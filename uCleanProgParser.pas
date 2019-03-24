unit uCleanProgParser;
{ TODO : Export nach Datensatzanzahl }
{ TODO : Programmnamen Export nach Datensatzanzahl Programmnamen }
{$I Compilerswitches.inc}

interface

uses
  Classes,
  SysUtils,
  csCSV,
  ExtCtrls,
  himXML,
  Graphics,
  Generics.Collections,
  CodeSiteLogging;

type

  TProgressEvent = procedure(Sender : TObject; Progress : Real) of object;
  TSelectLangIndexEvent = procedure(Sender : TObject; LangDesc : TStringList; out Indizes : TList<Integer>) of object;

  TCleanProgException = class(Exception)

  end;

  TRawValue = record
    Value : string;
    FormatIndex : Integer;
  end;

  TData = class(TObject)
  private
    FData : TList<TRawValue>;
    FFileIndex : Integer;
    FFolder : Integer;
  public
    constructor Create(Data : TList<TRawValue>; FileIndex : Integer; Folder : Integer);
    property Data : TList<TRawValue>read FData;
    property FileIndex : Integer read FFileIndex;
    property Folder : Integer read FFolder;
    destructor Destroy(); override;
  end;

  TValue<T> = record
    Value : T;
    EntryFolder : Integer;
  end;

  TInput = record
    Mode : TValue<Boolean>;
    Aktiv : TValue<Boolean>;
  end;

  TIntervall = record
    INTERVALL : TValue<Integer>;
    PAUSE : TValue<Integer>;
  end;

  TAnalogIn = record
    Value : TValue<Real>;
    Mode : TValue<Real>;
  end;

  TRecipeFileName = record
    FileName : string;
    Header : TStringList;
  end;

  TStep = record
    Name : array of TValue<string>;
    OutputMode : array of TValue<Integer>;
    Input : array of TInput;
    INTERVALL : array of TIntervall;
    AnalogIn : array of TAnalogIn;
    AnalogOut : array of TValue<Real>;
    AlarmStep : TValue<Integer>;
    AlarmCond : TValue<Integer>;
    NextCond : TValue<Integer>;
    ContrTime : TValue<Integer>;
    LOOPS : TValue<Integer>;
    NextStep : TValue<Integer>;
    Message : TValue<Integer>;
    Time : TValue<Integer>;
  public
    function Copy() : TStep;
  end;

  TDescription = record
    Output : array of string;
    Input : array of string;
    AnalogIn : array of string;
    AnalogOut : array of string;
    AnalogOutUnit : array of string;
    Message : TStringList;
  end;

  TProgram = record
    Name : TValue<string>;
    Step : array of TStep;
    NameFile : Integer;
    StepNameFile : array of Integer;
    OutputModeFile : Integer;
    InputModeFile : Integer;
    InputAktivFile : Integer;
    IntervallFile : Integer;
    AnalogInFile : Integer;
    AnalogOutFile : Integer;
    ModeFile : Integer;
  end;

  TProgramNameMode = (pnmSingleDataSet, pnmMultipleDataSets);

  TSettings = class(TObject)
  protected const
    FILE_VERSION_KEY = 'FileVersion';

    DATA_SET_MODE_KEY = 'ProgNameMode';

    NUM_OF_FILES_KEY = 'NumberOfFiles';
    NUM_OF_PROGS_KEY = 'NumberOfPrograms';
    NUM_OF_LANGS_KEY = 'NumberOfLanguages';
    NUM_OF_STEPS_KEY = 'NumberOfSteps';
    NUM_OF_OUTPUTS_KEY = 'NumberOfOutputs';
    NUM_OF_INPUTS_KEY = 'NumberOfInputs';
    NUM_OF_INTERVALLS_KEY = 'NumberOfIntervalls';
    NUM_OF_ANALOG_IN_KEY = 'NumberOfAnalogInputs';
    NUM_OF_ANALOG_OUT_KEY = 'NumberOfAnalogOutputs';

    PROG_NAME_KEY = 'ProgramName';
    STEP_NAME_KEY = 'StepName';
    OUTPUT_MODE_KEY = 'OutputMode';
    INPUT_MODE_KEY = 'InputMode';
    INPUT_AKTIV_KEY = 'InputActive';
    ALARM_STEP_KEY = 'AlarmStep';
    ALARM_COND_KEY = 'AlarmCondition';
    NEXT_COND_KEY = 'NextCondition';
    CONTR_TIME_KEY = 'ControlTime';
    INTERVALL_KEY = 'Intervall';
    LOOPS_KEY = 'Loops';
    NEXT_STEP_KEY = 'NextStep';
    MESSAGES_KEY = 'Messages';
    PAUSE_KEY = 'Pause';
    STEP_TIME_KEY = 'StepTime';
    ANALOG_IN_KEY = 'AnalogIn';
    ANALOG_OUT_KEY = 'AnalogOut';
    ANALOG_MODE_KEY = 'AnalogMode';

    MESSAGE_LIST_NAME_KEY = 'MessageListName';
    INPUT_LIST_NAME_KEY = 'InputListName';
    OUTPUT_LIST_NAME_KEY = 'OutputListName';
    ANALOG_INPUT_LIST_NAME_KEY = 'AnalogInputListName';
    ANALOG_OUTPUT_LIST_NAME_KEY = 'AnalogOutputListName';
    ANALOG_OUTPUT_UNIT_LIST_NAME_KEY = 'AnalogOutputUnitListName';
  protected
    FMessages : String;
    FNumOfProgs : Integer;
    FProgName : String;
    FNumOfAnalogOut : Integer;
    FNumOfOutputs : Integer;
    FAnalogInputListName : String;
    FNumOfIntervalls : Integer;
    FMessageListName : String;
    FPause : String;
    FNumOfAnalogIn : Integer;
    FNumOfInputs : Integer;
    FDataSetNameMode : TProgramNameMode;
    FNumOfSteps : Integer;
    FAnalogOut : String;
    FNumOfLangs : Integer;
    FNumOfFiles : Integer;
    FStepTime : String;
    FOutputListName : String;
    FAnalogMode : String;
    FAnalogIn : String;
    FAlarmCond : String;
    FAlarmStep : String;
    FInputListName : String;
    FIntervall : String;
    FContrTime : String;
    FOutputMode : String;
    FNextStep : String;
    FNextCond : String;
    FAnalogOutputUnitListName : String;
    FAnalogOutputListName : String;
    FInputAktiv : String;
    FStepName : String;
    FLoops : String;
    FInputMode : String;
    procedure SetNumOfProgs(const Value : Integer);
    procedure SetAlarmCond(const Value : String);
    procedure SetAlarmStep(const Value : String);
    procedure SetAnalogIn(const Value : String);
    procedure SetAnalogInputListName(const Value : String);
    procedure SetAnalogMode(const Value : String);
    procedure SetAnalogOut(const Value : String);
    procedure SetAnalogOutputListName(const Value : String);
    procedure SetAnalogOutputUnitListName(const Value : String);
    procedure SetContrTime(const Value : String);
    procedure SetDataSetNameMode(const Value : TProgramNameMode);
    procedure SetInputAktiv(const Value : String);
    procedure SetInputListName(const Value : String);
    procedure SetInputMode(const Value : String);
    procedure SetIntervall(const Value : String);
    procedure SetLoops(const Value : String);
    procedure SetMessageListName(const Value : String);
    procedure SetMessages(const Value : String);
    procedure SetNextCond(const Value : String);
    procedure SetNextStep(const Value : String);
    procedure SetNumOfAnalogIn(const Value : Integer);
    procedure SetNumOfAnalogOut(const Value : Integer);
    procedure SetNumOfFiles(const Value : Integer);
    procedure SetNumOfInputs(const Value : Integer);
    procedure SetNumOfIntervalls(const Value : Integer);
    procedure SetNumOfLangs(const Value : Integer);
    procedure SetNumOfOutputs(const Value : Integer);
    procedure SetNumOfSteps(const Value : Integer);
    procedure SetOutputListName(const Value : String);
    procedure SetOutputMode(const Value : String);
    procedure SetPause(const Value : String);
    procedure SetProgName(const Value : String);
    procedure SetStepName(const Value : String);
    procedure SetStepTime(const Value : String);

  public
    property DataSetNameMode : TProgramNameMode read FDataSetNameMode write SetDataSetNameMode;

    property NumOfFiles : Integer read FNumOfFiles write SetNumOfFiles;
    property NumOfProgs : Integer read FNumOfProgs write SetNumOfProgs;
    property NumOfLangs : Integer read FNumOfLangs write SetNumOfLangs;
    property NumOfSteps : Integer read FNumOfSteps write SetNumOfSteps;
    property NumOfOutputs : Integer read FNumOfOutputs write SetNumOfOutputs;
    property NumOfInputs : Integer read FNumOfInputs write SetNumOfInputs;
    property NumOfIntervalls : Integer read FNumOfIntervalls write SetNumOfIntervalls;
    property NumOfAnalogIn : Integer read FNumOfAnalogIn write SetNumOfAnalogIn;
    property NumOfAnalogOut : Integer read FNumOfAnalogOut write SetNumOfAnalogOut;

    property ProgName : String read FProgName write SetProgName;
    property StepName : String read FStepName write SetStepName;
    property OutputMode : String read FOutputMode write SetOutputMode;
    property InputMode : String read FInputMode write SetInputMode;
    property InputAktiv : String read FInputAktiv write SetInputAktiv;
    property AlarmStep : String read FAlarmStep write SetAlarmStep;
    property AlarmCond : String read FAlarmCond write SetAlarmCond;
    property NextCond : String read FNextCond write SetNextCond;
    property ContrTime : String read FContrTime write SetContrTime;
    property INTERVALL : String read FIntervall write SetIntervall;
    property LOOPS : String read FLoops write SetLoops;
    property NextStep : String read FNextStep write SetNextStep;
    property MESSAGES : String read FMessages write SetMessages;
    property PAUSE : String read FPause write SetPause;
    property StepTime : String read FStepTime write SetStepTime;
    property AnalogIn : String read FAnalogIn write SetAnalogIn;
    property AnalogOut : String read FAnalogOut write SetAnalogOut;
    property AnalogMode : String read FAnalogMode write SetAnalogMode;

    property MessageListName : String read FMessageListName write SetMessageListName;
    property InputListName : String read FInputListName write SetInputListName;
    property OutputListName : String read FOutputListName write SetOutputListName;
    property AnalogInputListName : String read FAnalogInputListName write SetAnalogInputListName;
    property AnalogOutputListName : String read FAnalogOutputListName write SetAnalogOutputListName;
    property AnalogOutputUnitListName : String read FAnalogOutputUnitListName write SetAnalogOutputUnitListName;

    constructor Create();
    procedure LoadFromFile(sFileName : string);
  end;

  TCleanProgParser = class(TObject)
  protected
    FSettings : TSettings;
    FPicture : TPicture;
    FPictureExtension : string;
    FDataSetCount : Integer;
    FCount : Integer;
    FMaxCount : Integer;
    FSendCount : Integer;
    FSelectedProgram : Integer;
    FLanguage : Integer;
    FDelimiter : Char;
    FLines : TDictionary<String, TData>;
    FOnProgress : TProgressEvent;
    FOnSelectLangIndex : TSelectLangIndexEvent;
    FStepBuffer : TStep;
    FProgram : array of TProgram;
    FDescription : array of TDescription;
    FRecipeFileName : array of TRecipeFileName;
    FEntryFolders : TStringList;

    procedure LoadFile(FileName : string; FileIndex : Integer);
    procedure LoadXMLV10(XML : TXMLFile);
    procedure LoadXMLV11(XML : TXMLFile);
    procedure LoadXMLV12(XML : TXMLFile);
    procedure SendProgress();
    procedure ParseProgName(); virtual;
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
    function GetStepCount : Integer;
    function GetStep(index : Integer) : TStep;
    procedure SetStep(index : Integer; const Value : TStep);
    function GetProgramName : string;
    procedure SetProgramName(const Value : string);
    procedure SetSelectedProgram(const Value : Integer);
    function GetDescription : TDescription;
    procedure SetDescription(const Value : TDescription);
    function GetSelectedProgram : Integer;
    function GetLanguage : Integer;
    procedure SetLanguage(const Value : Integer);
    function GetStepName(index : Integer) : string;
    procedure SetStepName(index : Integer; const Value : string);
  public
    constructor Create(Settings : TSettings);
    destructor Destroy(); override;
    procedure LoadFiles(Files : TStrings);
    procedure SaveFiles(Folder : string); virtual;
    procedure LoadDescription(DescFile : String);
    procedure CopyStep(Index : Integer);
    procedure InsertStep(Index : Integer);
    procedure CutStep(Index : Integer);
    procedure LoadFromXML(FileName : string);
    procedure SaveAsXML(FileName : string);
    procedure CopyProgram(Target : Integer);
    property Settings : TSettings read FSettings write FSettings;
    property OnProgress : TProgressEvent read FOnProgress write FOnProgress;
    property OnSelectLangIndex : TSelectLangIndexEvent read FOnSelectLangIndex write FOnSelectLangIndex;
    property StepCount : Integer read GetStepCount;
    property SelectedProgram : Integer read GetSelectedProgram write SetSelectedProgram;
    property Step[index : Integer] : TStep read GetStep write SetStep;
    property StepName[index : Integer] : string read GetStepName write SetStepName;
    property Description : TDescription read GetDescription write SetDescription;
    property ProgramName : string read GetProgramName write SetProgramName;
    property Language : Integer read GetLanguage write SetLanguage;
    property Picture : TPicture read FPicture write FPicture;
    property PictureExtension : string read FPictureExtension write FPictureExtension;
  end;

  TCleanProgParserSingleDatasetName = class(TCleanProgParser)
  protected
    procedure ParseProgName(); override;
  public
    procedure SaveFiles(Folder : String); override;
  end;

