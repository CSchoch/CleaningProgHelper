unit uCleanProgParser;

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

  TProgressEvent = procedure(Sender : TObject; Progress : Real) of object;
  TSelectLangIndexEvent = procedure(Sender : TObject; LangDesc : TStringList; out Indizes : TList<Integer>) of object;

  TData = class(TObject)
  private
    FString : string;
    FFileIndex : Integer;
    FFolder : Integer;
  public
    constructor Create(Data : string; FileIndex : Integer; Folder : Integer);
    property Data : string read FString;
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
    Name : array [0 .. NUM_OF_LANGS - 1] of TValue<string>;
    OutputMode : array [0 .. NUM_OF_OUTPUTS - 1] of TValue<Integer>;
    Input : array [0 .. NUM_OF_INPUTS - 1] of TInput;
    INTERVALL : array [0 .. NUM_OF_INTERVALLS - 1] of TIntervall;
    AnalogIn : array [0 .. NUM_OF_ANALOG_IN - 1] of TAnalogIn;
    AnalogOut : array [0 .. NUM_OF_ANALOG_OUT - 1] of TValue<Real>;
    AlarmStep : TValue<Integer>;
    AlarmCond : TValue<Integer>;
    NextCond : TValue<Integer>;
    ContrTime : TValue<Integer>;
    LOOPS : TValue<Integer>;
    NextStep : TValue<Integer>;
    Message : TValue<Integer>;
    Time : TValue<Integer>;
  end;

  TDescription = record
    Output : array [0 .. NUM_OF_OUTPUTS - 1] of string;
    Input : array [0 .. NUM_OF_INPUTS - 1] of string;
    AnalogIn : array [0 .. NUM_OF_ANALOG_IN - 1] of string;
    AnalogOut : array [0 .. NUM_OF_ANALOG_OUT - 1] of string;
    AnalogOutUnit : array [0 .. NUM_OF_ANALOG_OUT - 1] of string;
    Message : TStringList;
  end;

  TProgram = record
    Name : TValue<string>;
    Step : array [0 .. NUM_OF_STEPS - 1] of TStep;
    NameFile : Integer;
    StepNameFile : array [0 .. NUM_OF_LANGS - 1] of Integer;
    OutputModeFile : Integer;
    InputModeFile : Integer;
    InputAktivFile : Integer;
    IntervallFile : Integer;
    AnalogInFile : Integer;
    AnalogOutFile : Integer;
    ModeFile : Integer;
  end;

  TCleanProgParser = class(TObject)
  protected
    FPicture : TPicture;
    FPictureExtension : string;
    FFormatCount : Integer;
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
    FDescription : array [0 .. NUM_OF_LANGS - 1] of TDescription;
    FRecipeFileName : array [0 .. NUM_OF_FILES - 1] of TRecipeFileName;
    FEntryFolders : TStringList;

    procedure LoadFile(FileName : string; FileIndex : Integer);
    procedure LoadXMLV10(XML : TXMLFile);
    procedure LoadXMLV11(XML : TXMLFile);
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
    constructor Create();
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
    property FormatCount : Integer read FFormatCount;
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
begin
  if not InRange(Target, 1, FFormatCount) then
  begin
    raise Exception.CreateFmt('Selected target Out of Range Min: %d, Max: %d, Is: %d', [1, FFormatCount, Target]);
  end;
  FProgram[Target - 1] := FProgram[FSelectedProgram];
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
    FFormatCount := Attributes['Count'];
    SetLength(FProgram, FFormatCount);
    for i := 0 to FFormatCount - 1 do
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
    FFormatCount := Attributes['Count'];
    SetLength(FProgram, FFormatCount);
    for i := 0 to FFormatCount - 1 do
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
              for k := 0 to NUM_OF_LANGS - 1 do
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
  FStepBuffer := FProgram[FSelectedProgram].Step[Index];
end;

constructor TCleanProgParser.Create();
var
  i : Integer;
begin
  inherited Create();

  FLines := TDictionary<String, TData>.Create;
  for i := 0 to High(FDescription) do
  begin
    FDescription[i].Message := TStringList.Create;
  end;
  FEntryFolders := TStringList.Create;
  FEntryFolders.Sorted := True;
  FEntryFolders.Duplicates := dupIgnore;
