unit uParser;
{$I Compilerswitches.inc}

{ TODO : Auskommentierte stellen anpassen }
interface

uses
  Classes,
  SysUtils,
  csCSV,
  ExtCtrls,
  himXML,
  Graphics,
  Generics.Collections,
  uCleanProgParser;

const
  NUM_OF_FILES = 8;
  NUM_OF_LANGS = 3;
  NUM_OF_STEPS = 128;
  NUM_OF_OUTPUTS = 48;
  NUM_OF_INPUTS = 32;
  NUM_OF_INTERVALLS = 2;
  NUM_OF_ANALOG_IN = 8;
  NUM_OF_ANALOG_OUT = 8;

  // CleanProgName1
  PROG_NAME = 'CleanProgName%d';
  // CleanStep_Language1_Name0
  STEP_NAME = 'CleanStep_Language%d_Name%d';
  // Cleaning_Step.udt_cleaning.aby_output1_mode[0]
  OUTPUT_MODE = 'Cleaning_Step.udt_cleaning.aby_output%d_mode[%d]';
  // Cleaning_Step.udt_cleaning.aby_input1[0]
  INPUT_MODE = 'Cleaning_Step.udt_cleaning.aby_input%d[%d]';
  // Cleaning_Step.udt_cleaning.aby_input1_aktiv[0]
  INPUT_AKTIV = 'Cleaning_Step.udt_cleaning.aby_input%d_aktiv[%d]';
  // Cleaning_Step.udt_cleaning.ai_alarm_step[0]
  ALARM_STEP = 'Cleaning_Step.udt_cleaning.ai_alarm_step[%d]';
  // Cleaning_Step.udt_cleaning.ai_condition_alarm[0]
  ALARM_COND = 'Cleaning_Step.udt_cleaning.ai_condition_alarm[%d]';
  // Cleaning_Step.udt_cleaning.ai_condition_next_step[0]
  NEXT_COND = 'Cleaning_Step.udt_cleaning.ai_condition_next_step[%d]';
  // Cleaning_Step.udt_cleaning.ai_control_time[0]
  CONTR_TIME = 'Cleaning_Step.udt_cleaning.ai_control_time[%d]';
  // Cleaning_Step.udt_cleaning.ai_intervall_1[0]
  INTERVALL = 'Cleaning_Step.udt_cleaning.ai_intervall_%d[%d]';
  // Cleaning_Step.udt_cleaning.ai_loops[0]
  LOOPS = 'Cleaning_Step.udt_cleaning.ai_loops[%d]';
  // Cleaning_Step.udt_cleaning.ai_next_step[0]
  NEXT_STEP = 'Cleaning_Step.udt_cleaning.ai_next_step[%d]';
  // Cleaning_Step.udt_cleaning.ai_message[0]
  MESSAGES = 'Cleaning_Step.udt_cleaning.ai_message[%d]';
  // Cleaning_Step.udt_cleaning.ai_pause_1[0]
  PAUSE = 'Cleaning_Step.udt_cleaning.ai_pause_%d[%d]';
  // Cleaning_Step.udt_cleaning.ai_step_time[0]
  STEP_TIME = 'Cleaning_Step.udt_cleaning.ai_step_time[%d]';
  // Cleaning_Step.udt_cleaning.ar_analog_in_1[0]
  ANALOG_IN = 'Cleaning_Step.udt_cleaning.ar_analog_in_%d[%d]';
  // Cleaning_Step.udt_cleaning.ar_analog_out_1[0]
  ANALOG_OUT = 'Cleaning_Step.udt_cleaning.ar_analog_out_%d[%d]';
  // Cleaning_Step.udt_cleaning.ar_mode_ai_1[0]
  ANALOG_MODE = 'Cleaning_Step.udt_cleaning.ar_mode_ai_%d[%d]';

  MESSAGE_LIST_NAME = 'c_Meldeausgabe';
  INPUT_LIST_NAME = 'Clean_Input';
  OUTPUT_LIST_NAME = 'Clean_Output';
  ANALOG_INPUT_LIST_NAME = 'Clean_Analog_Input';
  ANALOG_OUTPUT_LIST_NAME = 'Clean_Analog_Output';
  ANALOG_OUTPUT_UNIT_LIST_NAME = 'Clean_Analog_Output_Unit';

