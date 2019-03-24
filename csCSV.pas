unit csCSV;

(******************************************************************************
 * CSV Reader Klasse                                                          *
 * Liest eine CSV-Datei ein und ermöglicht Zugriff auf die einzelnen Elemente *
 * jeder Zeile.                                                               *
 * Eine CSV ('Comma Separated Values' oder 'Character Separated Values' ist   *
 * ein Format, um Tabellen in einer Text-Datei zu speichern.                  *
 * Dabei werden die einzelnen Elemente einer Tabellenzeile durch ein frei     *
 * wählbares Zeichen getrennt. In Deutschland ist dies üblicherweise das      *
 * Semikolon, im englischsprachigen Raum das Komma (daher der Name).          *
 * Strings werden druch Quotes '"' eingeschlossen, ein Quote innerhalb eines  *
 * Strings wird verdoppelt.                                                   *
 * Beispiel (Trennzeichen';'):                                                *
 * "Text";123;"Text mit ""Quotes"" und Semikolon;";;Auch ein Text;345.657     *
 *                                                                            *
 * Der Code ist so trivial, das ein Copyright nicht lohnt.                    *
 *                                                                            *
 * Verwendung                                                                 *
 *   -- Bereitstellen eines Streams, z.B. TFileStream                         *
 *                                                                            *
 * csvReader := TCSVReader.Create (CSVDAtaStream, ';');                       *
 * While not csvReader.Eof Do Begin                                           *
 *   For i:=0 to csvReader.ColumnCount - 1 Do                                 *
 *     Memo.Lines.Add (csvReader.Columns[i]);                                 *
 *   csvReader.Next;                                                          *
 * End;                                                                       *
 ******************************************************************************)
interface

uses
  Classes,
  SysUtils;

type
  TStringPos = record
    spFirst: PChar;
    spLen: Integer;
  end;

  TCSVReader = class
  private
    fBuffer, fPos, fEnd: PChar;
    fSize: Integer;
    fStream: TStream;
    fQuote, fDelimiter: Char;
    fAtEOF, fIsEOF: Boolean;
    fColumns: array of TStringPos;
    fColumnCount: Integer;
    fEOLChar: Char;
    fEOLLength: Integer;
    function GetColumnByIndex(Index: Integer): string;
    procedure SetEOLChar(const Value: Char);
    procedure Initialize;
  public
    // Wenn kein Delimiter angegeben wird, wird das Listentrennzeichen aus den
    // internationalen Einstellungen von Windows verwendet.
    constructor Create(aStream: TStream; aDelimiter: Char = #0);
    destructor Destroy; override;
    // Bewegt den internen Positionszeiger auf die erste Zeile der Datei
    procedure First;
    // Bewegt den internen Positionszeiger auf die nächste Zeile der Datei
    procedure Next;
    // Liefert TRUE, wenn keine Daten mehr abgerufen werden können.
    function Eof: Boolean;
    // Liefert oder setzt das Trennzeichen
    property Delimiter: Char read fDelimiter write fDelimiter;
    // Liefert oder setzt das Quote-Zeichen
    property Quote: Char read fQuote write fQuote;
    // Liefert oder setzt das EOL-Zeichen (Windows #13, UNIX #10)
    property EOLChar: Char read fEOLChar write SetEOLChar;
    // Liefert oder setzt die Länge der EOL-Zeichen (Windows : 2 [CR+LF], UNIX: 1 [LF])
    property EOLLength: Integer read fEOLLength write fEOLLength;
    // Liefert die Anzahl der Elemente der aktuellen Zeile
    property ColumnCount: Integer read fColumnCount;
    // Liefert die einzelnen Elemente der aktuellen Zeile
    property Columns[Index: Integer]: string read GetColumnByIndex; default;
  end;

implementation

{TCSVReader}

constructor TCSVReader.Create(aStream: TStream; aDelimiter: Char);
var
  AnsiBuffer: PAnsiChar;
  i: Integer;
begin
  fStream := aStream;
  fSize := fStream.Size - fStream.Position + 2;
  AnsiBuffer := GetMemory(fSize);
  fBuffer := GetMemory(fSize * 2);
  fPos := fBuffer;
  aStream.Read(AnsiBuffer^, fSize);
  for i := 0 to fSize do
  begin
    fBuffer[i] := Char(AnsiBuffer[i]);
  end;
  FreeMemory(AnsiBuffer);
  fEOLChar := #13;
  fEOLLength := 2;
  fBuffer[fSize - 2] := fEOLChar;
  fBuffer[fSize - 1] := #0;
  fEnd := fBuffer + fSize - 1;
  if aDelimiter = #0 then
    fDelimiter := FormatSettings.ListSeparator
  else
    fDelimiter := aDelimiter;

  fQuote := '"';
  setLength(fColumns, 100);
  Initialize;
end;

destructor TCSVReader.Destroy;
begin
  FreeMemory(fBuffer);
  inherited;
end;

function TCSVReader.Eof: Boolean;
begin
  Result := fIsEOF;
end;

procedure TCSVReader.First;
begin
  Initialize;
  Next;
end;

function TCSVReader.GetColumnByIndex(Index: Integer): string;
var
  p: PChar;
  i, l: Integer;

begin
  with fColumns[Index] do
    if spLen = 0 then
      Result := ''
    else if spFirst^ = fQuote then
    begin
      setLength(Result, spLen - 2);
      p := spFirst + 1;
      l := spLen - 2;
      for i := 1 to spLen - 2 do
      begin
        Result[i] := p^;
        if (p^ = fQuote) and (p[1] = fQuote) then
        begin
          dec(l);
          inc(p, 2)
        end
        else
          inc(p);
      end;
      setLength(Result, l);
    end
    else
      SetString(Result, spFirst, spLen);
end;

procedure TCSVReader.Initialize;
begin
  fPos := fBuffer;
  fIsEOF := False;
  fAtEOF := False;
  fColumnCount := 0;
end;

procedure TCSVReader.Next;
var
  p: PChar;
  pPrev: PChar;

  procedure _GetString;
  begin
    repeat
      inc(p);
      if p^ = fQuote then
        if p[1] = fQuote then
          inc(p)
        else
          break;
    until False;
    inc(p);
  end;

begin
  pPrev := fPos;
  p := fPos;
  fColumnCount := 0;
  if fAtEOF then
    if Eof then
      raise exception.Create('Try to read past eof')
    else
    begin
      fIsEOF := True;
      Exit;
    end;
  if p^ = fQuote then
    _GetString;
  while p^ <> fEOLChar do
  begin
    if p^ = fDelimiter then
    begin
      if fColumnCount = Length(fColumns) then
        setLength(fColumns, 2 * Length(fColumns));
      fColumns[fColumnCount].spFirst := pPrev;
      fColumns[fColumnCount].spLen := p - pPrev;
      inc(fColumnCount);
      inc(p);
      pPrev := p;
      if p^ = fQuote then
        _GetString;
    end
    else
      inc(p);
  end;
  if p <> fPos then
  begin
    if fColumnCount = Length(fColumns) then
      setLength(fColumns, Length(fColumns) + 1);
    fColumns[fColumnCount].spFirst := pPrev;
    fColumns[fColumnCount].spLen := p - pPrev;
    inc(fColumnCount);
  end;
  fPos := p;
  if (fPos[1] = #0) then
    fAtEOF := True
  else
    inc(fPos, fEOLLength);
end;

procedure TCSVReader.SetEOLChar(const Value: Char);
begin
  if fEOLChar <> Value then
  begin
    fEOLChar := Value;
    fBuffer[fSize - 2] := fEOLChar;
  end;
end;

end.
