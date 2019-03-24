unit fSelectLangIndex;

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
  JvSpin,
  JvToolEdit,
  VTreeHelper,
  csUtils,
  StdCtrls,
  Generics.Collections;

type
  TSelectLangIndex = class(TForm)
    btOk : TButton;
    btCancel : TButton;
    vstLangIndex : TVirtualStringTree;
    procedure vstLangIndexCreateEditor(Sender : TBaseVirtualTree; Node : PVirtualNode;
      Column : TColumnIndex; out EditLink : IVTEditLink);
    procedure vstLangIndexEditing(Sender : TBaseVirtualTree; Node : PVirtualNode;
      Column : TColumnIndex; var Allowed : Boolean);
    procedure vstLangIndexMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState;
      X, Y : Integer);
    procedure FormShow(Sender : TObject);
    procedure vstLangIndexFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
    procedure vstLangIndexGetText(Sender : TBaseVirtualTree; Node : PVirtualNode;
      Column : TColumnIndex; TextType : TVSTTextType; var CellText : string);
    procedure FormCreate(Sender : TObject);
    procedure btOkClick(Sender : TObject);
    procedure vstLangIndexBeforeCellPaint(Sender : TBaseVirtualTree; TargetCanvas : TCanvas;
      Node : PVirtualNode; Column : TColumnIndex; CellPaintMode : TVTCellPaintMode;
      CellRect : TRect; var ContentRect : TRect);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FLangDesc : TStringList;
    FIndizes : TList<Integer>;
    {Private-Deklarationen}
  public
    property LangDesc : TStringList read FLangDesc write FLangDesc;
    property Indizes : TList<Integer>read FIndizes write FIndizes;
  end;

  TPropertyEditLinkLang = class(TInterfacedObject, IVTEditLink)
  private
    FEdit : TWinControl;
    FTree : TVirtualStringTree;
    FNode : PVirtualNode;
    FColumn : Integer;
    FIndizes : TList<Integer>;
  protected
    procedure EditKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
  public
    constructor Create(Indizes : TList<Integer>);
    destructor Destroy; override;

    function BeginEdit : Boolean; stdcall;
    function CancelEdit : Boolean; stdcall;
    function EndEdit : Boolean; stdcall;
    function GetBounds : TRect; stdcall;
    function PrepareEdit(Tree : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex)
      : Boolean; stdcall;
    procedure ProcessMessage(var Message : TMessage); stdcall;
    procedure SetBounds(R : TRect); stdcall;
  end;

implementation

{$R *.dfm}

destructor TPropertyEditLinkLang.Destroy;

begin
  FEdit.Free;
  inherited;
end;

procedure TPropertyEditLinkLang.EditKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);

var
  CanAdvance : Boolean;

begin
  CanAdvance := true;

  case Key of
    VK_ESCAPE :
      if CanAdvance then
      begin
        FTree.CancelEditNode;
        Key := 0;
      end;
    VK_RETURN :
      if CanAdvance then
      begin
        FTree.EndEditNode;
        Key := 0;
      end;

    VK_UP, VK_DOWN :
      begin
        CanAdvance := Shift = [];
        if FEdit is TComboBox then
          CanAdvance := CanAdvance and not TComboBox(FEdit).DroppedDown;
        if FEdit is TJvFilenameEdit then
          CanAdvance := false;
        if FEdit is TJvSpinEdit then
          CanAdvance := false;
        if FEdit is TEdit then
          CanAdvance := false;
        if CanAdvance then
        begin
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;
end;

function TPropertyEditLinkLang.BeginEdit : Boolean;

begin
  Result := true;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TPropertyEditLinkLang.CancelEdit : Boolean;

begin
  Result := true;
  FEdit.Hide;
end;

constructor TPropertyEditLinkLang.Create(Indizes : TList<Integer>);
begin
  inherited Create;
  FIndizes := Indizes;
end;

function TPropertyEditLinkLang.EndEdit : Boolean;
var
  Data : TSelectLangData;
