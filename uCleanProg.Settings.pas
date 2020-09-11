unit uCleanProg.Settings;

interface

uses uCleanProg,
  SysUtils,
  Classes,
  himXML;

type
  TSettings = class(TObject)
  protected const
    FILE_VERSION_KEY = 'FileVersion';
    PROG_MODE_KEY = 'ProgMode';
    DATA_SET_MODE_KEY = 'ProgNameMode';
    NUM_OF_FILES_KEY = 'NumberOfFiles';
    NUM_OF_PROGS_KEY = 'NumberOfPrograms';
    NUM_OF_PROG_STEPS_KEY = 'NumberOfProgramSteps';
    NUM_OF_BLOCKS_KEY = 'NumberOfBlocks';
    NUM_OF_LANGS_KEY = 'NumberOfLanguages';
    NUM_OF_STEPS_KEY = 'NumberOfSteps';
    NUM_OF_OUTPUTS_KEY = 'NumberOfOutputs';
    NUM_OF_INPUTS_KEY = 'NumberOfInputs';
    NUM_OF_INTERVALLS_KEY = 'NumberOfIntervalls';
    NUM_OF_ANALOG_IN_KEY = 'NumberOfAnalogInputs';
    NUM_OF_ANALOG_OUT_KEY = 'NumberOfAnalogOutputs';
    PROG_NAME_KEY = 'ProgramName';
    PROG_STEP_KEY = 'ProgramStep';
    BLOCK_NAME_KEY = 'BlockName';
    STEP_NAME_KEY = 'StepName';
    OUTPUT_MODE_KEY = 'OutputMode';
    INPUT_MODE_KEY = 'InputMode';
    INPUT_ALTERNATE_MODE_KEY = 'InputAlternateMode';
    INPUT_AKTIV_KEY = 'InputActive';
    INPUT_ALTERNATE_AKTIV_KEY = 'InputAlternateActive';
    ALARM_STEP_KEY = 'AlarmStep';
    ALARM_COND_KEY = 'AlarmCondition';
    NEXT_COND_KEY = 'NextCondition';
    NEXT_ALTERNATE_COND_KEY = 'NextAlternateCondition';
    CONTR_TIME_KEY = 'ControlTime';
    INTERVALL_KEY = 'Intervall';
    LOOPS_KEY = 'Loops';
    NEXT_STEP_KEY = 'NextStep';
    NEXT_ALTERNATE_STEP_KEY = 'NextAlternateStep';
    MESSAGES_KEY = 'Messages';
    PAUSE_KEY = 'Pause';
    STEP_TIME_KEY = 'StepTime';
    ANALOG_IN_KEY = 'AnalogIn';
    ANALOG_IN_ALTERNATE_KEY = 'AnalogInAlternate';
    ANALOG_OUT_KEY = 'AnalogOut';
    ANALOG_MODE_KEY = 'AnalogMode';
    ANALOG_MODE_ALTERNATE_KEY = 'AnalogModeAlternate';
    MESSAGE_LIST_NAME_KEY = 'MessageListName';
    INPUT_LIST_NAME_KEY = 'InputListName';
    OUTPUT_LIST_NAME_KEY = 'OutputListName';
    ANALOG_INPUT_LIST_NAME_KEY = 'AnalogInputListName';
    ANALOG_OUTPUT_LIST_NAME_KEY = 'AnalogOutputListName';
    ANALOG_OUTPUT_UNIT_LIST_NAME_KEY = 'AnalogOutputUnitListName';
    ON_OFF_LIST_NAME_KEY = 'OnOffListName';
    ACTIVE_INACTIVE_LIST_NAME_KEY = 'ActiveInactiveListName';
    OUTPUT_MODE_LIST_NAME_KEY = 'OutputModeListName';
    STEP_MODE_LIST_NAME_KEY = 'StepModeListName';
    STEP_MODE_ALTERNATE_LIST_NAME_KEY = 'StepModeAlternateListName';
    ALARM_COND_LIST_NAME_KEY = 'AlarmConditionListName';

  private
    FMessages : string;
    FNumOfProgs : Integer;
    FNumOfProgSteps : Integer;
    FNumOfBlocks : Integer;
    FProgName : string;
    FProgStep : string;
    FBlockName : string;
    FNumOfAnalogOut : Integer;
    FNumOfOutputs : Integer;
    FAnalogInputListName : string;
    FNumOfIntervalls : Integer;
    FMessageListName : string;
    FPause : string;
    FNumOfAnalogIn : Integer;
    FNumOfInputs : Integer;
    FDataSetNameMode : TProgramNameMode;
    FNumOfSteps : Integer;
    FAnalogOut : string;
    FNumOfLangs : Integer;
    FNumOfFiles : Integer;
    FStepTime : string;
    FOutputListName : string;
    FAnalogMode : string;
    FAnalogIn : string;
    FAlarmCond : string;
    FAlarmStep : string;
    FInputListName : string;
    FIntervall : string;
    FContrTime : string;
    FOutputMode : string;
    FNextStep : string;
    FNextCond : string;
    FAnalogOutputUnitListName : string;
    FAnalogOutputListName : string;
    FInputAktiv : string;
    FStepName : string;
    FLoops : string;
    FInputMode : string;
    FInputAlternateMode : string;
    FInputAlternateAktiv : string;
    FNextAlternateCond : string;
    FNextAlternateStep : string;
    FAnalogModeAlternate : string;
    FAnalogInAlternate : string;
    FStepModeAlternateListName : string;
    FOutputModeListName : string;
    FActiveInactiveListName : string;
    FAlarmConditionListName : string;
    FStepModeListName : string;
    FOnOffListName : string;
    procedure SetNumOfProgs(const Value : Integer);
    procedure SetNumOfProgSteps(const Value : Integer);
    procedure SetNumOfBlocks(const Value : Integer);
    procedure SetAlarmCond(const Value : string);
    procedure SetAlarmStep(const Value : string);
    procedure SetAnalogIn(const Value : string);
    procedure SetAnalogInputListName(const Value : string);
    procedure SetAnalogMode(const Value : string);
    procedure SetAnalogOut(const Value : string);
    procedure SetAnalogOutputListName(const Value : string);
    procedure SetAnalogOutputUnitListName(const Value : string);
    procedure SetContrTime(const Value : string);
    procedure SetDataSetNameMode(const Value : TProgramNameMode);
    procedure SetInputAktiv(const Value : string);
    procedure SetInputListName(const Value : string);
    procedure SetInputMode(const Value : string);
    procedure SetIntervall(const Value : string);
    procedure SetLoops(const Value : string);
    procedure SetMessageListName(const Value : string);
    procedure SetMessages(const Value : string);
    procedure SetNextCond(const Value : string);
    procedure SetNextStep(const Value : string);
    procedure SetNumOfAnalogIn(const Value : Integer);
    procedure SetNumOfAnalogOut(const Value : Integer);
    procedure SetNumOfFiles(const Value : Integer);
    procedure SetNumOfInputs(const Value : Integer);
    procedure SetNumOfIntervalls(const Value : Integer);
    procedure SetNumOfLangs(const Value : Integer);
    procedure SetNumOfOutputs(const Value : Integer);
    procedure SetNumOfSteps(const Value : Integer);
    procedure SetOutputListName(const Value : string);
    procedure SetOutputMode(const Value : string);
    procedure SetPause(const Value : string);
    procedure SetProgName(const Value : string);
    procedure SetProgStep(const Value : string);
    procedure SetBlockName(const Value : string);
    procedure SetStepName(const Value : string);
    procedure SetStepTime(const Value : string);
    procedure SetInputAlternateMode(const Value : string);
    procedure SetInputAlternateAktiv(const Value : string);
    procedure SetNextAlternateCond(const Value : string);
    procedure SetNextAlternateStep(const Value : string);
    procedure SetAnalogInAlternate(const Value : string);
    procedure SetAnalogModeAlternate(const Value : string);
    procedure SetActiveInactiveListName(const Value : string);
    procedure SetAlarmConditionListName(const Value : string);
    procedure SetOnOffListName(const Value : string);
    procedure SetOutputModeListName(const Value : string);
    procedure SetStepModeAlternateListName(const Value : string);
    procedure SetStepModeListName(const Value : string);
  public
    property DataSetNameMode : TProgramNameMode read FDataSetNameMode write SetDataSetNameMode;
    property NumOfFiles : Integer read FNumOfFiles write SetNumOfFiles;
    property NumOfProgs : Integer read FNumOfProgs write SetNumOfProgs;
    property NumOfProgSteps : Integer read FNumOfProgSteps write SetNumOfProgSteps;
    property NumOfBlocks : Integer read FNumOfBlocks write SetNumOfBlocks;
    property NumOfLangs : Integer read FNumOfLangs write SetNumOfLangs;
    property NumOfSteps : Integer read FNumOfSteps write SetNumOfSteps;
    property NumOfOutputs : Integer read FNumOfOutputs write SetNumOfOutputs;
    property NumOfInputs : Integer read FNumOfInputs write SetNumOfInputs;
    property NumOfIntervalls : Integer read FNumOfIntervalls write SetNumOfIntervalls;
    property NumOfAnalogIn : Integer read FNumOfAnalogIn write SetNumOfAnalogIn;
    property NumOfAnalogOut : Integer read FNumOfAnalogOut write SetNumOfAnalogOut;
    property ProgName : string read FProgName write SetProgName;
    property ProgStep : string read FProgStep write SetProgStep;
    property BlockName : string read FBlockName write SetBlockName;
    property StepName : string read FStepName write SetStepName;
    property OutputMode : string read FOutputMode write SetOutputMode;
    property InputMode : string read FInputMode write SetInputMode;
    property InputAlternateMode : string read FInputAlternateMode write SetInputAlternateMode;
    property InputAktiv : string read FInputAktiv write SetInputAktiv;
    property InputAlternateAktiv : string read FInputAlternateAktiv write SetInputAlternateAktiv;
    property AlarmStep : string read FAlarmStep write SetAlarmStep;
    property AlarmCond : string read FAlarmCond write SetAlarmCond;
    property NextCond : string read FNextCond write SetNextCond;
    property NextAlternateCond : string read FNextAlternateCond write SetNextAlternateCond;
    property ContrTime : string read FContrTime write SetContrTime;
    property INTERVALL : string read FIntervall write SetIntervall;
    property LOOPS : string read FLoops write SetLoops;
    property NextStep : string read FNextStep write SetNextStep;
    property NextAlternateStep : string read FNextAlternateStep write SetNextAlternateStep;
    property MESSAGES : string read FMessages write SetMessages;
    property PAUSE : string read FPause write SetPause;
    property StepTime : string read FStepTime write SetStepTime;
    property AnalogIn : string read FAnalogIn write SetAnalogIn;
    property AnalogInAlternate : string read FAnalogInAlternate write SetAnalogInAlternate;
    property AnalogOut : string read FAnalogOut write SetAnalogOut;
    property AnalogMode : string read FAnalogMode write SetAnalogMode;
    property AnalogModeAlternate : string read FAnalogModeAlternate write SetAnalogModeAlternate;
    property MessageListName : string read FMessageListName write SetMessageListName;
    property InputListName : string read FInputListName write SetInputListName;
    property OutputListName : string read FOutputListName write SetOutputListName;
    property AnalogInputListName : string read FAnalogInputListName write SetAnalogInputListName;
    property AnalogOutputListName : string read FAnalogOutputListName write SetAnalogOutputListName;
    property AnalogOutputUnitListName : string read FAnalogOutputUnitListName write SetAnalogOutputUnitListName;
    property OnOffListName : string read FOnOffListName write SetOnOffListName;
    property ActiveInactiveListName : string read FActiveInactiveListName write SetActiveInactiveListName;
    property OutputModeListName : string read FOutputModeListName write SetOutputModeListName;
    property StepModeListName : string read FStepModeListName write SetStepModeListName;
    property StepModeAlternateListName : string read FStepModeAlternateListName write SetStepModeAlternateListName;
    property AlarmConditionListName : string read FAlarmConditionListName write SetAlarmConditionListName;

    constructor Create();
    procedure LoadFromFile(sFileName : string);
  end;

