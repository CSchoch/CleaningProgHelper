object OptionsSelectForm: TOptionsSelectForm
  Left = 0
  Top = 0
  Caption = 'select location'
  ClientHeight = 257
  ClientWidth = 353
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  GlassFrame.Left = 16
  GlassFrame.Top = 35
  GlassFrame.Right = 16
  GlassFrame.Bottom = 60
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnMouseWheelDown = ScrollBox1MouseWheelDown
  OnMouseWheelUp = ScrollBox1MouseWheelUp
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 353
    Height = 257
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      353
      257)
    object Label2: TLabel
      Left = 8
      Top = 206
      Width = 337
      Height = 15
      Cursor = crHelp
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = False
      Caption = 'Label2'
      EllipsisPosition = epPathEllipsis
      ParentShowHint = False
      ShowHint = True
      ExplicitTop = 188
    end
    object Label3: TLabel
      Left = 8
      Top = 221
      Width = 266
      Height = 34
      Cursor = crHelp
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = False
      Caption = 'Label3'
      EllipsisPosition = epEndEllipsis
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
      ExplicitTop = 203
    end
    object Button1: TButton
      Left = 280
      Top = 221
      Width = 65
      Height = 28
      Anchors = [akRight, akBottom]
      Caption = 'ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = Button1Click
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 7
      Width = 337
      Height = 196
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      DesignSize = (
        337
        196)
      object Label1: TLabel
        Left = 7
        Top = 10
        Width = 323
        Height = 19
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'pleace select the location to save the program options:'
        EllipsisPosition = epEndEllipsis
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 307
      end
      object ScrollBox1: TScrollBox
        Left = 7
        Top = 29
        Width = 323
        Height = 159
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        OnMouseWheelDown = ScrollBox1MouseWheelDown
        OnMouseWheelUp = ScrollBox1MouseWheelUp
      end
    end
  end
end