implementation

uses
  StrUtils,
  Windows,
  Math,
  csExplode,
  csUtils,
  ShlObj;

{ TCleanProgParser }

procedure TCleanProgParser.CopyProgram(Target : Integer);
var
  i : Integer;
begin
  if not InRange(Target, 1, Settings.NumOfProgs) then
  begin
    raise TCleanProgException.CreateFmt('Selected target Out of Range Min: %d, Max: %d, Is: %d',
      [1, Settings.NumOfProgs, Target]);
  end;
  FProgram[Target - 1].Name := FProgram[FSelectedProgram].Name;
  for i := low(FProgram[FSelectedProgram].Step) to high(FProgram[FSelectedProgram].Step) do
  begin
    FProgram[Target - 1].Step[i] := FProgram[FSelectedProgram].Step[i].Copy;
  end;
  FProgram[Target - 1].NameFile := FProgram[FSelectedProgram].NameFile;
  FProgram[Target - 1].StepNameFile := System.Copy(FProgram[FSelectedProgram].StepNameFile);
  FProgram[Target - 1].OutputModeFile := FProgram[FSelectedProgram].OutputModeFile;
  FProgram[Target - 1].InputModeFile := FProgram[FSelectedProgram].InputModeFile;
  FProgram[Target - 1].InputAktivFile := FProgram[FSelectedProgram].InputAktivFile;
  FProgram[Target - 1].IntervallFile := FProgram[FSelectedProgram].IntervallFile;
  FProgram[Target - 1].AnalogInFile := FProgram[FSelectedProgram].AnalogInFile;
  FProgram[Target - 1].AnalogOutFile := FProgram[FSelectedProgram].AnalogOutFile;
  FProgram[Target - 1].ModeFile := FProgram[FSelectedProgram].ModeFile;
end;

procedure TCleanProgParser.LoadXMLV10(XML : TXMLFile);
var
  k : Integer;
  Stream : TFileStream;
  s : string;
  j : Integer;
  i : Integer;
