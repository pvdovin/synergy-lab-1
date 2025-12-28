unit WebModuleUnit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  Web.HTTPApp,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Stan.Intf,
  FireDAC.Phys,
  FireDAC.Phys.MSSQL,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Option,
  FireDAC.DApt;

type
  TWebModule1 = class(TWebModule)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    procedure WebModuleCreate(Sender: TObject);
    procedure ToursAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure OrdersListAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure OrdersCreateAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
  private
    function LoadConnectionString: string;
    procedure EnsureConnection;
  end;

implementation

{$R *.dfm}

function TWebModule1.LoadConnectionString: string;
var
  Ini: TIniFile;
  IniPath: string;
begin
  IniPath := IncludeTrailingPathDelimiter(ExtractFilePath(GetModuleName(HInstance))) + 'config.ini';
  Ini := TIniFile.Create(IniPath);
  try
    Result := Ini.ReadString('database', 'ConnectionString', '');
  finally
    Ini.Free;
  end;
end;

procedure TWebModule1.EnsureConnection;
begin
  if FDConnection1.Connected then
    Exit;

  FDConnection1.Params.Clear;
  FDConnection1.Params.Values['DriverID'] := 'MSSQL';
  FDConnection1.Params.Values['Server'] := '';
  FDConnection1.Params.Values['Database'] := '';
  FDConnection1.Params.Text := FDConnection1.Params.Text + sLineBreak + LoadConnectionString;
  FDConnection1.LoginPrompt := False;
  FDConnection1.Connected := True;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  FDConnection1.Connected := False;
end;

procedure TWebModule1.ToursAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
begin
  EnsureConnection;
  FDQuery1.Close;
  FDQuery1.SQL.Text := 'SELECT TourId, Name, Price FROM Tours ORDER BY Name';
  FDQuery1.Open;

  Response.ContentType := 'text/html; charset=utf-8';
  Response.Content := '<html><head><title>Туры</title></head><body>' +
    '<h1>Список туров</h1><table border="1" cellpadding="4" cellspacing="0">' +
    '<tr><th>ID</th><th>Название</th><th>Цена</th></tr>';

  while not FDQuery1.Eof do
  begin
    Response.Content := Response.Content +
      Format('<tr><td>%d</td><td>%s</td><td>%s</td></tr>', [
        FDQuery1.FieldByName('TourId').AsInteger,
        FDQuery1.FieldByName('Name').AsString,
        FDQuery1.FieldByName('Price').AsString
      ]);
    FDQuery1.Next;
  end;

  Response.Content := Response.Content + '</table></body></html>';
  Handled := True;
end;

procedure TWebModule1.OrdersListAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  EnsureConnection;
  FDQuery1.Close;
  FDQuery1.SQL.Text :=
    'SELECT o.OrderId, o.CustomerName, t.Name AS TourName, o.CreatedAt ' +
    'FROM Orders o ' +
    'JOIN Tours t ON t.TourId = o.TourId ' +
    'ORDER BY o.CreatedAt DESC';
  FDQuery1.Open;

  Response.ContentType := 'text/html; charset=utf-8';
  Response.Content := '<html><head><title>Заказы</title></head><body>' +
    '<h1>Список заказов</h1><table border="1" cellpadding="4" cellspacing="0">' +
    '<tr><th>ID</th><th>Клиент</th><th>Тур</th><th>Дата</th></tr>';

  while not FDQuery1.Eof do
  begin
    Response.Content := Response.Content +
      Format('<tr><td>%d</td><td>%s</td><td>%s</td><td>%s</td></tr>', [
        FDQuery1.FieldByName('OrderId').AsInteger,
        FDQuery1.FieldByName('CustomerName').AsString,
        FDQuery1.FieldByName('TourName').AsString,
        FDQuery1.FieldByName('CreatedAt').AsString
      ]);
    FDQuery1.Next;
  end;

  Response.Content := Response.Content + '</table></body></html>';
  Handled := True;
end;

procedure TWebModule1.OrdersCreateAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  TourId: Integer;
  CustomerName: string;
begin
  EnsureConnection;
  TourId := StrToIntDef(Request.ContentFields.Values['tour_id'], 0);
  CustomerName := Trim(Request.ContentFields.Values['customer_name']);

  if (TourId = 0) or CustomerName.IsEmpty then
  begin
    Response.ContentType := 'text/html; charset=utf-8';
    Response.Content := '<html><body><h1>Ошибка</h1><p>Нужно передать tour_id и customer_name.</p></body></html>';
    Handled := True;
    Exit;
  end;

  FDQuery1.Close;
  FDQuery1.SQL.Text := 'INSERT INTO Orders (TourId, CustomerName, CreatedAt) VALUES (:TourId, :CustomerName, GETDATE())';
  FDQuery1.ParamByName('TourId').AsInteger := TourId;
  FDQuery1.ParamByName('CustomerName').AsString := CustomerName;
  FDQuery1.ExecSQL;

  Response.ContentType := 'text/html; charset=utf-8';
  Response.Content := '<html><body><h1>Заказ создан</h1><p>Заказ успешно сохранен.</p></body></html>';
  Handled := True;
end;

end.
