unit uCleanProg.Parser;
{ TODO : Export nach Datensatzanzahl }
{ TODO : Programmnamen Export nach Datensatzanzahl Programmnamen }
{ TODO : Threaded parsing }
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
  uCleanProg,
  uCleanProg.Settings,
  OtlCommon,
  OtlTask,
  OtlTaskControl,
  OtlComm;

type

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
    FSelectedBlock : Integer;
    FLanguage : Integer;
    FDelimiter : Char;
    FLines : TDictionary<String, TData>;
    FOnProgress : TProgressEvent;
    FOnSelectLangIndex : TSelectLangIndexEvent;
    FStepBuffer : TStep;
    FProgram : array of TProgram;
    FBlock : array of TBlock;
    FDescription : array of TDescription;
    FRecipeFileName : array of TRecipeFileName;
    FEntryFolders : TStringList;

    procedure LoadFile(FileName : string; FileIndex : Integer);
    procedure LoadXMLV10(XML : TXMLFile);
    procedure LoadXMLV11(XML : TXMLFile);
    procedure LoadXMLV12(XML : TXMLFile);
    procedure LoadXMLV13(XML : TXMLFile);
    procedure SendProgress();
    procedure ParseFiles(); virtual;
    procedure ParseBlockName; virtual;
    procedure ParseStepName;
    procedure ParseOutputMode;
    procedure ParseInputMode;
    procedure ParseInputAktiv;
    procedure ParseIntervall;
    procedure ParsePause;
    procedure ParseAnalogIn;
    procedure ParseAnalogMode;
    procedure ParseAnalogOut;
    procedure ParseAlarmStep;
    procedure ParseAlarmCond;
    procedure ParseNextCond;
    procedure ParseContrTime;
    procedure ParseLoops;
    procedure ParseNextStep;
    procedure ParseMessage;
    procedure ParseStepTime;
    function GetStepCount : Integer;
    function GetStep(index : Integer) : TStep;
    procedure SetStep(index : Integer; const Value : TStep);
    function GetBlockName : string;
    procedure SetBlockName(const Value : string);
    function GetBlockNames(index : Integer) : string;
    procedure SetSelectedBlock(const Value : Integer);
    function GetDescription : TDescription;
    procedure SetDescription(const Value : TDescription);
    function GetSelectedBlock : Integer;
    function GetLanguage : Integer;
    procedure SetLanguage(const Value : Integer);
    function GetStepName(index : Integer) : string;
    procedure SetStepName(index : Integer; const Value : string);
    function GetProgramStep(index : Integer) : Integer;
    procedure SetProgramStep(index : Integer; const Value : Integer);
    function GetProgramName : string;
    function GetSelectedProgram : Integer;
    procedure SetProgramName(const Value : string);
    procedure SetSelectedProgram(const Value : Integer);
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
    procedure CopyBlock(Target : Integer);
    property Settings : TSettings read FSettings write FSettings;
    property OnProgress : TProgressEvent read FOnProgress write FOnProgress;
    property OnSelectLangIndex : TSelectLangIndexEvent read FOnSelectLangIndex write FOnSelectLangIndex;
    property StepCount : Integer read GetStepCount;
    property SelectedProgram : Integer read GetSelectedProgram write SetSelectedProgram;
    property SelectedBlock : Integer read GetSelectedBlock write SetSelectedBlock;
    property Step[index : Integer] : TStep read GetStep write SetStep;
    property StepName[index : Integer] : string read GetStepName write SetStepName;
    property Description : TDescription read GetDescription write SetDescription;
    property ProgramStep[index : Integer] : Integer read GetProgramStep write SetProgramStep;
    property ProgramName : string read GetProgramName write SetProgramName;
    property BlockName : string read GetBlockName write SetBlockName;
    property BlockNames[index : Integer] : string read GetBlockNames;
    property Language : Integer read GetLanguage write SetLanguage;
    property Picture : TPicture read FPicture write FPicture;
    property PictureExtension : string read FPictureExtension write FPictureExtension;
  end;

  TCleanProgParserSingleDatasetName = class(TCleanProgParser)
  protected
    procedure ParseBlockName; override;
  public
    procedure SaveFiles(Folder : String); override;
  end;

  TCleanProgParserBlockBased = class(TCleanProgParserSingleDatasetName)
  protected
    procedure ParseFiles(); override;
  public
    procedure SaveFiles(Folder : String); override;
  protected
    procedure ParseProgramName;
    procedure ParseProgramStep;
    procedure ParseInputModeAlternate;
    procedure ParseInputAktivAlternate;
    procedure ParseAnalogInAlternate;
    procedure ParseAnalogModeAlternate;
    procedure ParseNextCondAlternate;
    procedure ParseNextStepAlternate;

  end;

implementation

uses
  StrUtils,
  Windows,
  Math,
  csExplode,
  csUtils;

{ TCleanProgParser }

procedure TCleanProgParser.CopyBlock(Target : Integer);
var
  i : Integer;
begin
  if not InRange(Target, 1, Settings.NumOfBlocks) then
  begin
    raise TCleanProgException.CreateFmt('Selected target Out of Range Min: %d, Max: %d, Is: %d',
      [1, Settings.NumOfBlocks, Target]);
  end;
  FBlock[Target - 1].Name := FBlock[FSelectedBlock].Name;
  for i := low(FBlock[FSelectedBlock].Step) to high(FBlock[FSelectedBlock].Step) do
  begin
    FBlock[Target - 1].Step[i] := FBlock[FSelectedBlock].Step[i].Copy;
  end;
  FBlock[Target - 1].NameFile := FBlock[FSelectedBlock].NameFile;
  FBlock[Target - 1].StepNameFile := System.Copy(FBlock[FSelectedBlock].StepNameFile);
  FBlock[Target - 1].OutputModeFile := FBlock[FSelectedBlock].OutputModeFile;
  FBlock[Target - 1].InputModeFile := FBlock[FSelectedBlock].InputModeFile;
  FBlock[Target - 1].InputAlternateModeFile := FBlock[FSelectedBlock].InputAlternateModeFile;
  FBlock[Target - 1].InputAktivFile := FBlock[FSelectedBlock].InputAktivFile;
  FBlock[Target - 1].InputAlternateAktivFile := FBlock[FSelectedBlock].InputAlternateAktivFile;
  FBlock[Target - 1].IntervallFile := FBlock[FSelectedBlock].IntervallFile;
  FBlock[Target - 1].AnalogInValueFile := FBlock[FSelectedBlock].AnalogInValueFile;
  FBlock[Target - 1].AnalogInAlternateValueFile := FBlock[FSelectedBlock].AnalogInAlternateValueFile;
  FBlock[Target - 1].AnalogInModeFile := FBlock[FSelectedBlock].AnalogInModeFile;
  FBlock[Target - 1].AnalogInAlternateModeFile := FBlock[FSelectedBlock].AnalogInAlternateModeFile;
  FBlock[Target - 1].AnalogOutFile := FBlock[FSelectedBlock].AnalogOutFile;
  FBlock[Target - 1].ModeFile := FBlock[FSelectedBlock].ModeFile;
end;

procedure TCleanProgParser.ParseFiles;
begin
  FMaxCount := FMaxCount + Settings.NumOfBlocks + // Loops to parse block names
    (Settings.NumOfLangs * Settings.NumOfSteps * FDataSetCount) + // Loops to parse step names
    (2 * Settings.NumOfInputs * Settings.NumOfSteps * FDataSetCount) + // Loops to parse inputs
    (2 * Settings.NumOfIntervalls * Settings.NumOfSteps * FDataSetCount) + // Loops to parse intervalls
    (2 * Settings.NumOfAnalogIn * Settings.NumOfSteps * FDataSetCount) + // Loops to parse analog inputs
    (Settings.NumOfAnalogOut * Settings.NumOfSteps * FDataSetCount) + // Loops to parse analog outputs
    (8 * Settings.NumOfSteps * FDataSetCount) + // Loops to parse step control values
    (Settings.NumOfOutputs * Settings.NumOfSteps * FDataSetCount); // Loops to parse outputs

  FSendCount := 100;

  SendProgress;
  ParseBlockName;
  ParseStepName;
  ParseOutputMode;
  ParseInputMode;
  ParseInputAktiv;
  ParseIntervall;
  ParsePause;
  ParseAnalogIn;
  ParseAnalogMode;
  ParseAnalogOut;
  ParseAlarmStep;
  ParseAlarmCond;
  ParseNextCond;
  ParseContrTime;
  ParseLoops;
  ParseNextStep;
  ParseMessage;
  ParseStepTime;
end;

procedure TCleanProgParser.LoadXMLV10(XML : TXMLFile);
var
  k : Integer;
  Stream : TFileStream;
  s : string;
  j : Integer;
  i : Integer;
