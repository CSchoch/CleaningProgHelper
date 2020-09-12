unit fMain;
{ TODO : Modus Programmnamen verbessern (wenn mit unterschiedlichen modi importiert und exportiert wird stimmt die Ausgabedatei nicht) }
{ TODO : Sprachindexauswahl optimieren, damit kein falscher Index eingegeben werden kann }
{ TODO : Listentypen als Klasse }
{ TODO : Diagram exportieren }
{$I Compilerswitches.inc}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  JvExComCtrls,
  JvComCtrls,
  ComCtrls,
  XPMan,
  XPStyleActnCtrls,
  ActnList,
  ExtCtrls,
  ExtDlgs,
  ImgList,
  uCleanProg,
  uCleanProg.Parser,
  uCleanProg.Settings,
  JvDialogs,
  Menus,
  JvBaseDlg,
  JvBrowseFolder,
  VirtualTrees,
  Mask,
  JvExMask,
  JvSpin,
  UbuntuProgress,
  csUtils,
  JvToolEdit,
  VTreeHelper,
  VPropertyTreeEditors,
  Printers,
  fSelectTarget,
  fEditMessages,
  fSelectLangIndex,
  fAbout,
  JvComponentBase,
  JvgExportComponents,
  Generics.Collections,
  himXML,
  madExceptVcl,
  jpeg,
  pngimage;

type
  TMainForm = class(TForm)
    pcPages : TPageControl;
    tsBasic : TTabSheet;
    tsInputs : TTabSheet;
    tsOutputs : TTabSheet;
    taMain : TActionList;
    btBasicImport : TBitBtn;
    btBasicExport : TBitBtn;
    btBasicImportPicture : TButton;
    btBasicLoad : TButton;
    btBasicSave : TButton;
    iBasic : TImage;
    odBasicPicture : TOpenPictureDialog;
    acRight : TAction;
    acLeft : TAction;
    imlActions : TImageList;
    odBasicCsv : TJvOpenDialog;
    bffBasicSaveCsv : TJvBrowseForFolderDialog;
    XPManifest1 : TXPManifest;
    lProgram : TLabel;
    seBlockNumber : TJvSpinEdit;
    eProgName : TEdit;
    lStepInput : TLabel;
    eStepNameInput : TEdit;
    seStepInput : TJvSpinEdit;
    lStepNameOutput : TLabel;
    seStepOutput : TJvSpinEdit;
    eStepNameOutput : TEdit;
    lLanguage : TLabel;
    seLanguage : TJvSpinEdit;
    vstInputs : TVirtualStringTree;
    odBasicXML : TJvOpenDialog;
    vstOutputs : TVirtualStringTree;
    lStepMode : TLabel;
    cStepMode : TComboBox;
    lDuration : TLabel;
    seDuration : TJvSpinEdit;
    lNextStep : TLabel;
    seNextStep : TJvSpinEdit;
    lDurationUnit : TLabel;
    lLoops : TLabel;
    seLoops : TJvSpinEdit;
    lAlarmMode : TLabel;
    cAlarmMode : TComboBox;
    lAlarmTime : TLabel;
    seAlarmTime : TJvSpinEdit;
    lAlarmTimeUnit : TLabel;
    lAlarmStep : TLabel;
    seAlarmStep : TJvSpinEdit;
    lMessage : TLabel;
    cMessage : TComboBox;
    lIntervall1 : TLabel;
    seIntervall1On : TJvSpinEdit;
    lIntervall1Off : TLabel;
    seIntervall1Off : TJvSpinEdit;
    lIntervall1OnUnit : TLabel;
    lIntervall1OffUnit : TLabel;
    lIntervall2 : TLabel;
    seIntervall2On : TJvSpinEdit;
    lIntervall2OnUnit : TLabel;
    lIntervall2Off : TLabel;
    seIntervall2Off : TJvSpinEdit;
    lIntervall2OffUnit : TLabel;
    mmMain : TMainMenu;
    meEdit : TMenuItem;
    meCopy : TMenuItem;
    meInsert : TMenuItem;
    meCut : TMenuItem;
    meDuplicate : TMenuItem;
    tsCrosses : TTabSheet;
    PrintDialog1 : TPrintDialog;
    vstCrosses : TVirtualStringTree;
    btPrintGrid : TButton;
    meEditDescription : TMenuItem;
    meCopyProgram : TMenuItem;
    pmMessage : TPopupMenu;
    meEditMessages : TMenuItem;
    btExportGrid : TButton;
    gbCrossesLegend : TGroupBox;
    lLegend1 : TLabel;
    lLegend2 : TLabel;
    lLegend3 : TLabel;
    btBasicLoadDesc : TButton;
    meInfo : TMenuItem;
    meAbout : TMenuItem;
    vstAnalogInputs : TVirtualStringTree;
    vstAnalogOutputs : TVirtualStringTree;
    MadExceptionHandler1 : TMadExceptionHandler;
    sdCrossesExport : TFileSaveDialog;
    sdBasicXML : TFileSaveDialog;
    tsDiagram : TTabSheet;
    sbDiagram : TScrollBox;
    iDiagram : TImage;
    lStepModeAlternate : TLabel;
    cStepModeAlternate : TComboBox;
    lNextAlternatStep : TLabel;
    seNextAlternateStep : TJvSpinEdit;
    procedure FormCreate(Sender : TObject);
    procedure btBasicImportPictureClick(Sender : TObject);
    procedure acRightExecute(Sender : TObject);
    procedure acLeftExecute(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure OnSelectLangIndex(Sender : TObject; LangDesc : TStringList; out Indizes : TList<Integer>);
    procedure btBasicImportClick(Sender : TObject);
    procedure btBasicExportClick(Sender : TObject);
    procedure seBlockNumberChange(Sender : TObject);
    procedure eProgNameChange(Sender : TObject);
    procedure seStepChange(Sender : TObject);
    procedure eStepNameChange(Sender : TObject);
    procedure seLanguageChange(Sender : TObject);
    procedure vstInputsMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure vstInputsEditing(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      var Allowed : Boolean);
    procedure vstInputsGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      TextType : TVSTTextType; var CellText : String);
    procedure vstInputsFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
    procedure vstInputsNewText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex; NewText : String);
    procedure vstInputsBeforeCellPaint(Sender : TBaseVirtualTree; TargetCanvas : TCanvas; Node : PVirtualNode;
      Column : TColumnIndex; CellPaintMode : TVTCellPaintMode; CellRect : TRect; var ContentRect : TRect);
    procedure vstInputsKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure btBasicSaveClick(Sender : TObject);
    procedure btBasicLoadClick(Sender : TObject);
    procedure vstOutputsEditing(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      var Allowed : Boolean);
    procedure vstOutputsKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure vstOutputsMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure vstOutputsFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
    procedure vstOutputsGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      TextType : TVSTTextType; var CellText : String);
    procedure vstOutputsBeforeCellPaint(Sender : TBaseVirtualTree; TargetCanvas : TCanvas; Node : PVirtualNode;
      Column : TColumnIndex; CellPaintMode : TVTCellPaintMode; CellRect : TRect; var ContentRect : TRect);
    procedure vstOutputsCreateEditor(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      out EditLink : IVTEditLink);
    procedure vstOutputsEdited(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex);
    procedure cStepModeChange(Sender : TObject);
    procedure cAlarmModeChange(Sender : TObject);
    procedure seDurationChange(Sender : TObject);
    procedure seNextStepChange(Sender : TObject);
    procedure seLoopsChange(Sender : TObject);
    procedure seAlarmTimeChange(Sender : TObject);
    procedure seAlarmStepChange(Sender : TObject);
    procedure cMessageChange(Sender : TObject);
    procedure cMessageKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure seIntervall1OnChange(Sender : TObject);
    procedure seIntervall1OffChange(Sender : TObject);
    procedure seIntervall2OnChange(Sender : TObject);
    procedure seIntervall2OffChange(Sender : TObject);
    procedure pcPagesChanging(Sender : TObject; var AllowChange : Boolean);
    procedure meCopyClick(Sender : TObject);
    procedure meInsertClick(Sender : TObject);
    procedure meDuplicateClick(Sender : TObject);
    procedure meCutClick(Sender : TObject);
    procedure btGenerateGridClick(Sender : TObject);
    procedure vstCrossesHeaderDrawQueryElements(Sender : TVTHeader; var PaintInfo : THeaderPaintInfo;
      var Elements : THeaderPaintElements);
    procedure vstCrossesAdvancedHeaderDraw(Sender : TVTHeader; var PaintInfo : THeaderPaintInfo;
      const Elements : THeaderPaintElements);
    procedure vstCrossesFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
    procedure btPrintGridClick(Sender : TObject);
    procedure vstCrossesGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      TextType : TVSTTextType; var CellText : string);
    procedure meEditDescriptionClick(Sender : TObject);
    procedure meCopyProgramClick(Sender : TObject);
    procedure meEditMessagesClick(Sender : TObject);
    procedure btExportGridClick(Sender : TObject);
    procedure btBasicLoadDescClick(Sender : TObject);
    procedure meAboutClick(Sender : TObject);
    procedure vstAnalogInputsEditing(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      var Allowed : Boolean);
    procedure vstAnalogInputsFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
    procedure vstAnalogInputsGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      TextType : TVSTTextType; var CellText : string);
    procedure vstAnalogInputsKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure vstAnalogInputsMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure vstAnalogInputsCreateEditor(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      out EditLink : IVTEditLink);
    procedure vstAnalogOutputsCreateEditor(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      out EditLink : IVTEditLink);
    procedure vstAnalogInputsEdited(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex);
    procedure vstAnalogOutputsEdited(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex);
    procedure vstAnalogOutputsEditing(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      var Allowed : Boolean);
    procedure vstAnalogOutputsFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
    procedure vstAnalogOutputsGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
      TextType : TVSTTextType; var CellText : string);
    procedure vstAnalogOutputsKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure vstAnalogOutputsMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure tsCrossesShow(Sender : TObject);
    procedure tsDiagramShow(Sender : TObject);
    procedure FormMouseWheel(Sender : TObject; Shift : TShiftState; WheelDelta : Integer; MousePos : TPoint;
      var Handled : Boolean);
    procedure pcPagesChange(Sender : TObject);
    procedure vstCrossesBeforeCellPaint(Sender : TBaseVirtualTree; TargetCanvas : TCanvas; Node : PVirtualNode;
      Column : TColumnIndex; CellPaintMode : TVTCellPaintMode; CellRect : TRect; var ContentRect : TRect);

  private
    Parser : TCleanProgParser;
    // Visio : TCanvas;
    procedure ChangeStep(index : Integer);
    function GetTextFromCrossesData(Data : TCrossesData; Column : Integer) : String;
    procedure GenerateGrid;
    procedure GenerateDiagram;
  public
    { Public-Deklarationen }
  end;

