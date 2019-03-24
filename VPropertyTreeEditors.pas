unit VPropertyTreeEditors;

// Utility unit for the advanced Virtual Treeview demo application which contains the implementation of edit link
// interfaces used in other samples of the demo.

interface

{$INCLUDE Compilerswitches.inc}

uses
  StdCtrls,
  Controls,
  VirtualTrees,
  Classes,
  Windows,
  Messages,
  JvSpin,
  JvToolEdit,
  VTreeHelper,
  csUtils;

type
  TPropertyEditLink = class(TInterfacedObject, IVTEditLink)
  private
    FEdit : TWinControl;
    FTree : TVirtualStringTree;
    FNode : PVirtualNode;
    FColumn : Integer;
  protected
    procedure EditKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
  public
    destructor Destroy; override;

    function BeginEdit : Boolean; stdcall;
    function CancelEdit : Boolean; stdcall;
    function EndEdit : Boolean; virtual; stdcall; abstract;
    function GetBounds : TRect; stdcall;
    function PrepareEdit(Tree : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex) : Boolean; virtual;
      stdcall; abstract;
    procedure ProcessMessage(var Message : TMessage); stdcall;
    procedure SetBounds(R : TRect); stdcall;
  end;

  TAnalogInputEditLink = class(TPropertyEditLink)
  public
    function EndEdit : Boolean; override; stdcall;
    function PrepareEdit(Tree : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex) : Boolean;
      override; stdcall;

  end;

  TOutputEditLink = class(TPropertyEditLink)
  public
    function EndEdit : Boolean; override; stdcall;
    function PrepareEdit(Tree : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex) : Boolean;
      override; stdcall;

  end;

  TAnalogOutputEditLink = class(TPropertyEditLink)
  public
    function EndEdit : Boolean; override; stdcall;
    function PrepareEdit(Tree : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex) : Boolean;
      override; stdcall;

  end;

  // ----------------------------------------------------------------------------------------------------------------------

  // ----------------------------------------------------------------------------------------------------------------------

implementation

uses
  Dialogs;

destructor TPropertyEditLink.Destroy;

begin
  FEdit.Free;
  inherited;
end;

procedure TPropertyEditLink.EditKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);

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

function TPropertyEditLink.BeginEdit : Boolean;

begin
  Result := true;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TPropertyEditLink.CancelEdit : Boolean;

begin
  Result := true;
  FEdit.Hide;
end;

function TPropertyEditLink.GetBounds : TRect;

begin
  Result := FEdit.BoundsRect;
end;

// ----------------------------------------------------------------------------------------------------------------------

procedure TPropertyEditLink.ProcessMessage(var Message : TMessage);

begin
  FEdit.WindowProc(Message);
end;

// ----------------------------------------------------------------------------------------------------------------------

procedure TPropertyEditLink.SetBounds(R : TRect);

var
  Dummy : Integer;

begin
  // Since we don't want to activate grid extensions in the tree (this would influence how the selection is drawn)
  // we have to set the edit's width explicitly to the width of the column.
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;

end;

{ TOutputEditLink }

function TOutputEditLink.EndEdit : Boolean;
var
  Data : POutputData;
begin
  Result := true;
  Data := FTree.GetNodeData(FNode);
  case FColumn of
    0 :
      begin
        Data^.Name := TEdit(FEdit).Text;
        FTree.InvalidateNode(FNode);
      end;
    1 :
      begin
        Data^.Mode := TComboBox(FEdit).Items.IndexOf(TComboBox(FEdit).Text);
        FTree.InvalidateNode(FNode);
      end;
  end;
  FEdit.Hide;
  FTree.SetFocus;
end;

function TOutputEditLink.PrepareEdit(Tree : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex) : Boolean;
var
  Data : POutputData;
  i : Integer;
begin
  Result := true;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FEdit.Free;
  FEdit := nil;
  Data := FTree.GetNodeData(Node);
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

    0 :
      begin
        FEdit := TEdit.Create(nil);
        with FEdit as TEdit do
        begin
          Visible := false;
          Parent := Tree;
          ParentShowHint := false;
          ShowHint := true;
          Text := Data^.Name;
          OnKeyDown := EditKeyDown;
        end;
      end;
    1 :
      begin
        FEdit := TComboBox.Create(nil);
        with FEdit as TComboBox do
        begin
          Visible := false;
          Parent := Tree;
          for i := 0 to High(Mode) do
          begin
            Items.Add(Mode[i]);
          end;
          Text := Items.Strings[Data^.Mode];
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

{ TAnalogInputEditLink }

function TAnalogInputEditLink.EndEdit : Boolean;
var
  Data : PAnalogInputData;
