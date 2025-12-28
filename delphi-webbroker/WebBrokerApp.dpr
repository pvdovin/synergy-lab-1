library WebBrokerApp;

uses
  Web.WebBroker,
  Web.HTTPApp,
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule};

{$R *.res}

begin
  Application.Initialize;
  Application.WebModuleClass := WebModule1;
  Application.Run;
end.