type
  TCleanProgException = class(Exception)

  end;

  TParser = class(TObject)
  protected
    FDelimiter : Char;
    FFormatCount : Integer;
    FCount : Integer;
    FSendCount : Integer;
    FMaxCount : Integer;
    FOnProgress : TProgressEvent;
    FLines : TDictionary<String, TData>;
    FProgram : array of TProgram;
    FRecipeFileName : array [0 .. NUM_OF_FILES - 1] of TRecipeFileName;
    FEntryFolders : TStringList;

    procedure LoadFile(FileName : string; FileIndex : Integer);
    procedure SendProgress();
    procedure ParseProgName(); virtual; abstract;
    procedure ParseStepName();
    procedure ParseOutputMode();
    procedure ParseInputMode();
    procedure ParseInputAktiv();
    procedure ParseIntervall();
    procedure ParsePause();
    procedure ParseAnalogIn();
    procedure ParseAnalogMode();
    procedure ParseAnalogOut();
    procedure ParseAlarmStep();
    procedure ParseAlarmCond();
    procedure ParseNextCond();
    procedure ParseContrTime();
    procedure ParseLoops();
    procedure ParseNextStep();
    procedure ParseMessage();
    procedure ParseStepTime();
  public
    procedure LoadFiles(Files : TStrings);
    property OnProgress : TProgressEvent read FOnProgress write FOnProgress;
  end;

  TSingleStepParser = class(TParser)
  protected
    procedure ParseProgName(); override;
  public
  end;

  TMultipleStepParser = class(TParser)
  protected
    procedure ParseProgName(); override;
  public
  end;

  TExporter = class(TObject)
  protected
    FFormatCount : Integer;
    FCount : Integer;
    FMaxCount : Integer;
    FSendCount : Integer;
    FDelimiter : Char;
    FOnProgress : TProgressEvent;
    FProgram : array of TProgram;
    FRecipeFileName : array [0 .. NUM_OF_FILES - 1] of TRecipeFileName;
    FEntryFolders : TStringList;

    function GetEntryFolder(Index : Integer) : String;
    procedure SendProgress();
  public
    procedure SaveFiles(Folder : string); virtual; abstract;
    property FormatCount : Integer read FFormatCount;
    property OnProgress : TProgressEvent read FOnProgress write FOnProgress;
  end;

  TSingleDatasetExporter = class(TExporter)
    procedure SaveFiles(Folder : string); override;
  end;

  TMultipleDatasetExporter = class(TExporter)
    procedure SaveFiles(Folder : string); override;
  end;

implementation

uses
  StrUtils,
  Windows,
  Math,
  csExplode,
  csUtils;

{ TParser }

procedure TParser.LoadFile(FileName : string; FileIndex : Integer);
var
  csvDataStream : TFileStream;
  csvReader : TCSVReader;
  i : Integer;
  FoundLangID : Boolean;
  s : string;
  Data : TData;
  FolderIndex : Integer;
