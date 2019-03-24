unit fAbout;

interface

{$INCLUDE Compilerswitches.inc}

uses
  Forms,
  StdCtrls,
  Credits,
  Controls,
  Classes,
  csUtils;

type
  TAboutBox = class(TForm)
    btOk : TButton;
    Creatingsto : TScrollingCredits;
    procedure FormShow(Sender : TObject);
  private
    {Private declarations}
  public
    {Public declarations}
  end;

var
  AboutBox : TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.FormShow(Sender : TObject);
begin
  Creatingsto.Credits.Clear;
  Creatingsto.Credits.Add('');
  Creatingsto.Credits.Add('');
  Creatingsto.Credits.Add('');
  Creatingsto.Credits.Add('');
  Creatingsto.Credits.Add('&b&uReinigungseditor ' + GetVersion);
  Creatingsto.Credits.Add('');
  Creatingsto.Credits.Add('');
  Creatingsto.Credits.Add('Copyright © 2010 - 2019 C.Schoch');
  Creatingsto.Visible := true;
  // Creatingsto.Animate := true;
end;

end.
