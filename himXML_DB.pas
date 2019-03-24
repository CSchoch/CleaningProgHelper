Unit himXML_DB;

Interface

  (************************************************** )
  (                                                   )
  (  Copyright (c) 1997-2009 FNS Enterprize's™        )
  (                2003-2009 himitsu @ Delphi-PRAXiS  )
  (                                                   )
  (  Description   database tool for himXML           )
  (                use the XML as simple database     )
  (  Filename      himXML_DB.pas                      )
  (  Version       v0.97                              )
  (  Date          20.09.2009                         )
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

    // ***** query syntax for TXMLDatabase *****
    //
    // CREATE TABLE table (field datatyp [, field datatyp [, ...]]
    //   [PRIMARY KEY (field [, field [, ...]])]
    //   [FOREIGN KEY (field) REFERENCES extTable(extField) [ON UPDATE {CASCADE|RESTRICT|NO ACTION|SET NULL|SET DEFAULT}]
    //      [ON DELETE {CASCADE|RESTRICT|NO ACTION|SET NULL|SET DEFAULT}]] )
    //
    // ALTER TABLE table
    //   [ ADD field datatyp [{FIRST|AFTER posField}] [, field datatyp [{FIRST|AFTER posField}] [, ...]] [PRIMARY KEY (field [, field [, ...]])] ]
    //   [ DROP field [, field [, ...]] ]
    //   [ CHANGE field newField [newDatatyp] [, field newField [newDatatyp] [, ...]] ]
    //   [ MODIFY field newDatatyp [, field newDatatyp [, ...]] ]
    //
    // TRUNCATE TABLE table
    //
    // DROP TABLE table
    //
    //
    // INSERT INTO table (field [, field [, ...]])
    //   [ VALUES (value [, value [, ...]]) [, (value [, value [, ...]]) [, ...]] ]
    //   [ SELECT ...{see SELECT}... ]
    //
    // UPDATE table SET field = value [, field = value [, ...]] WHERE condition
    //
    // SELECT [DISTINCT] {*|field [, field [, ...]]} FROM table
    //   [WHERE condition] [{INNER|OUTER|LEFT OUTER|RIGHT OUTER} JOIN]] [GROUP BY field] [HAVING condition]
    //   [ORDER BY field [{ASC|DESC}]] [SKIP count] [LIMIT count]
    //   [ {UNION [ALL]|INTERSECT|MINUS} [SELECT ...{see SELECT}...]
    //     [ORDER BY field [{ASC|DESC}]] [SKIP count] [LIMIT count] ]
    //
    // DELETE FROM table WHERE condition
    //
    //
    // table (SELECT): table as tableAlias
    //
    // field (SELECT): {[DISTINCT] COUNT|SUM|MIN|MAX|AVR|CONCAT|TRIM|LTRIM|RTRIM}(field)
    //                 field as fieldAlias
    //
    // condition:      {field|value} {<|<=|=|>=|>|<>|LIKE} {field|value}
    //                 {field|value} IN ({field|value}, {field|value} [, ...])
    //                 {field|value} BETWEEN {field|value} AND {field|value}
    //                 condition {AND|OR} condition

  {$IF X}{$ENDREGION}{$IFEND}

  Uses Types, Windows, SysUtils, Classes, himXML_Lang, himXML;

  {$DEFINE CMarker_himXMLDB_Init}
  {$INCLUDE himXMLCheck.inc}

  Type TXMLDBSelect = Record
    End;
    TXMLDBCondition = Record
    End;
    TXMLDBResult = Record
    Private
      Cols:  Array of Record
               SourceTable: String;
               SourceName:  String;
               Name:        String;
               FType:       String;
               MaxLength:   Integer;
               NotNull:     Boolean;
               PrimaryKey:  Boolean;
               UniqueKey:   Boolean;
             End;
      Rows:  Array of TStringDynArray;
      RowIndex, ColIndex: Integer;
    End;

    TXMLDatabase = Class
    Private
      _XML: TXMLFile;

      _OpenTime:     Cardinal;
      _Queries:      Cardinal;
      _AffectedRows: Integer;
      _Error:        String;

      Function  GetCaseSensitive:         Boolean;
      Procedure SetCaseSensitive  (Value: Boolean);
    Public
      Constructor Create          (Const FileName: String = '');
      Destructor  Destroy;        Override;

      Property  CaseSensitive:    Boolean Read GetCaseSensitive Write SetCaseSensitive;

      Function  Connect           (Const FileName:  String): Boolean;                         // mysql_connect
      Function  ListTables:                                  TStringDynArray;                 // mysql_list_tables
      Function  ListFields        (Const TableName: String): TStringDynArray;                 // mysql_list_fields
      Procedure Flush;                                                                        // -
      Procedure Close             (Save: Boolean = True);                                     // mysql_close

      Function  AffectedRows:     Integer;                                                    // mysql_affected_rows
      Function  Stat:             TAssocVariantArray;                                         // mysql_stat
      Function  Error:            String;                                                     // mysql_error

      Function  CreateTable       (Const TableName: String; Const Fields {[FieldName, Datatype], ...}:                            Array of String): Boolean; Overload;
      Function  CreateTable       (Const TableName: String; Const Fields {[FieldName, Datatype], ...}, PrimaryKey{FildName, ...}: Array of String): Boolean; Overload;
      Function  AddField          (Const TableName, FildName, Datatype: String; AtFirst: Boolean = False; Const AfterField: String = ''): Boolean;
      Function  ChangeField       (Const TableName, OldFildName, NewFildName: String; Const NewDatatype: String = ''): Boolean;
      Function  ModifyField       (Const TableName, NewDatatype: String): Boolean;
      Function  DropField         (Const TableName, FildName: String): Boolean;
      Function  SetPrimaryKey     (Const TableName: String; Const Fields: Array of String): Boolean;
      Function  TruncateTable     (Const TableName: String): Boolean;
      Function  DropTable         (Const TableName: String): Boolean;
      Function  InsertRecord      (Const TableName: String; Const Fields {[FieldName, Value], ...}: Array of String): Boolean; Overload;
      Function  InsertRecordDirect(Const TableName: String; Const Values {Value, ...}:              Array of String): Boolean;
      Function  InsertRecord      (Const TableName: String; Const Select: TXMLDBSelect; Const Condition: TXMLDBCondition): Boolean; Overload;
      Function  UpdateRecord      (Const TableName: String; Const Fields {[FieldName, Value], ...}: Array of String; Const Condition): Boolean;
      Function  UpdateRecordDirect(Const TableName: String; Const Values {Value, ...}:              Array of String; Const Condition): Boolean;
      Function  SelectRecord      (Const Select: TXMLDBSelect; Var DBResult: TXMLDBResult): Boolean;
      Function  DeleteRecord      (Const TableName: String; Const Condition: TXMLDBCondition): Boolean;

      Function  Query             (Const Query: String): TXMLDBResult;                               // mysql_query
      Function  NumFields         (Const DBResult: TXMLDBResult): Integer;                                  // mysql_num_fields
      Function  NumRows           (Const DBResult: TXMLDBResult): Integer;                                  // mysql_num_rows
      Procedure FreeResult        (Var   DBResult: TXMLDBResult);                                           // mysql_free_result

      Function  DataSeek          (Var   DBResult: TXMLDBResult; Offset: Integer): Boolean;                 // mysql_data_seek
      Function  FetchRow          (Var   DBResult: TXMLDBResult; Var A: TAssocVariantArray): Boolean;       // mysql_fetch_row

      Function  FetchField        (Var   DBResult: TXMLDBResult; Offset: Integer = -1): TAssocVariantArray; // mysql_fetch_field
      Function  FieldTable        (Var   DBResult: TXMLDBResult; Offset: Integer = -1): String;      // mysql_field_table
      Function  FieldName         (Var   DBResult: TXMLDBResult; Offset: Integer = -1): String;      // mysql_field_name
      Function  FieldType         (Var   DBResult: TXMLDBResult; Offset: Integer = -1): String;      // mysql_field_type
      Function  FieldLen          (Var   DBResult: TXMLDBResult; Offset: Integer = -1): Integer;            // mysql_field_len
      Function  FieldSeek         (Var   DBResult: TXMLDBResult; Offset: Integer):      Integer;            // mysql_field_seek

      Function  EscapeString      (Const UnescapedString: String): String;                    // mysql_real_escape_string

      Procedure Lock;
      Function  TryLock:          Boolean;
      Procedure Unlock;
      Function  isLocked:         Boolean;
    End;

Implementation
  Function TXMLDatabase.GetCaseSensitive: Boolean;
    Begin
      Lock;
      Try
        Result := xoCaseSensitive in _XML.Options;
      Finally
        Unlock;
      End;
    End;

  Procedure TXMLDatabase.SetCaseSensitive(Value: Boolean);
    Begin
      Lock;
      Try
        If Value Then _XML.Options := _XML.Options + [xoCaseSensitive]
        Else          _XML.Options := _XML.Options - [xoCaseSensitive];
      Finally
        Unlock;
      End;
    End;

  Constructor TXMLDatabase.Create(Const FileName: String = '');
    Begin
      _XML         := TXMLFile.Create(Self);
      _XML.Options := _XML.Options + [xoHideInstructionNodes, xoHideTypedefNodes,
                        xoHideCDataNodes, xoHideCommentNodes, xoHideUnknownNodes,
                        xoNodeAutoCreate] - [xoCaseSensitive];
      If FileName <> '' Then Connect(FileName);
    End;

  Destructor TXMLDatabase.Destroy;
    Begin
      _XML.Free;
    End;

  Function TXMLDatabase.Connect(Const FileName: String): Boolean;
    Begin
      Lock;
      Try
        _XML.LoadFromFile(FileName);
        _OpenTime     := GetTickCount;
        _Queries      := 0;
        _AffectedRows := 0;
      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.ListTables: TStringDynArray;
    Var i:   Integer;
      Nodes: TXMLNodeArray;

    Begin
      Lock;
      Try
        Nodes := _XML.RootNode.NodeList['Table'];
        SetLength(Result, Length(Nodes));
        For i := Length(Nodes) downto 0 do Result[i] := Nodes[i].Attributes['Name'];
      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.ListFields(Const TableName: String): TStringDynArray;
    Var i:   Integer;
      Nodes: TXMLNodeArray;

    Begin
      Lock;
      Try
        If _XML.RootNode.Nodes.Exists('Table>Name=' + TableName) Then Begin
          Nodes := _XML.RootNode.Node['Table>Name=' + TableName].Node['Header'].NodeList['Field'];
          SetLength(Result, Length(Nodes));
          For i := Length(Nodes) downto 0 do Result[i] := Nodes[i].Attributes['Name'];
        End Else Result := nil;
      Finally
        Unlock;
      End;
    End;

  Procedure TXMLDatabase.Flush;
    Begin
      Lock;
      Try
        If _XML.FileName = '' Then _XML.SaveToFile(_XML.FileName);
      Finally
        Unlock;
      End;
    End;

  Procedure TXMLDatabase.Close(Save: Boolean = True);
    Begin
      Lock;
      Try
        If Save Then Flush;
        _XML.ClearDocument;
        _XML.FileName := '';
      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.AffectedRows: Integer;
    Begin
      Lock;
      Try
        Result := _AffectedRows;
      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.Stat: TAssocVariantArray;
    Begin
      Lock;
      Try
        Result.Clear;
        Result.Add('Uptime',       (GetTickCount - _OpenTime) div 1000);
        Result.Add('Threads',      '-');
        Result.Add('Questions',    _Queries);
        Result.Add('Slow queries', '-');
        Result.Add('Opens',        1);
        Result.Add('Flush tables', '-');
        Result.Add('Open tables',  '-');
        Result.Add('Queries per second avg', Format('%.2f', [_Queries / (GetTickCount - _OpenTime) * 1000]));
      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.Error: String;
    Begin
      Lock;
      Try
        Result := _Error;
      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.CreateTable(Const TableName: String; Const Fields: Array of String): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.CreateTable(Const TableName: String; Const Fields, PrimaryKey: Array of String): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.AddField(Const TableName, FildName, Datatype: String; AtFirst: Boolean = False; Const AfterField: String = ''): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.ChangeField(Const TableName, OldFildName, NewFildName: String; Const NewDatatype: String = ''): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.ModifyField(Const TableName, NewDatatype: String): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.DropField(Const TableName, FildName: String): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.SetPrimaryKey(Const TableName: String; Const Fields: Array of String): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.TruncateTable(Const TableName: String): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.DropTable(Const TableName: String): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.InsertRecord(Const TableName: String; Const Fields: Array of String): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.InsertRecordDirect(Const TableName: String; Const Values: Array of String): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.InsertRecord(Const TableName: String; Const Select: TXMLDBSelect; Const Condition: TXMLDBCondition): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.UpdateRecord(Const TableName: String; Const Fields: Array of String; Const Condition): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.UpdateRecordDirect(Const TableName: String; Const Values: Array of String; Const Condition): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.SelectRecord(Const Select: TXMLDBSelect; Var DBResult: TXMLDBResult): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.DeleteRecord(Const TableName: String; Const Condition: TXMLDBCondition): Boolean;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.Query(Const Query: String): TXMLDBResult;
    Begin
      Lock;
      Try

        ASM  INT 3  End;

      Finally
        Unlock;
      End;
    End;

  Function TXMLDatabase.NumFields(Const DBResult: TXMLDBResult): Integer;
    Begin
      Result := Length(DBResult.Cols);
    End;

  Function TXMLDatabase.NumRows(Const DBResult: TXMLDBResult): Integer;
    Begin
      Result := Length(DBResult.Rows);
    End;

  Procedure TXMLDatabase.FreeResult(Var DBResult: TXMLDBResult);
    Begin
      DBResult.Cols := nil;
      DBResult.Rows := nil;
    End;

  Function TXMLDatabase.DataSeek(Var DBResult: TXMLDBResult; Offset: Integer): Boolean;
    Begin
      Result := (Offset >= 0) and (Offset < Length(DBResult.Rows));
      If Result Then DBResult.RowIndex := Offset;
    End;

  Function TXMLDatabase.FetchRow(Var DBResult: TXMLDBResult; Var A: TAssocVariantArray): Boolean;
    Var i:  Integer;
      iAVA: TInternalAssocVariantArray Absolute A;

    Begin
      Result := DBResult.RowIndex < Length(DBResult.Rows);
      If Result Then Begin
        SetLength(iAVA, Length(DBResult.Cols));
        For i := High(DBResult.Cols) downto 0 do Begin
          iAVA[i].Name  := DBResult.Cols[i].Name;
          iAVA[i].Value := DBResult.Rows[DBResult.RowIndex, i];
        End;
        Inc(DBResult.RowIndex);
        A.Reset;
      End Else A.Clear;
    End;

  Function TXMLDatabase.FetchField(Var DBResult: TXMLDBResult; Offset: Integer = -1): TAssocVariantArray;
    Begin
      Result.Clear;
      If (Offset < 0) Then Offset := DBResult.ColIndex;
      If Offset < Length(DBResult.Cols) Then Begin
        Result.Add('name',         DBResult.Cols[Offset].SourceName);
        Result.Add('table',        DBResult.Cols[Offset].SourceTable);
        Result.Add('max_length',   DBResult.Cols[Offset].MaxLength);
        Result.Add('not_null',     DBResult.Cols[Offset].NotNull);
        Result.Add('primary_key',  DBResult.Cols[Offset].PrimaryKey);
        Result.Add('unique_key',   DBResult.Cols[Offset].UniqueKey);
        Result.Add('multiple_key', not DBResult.Cols[Offset].UniqueKey);
        Result.Add('numeric',      Pos('numeric', DBResult.Cols[Offset].FType) > 0);
        Result.Add('blob',         DBResult.Cols[Offset].FType = 'BLOB');
        Result.Add('type',         DBResult.Cols[Offset].FType);
        Result.Add('unsigned',     Pos('unsigned', DBResult.Cols[Offset].FType) > 0);
        Result.Add('zerofill',     Pos('zerofill', DBResult.Cols[Offset].FType) > 0);
      End;
    End;

  Function TXMLDatabase.FieldTable(Var DBResult: TXMLDBResult; Offset: Integer = -1): String;
    Begin
      If (Offset < 0) Then Offset := DBResult.ColIndex;
      If Offset >= Length(DBResult.Cols) Then Result := ''
      Else Result := DBResult.Cols[Offset].SourceTable;
    End;

  Function TXMLDatabase.FieldName(Var DBResult: TXMLDBResult; Offset: Integer = -1): String;
    Begin
      If (Offset < 0) Then Offset := DBResult.ColIndex;
      If Offset >= Length(DBResult.Cols) Then Result := ''
      Else Result := DBResult.Cols[Offset].SourceName;
    End;

  Function TXMLDatabase.FieldType(Var DBResult: TXMLDBResult; Offset: Integer = -1): String;
    Begin
      If (Offset < 0) Then Offset := DBResult.ColIndex;
      If Offset >= Length(DBResult.Cols) Then Result := ''
      Else Result := DBResult.Cols[Offset].FType;
    End;

  Function TXMLDatabase.FieldLen(Var DBResult: TXMLDBResult; Offset: Integer = -1): Integer;
    Begin
      If (Offset < 0) Then Offset := DBResult.ColIndex;
      If Offset >= Length(DBResult.Cols) Then Result := 0
      Else Result := DBResult.Cols[Offset].MaxLength;
    End;

  Function TXMLDatabase.FieldSeek(Var DBResult: TXMLDBResult; Offset: Integer): Integer;
    Begin
      If (Offset >= 0) and (Offset < Length(DBResult.Cols)) Then DBResult.ColIndex := Offset;
      Result := DBResult.ColIndex;
    End;

  Function TXMLDatabase.EscapeString(Const UnescapedString: String): String;
    Var i: Integer;

    Begin
      Result := UnescapedString;
      For i := Length(Result) downto 1 do
        Case Result[i] of
          '\', '"', '''':                    Insert('\',   Result, i);
          #26: Begin      Result[i] := '\';  Insert('x1a', Result, i + 1);  End;
          #13: Begin      Result[i] := '\';  Insert('r',   Result, i + 1);  End;
          #10: Begin      Result[i] := '\';  Insert('n',   Result, i + 1);  End;
          #0:  Begin      Result[i] := '\';  Insert('x00', Result, i + 1);  End;
        End;
    End;

  Procedure TXMLDatabase.Lock;
    Begin
      _XML._Lock;
    End;

  Function TXMLDatabase.TryLock: Boolean;
    Begin
      Result := _XML._TryLock;
    End;

  Procedure TXMLDatabase.Unlock;
    Begin
      _XML._Unlock;
    End;

  Function TXMLDatabase.isLocked: Boolean;
    Begin
      Result := _XML._isLocked;
    End;

End.