begin
  FSelectedProgram := XML.Node['SelectedProgram'].Attribute['Value'];
  FLanguage := XML.Node['Language'].Attribute['Value'];
  s := XML.Node['Delimiter'].Attribute['Value'];
  FDelimiter := s[1];
  with XML.Node['RecipeFileNames'] do
  begin
    for i := 0 to Nodes.Count - 1 do
    begin
      with Node['FileName_' + IntToStr(i)] do
      begin
        FRecipeFileName[i].FileName := Attribute['FileName'];
        if not Assigned(FRecipeFileName[i].Header) then
        begin
          FRecipeFileName[i].Header := TStringList.Create;
        end;
        FRecipeFileName[i].Header.Clear;
        for j := 0 to Attribute['LineCount'] - 1 do
        begin
          FRecipeFileName[i].Header.Add(Node['Line_' + IntToStr(j)].Text_S);
        end;
      end;
    end;
  end;

  with XML.Node['Descriptions'] do
  begin
    for i := 0 to Nodes.Count - 1 do
    begin
      FDescription[i].Message.Clear;
      with Node['Language_' + IntToStr(i)] do
      begin
        with Node['Outputs'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].Output[j] := Node['Output_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['Inputs'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].Input[j] := Node['Input_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['AnalogIns'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].AnalogIn[j] := Node['AnalogIn_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['AnalogOuts'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].AnalogOut[j] := Node['AnalogOut_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['Messages'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].Message.Add(Node['Message_' + IntToStr(j)].Text_S);
          end;
        end;
      end;
    end;
  end;

  with XML.Node['Programs'] do
  begin
    Settings.NumOfProgs := Attributes['Count'];
    SetLength(FProgram, Settings.NumOfProgs);
    for i := 0 to Settings.NumOfProgs - 1 do
    begin
      with Node['Program_' + IntToStr(i)] do
      begin
        FProgram[i].Name.Value := Attribute['Name'];
        FProgram[i].Name.EntryFolder := - 1;
        with Node['FileIndizes'] do
        begin
          FProgram[i].NameFile := Attribute['NameFile'];
          for j := 0 to High(FProgram[i].StepNameFile) do
          begin
            if Attributes.IndexOf('StepNameFile_' + IntToStr(j)) <> - 1 then
            begin
              FProgram[i].StepNameFile[j] := Attribute['StepNameFile_' + IntToStr(j)];
            end;
          end;
          FProgram[i].OutputModeFile := Attribute['OutputModeFile'];
          FProgram[i].InputModeFile := Attribute['InputModeFile'];
          FProgram[i].InputAktivFile := Attribute['InputAktivFile'];
          FProgram[i].IntervallFile := Attribute['IntervallFile'];
          FProgram[i].AnalogInFile := Attribute['AnalogInFile'];
          FProgram[i].AnalogOutFile := Attribute['AnalogOutFile'];
          FProgram[i].ModeFile := Attribute['ModeFile'];
        end;
        with Node['Steps'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin

            with Node['Steps_' + IntToStr(j)] do
            begin
              for k := 0 to Attributes.Count - 1 do
              begin
                FProgram[i].Step[j].Name[k].Value := Attribute['Name_' + IntToStr(k)];
                FProgram[i].Step[j].Name[k].EntryFolder := - 1;
              end;

              with Node['Conditions'] do
              begin
                FProgram[i].Step[j].NextCond.Value := Attribute['NextCond'];
                FProgram[i].Step[j].NextCond.EntryFolder := - 1;
                FProgram[i].Step[j].NextStep.Value := Attribute['NextStep'];
                FProgram[i].Step[j].NextStep.EntryFolder := - 1;
                FProgram[i].Step[j].Time.Value := Attribute['Time'];
                FProgram[i].Step[j].Time.EntryFolder := - 1;
                FProgram[i].Step[j].Message.Value := Attribute['Message'];
                FProgram[i].Step[j].Message.EntryFolder := - 1;
                FProgram[i].Step[j].LOOPS.Value := Attribute['Loops'];
                FProgram[i].Step[j].LOOPS.EntryFolder := - 1;
                FProgram[i].Step[j].AlarmCond.Value := Attribute['AlarmCond'];
                FProgram[i].Step[j].AlarmCond.EntryFolder := - 1;
                FProgram[i].Step[j].AlarmStep.Value := Attribute['AlarmStep'];
                FProgram[i].Step[j].AlarmStep.EntryFolder := - 1;
                FProgram[i].Step[j].ContrTime.Value := Attribute['ContrTime'];
                FProgram[i].Step[j].ContrTime.EntryFolder := - 1;
              end;

              with Node['OutputModes'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  FProgram[i].Step[j].OutputMode[k].Value := Node['OutputMode_' + IntToStr(k)].Text;
                  FProgram[i].Step[j].OutputMode[k].EntryFolder := - 1;
                end;
              end;

              with Node['Inputs'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['Input_' + IntToStr(k)] do
                  begin
                    FProgram[i].Step[j].Input[k].Mode.Value := TVarData(Attribute['Mode']).VBoolean;
                    FProgram[i].Step[j].Input[k].Mode.EntryFolder := - 1;
                    FProgram[i].Step[j].Input[k].Aktiv.Value := TVarData(Attribute['Aktiv']).VBoolean;
                    FProgram[i].Step[j].Input[k].Aktiv.EntryFolder := - 1;
                  end;
                end;
              end;

              with Node['Intervalls'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['Intervall_' + IntToStr(k)] do
                  begin
                    FProgram[i].Step[j].INTERVALL[k].INTERVALL.Value := Attribute['Intervall'];
                    FProgram[i].Step[j].INTERVALL[k].INTERVALL.EntryFolder := - 1;
                    FProgram[i].Step[j].INTERVALL[k].PAUSE.Value := Attribute['Pause'];
                    FProgram[i].Step[j].INTERVALL[k].PAUSE.EntryFolder := - 1;
                  end;
                end;
              end;

              with Node['AnalogIns'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['AnalogIn_' + IntToStr(k)] do
                  begin
                    FProgram[i].Step[j].AnalogIn[k].Value.Value := Attribute['Value'];
                    FProgram[i].Step[j].AnalogIn[k].Value.EntryFolder := - 1;
                    FProgram[i].Step[j].AnalogIn[k].Mode.Value := Attribute['Mode'];
                    FProgram[i].Step[j].AnalogIn[k].Mode.EntryFolder := - 1;
                  end;
                end;
              end;

              with Node['AnalogOut'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  FProgram[i].Step[j].AnalogOut[k].Value := Node['AnalogOut_' + IntToStr(k)].Text;
                  FProgram[i].Step[j].AnalogOut[k].EntryFolder := - 1;
                end;
              end;

            end;
          end;
        end;
      end;
    end;
  end;

  if Assigned(FPicture) then
  begin
    with XML.Node['Bitmap'] do
    begin
      FPictureExtension := Attribute['Ext'];
      if GetBinaryLen > 0 then
      begin
        s := GetEnvironmentVariable('temp');
        s := IncludeTrailingPathDelimiter(s);
        s := s + 'Test' + Attribute['Ext'];
        Stream := TFileStream.Create(s, fmCreate);
        GetBinaryData(Stream);
        Stream.Free;
        FPicture.LoadFromFile(s);
        DeleteFile(PChar(s));
      end;
    end;
  end;
end;

procedure TCleanProgParser.LoadXMLV11(XML : TXMLFile);
var
  k : Integer;
  Stream : TFileStream;
  s : string;
  j : Integer;
  i : Integer;
begin
  FSelectedProgram := XML.Node['SelectedProgram'].Attribute['Value'];
  FLanguage := XML.Node['Language'].Attribute['Value'];
  s := XML.Node['Delimiter'].Attribute['Value'];
  FDelimiter := s[1];

  with XML.Node['RecipeFileNames'] do
  begin
    for i := 0 to Nodes.Count - 1 do
    begin
      with Node['FileName_' + IntToStr(i)] do
      begin
        FRecipeFileName[i].FileName := Attribute['FileName'];
        if not Assigned(FRecipeFileName[i].Header) then
        begin
          FRecipeFileName[i].Header := TStringList.Create;
        end;
        FRecipeFileName[i].Header.Clear;
        for j := 0 to Attribute['LineCount'] - 1 do
        begin
          FRecipeFileName[i].Header.Add(Node['Line_' + IntToStr(j)].Text_S);
        end;
      end;
    end;
  end;

  with XML.Node['EntryFolders'] do
  begin
    if not Assigned(FEntryFolders) then
    begin
      FEntryFolders := TStringList.Create;
    end;
    FEntryFolders.Clear;
    for i := 0 to Attribute['LineCount'] - 1 do
    begin
      FEntryFolders.Add(Node['Line_' + IntToStr(i)].Text_S);
    end;
  end;

  with XML.Node['Descriptions'] do
  begin
    for i := 0 to Nodes.Count - 1 do
    begin
      FDescription[i].Message.Clear;
      with Node['Language_' + IntToStr(i)] do
      begin
        with Node['Outputs'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].Output[j] := Node['Output_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['Inputs'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].Input[j] := Node['Input_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['AnalogIns'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].AnalogIn[j] := Node['AnalogIn_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['AnalogOuts'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].AnalogOut[j] := Node['AnalogOut_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['Messages'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].Message.Add(Node['Message_' + IntToStr(j)].Text_S);
          end;
        end;
      end;
    end;
  end;

  with XML.Node['Programs'] do
  begin
    Settings.NumOfProgs := Attributes['Count'];
    SetLength(FProgram, Settings.NumOfProgs);
    for i := 0 to Settings.NumOfProgs - 1 do
    begin
      with Node['Program_' + IntToStr(i)] do
      begin
        FProgram[i].Name.Value := Attribute['Name'];
        FProgram[i].Name.EntryFolder := Attribute['NameEntryFolder'];
        with Node['FileIndizes'] do
        begin
          FProgram[i].NameFile := Attribute['NameFile'];
          for j := 0 to High(FProgram[i].StepNameFile) do
          begin
            if Attributes.IndexOf('StepNameFile_' + IntToStr(j)) <> - 1 then
            begin
              FProgram[i].StepNameFile[j] := Attribute['StepNameFile_' + IntToStr(j)];
            end;
          end;
          FProgram[i].OutputModeFile := Attribute['OutputModeFile'];
          FProgram[i].InputModeFile := Attribute['InputModeFile'];
          FProgram[i].InputAktivFile := Attribute['InputAktivFile'];
          FProgram[i].IntervallFile := Attribute['IntervallFile'];
          FProgram[i].AnalogInFile := Attribute['AnalogInFile'];
          FProgram[i].AnalogOutFile := Attribute['AnalogOutFile'];
          FProgram[i].ModeFile := Attribute['ModeFile'];
        end;
        with Node['Steps'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin

            with Node['Steps_' + IntToStr(j)] do
            begin
              for k := 0 to Settings.NumOfLangs - 1 do
              begin
                with Node['Name_' + IntToStr(k)] do
                begin
                  FProgram[i].Step[j].Name[k].Value := Attribute['Value'];
                  FProgram[i].Step[j].Name[k].EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['Conditions'] do
              begin
                with Node['NextCond'] do
                begin
                  FProgram[i].Step[j].NextCond.Value := Attribute['Value'];
                  FProgram[i].Step[j].NextCond.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['NextStep'] do
                begin
                  FProgram[i].Step[j].NextStep.Value := Attribute['Value'];
                  FProgram[i].Step[j].NextStep.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Time'] do
                begin
                  FProgram[i].Step[j].Time.Value := Attribute['Value'];
                  FProgram[i].Step[j].Time.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Message'] do
                begin
                  FProgram[i].Step[j].Message.Value := Attribute['Value'];
                  FProgram[i].Step[j].Message.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Loops'] do
                begin
                  FProgram[i].Step[j].LOOPS.Value := Attribute['Value'];
                  FProgram[i].Step[j].LOOPS.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmCond'] do
                begin
                  FProgram[i].Step[j].AlarmCond.Value := Attribute['Value'];
                  FProgram[i].Step[j].AlarmCond.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmStep'] do
                begin
                  FProgram[i].Step[j].AlarmStep.Value := Attribute['Value'];
                  FProgram[i].Step[j].AlarmStep.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['ContrTime'] do
                begin
                  FProgram[i].Step[j].ContrTime.Value := Attribute['Value'];
                  FProgram[i].Step[j].ContrTime.EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['OutputModes'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['OutputMode_' + IntToStr(k)] do
                  begin
                    FProgram[i].Step[j].OutputMode[k].Value := Attribute['Value'];
                    FProgram[i].Step[j].OutputMode[k].EntryFolder := Attribute['EntryFolder'];
                  end;
                end;
              end;

              with Node['Inputs'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['Input_' + IntToStr(k)] do
                  begin
                    with Node['Mode'] do
                    begin
                      FProgram[i].Step[j].Input[k].Mode.Value := TVarData(Attribute['Value']).VBoolean;
                      FProgram[i].Step[j].Input[k].Mode.EntryFolder := Attribute['EntryFolder'];
                    end;
                    with Node['Aktiv'] do
                    begin
                      FProgram[i].Step[j].Input[k].Aktiv.Value := TVarData(Attribute['Value']).VBoolean;
                      FProgram[i].Step[j].Input[k].Aktiv.EntryFolder := Attribute['EntryFolder'];
                    end;
                  end;
                end;
              end;

              with Node['Intervalls'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['Intervall_' + IntToStr(k)] do
                  begin
                    with Node['Intervall'] do
                    begin
                      FProgram[i].Step[j].INTERVALL[k].INTERVALL.Value := Attribute['Value'];
                      FProgram[i].Step[j].INTERVALL[k].INTERVALL.EntryFolder := Attribute['EntryFolder'];
                    end;
                    with Node['Pause'] do
                    begin
                      FProgram[i].Step[j].INTERVALL[k].PAUSE.Value := Attribute['Value'];
                      FProgram[i].Step[j].INTERVALL[k].PAUSE.EntryFolder := Attribute['EntryFolder'];
                    end;
                  end;
                end;
              end;

              with Node['AnalogIns'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['AnalogIn_' + IntToStr(k)] do
                  begin
                    with Node['Value'] do
                    begin
                      FProgram[i].Step[j].AnalogIn[k].Value.Value := Attribute['Value'];
                      FProgram[i].Step[j].AnalogIn[k].Value.EntryFolder := Attribute['EntryFolder'];
                    end;
                    with Node['Mode'] do
                    begin
                      FProgram[i].Step[j].AnalogIn[k].Mode.Value := Attribute['Value'];
                      FProgram[i].Step[j].AnalogIn[k].Mode.EntryFolder := Attribute['EntryFolder'];
                    end;
                  end;
                end;
              end;

              with Node['AnalogOut'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['AnalogOut_' + IntToStr(k)] do
                  begin
                    FProgram[i].Step[j].AnalogOut[k].Value := Attribute['Value'];
                    FProgram[i].Step[j].AnalogOut[k].EntryFolder := Attribute['EntryFolder'];
                  end;
                end;
              end;

            end;
          end;
        end;
      end;
    end;
  end;

  if Assigned(FPicture) then
  begin
    with XML.Node['Bitmap'] do
    begin
      FPictureExtension := Attribute['Ext'];
      if GetBinaryLen > 0 then
      begin
        s := GetEnvironmentVariable('temp');
        s := IncludeTrailingPathDelimiter(s);
        s := s + 'Test' + Attribute['Ext'];
        Stream := TFileStream.Create(s, fmCreate);
        GetBinaryData(Stream);
        Stream.Free;
        FPicture.LoadFromFile(s);
        DeleteFile(PChar(s));
      end;
    end;
  end;
end;

procedure TCleanProgParser.LoadXMLV12(XML : TXMLFile);
var
  k : Integer;
  Stream : TFileStream;
  s : string;
  j : Integer;
  i : Integer;
begin
  FSelectedProgram := XML.Node['SelectedProgram'].Attribute['Value'];
  FLanguage := XML.Node['Language'].Attribute['Value'];
  s := XML.Node['Delimiter'].Attribute['Value'];
  FDelimiter := s[1];

  with XML.Node['RecipeFileNames'] do
  begin
    for i := 0 to Nodes.Count - 1 do
    begin
      with Node['FileName_' + IntToStr(i)] do
      begin
        FRecipeFileName[i].FileName := Attribute['FileName'];
        if not Assigned(FRecipeFileName[i].Header) then
        begin
          FRecipeFileName[i].Header := TStringList.Create;
        end;
        FRecipeFileName[i].Header.Clear;
        for j := 0 to Attribute['LineCount'] - 1 do
        begin
          FRecipeFileName[i].Header.Add(Node['Line_' + IntToStr(j)].Text_S);
        end;
      end;
    end;
  end;

  with XML.Node['EntryFolders'] do
  begin
    if not Assigned(FEntryFolders) then
    begin
      FEntryFolders := TStringList.Create;
    end;
    FEntryFolders.Clear;
    for i := 0 to Attribute['LineCount'] - 1 do
    begin
      FEntryFolders.Add(Node['Line_' + IntToStr(i)].Text_S);
    end;
  end;

  with XML.Node['Descriptions'] do
  begin
    for i := 0 to Nodes.Count - 1 do
    begin
      FDescription[i].Message.Clear;
      with Node['Language_' + IntToStr(i)] do
      begin
        with Node['Outputs'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].Output[j] := Node['Output_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['Inputs'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].Input[j] := Node['Input_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['AnalogIns'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].AnalogIn[j] := Node['AnalogIn_' + IntToStr(j)].Text_S;
          end;
        end;
        with Node['AnalogOuts'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            with Node['AnalogOut_' + IntToStr(j)] do
            begin
              FDescription[i].AnalogOut[j] := Attribute['Name'];
              FDescription[i].AnalogOutUnit[j] := Attribute['Unit']
            end;
          end;
        end;
        with Node['Messages'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin
            FDescription[i].Message.Add(Node['Message_' + IntToStr(j)].Text_S);
          end;
        end;
      end;
    end;
  end;

  with XML.Node['Programs'] do
  begin
    Settings.NumOfProgs := Attributes['Count'];
    SetLength(FProgram, Settings.NumOfProgs);
    for i := 0 to Settings.NumOfProgs - 1 do
    begin
      with Node['Program_' + IntToStr(i)] do
      begin
        FProgram[i].Name.Value := Attribute['Name'];
        FProgram[i].Name.EntryFolder := Attribute['NameEntryFolder'];
        with Node['FileIndizes'] do
        begin
          FProgram[i].NameFile := Attribute['NameFile'];
          for j := 0 to High(FProgram[i].StepNameFile) do
          begin
            if Attributes.IndexOf('StepNameFile_' + IntToStr(j)) <> - 1 then
            begin
              FProgram[i].StepNameFile[j] := Attribute['StepNameFile_' + IntToStr(j)];
            end;
          end;
          FProgram[i].OutputModeFile := Attribute['OutputModeFile'];
          FProgram[i].InputModeFile := Attribute['InputModeFile'];
          FProgram[i].InputAktivFile := Attribute['InputAktivFile'];
          FProgram[i].IntervallFile := Attribute['IntervallFile'];
          FProgram[i].AnalogInFile := Attribute['AnalogInFile'];
          FProgram[i].AnalogOutFile := Attribute['AnalogOutFile'];
          FProgram[i].ModeFile := Attribute['ModeFile'];
        end;
        with Node['Steps'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin

            with Node['Steps_' + IntToStr(j)] do
            begin
              for k := 0 to Settings.NumOfLangs - 1 do
              begin
                with Node['Name_' + IntToStr(k)] do
                begin
                  FProgram[i].Step[j].Name[k].Value := Attribute['Value'];
                  FProgram[i].Step[j].Name[k].EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['Conditions'] do
              begin
                with Node['NextCond'] do
                begin
                  FProgram[i].Step[j].NextCond.Value := Attribute['Value'];
                  FProgram[i].Step[j].NextCond.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['NextStep'] do
                begin
                  FProgram[i].Step[j].NextStep.Value := Attribute['Value'];
                  FProgram[i].Step[j].NextStep.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Time'] do
                begin
                  FProgram[i].Step[j].Time.Value := Attribute['Value'];
                  FProgram[i].Step[j].Time.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Message'] do
                begin
                  FProgram[i].Step[j].Message.Value := Attribute['Value'];
                  FProgram[i].Step[j].Message.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Loops'] do
                begin
                  FProgram[i].Step[j].LOOPS.Value := Attribute['Value'];
                  FProgram[i].Step[j].LOOPS.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmCond'] do
                begin
                  FProgram[i].Step[j].AlarmCond.Value := Attribute['Value'];
                  FProgram[i].Step[j].AlarmCond.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmStep'] do
                begin
                  FProgram[i].Step[j].AlarmStep.Value := Attribute['Value'];
                  FProgram[i].Step[j].AlarmStep.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['ContrTime'] do
                begin
                  FProgram[i].Step[j].ContrTime.Value := Attribute['Value'];
                  FProgram[i].Step[j].ContrTime.EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['OutputModes'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['OutputMode_' + IntToStr(k)] do
                  begin
                    FProgram[i].Step[j].OutputMode[k].Value := Attribute['Value'];
                    FProgram[i].Step[j].OutputMode[k].EntryFolder := Attribute['EntryFolder'];
                  end;
                end;
              end;

              with Node['Inputs'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['Input_' + IntToStr(k)] do
                  begin
                    with Node['Mode'] do
                    begin
                      FProgram[i].Step[j].Input[k].Mode.Value := TVarData(Attribute['Value']).VBoolean;
                      FProgram[i].Step[j].Input[k].Mode.EntryFolder := Attribute['EntryFolder'];
                    end;
                    with Node['Aktiv'] do
                    begin
                      FProgram[i].Step[j].Input[k].Aktiv.Value := TVarData(Attribute['Value']).VBoolean;
                      FProgram[i].Step[j].Input[k].Aktiv.EntryFolder := Attribute['EntryFolder'];
                    end;
                  end;
                end;
              end;

              with Node['Intervalls'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['Intervall_' + IntToStr(k)] do
                  begin
                    with Node['Intervall'] do
                    begin
                      FProgram[i].Step[j].INTERVALL[k].INTERVALL.Value := Attribute['Value'];
                      FProgram[i].Step[j].INTERVALL[k].INTERVALL.EntryFolder := Attribute['EntryFolder'];
                    end;
                    with Node['Pause'] do
                    begin
                      FProgram[i].Step[j].INTERVALL[k].PAUSE.Value := Attribute['Value'];
                      FProgram[i].Step[j].INTERVALL[k].PAUSE.EntryFolder := Attribute['EntryFolder'];
                    end;
                  end;
                end;
              end;

              with Node['AnalogIns'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['AnalogIn_' + IntToStr(k)] do
                  begin
                    with Node['Value'] do
                    begin
                      FProgram[i].Step[j].AnalogIn[k].Value.Value := Attribute['Value'];
                      FProgram[i].Step[j].AnalogIn[k].Value.EntryFolder := Attribute['EntryFolder'];
                    end;
                    with Node['Mode'] do
                    begin
                      FProgram[i].Step[j].AnalogIn[k].Mode.Value := Attribute['Value'];
                      FProgram[i].Step[j].AnalogIn[k].Mode.EntryFolder := Attribute['EntryFolder'];
                    end;
                  end;
                end;
              end;

              with Node['AnalogOut'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['AnalogOut_' + IntToStr(k)] do
                  begin
                    FProgram[i].Step[j].AnalogOut[k].Value := Attribute['Value'];
                    FProgram[i].Step[j].AnalogOut[k].EntryFolder := Attribute['EntryFolder'];
                  end;
                end;
              end;

            end;
          end;
        end;
      end;
    end;
  end;

  if Assigned(FPicture) then
  begin
    with XML.Node['Bitmap'] do
    begin
      FPictureExtension := Attribute['Ext'];
      if GetBinaryLen > 0 then
      begin
        s := GetEnvironmentVariable('temp');
        s := IncludeTrailingPathDelimiter(s);
        s := s + 'Test' + Attribute['Ext'];
        Stream := TFileStream.Create(s, fmCreate);
        GetBinaryData(Stream);
        Stream.Free;
        FPicture.LoadFromFile(s);
        DeleteFile(PChar(s));
      end;
    end;
  end;
end;

procedure TCleanProgParser.CopyStep(Index : Integer);
begin
  FStepBuffer := FProgram[FSelectedProgram].Step[Index].Copy;
end;

constructor TCleanProgParser.Create(Settings : TSettings);
var
  i, j : Integer;
begin
  inherited Create();
  self.Settings := Settings;

  SetLength(FProgram, Settings.NumOfProgs);
  for i := 0 to Settings.NumOfProgs - 1 do
  begin
    SetLength(FProgram[i].Step, Settings.NumOfSteps);
    for j := 0 to Settings.NumOfSteps - 1 do
    begin
      SetLength(FProgram[i].Step[j].Name, Settings.NumOfLangs);
      SetLength(FProgram[i].Step[j].OutputMode, Settings.NumOfOutputs);
      SetLength(FProgram[i].Step[j].Input, Settings.NumOfInputs);
      SetLength(FProgram[i].Step[j].INTERVALL, Settings.NumOfIntervalls);
      SetLength(FProgram[i].Step[j].AnalogIn, Settings.NumOfAnalogIn);
      SetLength(FProgram[i].Step[j].AnalogOut, Settings.NumOfAnalogOut);
    end;
    SetLength(FProgram[i].StepNameFile, Settings.NumOfLangs);
  end;

  SetLength(FRecipeFileName, Settings.NumOfFiles);
  SetLength(FDescription, Settings.NumOfLangs);

  FLines := TDictionary<String, TData>.Create;
  for i := 0 to High(FDescription) do
  begin
    FDescription[i].Message := TStringList.Create;
    SetLength(FDescription[i].Output, Settings.NumOfOutputs);
    SetLength(FDescription[i].Input, Settings.NumOfInputs);
    SetLength(FDescription[i].AnalogIn, Settings.NumOfAnalogIn);
    SetLength(FDescription[i].AnalogOut, Settings.NumOfAnalogOut);
    SetLength(FDescription[i].AnalogOutUnit, Settings.NumOfAnalogOut);
  end;
  FEntryFolders := TStringList.Create;
  FEntryFolders.Sorted := True;
  FEntryFolders.Duplicates := dupIgnore;
end;

procedure TCleanProgParser.CutStep(Index : Integer);
var
  i : Integer;
begin
  FStepBuffer := FProgram[FSelectedProgram].Step[Index].Copy;
  for i := Index to Settings.NumOfSteps - 2 do
  begin
    FProgram[FSelectedProgram].Step[i] := FProgram[FSelectedProgram].Step[i + 1];
  end;
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    if FProgram[FSelectedProgram].Step[i].NextStep.Value > Index then
    begin
      Dec(FProgram[FSelectedProgram].Step[i].NextStep.Value);
    end;
    if FProgram[FSelectedProgram].Step[i].AlarmStep.Value > Index then
    begin
      Dec(FProgram[FSelectedProgram].Step[i].AlarmStep.Value);
    end;
  end;
end;

destructor TCleanProgParser.Destroy;
var
  i : Integer;
  Data : TArray<TData>;
begin
  if Assigned(FLines) then
  begin
    Data := FLines.Values.ToArray;
    for i := 0 to (FLines.Values.Count - 1) do
    begin
      FreeAndNil(Data[i]);
    end;
  end;
  FreeAndNil(FLines);

  FreeAndNil(FEntryFolders);

  for i := 0 to Settings.NumOfFiles - 1 do
  begin
    if Assigned(FRecipeFileName[i].Header) then
    begin
      FreeAndNil(FRecipeFileName[i].Header);
    end;
  end;

  for i := 0 to High(FDescription) do
  begin
    if Assigned(FDescription[i].Message) then
    begin
      FreeAndNil(FDescription[i].Message);
    end;
  end;

  if Assigned(Settings) then
  begin
    FreeAndNil(FSettings);
  end;

  inherited;
end;

function TCleanProgParser.GetDescription : TDescription;
begin
  Result := FDescription[FLanguage];
end;

function TCleanProgParser.GetLanguage : Integer;
begin
  Result := FLanguage + 1;
end;

function TCleanProgParser.GetProgramName : string;
begin
  if InRange(FSelectedProgram, 0, Settings.NumOfProgs - 1) then
  begin
    Result := FProgram[FSelectedProgram].Name.Value;
  end
  else
  begin
    Result := '';
  end;
end;

function TCleanProgParser.GetSelectedProgram : Integer;
begin
  Result := FSelectedProgram + 1;
end;

function TCleanProgParser.GetStep(index : Integer) : TStep;
begin
  if not InRange(index, 0, Settings.NumOfSteps - 1) then
  begin
    raise TCleanProgException.CreateFmt('Selected Step Out of Range Min: %d, Max: %d, Is: %d',
      [0, Settings.NumOfSteps - 1, index]);
  end;
  if InRange(FSelectedProgram, 0, Settings.NumOfProgs - 1) then
  begin
    Result := FProgram[FSelectedProgram].Step[index];
  end;
end;

function TCleanProgParser.GetStepCount : Integer;
begin
  Result := Settings.NumOfSteps;
end;

function TCleanProgParser.GetStepName(index : Integer) : string;
begin
  Result := FProgram[FSelectedProgram].Step[Index].Name[FLanguage].Value;
end;

procedure TCleanProgParser.InsertStep(Index : Integer);
var
  i : Integer;
begin
  for i := Settings.NumOfSteps - 2 downto Index do
  begin
    FProgram[FSelectedProgram].Step[i + 1] := FProgram[FSelectedProgram].Step[i];
  end;
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    if FProgram[FSelectedProgram].Step[i].NextStep.Value > Index then
    begin
      Inc(FProgram[FSelectedProgram].Step[i].NextStep.Value);
    end;
    if FProgram[FSelectedProgram].Step[i].AlarmStep.Value > Index then
    begin
      Inc(FProgram[FSelectedProgram].Step[i].AlarmStep.Value);
    end;
  end;
  FProgram[FSelectedProgram].Step[Index] := FStepBuffer.Copy;
end;

procedure TCleanProgParser.LoadDescription(DescFile : String);
var
  sl : TStringList;
  i, j, k : Integer;
  LangIndexSelected : Boolean;
  Divider, DividerInner : TStringDivider;
  aTemp, aTempInner : csExplode.TStringDynArray;
  aIndex : array of Integer;
  aDesc : array of String;
  aText : array of String;
  s : string;
  LangDesc : TStringList;
  Indizes : TList<Integer>;

  function GetString(s : string) : string;
  begin
    if s[1] = '"' then
    begin
      Result := Copy(s, 2, Length(s) - 2);
    end;
  end;

begin
  LangIndexSelected := False;
  SetLength(aIndex, Settings.NumOfLangs);
  SetLength(aDesc, Settings.NumOfLangs);
  SetLength(aText, Settings.NumOfLangs);
  sl := TStringList.Create();
  Divider := TStringDivider.Create;
  DividerInner := TStringDivider.Create;
  LangDesc := TStringList.Create;
  Indizes := TList<Integer>.Create;
  try
    sl.LoadFromFile(DescFile);
    FCount := 0;
    FMaxCount := sl.Count - 1;
    FSendCount := 100;
    SendProgress();
    for i := 0 to Settings.NumOfLangs - 1 do
    begin
      aIndex[i] := i;
      FDescription[i].Message.Clear;
    end;
    Divider.Pattern := #9;
    DividerInner.Pattern := '=';
    for i := 0 to sl.Count - 1 do
    begin
      Divider.Explode(sl.Strings[i], aTemp);
      if Divider.Count > 4 then
      begin
        case CaseStringIOf(GetString(aTemp[0]), [Settings.MessageListName, Settings.InputListName,
          Settings.OutputListName, Settings.AnalogInputListName, Settings.AnalogOutputListName,
          Settings.AnalogOutputUnitListName]) of
          0 :
            begin
              // for j := 4 to 4 + NUM_OF_LANGS - 1 do
              for j := 4 to Divider.Count - 1 do
              begin
                s := GetString(aTemp[j]);
                DividerInner.Explode(s, aTempInner);
                if DividerInner.Count > 0 then
                begin
                  aDesc[j - 4] := aTempInner[0];
                  aText[j - 4] := RightStr(s, Length(s) - Length(aTempInner[0]) - 1);
                end;
              end;
              if Assigned(FOnSelectLangIndex) and not LangIndexSelected and (DividerInner.Count > 0) then
              begin
                LangDesc.Clear;
                Indizes.Clear;
                // for j := 0 to NUM_OF_LANGS - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  LangDesc.Add(aDesc[j]);
                  Indizes.Add(aIndex[j]);
                end;
                FOnSelectLangIndex(self, LangDesc, Indizes);
                for j := 0 to Indizes.Count - 1 do
                begin
                  aIndex[j] := Indizes.Items[j];
                end;
                LangIndexSelected := True;
              end;
              // for j := 0 to NUM_OF_LANGS - 1 do
              for j := 0 to Divider.Count - 1 - 4 do
              begin
                FDescription[aIndex[j]].Message.Add(aText[j]);
                {
                  CodeSite.SendFmtMsg('Added Message for %s on LangIndex: %d Text: %s',
                  [aDesc[j], aIndex[j], aText[j]]);
                }
              end;
            end;
          1 :
            begin
              // for j := 4 to 4 + NUM_OF_LANGS - 1 do
              for j := 4 to Divider.Count - 1 do
              begin
                s := GetString(aTemp[j]);
                DividerInner.Explode(s, aTempInner);
                if DividerInner.Count > 0 then
                begin
                  aDesc[j - 4] := aTempInner[0];
                  aText[j - 4] := RightStr(s, Length(s) - Length(aTempInner[0]) - 1);
                end;
              end;
              if Assigned(FOnSelectLangIndex) and not LangIndexSelected and (DividerInner.Count > 0) then
              begin
                LangDesc.Clear;
                Indizes.Clear;
                // for j := 0 to NUM_OF_LANGS - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  LangDesc.Add(aDesc[j]);
                  Indizes.Add(aIndex[j]);
                end;
                FOnSelectLangIndex(self, LangDesc, Indizes);
                for j := 0 to Indizes.Count - 1 do
                begin
                  aIndex[j] := Indizes.Items[j];
                end;
                LangIndexSelected := True;
              end;
              // for j := 0 to NUM_OF_LANGS - 1 do    #
              for j := 0 to Divider.Count - 1 - 4 do
              begin
                k := StrToInt(GetString(aTemp[3]));
                if k < Settings.NumOfInputs then
                begin
                  FDescription[aIndex[j]].Input[k] := aText[j];
                end;
                {
                  CodeSite.SendFmtMsg('Added Input for %s on LangIndex: %d Index: %d Text: %s',
                  [aDesc[j], aIndex[j], k, aText[j]]);
                }
              end;
            end;
          2 :
            begin
              // for j := 4 to 4 + NUM_OF_LANGS - 1 do
              for j := 4 to Divider.Count - 1 do
              begin
                s := GetString(aTemp[j]);
                DividerInner.Explode(s, aTempInner);
                if DividerInner.Count > 0 then
                begin
                  aDesc[j - 4] := aTempInner[0];
                  aText[j - 4] := RightStr(s, Length(s) - Length(aTempInner[0]) - 1);
                end;
              end;
              if Assigned(FOnSelectLangIndex) and not LangIndexSelected and (DividerInner.Count > 0) then
              begin
                LangDesc.Clear;
                Indizes.Clear;
                // for j := 0 to NUM_OF_LANGS - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  LangDesc.Add(aDesc[j]);
                  Indizes.Add(aIndex[j]);
                end;
                FOnSelectLangIndex(self, LangDesc, Indizes);
                // for j := 0 to Indizes.Count - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  aIndex[j] := Indizes.Items[j];
                end;
                LangIndexSelected := True;
              end;
              // for j := 0 to NUM_OF_LANGS - 1 do
              for j := 0 to Divider.Count - 1 - 4 do
              begin
                k := StrToInt(GetString(aTemp[3]));
                if k < Settings.NumOfOutputs then
                begin
                  FDescription[aIndex[j]].Output[k] := aText[j];
                end;
                {
                  CodeSite.SendFmtMsg('Added Output for %s on LangIndex: %d Index: %d Text: %s',
                  [aDesc[j], aIndex[j], k, aText[j]]);
                }
              end;
            end;
          3 :
            begin
              // for j := 4 to 4 + NUM_OF_LANGS - 1 do
              for j := 4 to Divider.Count - 1 do
              begin
                s := GetString(aTemp[j]);
                DividerInner.Explode(s, aTempInner);
                if DividerInner.Count > 0 then
                begin
                  aDesc[j - 4] := aTempInner[0];
                  aText[j - 4] := RightStr(s, Length(s) - Length(aTempInner[0]) - 1);
                end;
              end;
              if Assigned(FOnSelectLangIndex) and not LangIndexSelected and (DividerInner.Count > 0) then
              begin
                LangDesc.Clear;
                Indizes.Clear;
                // for j := 0 to NUM_OF_LANGS - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  LangDesc.Add(aDesc[j]);
                  Indizes.Add(aIndex[j]);
                end;
                FOnSelectLangIndex(self, LangDesc, Indizes);
                // for j := 0 to Indizes.Count - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  aIndex[j] := Indizes.Items[j];
                end;
                LangIndexSelected := True;
              end;
              // for j := 0 to NUM_OF_LANGS - 1 do
              for j := 0 to Divider.Count - 1 - 4 do
              begin
                k := StrToInt(GetString(aTemp[3]));
                if k < Settings.NumOfAnalogIn then
                begin
                  FDescription[aIndex[j]].AnalogIn[k] := aText[j];
                end;
                {
                  CodeSite.SendFmtMsg('Added Analog Input for %s on LangIndex: %d Index: %d Text: %s',
                  [aDesc[j], aIndex[j], k, aText[j]]);
                }
              end;
            end;
          4 :
            begin
              // for j := 4 to 4 + NUM_OF_LANGS - 1 do
              for j := 4 to Divider.Count - 1 do
              begin
                s := GetString(aTemp[j]);
                DividerInner.Explode(s, aTempInner);
                if DividerInner.Count > 0 then
                begin
                  aDesc[j - 4] := aTempInner[0];
                  aText[j - 4] := RightStr(s, Length(s) - Length(aTempInner[0]) - 1);
                end;
              end;
              if Assigned(FOnSelectLangIndex) and not LangIndexSelected and (DividerInner.Count > 0) then
              begin
                LangDesc.Clear;
                Indizes.Clear;
                // for j := 0 to NUM_OF_LANGS - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  LangDesc.Add(aDesc[j]);
                  Indizes.Add(aIndex[j]);
                end;
                FOnSelectLangIndex(self, LangDesc, Indizes);
                // for j := 0 to Indizes.Count - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  aIndex[j] := Indizes.Items[j];
                end;
                LangIndexSelected := True;
              end;
              // for j := 0 to NUM_OF_LANGS - 1 do
              for j := 0 to Divider.Count - 1 - 4 do
              begin
                k := StrToInt(GetString(aTemp[3]));
                if k < Settings.NumOfAnalogOut then
                begin
                  FDescription[aIndex[j]].AnalogOut[k] := aText[j];
                end;
                {
                  CodeSite.SendFmtMsg('Added Analog Output for %s on LangIndex: %d Index: %d Text: %s',
                  [aDesc[j], aIndex[j], k, aText[j]]);
                }
              end;
            end;
          5 :
            begin
              // for j := 4 to 4 + NUM_OF_LANGS - 1 do
              for j := 4 to Divider.Count - 1 do
              begin
                s := GetString(aTemp[j]);
                DividerInner.Explode(s, aTempInner);
                if DividerInner.Count > 0 then
                begin
                  aDesc[j - 4] := aTempInner[0];
                  aText[j - 4] := RightStr(s, Length(s) - Length(aTempInner[0]) - 1);
                end;
              end;
              if Assigned(FOnSelectLangIndex) and not LangIndexSelected and (DividerInner.Count > 0) then
              begin
                LangDesc.Clear;
                Indizes.Clear;
                // for j := 0 to NUM_OF_LANGS - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  LangDesc.Add(aDesc[j]);
                  Indizes.Add(aIndex[j]);
                end;
                FOnSelectLangIndex(self, LangDesc, Indizes);
                // for j := 0 to Indizes.Count - 1 do
                for j := 0 to Divider.Count - 1 - 4 do
                begin
                  aIndex[j] := Indizes.Items[j];
                end;
                LangIndexSelected := True;
              end;
              // for j := 0 to NUM_OF_LANGS - 1 do
              for j := 0 to Divider.Count - 1 - 4 do
              begin
                k := StrToInt(GetString(aTemp[3]));
                if k < Settings.NumOfAnalogOut then
                begin
                  FDescription[aIndex[j]].AnalogOutUnit[k] := aText[j];
                end;
                {
                  CodeSite.SendFmtMsg('Added Analog Output Unit for %s on LangIndex: %d Index: %d Text: %s',
                  [aDesc[j], aIndex[j], k, aText[j]]);
                }
              end;
            end;
        end;
      end;
      Inc(FCount);
      FSendCount := 100;
      SendProgress();
    end;
  finally
    FreeAndNil(sl);
    FreeAndNil(Divider);
    FreeAndNil(DividerInner);
    FreeAndNil(LangDesc);
    FreeAndNil(Indizes);
  end;
end;

procedure TCleanProgParser.LoadFile(FileName : string; FileIndex : Integer);
var
  csvDataStream : TFileStream;
  csvReader : TCSVReader;
  i : Integer;
  FoundLangID : Boolean;
  ColumnFormat : TList<Integer>;
  s : string;
  FormatNo : Integer;
  RawValue : TRawValue;
  RawValues : TList<TRawValue>;
  Data : TData;
  FolderIndex : Integer;
begin
  ColumnFormat := TList<Integer>.Create();
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
          FDataSetCount := MAX(FDataSetCount, csvReader.ColumnCount - 1);
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
            for i := 1 to csvReader.ColumnCount - 1 do
            begin
              FormatNo := StrToIntDef(csvReader.Columns[i], 1);
              if FormatNo > Settings.NumOfProgs then
              begin
                raise TCleanProgException.CreateFmt('Read Dataset Number too high Is: %d, Max: %d',
                  [FormatNo, Settings.NumOfProgs]);
              end;
              ColumnFormat.Add(FormatNo);
            end;
            FoundLangID := False;
          end;
        end
        else
        begin
          RawValues := TList<TRawValue>.Create();
          for i := 1 to csvReader.ColumnCount - 1 do
          begin
            RawValue.Value := csvReader.Columns[i];
            RawValue.FormatIndex := ColumnFormat.Items[i - 1] - 1;
            RawValues.Add(RawValue);
          end;
          FolderIndex := FEntryFolders.Add(ExtractFilePath(csvReader.Columns[0]));
          Data := TData.Create(RawValues, FileIndex, FolderIndex);
          FLines.Add(ExtractFileName(csvReader.Columns[0]), Data);
        end;
      end;
      csvReader.Next;
    end;

  finally
    FreeAndNil(csvReader);
    FreeAndNil(csvDataStream);
    FreeAndNil(ColumnFormat);
  end;

end;

procedure TCleanProgParser.LoadFiles(Files : TStrings);
var
  i : Integer;
  Data : TArray<TData>;
begin

  if Files.Count <> Settings.NumOfFiles then
  begin
    raise TCleanProgException.CreateFmt('Incorrect File Count is (%d), should be (%d)',
      [Files.Count, Settings.NumOfFiles]);
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

  for i := 0 to Settings.NumOfFiles - 1 do
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

  FMaxCount := FMaxCount + FDataSetCount + (Settings.NumOfLangs * Settings.NumOfSteps * FDataSetCount) +
    (2 * Settings.NumOfInputs * Settings.NumOfSteps * FDataSetCount) +
    (2 * Settings.NumOfIntervalls * Settings.NumOfSteps * FDataSetCount) +
    (2 * Settings.NumOfAnalogIn * Settings.NumOfSteps * FDataSetCount) +
    (Settings.NumOfAnalogOut * Settings.NumOfSteps * FDataSetCount) + (8 * Settings.NumOfSteps * FDataSetCount) +
    (Settings.NumOfOutputs * Settings.NumOfSteps * FDataSetCount);

  FSendCount := 100;
  SendProgress();

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
  FCount := FMaxCount;
  SendProgress();
end;

procedure TCleanProgParser.LoadFromXML(FileName : string);
var
  XML : TXMLFile;
  FileVersion : Integer;
begin
  XML := TXMLFile.Create();
  try
    XML.LoadFromFile(FileName);
    if XML.RootNode.Nodes.Exists('FileVersion') then
    begin
      FileVersion := XML.Node['FileVersion'].Attribute['Value'];
    end
    else
    begin
      FileVersion := 10;
    end;

    case FileVersion of
      10 :
        LoadXMLV10(XML);
      11 :
        LoadXMLV11(XML);
      12 :
        LoadXMLV12(XML);
    end;

  finally
    FreeAndNil(XML);
  end;
end;

procedure TCleanProgParser.ParseAlarmCond;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.AlarmCond, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FProgram[RawValue.FormatIndex].Step[i].AlarmCond.Value := StrToInt(RawValue.Value);
      FProgram[RawValue.FormatIndex].Step[i].AlarmCond.EntryFolder := Data.Folder;
      FProgram[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParser.ParseAlarmStep;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.AlarmStep, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FProgram[RawValue.FormatIndex].Step[i].AlarmStep.Value := StrToInt(RawValue.Value);
      FProgram[RawValue.FormatIndex].Step[i].AlarmStep.EntryFolder := Data.Folder;
      FProgram[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParser.ParseAnalogIn;
var
  i, k : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfAnalogIn - 1 do
  begin
    for k := 0 to Settings.NumOfSteps - 1 do
    begin
      s := Format(Settings.AnalogIn, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FProgram[RawValue.FormatIndex].Step[k].AnalogIn[i].Value.Value := StrToFloat(RawValue.Value);
        FProgram[RawValue.FormatIndex].Step[k].AnalogIn[i].Value.EntryFolder := Data.Folder;
        FProgram[RawValue.FormatIndex].AnalogInFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParseAnalogMode;
var
  i, k : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfAnalogIn - 1 do
  begin
    for k := 0 to Settings.NumOfSteps - 1 do
    begin
      s := Format(Settings.AnalogMode, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FProgram[RawValue.FormatIndex].Step[k].AnalogIn[i].Mode.Value := StrToFloat(RawValue.Value);
        FProgram[RawValue.FormatIndex].Step[k].AnalogIn[i].Mode.EntryFolder := Data.Folder;
        FProgram[RawValue.FormatIndex].AnalogInFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParseAnalogOut;
var
  i, k : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfAnalogOut - 1 do
  begin
    for k := 0 to Settings.NumOfSteps - 1 do
    begin
      s := Format(Settings.AnalogOut, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FProgram[RawValue.FormatIndex].Step[k].AnalogOut[i].Value := StrToFloat(RawValue.Value);
        FProgram[RawValue.FormatIndex].Step[k].AnalogOut[i].EntryFolder := Data.Folder;
        FProgram[RawValue.FormatIndex].AnalogOutFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParseContrTime;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.ContrTime, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FProgram[RawValue.FormatIndex].Step[i].ContrTime.Value := StrToInt(RawValue.Value);
      FProgram[RawValue.FormatIndex].Step[i].ContrTime.EntryFolder := Data.Folder;
      FProgram[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParser.ParseInputAktiv;
var
  i, k : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfInputs - 1 do
  begin
    for k := 0 to Settings.NumOfSteps - 1 do
    begin
      s := Format(Settings.InputAktiv, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FProgram[RawValue.FormatIndex].Step[k].Input[i].Aktiv.Value := RawValue.Value = '1';
        FProgram[RawValue.FormatIndex].Step[k].Input[i].Aktiv.EntryFolder := Data.Folder;
        FProgram[RawValue.FormatIndex].InputAktivFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParseInputMode;
var
  i, k : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfInputs - 1 do
  begin
    for k := 0 to Settings.NumOfSteps - 1 do
    begin
      s := Format(Settings.InputMode, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FProgram[RawValue.FormatIndex].Step[k].Input[i].Mode.Value := RawValue.Value = '1';
        FProgram[RawValue.FormatIndex].Step[k].Input[i].Mode.EntryFolder := Data.Folder;
        FProgram[RawValue.FormatIndex].InputModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParseIntervall;
var
  i, k : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfIntervalls - 1 do
  begin
    for k := 0 to Settings.NumOfSteps - 1 do
    begin
      s := Format(Settings.INTERVALL, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FProgram[RawValue.FormatIndex].Step[k].INTERVALL[i].INTERVALL.Value := StrToInt(RawValue.Value);
        FProgram[RawValue.FormatIndex].Step[k].INTERVALL[i].INTERVALL.EntryFolder := Data.Folder;
        FProgram[RawValue.FormatIndex].IntervallFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParseLoops;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.LOOPS, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FProgram[RawValue.FormatIndex].Step[i].LOOPS.Value := StrToInt(RawValue.Value);
      FProgram[RawValue.FormatIndex].Step[i].LOOPS.EntryFolder := Data.Folder;
      FProgram[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParser.ParseMessage;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.MESSAGES, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FProgram[RawValue.FormatIndex].Step[i].Message.Value := StrToInt(RawValue.Value);
      FProgram[RawValue.FormatIndex].Step[i].Message.EntryFolder := Data.Folder;
      FProgram[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParser.ParseNextCond;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.NextCond, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FProgram[RawValue.FormatIndex].Step[i].NextCond.Value := StrToInt(RawValue.Value);
      FProgram[RawValue.FormatIndex].Step[i].NextCond.EntryFolder := Data.Folder;
      FProgram[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParser.ParseNextStep;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.NextStep, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FProgram[RawValue.FormatIndex].Step[i].NextStep.Value := StrToInt(RawValue.Value);
      FProgram[RawValue.FormatIndex].Step[i].NextStep.EntryFolder := Data.Folder;
      FProgram[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParser.ParseOutputMode;
var
  i, k : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfOutputs - 1 do
  begin
    for k := 0 to Settings.NumOfSteps - 1 do
    begin
      s := Format(Settings.OutputMode, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FProgram[RawValue.FormatIndex].Step[k].OutputMode[i].Value := StrToInt(RawValue.Value);
        FProgram[RawValue.FormatIndex].Step[k].OutputMode[i].EntryFolder := Data.Folder;
        FProgram[RawValue.FormatIndex].OutputModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParsePause;
var
  i, k : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfIntervalls - 1 do
  begin
    for k := 0 to Settings.NumOfSteps - 1 do
    begin
      s := Format(Settings.PAUSE, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FProgram[RawValue.FormatIndex].Step[k].INTERVALL[i].PAUSE.Value := StrToInt(RawValue.Value);
        FProgram[RawValue.FormatIndex].Step[k].INTERVALL[i].PAUSE.EntryFolder := Data.Folder;
        FProgram[RawValue.FormatIndex].IntervallFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParseProgName;
var
  i : Integer;
  s : string;
  Data : TData;
begin
  for i := 0 to Settings.NumOfProgs - 1 do
  begin
    s := Format(Settings.ProgName, [i + 1]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    if Data.Data.Count >= i + 1 then
    begin
      FProgram[i].Name.Value := Data.Data.Items[i].Value;
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
end;

procedure TCleanProgParser.ParseStepName;
var
  i, k : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfLangs - 1 do
  begin
    for k := 0 to Settings.NumOfSteps - 1 do
    begin
      s := Format(Settings.StepName, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FProgram[RawValue.FormatIndex].Step[k].Name[i].Value := RawValue.Value;
        FProgram[RawValue.FormatIndex].Step[k].Name[i].EntryFolder := Data.Folder;
        FProgram[RawValue.FormatIndex].StepNameFile[i] := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParseStepTime;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.StepTime, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FProgram[RawValue.FormatIndex].Step[i].Time.Value := StrToInt(RawValue.Value);
      FProgram[RawValue.FormatIndex].Step[i].Time.EntryFolder := Data.Folder;
      FProgram[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParser.SaveAsXML(FileName : string);
var
  XML : TXMLFile;
  Node, Node2 : TXMLNode;
  i, j, k : Integer;
  Stream : TFileStream;
  s : string;
begin
  XML := TXMLFile.Create();

  try
    XML.RootNode.Name := 'CleanProg';
    XML.AddNode('SelectedProgram').Attributes.Add('Value', FSelectedProgram);
    XML.AddNode('Language').Attributes.Add('Value', FLanguage);
    XML.AddNode('Delimiter').Attributes.Add('Value', FDelimiter);
    XML.AddNode('FileVersion').Attributes.Add('Value', 12);

    with XML.AddNode('RecipeFileNames') do
    begin
      for i := 0 to High(FRecipeFileName) do
      begin
        with AddNode('FileName_' + IntToStr(i)) do
        begin
          Attributes.Add('FileName', FRecipeFileName[i].FileName);
          Attributes.Add('LineCount', FRecipeFileName[i].Header.Count);
          for j := 0 to FRecipeFileName[i].Header.Count - 1 do
          begin
            AddNode('Line_' + IntToStr(j)).Text_S := FRecipeFileName[i].Header.Strings[j];
          end;
        end;
      end;
    end;

    with XML.AddNode('EntryFolders') do
    begin
      Attributes.Add('LineCount', FEntryFolders.Count);
      for i := 0 to FEntryFolders.Count - 1 do
      begin
        AddNode('Line_' + IntToStr(i)).Text_S := FEntryFolders.Strings[i];
      end;
    end;

    with XML.AddNode('Descriptions') do
    begin
      for i := 0 to High(FDescription) do
      begin
        with AddNode('Language_' + IntToStr(i)) do
        begin
          with AddNode('Outputs') do
          begin
            for j := 0 to High(FDescription[i].Output) do
            begin
              AddNode('Output_' + IntToStr(j)).Text_S := FDescription[i].Output[j];
            end;
          end;
          with AddNode('Inputs') do
          begin
            for j := 0 to High(FDescription[i].Input) do
            begin
              AddNode('Input_' + IntToStr(j)).Text_S := FDescription[i].Input[j];
            end;
          end;
          with AddNode('AnalogIns') do
          begin
            for j := 0 to High(FDescription[i].AnalogIn) do
            begin
              AddNode('AnalogIn_' + IntToStr(j)).Text_S := FDescription[i].AnalogIn[j];
            end;
          end;
          with AddNode('AnalogOuts') do
          begin
            for j := 0 to High(FDescription[i].AnalogOut) do
            begin
              with AddNode('AnalogOut_' + IntToStr(j)) do
              begin
                Attributes.Add('Name', FDescription[i].AnalogOut[j]);
                Attributes.Add('Unit', FDescription[i].AnalogOutUnit[j]);
              end;
            end;
          end;
          with AddNode('Messages') do
          begin
            for j := 0 to FDescription[i].Message.Count - 1 do
            begin
              AddNode('Message_' + IntToStr(j)).Text_S := FDescription[i].Message.Strings[j];
            end;
          end;
        end;
      end;
    end;

    with XML.AddNode('Programs') do
    begin
      Attributes.Add('Count', Settings.NumOfProgs);
      for i := 0 to High(FProgram) do
      begin
        with AddNode('Program_' + IntToStr(i)) do
        begin
          Attributes.Add('Name', FProgram[i].Name.Value);
          Attributes.Add('NameEntryFolder', FProgram[i].Name.EntryFolder);
          with AddNode('FileIndizes') do
          begin
            Attributes.Add('NameFile', FProgram[i].NameFile);
            for j := 0 to High(FProgram[i].StepNameFile) do
            begin
              Attributes.Add('StepNameFile_' + IntToStr(j), FProgram[i].StepNameFile[j]);
            end;
            Attributes.Add('OutputModeFile', FProgram[i].OutputModeFile);
            Attributes.Add('InputModeFile', FProgram[i].InputModeFile);
            Attributes.Add('InputAktivFile', FProgram[i].InputAktivFile);
            Attributes.Add('IntervallFile', FProgram[i].IntervallFile);
            Attributes.Add('AnalogInFile', FProgram[i].AnalogInFile);
            Attributes.Add('AnalogOutFile', FProgram[i].AnalogOutFile);
            Attributes.Add('ModeFile', FProgram[i].ModeFile);
          end;

          with AddNode('Steps') do
          begin
            for j := 0 to High(FProgram[i].Step) do
            begin

              with AddNode('Steps_' + IntToStr(j)) do
              begin
                for k := 0 to High(FProgram[i].Step[j].Name) do
                begin
                  with AddNode('Name_' + IntToStr(k)) do
                  begin
                    Attributes.Add('Value', FProgram[i].Step[j].Name[k].Value);
                    Attributes.Add('EntryFolder', FProgram[i].Step[j].Name[k].EntryFolder);
                  end;
                end;

                with AddNode('Conditions') do
                begin
                  with AddNode('NextCond') do
                  begin
                    Attributes.Add('Value', FProgram[i].Step[j].NextCond.Value);
                    Attributes.Add('EntryFolder', FProgram[i].Step[j].NextCond.EntryFolder);
                  end;
                  with AddNode('NextStep') do
                  begin
                    Attributes.Add('Value', FProgram[i].Step[j].NextStep.Value);
                    Attributes.Add('EntryFolder', FProgram[i].Step[j].NextStep.EntryFolder);
                  end;
                  with AddNode('Time') do
                  begin
                    Attributes.Add('Value', FProgram[i].Step[j].Time.Value);
                    Attributes.Add('EntryFolder', FProgram[i].Step[j].Time.EntryFolder);
                  end;
                  with AddNode('Message') do
                  begin
                    Attributes.Add('Value', FProgram[i].Step[j].Message.Value);
                    Attributes.Add('EntryFolder', FProgram[i].Step[j].Message.EntryFolder);
                  end;
                  with AddNode('Loops') do
                  begin
                    Attributes.Add('Value', FProgram[i].Step[j].LOOPS.Value);
                    Attributes.Add('EntryFolder', FProgram[i].Step[j].LOOPS.EntryFolder);
                  end;
                  with AddNode('AlarmCond') do
                  begin
                    Attributes.Add('Value', FProgram[i].Step[j].AlarmCond.Value);
                    Attributes.Add('EntryFolder', FProgram[i].Step[j].AlarmCond.EntryFolder);
                  end;
                  with AddNode('AlarmStep') do
                  begin
                    Attributes.Add('Value', FProgram[i].Step[j].AlarmStep.Value);
                    Attributes.Add('EntryFolder', FProgram[i].Step[j].AlarmStep.EntryFolder);
                  end;
                  with AddNode('ContrTime') do
                  begin
                    Attributes.Add('Value', FProgram[i].Step[j].ContrTime.Value);
                    Attributes.Add('EntryFolder', FProgram[i].Step[j].ContrTime.EntryFolder);
                  end;
                end;

                with AddNode('OutputModes') do
                begin
                  for k := 0 to High(FProgram[i].Step[j].OutputMode) do
                  begin
                    with AddNode('OutputMode_' + IntToStr(k)) do
                    begin
                      Attributes.Add('Value', FProgram[i].Step[j].OutputMode[k].Value);
                      Attributes.Add('EntryFolder', FProgram[i].Step[j].OutputMode[k].EntryFolder);
                    end;
                  end;
                end;

                with AddNode('Inputs') do
                begin
                  for k := 0 to High(FProgram[i].Step[j].Input) do
                  begin
                    with AddNode('Input_' + IntToStr(k)) do
                    begin
                      with AddNode('Mode') do
                      begin
                        Attributes.Add('Value', FProgram[i].Step[j].Input[k].Mode.Value);
                        Attributes.Add('EntryFolder', FProgram[i].Step[j].Input[k].Mode.EntryFolder);
                      end;
                      with AddNode('Aktiv') do
                      begin
                        Attributes.Add('Value', FProgram[i].Step[j].Input[k].Aktiv.Value);
                        Attributes.Add('EntryFolder', FProgram[i].Step[j].Input[k].Aktiv.EntryFolder);
                      end;
                    end;
                  end;
                end;

                with AddNode('Intervalls') do
                begin
                  for k := 0 to High(FProgram[i].Step[j].INTERVALL) do
                  begin
                    with AddNode('Intervall_' + IntToStr(k)) do
                    begin
                      with AddNode('Intervall') do
                      begin
                        Attributes.Add('Value', FProgram[i].Step[j].INTERVALL[k].INTERVALL.Value);
                        Attributes.Add('EntryFolder', FProgram[i].Step[j].INTERVALL[k].INTERVALL.EntryFolder);
                      end;
                      with AddNode('Pause') do
                      begin
                        Attributes.Add('Value', FProgram[i].Step[j].INTERVALL[k].PAUSE.Value);
                        Attributes.Add('EntryFolder', FProgram[i].Step[j].INTERVALL[k].PAUSE.EntryFolder);
                      end;
                    end;
                  end;
                end;

                with AddNode('AnalogIns') do
                begin
                  for k := 0 to High(FProgram[i].Step[j].AnalogIn) do
                  begin
                    with AddNode('AnalogIn_' + IntToStr(k)) do
                    begin
                      with AddNode('Value') do
                      begin
                        Attributes.Add('Value', FProgram[i].Step[j].AnalogIn[k].Value.Value);
                        Attributes.Add('EntryFolder', FProgram[i].Step[j].AnalogIn[k].Value.EntryFolder);
                      end;
                      with AddNode('Mode') do
                      begin
                        Attributes.Add('Value', FProgram[i].Step[j].AnalogIn[k].Mode.Value);
                        Attributes.Add('EntryFolder', FProgram[i].Step[j].AnalogIn[k].Mode.EntryFolder);
                      end;
                    end;
                  end;
                end;

                with AddNode('AnalogOut') do
                begin
                  for k := 0 to High(FProgram[i].Step[j].AnalogOut) do
                  begin
                    with AddNode('AnalogOut_' + IntToStr(k)) do
                    begin
                      Attributes.Add('Value', FProgram[i].Step[j].AnalogOut[k].Value);
                      Attributes.Add('EntryFolder', FProgram[i].Step[j].AnalogOut[k].EntryFolder);
                    end;
                  end;
                end;

              end;

            end;
          end;

        end;
      end;
    end;

    if Assigned(FPicture) and (FPictureExtension <> '') then
    begin
      s := GetEnvironmentVariable('temp');
      s := IncludeTrailingPathDelimiter(s);
      s := s + 'Test.' + FPictureExtension;
      FPicture.SaveToFile(s);
      Stream := TFileStream.Create(s, fmShareDenyWrite);
      with XML.AddNode('Bitmap') do
      begin
        Attributes.Add('Ext', FPictureExtension);
        SetBinaryData(Stream);
      end;
    end;

    XML.SaveToFile(FileName);
  finally
    FreeAndNil(XML);
    FreeAndNil(Stream);
  end;
end;

procedure TCleanProgParser.SaveFiles(Folder : string);
var
  i, j, lastCreated : Integer;
  s : string;
  k : Integer;
  RecipeFiles : array of TStringList;
const
  cSimpleBoolStrs : array [Boolean] of string = ('0', '1');

  function GetEntryFolder(Index : Integer) : String;
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

begin
  lastCreated := 0;
  SetLength(RecipeFiles, Settings.NumOfFiles);
  try
    for i := 0 to Settings.NumOfFiles - 1 do
    begin
      RecipeFiles[i] := TStringList.Create;
      lastCreated := i;
      RecipeFiles[i].AddStrings(FRecipeFileName[i].Header);
    end;

    for i := 0 to Settings.NumOfProgs - 1 do
    begin
      s := GetEntryFolder(FProgram[i].Name.EntryFolder);
      s := s + Format(Settings.ProgName, [i + 1]);
      // Eigentlich nicht ganz richtig aber Flexible verlangt es so
      for j := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + FProgram[i].Name.Value;
      end;
      RecipeFiles[FProgram[i].NameFile].Add(s);
    end;

    for i := 0 to Settings.NumOfLangs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Name[i].EntryFolder);
        s := s + Format(Settings.StepName, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + FProgram[k].Step[j].Name[i].Value;
        end;
        RecipeFiles[FProgram[0].StepNameFile[i]].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfOutputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].OutputMode[i].EntryFolder);
        s := s + Format(Settings.OutputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].OutputMode[i].Value);
        end;
        RecipeFiles[FProgram[0].OutputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Input[i].Mode.EntryFolder);
        s := s + Format(Settings.InputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FProgram[k].Step[j].Input[i].Mode.Value];
        end;
        RecipeFiles[FProgram[0].InputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Input[i].Aktiv.EntryFolder);
        s := s + Format(Settings.InputAktiv, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FProgram[k].Step[j].Input[i].Aktiv.Value];
        end;
        RecipeFiles[FProgram[0].InputAktivFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].AlarmStep.EntryFolder);
      s := s + Format(Settings.AlarmStep, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].AlarmStep.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].AlarmCond.EntryFolder);
      s := s + Format(Settings.AlarmCond, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].AlarmCond.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].NextCond.EntryFolder);
      s := s + Format(Settings.NextCond, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].NextCond.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].ContrTime.EntryFolder);
      s := s + Format(Settings.ContrTime, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].ContrTime.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].INTERVALL[i].INTERVALL.EntryFolder);
        s := s + Format(Settings.INTERVALL, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].INTERVALL[i].INTERVALL.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].LOOPS.EntryFolder);
      s := s + Format(Settings.LOOPS, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].LOOPS.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].NextStep.EntryFolder);
      s := s + Format(Settings.NextStep, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].NextStep.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].Message.EntryFolder);
      s := s + Format(Settings.MESSAGES, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].Message.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].INTERVALL[i].PAUSE.EntryFolder);
        s := s + Format(Settings.PAUSE, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].INTERVALL[i].PAUSE.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].Time.EntryFolder);
      s := s + Format(Settings.StepTime, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].Time.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogIn[i].Value.EntryFolder);
        s := s + Format(Settings.AnalogIn, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogIn[i].Value.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogIn[i].Mode.EntryFolder);
        s := s + Format(Settings.AnalogMode, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogIn[i].Mode.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogOut - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogOut[i].EntryFolder);
        s := s + Format(Settings.AnalogOut, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogOut[i].Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    s := FRecipeFileName[FProgram[0].NameFile].FileName;
    RecipeFiles[FProgram[0].NameFile].SaveToFile(Folder + s);
    for i := 0 to Settings.NumOfLangs - 1 do
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

procedure TCleanProgParser.SendProgress();
begin
  Inc(FSendCount);
  if Assigned(FOnProgress) and (FSendCount >= 10) then
  begin
    FOnProgress(self, (FCount * 100) / FMaxCount);
    FSendCount := 0;
  end;
end;

procedure TCleanProgParser.SetDescription(const Value : TDescription);
begin
  FDescription[FLanguage] := Value;
end;

procedure TCleanProgParser.SetLanguage(const Value : Integer);
begin
  if not InRange(Value, 1, Settings.NumOfLangs) then
  begin
    raise TCleanProgException.CreateFmt('Selected Language Out of Range Min: %d, Max: %d, Is: %d',
      [1, Settings.NumOfLangs, Value]);
  end;
  FLanguage := Value - 1;
end;

procedure TCleanProgParser.SetProgramName(const Value : string);
begin
  if InRange(FSelectedProgram, 0, Settings.NumOfProgs - 1) then
  begin
    FProgram[FSelectedProgram].Name.Value := Value;
  end;
end;

procedure TCleanProgParser.SetSelectedProgram(const Value : Integer);
begin
  if not InRange(Value, 1, Settings.NumOfProgs) then
  begin
    raise TCleanProgException.CreateFmt('Selected Program Out of Range Min: %d, Max: %d, Is: %d',
      [1, Settings.NumOfProgs, Value]);
  end;
  FSelectedProgram := Value - 1;
end;

procedure TCleanProgParser.SetStep(index : Integer; const Value : TStep);
begin
  if not InRange(index, 0, Settings.NumOfSteps - 1) then
  begin
    raise TCleanProgException.CreateFmt('Selected Step Out of Range Min: %d, Max: %d, Is: %d',
      [0, Settings.NumOfSteps - 1, index]);
  end;
  if InRange(FSelectedProgram, 0, Settings.NumOfProgs - 1) then
  begin
    FProgram[FSelectedProgram].Step[index] := Value;
  end;
end;

procedure TCleanProgParser.SetStepName(index : Integer; const Value : string);
begin
  FProgram[FSelectedProgram].Step[Index].Name[FLanguage].Value := Value;
end;

{ TData }

constructor TData.Create(Data : TList<TRawValue>; FileIndex : Integer; Folder : Integer);
begin
  inherited Create();
  FData := Data;
  FFileIndex := FileIndex;
  FFolder := Folder;
end;

destructor TData.Destroy;
begin
  if Assigned(FData) then
  begin
    FreeAndNil(FData)
  end;
  inherited;
end;

{ TCleanProgParserSingleDatasetName }

procedure TCleanProgParserSingleDatasetName.ParseProgName;
var
  i : Integer;
  s : string;
  Data : TData;
begin
  for i := 0 to Settings.NumOfProgs - 1 do
  begin
    s := Format(Settings.ProgName, [i + 1]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    if Data.Data.Count >= 1 then
    begin
      FProgram[i].Name.Value := Data.Data.Items[0].Value;
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
end;

procedure TCleanProgParserSingleDatasetName.SaveFiles(Folder : String);
var
  i, j, lastCreated : Integer;
  s : string;
  k : Integer;
  RecipeFiles : array of TStringList;
const
  cSimpleBoolStrs : array [Boolean] of string = ('0', '1');

  function GetEntryFolder(Index : Integer) : String;
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

begin
  lastCreated := 0;
  SetLength(RecipeFiles, Settings.NumOfFiles);
  try
    for i := 0 to Settings.NumOfFiles - 1 do
    begin
      RecipeFiles[i] := TStringList.Create;
      lastCreated := i;
      RecipeFiles[i].AddStrings(FRecipeFileName[i].Header);
    end;

    for i := 0 to Settings.NumOfProgs - 1 do
    begin
      s := GetEntryFolder(FProgram[i].Name.EntryFolder);
      s := s + Format(Settings.ProgName, [i + 1]);
      s := s + FDelimiter + FProgram[i].Name.Value;
      RecipeFiles[FProgram[i].NameFile].Add(s);
    end;

    for i := 0 to Settings.NumOfLangs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Name[i].EntryFolder);
        s := s + Format(Settings.StepName, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + FProgram[k].Step[j].Name[i].Value;
        end;
        RecipeFiles[FProgram[0].StepNameFile[i]].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfOutputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].OutputMode[i].EntryFolder);
        s := s + Format(Settings.OutputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].OutputMode[i].Value);
        end;
        RecipeFiles[FProgram[0].OutputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Input[i].Mode.EntryFolder);
        s := s + Format(Settings.InputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FProgram[k].Step[j].Input[i].Mode.Value];
        end;
        RecipeFiles[FProgram[0].InputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].Input[i].Aktiv.EntryFolder);
        s := s + Format(Settings.InputAktiv, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FProgram[k].Step[j].Input[i].Aktiv.Value];
        end;
        RecipeFiles[FProgram[0].InputAktivFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].AlarmStep.EntryFolder);
      s := s + Format(Settings.AlarmStep, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].AlarmStep.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].AlarmCond.EntryFolder);
      s := s + Format(Settings.AlarmCond, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].AlarmCond.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].NextCond.EntryFolder);
      s := s + Format(Settings.NextCond, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].NextCond.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].ContrTime.EntryFolder);
      s := s + Format(Settings.ContrTime, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].ContrTime.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].INTERVALL[i].INTERVALL.EntryFolder);
        s := s + Format(Settings.INTERVALL, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].INTERVALL[i].INTERVALL.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].LOOPS.EntryFolder);
      s := s + Format(Settings.LOOPS, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].LOOPS.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].NextStep.EntryFolder);
      s := s + Format(Settings.NextStep, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].NextStep.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].Message.EntryFolder);
      s := s + Format(Settings.MESSAGES, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].Message.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].INTERVALL[i].PAUSE.EntryFolder);
        s := s + Format(Settings.PAUSE, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + IntToStr(FProgram[k].Step[j].INTERVALL[i].PAUSE.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].Time.EntryFolder);
      s := s + Format(Settings.StepTime, [i]);
      for k := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[k].Step[i].Time.Value);
      end;
      RecipeFiles[FProgram[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogIn[i].Value.EntryFolder);
        s := s + Format(Settings.AnalogIn, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogIn[i].Value.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogIn[i].Mode.EntryFolder);
        s := s + Format(Settings.AnalogMode, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogIn[i].Mode.Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogOut - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FProgram[0].Step[j].AnalogOut[i].EntryFolder);
        s := s + Format(Settings.AnalogOut, [i + 1, j]);
        for k := 0 to Settings.NumOfProgs - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FProgram[k].Step[j].AnalogOut[i].Value);
        end;
        RecipeFiles[FProgram[0].ModeFile].Add(s);
      end;
    end;

    s := FRecipeFileName[FProgram[0].NameFile].FileName;
    RecipeFiles[FProgram[0].NameFile].SaveToFile(Folder + s);
    for i := 0 to Settings.NumOfLangs - 1 do
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

