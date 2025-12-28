object WebModule1: TWebModule1
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Name = 'ToursAction'
      PathInfo = '/tours'
      MethodType = mtGet
      OnAction = ToursAction
    end
    item
      Name = 'OrdersListAction'
      PathInfo = '/orders'
      MethodType = mtGet
      OnAction = OrdersListAction
    end
    item
      Name = 'OrdersCreateAction'
      PathInfo = '/orders/create'
      MethodType = mtPost
      OnAction = OrdersCreateAction
    end>
  Height = 230
  Width = 415
  object FDConnection1: TFDConnection
    Left = 48
    Top = 40
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 144
    Top = 40
  end
end