var
  MainForm : TMainForm;

implementation

uses
  Types,
  Math;

{$R *.dfm}

function TextOutAngle(const Canvas : TCanvas; X, Y : Integer; const AText : string; AAngle : Integer) : Integer;
var
  hCurFont : TFont;
  LogFont : TLogFont;
begin
  with Canvas do
  begin
    hCurFont := Font;
    try
      Brush.Style := bsClear;
      GetObject(Font.Handle, SizeOf(LogFont), @LogFont);
      LogFont.lfEscapement := AAngle;
      LogFont.lfOrientation := AAngle;
      Font.Handle := CreateFontIndirect(LogFont);
      Result := TextWidth(AText);
      TextOut(X, Y, AText);
    finally
      Font := hCurFont;
    end;
  end;
end;

procedure TMainForm.acLeftExecute(Sender : TObject);
begin
  pcPages.ActivePageIndex := pcPages.ActivePageIndex - 1;
  if pcPages.ActivePageIndex < 0 then
  begin
    pcPages.ActivePageIndex := 0;
  end;
end;

procedure TMainForm.acRightExecute(Sender : TObject);
begin
  pcPages.ActivePageIndex := pcPages.ActivePageIndex + 1 mod pcPages.PageCount;
end;

procedure TMainForm.btBasicExportClick(Sender : TObject);
begin
  btBasicImport.Enabled := False;
  btBasicExport.Enabled := False;
  btBasicLoad.Enabled := False;
  btBasicSave.Enabled := False;
  seBlockNumber.Enabled := False;
  eProgName.Enabled := False;
  seStepInput.Enabled := False;
  eStepNameInput.Enabled := False;
  seStepOutput.Enabled := False;
  eStepNameOutput.Enabled := False;
  meCopyProgram.Enabled := False;
  meCopy.Enabled := False;
  meCut.Enabled := False;
  meDuplicate.Enabled := False;
  meEditDescription.Enabled := False;
  try
    if bffBasicSaveCsv.Execute and (bffBasicSaveCsv.Directory <> '') then
    begin
      CreateDirectoryRecurse('', ExtractFilePath(bffBasicSaveCsv.Directory), nil);
      Parser.SaveFiles(IncludeTrailingPathDelimiter(bffBasicSaveCsv.Directory));
    end;
  finally
    btBasicImport.Enabled := True;
    btBasicExport.Enabled := True;
    btBasicLoad.Enabled := True;
    btBasicSave.Enabled := True;
    seBlockNumber.Enabled := True;
    eProgName.Enabled := True;
    seStepInput.Enabled := True;
    eStepNameInput.Enabled := True;
    seStepOutput.Enabled := True;
    eStepNameOutput.Enabled := True;
    meCopyProgram.Enabled := True;
    meCopy.Enabled := True;
    meCut.Enabled := True;
    meDuplicate.Enabled := True;
    meEditDescription.Enabled := True;
  end;
end;

procedure TMainForm.btBasicImportClick(Sender : TObject);
var
  Desc : TDescription;
begin
  btBasicImport.Enabled := False;
  btBasicExport.Enabled := False;
  btBasicLoad.Enabled := False;
  btBasicSave.Enabled := False;
  btBasicLoadDesc.Enabled := False;
  seBlockNumber.Enabled := False;
  eProgName.Enabled := False;
  seStepInput.Enabled := False;
  eStepNameInput.Enabled := False;
  seStepOutput.Enabled := False;
  eStepNameOutput.Enabled := False;
  meCopyProgram.Enabled := False;
  meCopy.Enabled := False;
  meCut.Enabled := False;
  meDuplicate.Enabled := False;
  meEditDescription.Enabled := False;
  try
    if odBasicCsv.Execute and (odBasicCsv.FileName <> '') then
    begin
      Parser.LoadFiles(odBasicCsv.Files);
    end;
  finally
    if Parser.Settings.NumOfBlocks > 0 then
    begin
      seBlockNumber.MaxValue := Parser.Settings.NumOfBlocks;
      Parser.Language := seLanguage.AsInteger;
      Parser.SelectedBlock := seBlockNumber.AsInteger;
      eProgName.Text := Parser.BlockName;
      Desc := Parser.Description;
      cMessage.Items.Clear;
      cMessage.Items.AddStrings(Desc.Message);
      ChangeStep(seStepInput.AsInteger);
      seBlockNumber.Enabled := True;
      eProgName.Enabled := True;
      btBasicExport.Enabled := True;
      btBasicSave.Enabled := True;
      btBasicLoadDesc.Enabled := True;
      seStepInput.Enabled := True;
      eStepNameInput.Enabled := True;
      seStepOutput.Enabled := True;
      eStepNameOutput.Enabled := True;
      meCopyProgram.Enabled := True;
      meCopy.Enabled := True;
      meCut.Enabled := True;
      meDuplicate.Enabled := True;
      meEditDescription.Enabled := True;
      pcPages.Pages[1].TabVisible := True;
      pcPages.Pages[2].TabVisible := True;
      pcPages.Pages[3].TabVisible := True;
      pcPages.Pages[4].TabVisible := True;
    end;
    btBasicImport.Enabled := True;
    btBasicLoad.Enabled := True;
  end;
end;

procedure TMainForm.btBasicImportPictureClick(Sender : TObject);
begin
  if odBasicPicture.Execute then
  begin
    iBasic.Picture.LoadFromFile(odBasicPicture.FileName);
    Parser.PictureExtension := ExtractFileExt(odBasicPicture.FileName);
  end;
end;

procedure TMainForm.btBasicLoadClick(Sender : TObject);
var
  Desc : TDescription;
begin
  btBasicImport.Enabled := False;
  btBasicExport.Enabled := False;
  btBasicLoad.Enabled := False;
  btBasicSave.Enabled := False;
  btBasicLoadDesc.Enabled := False;
  seBlockNumber.Enabled := False;
  eProgName.Enabled := False;
  seStepInput.Enabled := False;
  eStepNameInput.Enabled := False;
  seStepOutput.Enabled := False;
  eStepNameOutput.Enabled := False;
  meCopyProgram.Enabled := False;
  meCopy.Enabled := False;
  meCut.Enabled := False;
  meDuplicate.Enabled := False;
  meEditDescription.Enabled := False;
  try
    if odBasicXML.Execute and (odBasicXML.FileName <> '') then
    begin
      Parser.LoadFromXML(odBasicXML.FileName);
    end;
  finally
    if Parser.Settings.NumOfBlocks > 0 then
    begin
      seBlockNumber.MaxValue := Parser.Settings.NumOfBlocks;
      seLanguage.AsInteger := Parser.Language;
      seBlockNumber.AsInteger := Parser.SelectedBlock;
      eProgName.Text := Parser.BlockName;
      Desc := Parser.Description;
      cMessage.Items.Clear;
      cMessage.Items.AddStrings(Desc.Message);
      ChangeStep(seStepInput.AsInteger);
      seBlockNumber.Enabled := True;
      eProgName.Enabled := True;
      btBasicExport.Enabled := True;
      btBasicSave.Enabled := True;
      btBasicLoadDesc.Enabled := True;
      seStepInput.Enabled := True;
      eStepNameInput.Enabled := True;
      seStepOutput.Enabled := True;
      eStepNameOutput.Enabled := True;
      meCopyProgram.Enabled := True;
      meCopy.Enabled := True;
      meCut.Enabled := True;
      meDuplicate.Enabled := True;
      meEditDescription.Enabled := True;
      pcPages.Pages[1].TabVisible := True;
      pcPages.Pages[2].TabVisible := True;
      pcPages.Pages[3].TabVisible := True;
      pcPages.Pages[4].TabVisible := True;
    end;
    btBasicImport.Enabled := True;
    btBasicLoad.Enabled := True;
  end;
end;

procedure TMainForm.btBasicLoadDescClick(Sender : TObject);
var
  Desc : TDescription;
