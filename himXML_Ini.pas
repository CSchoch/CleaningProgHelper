Unit himXML_Ini;

Interface

  (*************************************************************** )
  (                                                                )
  (  Copyright (c) 1997-2009 FNS Enterprize's™                     )
  (                2003-2009 himitsu @ Delphi-PRAXiS               )
  (                                                                )
  (  Description   registry tool for himXML                        )
  (                used as TIniFile but data saves in an xml file  )
  (  Filename      himXML_Ini.pas                                  )
  (  Version       v0.97                                           )
  (  Date          16.09.2009                                      )
  (  Project       himXML [himix ML]                               )
  (  Info / Help   see "help" region in himXML.pas                 )
  (  Support       www.delphipraxis.net/topic153934.html           )
  (                                                                )
  (  License       MPL v1.1 , GPL v3.0 or LGPL v3.0                )
  (                                                                )
  (  Donation      www.FNSE.de/Spenden                             )
  (                                                                )
  (****************************************************************)

  // interface regions:       license, info
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
  {$IF X}{$REGION 'info'}{$IFEND}

    // ***** xml format for TXMLIniFile *****
    //
    // <?xml ... ?>
    // <ini>
    //   <section name="{sectionName}">
    //     <ident name="{identName}">{value}</ident>
    //     ...
    //   </section>
    //   ...
    // </ini>

  {$IF X}{$ENDREGION}{$IFEND}

  Uses Types, Windows, SysUtils, Classes, IniFiles, himXML_Lang, himXML;

  {$DEFINE CMarker_himXMLIni_Init}
  {$INCLUDE himXMLCheck.inc}

  Type TXMLIniFile = Class(TCustomIniFile)
    Private
      _XML:        TXMLFile;
      _AutoUpdate: Boolean;
      Procedure CheckName     (Const Name:  String);
      Procedure ChangeCallback(Node: TXMLNode; CType: TXMLNodeChangeType);
    Public
      Constructor Create(Const FileName: String; AutoUpdateIfChanged: Boolean = True);
      Destructor  Destroy;                                                                      Override;

      Function  SectionExists    (Const Section: String):         Boolean;
      Procedure ReadSections     (                       Strings: TStrings); Overload;          Override;
      Procedure ReadSection      (Const Section: String; Strings: TStrings);                    Override;
      Procedure ReadSectionValues(Const Section: String; Strings: TStrings);                    Override;
      Procedure EraseSection     (Const Section: String);                                       Override;

      Function  ValueExists      (Const Section, Ident: String):         Boolean;               Override;
      Function  ReadString       (Const Section, Ident,         Default: String):    String;    Override;
      Procedure WriteString      (Const Section, Ident,         Value:   String);               Override;
      Function  ReadInteger      (Const Section, Ident: String; Default: LongInt):   LongInt;   Override;
      Procedure WriteInteger     (Const Section, Ident: String; Value:   LongInt);              Override;
      Function  ReadFloat        (Const Section, Ident: String; Default: Double):    Double;    Override;
      Procedure WriteFloat       (Const Section, Ident: String; Value:   Double);               Override;
      Function  ReadBool         (Const Section, Ident: String; Default: Boolean):   Boolean;   Override;
      Procedure WriteBool        (Const Section, Ident: String; Value:   Boolean);              Override;
      Function  ReadDateTime     (Const Section, Ident: String; Default: TDateTime): TDateTime; Override;
      Procedure WriteDateTime    (Const Section, Ident: String; Value:   TDateTime);            Override;
      Function  ReadDate         (Const Section, Ident: String; Default: TDateTime): TDateTime; Override;
      Procedure WriteDate        (Const Section, Ident: String; Value:   TDateTime);            Override;
      Function  ReadTime         (Const Section, Ident: String; Default: TDateTime): TDateTime; Override;
      Procedure WriteTime        (Const Section, Ident: String; Value:   TDateTime);            Override;
      Function  ReadBinaryStream (Const Section, Ident: String; Value:   TStream):   Integer;   Override;
      Procedure WriteBinaryStream(Const Section, Ident: String; Value:   TStream);              Override;
      Procedure DeleteKey        (Const Section, Ident: String);                                Override;

      Procedure UpdateFile;                                                                     Override;
      Property  XMLFile: TXMLFile Read _XML;
    End;

Implementation
  Procedure TXMLIniFile.CheckName(Const Name: String);
    Var i: Integer;

    Begin
      For i := Length(Name) downto 1 do
        If (Name[i] = _XML.PathDelimiter) or (Name[i] = '>') or (Name[i] = '[') Then
          Raise EXMLException.Create(Self.ClassType, 'CheckName', @SInvalidName, [Name]);
    End;

  Procedure TXMLIniFile.ChangeCallback(Node: TXMLNode; CType: TXMLNodeChangeType);
    Begin
      If _AutoUpdate Then _XML.SaveToFile(FileName);
    End;

  Constructor TXMLIniFile.Create(Const FileName: String; AutoUpdateIfChanged: Boolean = True);
    Begin
      Inherited Create(FileName);
      _XML              := TXMLFile.Create(Self);
      _XML.Options      := _XML.Options + [xoHideInstructionNodes, xoHideTypedefNodes,
                             xoHideCDataNodes, xoHideCommentNodes, xoHideUnknownNodes,
                             xoNodeAutoCreate] - [xoCaseSensitive];
      If (FileName <> '') and FileExists(FileName) Then Begin
        _XML.LoadFromFile(FileName);
        If not Assigned(_XML.RootNode) Then
          _XML.Nodes.Add('ini');
        If _XML.Nodes.FirstNodeNF.NodeType <> xtInstruction Then Begin
          _XML.Version    := '1.0';
          _XML.Encoding   := 'UTF-8';
          _XML.Standalone := 'yes';
        End;
      End Else _XML.Nodes[0].Name := 'ini';
      _XML.OnNodeChange := ChangeCallback;
      _AutoUpdate       := AutoUpdateIfChanged and (FileName <> '');
    End;

  Destructor TXMLIniFile.Destroy;
    Begin
      _AutoUpdate := False;
      _XML.Free;
      Inherited;
    End;

  Function TXMLIniFile.SectionExists(Const Section: String): Boolean;
    Begin
      CheckName(Section);
      Result := _XML.RootNode.Nodes.Exists('section>name=' + Section);
    End;

  Procedure TXMLIniFile.ReadSections(Strings: TStrings);
    Var Node: TXMLNode;

    Begin
      Strings.BeginUpdate;
      Try
        Strings.Clear;
        Node := _XML.RootNode.Nodes.FirstNode;
        While Assigned(Node) do Begin
          Strings.Add(Node.Attributes['name']);
          Node := Node.NextNode;
        End;
      Finally
        Strings.EndUpdate;
      End;
    End;

  Procedure TXMLIniFile.ReadSection(Const Section: String; Strings: TStrings);
    Var Node: TXMLNode;

    Begin
      CheckName(Section);
      Strings.BeginUpdate;
      Try
        Strings.Clear;
        If _XML.RootNode.Nodes.Exists('section>name=' + Section) Then Begin
          Node := _XML.RootNode.Nodes['section>name=' + Section].Nodes.FirstNode;
          While Assigned(Node) do Begin
            Strings.Add(Node.Attributes['name']);
            Node := Node.NextNode;
          End;
        End;
      Finally
        Strings.EndUpdate;
      End;
    End;

  Procedure TXMLIniFile.ReadSectionValues(Const Section: String; Strings: TStrings);
    Var Node: TXMLNode;

    Begin
      CheckName(Section);
      Strings.BeginUpdate;
      Try
        Strings.Clear;
        If _XML.RootNode.Nodes.Exists('section>name=' + Section) Then Begin
          Node := _XML.RootNode.Nodes['section>name=' + Section].Nodes.FirstNode;
          While Assigned(Node) do Begin
            Strings.Add(Node.Attributes['name'] + Strings.NameValueSeparator + Node.Text_S);
            Node := Node.NextNode;
          End;
        End;
      Finally
        Strings.EndUpdate;
      End;
    End;

  Procedure TXMLIniFile.EraseSection(Const Section: String);
    Begin
      CheckName(Section);
      _XML.RootNode.Nodes.Delete('section>name=' + Section);
    End;

  Function TXMLIniFile.ValueExists(Const Section, Ident: String): Boolean;
    Begin
      CheckName(Section);
      CheckName(Ident);
      Result := _XML.RootNode.Nodes.Exists('section>name=' + Section)
        and _XML.RootNode.Nodes['section>name=' + Section].Nodes.Exists('ident>name=' + Ident);
    End;

  Function TXMLIniFile.ReadString(Const Section, Ident, Default: String): String;
    Begin
      If not ValueExists(Section, Ident) Then Result := Default
      Else Result := _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text_S;
    End;

  Procedure TXMLIniFile.WriteString(Const Section, Ident, Value: String);
    Begin
      CheckName(Section);
      CheckName(Ident);
      _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text_S := Value;
    End;

  Function TXMLIniFile.ReadInteger(Const Section, Ident: String; Default: LongInt): LongInt;
    Begin
      If ValueExists(Section, Ident) Then
        Try
          Result := _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text;
        Except
          Result := Default;
        End
      Else Result := Default;
    End;

  Procedure TXMLIniFile.WriteInteger(Const Section, Ident: String; Value: LongInt);
    Begin
      CheckName(Section);
      CheckName(Ident);
      _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text := Value;
    End;

  Function TXMLIniFile.ReadFloat(Const Section, Ident: String; Default: Double): Double;
    Begin
      If ValueExists(Section, Ident) Then
        Try
          Result := _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text;
        Except
          Result := Default;
        End
      Else Result := Default;
    End;

  Procedure TXMLIniFile.WriteFloat(Const Section, Ident: String; Value: Double);
    Begin
      CheckName(Section);
      CheckName(Ident);
      _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text := Value;
    End;

  Function TXMLIniFile.ReadBool(Const Section, Ident: String; Default: Boolean): Boolean;
    Begin
      If ValueExists(Section, Ident) Then
        Try
          Result := _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text;
        Except
          Result := Default;
        End
      Else Result := Default;
    End;

  Procedure TXMLIniFile.WriteBool(Const Section, Ident: String; Value: Boolean);
    Begin
      CheckName(Section);
      CheckName(Ident);
      _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text := Value;
    End;

  Function TXMLIniFile.ReadDateTime(Const Section, Ident: String; Default: TDateTime): TDateTime;
    Begin
      If ValueExists(Section, Ident) Then
        Try
          Result := _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text;
        Except
          Result := Default;
        End
      Else Result := Default;
    End;

  Procedure TXMLIniFile.WriteDateTime(Const Section, Ident: String; Value: TDateTime);
    Begin
      CheckName(Section);
      CheckName(Ident);
      _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident].Text := Value;
    End;

  Function TXMLIniFile.ReadDate(Const Section, Ident: String; Default: TDateTime): TDateTime;
    Begin
      Result := ReadDateTime(Section, Ident, Default);
    End;

  Procedure TXMLIniFile.WriteDate(Const Section, Ident: String; Value: TDateTime);
    Begin
      WriteDateTime(Section, Ident, Value);
    End;

  Function TXMLIniFile.ReadTime(Const Section, Ident: String; Default: TDateTime): TDateTime;
    Begin
      Result := ReadDateTime(Section, Ident, Default);
    End;

  Procedure TXMLIniFile.WriteTime(Const Section, Ident: String; Value: TDateTime);
    Begin
      WriteDateTime(Section, Ident, Value);
    End;

  Function TXMLIniFile.ReadBinaryStream(Const Section, Ident: String; Value: TStream): Integer;
    Var Temp: Array of Byte;

    Begin
      If ValueExists(Section, Ident) Then Begin
        With _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident] do Begin
          {$IF Declared(himXML.TStream)}
            SetLength(Temp, GetBinaryLen);
            Result := GetBinaryData(Temp, Length(Temp));
            If Result > 0 Then Value.WriteBuffer(Temp[0], Result);
          {$ELSE}
            Result := GetBinaryData(Value);
          {$IFEND}
        End;
      End Else Result := 0;
    End;

  Procedure TXMLIniFile.WriteBinaryStream(Const Section, Ident: String; Value: TStream);
    Var Temp: Array of Byte;

    Begin
      CheckName(Section);
      CheckName(Ident);
      With _XML.RootNode.Nodes['section>name=' + Section].Nodes['ident>name=' + Ident] do Begin
        {$IF Declared(himXML.TStream)}
          SetLength(Temp, Value.Size - Value.Position);
          If Assigned(Temp) Then Value.WriteBuffer(Temp[0], Length(Temp));
          SetBinaryData(Temp, Length(Temp));
        {$ELSE}
          SetBinaryData(Value);
        {$IFEND}
      End;
    End;

  Procedure TXMLIniFile.DeleteKey(Const Section, Ident: String);
    Begin
      CheckName(Section);
      CheckName(Ident);
      _XML.RootNode.Nodes['section>name=' + Section].Nodes.Delete(Ident);
    End;

  Procedure TXMLIniFile.UpdateFile;
    Begin
      If FileName <> '' Then _XML.SaveToFile(FileName);
    End;

End.