begin
  FSelectedBlock := XML.Node['SelectedProgram'].Attribute['Value'];
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
    Settings.NumOfBlocks := Attributes['Count'];
    SetLength(FBlock, Settings.NumOfBlocks);
    for i := 0 to Settings.NumOfBlocks - 1 do
    begin
      with Node['Program_' + IntToStr(i)] do
      begin
        FBlock[i].Name.Value := Attribute['Name'];
        FBlock[i].Name.EntryFolder := - 1;
        with Node['FileIndizes'] do
        begin
          FBlock[i].NameFile := Attribute['NameFile'];
          for j := 0 to High(FBlock[i].StepNameFile) do
          begin
            if Attributes.IndexOf('StepNameFile_' + IntToStr(j)) <> - 1 then
            begin
              FBlock[i].StepNameFile[j] := Attribute['StepNameFile_' + IntToStr(j)];
            end;
          end;
          FBlock[i].OutputModeFile := Attribute['OutputModeFile'];
          FBlock[i].InputModeFile := Attribute['InputModeFile'];
          FBlock[i].InputAlternateModeFile := Attribute['InputModeFile'];
          FBlock[i].InputAktivFile := Attribute['InputAktivFile'];
          FBlock[i].InputAlternateAktivFile := Attribute['InputAktivFile'];
          FBlock[i].IntervallFile := Attribute['IntervallFile'];
          FBlock[i].AnalogInValueFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogInAlternateValueFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogInModeFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogInAlternateModeFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogOutFile := Attribute['AnalogOutFile'];
          FBlock[i].ModeFile := Attribute['ModeFile'];
        end;
        with Node['Steps'] do
        begin
          for j := 0 to Nodes.Count - 1 do
          begin

            with Node['Steps_' + IntToStr(j)] do
            begin
              for k := 0 to Attributes.Count - 1 do
              begin
                FBlock[i].Step[j].Name[k].Value := Attribute['Name_' + IntToStr(k)];
                FBlock[i].Step[j].Name[k].EntryFolder := - 1;
              end;

              with Node['Conditions'] do
              begin
                FBlock[i].Step[j].NextCond.Value := Attribute['NextCond'];
                FBlock[i].Step[j].NextCond.EntryFolder := - 1;
                FBlock[i].Step[j].NextCondAlternate.Value := 0;
                FBlock[i].Step[j].NextCondAlternate.EntryFolder := - 1;
                FBlock[i].Step[j].NextStep.Value := Attribute['NextStep'];
                FBlock[i].Step[j].NextStep.EntryFolder := - 1;
                FBlock[i].Step[j].NextStepAlternate.Value := 0;
                FBlock[i].Step[j].NextStepAlternate.EntryFolder := - 1;
                FBlock[i].Step[j].Time.Value := Attribute['Time'];
                FBlock[i].Step[j].Time.EntryFolder := - 1;
                FBlock[i].Step[j].Message.Value := Attribute['Message'];
                FBlock[i].Step[j].Message.EntryFolder := - 1;
                FBlock[i].Step[j].LOOPS.Value := Attribute['Loops'];
                FBlock[i].Step[j].LOOPS.EntryFolder := - 1;
                FBlock[i].Step[j].AlarmCond.Value := Attribute['AlarmCond'];
                FBlock[i].Step[j].AlarmCond.EntryFolder := - 1;
                FBlock[i].Step[j].AlarmStep.Value := Attribute['AlarmStep'];
                FBlock[i].Step[j].AlarmStep.EntryFolder := - 1;
                FBlock[i].Step[j].ContrTime.Value := Attribute['ContrTime'];
                FBlock[i].Step[j].ContrTime.EntryFolder := - 1;
              end;

              with Node['OutputModes'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  FBlock[i].Step[j].OutputMode[k].Value := Node['OutputMode_' + IntToStr(k)].Text;
                  FBlock[i].Step[j].OutputMode[k].EntryFolder := - 1;
                end;
              end;

              with Node['Inputs'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['Input_' + IntToStr(k)] do
                  begin
                    FBlock[i].Step[j].Input[k].Default.Mode.Value := TVarData(Attribute['Mode']).VBoolean;
                    FBlock[i].Step[j].Input[k].Default.Mode.EntryFolder := - 1;
                    FBlock[i].Step[j].Input[k].Default.Aktiv.Value := TVarData(Attribute['Aktiv']).VBoolean;
                    FBlock[i].Step[j].Input[k].Default.Aktiv.EntryFolder := - 1;
                    FBlock[i].Step[j].Input[k].Alternate.Mode.Value := False;
                    FBlock[i].Step[j].Input[k].Alternate.Mode.EntryFolder := - 1;
                    FBlock[i].Step[j].Input[k].Alternate.Aktiv.Value := False;
                    FBlock[i].Step[j].Input[k].Alternate.Aktiv.EntryFolder := - 1;
                  end;
                end;
              end;

              with Node['Intervalls'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['Intervall_' + IntToStr(k)] do
                  begin
                    FBlock[i].Step[j].INTERVALL[k].INTERVALL.Value := Attribute['Intervall'];
                    FBlock[i].Step[j].INTERVALL[k].INTERVALL.EntryFolder := - 1;
                    FBlock[i].Step[j].INTERVALL[k].PAUSE.Value := Attribute['Pause'];
                    FBlock[i].Step[j].INTERVALL[k].PAUSE.EntryFolder := - 1;
                  end;
                end;
              end;

              with Node['AnalogIns'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['AnalogIn_' + IntToStr(k)] do
                  begin
                    FBlock[i].Step[j].AnalogIn[k].Default.Value.Value := Attribute['Value'];
                    FBlock[i].Step[j].AnalogIn[k].Default.Value.EntryFolder := - 1;
                    FBlock[i].Step[j].AnalogIn[k].Default.Mode.Value := Attribute['Mode'];
                    FBlock[i].Step[j].AnalogIn[k].Default.Mode.EntryFolder := - 1;
                    FBlock[i].Step[j].AnalogIn[k].Alternate.Value.Value := 0;
                    FBlock[i].Step[j].AnalogIn[k].Alternate.Value.EntryFolder := - 1;
                    FBlock[i].Step[j].AnalogIn[k].Alternate.Mode.Value := 0;
                    FBlock[i].Step[j].AnalogIn[k].Alternate.Mode.EntryFolder := - 1;
                  end;
                end;
              end;

              with Node['AnalogOut'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  FBlock[i].Step[j].AnalogOut[k].Value := Node['AnalogOut_' + IntToStr(k)].Text;
                  FBlock[i].Step[j].AnalogOut[k].EntryFolder := - 1;
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
  FSelectedBlock := XML.Node['SelectedProgram'].Attribute['Value'];
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
    Settings.NumOfBlocks := Attributes['Count'];
    SetLength(FBlock, Settings.NumOfBlocks);
    for i := 0 to Settings.NumOfBlocks - 1 do
    begin
      with Node['Program_' + IntToStr(i)] do
      begin
        FBlock[i].Name.Value := Attribute['Name'];
        FBlock[i].Name.EntryFolder := Attribute['NameEntryFolder'];
        with Node['FileIndizes'] do
        begin
          FBlock[i].NameFile := Attribute['NameFile'];
          for j := 0 to High(FBlock[i].StepNameFile) do
          begin
            if Attributes.IndexOf('StepNameFile_' + IntToStr(j)) <> - 1 then
            begin
              FBlock[i].StepNameFile[j] := Attribute['StepNameFile_' + IntToStr(j)];
            end;
          end;
          FBlock[i].OutputModeFile := Attribute['OutputModeFile'];
          FBlock[i].InputModeFile := Attribute['InputModeFile'];
          FBlock[i].InputAlternateModeFile := Attribute['InputModeFile'];
          FBlock[i].InputAktivFile := Attribute['InputAktivFile'];
          FBlock[i].InputAlternateAktivFile := Attribute['InputAktivFile'];
          FBlock[i].IntervallFile := Attribute['IntervallFile'];
          FBlock[i].AnalogInValueFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogInAlternateValueFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogInModeFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogInAlternateModeFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogOutFile := Attribute['AnalogOutFile'];
          FBlock[i].ModeFile := Attribute['ModeFile'];
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
                  FBlock[i].Step[j].Name[k].Value := Attribute['Value'];
                  FBlock[i].Step[j].Name[k].EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['Conditions'] do
              begin
                with Node['NextCond'] do
                begin
                  FBlock[i].Step[j].NextCond.Value := Attribute['Value'];
                  FBlock[i].Step[j].NextCond.EntryFolder := Attribute['EntryFolder'];
                end;
                FBlock[i].Step[j].NextCondAlternate.Value := 0;
                FBlock[i].Step[j].NextCondAlternate.EntryFolder := - 1;
                with Node['NextStep'] do
                begin
                  FBlock[i].Step[j].NextStep.Value := Attribute['Value'];
                  FBlock[i].Step[j].NextStep.EntryFolder := Attribute['EntryFolder'];
                end;
                FBlock[i].Step[j].NextStepAlternate.Value := 0;
                FBlock[i].Step[j].NextStepAlternate.EntryFolder := - 1;
                with Node['Time'] do
                begin
                  FBlock[i].Step[j].Time.Value := Attribute['Value'];
                  FBlock[i].Step[j].Time.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Message'] do
                begin
                  FBlock[i].Step[j].Message.Value := Attribute['Value'];
                  FBlock[i].Step[j].Message.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Loops'] do
                begin
                  FBlock[i].Step[j].LOOPS.Value := Attribute['Value'];
                  FBlock[i].Step[j].LOOPS.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmCond'] do
                begin
                  FBlock[i].Step[j].AlarmCond.Value := Attribute['Value'];
                  FBlock[i].Step[j].AlarmCond.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmStep'] do
                begin
                  FBlock[i].Step[j].AlarmStep.Value := Attribute['Value'];
                  FBlock[i].Step[j].AlarmStep.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['ContrTime'] do
                begin
                  FBlock[i].Step[j].ContrTime.Value := Attribute['Value'];
                  FBlock[i].Step[j].ContrTime.EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['OutputModes'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['OutputMode_' + IntToStr(k)] do
                  begin
                    FBlock[i].Step[j].OutputMode[k].Value := Attribute['Value'];
                    FBlock[i].Step[j].OutputMode[k].EntryFolder := Attribute['EntryFolder'];
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
                      FBlock[i].Step[j].Input[k].Default.Mode.Value := TVarData(Attribute['Value']).VBoolean;
                      FBlock[i].Step[j].Input[k].Default.Mode.EntryFolder := Attribute['EntryFolder'];
                      FBlock[i].Step[j].Input[k].Alternate.Mode.Value := False;
                      FBlock[i].Step[j].Input[k].Alternate.Mode.EntryFolder := - 1;
                    end;
                    with Node['Aktiv'] do
                    begin
                      FBlock[i].Step[j].Input[k].Default.Aktiv.Value := TVarData(Attribute['Value']).VBoolean;
                      FBlock[i].Step[j].Input[k].Default.Aktiv.EntryFolder := Attribute['EntryFolder'];
                      FBlock[i].Step[j].Input[k].Alternate.Aktiv.Value := False;
                      FBlock[i].Step[j].Input[k].Alternate.Aktiv.EntryFolder := - 1;
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
                      FBlock[i].Step[j].INTERVALL[k].INTERVALL.Value := Attribute['Value'];
                      FBlock[i].Step[j].INTERVALL[k].INTERVALL.EntryFolder := Attribute['EntryFolder'];
                    end;
                    with Node['Pause'] do
                    begin
                      FBlock[i].Step[j].INTERVALL[k].PAUSE.Value := Attribute['Value'];
                      FBlock[i].Step[j].INTERVALL[k].PAUSE.EntryFolder := Attribute['EntryFolder'];
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
                      FBlock[i].Step[j].AnalogIn[k].Default.Value.Value := Attribute['Value'];
                      FBlock[i].Step[j].AnalogIn[k].Default.Value.EntryFolder := Attribute['EntryFolder'];
                      FBlock[i].Step[j].AnalogIn[k].Alternate.Value.Value := 0;
                      FBlock[i].Step[j].AnalogIn[k].Alternate.Value.EntryFolder := - 1;
                    end;
                    with Node['Mode'] do
                    begin
                      FBlock[i].Step[j].AnalogIn[k].Default.Mode.Value := Attribute['Value'];
                      FBlock[i].Step[j].AnalogIn[k].Default.Mode.EntryFolder := Attribute['EntryFolder'];
                      FBlock[i].Step[j].AnalogIn[k].Alternate.Value.Value := 0;
                      FBlock[i].Step[j].AnalogIn[k].Alternate.Value.EntryFolder := - 1;
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
                    FBlock[i].Step[j].AnalogOut[k].Value := Attribute['Value'];
                    FBlock[i].Step[j].AnalogOut[k].EntryFolder := Attribute['EntryFolder'];
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
  FSelectedBlock := XML.Node['SelectedProgram'].Attribute['Value'];
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
    Settings.NumOfBlocks := Attributes['Count'];
    SetLength(FBlock, Settings.NumOfBlocks);
    for i := 0 to Settings.NumOfBlocks - 1 do
    begin
      with Node['Program_' + IntToStr(i)] do
      begin
        FBlock[i].Name.Value := Attribute['Name'];
        FBlock[i].Name.EntryFolder := Attribute['NameEntryFolder'];
        with Node['FileIndizes'] do
        begin
          FBlock[i].NameFile := Attribute['NameFile'];
          for j := 0 to High(FBlock[i].StepNameFile) do
          begin
            if Attributes.IndexOf('StepNameFile_' + IntToStr(j)) <> - 1 then
            begin
              FBlock[i].StepNameFile[j] := Attribute['StepNameFile_' + IntToStr(j)];
            end;
          end;
          FBlock[i].OutputModeFile := Attribute['OutputModeFile'];
          FBlock[i].InputModeFile := Attribute['InputModeFile'];
          FBlock[i].InputAlternateModeFile := Attribute['InputModeFile'];
          FBlock[i].InputAktivFile := Attribute['InputAktivFile'];
          FBlock[i].InputAlternateAktivFile := Attribute['InputAktivFile'];
          FBlock[i].IntervallFile := Attribute['IntervallFile'];
          FBlock[i].AnalogInValueFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogInAlternateValueFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogInModeFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogInAlternateModeFile := Attribute['AnalogInFile'];
          FBlock[i].AnalogOutFile := Attribute['AnalogOutFile'];
          FBlock[i].ModeFile := Attribute['ModeFile'];
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
                  FBlock[i].Step[j].Name[k].Value := Attribute['Value'];
                  FBlock[i].Step[j].Name[k].EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['Conditions'] do
              begin
                with Node['NextCond'] do
                begin
                  FBlock[i].Step[j].NextCond.Value := Attribute['Value'];
                  FBlock[i].Step[j].NextCond.EntryFolder := Attribute['EntryFolder'];
                end;
                FBlock[i].Step[j].NextCondAlternate.Value := 0;
                FBlock[i].Step[j].NextCondAlternate.EntryFolder := - 1;
                with Node['NextStep'] do
                begin
                  FBlock[i].Step[j].NextStep.Value := Attribute['Value'];
                  FBlock[i].Step[j].NextStep.EntryFolder := Attribute['EntryFolder'];
                end;
                FBlock[i].Step[j].NextStepAlternate.Value := 0;
                FBlock[i].Step[j].NextStepAlternate.EntryFolder := - 1;
                with Node['Time'] do
                begin
                  FBlock[i].Step[j].Time.Value := Attribute['Value'];
                  FBlock[i].Step[j].Time.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Message'] do
                begin
                  FBlock[i].Step[j].Message.Value := Attribute['Value'];
                  FBlock[i].Step[j].Message.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Loops'] do
                begin
                  FBlock[i].Step[j].LOOPS.Value := Attribute['Value'];
                  FBlock[i].Step[j].LOOPS.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmCond'] do
                begin
                  FBlock[i].Step[j].AlarmCond.Value := Attribute['Value'];
                  FBlock[i].Step[j].AlarmCond.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmStep'] do
                begin
                  FBlock[i].Step[j].AlarmStep.Value := Attribute['Value'];
                  FBlock[i].Step[j].AlarmStep.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['ContrTime'] do
                begin
                  FBlock[i].Step[j].ContrTime.Value := Attribute['Value'];
                  FBlock[i].Step[j].ContrTime.EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['OutputModes'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['OutputMode_' + IntToStr(k)] do
                  begin
                    FBlock[i].Step[j].OutputMode[k].Value := Attribute['Value'];
                    FBlock[i].Step[j].OutputMode[k].EntryFolder := Attribute['EntryFolder'];
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
                      FBlock[i].Step[j].Input[k].Default.Mode.Value := TVarData(Attribute['Value']).VBoolean;
                      FBlock[i].Step[j].Input[k].Default.Mode.EntryFolder := Attribute['EntryFolder'];
                      FBlock[i].Step[j].Input[k].Alternate.Mode.Value := False;
                      FBlock[i].Step[j].Input[k].Alternate.Mode.EntryFolder := - 1;
                    end;
                    with Node['Aktiv'] do
                    begin
                      FBlock[i].Step[j].Input[k].Default.Aktiv.Value := TVarData(Attribute['Value']).VBoolean;
                      FBlock[i].Step[j].Input[k].Default.Aktiv.EntryFolder := Attribute['EntryFolder'];
                      FBlock[i].Step[j].Input[k].Alternate.Aktiv.Value := False;
                      FBlock[i].Step[j].Input[k].Alternate.Aktiv.EntryFolder := - 1;
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
                      FBlock[i].Step[j].INTERVALL[k].INTERVALL.Value := Attribute['Value'];
                      FBlock[i].Step[j].INTERVALL[k].INTERVALL.EntryFolder := Attribute['EntryFolder'];
                    end;
                    with Node['Pause'] do
                    begin
                      FBlock[i].Step[j].INTERVALL[k].PAUSE.Value := Attribute['Value'];
                      FBlock[i].Step[j].INTERVALL[k].PAUSE.EntryFolder := Attribute['EntryFolder'];
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
                      FBlock[i].Step[j].AnalogIn[k].Default.Value.Value := Attribute['Value'];
                      FBlock[i].Step[j].AnalogIn[k].Default.Value.EntryFolder := Attribute['EntryFolder'];
                      FBlock[i].Step[j].AnalogIn[k].Alternate.Value.Value := 0;
                      FBlock[i].Step[j].AnalogIn[k].Alternate.Value.EntryFolder := - 1;
                    end;
                    with Node['Mode'] do
                    begin
                      FBlock[i].Step[j].AnalogIn[k].Default.Mode.Value := Attribute['Value'];
                      FBlock[i].Step[j].AnalogIn[k].Default.Mode.EntryFolder := Attribute['EntryFolder'];
                      FBlock[i].Step[j].AnalogIn[k].Alternate.Mode.Value := 0;
                      FBlock[i].Step[j].AnalogIn[k].Alternate.Mode.EntryFolder := - 1;
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
                    FBlock[i].Step[j].AnalogOut[k].Value := Attribute['Value'];
                    FBlock[i].Step[j].AnalogOut[k].EntryFolder := Attribute['EntryFolder'];
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

procedure TCleanProgParser.LoadXMLV13(XML : TXMLFile);
var
  k : Integer;
  Stream : TFileStream;
  s : string;
  j : Integer;
  i : Integer;
begin
  FSelectedBlock := XML.Node['SelectedProgram'].Attribute['Value'];
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
        FProgram[i].Name.Value := Attributes['Name'];
        FProgram[i].Name.EntryFolder := Attributes['EntryFolder'];
        with Node['FileIndizes'] do
        begin
          FProgram[i].NameFile := Attributes['NameFile'];
          FProgram[i].StepFile := Attributes['StepFile'];
        end;
        with Node['Steps'] do
        begin
          Settings.NumOfProgSteps := Attributes['Count'];
          SetLength(FProgram[i].Step, Settings.NumOfProgSteps);
          for j := 0 to High(FProgram[i].Step) do
          begin
            with Node['Step_' + IntToStr(j)] do
            begin
              FProgram[i].Step[j].Value := Attributes['Value'];
              FProgram[i].Step[j].EntryFolder := Attributes['EntryFolder'];
            end;
          end;
        end;
      end;
    end;
  end;

  with XML.Node['Blocks'] do
  begin
    Settings.NumOfBlocks := Attributes['Count'];
    SetLength(FBlock, Settings.NumOfBlocks);
    for i := 0 to Settings.NumOfBlocks - 1 do
    begin
      with Node['Block_' + IntToStr(i)] do
      begin
        FBlock[i].Name.Value := Attribute['Name'];
        FBlock[i].Name.EntryFolder := Attribute['EntryFolder'];
        with Node['FileIndizes'] do
        begin
          FBlock[i].NameFile := Attribute['NameFile'];
          for j := 0 to High(FBlock[i].StepNameFile) do
          begin
            if Attributes.IndexOf('StepNameFile_' + IntToStr(j)) <> - 1 then
            begin
              FBlock[i].StepNameFile[j] := Attribute['StepNameFile_' + IntToStr(j)];
            end;
          end;
          FBlock[i].OutputModeFile := Attribute['OutputModeFile'];
          FBlock[i].InputModeFile := Attribute['InputModeFile'];
          FBlock[i].InputAlternateModeFile := Attribute['InputAlternateModeFile'];
          FBlock[i].InputAktivFile := Attribute['InputAktivFile'];
          FBlock[i].InputAlternateAktivFile := Attribute['InputAlternateAktivFile'];
          FBlock[i].IntervallFile := Attribute['IntervallFile'];
          FBlock[i].AnalogInValueFile := Attribute['AnalogInValueFile'];
          FBlock[i].AnalogInAlternateValueFile := Attribute['AnalogInAlternateValueFile'];
          FBlock[i].AnalogInModeFile := Attribute['AnalogInModeFile'];
          FBlock[i].AnalogInAlternateModeFile := Attribute['AnalogInAlternateModeFile'];
          FBlock[i].AnalogOutFile := Attribute['AnalogOutFile'];
          FBlock[i].ModeFile := Attribute['ModeFile'];
        end;
        with Node['Steps'] do
        begin
          Settings.NumOfSteps := Attributes['Count'];
          SetLength(FBlock[i].Step, Settings.NumOfSteps);
          SetLength(FBlock[i].StepNameFile, Settings.NumOfLangs);
          for j := 0 to Nodes.Count - 1 do
          begin
            SetLength(FBlock[i].Step[j].Name, Settings.NumOfLangs);
            SetLength(FBlock[i].Step[j].OutputMode, Settings.NumOfOutputs);
            SetLength(FBlock[i].Step[j].Input, Settings.NumOfInputs);
            SetLength(FBlock[i].Step[j].INTERVALL, Settings.NumOfIntervalls);
            SetLength(FBlock[i].Step[j].AnalogIn, Settings.NumOfAnalogIn);
            SetLength(FBlock[i].Step[j].AnalogOut, Settings.NumOfAnalogOut);
            with Node['Step_' + IntToStr(j)] do
            begin
              for k := 0 to Settings.NumOfLangs - 1 do
              begin
                with Node['Name_' + IntToStr(k)] do
                begin
                  FBlock[i].Step[j].Name[k].Value := Attribute['Value'];
                  FBlock[i].Step[j].Name[k].EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['Conditions'] do
              begin
                with Node['NextCond'] do
                begin
                  FBlock[i].Step[j].NextCond.Value := Attribute['Value'];
                  FBlock[i].Step[j].NextCond.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['NextCondAlternate'] do
                begin
                  FBlock[i].Step[j].NextCondAlternate.Value := Attribute['Value'];
                  FBlock[i].Step[j].NextCondAlternate.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['NextStep'] do
                begin
                  FBlock[i].Step[j].NextStep.Value := Attribute['Value'];
                  FBlock[i].Step[j].NextStep.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['NextStepAlternate'] do
                begin
                  FBlock[i].Step[j].NextStepAlternate.Value := Attribute['Value'];
                  FBlock[i].Step[j].NextStepAlternate.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Time'] do
                begin
                  FBlock[i].Step[j].Time.Value := Attribute['Value'];
                  FBlock[i].Step[j].Time.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Message'] do
                begin
                  FBlock[i].Step[j].Message.Value := Attribute['Value'];
                  FBlock[i].Step[j].Message.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['Loops'] do
                begin
                  FBlock[i].Step[j].LOOPS.Value := Attribute['Value'];
                  FBlock[i].Step[j].LOOPS.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmCond'] do
                begin
                  FBlock[i].Step[j].AlarmCond.Value := Attribute['Value'];
                  FBlock[i].Step[j].AlarmCond.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['AlarmStep'] do
                begin
                  FBlock[i].Step[j].AlarmStep.Value := Attribute['Value'];
                  FBlock[i].Step[j].AlarmStep.EntryFolder := Attribute['EntryFolder'];
                end;
                with Node['ContrTime'] do
                begin
                  FBlock[i].Step[j].ContrTime.Value := Attribute['Value'];
                  FBlock[i].Step[j].ContrTime.EntryFolder := Attribute['EntryFolder'];
                end;
              end;

              with Node['OutputModes'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['OutputMode_' + IntToStr(k)] do
                  begin
                    FBlock[i].Step[j].OutputMode[k].Value := Attribute['Value'];
                    FBlock[i].Step[j].OutputMode[k].EntryFolder := Attribute['EntryFolder'];
                  end;
                end;
              end;

              with Node['Inputs'] do
              begin
                for k := 0 to Nodes.Count - 1 do
                begin
                  with Node['Input_' + IntToStr(k)] do
                  begin
                    with Node['Default'] do
                    begin
                      with Node['Mode'] do
                      begin
                        FBlock[i].Step[j].Input[k].Default.Mode.Value := TVarData(Attribute['Value']).VBoolean;
                        FBlock[i].Step[j].Input[k].Default.Mode.EntryFolder := Attribute['EntryFolder'];
                      end;
                      with Node['Aktiv'] do
                      begin
                        FBlock[i].Step[j].Input[k].Default.Aktiv.Value := TVarData(Attribute['Value']).VBoolean;
                        FBlock[i].Step[j].Input[k].Default.Aktiv.EntryFolder := Attribute['EntryFolder'];
                      end;
                    end;
                    with Node['Alternate'] do
                    begin
                      with Node['Mode'] do
                      begin
                        FBlock[i].Step[j].Input[k].Alternate.Mode.Value := TVarData(Attribute['Value']).VBoolean;
                        FBlock[i].Step[j].Input[k].Alternate.Mode.EntryFolder := Attribute['EntryFolder'];
                      end;
                      with Node['Aktiv'] do
                      begin
                        FBlock[i].Step[j].Input[k].Alternate.Aktiv.Value := TVarData(Attribute['Value']).VBoolean;
                        FBlock[i].Step[j].Input[k].Alternate.Aktiv.EntryFolder := Attribute['EntryFolder'];
                      end;
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
                      FBlock[i].Step[j].INTERVALL[k].INTERVALL.Value := Attribute['Value'];
                      FBlock[i].Step[j].INTERVALL[k].INTERVALL.EntryFolder := Attribute['EntryFolder'];
                    end;
                    with Node['Pause'] do
                    begin
                      FBlock[i].Step[j].INTERVALL[k].PAUSE.Value := Attribute['Value'];
                      FBlock[i].Step[j].INTERVALL[k].PAUSE.EntryFolder := Attribute['EntryFolder'];
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
                    with Node['Default'] do
                    begin
                      with Node['Value'] do
                      begin
                        FBlock[i].Step[j].AnalogIn[k].Default.Value.Value := Attribute['Value'];
                        FBlock[i].Step[j].AnalogIn[k].Default.Value.EntryFolder := Attribute['EntryFolder'];
                      end;
                      with Node['Mode'] do
                      begin
                        FBlock[i].Step[j].AnalogIn[k].Default.Mode.Value := Attribute['Value'];
                        FBlock[i].Step[j].AnalogIn[k].Default.Mode.EntryFolder := Attribute['EntryFolder'];
                      end;
                    end;
                    with Node['Alternate'] do
                    begin
                      with Node['Value'] do
                      begin
                        FBlock[i].Step[j].AnalogIn[k].Alternate.Value.Value := Attribute['Value'];
                        FBlock[i].Step[j].AnalogIn[k].Alternate.Value.EntryFolder := Attribute['EntryFolder'];
                      end;
                      with Node['Mode'] do
                      begin
                        FBlock[i].Step[j].AnalogIn[k].Alternate.Mode.Value := Attribute['Value'];
                        FBlock[i].Step[j].AnalogIn[k].Alternate.Mode.EntryFolder := Attribute['EntryFolder'];
                      end;
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
                    FBlock[i].Step[j].AnalogOut[k].Value := Attribute['Value'];
                    FBlock[i].Step[j].AnalogOut[k].EntryFolder := Attribute['EntryFolder'];
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
  FStepBuffer := FBlock[FSelectedBlock].Step[Index].Copy;
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
    SetLength(FProgram[i].Step, Settings.NumOfProgSteps);
  end;

  SetLength(FBlock, Settings.NumOfBlocks);
  for i := 0 to Settings.NumOfBlocks - 1 do
  begin
    SetLength(FBlock[i].Step, Settings.NumOfSteps);
    for j := 0 to Settings.NumOfSteps - 1 do
    begin
      SetLength(FBlock[i].Step[j].Name, Settings.NumOfLangs);
      SetLength(FBlock[i].Step[j].OutputMode, Settings.NumOfOutputs);
      SetLength(FBlock[i].Step[j].Input, Settings.NumOfInputs);
      SetLength(FBlock[i].Step[j].INTERVALL, Settings.NumOfIntervalls);
      SetLength(FBlock[i].Step[j].AnalogIn, Settings.NumOfAnalogIn);
      SetLength(FBlock[i].Step[j].AnalogOut, Settings.NumOfAnalogOut);
    end;
    SetLength(FBlock[i].StepNameFile, Settings.NumOfLangs);
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
  FStepBuffer := FBlock[FSelectedBlock].Step[Index].Copy;
  for i := Index to Settings.NumOfSteps - 2 do
  begin
    FBlock[FSelectedBlock].Step[i] := FBlock[FSelectedBlock].Step[i + 1];
  end;
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    if FBlock[FSelectedBlock].Step[i].NextStep.Value > Index then
    begin
      Dec(FBlock[FSelectedBlock].Step[i].NextStep.Value);
    end;
    if FBlock[FSelectedBlock].Step[i].AlarmStep.Value > Index then
    begin
      Dec(FBlock[FSelectedBlock].Step[i].AlarmStep.Value);
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

function TCleanProgParser.GetProgramStep(index : Integer) : Integer;
begin
  if InRange(FSelectedProgram, 0, Settings.NumOfProgs - 1) and InRange(index, 0, Settings.NumOfProgSteps - 1) then
  begin
    Result := FProgram[FSelectedProgram].Step[index].Value;
  end;
end;

function TCleanProgParser.GetBlockName : string;
begin
  if InRange(FSelectedBlock, 0, Settings.NumOfBlocks - 1) then
  begin
    Result := FBlock[FSelectedBlock].Name.Value;
  end
  else
  begin
    Result := '';
  end;
end;

function TCleanProgParser.GetBlockNames(index : Integer) : string;
begin
  if InRange(index, 0, Settings.NumOfBlocks - 1) then
  begin
    Result := FBlock[index].Name.Value;
  end
  else
  begin
    Result := '';
  end;
end;

function TCleanProgParser.GetSelectedBlock : Integer;
begin
  Result := FSelectedBlock + 1;
end;

function TCleanProgParser.GetSelectedProgram : Integer;
begin
  Result := FSelectedProgram + 1;
end;

function TCleanProgParser.GetStep(index : Integer) : TStep;
begin
  if not InRange(index, 0, Settings.NumOfSteps - 1) then
  begin
    raise TCleanProgException.CreateFmt('Selected Step Out of Range Min: %d, Max: %d, Is: %d maybe configuration error',
      [0, Settings.NumOfSteps - 1, index]);
  end;
  if InRange(FSelectedBlock, 0, Settings.NumOfBlocks - 1) then
  begin
    Result := FBlock[FSelectedBlock].Step[index];
  end;
end;

function TCleanProgParser.GetStepCount : Integer;
begin
  Result := Settings.NumOfSteps;
end;

function TCleanProgParser.GetStepName(index : Integer) : string;
begin
  Result := FBlock[FSelectedBlock].Step[Index].Name[FLanguage].Value;
end;

procedure TCleanProgParser.InsertStep(Index : Integer);
var
  i : Integer;
begin
  for i := Settings.NumOfSteps - 2 downto Index do
  begin
    FBlock[FSelectedBlock].Step[i + 1] := FBlock[FSelectedBlock].Step[i];
  end;
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    if FBlock[FSelectedBlock].Step[i].NextStep.Value > Index then
    begin
      Inc(FBlock[FSelectedBlock].Step[i].NextStep.Value);
    end;
    if FBlock[FSelectedBlock].Step[i].AlarmStep.Value > Index then
    begin
      Inc(FBlock[FSelectedBlock].Step[i].AlarmStep.Value);
    end;
  end;
  FBlock[FSelectedBlock].Step[Index] := FStepBuffer.Copy;
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
    if (s <> '') and (s[1] = '"') then
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
                k := StrToIntDef(GetString(aTemp[3]), 0);
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
                k := StrToIntDef(GetString(aTemp[3]), 0);
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
                k := StrToIntDef(GetString(aTemp[3]), 0);
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
                k := StrToIntDef(GetString(aTemp[3]), 0);
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
                k := StrToIntDef(GetString(aTemp[3]), 0);
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
              if (FormatNo > Settings.NumOfBlocks) and (FormatNo > Settings.NumOfProgs) then
              begin
                raise TCleanProgException.CreateFmt('Read Dataset Number too high Is: %d, Max: %d',
                  [FormatNo, MAX(Settings.NumOfBlocks, Settings.NumOfProgs)]);
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

  ParseFiles();

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
      13 :
        LoadXMLV13(XML);
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
      FBlock[RawValue.FormatIndex].Step[i].AlarmCond.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].AlarmCond.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
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
      FBlock[RawValue.FormatIndex].Step[i].AlarmStep.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].AlarmStep.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
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
        FBlock[RawValue.FormatIndex].Step[k].AnalogIn[i].Default.Value.Value := StrToFloat(RawValue.Value);
        FBlock[RawValue.FormatIndex].Step[k].AnalogIn[i].Default.Value.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].AnalogInValueFile := Data.FileIndex;
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
        FBlock[RawValue.FormatIndex].Step[k].AnalogIn[i].Default.Mode.Value := StrToFloat(RawValue.Value);
        FBlock[RawValue.FormatIndex].Step[k].AnalogIn[i].Default.Mode.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].AnalogInModeFile := Data.FileIndex;
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
        FBlock[RawValue.FormatIndex].Step[k].AnalogOut[i].Value := StrToFloat(RawValue.Value);
        FBlock[RawValue.FormatIndex].Step[k].AnalogOut[i].EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].AnalogOutFile := Data.FileIndex;
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
      FBlock[RawValue.FormatIndex].Step[i].ContrTime.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].ContrTime.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
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
        FBlock[RawValue.FormatIndex].Step[k].Input[i].Default.Aktiv.Value := RawValue.Value = '1';
        FBlock[RawValue.FormatIndex].Step[k].Input[i].Default.Aktiv.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].InputAktivFile := Data.FileIndex;
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
        FBlock[RawValue.FormatIndex].Step[k].Input[i].Default.Mode.Value := RawValue.Value = '1';
        FBlock[RawValue.FormatIndex].Step[k].Input[i].Default.Mode.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].InputModeFile := Data.FileIndex;
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
        FBlock[RawValue.FormatIndex].Step[k].INTERVALL[i].INTERVALL.Value := StrToIntDef(RawValue.Value, 0);
        FBlock[RawValue.FormatIndex].Step[k].INTERVALL[i].INTERVALL.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].IntervallFile := Data.FileIndex;
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
      FBlock[RawValue.FormatIndex].Step[i].LOOPS.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].LOOPS.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
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
      FBlock[RawValue.FormatIndex].Step[i].Message.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].Message.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
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
      FBlock[RawValue.FormatIndex].Step[i].NextCond.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].NextCond.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
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
      FBlock[RawValue.FormatIndex].Step[i].NextStep.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].NextStep.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
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
        FBlock[RawValue.FormatIndex].Step[k].OutputMode[i].Value := StrToIntDef(RawValue.Value, 0);
        FBlock[RawValue.FormatIndex].Step[k].OutputMode[i].EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].OutputModeFile := Data.FileIndex;
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
        FBlock[RawValue.FormatIndex].Step[k].INTERVALL[i].PAUSE.Value := StrToIntDef(RawValue.Value, 0);
        FBlock[RawValue.FormatIndex].Step[k].INTERVALL[i].PAUSE.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].IntervallFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParser.ParseBlockName;