implementation

constructor TSettings.Create;
begin
  inherited;
  // V10
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
  // V11
  NumOfProgSteps := 20;
  NumOfBlocks := 40;
  ProgStep := 'Cleaning_Step.udt_cleaning_sequence.ai_stepnumber[%d]';
  BlockName := 'CleanProgName%d';
  InputAlternateMode := 'Cleaning_Step.udt_cleaning.aby_input%d_alternativ[%d]';
  InputAlternateAktiv := 'Cleaning_Step.udt_cleaning.aby_input%d_aktiv_alternativ[%d]';
  NextAlternateCond := 'Cleaning_Step.udt_cleaning.ai_condition_next_alternativ_step[%d]';
  NextAlternateStep := 'Cleaning_Step.udt_cleaning.ai_next_alternative_step[%d]';
  AnalogInAlternate := 'Cleaning_Step.udt_cleaning.ar_analog_in_%d_alternativ[%d]';
  AnalogModeAlternate := 'Cleaning_Step.udt_cleaning.ar_mode_ai_%d_alternativ[%d]';
  OnOffListName := 'AUS_EIN';
  ActiveInactiveListName := 'Active_Inactive';
  OutputModeListName := 'CleaningBlock_Outputmode';
  StepModeListName := 'CleaningBlock_Step_mode';
  StepModeAlternateListName := 'CleaningBlock_Step_mode_Alternativ';
  AlarmConditionListName := 'CleaningBlock_UeStep_mode';
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
          end;
        11 :
          begin
            DataSetNameMode := TProgramNameMode(XML.Node[DATA_SET_MODE_KEY].Attribute['Value']);
            NumOfProgs := XML.Node[NUM_OF_PROGS_KEY].Attribute['Value'];
            NumOfProgSteps := XML.Node[NUM_OF_PROG_STEPS_KEY].Attribute['Value'];
            NumOfBlocks := XML.Node[NUM_OF_BLOCKS_KEY].Attribute['Value'];
            NumOfFiles := XML.Node[NUM_OF_FILES_KEY].Attribute['Value'];
            NumOfLangs := XML.Node[NUM_OF_LANGS_KEY].Attribute['Value'];
            NumOfSteps := XML.Node[NUM_OF_STEPS_KEY].Attribute['Value'];
            NumOfOutputs := XML.Node[NUM_OF_OUTPUTS_KEY].Attribute['Value'];
            NumOfInputs := XML.Node[NUM_OF_INPUTS_KEY].Attribute['Value'];
            NumOfIntervalls := XML.Node[NUM_OF_INTERVALLS_KEY].Attribute['Value'];
            NumOfAnalogIn := XML.Node[NUM_OF_ANALOG_IN_KEY].Attribute['Value'];
            NumOfAnalogOut := XML.Node[NUM_OF_ANALOG_OUT_KEY].Attribute['Value'];
            ProgName := XML.Node[PROG_NAME_KEY].Attribute['Value'];
            ProgStep := XML.Node[PROG_STEP_KEY].Attribute['Value'];
            BlockName := XML.Node[BLOCK_NAME_KEY].Attribute['Value'];
            StepName := XML.Node[STEP_NAME_KEY].Attribute['Value'];
            OutputMode := XML.Node[OUTPUT_MODE_KEY].Attribute['Value'];
            InputMode := XML.Node[INPUT_MODE_KEY].Attribute['Value'];
            InputAlternateMode := XML.Node[INPUT_ALTERNATE_MODE_KEY].Attribute['Value'];
            InputAktiv := XML.Node[INPUT_AKTIV_KEY].Attribute['Value'];
            InputAlternateAktiv := XML.Node[INPUT_ALTERNATE_AKTIV_KEY].Attribute['Value'];
            AlarmStep := XML.Node[ALARM_STEP_KEY].Attribute['Value'];
            AlarmCond := XML.Node[ALARM_COND_KEY].Attribute['Value'];
            NextCond := XML.Node[NEXT_COND_KEY].Attribute['Value'];
            NextAlternateCond := XML.Node[NEXT_ALTERNATE_COND_KEY].Attribute['Value'];
            ContrTime := XML.Node[CONTR_TIME_KEY].Attribute['Value'];
            INTERVALL := XML.Node[INTERVALL_KEY].Attribute['Value'];
            LOOPS := XML.Node[LOOPS_KEY].Attribute['Value'];
            NextStep := XML.Node[NEXT_STEP_KEY].Attribute['Value'];
            NextAlternateStep := XML.Node[NEXT_ALTERNATE_STEP_KEY].Attribute['Value'];
            MESSAGES := XML.Node[MESSAGES_KEY].Attribute['Value'];
            PAUSE := XML.Node[PAUSE_KEY].Attribute['Value'];
            StepTime := XML.Node[STEP_TIME_KEY].Attribute['Value'];
            AnalogIn := XML.Node[ANALOG_IN_KEY].Attribute['Value'];
            AnalogInAlternate := XML.Node[ANALOG_IN_ALTERNATE_KEY].Attribute['Value'];
            AnalogOut := XML.Node[ANALOG_OUT_KEY].Attribute['Value'];
            AnalogMode := XML.Node[ANALOG_MODE_KEY].Attribute['Value'];
            AnalogModeAlternate := XML.Node[ANALOG_MODE_ALTERNATE_KEY].Attribute['Value'];
            MessageListName := XML.Node[MESSAGE_LIST_NAME_KEY].Attribute['Value'];
            InputListName := XML.Node[INPUT_LIST_NAME_KEY].Attribute['Value'];
            OutputListName := XML.Node[OUTPUT_LIST_NAME_KEY].Attribute['Value'];
            AnalogInputListName := XML.Node[ANALOG_INPUT_LIST_NAME_KEY].Attribute['Value'];
            AnalogOutputListName := XML.Node[ANALOG_OUTPUT_LIST_NAME_KEY].Attribute['Value'];
            AnalogOutputUnitListName := XML.Node[ANALOG_OUTPUT_UNIT_LIST_NAME_KEY].Attribute['Value'];
            OnOffListName := XML.Node[ON_OFF_LIST_NAME_KEY].Attribute['Value'];
            ActiveInactiveListName := XML.Node[ACTIVE_INACTIVE_LIST_NAME_KEY].Attribute['Value'];
            OutputModeListName := XML.Node[OUTPUT_LIST_NAME_KEY].Attribute['Value'];
            StepModeListName := XML.Node[STEP_MODE_LIST_NAME_KEY].Attribute['Value'];
            StepModeAlternateListName := XML.Node[STEP_MODE_ALTERNATE_LIST_NAME_KEY].Attribute['Value'];
            AlarmConditionListName := XML.Node[ALARM_COND_LIST_NAME_KEY].Attribute['Value'];
          end;
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