begin
  btBasicImport.Enabled := False;
  btBasicExport.Enabled := False;
  btBasicLoad.Enabled := False;
  btBasicSave.Enabled := False;
  btBasicLoadDesc.Enabled := False;
  seBlockNumber.Enabled := False;
  eProgName.Enabled := False;
  seStepInput.Enabled := False;
  eStepNameInput.Enabled := False;
  seStepOutput.Enabled := False;
  eStepNameOutput.Enabled := False;
  meCopyProgram.Enabled := False;
  meCopy.Enabled := False;
  meCut.Enabled := False;
  meDuplicate.Enabled := False;
  meEditDescription.Enabled := False;
  try
    if odBasicCsv.Execute and (odBasicCsv.FileName <> '') then
    begin
      Parser.LoadDescription(odBasicCsv.FileName);
    end;
  finally
    if Parser.Settings.NumOfBlocks > 0 then
    begin
      Desc := Parser.Description;
      cMessage.Items.Clear;
      cMessage.Items.AddStrings(Desc.Message);
      ChangeStep(seStepInput.AsInteger);
      seBlockNumber.Enabled := True;
      eProgName.Enabled := True;
      btBasicExport.Enabled := True;
      btBasicSave.Enabled := True;
      btBasicLoadDesc.Enabled := True;
      seStepInput.Enabled := True;
      eStepNameInput.Enabled := True;
      seStepOutput.Enabled := True;
      eStepNameOutput.Enabled := True;
      meCopyProgram.Enabled := True;
      meCopy.Enabled := True;
      meCut.Enabled := True;
      meDuplicate.Enabled := True;
      meEditDescription.Enabled := True;
    end;
    btBasicImport.Enabled := True;
    btBasicLoad.Enabled := True;
  end;
end;

procedure TMainForm.btBasicSaveClick(Sender : TObject);
begin
  btBasicImport.Enabled := False;
  btBasicExport.Enabled := False;
  btBasicLoad.Enabled := False;
  btBasicSave.Enabled := False;
  btBasicLoadDesc.Enabled := False;
  seBlockNumber.Enabled := False;
  eProgName.Enabled := False;
  seStepInput.Enabled := False;
  eStepNameInput.Enabled := False;
  seStepOutput.Enabled := False;
  eStepNameOutput.Enabled := False;
  meCopyProgram.Enabled := False;
  meCopy.Enabled := False;
  meCut.Enabled := False;
  meDuplicate.Enabled := False;
  meEditDescription.Enabled := False;
  try
    if sdBasicXML.Execute and (sdBasicXML.FileName <> '') then
    begin
      CreateDirectoryRecurse('', ExtractFilePath(sdBasicXML.FileName), nil);
      Parser.SaveAsXML(sdBasicXML.FileName);
    end;
  finally
    btBasicImport.Enabled := True;
    btBasicExport.Enabled := True;
    btBasicLoad.Enabled := True;
    btBasicSave.Enabled := True;
    btBasicLoadDesc.Enabled := True;
    seBlockNumber.Enabled := True;
    eProgName.Enabled := True;
    seStepInput.Enabled := True;
    eStepNameInput.Enabled := True;
    seStepOutput.Enabled := True;
    eStepNameOutput.Enabled := True;
    meCopyProgram.Enabled := True;
    meCopy.Enabled := True;
    meCut.Enabled := True;
    meDuplicate.Enabled := True;
    meEditDescription.Enabled := True;
  end;
end;

procedure TMainForm.btGenerateGridClick(Sender : TObject);
begin
  GenerateGrid;
end;

procedure TMainForm.btExportGridClick(Sender : TObject);
var
  List : TStringList;
  i : Integer;
  s : string;
  Node : PVirtualNode;
  Data : TCrossesData;
begin

  if sdCrossesExport.Execute and (sdCrossesExport.FileName <> '') then
  begin
    List := TStringList.Create;
    try
      s := '';
      for i := 0 to vstCrosses.Header.Columns.Count - 1 do
      begin
        if coVisible in vstCrosses.Header.Columns[i].Options then
        begin
          s := s + vstCrosses.Header.Columns[i].Text + ';';
        end;
      end;
      Delete(s, length(s), 1);
      List.Add(s);
      Node := vstCrosses.GetFirst();
      while Node <> nil do
      begin
        Data := TCrossesData(vstCrosses.GetNodeData(Node)^);
        s := '';
        for i := 0 to vstCrosses.Header.Columns.Count - 1 do
        begin
          if coVisible in vstCrosses.Header.Columns[i].Options then
          begin
            s := s + GetTextFromCrossesData(Data, i) + ';';
          end;
        end;
        Delete(s, length(s), 1);
        List.Add(s);
        Node := vstCrosses.GetNext(Node);
      end;
      CreateDirectoryRecurse('', ExtractFilePath(sdCrossesExport.FileName), nil);
      List.SaveToFile(sdCrossesExport.FileName);
    finally
      FreeAndNil(List);
    end;
  end;
  { DONE : Noch Testen! }
end;

procedure TMainForm.btPrintGridClick(Sender : TObject);
begin
  PrintDialog1.Execute;
  vstCrosses.Print(Printer, True);
end;

procedure TMainForm.cAlarmModeChange(Sender : TObject);
var
  Step : TStep;
  i : Integer;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  i := cAlarmMode.Items.IndexOf(cAlarmMode.Text);
  if i <> - 1 then
  begin
    Step.AlarmCond.Value := i;
  end
  else
  begin
    cAlarmMode.Text := cAlarmMode.Items.Strings[Step.AlarmCond.Value];
  end;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.eProgNameChange(Sender : TObject);
begin
  Parser.BlockName := eProgName.Text;
end;

procedure TMainForm.eStepNameChange(Sender : TObject);
begin
  eStepNameInput.Text := (Sender as TEdit).Text;
  eStepNameOutput.Text := eStepNameInput.Text;
  Parser.StepName[seStepInput.AsInteger] := eStepNameInput.Text;
end;

procedure TMainForm.ChangeStep(index : Integer);
var
  i : Integer;
  InputData : TInputData;
  AnalogInputData : TAnalogInputData;
  OutputData : TOutputData;
  AnalogOutputData : TAnalogOutputData;
  Step : TStep;
  Desc : TDescription;
begin
  if Assigned(Parser) and (Parser.Settings.NumOfBlocks > 0) then
  begin
    Step := Parser.Step[index];
    Desc := Parser.Description;
    eStepNameInput.Text := Parser.StepName[Index];
    eStepNameOutput.Text := Parser.StepName[Index];

    cStepMode.Text := cStepMode.Items.Strings[Step.NextCond.Value];
    seNextStep.Value := Step.NextStep.Value;
    seDuration.Value := Step.Time.Value;
    seLoops.Value := Step.Loops.Value;
    cAlarmMode.Text := cAlarmMode.Items.Strings[Step.AlarmCond.Value];
    seAlarmTime.Value := Step.ContrTime.Value;
    seAlarmStep.Value := Step.AlarmStep.Value;

    cMessage.Text := cMessage.Items.Strings[Step.Message.Value];
    seIntervall1On.Value := Step.Intervall[0].Intervall.Value;
    seIntervall1Off.Value := Step.Intervall[0].Pause.Value;
    seIntervall2On.Value := Step.Intervall[1].Intervall.Value;
    seIntervall2Off.Value := Step.Intervall[1].Pause.Value;

    vstInputs.BeginUpdate;
    try
      vstInputs.Clear;
      for i := 0 to Parser.Settings.NumOfInputs - 1 do
      begin
        InputData.Name := Desc.Input[i];
        InputData.Default.Mode := Step.Input[i].Default.Mode.Value;
        InputData.Default.Aktiv := Step.Input[i].Default.Aktiv.Value;
        InputData.Alternate.Mode := Step.Input[i].Alternate.Mode.Value;
        InputData.Alternate.Aktiv := Step.Input[i].Alternate.Aktiv.Value;
        VSTHAdd(vstInputs, InputData);
      end;
    finally
      vstInputs.EndUpdate;
    end;

    vstAnalogInputs.BeginUpdate;
    try
      vstAnalogInputs.Clear;
      for i := 0 to Parser.Settings.NumOfAnalogIn - 1 do
      begin
        AnalogInputData.Name := Desc.AnalogIn[i];
        AnalogInputData.Default.Mode := Trunc(Step.AnalogIn[i].Default.Mode.Value);
        AnalogInputData.Default.Value := Step.AnalogIn[i].Default.Value.Value;
        AnalogInputData.Alternate.Mode := Trunc(Step.AnalogIn[i].Alternate.Mode.Value);
        AnalogInputData.Alternate.Value := Step.AnalogIn[i].Alternate.Value.Value;
        VSTHAdd(vstAnalogInputs, AnalogInputData);
      end;
    finally
      vstAnalogInputs.EndUpdate;
    end;

    vstOutputs.BeginUpdate;
    try
      vstOutputs.Clear;
      for i := 0 to Parser.Settings.NumOfOutputs - 1 do
      begin
        OutputData.Name := Desc.Output[i];
        OutputData.Mode := Step.OutputMode[i].Value;
        VSTHAdd(vstOutputs, OutputData);
      end;
    finally
      vstOutputs.EndUpdate;
    end;

    vstAnalogOutputs.BeginUpdate;
    try
      vstAnalogOutputs.Clear;
      for i := 0 to Parser.Settings.NumOfAnalogOut - 1 do
      begin
        AnalogOutputData.Name := Desc.AnalogOut[i];
        AnalogOutputData.UnitName := Desc.AnalogOutUnit[i];
        AnalogOutputData.Value := Step.AnalogOut[i].Value;
        VSTHAdd(vstAnalogOutputs, AnalogOutputData);
      end;
    finally
      vstAnalogOutputs.EndUpdate;
    end;

  end;
end;

function TMainForm.GetTextFromCrossesData(Data : TCrossesData; Column : Integer) : String;
var
  INPUTS_START : Integer;
  INPUTS_END : Integer;
  ANALOG_INPUTS_START : Integer;
  ANALOG_INPUTS_END : Integer;
  EMPTY_COLUMN_INPUTS : Integer;
  OUTPUTS_START : Integer;
  OUTPUTS_END : Integer;
  ANALOG_OUTPUTS_START : Integer;
  ANALOG_OUTPUTS_END : Integer;
  EMPTY_COLUMN_OUTPUTS : Integer;
  INTERVALLS_START : Integer;
  INTERVALLS_END : Integer;
  STEP_MODE : Integer;
  STEP_TIME : Integer;
  NEXT_STEP : Integer;
  Loops : Integer;
  STEP_MODE_ALTERNATE : Integer;
  NEXT_STEP_ALTERNATE : Integer;
  ALARM_CONDITION : Integer;
  CONTROL_TIME : Integer;
  ALARM_STEP : Integer;
  MESSAGE_COLUMN : Integer;
  sDefault : string;
  sAlternate : string;