begin
  Result := true;
  Data := TSelectLangData(FTree.GetNodeData(FNode)^);
  if FEdit is TJvFilenameEdit then
  begin
    // Data^.sFileName := TJvFilenameEdit(FEdit).FileName;
    FTree.InvalidateNode(FNode);
  end;
  if FEdit is TEdit then
  begin
    // Data^.Name := TEdit(FEdit).Text;
    FTree.InvalidateNode(FNode);
  end;
  if FEdit is TComboBox then
  begin
    Data.Index := StrToInt(TComboBox(FEdit).Text) - 1;
    FTree.InvalidateNode(FNode);
  end;
  if FEdit is TJvSpinEdit then
  begin
    // Data^.iTimeout := TJvSpinEdit(FEdit).AsInteger * 1000;
    FTree.InvalidateNode(FNode);
  end;
  FEdit.Hide;
  FTree.SetFocus;
end;

function TPropertyEditLinkLang.GetBounds : TRect;

begin
  Result := FEdit.BoundsRect;
end;

function TPropertyEditLinkLang.PrepareEdit(Tree : TBaseVirtualTree; Node : PVirtualNode;
  Column : TColumnIndex) : Boolean;

var
  Data : TSelectLangData;
  i : Integer;
begin
  Result := true;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FEdit.Free;
  FEdit := nil;
  Data := TSelectLangData(FTree.GetNodeData(Node)^);
  case FColumn of
    // 0 :
    // begin
    // FEdit := TJvFilenameEdit.Create(nil);
    // with FEdit as TJvFilenameEdit do
    // begin
    // Visible := false;
    // Parent := Tree;
    // DialogOptions := [ofHideReadOnly, ofFileMustExist];
    // ButtonFlat := true;
    // //Text := Data^.sFileName;
    // OnKeyDown := EditKeyDown;
    // { TODO : Hier anpassen }
    // Filter := 'Anwendungen (*.exe;*.cmd;*.bat)|*.exe;*.cmd;*.bat';
    // DialogTitle := 'Anwendung auswählen';
    // end;
    // end;

// 0 :
// begin
// FEdit := TEdit.Create(nil);
// with FEdit as TEdit do
// begin
// Visible := false;
// Parent := Tree;
// ParentShowHint := false;
// ShowHint := true;
// Text := Data^.Name;
// OnKeyDown := EditKeyDown;
// end;
// end;
    1 :
      begin
        FEdit := TComboBox.Create(nil);
        with FEdit as TComboBox do
        begin
          Visible := false;
          Parent := Tree;
          for i := 0 to FIndizes.Count - 1 do
          begin
            Items.Add(IntToStr(FIndizes.Items[i] + 1));
          end;
          Text := Items.Strings[Data.Index];
          OnKeyDown := EditKeyDown;
        end;
      end;
    // 2 :
    // begin
    // FEdit := TJvSpinEdit.Create(nil);
    // with FEdit as TJvSpinEdit do
    // begin
    // Visible := False;
    // Parent := Tree;
    // ButtonKind := bkStandard;
    // MaxLength := 0;
    // Decimal := 2;
    // MinValue := 1;
    // MaxValue := 0;
    // CheckMaxValue := false;
    // // Value := Data^.iTimeout div 1000;
    // OnKeyDown := EditKeyDown;
    // end;
    // end;

  else
    Result := false;
  end;
end;

// ----------------------------------------------------------------------------------------------------------------------

procedure TPropertyEditLinkLang.ProcessMessage(var Message : TMessage);

begin
  FEdit.WindowProc(Message);
end;

// ----------------------------------------------------------------------------------------------------------------------

procedure TPropertyEditLinkLang.SetBounds(R : TRect);

var
  Dummy : Integer;

begin
  // Since we don't want to activate grid extensions in the tree (this would influence how the selection is drawn)
  // we have to set the edit's width explicitly to the width of the column.
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;

end;

procedure TSelectLangIndex.btOkClick(Sender : TObject);
var
  Node : PVirtualNode;
  NodeData : TSelectLangData;
