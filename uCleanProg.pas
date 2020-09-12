unit uCleanProg;

interface

uses
  SysUtils,
  Classes,
  Generics.Collections;

type
  TProgressEvent = procedure(Sender : TObject; Progress : Real) of object;
  TSelectLangIndexEvent = procedure(Sender : TObject; LangDesc : TStringList; out Indizes : TList<Integer>) of object;

  TCleanProgException = class(Exception)
  end;

  TProgramNameMode = (pnmSingleDataSet, pnmMultipleDataSets, pnmBlocks);

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

  TInputState = record
    Mode : TValue<Boolean>;
    Aktiv : TValue<Boolean>;
  end;

  TInput = record
    Default : TInputState;
    Alternate : TInputState;
  end;

  TIntervall = record
    INTERVALL : TValue<Integer>;
    PAUSE : TValue<Integer>;
  end;

  TAnalogInState = record
    Value : TValue<Real>;
    Mode : TValue<Real>;
  end;

  TAnalogIn = record
    Default : TAnalogInState;
    Alternate : TAnalogInState;
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
    NextCondAlternate : TValue<Integer>;
    ContrTime : TValue<Integer>;
    LOOPS : TValue<Integer>;
    NextStep : TValue<Integer>;
    NextStepAlternate : TValue<Integer>;
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

  TBlock = record
    Name : TValue<string>;
    Step : array of TStep;
    NameFile : Integer;
    StepNameFile : array of Integer;
    OutputModeFile : Integer;
    InputModeFile : Integer;
    InputAktivFile : Integer;
    InputAlternateModeFile : Integer;
    InputAlternateAktivFile : Integer;
    IntervallFile : Integer;
    AnalogInValueFile : Integer;
    AnalogInAlternateValueFile : Integer;
    AnalogInModeFile : Integer;
    AnalogInAlternateModeFile : Integer;
    AnalogOutFile : Integer;
    ModeFile : Integer;
  end;

  TProgram = record
      Name : TValue<string>;
      Step : array of TValue<Integer>;
      NameFile : Integer;
      StepFile : Integer;
  end;

implementation

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
  Buffer.NextCondAlternate := self.NextCondAlternate;
  Buffer.ContrTime := self.ContrTime;
  Buffer.LOOPS := self.LOOPS;
  Buffer.NextStep := self.NextStep;
  Buffer.NextStepAlternate := self.NextStepAlternate;
  Buffer.Message := self.Message;
  Buffer.Time := self.Time;
  Result := Buffer;
end;

end.