begin
  INPUTS_START := 2;
  INPUTS_END := INPUTS_START + Parser.Settings.NumOfInputs - 1;
  ANALOG_INPUTS_START := INPUTS_END + 1;
  ANALOG_INPUTS_END := ANALOG_INPUTS_START + Parser.Settings.NumOfAnalogIn - 1;
  EMPTY_COLUMN_INPUTS := ANALOG_INPUTS_END + 1;
  OUTPUTS_START := EMPTY_COLUMN_INPUTS + 1;
  OUTPUTS_END := OUTPUTS_START + Parser.Settings.NumOfOutputs - 1;
  ANALOG_OUTPUTS_START := OUTPUTS_END + 1;
  ANALOG_OUTPUTS_END := ANALOG_OUTPUTS_START + Parser.Settings.NumOfAnalogOut - 1;
  EMPTY_COLUMN_OUTPUTS := ANALOG_OUTPUTS_END + 1;
  INTERVALLS_START := EMPTY_COLUMN_OUTPUTS + 1;
  INTERVALLS_END := INTERVALLS_START + Parser.Settings.NumOfIntervalls - 1;
  STEP_MODE := INTERVALLS_END + 1;
  STEP_TIME := STEP_MODE + 1;
  NEXT_STEP := STEP_TIME + 1;
  Loops := NEXT_STEP + 1;
  STEP_MODE_ALTERNATE := Loops + 1;
  NEXT_STEP_ALTERNATE := STEP_MODE_ALTERNATE + 1;
  ALARM_CONDITION := NEXT_STEP_ALTERNATE + 1;
  CONTROL_TIME := ALARM_CONDITION + 1;
  ALARM_STEP := CONTROL_TIME + 1;
  MESSAGE_COLUMN := ALARM_STEP + 1;
  Result := '';
  if Column = 0 then
  begin
    Result := IntToStr(Data.Step);
  end
  else if Column = 1 then
  begin
    Result := Data.StepName;
  end
  else if InRange(Column, INPUTS_START, INPUTS_END) then
  begin
    if Data.Input[Column - INPUTS_START].Default.Aktiv.Value then
    begin
      sDefault := InputMode[Data.Input[Column - INPUTS_START].Default.Mode.Value];
    end
    else
    begin
      sDefault := InputAktiv[Data.Input[Column - INPUTS_START].Default.Aktiv.Value];
    end;

    if Data.Input[Column - INPUTS_START].Alternate.Aktiv.Value then
    begin
      sAlternate := InputMode[Data.Input[Column - INPUTS_START].Alternate.Mode.Value];
    end
    else
    begin
      sAlternate := InputAktiv[Data.Input[Column - INPUTS_START].Alternate.Aktiv.Value];
    end;

    if Data.Input[Column - INPUTS_START].Default.Aktiv.Value or Data.Input[Column - INPUTS_START]
      .Alternate.Aktiv.Value then
    begin
      Result := sDefault + '/' + sAlternate;
    end;
  end
  else if InRange(Column, ANALOG_INPUTS_START, ANALOG_INPUTS_END) then
  begin
    if Data.AnalogIn[Column - ANALOG_INPUTS_START].Default.Mode.Value > 0 then
    begin
      sDefault := Format('%s %f', [AnalogInMode[Trunc(Data.AnalogIn[Column - ANALOG_INPUTS_START].Default.Mode.Value)],
        Data.AnalogIn[Column - ANALOG_INPUTS_START].Default.Value.Value]);
    end
    else
    begin
      sDefault := InputAktiv[Data.AnalogIn[Column - ANALOG_INPUTS_START].Default.Mode.Value > 0];
    end;

    if Data.AnalogIn[Column - ANALOG_INPUTS_START].Alternate.Mode.Value > 0 then
    begin
      sAlternate := Format('%s %f',
        [AnalogInMode[Trunc(Data.AnalogIn[Column - ANALOG_INPUTS_START].Alternate.Mode.Value)],
        Data.AnalogIn[Column - ANALOG_INPUTS_START].Alternate.Value.Value]);
    end
    else
    begin
      sAlternate := InputAktiv[Data.AnalogIn[Column - ANALOG_INPUTS_START].Alternate.Mode.Value > 0];
    end;

    if (Data.AnalogIn[Column - ANALOG_INPUTS_START].Default.Mode.Value > 0) or
      (Data.AnalogIn[Column - ANALOG_INPUTS_START].Alternate.Mode.Value > 0) then
    begin
      Result := sDefault + '/' + sAlternate;
    end;
  end
  else if InRange(Column, OUTPUTS_START, OUTPUTS_END) then
  begin
    if Data.OutputMode[Column - OUTPUTS_START] > 0 then
    begin
      Result := OutputMode[Data.OutputMode[Column - OUTPUTS_START]];
    end;
  end
  else if InRange(Column, ANALOG_OUTPUTS_START, ANALOG_OUTPUTS_END) then
  begin
    Result := Format('%f', [Data.AnalogOut[Column - ANALOG_OUTPUTS_START]]);
  end
  else if InRange(Column, INTERVALLS_START, INTERVALLS_END) then
  begin
    Result := Format('%d/%d s', [Data.Intervall[Column - INTERVALLS_START].Intervall.Value,
      Data.Intervall[Column - INTERVALLS_START].Pause.Value]);
  end
  else if Column = STEP_MODE then
  begin
    Result := cStepMode.Items[Data.NextCond];
  end
  else if Column = STEP_TIME then
  begin
    Result := Format('%d s', [Data.Time]);
  end
  else if Column = NEXT_STEP then
  begin
    Result := IntToStr(Data.NextStep);
  end
  else if Column = Loops then
  begin
    Result := IntToStr(Data.Loops);
  end
  else if Column = STEP_MODE_ALTERNATE then
  begin
    Result := cStepModeAlternate.Items[Data.NextCondAlternate];
  end
  else if Column = NEXT_STEP_ALTERNATE then
  begin
    Result := IntToStr(Data.NextStepAlternate);
  end
  else if Column = ALARM_CONDITION then
  begin
    Result := cAlarmMode.Items[Data.AlarmCond];
  end
  else if Column = CONTROL_TIME then
  begin
    Result := Format('%d s', [Data.ContrTime]);
  end
  else if Column = ALARM_STEP then
  begin
    Result := IntToStr(Data.AlarmStep);
  end
  else if Column = MESSAGE_COLUMN then
  begin
    if Parser.Description.Message.Count > Data.Message then
    begin
      Result := Parser.Description.Message.Strings[Data.Message];
    end
    else
    begin
      if Data.Message > 0 then
      begin
        Result := '???';
      end;
    end;
  end;
end;

procedure TMainForm.GenerateDiagram;
  procedure TraceStep(index : Integer; List : TList<Integer>);
  begin
    if not List.Contains(index) then
    begin
      List.Add(index);
      if Parser.Step[index].NextStep.Value <> 0 then
      begin
        if Parser.Step[index].Loops.Value <> 0 then
        begin
          TraceStep(Parser.Step[index].NextStep.Value, List);
          TraceStep(index + 1, List);
        end
        else
        begin
          TraceStep(Parser.Step[index].NextStep.Value, List);
        end;
      end
      else if (Parser.Step[index].NextCond.Value <> 5) and (index < Parser.StepCount - 1) then
      begin
        TraceStep(index + 1, List);
      end;
      case Parser.Step[index].AlarmCond.Value of
        0 :
          ;
        1 :
          ;
        2 :
          TraceStep(index + 1, List);
        3 :
          TraceStep(Parser.Step[index].AlarmStep.Value, List);
      end;
    end;
  end;

var
  i : Integer;
  sTempPath : string;
  slDotFile : TStringList;
  lActiveSteps : TList<Integer>;
  sTextFileName : string;
  sGrapicFileName : string;
  sAppName : string;
begin
  { TODO : Nicht starten wenn funktion noch läuft }
  lActiveSteps := TList<Integer>.Create();
  TraceStep(0, lActiveSteps);
  slDotFile := TStringList.Create();
  slDotFile.Add('digraph G {');
  // for i := 0 to Parser.StepCount - 1 do
  for i in lActiveSteps do
  begin
    slDotFile.Add(Format('%d [label = "(%d) %s"]', [i, i, Parser.StepName[i]]));
    if Parser.Step[i].NextStep.Value <> 0 then
    begin
      if Parser.Step[i].Loops.Value <> 0 then
      begin
        slDotFile.Add(Format('%d -> %d [label = "%d mal"]', [i, Parser.Step[i].NextStep.Value,
          Parser.Step[i].Loops.Value]));
        slDotFile.Add(Format('%d -> %d', [i, i + 1]));
      end
      else
      begin
        slDotFile.Add(Format('%d -> %d', [i, Parser.Step[i].NextStep.Value]));
      end;
    end
    else if (Parser.Step[i].NextCond.Value <> 5) and (i < Parser.StepCount - 1) then
    begin
      slDotFile.Add(Format('%d -> %d', [i, i + 1]));
    end;
    case Parser.Step[i].AlarmCond.Value of
      0 :
        ;
      1 :
        slDotFile.Add(Format('%d -> "%s" [label = "Timeout %ds"]', [i, cAlarmMode.Items[1],
          Parser.Step[i].ContrTime.Value]));
      2 :
        slDotFile.Add(Format('%d -> %d [label = "Timeout %ds"]', [i, i + 1, Parser.Step[i].ContrTime.Value]));
      3 :
        slDotFile.Add(Format('%d -> %d [label = "Timeout %ds"]', [i, Parser.Step[i].AlarmStep.Value,
          Parser.Step[i].ContrTime.Value]));
    end;
  end;
  slDotFile.Add('}');
  sTempPath := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP')) + 'CleanProgHelper\';
  ForceDirectories(sTempPath);
  sTextFileName := sTempPath + 'Diagram.dot';
  sGrapicFileName := sTempPath + 'Diagram.png';
  sAppName := ExtractFilePath(Application.ExeName) + 'Graphviz\dot.exe';
  if DirectoryExists(sTempPath) and FileExists(sAppName) then
  begin
    slDotFile.SaveToFile(sTextFileName);
    RunApplicationAndWait(sAppName, sTextFileName + ' -Tpng -o ' + sGrapicFileName, 20000, SW_HIDE);
    if FileExists(sGrapicFileName) then
    begin
      iDiagram.Picture.LoadFromFile(sGrapicFileName);
    end;
  end;
  DeleteFileEx(sTempPath);
  FreeAndNil(slDotFile);
  FreeAndNil(lActiveSteps);
