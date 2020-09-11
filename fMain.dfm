object MainForm: TMainForm
  Left = 88
  Top = 93
  Caption = 'Reinigungseditor'
  ClientHeight = 673
  ClientWidth = 919
  Color = clBtnFace
  Constraints.MinHeight = 330
  Constraints.MinWidth = 768
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMain
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  DesignSize = (
    919
    673)
  PixelsPerInch = 96
  TextHeight = 13
  object lLanguage: TLabel
    Left = 817
    Top = 8
    Width = 44
    Height = 21
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'Sprache:'
    FocusControl = seLanguage
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    ExplicitLeft = 650
  end
  object lProgram: TLabel
    Left = 8
    Top = 8
    Width = 44
    Height = 21
    AutoSize = False
    Caption = 'Program:'
    FocusControl = seProgramNumber
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Layout = tlCenter
  end
  object pcPages: TPageControl
    Left = 8
    Top = 32
    Width = 903
    Height = 632
    ActivePage = tsCrosses
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    HotTrack = True
    ParentFont = False
    TabOrder = 3
    OnChange = pcPagesChange
    OnChanging = pcPagesChanging
    object tsBasic: TTabSheet
      Caption = 'Grundbild'
      DesignSize = (
        895
        604)
      object iBasic: TImage
        Left = 3
        Top = 3
        Width = 889
        Height = 512
        Anchors = [akLeft, akTop, akRight, akBottom]
        Center = True
        Proportional = True
        Stretch = True
        ExplicitWidth = 722
        ExplicitHeight = 371
      end
      object Panel1: TPanel
        Left = 519
        Top = 521
        Width = 373
        Height = 80
        Anchors = [akLeft, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 6
        DesignSize = (
          373
          80)
        object pbParseProgress: TUbuntuProgress
          Left = 8
          Top = 29
          Width = 362
          Height = 19
          Anchors = [akLeft, akRight, akBottom]
          Max = 100.000000000000000000
          Speed = msSlow
          ExplicitWidth = 281
        end
      end
      object btBasicImport: TBitBtn
        Left = 3
        Top = 521
        Width = 80
        Height = 80
        Hint = 'Exportierte Dateien vom HMI'
        Anchors = [akLeft, akBottom]
        Caption = 'Import'
        DoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btBasicImportClick
      end
      object btBasicExport: TBitBtn
        Left = 89
        Top = 521
        Width = 80
        Height = 80
        Hint = 'Dateien f'#252'r den Import im HMI'
        Anchors = [akLeft, akBottom]
        Caption = 'Export'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btBasicExportClick
      end
      object btBasicImportPicture: TButton
        Left = 175
        Top = 521
        Width = 80
        Height = 80
        Hint = 'Screenshot f'#252'rs Grundbild'
        Anchors = [akLeft, akBottom]
        Caption = 'Bild Importieren'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        WordWrap = True
        OnClick = btBasicImportPictureClick
      end
      object btBasicLoad: TButton
        Left = 261
        Top = 521
        Width = 80
        Height = 80
        Hint = 'Eigenes Format (.xml)'
        Anchors = [akLeft, akBottom]
        Caption = 'Laden'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        WordWrap = True
        OnClick = btBasicLoadClick
      end
      object btBasicSave: TButton
        Left = 347
        Top = 521
        Width = 80
        Height = 80
        Hint = 'Eigenes Format (.xml)'
        Anchors = [akLeft, akBottom]
        Caption = 'Speichern'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        WordWrap = True
        OnClick = btBasicSaveClick
      end
      object btBasicLoadDesc: TButton
        Left = 433
        Top = 521
        Width = 80
        Height = 80
        Hint = 'Exportierte der Textlisten aus WinCC flexible'
        Anchors = [akLeft, akBottom]
        Caption = 'Beschreibung importieren'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        WordWrap = True
        OnClick = btBasicLoadDescClick
      end
    end
    object tsInputs: TTabSheet
      Caption = 'Eing'#228'nge'
      ImageIndex = 1
      DesignSize = (
        895
        604)
      object lStepInput: TLabel
        Left = 3
        Top = 3
        Width = 44
        Height = 21
        AutoSize = False
        Caption = 'Schritt:'
        FocusControl = eStepNameInput
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
      end
      object lStepMode: TLabel
        Left = 3
        Top = 551
        Width = 73
        Height = 21
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 'Schrittmodus:'
        FocusControl = cStepMode
        Layout = tlCenter
        ExplicitTop = 533
      end
      object lDuration: TLabel
        Left = 525
        Top = 551
        Width = 33
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 'Dauer:'
        FocusControl = seDuration
        Layout = tlCenter
        ExplicitLeft = 384
        ExplicitTop = 533
      end
      object lNextStep: TLabel
        Left = 644
        Top = 551
        Width = 58
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 'Folgeschritt:'
        FocusControl = seNextStep
        Layout = tlCenter
        ExplicitLeft = 503
        ExplicitTop = 533
      end
      object lDurationUnit: TLabel
        Left = 628
        Top = 551
        Width = 10
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 's'
        Layout = tlCenter
        ExplicitLeft = 487
        ExplicitTop = 533
      end
      object lLoops: TLabel
        Left = 781
        Top = 551
        Width = 47
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 'Schleifen:'
        FocusControl = seLoops
        Layout = tlCenter
        ExplicitLeft = 640
        ExplicitTop = 533
      end
      object lAlarmMode: TLabel
        Left = 3
        Top = 575
        Width = 110
        Height = 21
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = #220'berwachungsmodus:'
        FocusControl = cAlarmMode
        Layout = tlCenter
        ExplicitTop = 557
      end
      object lAlarmTime: TLabel
        Left = 525
        Top = 575
        Width = 92
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = #220'berwachungszeit:'
        Layout = tlCenter
        ExplicitLeft = 384
        ExplicitTop = 557
      end
      object lAlarmTimeUnit: TLabel
        Left = 687
        Top = 575
        Width = 10
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 's'
        Layout = tlCenter
        ExplicitLeft = 546
        ExplicitTop = 557
      end
      object lAlarmStep: TLabel
        Left = 767
        Top = 575
        Width = 61
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        BiDiMode = bdLeftToRight
        Caption = 'Alarmschritt:'
        FocusControl = seAlarmStep
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitLeft = 626
        ExplicitTop = 557
      end
      object eStepNameInput: TEdit
        Left = 103
        Top = 3
        Width = 789
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        TabOrder = 1
        OnChange = eStepNameChange
      end
      object seStepInput: TJvSpinEdit
        Left = 53
        Top = 3
        Width = 44
        Height = 21
        CheckMinValue = True
        CheckMaxValue = True
        Enabled = False
        TabOrder = 0
        OnChange = seStepChange
      end
      object vstInputs: TVirtualStringTree
        Left = 3
        Top = 27
        Width = 889
        Height = 410
        Anchors = [akLeft, akTop, akRight, akBottom]
        DefaultNodeHeight = 24
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible, hoAutoSpring]
        TabOrder = 2
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toExtendedFocus, toLevelSelectConstraint]
        OnBeforeCellPaint = vstInputsBeforeCellPaint
        OnEditing = vstInputsEditing
        OnFreeNode = vstInputsFreeNode
        OnGetText = vstInputsGetText
        OnKeyDown = vstInputsKeyDown
        OnMouseUp = vstInputsMouseUp
        OnNewText = vstInputsNewText
        Columns = <
          item
            Position = 0
            Width = 675
            WideText = 'Eingang'
          end
          item
            Alignment = taCenter
            Position = 1
            Width = 45
            WideText = 'Status'
          end
          item
            Alignment = taCenter
            Position = 2
            Width = 60
            WideText = 'Aktiv'
          end
          item
            Alignment = taCenter
            Position = 3
            Width = 45
            WideText = 'Status'
          end
          item
            Alignment = taCenter
            Position = 4
            Width = 60
            WideText = 'Aktiv'
          end>
      end
      object cStepMode: TComboBox
        Left = 119
        Top = 551
        Width = 233
        Height = 21
        Anchors = [akLeft, akBottom]
        TabOrder = 5
        Text = 'Eingangsbedingungen'
        OnChange = cStepModeChange
        Items.Strings = (
          'Eingangsbedingungen'
          'Zeit'
          'Eingangsbedingungen und Zeit'
          'Eingangsbedingungen oder Zeit'
          'Quittierung'
          'Ende Reinigung')
      end
      object seDuration: TJvSpinEdit
        Left = 564
        Top = 551
        Width = 58
        Height = 21
        CheckMinValue = True
        Decimal = 0
        Anchors = [akRight, akBottom]
        TabOrder = 6
        OnChange = seDurationChange
      end
      object seNextStep: TJvSpinEdit
        Left = 708
        Top = 551
        Width = 58
        Height = 21
        CheckMinValue = True
        Decimal = 0
        Anchors = [akRight, akBottom]
        TabOrder = 7
        OnChange = seNextStepChange
      end
      object seLoops: TJvSpinEdit
        Left = 834
        Top = 548
        Width = 58
        Height = 21
        CheckMinValue = True
        Decimal = 0
        Anchors = [akRight, akBottom]
        TabOrder = 4
        OnChange = seLoopsChange
      end
      object cAlarmMode: TComboBox
        Left = 119
        Top = 575
        Width = 233
        Height = 21
        Anchors = [akLeft, akBottom]
        TabOrder = 8
        Text = 'Aus'
        OnChange = cAlarmModeChange
        Items.Strings = (
          'Aus'
          'Abbruch'
          'N'#228'chster Schitt'
          'Alarmschritt'
          '')
      end
      object seAlarmTime: TJvSpinEdit
        Left = 623
        Top = 575
        Width = 58
        Height = 21
        CheckMinValue = True
        Decimal = 0
        Anchors = [akRight, akBottom]
        TabOrder = 9
        OnChange = seAlarmTimeChange
      end
      object seAlarmStep: TJvSpinEdit
        Left = 834
        Top = 575
        Width = 58
        Height = 21
        CheckMinValue = True
        Decimal = 0
        Anchors = [akRight, akBottom]
        TabOrder = 10
        OnChange = seAlarmStepChange
      end
      object vstAnalogInputs: TVirtualStringTree
        Left = 3
        Top = 443
        Width = 889
        Height = 102
        Anchors = [akLeft, akRight, akBottom]
        DefaultNodeHeight = 24
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible, hoAutoSpring]
        TabOrder = 3
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toExtendedFocus, toLevelSelectConstraint]
        OnCreateEditor = vstAnalogInputsCreateEditor
        OnEdited = vstAnalogInputsEdited
        OnEditing = vstAnalogInputsEditing
        OnFreeNode = vstAnalogInputsFreeNode
        OnGetText = vstAnalogInputsGetText
        OnKeyDown = vstAnalogInputsKeyDown
        OnMouseUp = vstAnalogInputsMouseUp
        Columns = <
          item
            Position = 0
            Width = 595
            WideText = 'Analogeingang'
          end
          item
            Alignment = taCenter
            Position = 1
            Width = 60
            WideText = 'Wert'
          end
          item
            Alignment = taCenter
            Position = 2
            Width = 85
            WideText = 'Modus'
          end
          item
            Alignment = taCenter
            Position = 3
            Width = 60
            WideText = 'Wert'
          end
          item
            Alignment = taCenter
            Position = 4
            Width = 85
            WideText = 'Modus'
          end>
      end
    end
    object tsOutputs: TTabSheet
      Caption = 'Ausg'#228'nge'
      ImageIndex = 2
      DesignSize = (
        895
        604)
      object lStepNameOutput: TLabel
        Left = 3
        Top = 3
        Width = 44
        Height = 21
        AutoSize = False
        Caption = 'Schritt:'
        FocusControl = seStepOutput
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
      end
      object lMessage: TLabel
        Left = 3
        Top = 554
        Width = 73
        Height = 21
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 'Meldausgabe:'
        FocusControl = cMessage
        Layout = tlCenter
        ExplicitTop = 437
      end
      object lIntervall1: TLabel
        Left = 3
        Top = 578
        Width = 73
        Height = 21
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 'Intervall1  Ein:'
        FocusControl = seIntervall1On
        Layout = tlCenter
        ExplicitTop = 461
      end
      object lIntervall1Off: TLabel
        Left = 191
        Top = 578
        Width = 26
        Height = 21
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 'Aus:'
        FocusControl = seIntervall1Off
        Layout = tlCenter
        ExplicitTop = 461
      end
      object lIntervall1OnUnit: TLabel
        Left = 146
        Top = 578
        Width = 10
        Height = 21
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 's'
        Layout = tlCenter
        ExplicitTop = 461
      end
      object lIntervall1OffUnit: TLabel
        Left = 287
        Top = 578
        Width = 10
        Height = 21
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = 's'
        Layout = tlCenter
        ExplicitTop = 461
      end
      object lIntervall2: TLabel
        Left = 534
        Top = 578
        Width = 73
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 'Intervall2  Ein:'
        FocusControl = seIntervall2On
        Layout = tlCenter
        ExplicitLeft = 367
        ExplicitTop = 461
      end
      object lIntervall2OnUnit: TLabel
        Left = 677
        Top = 578
        Width = 10
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 's'
        Layout = tlCenter
        ExplicitLeft = 510
        ExplicitTop = 461
      end
      object lIntervall2Off: TLabel
        Left = 722
        Top = 578
        Width = 26
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 'Aus:'
        FocusControl = seIntervall2Off
        Layout = tlCenter
        ExplicitLeft = 555
        ExplicitTop = 461
      end
      object lIntervall2OffUnit: TLabel
        Left = 818
        Top = 578
        Width = 10
        Height = 21
        Anchors = [akRight, akBottom]
        AutoSize = False
        Caption = 's'
        Layout = tlCenter
        ExplicitLeft = 651
        ExplicitTop = 461
      end
      object seStepOutput: TJvSpinEdit
        Left = 53
        Top = 3
        Width = 44
        Height = 21
        CheckMinValue = True
        CheckMaxValue = True
        Enabled = False
        TabOrder = 0
        OnChange = seStepChange
      end
      object eStepNameOutput: TEdit
        Left = 103
        Top = 3
        Width = 789
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        TabOrder = 1
        OnChange = eStepNameChange
      end
      object vstOutputs: TVirtualStringTree
        Left = 3
        Top = 27
        Width = 889
        Height = 410
        Anchors = [akLeft, akTop, akRight, akBottom]
        DefaultNodeHeight = 24
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible, hoAutoSpring]
        TabOrder = 2
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toExtendedFocus, toLevelSelectConstraint]
        OnBeforeCellPaint = vstOutputsBeforeCellPaint
        OnCreateEditor = vstOutputsCreateEditor
        OnEdited = vstOutputsEdited
        OnEditing = vstOutputsEditing
        OnFreeNode = vstOutputsFreeNode
        OnGetText = vstOutputsGetText
        OnKeyDown = vstOutputsKeyDown
        OnMouseUp = vstOutputsMouseUp
        Columns = <
          item
            Position = 0
            Width = 745
            WideText = 'Ausgang'
          end
          item
            Alignment = taCenter
            Position = 1
            Width = 140
            WideText = 'Status'
          end>
      end
      object cMessage: TComboBox
        Left = 82
        Top = 551
        Width = 810
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        PopupMenu = pmMessage
        TabOrder = 4
        OnChange = cMessageChange
        OnKeyDown = cMessageKeyDown
      end
      object seIntervall1On: TJvSpinEdit
        Left = 82
        Top = 578
        Width = 58
        Height = 21
        CheckMinValue = True
        Decimal = 1
        Anchors = [akLeft, akBottom]
        TabOrder = 5
        OnChange = seIntervall1OnChange
      end
      object seIntervall1Off: TJvSpinEdit
        Left = 223
        Top = 578
        Width = 58
        Height = 21
        CheckMinValue = True
        Decimal = 1
        Anchors = [akLeft, akBottom]
        TabOrder = 6
        OnChange = seIntervall1OffChange
      end
      object seIntervall2On: TJvSpinEdit
        Left = 613
        Top = 578
        Width = 58
        Height = 21
        CheckMinValue = True
        Decimal = 1
        Anchors = [akRight, akBottom]
        TabOrder = 7
        OnChange = seIntervall2OnChange
      end
      object seIntervall2Off: TJvSpinEdit
        Left = 754
        Top = 578
        Width = 58
        Height = 21
        CheckMinValue = True
        Decimal = 1
        Anchors = [akRight, akBottom]
        TabOrder = 8
        OnChange = seIntervall2OffChange
      end
      object vstAnalogOutputs: TVirtualStringTree
        Left = 3
        Top = 443
        Width = 889
        Height = 102
        Anchors = [akLeft, akRight, akBottom]
        DefaultNodeHeight = 24
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible, hoAutoSpring]
        TabOrder = 3
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toExtendedFocus, toLevelSelectConstraint]
        OnCreateEditor = vstAnalogOutputsCreateEditor
        OnEdited = vstAnalogOutputsEdited
        OnEditing = vstAnalogOutputsEditing
        OnFreeNode = vstAnalogOutputsFreeNode
        OnGetText = vstAnalogOutputsGetText
        OnKeyDown = vstAnalogOutputsKeyDown
        OnMouseUp = vstAnalogOutputsMouseUp
        Columns = <
          item
            Position = 0
            Width = 750
            WideText = 'Analogausgang'
          end
          item
            Alignment = taCenter
            Position = 1
            Width = 85
            WideText = 'Wert'
          end
          item
            Alignment = taCenter
            Position = 2
            WideText = 'Einheit'
          end>
      end
    end
    object tsCrosses: TTabSheet
      Caption = 'Kreuzchen'
      ImageIndex = 3
      OnShow = tsCrossesShow
      DesignSize = (
        895
        604)
      object vstCrosses: TVirtualStringTree
        Left = 3
        Top = 3
        Width = 889
        Height = 512
        Anchors = [akLeft, akTop, akRight, akBottom]
        Header.AutoSizeIndex = -1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -16
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Height = 25
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag, hoOwnerDraw, hoVisible, hoHeightResize]
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toLevelSelectConstraint]
        OnAdvancedHeaderDraw = vstCrossesAdvancedHeaderDraw
        OnBeforeCellPaint = vstCrossesBeforeCellPaint
        OnFreeNode = vstCrossesFreeNode
        OnGetText = vstCrossesGetText
        OnHeaderDrawQueryElements = vstCrossesHeaderDrawQueryElements
        Columns = <>
        WideDefaultText = ''
      end
      object btPrintGrid: TButton
        Left = 3
        Top = 521
        Width = 80
        Height = 80
        Anchors = [akLeft, akBottom]
        Caption = 'Drucken'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btPrintGridClick
      end
      object btExportGrid: TButton
        Left = 89
        Top = 521
        Width = 80
        Height = 80
        Hint = 'In Excel (.csv)'
        Anchors = [akLeft, akBottom]
        Caption = 'Exportieren'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btExportGridClick
      end
      object gbCrossesLegend: TGroupBox
        Left = 175
        Top = 521
        Width = 717
        Height = 80
        Anchors = [akLeft, akRight, akBottom]
        Caption = ' Legende '
        TabOrder = 3
        object lLegend1: TLabel
          Left = 11
          Top = 19
          Width = 241
          Height = 13
          Caption = 'Eing'#228'nge: Schritt/Alternativschritt; Leer = Inaktiv '
        end
        object lLegend2: TLabel
          Left = 11
          Top = 35
          Width = 515
          Height = 13
          Caption = 
            'Analoge Eing'#228'nge: Schritt/Alternativschritt, >/<"Wert" = Verglei' +
            'ch auf gr'#246#223'er/kleiner Wert;  Leer = Inaktiv'
        end
        object lLegend3: TLabel
          Left = 11
          Top = 51
          Width = 126
          Height = 13
          Caption = 'Ausg'#228'nge: Leer = Inaktiv '
        end
      end
    end
    object tsDiagram: TTabSheet
      Caption = 'Diagramm'
      ImageIndex = 4
      OnShow = tsDiagramShow
      DesignSize = (
        895
        604)
      object sbDiagram: TScrollBox
        Left = 3
        Top = 3
        Width = 889
        Height = 598
        HorzScrollBar.Size = 10
        VertScrollBar.Increment = 40
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        DesignSize = (
          868
          594)
        object iDiagram: TImage
          Left = 3
          Top = 3
          Width = 778
          Height = 6033
          Anchors = [akLeft, akTop, akRight]
          AutoSize = True
          IncrementalDisplay = True
          ExplicitWidth = 695
        end
      end
    end
  end
  object seProgramNumber: TJvSpinEdit
    Left = 58
    Top = 8
    Width = 44
    Height = 21
    MinValue = 1.000000000000000000
    Value = 1.000000000000000000
    Enabled = False
    TabOrder = 0
    OnChange = seProgramNumberChange
  end
  object seLanguage: TJvSpinEdit
    Left = 867
    Top = 8
    Width = 44
    Height = 21
    MinValue = 1.000000000000000000
    Anchors = [akTop, akRight]
    TabOrder = 2
    OnChange = seLanguageChange
  end
  object eProgName: TEdit
    Left = 108
    Top = 8
    Width = 703
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    TabOrder = 1
    OnChange = eProgNameChange
  end
  object taMain: TActionList
    Images = imlActions
    Left = 88
    Top = 96
    object acRight: TAction
      OnExecute = acRightExecute
    end
    object acLeft: TAction
      OnExecute = acLeftExecute
    end
  end
  object odBasicPicture: TOpenPictureDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Bild ausw'#228'hlen'
    Left = 120
    Top = 96
  end
  object imlActions: TImageList
    Left = 152
    Top = 96
  end
  object odBasicCsv: TJvOpenDialog
    Filter = 'Exportdateien(*.csv)|*.csv'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    ActiveControl = acListView
    Height = 458
    Width = 571
    Left = 184
    Top = 96
  end
  object bffBasicSaveCsv: TJvBrowseForFolderDialog
    Options = [odOnlyDirectory, odFileSystemDirectoryOnly, odStatusAvailable, odEditBox, odNewDialogStyle]
    Left = 216
    Top = 96
  end
  object XPManifest1: TXPManifest
    Left = 48
    Top = 96
  end
  object odBasicXML: TJvOpenDialog
    Filter = 'XML Dateien(*.xml)|*.xml'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    ActiveControl = acListView
    Height = 458
    Width = 571
    Left = 280
    Top = 96
  end
  object mmMain: TMainMenu
    Left = 312
    Top = 96
    object meEdit: TMenuItem
      Caption = 'Bearbeiten'
      object meCopy: TMenuItem
        Caption = 'Kopieren'
        Enabled = False
        ShortCut = 16451
        OnClick = meCopyClick
      end
      object meInsert: TMenuItem
        Caption = 'Einf'#252'gen'
        Enabled = False
        ShortCut = 16470
        OnClick = meInsertClick
      end
      object meCut: TMenuItem
        Caption = 'Ausschneiden'
        Enabled = False
        ShortCut = 16472
        OnClick = meCutClick
      end
      object meDuplicate: TMenuItem
        Caption = 'Duplizieren'
        Enabled = False
        ShortCut = 16452
        OnClick = meDuplicateClick
      end
      object meEditDescription: TMenuItem
        AutoCheck = True
        Caption = 'Beschreibungen editieren'
        Enabled = False
        OnClick = meEditDescriptionClick
      end
      object meCopyProgram: TMenuItem
        Caption = 'Program kopieren'
        Enabled = False
        OnClick = meCopyProgramClick
      end
    end
    object meInfo: TMenuItem
      Caption = 'Info'
      object meAbout: TMenuItem
        Caption = #220'ber'
        OnClick = meAboutClick
      end
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 344
    Top = 96
  end
  object pmMessage: TPopupMenu
    Left = 376
    Top = 96
    object meEditMessages: TMenuItem
      Caption = 'Bearbeiten'
      OnClick = meEditMessagesClick
    end
  end
  object MadExceptionHandler1: TMadExceptionHandler
    Left = 440
    Top = 96
  end
  object sdCrossesExport: TFileSaveDialog
    DefaultExtension = '.csv'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'csv Dateien (*.csv)'
        FileMask = '*.csv'
      end>
    Options = [fdoOverWritePrompt]
    Left = 408
    Top = 96
  end
  object sdBasicXML: TFileSaveDialog
    DefaultExtension = '.xml'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'XML Dateien (*.xml)'
        FileMask = '*.xml'
      end>
    Options = [fdoOverWritePrompt]
    Left = 248
    Top = 96
  end
end