{ TSetting }

constructor TSettings.Create;
begin
  inherited;
  DataSetNameMode := pnmSingleDataSet;
  NumOfFiles := 8;
  NumOfProgs := 20;
  NumOfLangs := 3;
  NumOfSteps := 128;
  NumOfOutputs := 48;
  NumOfInputs := 32;
  NumOfIntervalls := 2;
  NumOfAnalogIn := 8;
  NumOfAnalogOut := 8;

  ProgName := 'CleanProgName%d';
  StepName := 'CleanStep_Language%d_Name%d';
  OutputMode := 'Cleaning_Step.udt_cleaning.aby_output%d_mode[%d]';
  InputMode := 'Cleaning_Step.udt_cleaning.aby_input%d[%d]';
  InputAktiv := 'Cleaning_Step.udt_cleaning.aby_input%d_aktiv[%d]';
  AlarmStep := 'Cleaning_Step.udt_cleaning.ai_alarm_step[%d]';
  AlarmCond := 'Cleaning_Step.udt_cleaning.ai_condition_alarm[%d]';
  NextCond := 'Cleaning_Step.udt_cleaning.ai_condition_next_step[%d]';
  ContrTime := 'Cleaning_Step.udt_cleaning.ai_control_time[%d]';
  INTERVALL := 'Cleaning_Step.udt_cleaning.ai_intervall_%d[%d]';
  LOOPS := 'Cleaning_Step.udt_cleaning.ai_loops[%d]';
  NextStep := 'Cleaning_Step.udt_cleaning.ai_next_step[%d]';
  MESSAGES := 'Cleaning_Step.udt_cleaning.ai_message[%d]';
  PAUSE := 'Cleaning_Step.udt_cleaning.ai_pause_%d[%d]';
  StepTime := 'Cleaning_Step.udt_cleaning.ai_step_time[%d]';
  AnalogIn := 'Cleaning_Step.udt_cleaning.ar_analog_in_%d[%d]';
  AnalogOut := 'Cleaning_Step.udt_cleaning.ar_analog_out_%d[%d]';
  AnalogMode := 'Cleaning_Step.udt_cleaning.ar_mode_ai_%d[%d]';

  MessageListName := 'c_Meldeausgabe';
  InputListName := 'Clean_Input';
  OutputListName := 'Clean_Output';
  AnalogInputListName := 'Clean_Analog_Input';
  AnalogOutputListName := 'Clean_Analog_Output';
  AnalogOutputUnitListName := 'Clean_Analog_Output_Unit';