var
  i : Integer;
  s : string;
  Data : TData;
begin
  for i := 0 to Settings.NumOfBlocks - 1 do
  begin
    s := Format(Settings.BlockName, [i + 1]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    if Data.Data.Count >= i + 1 then
    begin
      FBlock[i].Name.Value := Data.Data.Items[i].Value;
      FBlock[i].Name.EntryFolder := Data.Folder;
    end
    else
    begin
      FBlock[i].Name.Value := '';
      FBlock[i].Name.EntryFolder := Data.Folder;
    end;
    FBlock[i].NameFile := Data.FileIndex;
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
        FBlock[RawValue.FormatIndex].Step[k].Name[i].Value := RawValue.Value;
        FBlock[RawValue.FormatIndex].Step[k].Name[i].EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].StepNameFile[i] := Data.FileIndex;
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
      FBlock[RawValue.FormatIndex].Step[i].Time.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].Time.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
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
    XML.AddNode('SelectedProgram').Attributes.Add('Value', FSelectedBlock);
    XML.AddNode('Language').Attributes.Add('Value', FLanguage);
    XML.AddNode('Delimiter').Attributes.Add('Value', FDelimiter);
    XML.AddNode('FileVersion').Attributes.Add('Value', 13);

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
      for i := 0 to high(FProgram) do
      begin
        with AddNode('Program_' + IntToStr(i)) do
        begin
          Attributes.Add('Name', FProgram[i].Name.Value);
          Attributes.Add('EntryFolder', FProgram[i].Name.EntryFolder);
          with AddNode('FileIndizes') do
          begin
            Attributes.Add('NameFile', FProgram[i].NameFile);
            Attributes.Add('StepFile', FProgram[i].StepFile);
          end;
          with AddNode('Steps') do
          begin
            Attributes.Add('Count', Settings.NumOfProgSteps);
            for j := 0 to High(FProgram[i].Step) do
            begin
              with AddNode('Step_' + IntToStr(j)) do
              begin
                Attributes.Add('Value', FProgram[i].Step[j].Value);
                Attributes.Add('EntryFolder', FProgram[i].Step[j].EntryFolder);
              end;
            end;
          end;
        end;
      end;
    end;

    with XML.AddNode('Blocks') do
    begin
      Attributes.Add('Count', Settings.NumOfBlocks);
      for i := 0 to High(FBlock) do
      begin
        with AddNode('Block_' + IntToStr(i)) do
        begin
          Attributes.Add('Name', FBlock[i].Name.Value);
          Attributes.Add('EntryFolder', FBlock[i].Name.EntryFolder);
          with AddNode('FileIndizes') do
          begin
            Attributes.Add('NameFile', FBlock[i].NameFile);
            for j := 0 to High(FBlock[i].StepNameFile) do
            begin
              Attributes.Add('StepNameFile_' + IntToStr(j), FBlock[i].StepNameFile[j]);
            end;
            Attributes.Add('OutputModeFile', FBlock[i].OutputModeFile);
            Attributes.Add('InputModeFile', FBlock[i].InputModeFile);
            Attributes.Add('InputAlternateModeFile', FBlock[i].InputAlternateModeFile);
            Attributes.Add('InputAktivFile', FBlock[i].InputAktivFile);
            Attributes.Add('InputAlternateAktivFile', FBlock[i].InputAlternateAktivFile);
            Attributes.Add('IntervallFile', FBlock[i].IntervallFile);
            Attributes.Add('AnalogInValueFile', FBlock[i].AnalogInValueFile);
            Attributes.Add('AnalogInAlternateValueFile', FBlock[i].AnalogInAlternateValueFile);
            Attributes.Add('AnalogInModeFile', FBlock[i].AnalogInModeFile);
            Attributes.Add('AnalogInAlternateModeFile', FBlock[i].AnalogInAlternateModeFile);
            Attributes.Add('AnalogOutFile', FBlock[i].AnalogOutFile);
            Attributes.Add('ModeFile', FBlock[i].ModeFile);
          end;

          with AddNode('Steps') do
          begin
            Attributes.Add('Count', Settings.NumOfSteps);
            for j := 0 to High(FBlock[i].Step) do
            begin

              with AddNode('Step_' + IntToStr(j)) do
              begin
                for k := 0 to High(FBlock[i].Step[j].Name) do
                begin
                  with AddNode('Name_' + IntToStr(k)) do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].Name[k].Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].Name[k].EntryFolder);
                  end;
                end;

                with AddNode('Conditions') do
                begin
                  with AddNode('NextCond') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].NextCond.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].NextCond.EntryFolder);
                  end;
                  with AddNode('NextCondAlternate') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].NextCondAlternate.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].NextCondAlternate.EntryFolder);
                  end;
                  with AddNode('NextStep') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].NextStep.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].NextStep.EntryFolder);
                  end;
                  with AddNode('NextStepAlternate') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].NextStepAlternate.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].NextStepAlternate.EntryFolder);
                  end;
                  with AddNode('Time') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].Time.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].Time.EntryFolder);
                  end;
                  with AddNode('Message') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].Message.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].Message.EntryFolder);
                  end;
                  with AddNode('Loops') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].LOOPS.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].LOOPS.EntryFolder);
                  end;
                  with AddNode('AlarmCond') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].AlarmCond.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].AlarmCond.EntryFolder);
                  end;
                  with AddNode('AlarmStep') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].AlarmStep.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].AlarmStep.EntryFolder);
                  end;
                  with AddNode('ContrTime') do
                  begin
                    Attributes.Add('Value', FBlock[i].Step[j].ContrTime.Value);
                    Attributes.Add('EntryFolder', FBlock[i].Step[j].ContrTime.EntryFolder);
                  end;
                end;

                with AddNode('OutputModes') do
                begin
                  for k := 0 to High(FBlock[i].Step[j].OutputMode) do
                  begin
                    with AddNode('OutputMode_' + IntToStr(k)) do
                    begin
                      Attributes.Add('Value', FBlock[i].Step[j].OutputMode[k].Value);
                      Attributes.Add('EntryFolder', FBlock[i].Step[j].OutputMode[k].EntryFolder);
                    end;
                  end;
                end;

                with AddNode('Inputs') do
                begin
                  for k := 0 to High(FBlock[i].Step[j].Input) do
                  begin
                    with AddNode('Input_' + IntToStr(k)) do
                    begin
                      with AddNode('Default') do
                      begin
                        with AddNode('Mode') do
                        begin
                          Attributes.Add('Value', FBlock[i].Step[j].Input[k].Default.Mode.Value);
                          Attributes.Add('EntryFolder', FBlock[i].Step[j].Input[k].Default.Mode.EntryFolder);
                        end;
                        with AddNode('Aktiv') do
                        begin
                          Attributes.Add('Value', FBlock[i].Step[j].Input[k].Default.Aktiv.Value);
                          Attributes.Add('EntryFolder', FBlock[i].Step[j].Input[k].Default.Aktiv.EntryFolder);
                        end;
                      end;
                      with AddNode('Alternate') do
                      begin
                        with AddNode('Mode') do
                        begin
                          Attributes.Add('Value', FBlock[i].Step[j].Input[k].Alternate.Mode.Value);
                          Attributes.Add('EntryFolder', FBlock[i].Step[j].Input[k].Alternate.Mode.EntryFolder);
                        end;
                        with AddNode('Aktiv') do
                        begin
                          Attributes.Add('Value', FBlock[i].Step[j].Input[k].Alternate.Aktiv.Value);
                          Attributes.Add('EntryFolder', FBlock[i].Step[j].Input[k].Alternate.Aktiv.EntryFolder);
                        end;
                      end;
                    end;
                  end;
                end;

                with AddNode('Intervalls') do
                begin
                  for k := 0 to High(FBlock[i].Step[j].INTERVALL) do
                  begin
                    with AddNode('Intervall_' + IntToStr(k)) do
                    begin
                      with AddNode('Intervall') do
                      begin
                        Attributes.Add('Value', FBlock[i].Step[j].INTERVALL[k].INTERVALL.Value);
                        Attributes.Add('EntryFolder', FBlock[i].Step[j].INTERVALL[k].INTERVALL.EntryFolder);
                      end;
                      with AddNode('Pause') do
                      begin
                        Attributes.Add('Value', FBlock[i].Step[j].INTERVALL[k].PAUSE.Value);
                        Attributes.Add('EntryFolder', FBlock[i].Step[j].INTERVALL[k].PAUSE.EntryFolder);
                      end;
                    end;
                  end;
                end;

                with AddNode('AnalogIns') do
                begin
                  for k := 0 to High(FBlock[i].Step[j].AnalogIn) do
                  begin
                    with AddNode('AnalogIn_' + IntToStr(k)) do
                    begin
                      with AddNode('Default') do
                      begin
                        with AddNode('Value') do
                        begin
                          Attributes.Add('Value', FBlock[i].Step[j].AnalogIn[k].Default.Value.Value);
                          Attributes.Add('EntryFolder', FBlock[i].Step[j].AnalogIn[k].Default.Value.EntryFolder);
                        end;
                        with AddNode('Mode') do
                        begin
                          Attributes.Add('Value', FBlock[i].Step[j].AnalogIn[k].Default.Mode.Value);
                          Attributes.Add('EntryFolder', FBlock[i].Step[j].AnalogIn[k].Default.Mode.EntryFolder);
                        end;
                      end;
                      with AddNode('Alternate') do
                      begin
                        with AddNode('Value') do
                        begin
                          Attributes.Add('Value', FBlock[i].Step[j].AnalogIn[k].Alternate.Value.Value);
                          Attributes.Add('EntryFolder', FBlock[i].Step[j].AnalogIn[k].Alternate.Value.EntryFolder);
                        end;
                        with AddNode('Mode') do
                        begin
                          Attributes.Add('Value', FBlock[i].Step[j].AnalogIn[k].Alternate.Mode.Value);
                          Attributes.Add('EntryFolder', FBlock[i].Step[j].AnalogIn[k].Alternate.Mode.EntryFolder);
                        end;
                      end;
                    end;
                  end;
                end;

                with AddNode('AnalogOut') do
                begin
                  for k := 0 to High(FBlock[i].Step[j].AnalogOut) do
                  begin
                    with AddNode('AnalogOut_' + IntToStr(k)) do
                    begin
                      Attributes.Add('Value', FBlock[i].Step[j].AnalogOut[k].Value);
                      Attributes.Add('EntryFolder', FBlock[i].Step[j].AnalogOut[k].EntryFolder);
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

    for i := 0 to Settings.NumOfBlocks - 1 do
    begin
      s := GetEntryFolder(FBlock[i].Name.EntryFolder);
      s := s + Format(Settings.BlockName, [i + 1]);
      // Eigentlich nicht ganz richtig aber Flexible verlangt es so
      for j := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + FBlock[i].Name.Value;
      end;
      RecipeFiles[FBlock[i].NameFile].Add(s);
    end;

    for i := 0 to Settings.NumOfLangs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Name[i].EntryFolder);
        s := s + Format(Settings.StepName, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FBlock[k].Step[j].Name[i].Value;
        end;
        RecipeFiles[FBlock[0].StepNameFile[i]].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfOutputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].OutputMode[i].EntryFolder);
        s := s + Format(Settings.OutputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + IntToStr(FBlock[k].Step[j].OutputMode[i].Value);
        end;
        RecipeFiles[FBlock[0].OutputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Default.Mode.EntryFolder);
        s := s + Format(Settings.InputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Default.Mode.Value];
        end;
        RecipeFiles[FBlock[0].InputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Alternate.Mode.EntryFolder);
        s := s + Format(Settings.InputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Alternate.Mode.Value];
        end;
        RecipeFiles[FBlock[0].InputAlternateModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Default.Aktiv.EntryFolder);
        s := s + Format(Settings.InputAktiv, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Default.Aktiv.Value];
        end;
        RecipeFiles[FBlock[0].InputAktivFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Alternate.Aktiv.EntryFolder);
        s := s + Format(Settings.InputAktiv, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Alternate.Aktiv.Value];
        end;
        RecipeFiles[FBlock[0].InputAlternateAktivFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].AlarmStep.EntryFolder);
      s := s + Format(Settings.AlarmStep, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].AlarmStep.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].AlarmCond.EntryFolder);
      s := s + Format(Settings.AlarmCond, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].AlarmCond.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].NextCond.EntryFolder);
      s := s + Format(Settings.NextCond, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].NextCond.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].ContrTime.EntryFolder);
      s := s + Format(Settings.ContrTime, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].ContrTime.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].INTERVALL[i].INTERVALL.EntryFolder);
        s := s + Format(Settings.INTERVALL, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + IntToStr(FBlock[k].Step[j].INTERVALL[i].INTERVALL.Value);
        end;
        RecipeFiles[FBlock[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].LOOPS.EntryFolder);
      s := s + Format(Settings.LOOPS, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].LOOPS.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].NextStep.EntryFolder);
      s := s + Format(Settings.NextStep, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].NextStep.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].Message.EntryFolder);
      s := s + Format(Settings.MESSAGES, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].Message.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].INTERVALL[i].PAUSE.EntryFolder);
        s := s + Format(Settings.PAUSE, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + IntToStr(FBlock[k].Step[j].INTERVALL[i].PAUSE.Value);
        end;
        RecipeFiles[FBlock[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].Time.EntryFolder);
      s := s + Format(Settings.StepTime, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].Time.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Default.Value.EntryFolder);
        s := s + Format(Settings.AnalogIn, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Default.Value.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInValueFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Alternate.Value.EntryFolder);
        s := s + Format(Settings.AnalogIn, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Alternate.Value.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInAlternateValueFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Default.Mode.EntryFolder);
        s := s + Format(Settings.AnalogMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Default.Mode.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Alternate.Mode.EntryFolder);
        s := s + Format(Settings.AnalogMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Alternate.Mode.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInAlternateModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogOut - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogOut[i].EntryFolder);
        s := s + Format(Settings.AnalogOut, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogOut[i].Value);
        end;
        RecipeFiles[FBlock[0].AnalogOutFile].Add(s);
      end;
    end;

    for i := 0 to High(RecipeFiles) do
    begin
      s := FRecipeFileName[i].FileName;
      RecipeFiles[i].SaveToFile(Folder + s);
    end;

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