end;

procedure TMainForm.GenerateGrid;
  function TextWidthAngle(const Canvas : TCanvas; const AText : string; AAngle : Integer) : Integer;
  var
    hCurFont : TFont;
    LogFont : TLogFont;
  begin
    with Canvas do
    begin
      hCurFont := Font;
      try
        GetObject(Font.Handle, SizeOf(LogFont), @LogFont);
        LogFont.lfEscapement := AAngle;
        LogFont.lfOrientation := AAngle;
        LogFont.lfWidth := hCurFont.Size;
        Font.Handle := CreateFontIndirect(LogFont);
        Result := TextWidth(AText);
      finally
        Font := hCurFont;
      end;
    end;
  end;

var
  j : Integer;
  HeaderColumn : TVirtualTreeColumn;
  k : Integer;
  s : string;
  i : Integer;
  Data : TCrossesData;
begin
  vstCrosses.Clear;
  vstCrosses.Header.Columns.Clear;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Schritt';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Name';
  HeaderColumn.Width := 28;
  for i := 0 to Parser.Settings.NumOfInputs - 1 do
  begin
    HeaderColumn := vstCrosses.Header.Columns.Add;
    HeaderColumn.Text := Parser.Description.Input[i];
    HeaderColumn.Width := 28;
    if HeaderColumn.Text = '' then
    begin
      HeaderColumn.Options := HeaderColumn.Options - [coVisible];
    end;
  end;
  for i := 0 to Parser.Settings.NumOfAnalogIn - 1 do
  begin
    HeaderColumn := vstCrosses.Header.Columns.Add;
    HeaderColumn.Text := Parser.Description.AnalogIn[i];
    HeaderColumn.Width := 28;
    if HeaderColumn.Text = '' then
    begin
      HeaderColumn.Options := HeaderColumn.Options - [coVisible];
    end;
  end;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := '';
  HeaderColumn.Width := 28;
  for i := 0 to Parser.Settings.NumOfOutputs - 1 do
  begin
    HeaderColumn := vstCrosses.Header.Columns.Add;
    HeaderColumn.Text := Parser.Description.Output[i];
    HeaderColumn.Width := 28;
    if HeaderColumn.Text = '' then
    begin
      HeaderColumn.Options := HeaderColumn.Options - [coVisible];
    end;
  end;
  for i := 0 to Parser.Settings.NumOfAnalogOut - 1 do
  begin
    HeaderColumn := vstCrosses.Header.Columns.Add;
    HeaderColumn.Text := Parser.Description.AnalogOut[i];
    HeaderColumn.Width := 28;
    if HeaderColumn.Text = '' then
    begin
      HeaderColumn.Options := HeaderColumn.Options - [coVisible];
    end;
  end;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := '';
  HeaderColumn.Width := 28;
  for i := 0 to Parser.Settings.NumOfIntervalls - 1 do
  begin
    HeaderColumn := vstCrosses.Header.Columns.Add;
    HeaderColumn.Text := Format('Intervall %d Ein/Aus', [i + 1]);
    HeaderColumn.Width := 28;
  end;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Schrittmodus';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Dauer';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Folgeschritt';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Schleifen';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Schrittmodus Alternativ';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Alternativschritt';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Überwachungsmodus';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Überwachungszeit';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Alarmschritt';
  HeaderColumn.Width := 28;
  HeaderColumn := vstCrosses.Header.Columns.Add;
  HeaderColumn.Text := 'Meldung';
  HeaderColumn.Width := 28;
  for i := 0 to vstCrosses.Header.Columns.Count - 1 do
  begin
    j := TextWidthAngle(vstCrosses.Canvas, vstCrosses.Header.Columns[i].Text, 900);
    vstCrosses.Header.Height := Max(j + vstCrosses.Header.Columns[i].Margin * 2, vstCrosses.Header.Height);
  end;
  vstCrosses.Canvas.Font := vstCrosses.Font;
  for i := 0 to Parser.StepCount - 1 do
  begin
    Data := TCrossesData.Create(Parser.Settings);
    Data.Step := i;
    Data.StepName := Parser.StepName[i];
    for j := 0 to Parser.Settings.NumOfInputs - 1 do
    begin
      Data.Input[j] := Parser.Step[i].Input[j];
    end;
    for j := 0 to Parser.Settings.NumOfAnalogIn - 1 do
    begin
      Data.AnalogIn[j] := Parser.Step[i].AnalogIn[j];
    end;
    for j := 0 to Parser.Settings.NumOfOutputs - 1 do
    begin
      Data.OutputMode[j] := Parser.Step[i].OutputMode[j].Value;
    end;
    for j := 0 to Parser.Settings.NumOfAnalogOut - 1 do
    begin
      Data.AnalogOut[j] := Parser.Step[i].AnalogOut[j].Value;
    end;
    for j := 0 to Parser.Settings.NumOfIntervalls - 1 do
    begin
      Data.Intervall[j] := Parser.Step[i].Intervall[j];
    end;
    Data.NextCond := Parser.Step[i].NextCond.Value;
    Data.NextCondAlternate := Parser.Step[i].NextCondAlternate.Value;
    Data.Time := Parser.Step[i].Time.Value;
    Data.NextStep := Parser.Step[i].NextStep.Value;
    Data.NextStepAlternate := Parser.Step[i].NextStepAlternate.Value;
    Data.Loops := Parser.Step[i].Loops.Value;
    Data.AlarmCond := Parser.Step[i].AlarmCond.Value;
    Data.ContrTime := Parser.Step[i].ContrTime.Value;
    Data.AlarmStep := Parser.Step[i].AlarmStep.Value;
    Data.Message := Parser.Step[i].Message.Value;
    for j := 0 to vstCrosses.Header.Columns.Count - 1 do
    begin
      s := GetTextFromCrossesData(Data, j);
      k := vstCrosses.Canvas.TextWidth(s);
      HeaderColumn := vstCrosses.Header.Columns[j];
      HeaderColumn.Width := Max(k + 14, HeaderColumn.Width);
      if s <> '' then
      begin
        HeaderColumn.Options := HeaderColumn.Options + [coVisible];
      end;
    end;
    VSTHAdd(vstCrosses, Data);
  end;
  btPrintGrid.Enabled := True;
  btExportGrid.Enabled := True;
end;

procedure TMainForm.cMessageChange(Sender : TObject);
var
  Step : TStep;
  i : Integer;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  i := cMessage.Items.IndexOf(cMessage.Text);
  if i <> - 1 then
  begin
    Step.Message.Value := i;
  end;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.cMessageKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
var
  i : Integer;
  Desc : TDescription;
begin
  Desc := Parser.Description;
  case Key of
    VK_RETURN :
      begin
        cMessage.Items.Add(cMessage.Text);
        Desc.Message.Clear;
        Desc.Message.AddStrings(cMessage.Items);
      end;
    VK_DELETE :
      begin
        i := cMessage.Items.IndexOf(cMessage.Text);
        if i <> - 1 then
        begin
          cMessage.Items.Delete(i);
          Desc.Message.Clear;
          Desc.Message.AddStrings(cMessage.Items);
        end;
      end;
  end;
  Parser.Description := Desc;
end;

procedure TMainForm.cStepModeChange(Sender : TObject);
var
  Step : TStep;
  i : Integer;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  i := cStepMode.Items.IndexOf(cStepMode.Text);
  if i <> - 1 then
  begin
    Step.NextCond.Value := i;
  end
  else
  begin
    cStepMode.Text := cStepMode.Items.Strings[Step.NextCond.Value];
  end;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.FormCreate(Sender : TObject);
var
  Settings : TSettings;
  FileName : string;