procedure TSettings.SetActiveInactiveListName(const Value : string);
begin
  FActiveInactiveListName := Value;
end;

procedure TSettings.SetAlarmCond(const Value : string);
begin
  FAlarmCond := Value;
end;

procedure TSettings.SetAlarmConditionListName(const Value : string);
begin
  FAlarmConditionListName := Value;
end;

procedure TSettings.SetAlarmStep(const Value : string);
begin
  FAlarmStep := Value;
end;

procedure TSettings.SetAnalogIn(const Value : string);
begin
  FAnalogIn := Value;
end;

procedure TSettings.SetAnalogInAlternate(const Value : string);
begin
  FAnalogInAlternate := Value;
end;

procedure TSettings.SetAnalogInputListName(const Value : string);
begin
  FAnalogInputListName := Value;
end;

procedure TSettings.SetAnalogMode(const Value : string);
begin
  FAnalogMode := Value;
end;

procedure TSettings.SetAnalogModeAlternate(const Value : string);
begin
  FAnalogModeAlternate := Value;
end;

procedure TSettings.SetAnalogOut(const Value : string);
begin
  FAnalogOut := Value;
end;

procedure TSettings.SetAnalogOutputListName(const Value : string);
begin
  FAnalogOutputListName := Value;
end;

procedure TSettings.SetAnalogOutputUnitListName(const Value : string);
begin
  FAnalogOutputUnitListName := Value;
