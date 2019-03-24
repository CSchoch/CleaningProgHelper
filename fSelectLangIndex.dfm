object SelectLangIndex: TSelectLangIndex
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Sprachindex ausw'#228'hlen'
  ClientHeight = 353
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    377
    353)
  PixelsPerInch = 96
  TextHeight = 13
  object btOk: TButton
    Left = 106
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btOkClick
  end
  object btCancel: TButton
    Left = 189
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
  object vstLangIndex: TVirtualStringTree
    Left = 8
    Top = 8
    Width = 361
    Height = 306
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultNodeHeight = 24
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible, hoAutoSpring]
    TabOrder = 0
    TreeOptions.MiscOptions = [toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
    TreeOptions.SelectionOptions = [toExtendedFocus, toLevelSelectConstraint]
    OnBeforeCellPaint = vstLangIndexBeforeCellPaint
    OnCreateEditor = vstLangIndexCreateEditor
    OnEditing = vstLangIndexEditing
    OnFreeNode = vstLangIndexFreeNode
    OnGetText = vstLangIndexGetText
    OnMouseUp = vstLangIndexMouseUp
    Columns = <
      item
        Position = 0
        Width = 160
        WideText = 'K'#252'rzel'
      end
      item
        Position = 1
        Width = 197
        WideText = 'Index'
      end>
    WideDefaultText = ''
  end
end