end;

procedure TCleanProgParser.CutStep(Index : Integer);
var
  i : Integer;
begin
  FStepBuffer := FProgram[FSelectedProgram].Step[Index];
  for i := Index to NUM_OF_STEPS - 2 do
  begin
    FProgram[FSelectedProgram].Step[i] := FProgram[FSelectedProgram].Step[i + 1];
  end;
  for i := 0 to NUM_OF_STEPS - 1 do
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

  for i := 0 to NUM_OF_FILES - 1 do
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
  if InRange(FSelectedProgram, 0, FFormatCount - 1) then
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
  if not InRange(index, 0, NUM_OF_STEPS - 1) then
  begin
    raise Exception.CreateFmt('Selected Step Out of Range Min: %d, Max: %d, Is: %d', [0, NUM_OF_STEPS - 1, index]);
  end;
  if InRange(FSelectedProgram, 0, FFormatCount - 1) then
  begin
    Result := FProgram[FSelectedProgram].Step[index];
  end;
end;

function TCleanProgParser.GetStepCount : Integer;
begin
  Result := NUM_OF_STEPS;
end;

function TCleanProgParser.GetStepName(index : Integer) : string;
begin
  Result := FProgram[FSelectedProgram].Step[Index].Name[FLanguage].Value;
end;

procedure TCleanProgParser.InsertStep(Index : Integer);
var
  i : Integer;
begin
  for i := NUM_OF_STEPS - 2 downto Index do
  begin
    FProgram[FSelectedProgram].Step[i + 1] := FProgram[FSelectedProgram].Step[i];
  end;
  for i := 0 to NUM_OF_STEPS - 1 do
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
  FProgram[FSelectedProgram].Step[Index] := FStepBuffer;
end;

procedure TCleanProgParser.LoadDescription(DescFile : String);
var
  sl : TStringList;
  i, j, k : Integer;
  LangIndexSelected : Boolean;
  Divider, DividerInner : TStringDivider;
  aTemp, aTempInner : csExplode.TStringDynArray;
  aIndex : array [0 .. NUM_OF_LANGS - 1] of Integer;
  aDesc : array [0 .. NUM_OF_LANGS - 1] of String;
  aText : array [0 .. NUM_OF_LANGS - 1] of String;
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
    for i := 0 to NUM_OF_LANGS - 1 do
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
        case CaseStringIOf(GetString(aTemp[0]), [MESSAGE_LIST_NAME, INPUT_LIST_NAME, OUTPUT_LIST_NAME,
          ANALOG_INPUT_LIST_NAME, ANALOG_OUTPUT_LIST_NAME, ANALOG_OUTPUT_UNIT_LIST_NAME]) of
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
                FOnSelectLangIndex(Self, LangDesc, Indizes);
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
                FOnSelectLangIndex(Self, LangDesc, Indizes);
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
                if k < NUM_OF_INPUTS then
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
                FOnSelectLangIndex(Self, LangDesc, Indizes);
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
                if k < NUM_OF_OUTPUTS then
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
                FOnSelectLangIndex(Self, LangDesc, Indizes);
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
                if k < NUM_OF_ANALOG_IN then
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
                FOnSelectLangIndex(Self, LangDesc, Indizes);
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
                if k < NUM_OF_ANALOG_OUT then
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
                FOnSelectLangIndex(Self, LangDesc, Indizes);
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
                if k < NUM_OF_ANALOG_OUT then
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
  // j : Integer;
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
          Data := TData.Create(s, FileIndex, FolderIndex);
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

procedure TCleanProgParser.LoadFiles(Files : TStrings);
var
  i : Integer;
  Data : TArray<TData>;
begin

  if Files.Count <> NUM_OF_FILES then
  begin
    raise Exception.CreateFmt('Incorrect File Count is (%d), should be (%d)', [Files.Count, NUM_OF_FILES]);
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
    end;

  finally
    FreeAndNil(XML);
  end;
end;

