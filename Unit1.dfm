object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'NEC --> Emerald System'
  ClientHeight = 556
  ClientWidth = 788
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 21
    Width = 95
    Height = 16
    Caption = 'Database Server'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 686
    Top = 333
    Width = 94
    Height = 13
    Alignment = taRightJustify
    Caption = '0 records remaining'
  end
  object mysqlserver: TEdit
    Left = 24
    Top = 40
    Width = 345
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 24
    Top = 104
    Width = 377
    Height = 225
    ScrollBars = ssBoth
    TabOrder = 1
    OnChange = Memo1Change
  end
  object Button1: TButton
    Left = 584
    Top = 352
    Width = 95
    Height = 25
    Caption = 'Start Billing'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 685
    Top = 352
    Width = 95
    Height = 25
    Caption = 'Stop Billing'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 70
    Width = 233
    Height = 21
    TabOrder = 4
    Text = '192.168.10.90'
  end
  object Edit2: TEdit
    Left = 288
    Top = 70
    Width = 81
    Height = 21
    TabOrder = 5
    Text = '8181'
  end
  object Button3: TButton
    Left = 24
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Connect'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 105
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 24
    Top = 383
    Width = 75
    Height = 25
    Caption = 'Start FO'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 245
    Top = 444
    Width = 75
    Height = 25
    Caption = 'CI 208'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    Visible = False
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 326
    Top = 444
    Width = 75
    Height = 25
    Caption = 'CO 208'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    Visible = False
    OnClick = Button7Click
  end
  object Edit3: TEdit
    Left = 245
    Top = 417
    Width = 156
    Height = 21
    TabOrder = 11
    Text = '8208'
    Visible = False
    OnChange = Edit3Change
  end
  object Button8: TButton
    Left = 24
    Top = 414
    Width = 75
    Height = 25
    Caption = 'ENQ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 105
    Top = 445
    Width = 75
    Height = 25
    Caption = 'areyuthere'
    TabOrder = 13
    OnClick = Button9Click
  end
  object Button14: TButton
    Left = 105
    Top = 415
    Width = 75
    Height = 25
    Caption = 'RQINZ'
    TabOrder = 14
    OnClick = Button14Click
  end
  object Button15: TButton
    Left = 326
    Top = 477
    Width = 75
    Height = 25
    Caption = 'RST'
    TabOrder = 15
    Visible = False
    OnClick = Button15Click
  end
  object Edit4: TEdit
    Left = 199
    Top = 479
    Width = 121
    Height = 21
    TabOrder = 16
    Text = '0'
    Visible = False
  end
  object Button10: TButton
    Left = 326
    Top = 508
    Width = 75
    Height = 25
    Caption = 'STS'
    TabOrder = 17
    Visible = False
    OnClick = Button10Click
  end
  object Edit5: TEdit
    Left = 199
    Top = 510
    Width = 121
    Height = 21
    TabOrder = 18
    Text = '0'
    Visible = False
  end
  object Button11: TButton
    Left = 24
    Top = 444
    Width = 75
    Height = 25
    Caption = 'SYNC'
    TabOrder = 19
    OnClick = Button11Click
  end
  object dep: TDateTimePicker
    Left = 443
    Top = 450
    Width = 186
    Height = 21
    Date = 42679.535522025460000000
    Time = 42679.535522025460000000
    TabOrder = 20
    Visible = False
  end
  object Button12: TButton
    Left = 24
    Top = 523
    Width = 75
    Height = 25
    Caption = 'Test CI'
    TabOrder = 21
    Visible = False
    OnClick = Button12Click
  end
  object Memo2: TMemo
    Left = 407
    Top = 104
    Width = 373
    Height = 223
    ScrollBars = ssBoth
    TabOrder = 22
    OnChange = Memo2Change
  end
  object Button13: TButton
    Left = 105
    Top = 383
    Width = 75
    Height = 25
    Caption = 'STOP FO'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 23
    OnClick = Button13Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 536
    Top = 352
  end
  object ZConnection1: TZConnection
    Protocol = 'mysql-5'
    Left = 200
    Top = 104
  end
  object ZConnection2: TZConnection
    Protocol = 'mysql-5'
    Left = 248
    Top = 104
  end
  object misc: TZQuery
    Connection = ZConnection2
    Params = <>
    Left = 168
    Top = 192
  end
  object que: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 216
    Top = 192
  end
  object ZQuery2: TZQuery
    Connection = ZConnection1
    Params = <>
    Left = 272
    Top = 200
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnecting = ClientSocket1Connecting
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    Left = 80
    Top = 120
  end
  object ClientSocket2: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocket2Connect
    OnDisconnect = ClientSocket2Disconnect
    OnRead = ClientSocket2Read
    OnWrite = ClientSocket2Write
    Left = 304
    Top = 272
  end
  object fo: TZQuery
    Connection = ZConnection2
    Params = <>
    Left = 232
    Top = 280
  end
  object rsv: TZQuery
    Connection = ZConnection2
    Params = <>
    Left = 176
    Top = 272
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer2Timer
    Left = 120
    Top = 488
  end
  object Timer3: TTimer
    Interval = 300000
    OnTimer = Timer3Timer
    Left = 568
    Top = 224
  end
end