end;

procedure TSettings.LoadFromFile(sFileName : string);
var
  XML : TXMLFile;
  FileVersion : Integer;
begin
  XML := TXMLFile.Create();
  try
    try
      XML.LoadFromFile(sFileName);
      if XML.RootNode.Nodes.Exists(FILE_VERSION_KEY) then
      begin
        FileVersion := XML.Node[FILE_VERSION_KEY].Attribute['Value'];
      end
      else
      begin
        FileVersion := 10;
      end;

      case FileVersion of
        10 :
          begin
            DataSetNameMode := TProgramNameMode(XML.Node[DATA_SET_MODE_KEY].Attribute['Value']);
            NumOfProgs := XML.Node[NUM_OF_PROGS_KEY].Attribute['Value'];
            NumOfFiles := XML.Node[NUM_OF_FILES_KEY].Attribute['Value'];
            NumOfLangs := XML.Node[NUM_OF_LANGS_KEY].Attribute['Value'];
            NumOfSteps := XML.Node[NUM_OF_STEPS_KEY].Attribute['Value'];
            NumOfOutputs := XML.Node[NUM_OF_OUTPUTS_KEY].Attribute['Value'];
            NumOfInputs := XML.Node[NUM_OF_INPUTS_KEY].Attribute['Value'];
            NumOfIntervalls := XML.Node[NUM_OF_INTERVALLS_KEY].Attribute['Value'];
            NumOfAnalogIn := XML.Node[NUM_OF_ANALOG_IN_KEY].Attribute['Value'];
            NumOfAnalogOut := XML.Node[NUM_OF_ANALOG_OUT_KEY].Attribute['Value'];

            ProgName := XML.Node[PROG_NAME_KEY].Attribute['Value'];
            StepName := XML.Node[STEP_NAME_KEY].Attribute['Value'];
            OutputMode := XML.Node[OUTPUT_MODE_KEY].Attribute['Value'];
            InputMode := XML.Node[INPUT_MODE_KEY].Attribute['Value'];
            InputAktiv := XML.Node[INPUT_AKTIV_KEY].Attribute['Value'];
            AlarmStep := XML.Node[ALARM_STEP_KEY].Attribute['Value'];
            AlarmCond := XML.Node[ALARM_COND_KEY].Attribute['Value'];
            NextCond := XML.Node[NEXT_COND_KEY].Attribute['Value'];
            ContrTime := XML.Node[CONTR_TIME_KEY].Attribute['Value'];
            INTERVALL := XML.Node[INTERVALL_KEY].Attribute['Value'];
            LOOPS := XML.Node[LOOPS_KEY].Attribute['Value'];
            NextStep := XML.Node[NEXT_STEP_KEY].Attribute['Value'];
            MESSAGES := XML.Node[MESSAGES_KEY].Attribute['Value'];
            PAUSE := XML.Node[PAUSE_KEY].Attribute['Value'];
            StepTime := XML.Node[STEP_TIME_KEY].Attribute['Value'];
            AnalogIn := XML.Node[ANALOG_IN_KEY].Attribute['Value'];
            AnalogOut := XML.Node[ANALOG_OUT_KEY].Attribute['Value'];
            AnalogMode := XML.Node[ANALOG_MODE_KEY].Attribute['Value'];

            MessageListName := XML.Node[MESSAGE_LIST_NAME_KEY].Attribute['Value'];
            InputListName := XML.Node[INPUT_LIST_NAME_KEY].Attribute['Value'];
            OutputListName := XML.Node[OUTPUT_LIST_NAME_KEY].Attribute['Value'];
            AnalogInputListName := XML.Node[ANALOG_INPUT_LIST_NAME_KEY].Attribute['Value'];
            AnalogOutputListName := XML.Node[ANALOG_OUTPUT_LIST_NAME_KEY].Attribute['Value'];
            AnalogOutputUnitListName := XML.Node[ANALOG_OUTPUT_UNIT_LIST_NAME_KEY].Attribute['Value'];
          end
        // 11 :
      end;
    except
      on E : Exception do
      begin
        FreeAndNil(XML);
        raise TCleanProgException.CreateFmt('Fehler in der Konfiguration: %s', [E.Message]);
      end;
    end;
  finally
    FreeAndNil(XML);
  end;
