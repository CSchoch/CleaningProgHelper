Unit himXML_OptOSF;

Interface

  (******************************************************************** )
  (                                                                     )
  (  Copyright (c) 1997-2009 FNS Enterprize's™                          )
  (                2003-2009 himitsu @ Delphi-PRAXiS                    )
  (                                                                     )
  (  Description   project options tool for himXML                      )
  (                sample of selection dialog for the project options   )
  (  Filename      himXML_OptOSF.pas                                    )
  (  Version       v0.97                                                )
  (  Date          17.09.2009                                           )
  (  Project       himXML [himix ML]                                    )
  (  Info / Help   see "help" region in himXML.pas                      )
  (  Support       www.delphipraxis.net/topic153934.html                )
  (                                                                     )
  (  License       MPL v1.1 , GPL v3.0 or LGPL v3.0                     )
  (                                                                     )
  (  Donation      www.FNSE.de/Spenden                                  )
  (                                                                     )
  (*********************************************************************)

  // interface regions:       license
  // implementation regions:  -

  {$UNDEF X}{$IF X}{$REGION 'license'}{$IFEND}
  //
  // Mozilla Public License (MPL) v1.1
  // GNU General Public License (GPL) v3.0
  // GNU Lesser General Public License (LGPL) v3.0
  //
  //
  //
  // The contents of this file are subject to the Mozilla Public License
  // Version 1.1 (the "License"); you may not use this file except in
  // compliance with the License.
  // You may obtain a copy of the License at http://www.mozilla.org/MPL .
  //
  // Software distributed under the License is distributed on an "AS IS"
  // basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  // License for the specific language governing rights and limitations
  // under the License.
  //
  // The Original Code is "himix ML".
  //
  // The Initial Developer of the Original Code is "himitsu".
  // Portions created by Initial Developer are Copyright (C) 2009.
  // All Rights Reserved.
  //
  // Contributor(s): -
  //
  // Alternatively, the contents of this file may be used under the terms
  // of the GNU General Public License Version 3.0 or later (the "GPL"), or the
  // GNU Lesser General Public License Version 3.0 or later (the "LGPL"),
  // in which case the provisions of GPL or the LGPL are applicable instead of
  // those above. If you wish to allow use of your version of this file only
  // under the terms of the GPL or the LGPL and not to allow others to use
  // your version of this file under the MPL, indicate your decision by
  // deleting the provisions above and replace them with the notice and
  // other provisions required by the GPL or the LGPL. If you do not delete
  // the provisions above, a recipient may use your version of this file
  // under either the MPL, the GPL or the LGPL.
  //
  //
  //
  // HTML:                               PlainText:
  // www.mozilla.org/MPL/MPL-1.1.html    www.mozilla.org/MPL/MPL-1.1.txt
  // www.gnu.org/licenses/gpl-3.0.html   www.gnu.org/licenses/gpl-3.0.txt
  // www.gnu.org/licenses/lgpl-3.0.html  www.gnu.org/licenses/lgpl-3.0.txt
  //
  {$IF X}{$ENDREGION}{$IFEND}

  Uses Windows, SysUtils, Classes, Graphics, Messages, Controls, Forms,
    StdCtrls, ExtCtrls, Buttons, himXML_Lang, himXML_Opt;

  {$DEFINE CMarker_himXMLOptOSF_Init}
  {$INCLUDE himXMLCheck.inc}

  Type TOptionsSelectForm = Class(TForm)
      Panel1: TPanel;
        GroupBox1: TGroupBox;
          Label1: TLabel;
          ScrollBox1: TScrollBox;
        Label2: TLabel;
        Label3: TLabel;
        Button1: TButton;
      Procedure FormCreate(Sender: TObject);
      Procedure ButtonMouseEnter(Sender: TObject);
      Procedure ButtonMouseLeave(Sender: TObject);
      Procedure ButtonClick(Sender: TObject);
      Procedure ButtonDblClick(Sender: TObject);
      Procedure ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
      Procedure ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
      Procedure Button1Click(Sender: TObject);
    Private
      Procedure CMDialogKey(Var Msg: TCMDialogKey); Message CM_DIALOGKEY;
      Function  GetSelIndex: Integer;
    Public
      Procedure SetCaptions(Caption: String; Title: String = ''; Button: String = '');
      Procedure AddDir(Location: TXMLPOLocation; Const Name, Dir, Hint: String; Selected: Boolean);
      Function  GetLocationOfSelected: TXMLPOLocation;
    End;

Implementation
  {$R *.dfm}

  Procedure TOptionsSelectForm.FormCreate(Sender: TObject);
    Begin
      SetCaptions('');
    End;

  Procedure TOptionsSelectForm.ButtonMouseEnter(Sender: TObject);
    Begin
      Label2.Caption := GetShortHint(TSpeedButton(Sender).Hint);
      Label2.Hint    := Label2.Caption;
      Label3.Caption := GetLongHint(TSpeedButton(Sender).Hint);
      Label3.Hint    := Label3.Caption;
    End;

  Procedure TOptionsSelectForm.ButtonMouseLeave(Sender: TObject);
    Begin
      ButtonClick(nil);
    End;

  Procedure TOptionsSelectForm.ButtonClick(Sender: TObject);
    Var i: Integer;

    Begin
      i := GetSelIndex;
      If i >= 0 Then Begin
        Label2.Caption := GetShortHint(TSpeedButton(ScrollBox1.Controls[i]).Hint);
        Label2.Hint    := Label2.Caption;
        Label3.Caption := GetLongHint(TSpeedButton(ScrollBox1.Controls[i]).Hint);
        Label3.Hint    := Label3.Caption;
      End Else Begin
        Label2.Caption := '-';
        Label2.Hint    := '-';
        Label3.Caption := '-';
        Label3.Hint    := '-';
      End;
    End;

  Procedure TOptionsSelectForm.ButtonDblClick(Sender: TObject);
    Begin
      ButtonClick(nil);
      Button1Click(nil);
    End;

  Procedure TOptionsSelectForm.ScrollBox1MouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);

    Var i: Integer;

    Begin
      i := (GetSelIndex + 1) mod ScrollBox1.ControlCount;
      TSpeedButton(ScrollBox1.Controls[i]).Down := True;
      ButtonClick(nil);
      ScrollBox1.ScrollInView(ScrollBox1.Controls[i]);
      Handled := True;
    End;

  Procedure TOptionsSelectForm.ScrollBox1MouseWheelUp(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);

    Var i: Integer;

    Begin
      i := (GetSelIndex - 1 + ScrollBox1.ControlCount) mod ScrollBox1.ControlCount;
      TSpeedButton(ScrollBox1.Controls[i]).Down := True;
      ButtonClick(nil);
      ScrollBox1.ScrollInView(ScrollBox1.Controls[i]);
      Handled := True;
    End;

  Procedure TOptionsSelectForm.Button1Click(Sender: TObject);
    Var i: Integer;

    Begin
      i := GetSelIndex;
      If i >= 0 Then Tag := TSpeedButton(ScrollBox1.Controls[i]).Tag;
      ModalResult := mrOk;
    End;

  Procedure TOptionsSelectForm.CMDialogKey(Var Msg: TCMDialogKey);
    Var B: Boolean;

    Begin
      Case Msg.CharCode of
        VK_DOWN, VK_RIGHT: ScrollBox1MouseWheelDown(nil, [], Point(0, 0), B);
        VK_UP,   VK_LEFT:  ScrollBox1MouseWheelUp  (nil, [], Point(0, 0), B);
        Else Inherited;
      End;
    End;

  Function TOptionsSelectForm.GetSelIndex: Integer;
    Var i: Integer;

    Begin
      Result := -1;
      For i := ScrollBox1.ControlCount - 1 downto 0 do
        If TSpeedButton(ScrollBox1.Controls[i]).Down Then Begin
          Result := i;
          TSpeedButton(ScrollBox1.Controls[i]).Font.Style := [fsBold];
        End Else TSpeedButton(ScrollBox1.Controls[i]).Font.Style := [];
    End;

  Procedure TOptionsSelectForm.SetCaptions(Caption: String; Title: String = ''; Button: String = '');
    Begin
      If Trim(Title) = '' Then
        If Owner is TForm Then                      Title := TForm(Owner).Caption
        Else If Assigned(Application.MainForm) Then Title := Application.MainForm.Caption
        Else                                        Title := Application.Title;
      If Trim(Caption) = '' Then Caption := '';
      If Trim(Button)  = '' Then Button  := '';
      Self.Caption    := Title;
      Label1.Caption  := Caption;
      Button1.Caption := Button;
    End;

  Procedure TOptionsSelectForm.AddDir(Location: TXMLPOLocation; Const Name, Dir, Hint: String; Selected: Boolean);
    Var C: TSpeedButton;

    Begin
      C := TSpeedButton.Create(Self);
      C.Parent       := ScrollBox1;
      C.Align        := alTop;
      C.Height       := 36;
      C.GroupIndex   := 1;
      C.Caption      := Name;
      C.Hint         := Dir + '|' + Hint;
      C.Tag          := Ord(Location);
      C.Down         := Selected or (ScrollBox1.ControlCount = 1);
      C.OnMouseEnter := ButtonMouseEnter;
      C.OnMouseLeave := ButtonMouseLeave;
      C.OnClick      := ButtonClick;
      C.OnDblClick   := ButtonDblClick;
      ButtonClick(nil);
      If C.Down Then Self.Tag := Tag;
    End;

  Function TOptionsSelectForm.GetLocationOfSelected: TXMLPOLocation;
    Begin
      Result := TXMLPOLocation(Tag);
    End;

End.

