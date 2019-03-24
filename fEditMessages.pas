unit fEditMessages;

interface

{$INCLUDE Compilerswitches.inc}

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
  VirtualTrees,
  VPropertyTreeEditors,
  ActiveX,
  StdCtrls;

type
  TEditMessages = class(TForm)
    vstMessages : TVirtualStringTree;
    btOk : TButton;
    btCancel : TButton;
    procedure FormCreate(Sender : TObject);
    procedure vstMessagesGetText(Sender : TBaseVirtualTree; Node : PVirtualNode;
      Column : TColumnIndex; TextType : TVSTTextType; var CellText : string);
    procedure vstMessagesFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
    procedure vstMessagesEditing(Sender : TBaseVirtualTree; Node : PVirtualNode;
      Column : TColumnIndex; var Allowed : Boolean);
    procedure vstMessagesNewText(Sender : TBaseVirtualTree; Node : PVirtualNode;
      Column : TColumnIndex; NewText : string);
    procedure vstMessagesDragAllowed(Sender : TBaseVirtualTree; Node : PVirtualNode;
      Column : TColumnIndex; var Allowed : Boolean);
    procedure vstMessagesDragDrop(Sender : TBaseVirtualTree; Source : TObject;
      DataObject : IDataObject; Formats : TFormatArray; Shift : TShiftState; Pt : TPoint;
      var Effect : Integer; Mode : TDropMode);
    procedure vstMessagesDragOver(Sender : TBaseVirtualTree; Source : TObject; Shift : TShiftState;
      State : TDragState; Pt : TPoint; Mode : TDropMode; var Effect : Integer;
      var Accept : Boolean);
    procedure vstMessagesKeyUp(Sender : TObject; var Key : Word; Shift : TShiftState);
  private
    function GetMessages : TStringList;
    procedure SetMessages(const Value : TStringList);
    {Private-Deklarationen}
  public
    property Messages : TStringList read GetMessages write SetMessages;
  end;

implementation

{$R *.dfm}

procedure TEditMessages.FormCreate(Sender : TObject);
begin
  vstMessages.NodeDataSize := SizeOf(string);
end;

function TEditMessages.GetMessages : TStringList;
var
  Node : PVirtualNode;
  Data : PString;
begin
  Node := vstMessages.GetFirst();
  Result := TStringList.Create;
  while Node <> nil do
  begin
    Data := vstMessages.GetNodeData(Node);
    Result.Add(Data^);
    Node := vstMessages.GetNext(Node);
  end;
end;

procedure TEditMessages.SetMessages(const Value : TStringList);
var
  Node : PVirtualNode;
  Data : PString;
  Texts : string;
begin
  for Texts in Value do
  begin
    Node := vstMessages.AddChild(nil);
    Data := vstMessages.GetNodeData(Node);
    vstMessages.ValidateNode(Node, false);
    Data^ := Texts;
  end;
end;

procedure TEditMessages.vstMessagesDragAllowed(Sender : TBaseVirtualTree; Node : PVirtualNode;
  Column : TColumnIndex; var Allowed : Boolean);
begin
  Allowed := True;
end;

procedure TEditMessages.vstMessagesDragDrop(Sender : TBaseVirtualTree; Source : TObject;
  DataObject : IDataObject; Formats : TFormatArray; Shift : TShiftState; Pt : TPoint;
  var Effect : Integer; Mode : TDropMode);

 // --------------- local function --------------------------------------------

  procedure DetermineEffect;

  // Determine the drop effect to use if the source is a Virtual Treeview.

  begin
    // In the case the source is a Virtual Treeview we know 'move' is the default if dragging within
    // the same tree and copy if dragging to another tree. Set Effect accordingly.
    if Shift = [] then
    begin
      // No modifier key, so use standard action.
      if Source = Sender then
        Effect := DROPEFFECT_MOVE
      else
        Effect := DROPEFFECT_COPY;
    end
    else
    begin
      // A modifier key is pressed, hence use this to determine action.
      if (Shift = [ssAlt]) or (Shift = [ssCtrl, ssAlt]) then
        Effect := DROPEFFECT_LINK
      else if Shift = [ssCtrl] then
        Effect := DROPEFFECT_COPY
      else
        Effect := DROPEFFECT_MOVE;
    end;
  end;

  // --------------- end local function ----------------------------------------

var
  Attachmode : TVTNodeAttachMode;
  Nodes : TNodeArray;
  I : Integer;

begin
  Nodes := nil;

  // Translate the drop position into an node attach mode.
  case Mode of
    dmAbove :
      Attachmode := amInsertBefore;
    dmOnNode :
      Attachmode := amAddChildLast;
    dmBelow :
      Attachmode := amInsertAfter;
  else
    Attachmode := amNowhere;
  end;

  if DataObject = nil then
  begin
    // VCL drag'n drop. Handling this requires detailed knowledge about the sender and its data. This is one reason
    // why it was a bad decision by Borland to implement something own instead using the system's way.
    // In this demo we have two known sources of VCL dd data: vstMessages and LogListBox.
    if Source = vstMessages then
    begin
      // Since we know this is a Virtual Treeview we can ignore the drop event entirely and use VT mechanisms.
      DetermineEffect;
      Nodes := vstMessages.GetSortedSelection(True);
      if Effect = DROPEFFECT_COPY then
      begin
        for I := 0 to High(Nodes) do
          vstMessages.CopyTo(Nodes[I], Sender.DropTargetNode, Attachmode, false);
      end
      else
        for I := 0 to High(Nodes) do
          vstMessages.MoveTo(Nodes[I], Sender.DropTargetNode, Attachmode, false);
    end;
  end;
end;

procedure TEditMessages.vstMessagesDragOver(Sender : TBaseVirtualTree; Source : TObject;
  Shift : TShiftState; State : TDragState; Pt : TPoint; Mode : TDropMode; var Effect : Integer;
  var Accept : Boolean);
begin
  Accept := True;
end;

procedure TEditMessages.vstMessagesEditing(Sender : TBaseVirtualTree; Node : PVirtualNode;
  Column : TColumnIndex; var Allowed : Boolean);
begin
  Allowed := True;
end;

procedure TEditMessages.vstMessagesFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
var
  Data : PString;
begin
  Data := vstMessages.GetNodeData(Node);
  if Assigned(Data) then
  begin
    Data^ := '';
  end;
end;

procedure TEditMessages.vstMessagesGetText(Sender : TBaseVirtualTree; Node : PVirtualNode;
  Column : TColumnIndex; TextType : TVSTTextType; var CellText : string);
var
  Data : PString;
begin
  Data := vstMessages.GetNodeData(Node);
  if Assigned(Data) then
  begin
    CellText := Data^;
  end;
end;

procedure TEditMessages.vstMessagesKeyUp(Sender : TObject; var Key : Word; Shift : TShiftState);
var
  Node : PVirtualNode;
begin
  if Key = VK_DELETE then
  begin
    Node := vstMessages.FocusedNode;
    if Assigned(Node) then
    begin
      vstMessages.DeleteNode(Node);
    end;
  end;
end;

procedure TEditMessages.vstMessagesNewText(Sender : TBaseVirtualTree; Node : PVirtualNode;
  Column : TColumnIndex; NewText : string);
var
  Data : PString;
begin
  Data := vstMessages.GetNodeData(Node);
  if Assigned(Data) then
  begin
    Data^ := NewText;
  end;
end;

end.