begin
  vstLangIndex.EndEditNode;
  FIndizes.Clear;
  Node := vstLangIndex.GetFirst();
  while Node <> nil do
  begin
    NodeData := TSelectLangData(vstLangIndex.GetNodeData(Node)^);
    if Assigned(NodeData) then
    begin
      FIndizes.Add(NodeData.Index);
    end;
    Node := vstLangIndex.GetNext(Node);
  end;
end;

procedure TSelectLangIndex.FormClose(Sender: TObject; var Action: TCloseAction);
begin
vstLangIndex.Clear;
end;

procedure TSelectLangIndex.FormCreate(Sender : TObject);
begin
  vstLangIndex.NodeDataSize := SizeOf(TSelectLangData);
end;

procedure TSelectLangIndex.FormShow(Sender : TObject);
var
  i : Integer;
  NodeData : TSelectLangData;
begin
  for i := 0 to FLangDesc.Count - 1 do
  begin
    NodeData := TSelectLangData.Create(FLangDesc.Strings[i], FIndizes.Items[i]);
    VSTHAdd(vstLangIndex, NodeData);
  end;
end;

procedure TSelectLangIndex.vstLangIndexBeforeCellPaint(Sender : TBaseVirtualTree;
  TargetCanvas : TCanvas; Node : PVirtualNode; Column : TColumnIndex;
  CellPaintMode : TVTCellPaintMode; CellRect : TRect; var ContentRect : TRect);
var
  i : Integer;
  NodeData : TSelectLangData;
begin
  if Column = 1 then
  begin
    NodeData := TSelectLangData(vstLangIndex.GetNodeData(Node)^);
    if Assigned(NodeData) then
    begin
      for i := 0 to TSelectLangData.UsedIndices.Count - 1 do
      begin
        if (NodeData.Instance <> i) and (NodeData.Index = TSelectLangData.UsedIndices.Items[i]) then
        begin
          TargetCanvas.Brush.Color := clYellow;
          TargetCanvas.FillRect(CellRect);
          Break;
        end;
      end;
    end;
  end;
end;

procedure TSelectLangIndex.vstLangIndexCreateEditor(Sender : TBaseVirtualTree; Node : PVirtualNode;
  Column : TColumnIndex; out EditLink : IVTEditLink);
begin
  EditLink := TPropertyEditLinkLang.Create(FIndizes);
end;

procedure TSelectLangIndex.vstLangIndexEditing(Sender : TBaseVirtualTree; Node : PVirtualNode;
  Column : TColumnIndex; var Allowed : Boolean);
begin
  Allowed := Column = 1;
end;

procedure TSelectLangIndex.vstLangIndexFreeNode(Sender : TBaseVirtualTree; Node : PVirtualNode);
var
  NodeData : TSelectLangData;
begin
  NodeData := TSelectLangData(vstLangIndex.GetNodeData(Node)^);
  if Assigned(NodeData) then
  begin
    FreeAndNil(NodeData);
  end;
end;

procedure TSelectLangIndex.vstLangIndexGetText(Sender : TBaseVirtualTree; Node : PVirtualNode;
  Column : TColumnIndex; TextType : TVSTTextType; var CellText : string);
var
  NodeData : TSelectLangData;
begin
  NodeData := TSelectLangData(vstLangIndex.GetNodeData(Node)^);
  if Assigned(NodeData) then
  begin
    case Column of
      0 :
        CellText := NodeData.Shortage;
      1 :
        CellText := IntToStr(NodeData.Index + 1);
    end;
  end;
end;

procedure TSelectLangIndex.vstLangIndexMouseUp(Sender : TObject; Button : TMouseButton;
  Shift : TShiftState; X, Y : Integer);
var
  Node : PVirtualNode;
  Column : Integer;
begin
  Node := vstLangIndex.GetNodeAt(X, Y);
  Column := vstLangIndex.Header.Columns.ColumnFromPosition(Point(X, Y));
  if Assigned(Node) then
  begin
    case Column of
      0 :
        ;
      1 :
        vstLangIndex.EditNode(Node, Column);
    end;
  end;
end;

end.