begin

  csvDataStream := TFileStream.Create(FileName, fmShareDenyWrite);
  csvReader := TCSVReader.Create(csvDataStream, '=');
  csvReader.First;
  FRecipeFileName[FileIndex].FileName := ExtractFileName(FileName);
  if not Assigned(FRecipeFileName[FileIndex].Header) then
  begin
    FRecipeFileName[FileIndex].Header := TStringList.Create;
  end;
  FRecipeFileName[FileIndex].Header.Clear;
  try
    FoundLangID := False;
    while not csvReader.Eof and not FoundLangID do
    begin
      s := '';
      for i := 0 to csvReader.ColumnCount - 1 do
      begin
        s := s + csvReader.Columns[i];
        if i <> csvReader.ColumnCount - 1 then
        begin
          s := s + csvReader.Delimiter;
        end;
      end;
      if csvReader.ColumnCount <> 0 then
      begin
        FRecipeFileName[FileIndex].Header.Add(s);
      end;
      for i := 0 to csvReader.ColumnCount - 1 do
      begin

        if (csvReader.Columns[i] = 'List separator') then
        begin
          FDelimiter := csvReader.Columns[i + 1][1];
          // csvReader.Delimiter := #13;
          csvReader.Delimiter := FDelimiter;
          Break;
        end
        else if AnsiContainsText(csvReader.Columns[i], 'LANGID') then
        begin
          FFormatCount := MAX(FFormatCount, csvReader.ColumnCount - 1);
          FoundLangID := True;
          Break;
        end;
      end;
      csvReader.Next;
    end;

    while not csvReader.Eof do
    begin
      if FoundLangID then
      begin
        s := '';
        for i := 0 to csvReader.ColumnCount - 1 do
        begin
          s := s + csvReader.Columns[i];
          if i <> csvReader.ColumnCount - 1 then
          begin
            s := s + FDelimiter;
          end;
        end;
        FRecipeFileName[FileIndex].Header.Add(s);
      end;
      if csvReader.ColumnCount > 0 then
      begin
        if FoundLangID then
        begin
          if not AnsiContainsText(csvReader.Columns[0], 'LANGID') then
          begin
            FoundLangID := False;
          end;
        end
        else
        begin
          s := '';
          for i := 1 to csvReader.ColumnCount - 1 do
          begin
            s := s + csvReader.Columns[i];
            if i <> csvReader.ColumnCount - 1 then
            begin
              s := s + ';';
            end;
          end;
          FolderIndex := FEntryFolders.Add(ExtractFilePath(csvReader.Columns[0]));
          // Data := TData.Create(s, FileIndex, FolderIndex);
          FLines.Add(ExtractFileName(csvReader.Columns[0]), Data);
        end;
      end;
      csvReader.Next;
    end;

  finally
    FreeAndNil(csvReader);
    FreeAndNil(csvDataStream);
  end;
end;

procedure TParser.LoadFiles(Files : TStrings);
var
  i : Integer;
  Data : TArray<TData>;
begin

  if Files.Count <> NUM_OF_FILES then
  begin
    raise TCleanProgException.CreateFmt('Incorrect File Count is (%d), should be (%d)', [Files.Count, NUM_OF_FILES]);
  end;

  FMaxCount := 0;
  FCount := 0;

  if Assigned(FLines) then
  begin
    FMaxCount := FMaxCount + FLines.Values.Count;
    FSendCount := 100;
    Data := FLines.Values.ToArray;
    for i := 0 to (FLines.Values.Count - 1) do
    begin
      FreeAndNil(Data[i]);
      Inc(FCount);
      SendProgress();
    end;
    FLines.Clear;
  end;

  for i := 0 to NUM_OF_FILES - 1 do
  begin
    if Assigned(FRecipeFileName[i].Header) then
    begin
      FRecipeFileName[i].Header.Clear;
    end;
  end;

  for i := 0 to Files.Count - 1 do
  begin
    LoadFile(Files.Strings[i], i);
  end;

  FMaxCount := FMaxCount + FFormatCount + (NUM_OF_LANGS * NUM_OF_STEPS * FFormatCount) +
    (2 * NUM_OF_INPUTS * NUM_OF_STEPS * FFormatCount) + (2 * NUM_OF_INTERVALLS * NUM_OF_STEPS * FFormatCount) +
    (2 * NUM_OF_ANALOG_IN * NUM_OF_STEPS * FFormatCount) + (NUM_OF_ANALOG_OUT * NUM_OF_STEPS * FFormatCount) +
    (8 * NUM_OF_STEPS * FFormatCount) + (NUM_OF_OUTPUTS * NUM_OF_STEPS * FFormatCount);

  FSendCount := 100;
  SendProgress();

  SetLength(FProgram, FFormatCount);

  ParseProgName();
  ParseStepName();
  ParseOutputMode();
  ParseInputMode();
  ParseInputAktiv();
  ParseIntervall();
  ParsePause();
  ParseAnalogIn();
  ParseAnalogMode();
  ParseAnalogOut();
  ParseAlarmStep();
  ParseAlarmCond();
  ParseNextCond();
  ParseContrTime();
  ParseLoops();
  ParseNextStep();
  ParseMessage();
  ParseStepTime();

  FSendCount := 100;
  SendProgress();
end;

