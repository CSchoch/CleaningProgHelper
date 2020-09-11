object SelectTarget: TSelectTarget
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Ziel w'#228'hlen'
  ClientHeight = 63
  ClientWidth = 172
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lProgram: TLabel
    Left = 8
    Top = 2
    Width = 44
    Height = 21
    AutoSize = False
    Caption = 'Program:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Layout = tlCenter
  end
  object seProgramNumber: TJvSpinEdit
    Left = 58
    Top = 3
    Width = 106
    Height = 21
    MinValue = 1.000000000000000000
    TabOrder = 0
  end
  object btOk: TButton
    Left = 8
    Top = 30
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 89
    Top = 30
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
end
