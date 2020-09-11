unit VTreeHelper;

interface

{$INCLUDE Compilerswitches.inc}

uses
  VirtualTrees,
  Classes,
  Types,
  uCleanProg,
  uCleanProg.Settings,
  Generics.Collections,
  SysUtils;

const
  OutputMode : array [0 .. 5] of string = ('Inaktiv', 'Aktiv', 'Intervall 1', 'Inverse Intervall 1', 'Intervall 2',
    'Inverse Intervall 2');
  AnalogInMode : array [0 .. 2] of string = ('Inaktiv', '<', '>');
  InputAktiv: array [Boolean] of string = ('Inaktiv', 'Aktiv');
  InputMode : array [Boolean] of string = ('Aus', 'Ein');

type
  PInputData = ^TInputData;

  TInputDataState = record
    Mode : Boolean;
    Aktiv : Boolean;
  end;

  TInputData = record
    Name : string;
    Default : TInputDataState;
    Alternate : TInputDataState;
  end;

  PAnalogInputData = ^TAnalogInputData;

  TAnalogInputDataState = record
    Mode : Integer;
    Value : Real;
  end;

  TAnalogInputData = record
    Name : string;
    Default : TAnalogInputDataState;
    Alternate : TAnalogInputDataState;
  end;

  POutputData = ^TOutputData;

  TOutputData = record
    Name : string;
    Mode : Integer;
  end;

  PAnalogOutputData = ^TAnalogOutputData;

  TAnalogOutputData = record
    Name : string;
    UnitName : string;
    Value : Real;
  end;

  TCrossesData = class(TObject)
  public
    Step : Integer;
    StepName : string;
    OutputMode : array of Integer;
    Input : array of TInput;
    Intervall : array of TIntervall;
    AnalogIn : array of TAnalogIn;
    AnalogOut : array of Real;
    AlarmStep : Integer;
    AlarmCond : Integer;
    NextCond : Integer;
    ContrTime : Integer;
    Loops : Integer;
    NextStep : Integer;
    Message : Integer;
    Time : Integer;

    constructor Create(Settings : TSettings);
  end;

  TSelectLangData = class
  class var
    UsedIndices : TList<Integer>;
    Count : Integer;
  private
    FShortage : string;
    FIndex : Integer;
    FInstance : Integer;
    procedure SetIndex(const Value : Integer);
  public
    constructor Create(Shortage : string; Index : Integer);
    destructor Destroy(); override;
    property Shortage : string read FShortage write FShortage;
    property Index : Integer read FIndex write SetIndex;
    property Instance : Integer read FInstance;
  end;

function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TInputData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TAnalogInputData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TOutputData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TAnalogOutputData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TCrossesData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TSelectLangData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;

// function VSTHChange(AVST : TVirtualStringTree; ARecord : TTreeData; Checked : boolean; ANode :
// PVirtualNode) : PVirtualNode;
// function VSTHChecked(AVST : TCustomVirtualStringTree; ANode : PVirtualNode) : boolean;
// procedure VSTHCreate(AVST : TVirtualStringTree);
// procedure VSTHDel(AVST : TVirtualStringTree; ANode : PVirtualNode);
//
implementation

function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TInputData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
var
  Data : PInputData;
begin
  result := AVST.AddChild(ANode);
  Data := AVST.GetNodeData(result);
  AVST.ValidateNode(result, false);
  Data^ := ARecord;
end;

function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TAnalogInputData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
var
  Data : PAnalogInputData;
begin
  result := AVST.AddChild(ANode);
  Data := AVST.GetNodeData(result);
  AVST.ValidateNode(result, false);
  Data^ := ARecord;
end;

function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TOutputData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
var
  Data : POutputData;
begin
  result := AVST.AddChild(ANode);
  Data := AVST.GetNodeData(result);
  AVST.ValidateNode(result, false);
  Data^ := ARecord;
end;

function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TAnalogOutputData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
var
  Data : PAnalogOutputData;
begin
  result := AVST.AddChild(ANode);
  Data := AVST.GetNodeData(result);
  AVST.ValidateNode(result, false);
  Data^ := ARecord;
end;

function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TCrossesData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
begin
  result := AVST.AddChild(ANode, ARecord);
  AVST.ValidateNode(result, false);
end;

function VSTHAdd(AVST : TCustomVirtualStringTree; ARecord : TSelectLangData; ANode : PVirtualNode = nil)
  : PVirtualNode; overload;
begin
  result := AVST.AddChild(ANode, ARecord);
  AVST.ValidateNode(result, false);
end;