procedure TCleanProgParser.SetProgramStep(index : Integer; const Value : Integer);
begin
  if InRange(FSelectedProgram, 0, Settings.NumOfProgs - 1) and InRange(index, 0, Settings.NumOfProgSteps - 1) then
  begin
    FProgram[FSelectedProgram].Step[index].Value := Value;
  end;
end;

procedure TCleanProgParser.SetBlockName(const Value : string);
begin
  if InRange(FSelectedBlock, 0, Settings.NumOfBlocks - 1) then
  begin
    FBlock[FSelectedBlock].Name.Value := Value;
  end;
end;

procedure TCleanProgParser.SetSelectedBlock(const Value : Integer);
begin
  if not InRange(Value, 1, Settings.NumOfBlocks) then
  begin
    raise TCleanProgException.CreateFmt('Selected Block Out of Range Min: %d, Max: %d, Is: %d',
      [1, Settings.NumOfBlocks, Value]);
  end;
  FSelectedBlock := Value - 1;
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
  if InRange(FSelectedBlock, 0, Settings.NumOfBlocks - 1) then
  begin
    FBlock[FSelectedBlock].Step[index] := Value;
  end;
end;

procedure TCleanProgParser.SetStepName(index : Integer; const Value : string);
begin
  FBlock[FSelectedBlock].Step[Index].Name[FLanguage].Value := Value;
