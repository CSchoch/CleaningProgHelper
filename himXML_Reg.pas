Unit himXML_Reg;

Interface

  (************************************************** )
  (                                                   )
  (  Copyright (c) 1997-2009 FNS Enterprize's™        )
  (                2003-2009 himitsu @ Delphi-PRAXiS  )
  (                                                   )
  (  Description   registry tool for himXML           )
  (                use similar to TRegistry           )
  (  Filename      himXML_Reg.pas                     )
  (  Version       v0.97                              )
  (  Date          16.09.2009                         )
  (  Project       himXML [himix ML]                  )
  (  Info / Help   see "help" region in himXML.pas    )
  (  Support       delphipraxis.net/topic153934.html  )
  (                                                   )
  (  License       MPL v1.1 , GPL v3.0 or LGPL v3.0   )
  (                                                   )
  (  Donation      www.FNSE.de/Spenden                )
  (                                                   )
  (***************************************************)

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

    // ***** xml format for TXMLRegistry *****
    //
    // <?xml ... ?>
    // <registry>
    //   <key name={keyName}>
    //     <key ...>...</key>
    //     <value ...>...</value>
    //     ...
    //   </key>
    //   ...
    //   <value name={valueName} type="{rdUnknown|rdString|rdInteger|rdBinary}">{value}</value>
    //   ...
    // </registry>

  {$IF X}{$ENDREGION}{$IFEND}

  Uses Types, Windows, SysUtils, Classes,
    Registry, Math, {$IF not Declared(TDate)} Controls, {$IFEND}
    himXML_Lang, himXML;

  {$DEFINE CMarker_himXMLReg_Init}
  {$DEFINE CMarker_himXMLLang}
  {$DEFINE CMarker_himXML}
  {$INCLUDE himXMLCheck.inc}

  Type TXMLRegistry = Class
    Private
      _XML:     TXMLFile;
      _Current: TXMLNode;

      Procedure CheckKey  (Var   Name:  String);
      Procedure CheckValue(Const Name:  String);
      Function  GetCurrentPath: String;
    Public
      Constructor Create(Const FileName: String; AutoUpdateIfChanged: Boolean = True);
      Destructor  Destroy; Override;

      Function  GetKeyInfo     (Var   Value:   TRegKeyInfo): Boolean;
      Function  HasSubKeys:                    Boolean;
      Procedure GetKeyNames    (      Strings: TStrings);
      Procedure GetValueNames  (      Strings: TStrings);

      Function  CreateKey      (      Key:  String): Boolean;
      Function  KeyExists      (      Key:  String): Boolean;
      Function  OpenKey        (      Key:  String; CanCreate: Boolean): Boolean;
      Procedure CloseKey;
      Function  DeleteKey      (      Key:  String): Boolean;

      Function  ValueExists    (Const Name: String):       Boolean;
      Function  GetDataInfo    (Const Name: String; Var Value: TRegDataInfo): Boolean;
      Function  GetDataSize    (Const Name: String):       Integer;
      Function  GetDataType    (Const Name: String):       TRegDataType;
      Function  ReadString     (Const Name: String):       String;
      Procedure WriteString    (Const Name,         Value: String);
      Function  ReadInteger    (Const Name: String):       Integer;
      Procedure WriteInteger   (Const Name: String; Value: Integer);
      Function  ReadFloat      (Const Name: String):       Double;
      Procedure WriteFloat     (Const Name: String; Value: Double);
      Function  ReadCurrency   (Const Name: String):       Currency;
      Procedure WriteCurrency  (Const Name: String; Value: Currency);
      Function  ReadBool       (Const Name: String):       Boolean;
      Procedure WriteBool      (Const Name: String; Value: Boolean);
      Function  ReadDateTime   (Const Name: String):       TDateTime;
      Procedure WriteDateTime  (Const Name: String; Value: TDateTime);
      Function  ReadDate       (Const Name: String):       TDate;
      Procedure WriteDate      (Const Name: String; Value: TDate);
      Function  ReadTime       (Const Name: String):       TTime;
      Procedure WriteTime      (Const Name: String; Value: TTime);
      Function  ReadBinaryData (Const Name: String; Var Buffer; BufSize: Integer): Integer;
      Procedure WriteBinaryData(Const Name: string; Var Buffer; BufSize: Integer);
      Function  DeleteValue    (Const Name: String):       Boolean;
      Procedure RenameValue    (Const OldName, NewName: String);

      Property  CurrentPath: String read GetCurrentPath;
    End;

Implementation
  Procedure TXMLRegistry.CheckKey(Var Name: String);
    Var i: Integer;

    Begin
      For i := Length(Name) downto 0 do
        If (i = 0) or (Name[i] = _XML.PathDelimiter) Then
          Insert('key>name=', Name, i + 1)
        Else If (Name[i] = '>') or (Name[i] = '[') Then
          Raise EXMLException.Create(Self.ClassType, 'CheckName', @SInvalidName, [Name]);
    End;

  Procedure TXMLRegistry.CheckValue(Const Name: String);
    Var i: Integer;

    Begin
      For i := Length(Name) downto 1 do
        If (Name[i] = _XML.PathDelimiter) or (Name[i] = '>') or (Name[i] = '[') Then
          Raise EXMLException.Create(Self.ClassType, 'CheckName', @SInvalidName, [Name]);
    End;

  Function TXMLRegistry.GetCurrentPath: String;
    Var Node: TXMLNode;

    Begin
      Result := '';
      Node   := _Current;
      While Assigned(Node) do Begin
        If Result <> '' Then Result := PathDelim + Result;
        Result := Node.Attributes['name'] + Result;
        Node := Node.Parent;
      End;
    End;

  Constructor TXMLRegistry.Create(Const FileName: String; AutoUpdateIfChanged: Boolean = True);
    Begin
      Inherited Create;
      _XML         := TXMLFile.Create(Self);
      _XML.Options := _XML.Options + [xoHideInstructionNodes, xoHideTypedefNodes,
                        xoHideCDataNodes, xoHideCommentNodes, xoHideUnknownNodes]
                        - [xoCaseSensitive];
      _Current     := nil;
      If (FileName <> '') and FileExists(FileName) Then Begin
        _XML.LoadFromFile(FileName);
        If not Assigned(_XML.RootNode) Then _XML.Nodes.Add('registry');
      End Else _XML.Nodes[0].Name := 'registry';
    End;

  Destructor TXMLRegistry.Destroy;
    Begin
      If _XML.Changed Then _XML.SaveToFile(_XML.FileName);
      _XML.Free;
      Inherited;
    End;

  Function TXMLRegistry.GetKeyInfo(Var Value: TRegKeyInfo): Boolean;
    Var i:  Integer;
      List: TXMLNodeArray;

    Begin
      Result := Assigned(_Current);
      If Result Then Begin
        List                  := _Current.NodeList['key'];
        Value.NumSubKeys      := Length(List);
        Value.MaxSubKeyLen    := 0;
        For i := Length(List) - 1 downto 0 do
          Value.MaxSubKeyLen  := Max(Length(List[i].Attributes['name']), Value.MaxSubKeyLen);
        List                  := _Current.NodeList['value'];
        Value.NumValues       := Length(List);
        Value.MaxValueLen     := 0;
        Value.MaxDataLen      := 0;
        For i := Length(List) - 1 downto 0 do Begin
          Value.MaxValueLen   := Max(Length(List[i].Attributes['name']), Value.MaxValueLen);
          Value.MaxDataLen    := Max(Length(List[i].Text_S) * 2, Value.MaxDataLen);
        End;
        Int64(Value.FileTime) := 0;
      End;
    End;

  Function TXMLRegistry.HasSubKeys: Boolean;
    Begin
      Result := Assigned(_Current) and Assigned(_Current.Nodes['key']);
    End;

  Procedure TXMLRegistry.GetKeyNames(Strings: TStrings);
    Var i:  Integer;
      List: TXMLNodeArray;

    Begin
      Strings.BeginUpdate;
      Try
        Strings.Clear;
        If Assigned(_Current) Then Begin
          List := _Current.NodeList['key'];
          For i := 0 to Length(List) - 1 do
            Strings.Add(List[i].Attributes['name']);
        End;
      Finally
        Strings.EndUpdate;
      End;
    End;

  Procedure TXMLRegistry.GetValueNames(Strings: TStrings);
    Var i:  Integer;
      List: TXMLNodeArray;

    Begin
      Strings.BeginUpdate;
      Try
        Strings.Clear;
        If Assigned(_Current) Then Begin
          List := _Current.NodeList['value'];
          For i := 0 to Length(List) - 1 do
            Strings.Add(List[i].Attributes['name']);
        End;
      Finally
        Strings.EndUpdate;
      End;
    End;

  Function TXMLRegistry.CreateKey(Key: String): Boolean;
    Begin
      CheckKey(Key);
      Result := Assigned(_Current) and not _Current.Nodes.Exists(Key);
      If Result Then
        Try
          _Current.Nodes.Add(Key);
        Except
          Result := False;
        End;
    End;

  Function TXMLRegistry.KeyExists(Key: String): Boolean;
    Begin
      CheckKey(Key);
      Result := Assigned(_Current) and _Current.Nodes.Exists(Key);
    End;

  Function TXMLRegistry.OpenKey(Key: String; CanCreate: Boolean): Boolean;
    Var Node: TXMLNode;

    Begin
      CheckKey(Key);
      Result := Assigned(_Current);
      If Result Then Begin
        If _Current.Nodes.Exists(Key) Then Begin
          If CanCreate Then Begin
            Try
              Node := _Current.Nodes.Add(Key);
              CloseKey;
              _Current := Node;
            Except
              Result := False;
            End;
          End Else Result := False;
        End Else Begin
          Node := _Current.Nodes[Key];
          CloseKey;
          _Current := Node;
        End;
      End;
    End;

  Procedure TXMLRegistry.CloseKey;
    Begin
      _Current := nil;
      If _XML.Changed Then _XML.SaveToFile(_XML.FileName);
    End;

  Function TXMLRegistry.DeleteKey(Key: String): Boolean;
    Var Node: TXMLNode;

    Begin
      CheckKey(Key);
      Result := Assigned(_Current);
      If Result Then
        If _Current.Nodes.Exists(Key) Then Begin
          Node := _Current.Nodes[Key];
          Result := not Node.Nodes.Exists('key');
          If Result Then _Current.Nodes.Delete(Node);
        End;
    End;

  Function TXMLRegistry.ValueExists(Const Name: String): Boolean;
    Begin
      CheckValue(Name);
      Result := Assigned(_Current) and _Current.Nodes.Exists('value>name=' + Name);
    End;

  Function TXMLRegistry.GetDataInfo(Const Name: String; Var Value: TRegDataInfo): Boolean;
    Var Node: TXMLNode;

    Begin
      Result := ValueExists(Name);
      If Result Then Begin
        Node := _Current.Nodes['value>name=' + Name];
        Value.RegData := Node.Attributes['type'];
        Case Value.RegData of
          rdUnknown: Value.DataSize := Length(Node.Text_S) * 2;
          rdString:  Value.DataSize := (Length(Node.Text_S) + 1) * 2;
          rdInteger: Value.DataSize := 4;
          rdBinary:  Value.DataSize := Node.GetBinaryLen;
        End;
      End;
    End;

  Function TXMLRegistry.GetDataSize(Const Name: String): Integer;
    Var Info: TRegDataInfo;

    Begin
      If GetDataInfo(Name, Info) Then Result := Info.DataSize Else Result := 0;
    End;

  Function TXMLRegistry.GetDataType(Const Name: String): TRegDataType;
    Var Info: TRegDataInfo;

    Begin
      If GetDataInfo(Name, Info) Then Result := Info.RegData Else Result := rdUnknown;
    End;

  Function TXMLRegistry.ReadString(Const Name: String): String;
    Begin
      If ValueExists(Name) Then Result := ''
      Else Result := _Current.Nodes['value>name=' + Name].Text_S;
    End;

  Procedure TXMLRegistry.WriteString(Const Name, Value: String);
    Begin
      CheckValue(Name);
      If Assigned(_Current) Then
        With _Current.Nodes['value>name=' + Name] do Begin
          Attribute['type'] := rdString;
          Text_S := Value;
        End;
    End;

  Function TXMLRegistry.ReadInteger(Const Name: String): Integer;
    Begin
      If ValueExists(Name) Then Result := 0
      Else Result := _Current.Nodes['value>name=' + Name].Text;
    End;

  Procedure TXMLRegistry.WriteInteger(Const Name: String; Value: Integer);
    Begin
      CheckValue(Name);
      If Assigned(_Current) Then
        With _Current.Nodes['value>name=' + Name] do Begin
          Attribute['type'] := rdInteger;
          Text := Value;
        End;
    End;

  Function TXMLRegistry.ReadFloat(Const Name: String): Double;
    Begin
      If ValueExists(Name) Then Result := 0
      Else Result := _Current.Nodes['value>name=' + Name].Text;
    End;

  Procedure TXMLRegistry.WriteFloat(Const Name: String; Value: Double);
    Begin
      CheckValue(Name);
      If Assigned(_Current) Then
        With _Current.Nodes['value>name=' + Name] do Begin
          Attribute['type'] := rdUnknown;
          Text := Value;
        End;
    End;

  Function TXMLRegistry.ReadCurrency(Const Name: String): Currency;
    Begin
      If ValueExists(Name) Then Result := 0
      Else Result := _Current.Nodes['value>name=' + Name].Text;
    End;

  Procedure TXMLRegistry.WriteCurrency(Const Name: String; Value: Currency);
    Begin
      CheckValue(Name);
      If Assigned(_Current) Then
        With _Current.Nodes['value>name=' + Name] do Begin
          Attribute['type'] := rdUnknown;
          Text := Value;
        End;
    End;

  Function TXMLRegistry.ReadBool(Const Name: String): Boolean;
    Begin
      If ValueExists(Name) Then Result := False
      Else Result := _Current.Nodes['value>name=' + Name].Text;
    End;

  Procedure TXMLRegistry.WriteBool(Const Name: String; Value: Boolean);
    Begin
      CheckValue(Name);
      If Assigned(_Current) Then
        With _Current.Nodes['value>name=' + Name] do Begin
          Attribute['type'] := rdUnknown;
          Text := Value;
        End;
    End;

  Function TXMLRegistry.ReadDateTime(Const Name: String): TDateTime;
    Begin
      If ValueExists(Name) Then Result := 0
      Else Result := _Current.Nodes['value>name=' + Name].Text;
    End;

  Procedure TXMLRegistry.WriteDateTime(Const Name: String; Value: TDateTime);
    Begin
      CheckValue(Name);
      If Assigned(_Current) Then
        With _Current.Nodes['value>name=' + Name] do Begin
          Attribute['type'] := rdUnknown;
          Text := Value;
        End;
    End;

  Function TXMLRegistry.ReadDate(Const Name: String): TDate;
    Begin
      Result := ReadDateTime(Name);
    End;

  Procedure TXMLRegistry.WriteDate(Const Name: String; Value: TDate);
    Begin
      WriteDateTime(Name, Value);
    End;

  Function TXMLRegistry.ReadTime(Const Name: String): TTime;
    Begin
      Result := ReadDateTime(Name);
    End;

  Procedure TXMLRegistry.WriteTime(Const Name: String; Value: TTime);
    Begin
      WriteDateTime(Name, Value);
    End;

  Function TXMLRegistry.ReadBinaryData(Const Name: String; Var Buffer; BufSize: Integer): Integer;
    Begin
      If ValueExists(Name) Then Result := 0
      Else Result := _Current.Nodes['value>name=' + Name].GetBinaryData(@Buffer, BufSize);
    End;

  Procedure TXMLRegistry.WriteBinaryData(Const Name: string; Var Buffer; BufSize: Integer);
    Begin
      CheckValue(Name);
      If Assigned(_Current) Then
        With _Current.Nodes['value>name=' + Name] do Begin
          Attribute['type'] := rdBinary;
          SetBinaryData(@Buffer, BufSize);
        End;
    End;

  Function TXMLRegistry.DeleteValue(Const Name: String): Boolean;
    Begin
      CheckValue(Name);
      Result := Assigned(_Current);
      If Result and _Current.Nodes.Exists('value>name=' + Name) Then
        _Current.Nodes.Delete('value>name=' + Name);
    End;

  Procedure TXMLRegistry.RenameValue(Const OldName, NewName: String);
    Begin
      If ValueExists(OldName) and not ValueExists(NewName) Then
        _Current.Nodes['value>name=' + OldName].Attributes['name'] := NewName;
    End;

End.

