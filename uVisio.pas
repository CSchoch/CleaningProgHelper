unit uVisio;

{$I Compilerswitches.inc}

interface

uses
  SysUtils;

type
  TBaseVisioStepContainer = class
    constructor Create; virtual; abstract;
  end;

  TVisioStep<T> = class
  private
    //FDestroyed: Boolean;
    FName: string;
    FStepNumber: Integer;
    FPrev: TVisioStep<T>;
    FNext: TVisioStep<T>;
    //FPrevLeft: T;
    //FNextLeft: T;
    FPrevRight: T;
    FNextRight: T;
  public
    destructor Destroy; override;

    property Name: string read FName write FName;
    property StepNumber: Integer read FStepNumber write FStepNumber;
    property Prev: TVisioStep<T>read FPrev write FPrev;
    property Next: TVisioStep<T>read FNext write FNext;
    //property PrevLeft: T read FPrevLeft write FPrevLeft;
    //property NextLeft: T read FNextLeft write FNextLeft;
    property PrevRight: T read FPrevRight write FPrevRight;
    property NextRight: T read FNextRight write FNextRight;
  end;

  TVisioStepContainer = class
  private
    FFirst: TVisioStep<TVisioStepContainer>;
    FLast: TVisioStep<TVisioStepContainer>;
  public
      destructor Destroy; override;
    procedure Add(Step: TVisioStep<TVisioStepContainer>);
    procedure Delete(Step: TVisioStep<TVisioStepContainer>);
    function Find(index: Integer): TVisioStep<TVisioStepContainer>;
    function GetFirst(): TVisioStep<TVisioStepContainer>;
    function GetLast(): TVisioStep<TVisioStepContainer>;
    function GetNext(Step: TVisioStep<TVisioStepContainer>): TVisioStep<TVisioStepContainer>;
    function GetPrev(Step: TVisioStep<TVisioStepContainer>): TVisioStep<TVisioStepContainer>;
  end;

implementation

{TVisioStepContainer}

procedure TVisioStepContainer.Add(Step: TVisioStep<TVisioStepContainer>);
begin
  if FLast <> nil then
  begin
    FLast.Next := Step;
    Step.Prev := FLast;
    FLast := FLast.Next;
  end
  else
  begin
    FFirst := Step;
    FLast := Step;
  end;
end;

procedure TVisioStepContainer.Delete(Step: TVisioStep<TVisioStepContainer>);
var
  Step2: TVisioStep<TVisioStepContainer>;
begin
  Step2 := Self.GetFirst;
  while Step2 <> nil do
  begin
    if Step = Step2 then
    begin
      if Step2 = FFirst then
      begin
        FFirst := Step2.Next;
      end;
      if Step2 = FLast then
      begin
        FLast := Step2.Prev;
      end;
      if Step2.Prev <> nil then
      begin
        Step2.Prev.Next := Step2.Next;
      end;
      if Step2.Next <> nil then
      begin
        Step2.Next.Prev := Step2.Prev;
      end;
      Break;
    end;
    Step2 := Self.GetNext(Step2);
  end;
end;

function TVisioStepContainer.Find(index: Integer): TVisioStep<TVisioStepContainer>;
var
  Step, Step2: TVisioStep<TVisioStepContainer>;
begin
  Result := nil;
  Step := Self.GetFirst;
  while Step <> nil do
  begin
    if Step.StepNumber = index then
    begin
      Result := Step;
      Break;
    end;
    (*Step2 := Step.FPrevLeft.Find(index);
    if Step2 <> nil then
    begin
      Result := Step2;
      Break;
    end;
    Step2 := Step.FNextLeft.Find(index);
    if Step2 <> nil then
    begin
      Result := Step2;
      Break;
    end;*)
    Step2 := Step.FPrevRight.Find(index);
    if Step2 <> nil then
    begin
      Result := Step2;
      Break;
    end;
    Step2 := Step.FNextRight.Find(index);
    if Step2 <> nil then
    begin
      Result := Step2;
      Break;
    end;
    Step := Self.GetNext(Step);
  end;
end;

destructor TVisioStepContainer.Destroy;
var
  Step: TVisioStep<TVisioStepContainer>;
begin
  Step := Self.GetFirst;
  try
  FreeAndNil(Step);
  except
  end;
  Self.FFirst := nil;
  Self.FLast := nil;
  // while Step <> nil do
  // begin
  // Step := Self.GetNext(Step);
  // FreeAndNil(FFirst);
  // FFirst := Step;
  // end;
  inherited;
end;

function TVisioStepContainer.GetFirst: TVisioStep<TVisioStepContainer>;
begin
  Result := FFirst;
end;

function TVisioStepContainer.GetLast: TVisioStep<TVisioStepContainer>;
begin
  Result := FLast;
end;

function TVisioStepContainer.GetNext(Step: TVisioStep<TVisioStepContainer>)
  : TVisioStep<TVisioStepContainer>;
begin
  Result := nil;
  if Step <> nil then
  begin
    Result := Step.Next;
  end;
end;

function TVisioStepContainer.GetPrev(Step: TVisioStep<TVisioStepContainer>)
  : TVisioStep<TVisioStepContainer>;
begin
  Result := nil;
  if Step <> nil then
  begin
    Result := Step.Prev;
  end;
end;

{TVisioStep}

destructor TVisioStep<T>.Destroy;
begin
try
    FreeAndNil(Self.FNext);
except
end;
//  FreeAndNil(Self.FPrevLeft);
//  FreeAndNil(Self.FNextLeft);
  FreeAndNil(Self.FPrevRight);
  FreeAndNil(Self.FNextRight);
  inherited;
end;


end.