end;

{ TCleanProgParserSingleDatasetName }

procedure TCleanProgParserSingleDatasetName.ParseBlockName;
var
  i : Integer;
  s : string;
  Data : TData;
begin
  for i := 0 to Settings.NumOfBlocks - 1 do
  begin
    s := Format(Settings.BlockName, [i + 1]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    if Data.Data.Count >= 1 then
    begin
      FBlock[i].Name.Value := Data.Data.Items[0].Value;
      FBlock[i].Name.EntryFolder := Data.Folder;
    end
    else
    begin
      FBlock[i].Name.Value := '';
      FBlock[i].Name.EntryFolder := Data.Folder;
    end;
    FBlock[i].NameFile := Data.FileIndex;
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

    for i := 0 to Settings.NumOfBlocks - 1 do
    begin
      s := GetEntryFolder(FBlock[i].Name.EntryFolder);
      s := s + Format(Settings.BlockName, [i + 1]);
      s := s + FDelimiter + FBlock[i].Name.Value;
      RecipeFiles[FBlock[i].NameFile].Add(s);
    end;

    for i := 0 to Settings.NumOfLangs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Name[i].EntryFolder);
        s := s + Format(Settings.StepName, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FBlock[k].Step[j].Name[i].Value;
        end;
        RecipeFiles[FBlock[0].StepNameFile[i]].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfOutputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].OutputMode[i].EntryFolder);
        s := s + Format(Settings.OutputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + IntToStr(FBlock[k].Step[j].OutputMode[i].Value);
        end;
        RecipeFiles[FBlock[0].OutputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Default.Mode.EntryFolder);
        s := s + Format(Settings.InputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Default.Mode.Value];
        end;
        RecipeFiles[FBlock[0].InputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Alternate.Mode.EntryFolder);
        s := s + Format(Settings.InputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Alternate.Mode.Value];
        end;
        RecipeFiles[FBlock[0].InputAlternateModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Default.Aktiv.EntryFolder);
        s := s + Format(Settings.InputAktiv, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Default.Aktiv.Value];
        end;
        RecipeFiles[FBlock[0].InputAktivFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Alternate.Aktiv.EntryFolder);
        s := s + Format(Settings.InputAktiv, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Alternate.Aktiv.Value];
        end;
        RecipeFiles[FBlock[0].InputAlternateAktivFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].AlarmStep.EntryFolder);
      s := s + Format(Settings.AlarmStep, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].AlarmStep.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].AlarmCond.EntryFolder);
      s := s + Format(Settings.AlarmCond, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].AlarmCond.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].NextCond.EntryFolder);
      s := s + Format(Settings.NextCond, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].NextCond.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].ContrTime.EntryFolder);
      s := s + Format(Settings.ContrTime, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].ContrTime.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].INTERVALL[i].INTERVALL.EntryFolder);
        s := s + Format(Settings.INTERVALL, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + IntToStr(FBlock[k].Step[j].INTERVALL[i].INTERVALL.Value);
        end;
        RecipeFiles[FBlock[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].LOOPS.EntryFolder);
      s := s + Format(Settings.LOOPS, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].LOOPS.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].NextStep.EntryFolder);
      s := s + Format(Settings.NextStep, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].NextStep.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].Message.EntryFolder);
      s := s + Format(Settings.MESSAGES, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].Message.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].INTERVALL[i].PAUSE.EntryFolder);
        s := s + Format(Settings.PAUSE, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + IntToStr(FBlock[k].Step[j].INTERVALL[i].PAUSE.Value);
        end;
        RecipeFiles[FBlock[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].Time.EntryFolder);
      s := s + Format(Settings.StepTime, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].Time.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Default.Value.EntryFolder);
        s := s + Format(Settings.AnalogIn, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Default.Value.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInValueFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Alternate.Value.EntryFolder);
        s := s + Format(Settings.AnalogIn, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Alternate.Value.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInAlternateValueFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Default.Mode.EntryFolder);
        s := s + Format(Settings.AnalogMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Default.Mode.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Alternate.Mode.EntryFolder);
        s := s + Format(Settings.AnalogMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Alternate.Mode.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInAlternateModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogOut - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogOut[i].EntryFolder);
        s := s + Format(Settings.AnalogOut, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogOut[i].Value);
        end;
        RecipeFiles[FBlock[0].AnalogOutFile].Add(s);
      end;
    end;

    for i := 0 to High(RecipeFiles) do
    begin
      s := FRecipeFileName[i].FileName;
      RecipeFiles[i].SaveToFile(Folder + s);
    end;

  finally
    for i := 0 to lastCreated do
    begin
      FreeAndNil(RecipeFiles[i]);
    end;
  end;