end;

procedure TSettings.SetBlockName(const Value : string);
begin
  FBlockName := Value;
end;

procedure TSettings.SetContrTime(const Value : string);
begin
  FContrTime := Value;
end;

procedure TSettings.SetDataSetNameMode(const Value : TProgramNameMode);
begin
  FDataSetNameMode := Value;
end;

procedure TSettings.SetInputAktiv(const Value : string);
begin
  FInputAktiv := Value;
end;

procedure TSettings.SetInputAlternateAktiv(const Value : string);
begin
  FInputAlternateAktiv := Value;
end;

procedure TSettings.SetInputAlternateMode(const Value : string);
begin
  FInputAlternateMode := Value;
end;

procedure TSettings.SetInputListName(const Value : string);
begin
  FInputListName := Value;
end;

procedure TSettings.SetInputMode(const Value : string);
begin
  FInputMode := Value;
end;

procedure TSettings.SetIntervall(const Value : string);
begin
  FIntervall := Value;
end;

procedure TSettings.SetLoops(const Value : string);
begin
  FLoops := Value;
end;

procedure TSettings.SetMessageListName(const Value : string);
begin
  FMessageListName := Value;
end;

procedure TSettings.SetMessages(const Value : string);
begin
  FMessages := Value;
end;

procedure TSettings.SetNextAlternateCond(const Value : string);
begin
  FNextAlternateCond := Value;