begin
  Settings := TSettings.Create();
  FileName := ExtractFilePath(Application.ExeName) + 'Settings.xml';
  if FileExists(FileName) then
  begin
    Settings.LoadFromFile(FileName);
  end;
  pcPages.ActivePage := tsBasic;
  pcPages.Pages[1].TabVisible := False;
  pcPages.Pages[2].TabVisible := False;
  pcPages.Pages[3].TabVisible := False;
  pcPages.Pages[4].TabVisible := False;
  seLanguage.MaxValue := Settings.NumOfLangs;
  seStepInput.MaxValue := Settings.NumOfSteps - 1;
  seStepOutput.MaxValue := Settings.NumOfSteps - 1;
  vstInputs.NodeDataSize := SizeOf(TInputData);
  vstAnalogInputs.NodeDataSize := SizeOf(TAnalogInputData);
  vstOutputs.NodeDataSize := SizeOf(TOutputData);
  vstAnalogOutputs.NodeDataSize := SizeOf(TAnalogOutputData);
  vstCrosses.NodeDataSize := SizeOf(TCrossesData);
  cMessage.Items.Add('');
  case Settings.DataSetNameMode of
    pnmSingleDataSet :
      begin
        Parser := TCleanProgParserSingleDatasetName.Create(Settings);
        vstInputs.Header.Columns[3].Options := vstInputs.Header.Columns[3].Options - [coVisible];
        vstInputs.Header.Columns[4].Options := vstInputs.Header.Columns[4].Options - [coVisible];
        vstAnalogInputs.Header.Columns[3].Options := vstAnalogInputs.Header.Columns[3].Options - [coVisible];
        vstAnalogInputs.Header.Columns[4].Options := vstAnalogInputs.Header.Columns[4].Options - [coVisible];
      end;
    pnmMultipleDataSets :
      begin
        Parser := TCleanProgParser.Create(Settings);
        vstInputs.Header.Columns[3].Options := vstInputs.Header.Columns[3].Options - [coVisible];
        vstInputs.Header.Columns[4].Options := vstInputs.Header.Columns[4].Options - [coVisible];
        vstAnalogInputs.Header.Columns[3].Options := vstAnalogInputs.Header.Columns[3].Options - [coVisible];
        vstAnalogInputs.Header.Columns[4].Options := vstAnalogInputs.Header.Columns[4].Options - [coVisible];
      end;
    pnmBlocks :
      begin
        Parser := TCleanProgParserBlockBased.Create(Settings);
        cStepMode.Items.Clear();
        cStepMode.Items.Add('Eingänge (UND)');
        cStepMode.Items.Add('Zeit');
        cStepMode.Items.Add('Eingänge UND Zeit');
        cStepMode.Items.Add('Eingänge ODER Zeit');
        cStepMode.Items.Add('Quittierung');
        cStepMode.Items.Add('Ende Reinigung');
      end;
  end;
  Parser.Picture := iBasic.Picture;
  Parser.OnSelectLangIndex := OnSelectLangIndex;
  // end;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(Parser);
end;

procedure TMainForm.FormMouseWheel(Sender : TObject; Shift : TShiftState; WheelDelta : Integer; MousePos : TPoint;
  var Handled : Boolean);
var
  vsb : TControlScrollbar;
  ctrl : TControl;
begin
  if pcPages.ActivePage = tsDiagram then
  begin
    ctrl := ControlAtPos(ScreenToClient(MousePos), False, True, True);
    while (ctrl <> nil) and not (ctrl is TPageControl) do
    begin
      ctrl := ctrl.Parent;
    end;
    if ctrl is TPageControl then
    begin
      vsb := sbDiagram.VertScrollBar;
      vsb.Position := vsb.Position - Sign(WheelDelta) * vsb.Increment;
      Handled := True;
    end;
  end;
end;

procedure TMainForm.meAboutClick(Sender : TObject);
var
  AboutForm : TAboutBox;
begin
  AboutForm := TAboutBox.Create(Self);
  AboutForm.ShowModal;
end;

procedure TMainForm.meCopyClick(Sender : TObject);
begin
  { DONE : Deaktivieren wenn kein Prog geladen }
  Parser.CopyStep(seStepInput.AsInteger);
  meInsert.Caption := Format('Einfügen (%d: %s)', [seStepInput.AsInteger, Parser.StepName[seStepInput.AsInteger]]);
  meInsert.Enabled := True;
  meInsert.Tag := 1;
end;

procedure TMainForm.meCopyProgramClick(Sender : TObject);
var
  InsertForm : TSelectTarget;
begin
  { DONE : Deaktivieren wenn kein Prog geladen }
  InsertForm := TSelectTarget.Create(Self);
  InsertForm.MaxNumber := Parser.Settings.NumOfBlocks;
  if InsertForm.ShowModal = mrOk then
  begin
    Parser.CopyBlock(InsertForm.SelectedNumber);
  end;
  FreeAndNil(InsertForm);
end;

procedure TMainForm.meCutClick(Sender : TObject);
begin
  { DONE : Deaktivieren wenn kein Prog geladen }
  meInsert.Caption := Format('Einfügen (%d: %s)', [seStepInput.AsInteger, Parser.StepName[seStepInput.AsInteger]]);
  Parser.CutStep(seStepInput.AsInteger);
  ChangeStep(seStepInput.AsInteger);
  meInsert.Enabled := True;
  meInsert.Tag := 1;
end;

procedure TMainForm.meDuplicateClick(Sender : TObject);
begin
  { DONE : Deaktivieren wenn kein Prog geladen }
  Parser.CopyStep(seStepInput.AsInteger);
  meInsert.Caption := Format('Einfügen (%d: %s)', [seStepInput.AsInteger, Parser.StepName[seStepInput.AsInteger]]);
  Parser.InsertStep(seStepInput.AsInteger);
  ChangeStep(seStepInput.AsInteger);
  meInsert.Enabled := True;
  meInsert.Tag := 1;
end;

procedure TMainForm.meEditDescriptionClick(Sender : TObject);
begin
  if meEditDescription.Checked then
  begin
    meInsert.Enabled := False;
    meInsert.ShortCut := 0;
    meCopy.Enabled := False;
    meCopy.ShortCut := 0;
    meCut.Enabled := False;
    meCut.ShortCut := 0;
    meDuplicate.Enabled := False;
    meDuplicate.ShortCut := 0;
  end
  else
  begin
    meInsert.Enabled := (meInsert.Tag = 1);
    meInsert.ShortCut := ShortCut(Word('V'), [ssCtrl]);
    meCopy.Enabled := True;
    meCopy.ShortCut := ShortCut(Word('C'), [ssCtrl]);
    meCut.Enabled := True;
    meCut.ShortCut := ShortCut(Word('X'), [ssCtrl]);
    meDuplicate.Enabled := True;
    meDuplicate.ShortCut := ShortCut(Word('D'), [ssCtrl]);
  end;
end;

procedure TMainForm.meEditMessagesClick(Sender : TObject);
var
  EditMessages : TEditMessages;
  Helper : TStringList;
  OldIndex : Integer;
begin
  OldIndex := cMessage.Items.IndexOf(cMessage.Text);
  EditMessages := TEditMessages.Create(Self);
  Helper := TStringList.Create;
  Helper.AddStrings(cMessage.Items);
  EditMessages.Messages := Helper;
  if EditMessages.ShowModal = mrOk then
  begin
    FreeAndNil(Helper);
    Helper := EditMessages.Messages;
    cMessage.Items.Clear;
    cMessage.Items.AddStrings(Helper);
    Parser.Description.Message.Clear;
    Parser.Description.Message.AddStrings(Helper);
    if OldIndex <= cMessage.Items.Count - 1 then
    begin
      cMessage.Text := cMessage.Items[OldIndex];
    end
    else
    begin
      cMessage.Text := '';
    end;
  end;
  FreeAndNil(Helper);
end;

procedure TMainForm.meInsertClick(Sender : TObject);
begin
  { DONE : Deaktivieren wenn kein Prog geladen }
  Parser.InsertStep(seStepInput.AsInteger);
  ChangeStep(seStepInput.AsInteger);
end;

procedure TMainForm.OnSelectLangIndex(Sender : TObject; LangDesc : TStringList; out Indizes : TList<Integer>);
var
  SelectLangIndex : TSelectLangIndex;
begin
  SelectLangIndex := TSelectLangIndex.Create(Self);
  SelectLangIndex.LangDesc := LangDesc;
  SelectLangIndex.Indizes := Indizes;
  SelectLangIndex.ShowModal;
end;

procedure TMainForm.pcPagesChange(Sender : TObject);
begin
  if pcPages.ActivePage = tsDiagram then
  begin
    sbDiagram.SetFocus;
  end;
end;

procedure TMainForm.pcPagesChanging(Sender : TObject; var AllowChange : Boolean);
begin
  AllowChange := Parser.Settings.NumOfBlocks > 0;
end;

procedure TMainForm.seAlarmStepChange(Sender : TObject);
var
  Step : TStep;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  Step.AlarmStep.Value := seAlarmStep.AsInteger;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.seAlarmTimeChange(Sender : TObject);
var
  Step : TStep;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  Step.ContrTime.Value := seAlarmTime.AsInteger;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.seDurationChange(Sender : TObject);
var
  Step : TStep;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  Step.Time.Value := seDuration.AsInteger;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.seIntervall1OffChange(Sender : TObject);
var
  Step : TStep;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  Step.Intervall[0].Pause.Value := seIntervall1Off.AsInteger;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.seIntervall1OnChange(Sender : TObject);
var
  Step : TStep;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  Step.Intervall[0].Intervall.Value := seIntervall1On.AsInteger;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.seIntervall2OffChange(Sender : TObject);
var
  Step : TStep;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  Step.Intervall[1].Pause.Value := seIntervall2Off.AsInteger;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.seIntervall2OnChange(Sender : TObject);
var
  Step : TStep;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  Step.Intervall[1].Intervall.Value := seIntervall2On.AsInteger;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.seLanguageChange(Sender : TObject);
var
  Desc : TDescription;
begin
  if Assigned(Parser) then
  begin
    Parser.Language := seLanguage.AsInteger;
    Desc := Parser.Description;
    cMessage.Items.Clear;
    cMessage.Items.AddStrings(Desc.Message);
    if Parser.Settings.DataSetNameMode = pnmBlocks then
    begin
      cStepMode.Items.Clear();
      cStepMode.Items.Add('Eingänge (UND)');
      cStepMode.Items.Add('Zeit');
      cStepMode.Items.Add('Eingänge UND Zeit');
      cStepMode.Items.Add('Eingänge ODER Zeit');
      cStepMode.Items.Add('Quittierung');
      cStepMode.Items.Add('Ende Reinigung');
    end;
    ChangeStep(seStepInput.AsInteger);
  end;
  if pcPages.ActivePage = tsCrosses then
  begin
    GenerateGrid;
  end;
  if pcPages.ActivePage = tsDiagram then
  begin
    GenerateDiagram;
  end;