end;

procedure TCleanProgParserBlockBased.ParseFiles;
begin
  FMaxCount := FMaxCount + Settings.NumOfProgs + // Loops to parse program names
    Settings.NumOfProgSteps + // Loops to parse program steps
    Settings.NumOfBlocks + // Loops to parse block names
    (Settings.NumOfLangs * Settings.NumOfSteps * FDataSetCount) + // Loops to parse step names
    (4 * Settings.NumOfInputs * Settings.NumOfSteps * FDataSetCount) + // Loops to parse inputs
    (2 * Settings.NumOfIntervalls * Settings.NumOfSteps * FDataSetCount) + // Loops to parse intervalls
    (4 * Settings.NumOfAnalogIn * Settings.NumOfSteps * FDataSetCount) + // Loops to parse analog inputs
    (Settings.NumOfAnalogOut * Settings.NumOfSteps * FDataSetCount) + // Loops to parse analog outputs
    (10 * Settings.NumOfSteps * FDataSetCount) + // Loops to parse step control values
    (Settings.NumOfOutputs * Settings.NumOfSteps * FDataSetCount); // Loops to parse outputs

  FSendCount := 100;

  SendProgress;
  ParseProgramName;
  ParseProgramStep;
  ParseBlockName;
  ParseStepName;
  ParseOutputMode;
  ParseInputMode;
  ParseInputModeAlternate;
  ParseInputAktiv;
  ParseInputAktivAlternate;
  ParseIntervall;
  ParsePause;
  ParseAnalogIn;
  ParseAnalogInAlternate;
  ParseAnalogMode;
  ParseAnalogModeAlternate;
  ParseAnalogOut;
  ParseAlarmStep;
  ParseAlarmCond;
  ParseNextCond;
  ParseNextCondAlternate;
  ParseContrTime;
  ParseLoops;
  ParseNextStep;
  ParseNextStepAlternate;
  ParseMessage;
  ParseStepTime;