end;

procedure TSettings.SetAlarmCond(const Value : String);
begin
  FAlarmCond := Value;
end;

procedure TSettings.SetAlarmStep(const Value : String);
begin
  FAlarmStep := Value;
end;

procedure TSettings.SetAnalogIn(const Value : String);
begin
  FAnalogIn := Value;
end;

procedure TSettings.SetAnalogInputListName(const Value : String);
begin
  FAnalogInputListName := Value;
end;

procedure TSettings.SetAnalogMode(const Value : String);
begin
  FAnalogMode := Value;
end;

procedure TSettings.SetAnalogOut(const Value : String);
begin
  FAnalogOut := Value;
end;

procedure TSettings.SetAnalogOutputListName(const Value : String);
begin
  FAnalogOutputListName := Value;
end;

procedure TSettings.SetAnalogOutputUnitListName(const Value : String);
begin
  FAnalogOutputUnitListName := Value;
end;

procedure TSettings.SetContrTime(const Value : String);
begin
  FContrTime := Value;
end;

procedure TSettings.SetDataSetNameMode(const Value : TProgramNameMode);
begin
  FDataSetNameMode := Value;
end;

procedure TSettings.SetInputAktiv(const Value : String);
begin
  FInputAktiv := Value;
end;

procedure TSettings.SetInputListName(const Value : String);
begin
  FInputListName := Value;