end;

procedure TMainForm.seLoopsChange(Sender : TObject);
var
  Step : TStep;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  Step.Loops.Value := seLoops.AsInteger;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.seNextStepChange(Sender : TObject);
var
  Step : TStep;
begin
  Step := Parser.Step[seStepInput.AsInteger];
  Step.NextStep.Value := seNextStep.AsInteger;
  Parser.Step[seStepInput.AsInteger] := Step;
end;

procedure TMainForm.seBlockNumberChange(Sender : TObject);
begin
  Parser.SelectedBlock := seBlockNumber.AsInteger;
  eProgName.Text := Parser.BlockName;
  ChangeStep(seStepInput.AsInteger);
  if pcPages.ActivePage = tsCrosses then
  begin
    GenerateGrid;
  end;
  if pcPages.ActivePage = tsDiagram then
  begin
    GenerateDiagram;
  end;
end;

procedure TMainForm.seStepChange(Sender : TObject);
begin
  seStepInput.Value := (Sender as TJvSpinEdit).Value;
  seStepOutput.Value := seStepInput.Value;
  ChangeStep(seStepInput.AsInteger);
end;

procedure TMainForm.tsCrossesShow(Sender : TObject);
begin
  GenerateGrid;
end;

procedure TMainForm.tsDiagramShow(Sender : TObject);
begin
  GenerateDiagram;
end;

procedure TMainForm.vstAnalogInputsCreateEditor(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  out EditLink : IVTEditLink);
begin
  EditLink := TAnalogInputEditLink.Create;
end;

procedure TMainForm.vstAnalogInputsEdited(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex);
var
  Step : TStep;
  Data : PAnalogInputData;
  Description : TDescription;
begin
  Data := vstAnalogInputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 :
        begin
          Description := Parser.Description;
          Description.AnalogIn[Node.Index] := Data.Name;
          Parser.Description := Description;
        end;
      1 :
        begin
          Step := Parser.Step[seStepInput.AsInteger];
          Step.AnalogIn[Node.Index].Default.Value.Value := Data.Default.Value;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
      2 :
        begin
          Step := Parser.Step[seStepInput.AsInteger];
          Step.AnalogIn[Node.Index].Default.Mode.Value := Data.Default.Mode;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
      3 :
        begin
          Step := Parser.Step[seStepInput.AsInteger];
          Step.AnalogIn[Node.Index].Alternate.Value.Value := Data.Alternate.Value;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
      4 :
        begin
          Step := Parser.Step[seStepInput.AsInteger];
          Step.AnalogIn[Node.Index].Alternate.Mode.Value := Data.Alternate.Mode;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
    end;
  end;
end;

procedure TMainForm.vstAnalogInputsEditing(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  var Allowed : Boolean);
begin
  Allowed := True;
end;

procedure TMainForm.vstAnalogInputsFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
var
  Data : PAnalogInputData;
begin
  Data := vstAnalogInputs.GetNodeData(Node);
  Data.Name := '';
  Data.Default.Mode := 0;
  Data.Default.Value := 0;
  Data.Alternate.Mode := 0;
  Data.Alternate.Value := 0;
end;

procedure TMainForm.vstAnalogInputsGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  TextType : TVSTTextType; var CellText : string);
var
  Data : PAnalogInputData;
begin
  Data := vstAnalogInputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 :
        CellText := Data.Name;
      1 :
        CellText := Format('%1.2f', [Data^.Default.Value]);
      2 :
        CellText := AnalogInMode[Data^.Default.Mode];
      3 :
        CellText := Format('%1.2f', [Data^.Alternate.Value]);
      4 :
        CellText := AnalogInMode[Data^.Alternate.Mode];
    end;
  end;
end;

procedure TMainForm.vstAnalogInputsKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  if Key = VK_RETURN then
  begin
    vstAnalogInputs.FocusedNode := vstAnalogInputs.GetNext(vstAnalogInputs.FocusedNode);
    if vstAnalogInputs.FocusedNode <> nil then
    begin
      vstAnalogInputs.Selected[vstAnalogInputs.FocusedNode] := True;
      vstAnalogInputs.EditNode(vstAnalogInputs.FocusedNode, 0);
    end;
  end;
end;

procedure TMainForm.vstAnalogInputsMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState;
  X, Y : Integer);
var
  Node : PVirtualNode;
  Column : Integer;
begin
  Node := vstAnalogInputs.GetNodeAt(X, Y);
  Column := vstAnalogInputs.Header.Columns.ColumnFromPosition(Point(X, Y));
  if Assigned(Node) then
  begin
    case Column of
      0 :
        if meEditDescription.Checked then
        begin
          vstAnalogInputs.EditNode(Node, Column);
        end;
      1 :
        vstAnalogInputs.EditNode(Node, Column);
      2 :
        vstAnalogInputs.EditNode(Node, Column);
      3 :
        vstAnalogInputs.EditNode(Node, Column);
      4 :
        vstAnalogInputs.EditNode(Node, Column);
    end;
  end;
end;

procedure TMainForm.vstAnalogOutputsCreateEditor(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  out EditLink : IVTEditLink);
begin
  EditLink := TAnalogOutputEditLink.Create;
end;

procedure TMainForm.vstAnalogOutputsEdited(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex);
var
  Step : TStep;
  Data : PAnalogOutputData;
  Description : TDescription;
begin
  Data := vstAnalogOutputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 :
        begin
          Description := Parser.Description;
          Description.AnalogOut[Node.Index] := Data.Name;
          Parser.Description := Description;
        end;
      1 :
        begin
          Step := Parser.Step[seStepInput.AsInteger];
          Step.AnalogOut[Node.Index].Value := Data.Value;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
      2 :
        begin
          Description := Parser.Description;
          Description.AnalogOutUnit[Node.Index] := Data.UnitName;
          Parser.Description := Description;
        end;
    end;
  end;
end;

procedure TMainForm.vstAnalogOutputsEditing(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  var Allowed : Boolean);
begin
  Allowed := True;
end;

procedure TMainForm.vstAnalogOutputsFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
var
  Data : PAnalogOutputData;
begin
  Data := vstAnalogOutputs.GetNodeData(Node);
  Data.Name := '';
  Data.UnitName := '';
  Data.Value := 0;
end;

procedure TMainForm.vstAnalogOutputsGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  TextType : TVSTTextType; var CellText : string);
var
  Data : PAnalogOutputData;
begin
  Data := vstAnalogOutputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 :
        CellText := Data.Name;
      1 :
        CellText := Format('%1.2f', [Data.Value]);
      2 :
        CellText := Data.UnitName;
    end;
  end;
end;

procedure TMainForm.vstAnalogOutputsKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  if Key = VK_RETURN then
  begin
    vstAnalogOutputs.FocusedNode := vstAnalogOutputs.GetNext(vstAnalogOutputs.FocusedNode);
    if vstAnalogOutputs.FocusedNode <> nil then
    begin
      vstAnalogOutputs.Selected[vstAnalogOutputs.FocusedNode] := True;
      vstAnalogOutputs.EditNode(vstAnalogOutputs.FocusedNode, 0);
    end;
  end;
end;

procedure TMainForm.vstAnalogOutputsMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState;
  X, Y : Integer);
var
  Node : PVirtualNode;
  Column : Integer;
begin
  Node := vstAnalogOutputs.GetNodeAt(X, Y);
  Column := vstAnalogOutputs.Header.Columns.ColumnFromPosition(Point(X, Y));
  if Assigned(Node) then
  begin
    case Column of
      0 :
        if meEditDescription.Checked then
        begin
          vstAnalogOutputs.EditNode(Node, Column);
        end;
      1 :
        vstAnalogOutputs.EditNode(Node, Column);
      2 :
        if meEditDescription.Checked then
        begin
          vstAnalogOutputs.EditNode(Node, Column);
        end;
    end;
  end;
end;

procedure TMainForm.vstCrossesAdvancedHeaderDraw(Sender : TVTHeader; var PaintInfo : THeaderPaintInfo;
  const Elements : THeaderPaintElements);
var
  // i : Integer;
  Pos : Integer;
begin
  with PaintInfo do
  begin
    if Column <> nil then
    begin
      Pos := PaintRectangle.Left + ((PaintRectangle.Right - PaintRectangle.Left) div 2);
      Pos := Pos - TargetCanvas.TextHeight(Column.Text) div 2;
      Pos := Pos - Column.Margin;
      { i := } TextOutAngle(TargetCanvas, Pos, PaintRectangle.Bottom - Column.Margin, Column.Text, 900);
      // Sender.Height := Max(i + Column.Margin * 2, Sender.Height);
    end;
  end;
end;

procedure TMainForm.vstCrossesBeforeCellPaint(Sender : TBaseVirtualTree; TargetCanvas : TCanvas; Node : PVirtualNode;
  Column : TColumnIndex; CellPaintMode : TVTCellPaintMode; CellRect : TRect; var ContentRect : TRect);
begin
  if Odd(Node.Index) then
  begin
    TargetCanvas.Brush.Color := clSkyBlue;
    TargetCanvas.FillRect(CellRect);
  end;
end;

procedure TMainForm.vstCrossesFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
var
  Data : TCrossesData;
begin
  Data := TCrossesData(vstCrosses.GetNodeData(Node)^);
  if Assigned(Data) then
  begin
    FreeAndNil(Data);
  end;
end;