end;

procedure TCleanProgParserBlockBased.ParseProgramName;
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

procedure TCleanProgParserBlockBased.SaveFiles(Folder : String);
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

    for i := 0 to Settings.NumOfProgSteps - 1 do
    begin
      s := GetEntryFolder(FProgram[0].Step[i].EntryFolder);
      s := s + Format(Settings.ProgStep, [i + 1]);
      for j := 0 to Settings.NumOfProgs - 1 do
      begin
        s := s + FDelimiter + IntToStr(FProgram[j].Step[i].Value);
      end;
      RecipeFiles[FProgram[0].StepFile].Add(s);
    end;

    for i := 0 to Settings.NumOfBlocks - 1 do
    begin
      s := GetEntryFolder(FBlock[i].Name.EntryFolder);
      s := s + Format(Settings.BlockName, [i + 1]);
      s := s + FDelimiter + FBlock[i].Name.Value;
      RecipeFiles[FBlock[i].NameFile].Add(s);
    end;

    for i := 0 to Settings.NumOfLangs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Name[i].EntryFolder);
        s := s + Format(Settings.StepName, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FBlock[k].Step[j].Name[i].Value;
        end;
        RecipeFiles[FBlock[0].StepNameFile[i]].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfOutputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].OutputMode[i].EntryFolder);
        s := s + Format(Settings.OutputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + IntToStr(FBlock[k].Step[j].OutputMode[i].Value);
        end;
        RecipeFiles[FBlock[0].OutputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Default.Mode.EntryFolder);
        s := s + Format(Settings.InputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Default.Mode.Value];
        end;
        RecipeFiles[FBlock[0].InputModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Alternate.Mode.EntryFolder);
        s := s + Format(Settings.InputMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Alternate.Mode.Value];
        end;
        RecipeFiles[FBlock[0].InputAlternateModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Default.Aktiv.EntryFolder);
        s := s + Format(Settings.InputAktiv, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Default.Aktiv.Value];
        end;
        RecipeFiles[FBlock[0].InputAktivFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfInputs - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].Input[i].Alternate.Aktiv.EntryFolder);
        s := s + Format(Settings.InputAktiv, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + cSimpleBoolStrs[FBlock[k].Step[j].Input[i].Alternate.Aktiv.Value];
        end;
        RecipeFiles[FBlock[0].InputAlternateAktivFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].AlarmStep.EntryFolder);
      s := s + Format(Settings.AlarmStep, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].AlarmStep.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].AlarmCond.EntryFolder);
      s := s + Format(Settings.AlarmCond, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].AlarmCond.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].NextCond.EntryFolder);
      s := s + Format(Settings.NextCond, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].NextCond.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].ContrTime.EntryFolder);
      s := s + Format(Settings.ContrTime, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].ContrTime.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].INTERVALL[i].INTERVALL.EntryFolder);
        s := s + Format(Settings.INTERVALL, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + IntToStr(FBlock[k].Step[j].INTERVALL[i].INTERVALL.Value);
        end;
        RecipeFiles[FBlock[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].LOOPS.EntryFolder);
      s := s + Format(Settings.LOOPS, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].LOOPS.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].NextStep.EntryFolder);
      s := s + Format(Settings.NextStep, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].NextStep.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].Message.EntryFolder);
      s := s + Format(Settings.MESSAGES, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].Message.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfIntervalls - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].INTERVALL[i].PAUSE.EntryFolder);
        s := s + Format(Settings.PAUSE, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + IntToStr(FBlock[k].Step[j].INTERVALL[i].PAUSE.Value);
        end;
        RecipeFiles[FBlock[0].ModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfSteps - 1 do
    begin
      s := GetEntryFolder(FBlock[0].Step[i].Time.EntryFolder);
      s := s + Format(Settings.StepTime, [i]);
      for k := 0 to Settings.NumOfBlocks - 1 do
      begin
        s := s + FDelimiter + IntToStr(FBlock[k].Step[i].Time.Value);
      end;
      RecipeFiles[FBlock[0].ModeFile].Add(s);
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Default.Value.EntryFolder);
        s := s + Format(Settings.AnalogIn, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Default.Value.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInValueFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Alternate.Value.EntryFolder);
        s := s + Format(Settings.AnalogIn, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Alternate.Value.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInAlternateValueFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Default.Mode.EntryFolder);
        s := s + Format(Settings.AnalogMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Default.Mode.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogIn - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogIn[i].Alternate.Mode.EntryFolder);
        s := s + Format(Settings.AnalogMode, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogIn[i].Alternate.Mode.Value);
        end;
        RecipeFiles[FBlock[0].AnalogInAlternateModeFile].Add(s);
      end;
    end;

    for i := 0 to Settings.NumOfAnalogOut - 1 do
    begin
      for j := 0 to Settings.NumOfSteps - 1 do
      begin
        s := GetEntryFolder(FBlock[0].Step[j].AnalogOut[i].EntryFolder);
        s := s + Format(Settings.AnalogOut, [i + 1, j]);
        for k := 0 to Settings.NumOfBlocks - 1 do
        begin
          s := s + FDelimiter + FloatToStr(FBlock[k].Step[j].AnalogOut[i].Value);
        end;
        RecipeFiles[FBlock[0].AnalogOutFile].Add(s);
      end;
    end;

    for i := 0 to High(RecipeFiles) do
    begin
      s := FRecipeFileName[i].FileName;
      RecipeFiles[i].SaveToFile(Folder + s);
    end;

  finally
    for i := 0 to lastCreated do
    begin
      FreeAndNil(RecipeFiles[i]);
    end;
  end;
end;

procedure TCleanProgParserBlockBased.ParseInputModeAlternate;
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
      s := Format(Settings.InputAlternateMode, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FBlock[RawValue.FormatIndex].Step[k].Input[i].Alternate.Mode.Value := RawValue.Value = '1';
        FBlock[RawValue.FormatIndex].Step[k].Input[i].Alternate.Mode.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].InputAlternateModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParserBlockBased.ParseInputAktivAlternate;
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
      s := Format(Settings.InputAlternateAktiv, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FBlock[RawValue.FormatIndex].Step[k].Input[i].Alternate.Aktiv.Value := RawValue.Value = '1';
        FBlock[RawValue.FormatIndex].Step[k].Input[i].Alternate.Aktiv.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].InputAlternateAktivFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParserBlockBased.ParseAnalogInAlternate;
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
      s := Format(Settings.AnalogInAlternate, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FBlock[RawValue.FormatIndex].Step[k].AnalogIn[i].Alternate.Value.Value := StrToFloat(RawValue.Value);
        FBlock[RawValue.FormatIndex].Step[k].AnalogIn[i].Alternate.Value.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].AnalogInAlternateValueFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParserBlockBased.ParseAnalogModeAlternate;
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
      s := Format(Settings.AnalogModeAlternate, [i + 1, k]);
      if not FLines.TryGetValue(s, Data) then
      begin
        raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
      end;
      for RawValue in Data.Data do
      begin
        FBlock[RawValue.FormatIndex].Step[k].AnalogIn[i].Alternate.Mode.Value := StrToFloat(RawValue.Value);
        FBlock[RawValue.FormatIndex].Step[k].AnalogIn[i].Alternate.Mode.EntryFolder := Data.Folder;
        FBlock[RawValue.FormatIndex].AnalogInAlternateModeFile := Data.FileIndex;
        Inc(FCount);
        SendProgress;
      end;
    end;
  end;
end;

procedure TCleanProgParserBlockBased.ParseNextCondAlternate;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.NextAlternateCond, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FBlock[RawValue.FormatIndex].Step[i].NextCondAlternate.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].NextCondAlternate.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParserBlockBased.ParseNextStepAlternate;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfSteps - 1 do
  begin
    s := Format(Settings.NextAlternateStep, [i]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FBlock[RawValue.FormatIndex].Step[i].NextStepAlternate.Value := StrToIntDef(RawValue.Value, 0);
      FBlock[RawValue.FormatIndex].Step[i].NextStepAlternate.EntryFolder := Data.Folder;
      FBlock[RawValue.FormatIndex].ModeFile := Data.FileIndex;
      Inc(FCount);
      SendProgress;
    end;
  end;
end;

procedure TCleanProgParserBlockBased.ParseProgramStep;
var
  i : Integer;
  s : string;
  Data : TData;
  RawValue : TRawValue;
begin
  for i := 0 to Settings.NumOfProgSteps - 1 do
  begin
    s := Format(Settings.ProgStep, [i + 1]);
    if not FLines.TryGetValue(s, Data) then
    begin
      raise TCleanProgException.CreateFmt('Value %s not Found', [s]);
    end;
    for RawValue in Data.Data do
    begin
      FProgram[RawValue.FormatIndex].Step[i].Value := StrToIntDef(RawValue.Value, 0);
      FProgram[RawValue.FormatIndex].Step[i].EntryFolder := Data.Folder;
      FProgram[RawValue.FormatIndex].StepFile := Data.FileIndex;
    end;
    Inc(FCount);
    SendProgress;
  end;
end;

end.