end;

procedure TSettings.SetInputMode(const Value : String);
begin
  FInputMode := Value;
end;

procedure TSettings.SetIntervall(const Value : String);
begin
  FIntervall := Value;
end;

procedure TSettings.SetLoops(const Value : String);
begin
  FLoops := Value;
end;

procedure TSettings.SetMessageListName(const Value : String);
begin
  FMessageListName := Value;
end;

procedure TSettings.SetMessages(const Value : String);
begin
  FMessages := Value;
end;

procedure TSettings.SetNextCond(const Value : String);
begin
  FNextCond := Value;
end;

procedure TSettings.SetNextStep(const Value : String);
begin
  FNextStep := Value;
end;

procedure TSettings.SetNumOfAnalogIn(const Value : Integer);
begin
  FNumOfAnalogIn := Value;
end;

procedure TSettings.SetNumOfAnalogOut(const Value : Integer);
begin
  FNumOfAnalogOut := Value;
end;

procedure TSettings.SetNumOfFiles(const Value : Integer);
begin
  FNumOfFiles := Value;
end;

procedure TSettings.SetNumOfInputs(const Value : Integer);
begin
  FNumOfInputs := Value;
end;

procedure TSettings.SetNumOfIntervalls(const Value : Integer);
begin
  FNumOfIntervalls := Value;