procedure TCleanProgParser.ParseAlarmCond;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseAlarmStep;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseAnalogIn;
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
          raise Exception.CreateFmt('Value %s not Found', [s]);
        end;
        Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseAnalogMode;
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
          raise Exception.CreateFmt('Value %s not Found', [s]);
        end;
        Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseAnalogOut;
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
          raise Exception.CreateFmt('Value %s not Found', [s]);
        end;
        Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseContrTime;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseInputAktiv;
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
          raise Exception.CreateFmt('Value %s not Found', [s]);
        end;
        Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseInputMode;
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
          raise Exception.CreateFmt('Value %s not Found', [s]);
        end;
        Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseIntervall;
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
          raise Exception.CreateFmt('Value %s not Found', [s]);
        end;
        Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseLoops;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseMessage;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseNextCond;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseNextStep;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseOutputMode;
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
          raise Exception.CreateFmt('Value %s not Found', [s]);
        end;
        Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParsePause;
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
          raise Exception.CreateFmt('Value %s not Found', [s]);
        end;
        Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseProgName;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseStepName;
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
          raise Exception.CreateFmt('Value %s not Found', [s]);
        end;
        Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParser.ParseStepTime;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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
    XML.AddNode('FileVersion').Attributes.Add('Value', 11);

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
              AddNode('AnalogOut_' + IntToStr(j)).Text_S := FDescription[i].AnalogOut[j];
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
      Attributes.Add('Count', FFormatCount);
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
  RecipeFiles : array [0 .. NUM_OF_FILES - 1] of TStringList;
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

procedure TCleanProgParser.SendProgress();
begin
  Inc(FSendCount);
  if Assigned(FOnProgress) and (FSendCount >= 10) then
  begin
    FOnProgress(Self, (FCount * 100) / FMaxCount);
    FSendCount := 0;
  end;
end;

procedure TCleanProgParser.SetDescription(const Value : TDescription);
begin
  FDescription[FLanguage] := Value;
end;

procedure TCleanProgParser.SetLanguage(const Value : Integer);
begin
  if not InRange(Value, 1, NUM_OF_LANGS) then
  begin
    raise Exception.CreateFmt('Selected Language Out of Range Min: %d, Max: %d, Is: %d', [1, NUM_OF_LANGS, Value]);
  end;
  FLanguage := Value - 1;
end;

procedure TCleanProgParser.SetProgramName(const Value : string);
begin
  if InRange(FSelectedProgram, 0, FFormatCount - 1) then
  begin
    FProgram[FSelectedProgram].Name.Value := Value;
  end;
end;

procedure TCleanProgParser.SetSelectedProgram(const Value : Integer);
begin
  if not InRange(Value, 1, FFormatCount) then
  begin
    raise Exception.CreateFmt('Selected Program Out of Range Min: %d, Max: %d, Is: %d', [1, FFormatCount, Value]);
  end;
  FSelectedProgram := Value - 1;
end;

procedure TCleanProgParser.SetStep(index : Integer; const Value : TStep);
begin
  if not InRange(index, 0, NUM_OF_STEPS - 1) then
  begin
    raise Exception.CreateFmt('Selected Step Out of Range Min: %d, Max: %d, Is: %d', [0, NUM_OF_STEPS - 1, index]);
  end;
  if InRange(FSelectedProgram, 0, FFormatCount - 1) then
  begin
    FProgram[FSelectedProgram].Step[index] := Value;
  end;
end;

procedure TCleanProgParser.SetStepName(index : Integer; const Value : string);
begin
  FProgram[FSelectedProgram].Step[Index].Name[FLanguage].Value := Value;
end;

{ TData }

constructor TData.Create(Data : string; FileIndex : Integer; Folder : Integer);
begin
  inherited Create();
  FString := Data;
  FFileIndex := FileIndex;
  FFolder := Folder;
end;

destructor TData.Destroy;
begin
  FString := '';

  inherited;
end;

{ TCleanProgParserSingleDatasetName }

procedure TCleanProgParserSingleDatasetName.ParseProgName;
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
        raise Exception.CreateFmt('Value %s not Found', [s]);
      end;
      Divider.Explode(Data.Data, aTemp);
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

procedure TCleanProgParserSingleDatasetName.SaveFiles(Folder : String);
var
  i, j, lastCreated : Integer;
  s : string;
  k : Integer;
  RecipeFiles : array [0 .. NUM_OF_FILES - 1] of TStringList;
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

end.