procedure TMainForm.vstCrossesGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  TextType : TVSTTextType; var CellText : string);
var
  Data : TCrossesData;
begin
  Data := TCrossesData(vstCrosses.GetNodeData(Node)^);
  if Assigned(Data) then
  begin
    CellText := GetTextFromCrossesData(Data, Column);
    { vstCrosses.Header.Columns[Column].Width := Max(vstCrosses.Canvas.TextWidth(CellText) + 14,
      vstCrosses.Header.Columns[Column].Width); }
    { if (Column = 89 + Data.Message) and
      (Parser.Description.Message.Strings[Data.Message] <> '') then
      begin
      CellText := 'X';
      end; }

  end;
end;

procedure TMainForm.vstCrossesHeaderDrawQueryElements(Sender : TVTHeader; var PaintInfo : THeaderPaintInfo;
  var Elements : THeaderPaintElements);
begin
  with PaintInfo do
  begin
    if (Column <> nil) and (Column.Text <> '') then
    begin
      Elements := [hpeText];
    end;
  end;
end;

procedure TMainForm.vstInputsBeforeCellPaint(Sender : TBaseVirtualTree; TargetCanvas : TCanvas; Node : PVirtualNode;
  Column : TColumnIndex; CellPaintMode : TVTCellPaintMode; CellRect : TRect; var ContentRect : TRect);
var
  Data : PInputData;
  Steps : Integer;
  Rectangle : TRect;
begin
  Data := vstInputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    if ((Column = 1) and Data.Default.Mode) or ((Column = 2) and Data.Default.Aktiv) or
      ((Column = 3) and Data.Alternate.Mode) or ((Column = 4) and Data.Alternate.Aktiv) then
    begin
      Steps := Round((CellRect.Bottom - CellRect.Top) / 14);
      Rectangle := CellRect;
      Rectangle.Left := Rectangle.Left + 1;
      Rectangle.Top := Rectangle.Top + 1;

      TargetCanvas.Brush.Color := $00ACEDAB;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $00ACEDAB;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0096E995;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $007EE47C;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0068DF66;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0050DA4E;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0038D535;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0038D535;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0031D32E;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0045D742;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $005DDD5B;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0077E275;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0090E78E;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0090E78E;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := CellRect.Bottom;
      TargetCanvas.FillRect(Rectangle);
    end;
  end;

end;

procedure TMainForm.vstInputsEditing(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  var Allowed : Boolean);
begin
  Allowed := Column = 0;
end;

procedure TMainForm.vstInputsFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
var
  Data : PInputData;
begin
  Data := vstInputs.GetNodeData(Node);
  Data.Name := '';
  Data.Default.Mode := False;
  Data.Default.Aktiv := False;
  Data.Alternate.Mode := False;
  Data.Alternate.Aktiv := False;
end;

procedure TMainForm.vstInputsGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  TextType : TVSTTextType; var CellText : String);
var
  Data : PInputData;
begin
  Data := vstInputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 :
        CellText := Data.Name;
      1 :
        CellText := InputMode[Data^.Default.Mode];
      2 :
        CellText := InputAktiv[Data^.Default.Aktiv];
      3 :
        CellText := InputMode[Data^.Alternate.Mode];
      4 :
        CellText := InputAktiv[Data^.Alternate.Aktiv];
    end;
  end;
end;

procedure TMainForm.vstInputsKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  if Key = VK_RETURN then
  begin
    vstInputs.FocusedNode := vstInputs.GetNext(vstInputs.FocusedNode);
    if vstInputs.FocusedNode <> nil then
    begin
      vstInputs.Selected[vstInputs.FocusedNode] := True;
      vstInputs.EditNode(vstInputs.FocusedNode, 0);
    end;
  end;
end;

procedure TMainForm.vstInputsMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  Node : PVirtualNode;
  Data : PInputData;
  Column : Integer;
  Step : TStep;
begin
  Node := vstInputs.GetNodeAt(X, Y);
  Column := vstInputs.Header.Columns.ColumnFromPosition(Point(X, Y));
  if Assigned(Node) then
  begin
    Data := vstInputs.GetNodeData(Node);
    case Column of
      0 :
        if meEditDescription.Checked then
        begin
          vstInputs.EditNode(Node, Column);
        end;
      1 :
        if Assigned(Data) then
        begin
          Data.Default.Mode := not Data.Default.Mode;
          vstInputs.Selected[Node] := False;
          vstInputs.RepaintNode(Node);
          Step := Parser.Step[seStepInput.AsInteger];
          Step.Input[Node.Index].Default.Mode.Value := Data.Default.Mode;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
      2 :
        if Assigned(Data) then
        begin
          Data.Default.Aktiv := not Data.Default.Aktiv;
          vstInputs.Selected[Node] := False;
          vstInputs.RepaintNode(Node);
          Step := Parser.Step[seStepInput.AsInteger];
          Step.Input[Node.Index].Default.Aktiv.Value := Data.Default.Aktiv;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
      3 :
        if Assigned(Data) then
        begin
          Data.Alternate.Mode := not Data.Alternate.Mode;
          vstInputs.Selected[Node] := False;
          vstInputs.RepaintNode(Node);
          Step := Parser.Step[seStepInput.AsInteger];
          Step.Input[Node.Index].Alternate.Mode.Value := Data.Alternate.Mode;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
      4 :
        if Assigned(Data) then
        begin
          Data.Alternate.Aktiv := not Data.Alternate.Aktiv;
          vstInputs.Selected[Node] := False;
          vstInputs.RepaintNode(Node);
          Step := Parser.Step[seStepInput.AsInteger];
          Step.Input[Node.Index].Alternate.Aktiv.Value := Data.Alternate.Aktiv;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
    end;
  end;
end;

procedure TMainForm.vstInputsNewText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  NewText : String);
var
  Data : PInputData;
  Description : TDescription;
begin
  Data := vstInputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    Description := Parser.Description;
    case Column of
      0 :
        begin
          Data.Name := NewText;
          Description.Input[Node.Index] := NewText;
        end;
      1 :
        ;
      2 :
        ;
      3 :
        ;
      4 :
        ;
    end;
    Parser.Description := Description;
  end;
end;

procedure TMainForm.vstOutputsBeforeCellPaint(Sender : TBaseVirtualTree; TargetCanvas : TCanvas; Node : PVirtualNode;
  Column : TColumnIndex; CellPaintMode : TVTCellPaintMode; CellRect : TRect; var ContentRect : TRect);
var
  Data : POutputData;
  Steps : Integer;
  Rectangle : TRect;
begin
  Data := vstOutputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    if ((Column = 1) and (Data.Mode > 0)) then
    begin
      Steps := Round((CellRect.Bottom - CellRect.Top) / 14);
      Rectangle := CellRect;
      Rectangle.Left := Rectangle.Left + 1;
      Rectangle.Top := Rectangle.Top + 1;

      TargetCanvas.Brush.Color := $00ACEDAB;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $00ACEDAB;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0096E995;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $007EE47C;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0068DF66;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0050DA4E;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0038D535;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0038D535;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0031D32E;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0045D742;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $005DDD5B;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0077E275;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0090E78E;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := Rectangle.Top + Steps;
      TargetCanvas.FillRect(Rectangle);

      TargetCanvas.Brush.Color := $0090E78E;
      Rectangle.Top := Rectangle.Bottom;
      Rectangle.Bottom := CellRect.Bottom;
      TargetCanvas.FillRect(Rectangle);
    end;
  end;
end;

procedure TMainForm.vstOutputsCreateEditor(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  out EditLink : IVTEditLink);
begin
  EditLink := TOutputEditLink.Create;
end;

procedure TMainForm.vstOutputsEdited(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex);
var
  Step : TStep;
  Data : POutputData;
  Description : TDescription;
begin
  Data := vstOutputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 :
        begin
          Description := Parser.Description;
          Description.Output[Node.Index] := Data.Name;
          Parser.Description := Description;
        end;
      1 :
        begin
          Step := Parser.Step[seStepInput.AsInteger];
          Step.OutputMode[Node.Index].Value := Data.Mode;
          Parser.Step[seStepInput.AsInteger] := Step;
        end;
    end;
  end;
end;

procedure TMainForm.vstOutputsEditing(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  var Allowed : Boolean);
begin
  Allowed := True;
end;

procedure TMainForm.vstOutputsFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
var
  Data : POutputData;
begin
  Data := vstOutputs.GetNodeData(Node);
  Data.Name := '';
  Data.Mode := 0;
end;

procedure TMainForm.vstOutputsGetText(Sender : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex;
  TextType : TVSTTextType; var CellText : String);
var
  Data : POutputData;
begin
  Data := vstOutputs.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0 :
        CellText := Data.Name;
      1 :
        CellText := OutputMode[Data^.Mode];
    end;
  end;
end;

procedure TMainForm.vstOutputsKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  if Key = VK_RETURN then
  begin
    vstOutputs.FocusedNode := vstOutputs.GetNext(vstOutputs.FocusedNode);
    if vstOutputs.FocusedNode <> nil then
    begin
      vstOutputs.Selected[vstOutputs.FocusedNode] := True;
      vstOutputs.EditNode(vstOutputs.FocusedNode, 0);
    end;
  end;
end;

procedure TMainForm.vstOutputsMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  Node : PVirtualNode;
  Column : Integer;
begin
  Node := vstOutputs.GetNodeAt(X, Y);
  Column := vstOutputs.Header.Columns.ColumnFromPosition(Point(X, Y));
  if Assigned(Node) then
  begin
    case Column of
      0 :
        if meEditDescription.Checked then
        begin
          vstOutputs.EditNode(Node, Column);
        end;
      1 :
        vstOutputs.EditNode(Node, Column);
    end;
  end;
end;

end.