begin
  Result := true;
  Data := FTree.GetNodeData(FNode);
  case FColumn of
    0 :
      begin
        Data^.Name := TEdit(FEdit).Text;
        FTree.InvalidateNode(FNode);
      end;
    1 :
      begin
        Data^.Value := TJvSpinEdit(FEdit).Value;
        FTree.InvalidateNode(FNode);
      end;
    2 :
      begin
        Data^.Mode := TComboBox(FEdit).Items.IndexOf(TComboBox(FEdit).Text);
        FTree.InvalidateNode(FNode);
      end;
  end;
  FEdit.Hide;
  FTree.SetFocus;
end;

function TAnalogInputEditLink.PrepareEdit(Tree : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex)
  : Boolean;

var
  Data : PAnalogInputData;
  i : Integer;
begin
  Result := true;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FEdit.Free;
  FEdit := nil;
  Data := FTree.GetNodeData(Node);
  case FColumn of
    0 :
      begin
        FEdit := TEdit.Create(nil);
        with FEdit as TEdit do
        begin
          Visible := false;
          Parent := Tree;
          ParentShowHint := false;
          ShowHint := true;
          Text := Data^.Name;
          OnKeyDown := EditKeyDown;
        end;
      end;
    1 :
      begin
        FEdit := TJvSpinEdit.Create(nil);
        with FEdit as TJvSpinEdit do
        begin
          Visible := false;
          Parent := Tree;
          ButtonKind := bkStandard;
          MaxLength := 0;
          Decimal := 2;
          MinValue := 0;
          MaxValue := 0;
          ValueType := vtFloat;
          CheckMinValue := false;
          CheckMaxValue := false;
          ButtonKind := bkDiagonal;
          Value := Data^.Value;
          OnKeyDown := EditKeyDown;
        end;
      end;
    2 :
      begin
        FEdit := TComboBox.Create(nil);
        with FEdit as TComboBox do
        begin
          Visible := false;
          Parent := Tree;
          for i := 0 to High(AnalogInMode) do
          begin
            Items.Add(AnalogInMode[i]);
          end;
          Text := Items.Strings[Data^.Mode];
          OnKeyDown := EditKeyDown;
        end;
      end;
  else
    Result := false;
  end;
end;

{ TAnalogOutputEditLink }

function TAnalogOutputEditLink.EndEdit : Boolean;
var
  Data : PAnalogOutputData;
begin
  Result := true;
  Data := FTree.GetNodeData(FNode);
  case FColumn of
    0 :
      begin
        Data^.Name := TEdit(FEdit).Text;
        FTree.InvalidateNode(FNode);
      end;
    1 :
      begin
        Data^.Value := TJvSpinEdit(FEdit).Value;
        FTree.InvalidateNode(FNode);
      end;
    2 :
      begin
        Data^.UnitName := TEdit(FEdit).Text;
        FTree.InvalidateNode(FNode);
      end;
  end;
  FEdit.Hide;
  FTree.SetFocus;
end;

function TAnalogOutputEditLink.PrepareEdit(Tree : TBaseVirtualTree; Node : PVirtualNode; Column : TColumnIndex)
  : Boolean;
var
  Data : PAnalogOutputData;
begin
  Result := true;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  FEdit.Free;
  FEdit := nil;
  Data := FTree.GetNodeData(Node);
  case FColumn of
    0 :
      begin
        FEdit := TEdit.Create(nil);
        with FEdit as TEdit do
        begin
          Visible := false;
          Parent := Tree;
          ParentShowHint := false;
          ShowHint := true;
          Text := Data^.Name;
          OnKeyDown := EditKeyDown;
        end;
      end;
    1 :
      begin
        FEdit := TJvSpinEdit.Create(nil);
        with FEdit as TJvSpinEdit do
        begin
          Visible := false;
          Parent := Tree;
          ButtonKind := bkStandard;
          MaxLength := 0;
          Decimal := 2;
          MinValue := 0;
          MaxValue := 0;
          ValueType := vtFloat;
          CheckMinValue := false;
          CheckMaxValue := false;
          ButtonKind := bkDiagonal;
          Value := Data^.Value;
          OnKeyDown := EditKeyDown;
        end;
      end;
    2 :
      begin
        begin
          FEdit := TEdit.Create(nil);
          with FEdit as TEdit do
          begin
            Visible := false;
            Parent := Tree;
            ParentShowHint := false;
            ShowHint := true;
            Text := Data^.UnitName;
            OnKeyDown := EditKeyDown;
          end;
        end;
      end;
  else
    Result := false;
  end;
end;

end.