end;

procedure TSettings.SetNextAlternateStep(const Value : string);
begin
  FNextAlternateStep := Value;
end;

procedure TSettings.SetNextCond(const Value : string);
begin
  FNextCond := Value;
end;

procedure TSettings.SetNextStep(const Value : string);
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

procedure TSettings.SetNumOfBlocks(const Value : Integer);
begin
  FNumOfBlocks := Value;
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

procedure TSettings.SetNumOfProgSteps(const Value : Integer);
begin
  FNumOfProgSteps := Value;
end;

procedure TSettings.SetNumOfSteps(const Value : Integer);
begin
  FNumOfSteps := Value;
end;

procedure TSettings.SetOnOffListName(const Value : string);
begin
  FOnOffListName := Value;
end;

procedure TSettings.SetOutputListName(const Value : string);
begin
  FOutputListName := Value;
end;

procedure TSettings.SetOutputMode(const Value : string);
begin
  FOutputMode := Value;
end;

procedure TSettings.SetOutputModeListName(const Value : string);
begin
  FOutputModeListName := Value;
end;

procedure TSettings.SetPause(const Value : string);
begin
  FPause := Value;
end;

procedure TSettings.SetProgName(const Value : string);
begin
  FProgName := Value;
end;

procedure TSettings.SetProgStep(const Value : string);
begin
  FProgStep := Value;
end;

procedure TSettings.SetStepModeAlternateListName(const Value : string);
begin
  FStepModeAlternateListName := Value;
end;

procedure TSettings.SetStepModeListName(const Value : string);
begin
  FStepModeListName := Value;
end;

procedure TSettings.SetStepName(const Value : string);
begin
  FStepName := Value;
end;

procedure TSettings.SetStepTime(const Value : string);
begin
  FStepTime := Value;
end;

end.