// function VSTHChange(AVST : TVirtualStringTree; ARecord : TTreeData; Checked : boolean; ANode :
// PVirtualNode) : PVirtualNode;
// var
// NodeData : PTreeData;
// sName : string;
// slSkipFolders, slSkipFiles : TStringList;
// begin
// sName := '';
// if AVST.GetNodeLevel(ANode) = 1 then
// begin
// NodeData := AVST.GetNodeData(ANode.Parent);
// sName := NodeData^.sName + ' ';
// end;
// NodeData := AVST.GetNodeData(ANode);
// if ARecord.sName = sName + NodeData^.sName then
// begin
// result := ANode;
// ARecord.sName := NodeData^.sName;
// NodeData^ := ARecord;
// AVST.CheckState[result] := csCheckedNormal;
// if not Checked then
// begin
// AVST.CheckState[result] := csUncheckedNormal;
// end;
// end
// else
// begin
// slSkipFolders := TStringList.Create;
// slSkipFolders.Sorted := true;
// slSkipFolders.Duplicates := dupIgnore;
// slSkipFolders.Assign(ARecord.SkipFolders);
// ARecord.SkipFolders := slSkipFolders;
// slSkipFiles := TStringList.Create;
// slSkipFiles.Sorted := true;
// slSkipFiles.Duplicates := dupIgnore;
// slSkipFiles.Assign(ARecord.SkipFiles);
// ARecord.SkipFiles := slSkipFiles;
// result := VSTHAdd(AVST, ARecord, Checked);
// if result.Parent = ANode then
// begin
// ANode := AVST.GetFirstChild(ANode);
// end;
// VSTHDEL(AVST, ANode);
// end;
// end;
//
// function VSTHChecked(AVST : TCustomVirtualStringTree; ANode : PVirtualNode) : boolean;
// var
// CheckState : TCheckState;
// begin
// result := false;
// if ANode <> nil then
// begin
// CheckState := AVST.CheckState[ANode];
// result := CheckState = csCheckedNormal;
// end;
// end;

// procedure VSTHCreate(AVST : TVirtualStringTree);
// begin
// AVST.NodeDataSize := SizeOf(TApplicationData);
// end;

// procedure VSTHDel(AVST : TVirtualStringTree; ANode : PVirtualNode);
// var
// RootNode, SubNode : PVirtualNode;
// RootData, SubData : PTreeData;
// s : string;
// begin
// if Assigned(ANode) then
// begin
// if AVST.GetNodeLevel(ANode) = 1 then
// begin
// RootNode := ANode.Parent;
// AVST.DeleteNode(ANode);
// if AVST.ChildCount[RootNode] = 1 then
// begin
// SubNode := AVST.GetFirstChild(RootNode);
// RootData := AVST.GetNodeData(RootNode);
// SubData := AVST.GetNodeData(SubNode);
// s := RootData^.sName + ' ' + SubData^.sName;
// RootData^ := SubData^;
// RootData^.SkipFolders := TStringlist.Create;
// RootData^.SkipFolders.Sorted := true;
// RootData^.SkipFolders.Duplicates := dupIgnore;
// RootData^.SkipFolders.Assign(SubData^.SkipFolders);
// RootData^.SkipFiles := TStringlist.Create;
// RootData^.SkipFiles.Sorted := true;
// RootData^.SkipFiles.Duplicates := dupIgnore;
// RootData^.SkipFiles.Assign(SubData^.SkipFiles);
// RootData^.sName := s;
// AVST.CheckState[RootNode] := AVST.CheckState[SubNode];
// AVST.DeleteNode(SubNode);
// end;
// end
// else
// begin
// AVST.DeleteNode(ANode);
// end;
// end;
// end;

{ TSelectLangData }

constructor TSelectLangData.Create(Shortage : string; Index : Integer);
begin
  if UsedIndices = nil then
  begin
    UsedIndices := TList<Integer>.Create;
  end;
  inc(Count);
  FInstance := UsedIndices.Count;
  UsedIndices.Add(Index);
  FShortage := Shortage;
  FIndex := Index;
end;

destructor TSelectLangData.Destroy;
begin
  Dec(Count);
  if Count = 0 then
  begin
    UsedIndices.Clear;
    FreeandNil(UsedIndices);
  end
  else
  begin
    UsedIndices.Items[FInstance] := - 1;
  end;
end;

procedure TSelectLangData.SetIndex(const Value : Integer);
begin
  FIndex := Value;
  UsedIndices.Items[FInstance] := Value;
end;

{ TCrossesData }

constructor TCrossesData.Create(Settings : TSettings);
begin
  SetLength(OutputMode, Settings.NumOfOutputs);
  SetLength(Input, Settings.NumOfInputs);
  SetLength(Intervall, Settings.NumOfIntervalls);
  SetLength(AnalogIn, Settings.NumOfAnalogIn);
  SetLength(AnalogOut, Settings.NumOfAnalogOut);
end;

end.