procedure TParser.ParseAlarmCond;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := Format(ALARM_COND, [i]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      for l := 0 to FFormatCount - 1 do
      begin
        FProgram[l].Step[i].AlarmCond.Value := StrToInt(aTemp[l]);
        FProgram[l].Step[i].AlarmCond.EntryFolder := Data.Folder;
        FProgram[l].ModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseAlarmStep;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := Format(ALARM_STEP, [i]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      for l := 0 to FFormatCount - 1 do
      begin
        FProgram[l].Step[i].AlarmStep.Value := StrToInt(aTemp[l]);
        FProgram[l].Step[i].AlarmStep.EntryFolder := Data.Folder;
        FProgram[l].ModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseAnalogIn;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, k, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_ANALOG_IN - 1 do
    begin
      for k := 0 to NUM_OF_STEPS - 1 do
      begin
        s := Format(ANALOG_IN, [i + 1, k]);
        if not FLines.TryGetValue(s, Data) then
        begin
          raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
        end;
        // Divider.Explode(Data.Data, aTemp);
        for l := 0 to FFormatCount - 1 do
        begin
          FProgram[l].Step[k].AnalogIn[i].Value.Value := StrToFloat(aTemp[l]);
          FProgram[l].Step[k].AnalogIn[i].Value.EntryFolder := Data.Folder;
          FProgram[l].AnalogInFile := Data.FileIndex;
          Inc(FCount);
          SendProgress;
        end;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseAnalogMode;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, k, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_ANALOG_IN - 1 do
    begin
      for k := 0 to NUM_OF_STEPS - 1 do
      begin
        s := Format(ANALOG_MODE, [i + 1, k]);
        if not FLines.TryGetValue(s, Data) then
        begin
          raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
        end;
        // Divider.Explode(Data.Data, aTemp);
        for l := 0 to FFormatCount - 1 do
        begin
          FProgram[l].Step[k].AnalogIn[i].Mode.Value := StrToFloat(aTemp[l]);
          FProgram[l].Step[k].AnalogIn[i].Mode.EntryFolder := Data.Folder;
          FProgram[l].AnalogInFile := Data.FileIndex;
          Inc(FCount);
          SendProgress;
        end;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseAnalogOut;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, k, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;

    for i := 0 to NUM_OF_ANALOG_OUT - 1 do
    begin
      for k := 0 to NUM_OF_STEPS - 1 do
      begin
        s := Format(ANALOG_OUT, [i + 1, k]);
        if not FLines.TryGetValue(s, Data) then
        begin
          raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
        end;
        // Divider.Explode(Data.Data, aTemp);
        for l := 0 to FFormatCount - 1 do
        begin
          FProgram[l].Step[k].AnalogOut[i].Value := StrToFloat(aTemp[l]);
          FProgram[l].Step[k].AnalogOut[i].EntryFolder := Data.Folder;
          FProgram[l].AnalogOutFile := Data.FileIndex;
          Inc(FCount);
          SendProgress;
        end;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseContrTime;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := Format(CONTR_TIME, [i]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      for l := 0 to FFormatCount - 1 do
      begin
        FProgram[l].Step[i].ContrTime.Value := StrToInt(aTemp[l]);
        FProgram[l].Step[i].ContrTime.EntryFolder := Data.Folder;
        FProgram[l].ModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseInputAktiv;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, k, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_INPUTS - 1 do
    begin
      for k := 0 to NUM_OF_STEPS - 1 do
      begin
        s := Format(INPUT_AKTIV, [i + 1, k]);
        if not FLines.TryGetValue(s, Data) then
        begin
          raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
        end;
        // Divider.Explode(Data.Data, aTemp);
        for l := 0 to FFormatCount - 1 do
        begin
          FProgram[l].Step[k].Input[i].Aktiv.Value := aTemp[l] = '1';
          FProgram[l].Step[k].Input[i].Aktiv.EntryFolder := Data.Folder;
          FProgram[l].InputAktivFile := Data.FileIndex;
          Inc(FCount);
          SendProgress;
        end;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseInputMode;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, k, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_INPUTS - 1 do
    begin
      for k := 0 to NUM_OF_STEPS - 1 do
      begin
        s := Format(INPUT_MODE, [i + 1, k]);
        if not FLines.TryGetValue(s, Data) then
        begin
          raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
        end;
        // Divider.Explode(Data.Data, aTemp);
        for l := 0 to FFormatCount - 1 do
        begin
          FProgram[l].Step[k].Input[i].Mode.Value := aTemp[l] = '1';
          FProgram[l].Step[k].Input[i].Mode.EntryFolder := Data.Folder;
          FProgram[l].InputModeFile := Data.FileIndex;
          Inc(FCount);
          SendProgress;
        end;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseIntervall;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, k, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_INTERVALLS - 1 do
    begin
      for k := 0 to NUM_OF_STEPS - 1 do
      begin
        s := Format(INTERVALL, [i + 1, k]);
        if not FLines.TryGetValue(s, Data) then
        begin
          raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
        end;
        // Divider.Explode(Data.Data, aTemp);
        for l := 0 to FFormatCount - 1 do
        begin
          FProgram[l].Step[k].INTERVALL[i].INTERVALL.Value := StrToInt(aTemp[l]);
          FProgram[l].Step[k].INTERVALL[i].INTERVALL.EntryFolder := Data.Folder;
          FProgram[l].IntervallFile := Data.FileIndex;
          Inc(FCount);
          SendProgress;
        end;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseLoops;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := Format(LOOPS, [i]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      for l := 0 to FFormatCount - 1 do
      begin
        FProgram[l].Step[i].LOOPS.Value := StrToInt(aTemp[l]);
        FProgram[l].Step[i].LOOPS.EntryFolder := Data.Folder;
        FProgram[l].ModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseMessage;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := Format(MESSAGES, [i]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      for l := 0 to FFormatCount - 1 do
      begin
        FProgram[l].Step[i].Message.Value := StrToInt(aTemp[l]);
        FProgram[l].Step[i].Message.EntryFolder := Data.Folder;
        FProgram[l].ModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseNextCond;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := Format(NEXT_COND, [i]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      for l := 0 to FFormatCount - 1 do
      begin
        FProgram[l].Step[i].NextCond.Value := StrToInt(aTemp[l]);
        FProgram[l].Step[i].NextCond.EntryFolder := Data.Folder;
        FProgram[l].ModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseNextStep;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := Format(NEXT_STEP, [i]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      for l := 0 to FFormatCount - 1 do
      begin
        FProgram[l].Step[i].NextStep.Value := StrToInt(aTemp[l]);
        FProgram[l].Step[i].NextStep.EntryFolder := Data.Folder;
        FProgram[l].ModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseOutputMode;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, k, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_OUTPUTS - 1 do
    begin
      for k := 0 to NUM_OF_STEPS - 1 do
      begin
        s := Format(OUTPUT_MODE, [i + 1, k]);
        if not FLines.TryGetValue(s, Data) then
        begin
          raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
        end;
        // Divider.Explode(Data.Data, aTemp);
        for l := 0 to FFormatCount - 1 do
        begin
          FProgram[l].Step[k].OutputMode[i].Value := StrToInt(aTemp[l]);
          FProgram[l].Step[k].OutputMode[i].EntryFolder := Data.Folder;
          FProgram[l].OutputModeFile := Data.FileIndex;
          Inc(FCount);
          SendProgress;
        end;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParsePause;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, k, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_INTERVALLS - 1 do
    begin
      for k := 0 to NUM_OF_STEPS - 1 do
      begin
        s := Format(PAUSE, [i + 1, k]);
        if not FLines.TryGetValue(s, Data) then
        begin
          raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
        end;
        // Divider.Explode(Data.Data, aTemp);
        for l := 0 to FFormatCount - 1 do
        begin
          FProgram[l].Step[k].INTERVALL[i].PAUSE.Value := StrToInt(aTemp[l]);
          FProgram[l].Step[k].INTERVALL[i].PAUSE.EntryFolder := Data.Folder;
          FProgram[l].IntervallFile := Data.FileIndex;
          Inc(FCount);
          SendProgress;
        end;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseStepName;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, k, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_LANGS - 1 do
    begin
      for k := 0 to NUM_OF_STEPS - 1 do
      begin
        s := Format(STEP_NAME, [i + 1, k]);
        if not FLines.TryGetValue(s, Data) then
        begin
          raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
        end;
        // Divider.Explode(Data.Data, aTemp);
        for l := 0 to FFormatCount - 1 do
        begin
          FProgram[l].Step[k].Name[i].Value := aTemp[l];
          FProgram[l].Step[k].Name[i].EntryFolder := Data.Folder;
          FProgram[l].StepNameFile[i] := Data.FileIndex;
          Inc(FCount);
          SendProgress;
        end;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.ParseStepTime;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i, l : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := Format(STEP_TIME, [i]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      for l := 0 to FFormatCount - 1 do
      begin
        FProgram[l].Step[i].Time.Value := StrToInt(aTemp[l]);
        FProgram[l].Step[i].Time.EntryFolder := Data.Folder;
        FProgram[l].ModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

procedure TParser.SendProgress;
begin
  Inc(FSendCount);
  if Assigned(FOnProgress) and (FSendCount >= 10) then
  begin
    FOnProgress(Self, (FCount * 100) / FMaxCount);
    FSendCount := 0;
  end;
end;

{ TSingleStepParser }

procedure TSingleStepParser.ParseProgName;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to FFormatCount - 1 do
    begin
      s := Format(PROG_NAME, [i + 1]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      if Divider.Count >= 1 then
      begin
        FProgram[i].Name.Value := aTemp[0];
        FProgram[i].Name.EntryFolder := Data.Folder;
      end
      else
      begin
        FProgram[i].Name.Value := '';
        FProgram[i].Name.EntryFolder := Data.Folder;
      end;
      FProgram[i].NameFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  finally
    FreeAndNil(Divider);
  end;
end;

{ TMultipleStepParser }

procedure TMultipleStepParser.ParseProgName;
var
  aTemp : csExplode.TStringDynArray;
  Divider : TStringDivider;
  i : Integer;
  s : string;
  Data : TData;
begin
  Divider := TStringDivider.Create;
  try
    Divider.Pattern := FDelimiter;
    for i := 0 to FFormatCount - 1 do
    begin
      s := Format(PROG_NAME, [i + 1]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      // Divider.Explode(Data.Data, aTemp);
      if Divider.Count >= i + 1 then
      begin
        FProgram[i].Name.Value := aTemp[i];
        FProgram[i].Name.EntryFolder := Data.Folder;
      end
      else
      begin
        FProgram[i].Name.Value := '';
        FProgram[i].Name.EntryFolder := Data.Folder;
      end;
      FProgram[i].NameFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;

    end;
  finally
    FreeAndNil(Divider);
  end;
end;

{ TMultipleDatasetExporter }

procedure TMultipleDatasetExporter.SaveFiles(Folder : string);
var
  i, j, lastCreated : Integer;
  s : string;
  k : Integer;
  RecipeFiles : array [0 .. NUM_OF_FILES - 1] of TStringList;
const
  cSimpleBoolStrs : array [Boolean] of string = ('0', '1');
begin
  lastCreated := 0;
  try
    for i := 0 to NUM_OF_FILES - 1 do
    begin
      RecipeFiles[i] := TStringList.Create;
      lastCreated := i;
      RecipeFiles[i].AddStrings(FRecipeFileName[i].Header);
    end;

    for i := 0 to FormatCount - 1 do
    begin
      s := GetEntryFolder(FProgram[i].Name.EntryFolder);
      s := s + Format(PROG_NAME, [i + 1]);
      // Eigentlich nicht ganz richtig aber Flexible verlangt es so
      for j := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + FProgram[i].Name.Value;
      end;
      RecipeFiles[FProgram[i].NameFile].Add(s);
    end;

    for i := 0 to NUM_OF_LANGS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Name[i].EntryFolder);
        s := s + Format(STEP_NAME, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + FProgram[k].Step[j].Name[i].Value;
        end;
        RecipeFiles[FProgram[0].StepNameFile[i]].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_OUTPUTS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].OutputMode[i].EntryFolder);
        s := s + Format(OUTPUT_MODE, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].OutputMode[i].Value);
        end;
        RecipeFiles[FProgram[0].OutputModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_INPUTS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Input[i].Mode.EntryFolder);
        s := s + Format(INPUT_MODE, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FProgram[k].Step[j].Input[i].Mode.Value];
        end;
        RecipeFiles[FProgram[0].InputModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_INPUTS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Input[i].Aktiv.EntryFolder);
        s := s + Format(INPUT_AKTIV, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FProgram[k].Step[j].Input[i].Aktiv.Value];
        end;
        RecipeFiles[FProgram[0].InputAktivFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].AlarmStep.EntryFolder);
      s := s + Format(ALARM_STEP, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].AlarmStep.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].AlarmCond.EntryFolder);
      s := s + Format(ALARM_COND, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].AlarmCond.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].NextCond.EntryFolder);
      s := s + Format(NEXT_COND, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].NextCond.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].ContrTime.EntryFolder);
      s := s + Format(CONTR_TIME, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].ContrTime.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_INTERVALLS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].INTERVALL[i].INTERVALL.EntryFolder);
        s := s + Format(INTERVALL, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].INTERVALL[i].INTERVALL.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].LOOPS.EntryFolder);
      s := s + Format(LOOPS, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].LOOPS.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].NextStep.EntryFolder);
      s := s + Format(NEXT_STEP, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].NextStep.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].Message.EntryFolder);
      s := s + Format(MESSAGES, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].Message.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_INTERVALLS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].INTERVALL[i].PAUSE.EntryFolder);
        s := s + Format(PAUSE, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].INTERVALL[i].PAUSE.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].Time.EntryFolder);
      s := s + Format(STEP_TIME, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].Time.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_ANALOG_IN - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogIn[i].Value.EntryFolder);
        s := s + Format(ANALOG_IN, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogIn[i].Value.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_ANALOG_IN - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogIn[i].Mode.EntryFolder);
        s := s + Format(ANALOG_MODE, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogIn[i].Mode.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_ANALOG_OUT - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogOut[i].EntryFolder);
        s := s + Format(ANALOG_OUT, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogOut[i].Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    s := FRecipeFileName[FProgram[0].NameFile].FileName;
    RecipeFiles[FProgram[0].NameFile].SaveToFile(Folder + s);
    for i := 0 to NUM_OF_LANGS - 1 do
    begin
      s := FRecipeFileName[FProgram[0].StepNameFile[i]].FileName;
      RecipeFiles[FProgram[0].StepNameFile[i]].SaveToFile(Folder + s);
    end;
    s := FRecipeFileName[FProgram[0].OutputModeFile].FileName;
    RecipeFiles[FProgram[0].OutputModeFile].SaveToFile(Folder + s);
    s := FRecipeFileName[FProgram[0].InputModeFile].FileName;
    RecipeFiles[FProgram[0].InputModeFile].SaveToFile(Folder + s);
    s := FRecipeFileName[FProgram[0].InputAktivFile].FileName;
    RecipeFiles[FProgram[0].InputAktivFile].SaveToFile(Folder + s);
    s := FRecipeFileName[FProgram[0].ModeFile].FileName;
    RecipeFiles[FProgram[0].ModeFile].SaveToFile(Folder + s);
  finally
    for i := 0 to lastCreated do
    begin
      FreeAndNil(RecipeFiles[i]);
    end;
  end;
end;

{ TSingleDatasetExporter }

procedure TSingleDatasetExporter.SaveFiles(Folder : string);
var
  i, j, lastCreated : Integer;
  s : string;
  k : Integer;
  RecipeFiles : array [0 .. NUM_OF_FILES - 1] of TStringList;
const
  cSimpleBoolStrs : array [Boolean] of string = ('0', '1');
begin
  lastCreated := 0;
  try
    for i := 0 to NUM_OF_FILES - 1 do
    begin
      RecipeFiles[i] := TStringList.Create;
      lastCreated := i;
      RecipeFiles[i].AddStrings(FRecipeFileName[i].Header);
    end;

    for i := 0 to FormatCount - 1 do
    begin
      s := GetEntryFolder(FProgram[i].Name.EntryFolder);
      s := s + Format(PROG_NAME, [i + 1]);
      s := s + FDelimiter + FProgram[i].Name.Value;
      RecipeFiles[FProgram[i].NameFile].Add(s);
    end;

    for i := 0 to NUM_OF_LANGS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Name[i].EntryFolder);
        s := s + Format(STEP_NAME, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + FProgram[k].Step[j].Name[i].Value;
        end;
        RecipeFiles[FProgram[0].StepNameFile[i]].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_OUTPUTS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].OutputMode[i].EntryFolder);
        s := s + Format(OUTPUT_MODE, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].OutputMode[i].Value);
        end;
        RecipeFiles[FProgram[0].OutputModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_INPUTS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Input[i].Mode.EntryFolder);
        s := s + Format(INPUT_MODE, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FProgram[k].Step[j].Input[i].Mode.Value];
        end;
        RecipeFiles[FProgram[0].InputModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_INPUTS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Input[i].Aktiv.EntryFolder);
        s := s + Format(INPUT_AKTIV, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FProgram[k].Step[j].Input[i].Aktiv.Value];
        end;
        RecipeFiles[FProgram[0].InputAktivFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].AlarmStep.EntryFolder);
      s := s + Format(ALARM_STEP, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].AlarmStep.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].AlarmCond.EntryFolder);
      s := s + Format(ALARM_COND, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].AlarmCond.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].NextCond.EntryFolder);
      s := s + Format(NEXT_COND, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].NextCond.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].ContrTime.EntryFolder);
      s := s + Format(CONTR_TIME, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].ContrTime.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_INTERVALLS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].INTERVALL[i].INTERVALL.EntryFolder);
        s := s + Format(INTERVALL, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].INTERVALL[i].INTERVALL.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].LOOPS.EntryFolder);
      s := s + Format(LOOPS, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].LOOPS.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].NextStep.EntryFolder);
      s := s + Format(NEXT_STEP, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].NextStep.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].Message.EntryFolder);
      s := s + Format(MESSAGES, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].Message.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_INTERVALLS - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].INTERVALL[i].PAUSE.EntryFolder);
        s := s + Format(PAUSE, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].INTERVALL[i].PAUSE.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_STEPS - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].Time.EntryFolder);
      s := s + Format(STEP_TIME, [i]);
      for k := 0 to FormatCount - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].Time.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to NUM_OF_ANALOG_IN - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogIn[i].Value.EntryFolder);
        s := s + Format(ANALOG_IN, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogIn[i].Value.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_ANALOG_IN - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogIn[i].Mode.EntryFolder);
        s := s + Format(ANALOG_MODE, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogIn[i].Mode.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to NUM_OF_ANALOG_OUT - 1 do
    begin
      for j := 0 to NUM_OF_STEPS - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogOut[i].EntryFolder);
        s := s + Format(ANALOG_OUT, [i + 1, j]);
        for k := 0 to FormatCount - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogOut[i].Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    s := FRecipeFileName[FProgram[0].NameFile].FileName;
    RecipeFiles[FProgram[0].NameFile].SaveToFile(Folder + s);
    for i := 0 to NUM_OF_LANGS - 1 do
    begin
      s := FRecipeFileName[FProgram[0].StepNameFile[i]].FileName;
      RecipeFiles[FProgram[0].StepNameFile[i]].SaveToFile(Folder + s);
    end;
    s := FRecipeFileName[FProgram[0].OutputModeFile].FileName;
    RecipeFiles[FProgram[0].OutputModeFile].SaveToFile(Folder + s);
    s := FRecipeFileName[FProgram[0].InputModeFile].FileName;
    RecipeFiles[FProgram[0].InputModeFile].SaveToFile(Folder + s);
    s := FRecipeFileName[FProgram[0].InputAktivFile].FileName;
    RecipeFiles[FProgram[0].InputAktivFile].SaveToFile(Folder + s);
    s := FRecipeFileName[FProgram[0].ModeFile].FileName;
    RecipeFiles[FProgram[0].ModeFile].SaveToFile(Folder + s);
  finally
    for i := 0 to lastCreated do
    begin
      FreeAndNil(RecipeFiles[i]);
    end;
  end;
end;

{ TExporter }

function TExporter.GetEntryFolder(Index : Integer) : String;
begin
  if (Index <> - 1) and (Index <= FEntryFolders.Count - 1) then
  begin
    Result := FEntryFolders.Strings[Index];
  end
  else
  begin
    Result := '';
  end;
end;

procedure TExporter.SendProgress;
begin
  Inc(FSendCount);
  if Assigned(FOnProgress) and (FSendCount >= 10) then
  begin
    FOnProgress(Self, (FCount * 100) / FMaxCount);
    FSendCount := 0;
  end;
end;

end.
