object EditMessages: TEditMessages
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Meldungen bearbeiten'
  ClientHeight = 451
  ClientWidth = 661
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    661
    451)
  PixelsPerInch = 96
  TextHeight = 13
  object vstMessages: TVirtualStringTree
    Left = 8
    Top = 8
    Width = 645
    Height = 404
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultNodeHeight = 24
    DragMode = dmAutomatic
    DragType = dtVCL
    EditDelay = 350
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = -1
    TabOrder = 0
    TreeOptions.MiscOptions = [toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
    TreeOptions.SelectionOptions = [toExtendedFocus, toLevelSelectConstraint]
    OnDragAllowed = vstMessagesDragAllowed
    OnDragOver = vstMessagesDragOver
    OnDragDrop = vstMessagesDragDrop
    OnEditing = vstMessagesEditing
    OnFreeNode = vstMessagesFreeNode
    OnGetText = vstMessagesGetText
    OnKeyUp = vstMessagesKeyUp
    OnNewText = vstMessagesNewText
    Columns = <>
  end
  object btOk: TButton
    Left = 248
    Top = 418
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 329
    Top = 418
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
end