end;

procedure TSettings.SetNumOfLangs(const Value : Integer);
begin
  FNumOfLangs := Value;
end;

procedure TSettings.SetNumOfOutputs(const Value : Integer);
begin
  FNumOfOutputs := Value;
end;

procedure TSettings.SetNumOfProgs(const Value : Integer);
begin
  FNumOfProgs := Value;
end;

procedure TSettings.SetNumOfSteps(const Value : Integer);
begin
  FNumOfSteps := Value;
end;

procedure TSettings.SetOutputListName(const Value : String);
begin
  FOutputListName := Value;
end;

procedure TSettings.SetOutputMode(const Value : String);
begin
  FOutputMode := Value;
end;

procedure TSettings.SetPause(const Value : String);
begin
  FPause := Value;
end;

procedure TSettings.SetProgName(const Value : String);
begin
  FProgName := Value;
end;

procedure TSettings.SetStepName(const Value : String);
begin
  FStepName := Value;
end;

procedure TSettings.SetStepTime(const Value : String);
begin
  FStepTime := Value;
end;

{ TStep }

function TStep.Copy : TStep;
var
  Buffer : TStep;
begin
  Buffer.Name := System.Copy(self.Name);
  Buffer.OutputMode := System.Copy(self.OutputMode);
  Buffer.Input := System.Copy(self.Input);
  Buffer.INTERVALL := System.Copy(self.INTERVALL);
  Buffer.AnalogIn := System.Copy(self.AnalogIn);
  Buffer.AnalogOut := System.Copy(self.AnalogOut);
  Buffer.AlarmStep := self.AlarmStep;
  Buffer.AlarmCond := self.AlarmCond;
  Buffer.NextCond := self.NextCond;
  Buffer.ContrTime := self.ContrTime;
  Buffer.LOOPS := self.LOOPS;
  Buffer.NextStep := self.NextStep;
  Buffer.Message := self.Message;
  Buffer.Time := self.Time;
  Result := Buffer;
end;

end.
