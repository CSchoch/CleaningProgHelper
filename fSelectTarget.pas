unit fSelectTarget;

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
  StdCtrls,
  Mask,
  JvExMask,
  JvSpin;

type
  TSelectTarget = class(TForm)
    seProgramNumber : TJvSpinEdit;
    lProgram : TLabel;
    btOk : TButton;
    btCancel : TButton;
  private
    procedure SetMaxNumber(const Value : Integer);
    function GetSelectedNumber : Integer;
    {Private-Deklarationen}
  public
    property MaxNumber : Integer write SetMaxNumber;
    property SelectedNumber : Integer read GetSelectedNumber;
  end;

implementation

{$R *.dfm}

function TSelectTarget.GetSelectedNumber : Integer;
begin
  Result := seProgramNumber.AsInteger;
end;

procedure TSelectTarget.SetMaxNumber(const Value : Integer);
begin
  seProgramNumber.MaxValue := Value;
end;

end.
