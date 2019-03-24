Unit himXML_Opt;

Interface

  (******************************************************************** )
  (                                                                     )
  (  Copyright (c) 1997-2009 FNS Enterprize's™                          )
  (                2003-2009 himitsu @ Delphi-PRAXiS                    )
  (                                                                     )
  (  Description   project options tool for himXML                      )
  (                similar variant to manage the options of an project  )
  (  Filename      himXML_Opt.pas                                       )
  (  Version       v0.97                                                )
  (  Date          21.09.2009                                           )
  (  Project       himXML [himix ML]                                    )
  (  Info / Help   see "help" region in himXML.pas                      )
  (  Support       www.delphipraxis.net/topic153934.html                )
  (                                                                     )
  (  License       MPL v1.1 , GPL v3.0 or LGPL v3.0                     )
  (                                                                     )
  (  Donation      www.FNSE.de/Spenden                                  )
  (                                                                     )
  (*********************************************************************)

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

    // ***** xml format for TXMLProjectOptions *****
    //
    // <?xml ... ?>
    // <poptions company="{name}" application="{name}" version="{version}" {readonly="yes"}>
    //   <option name={name}>{value}</key>
    //   <option name={dirName}>
    //     <option name={name}>{value}</key>
    //     ...
    //   </key>
    //   ...
    // </poptions>

    // ***** locations for TXMLProjectOptions *****
    //
    // xpoSession            the settings are only valid for this session (not stored)
    // xpoDirect             file by setting trouth the property .FileName incl. an absolute or relative path
    // xpoAppDir             it will stored in the program directory
    //
    // xpoLocalAppDataCP     C:\Documents and Settings\[user]\Local Settings\Application Data\[company]\[project]\[filename]
    // xpoLocalAppDataP      C:\Documents and Settings\[user]\Local Settings\Application Data\[project]\[filename]
    // xpoLocalAppDataC      C:\Documents and Settings\[user]\Local Settings\Application Data\[company]\[filename]
    // xpoLocalAppData       C:\Documents and Settings\[user]\Local Settings\Application Data\[filename]
    //
    // xpoRoamingAppDataCP   C:\Documents and Settings\[user]\Application Data\[company]\[project]\[filename]
    // xpoRoamingAppDataP    C:\Documents and Settings\[user]\Application Data\[project][filename]
    // xpoRoamingAppDataC    C:\Documents and Settings\[user]\Application Data\[company]\[filename]
    // xpoRoamingAppData     C:\Documents and Settings\[user]\Application Data\[filename]
    //
    // xpoAllUserAppDataCP   C:\Documents and Settings\All Users\Application Data\[company]\[project]\[user-guid][filename]
    // xpoAllUserAppDataP    C:\Documents and Settings\All Users\Application Data\[project]\[user-guid][filename]
    // xpoAllUserAppDataC    C:\Documents and Settings\All Users\Application Data\[company]\[user-guid][filename]
    // xpoAllUserAppData     C:\Documents and Settings\All Users\Application Data\[user-guid][filename]

  {$IF X}{$ENDREGION}{$IFEND}

  Uses Types, Windows, SysUtils, Classes, himXML_Lang, himXML;

  {$DEFINE CMarker_himXMLOpt_Init}
  {$INCLUDE himXMLCheck.inc}

  {$WARN SYMBOL_PLATFORM OFF}

  Type TXMLProjectOptions = Class;
    TXMLPOLocation        = (xpoSession, xpoDirect, xpoAppDir, xpoLocalAppDataCP, xpoLocalAppDataP, xpoLocalAppDataC, xpoLocalAppData,
                              xpoRoamingAppDataCP, xpoRoamingAppDataP, xpoRoamingAppDataC, xpoRoamingAppData,
                              xpoAllUserAppDataCP, xpoAllUserAppDataP, xpoAllUserAppDataC, xpoAllUserAppData);
    TXMLPOLocations       = Set of TXMLPOLocation;
    TXMLPOSelectLocation  = Procedure(Sender: TXMLProjectOptions; Var Location: TXMLPOLocation) of Object;
    TXMLPOErrorProc       = Function(Sender: TXMLProjectOptions; Error: HRESULT; Const ErrorStr: String): Boolean of Object;

    TXMLProjectOptions = Class
    Private
      _XML:               TXMLFile;
      _Tag:               Integer;

      _AutorOrCompany:    String;
      _Project:           String;
      _OptionsVersion:    String;

      _AllowedLocations:  TXMLPOLocations;
      _FileName:          String;
      _Protection:        AnsiString;

      _ActiveLocation:    TXMLPOLocation;
      _NoUpdate:          Integer;

      _SelectLocation:    TXMLPOSelectLocation;
      _ErrorProc:         TXMLPOErrorProc;

      Procedure DoError(Const ErrorStr: String; Error: HRESULT = -1); Overload;
      Procedure DoError(E: Exception);                                Overload;
      Function  Changed: Boolean;
      Function  GetLocation(L: TXMLPOLocation; Const AutorOrCompany, Project, FileName: String; AllUsersMask: Boolean = False): String;
      Function  MoveFile   (L: TXMLPOLocation; Const AutorOrCompany, Project, FileName: String; DeleteOther:  Boolean = True):  Boolean;

      Function  CheckReadOnly:             Boolean;
      Function  CheckName          (Value: String): Boolean;
      Procedure SetAutorOrCompany  (Value: String);
      Procedure SetProject         (Value: String);
      Procedure SetOptionsVersion  (Value: String);
      Procedure SetAllowedLocations(Value: TXMLPOLocations);
      Procedure SetFileName        (Value: String);
      Procedure SetProtection      (Value: AnsiString);
      Procedure SetActiveLocation  (Value: TXMLPOLocation);
      Function  GetReadOnly:               Boolean;
      Procedure SetReadOnly        (Value: Boolean);
      Function  GetValue           (Name:  String):                     Variant;
      Procedure SetValue           (Name:  String;               Value: Variant);
      Function  GetFormatValue     (Name:  String; Fmt: Variant):       Variant;
      Procedure SetFormatValue     (Name:  String; Fmt: Variant; Value: Variant);
      Function  GetProtect         (Name:  String):                     Boolean;
      Procedure SetProtect         (Name:  String;               Value: Boolean);
    Public
      Constructor Create;
      Destructor  Destroy; Override;

      Property  AutorOrCompany:     String                         Read _AutorOrCompany   Write SetAutorOrCompany;
      Property  Project:            String                         Read _Project          Write SetProject;
      Property  OptionsVersion:     String                         Read _OptionsVersion   Write SetOptionsVersion;

      Property  AllowedLocations:   TXMLPOLocations                Read _AllowedLocations Write SetAllowedLocations;
      Property  FileName:           String                         Read _FileName         Write SetFileName;
      Property  Protection:         AnsiString                     Read _Protection       Write SetProtection;

      Function  ExistingLocations:  TXMLPOLocations;
      Function  PossibleLocations:  TXMLPOLocations;

      Function  Open:                                Boolean; Overload;
      Function  Open     (Location: TXMLPOLocation): Boolean; Overload;
      Property  ActiveLocation:     TXMLPOLocation                 Read _ActiveLocation   Write SetActiveLocation;

      // only if ActiveLocation is xpoAllUserAppDataCP..xpoAllUserAppData
      Function  GetOptionfiles      (Out IndexOfSelf: Integer): TStringDynArray;
      Procedure UpdateShareddata    (ValueName: String; OptionsFile: String = '');

      Property  ReadOnly:           Boolean                        Read GetReadOnly       Write SetReadOnly;

      Procedure BeginUpdate;
      Property  Value        [Name: String]:               Variant Read GetValue          Write SetValue;
      Property  ValueFmt     [Name: String; Fmt: Variant]: Variant Read GetFormatValue    Write SetFormatValue;
      Procedure SaveObject   (Name: String;     Value:   TObject);
      Procedure LoadObject   (Name: String;     Value:   TObject);
      Property  Protect      [Name: String]: Boolean               Read GetProtect        Write SetProtect;
      Function  Exists       (Name: String): Boolean;
      Function  GetValueDef  (Name: String;     Default:           Variant): Variant; Overload;
      Function  GetValueDef  (Name: String;     Default, Min, Max: Variant): Variant; Overload;
      Function  TryGetValue  (Name: String; Var Value:             Variant): Boolean;
      Function  TryLoadObject(Name: String;     Value:             TObject): Boolean;
      Procedure DeleteValue  (Name: String);
      Procedure EndUpdate;

      Procedure Save     (Location: TXMLPOLocation; DeleteOther: Boolean);
      Procedure Close;
      Procedure Delete   (Location: TXMLPOLocation);
      Procedure DeleteAllOptionFiles;

      Property  OnSelectLocation:   TXMLPOSelectLocation           Read _SelectLocation   Write _SelectLocation;
      Property  OnException:        TXMLPOErrorProc                Read _ErrorProc        Write _ErrorProc;

      Function  GetPath  (Location: TXMLPOLocation): String;

      Property  Tag:                Integer                        Read _Tag              Write _Tag;
    End;

Implementation
  Type EXTENDED_NAME_FORMAT = Integer;

  Const NameUniqueId = EXTENDED_NAME_FORMAT(6);

  Function GetUserNameEx(NameFormat: EXTENDED_NAME_FORMAT; NameBuffer: PChar; Var Size: Integer): Boolean; StdCall;
    External 'Secur32.dll' Name {$IF SizeOf(Char) = 1}'GetUserNameExA'{$ELSE}'GetUserNameExW'{$IFEND};

  Function SHGetSpecialFolderLocation(Owner: HWND; Folder: Integer; Var ItemIDList: Pointer): HResult; StdCall;
    External 'shell32.dll' Name 'SHGetSpecialFolderLocation';

  Function SHGetPathFromIDList(ItemIDList: Pointer; pszPath: PChar): LongBool; StdCall;
    External 'shell32.dll' Name {$IF SizeOf(Char) = 1}'SHGetPathFromIDListA'{$ELSE}'SHGetPathFromIDListW'{$IFEND};

  Procedure CoTaskMemFree(P: Pointer); StdCall;
    External 'ole32.dll' Name 'CoTaskMemFree';

  Procedure TXMLProjectOptions.DoError(Const ErrorStr: String; Error: HRESULT = -1);
    Begin
      If not Assigned(_ErrorProc) or not _ErrorProc(Self, Error, ErrorStr) Then
        If Error = -1 Then Raise EXMLException.Create(ErrorStr)
        Else Raise EXMLException.Create(ErrorStr + #13#10#13#10'system message:'#13#10
          + SysErrorMessage(Error));
    End;

  Procedure TXMLProjectOptions.DoError(E: Exception);
    Begin
      If not Assigned(_ErrorProc) or not _ErrorProc(Self, -1, E.Message) Then
        Raise E;
    End;

  Function TXMLProjectOptions.Changed: Boolean;
    Var S: String;

    Begin
      Result := False;
      If (_ActiveLocation <> xpoSession) and (_NoUpdate <> 0) Then
        Try
          S := GetPath(_ActiveLocation);
          If not ForceDirectories(ExtractFileDir(S)) Then Begin
            DoError('directory can''t created'#13#10'"' + ExtractFileDir(S) + '"', GetLastError);
            Exit;
          End;
          _XML.RootNode.Name            := 'poptions';
          _XML.Attribute['company']     := _AutorOrCompany;
          _XML.Attribute['application'] := _Project;
          _XML.Attribute['version']     := _OptionsVersion;
          _XML.SaveToFile(S);
          Result := True;
        Except
          On E: Exception do DoError(E);
        End;
    End;

  Function TXMLProjectOptions.GetLocation(L: TXMLPOLocation; Const AutorOrCompany, Project, FileName: String;
      AllUsersMask: Boolean = False): String;

    Function GetSpecialFolder(Folder: Integer): String;
      Var IDL: Pointer;

      Begin
        If Integer(SHGetSpecialFolderLocation(0, Folder, IDL)) >= 0 Then Begin
          SetLength(Result, MAX_PATH);
          SHGetPathFromIDList(IDL, PChar(Result));
          SetLength(Result, lstrlen(PChar(Result)));
          CoTaskMemFree(IDL);
        End Else Result := '';
      End;

    Var S: String;
      i:   Integer;

    Begin
      Result := '';
      Case L of
        xpoDirect:                              S := '';
        xpoAppDir:                              S := ExtractFilePath(ParamStr(0));
        xpoLocalAppDataCP..xpoLocalAppData:     S := GetSpecialFolder(28{CSIDL_LOCAL_APPDATA})  + PathDelim;
        xpoRoamingAppDataCP..xpoRoamingAppData: S := GetSpecialFolder(26{CSIDL_APPDATA})        + PathDelim;
        xpoAllUserAppDataCP..xpoAllUserAppData: S := GetSpecialFolder(35{CSIDL_COMMON_APPDATA}) + PathDelim;
        Else                                    Exit;
      End;
      If ((S = '') and (L <> xpoDirect)) or (_FileName = '') Then Exit;
      Case L of
        xpoLocalAppDataCP, xpoRoamingAppDataCP, xpoAllUserAppDataCP:
          If (AutorOrCompany = '') or (Project = '') Then Exit
          Else S := S + AutorOrCompany + PathDelim + Project + PathDelim;
        xpoLocalAppDataP, xpoRoamingAppDataP, xpoAllUserAppDataP:
          If Project = '' Then Exit Else S := S + Project + PathDelim;
        xpoLocalAppDataC, xpoRoamingAppDataC, xpoAllUserAppDataC:
          If AutorOrCompany = '' Then Exit Else S := S + AutorOrCompany + PathDelim;
      End;
      Result := S + _FileName;
      If L in [xpoAllUserAppDataCP..xpoAllUserAppData] Then Begin
        SetLength(S, 38);
        i := 38;
        If AllUsersMask or (not GetUserNameEx(NameUniqueId, PChar(S), i) and (i = 38)) Then Begin
          If AllUsersMask Then S := '{????????-????-????-????-????????????}';
          i := Length(Result);
          While (i > 0) and (Result[i] <> PathDelim) do Dec(i);
          Insert(S, Result, i + 1);
        End Else Result := '';
      End;
    End;

  Function TXMLProjectOptions.MoveFile(L: TXMLPOLocation;
      Const AutorOrCompany, Project, FileName: String; DeleteOther: Boolean = True): Boolean;

    Var S: String;

    Begin
      Result := False;
      If L <> xpoSession Then Begin
        S := GetLocation(L, AutorOrCompany, Project, FileName);
        If S = '' Then Begin
          DoError('location (' + IntToStr(Ord(L)) + ') does not exists');
          Exit;
        End;
        Try
          If not ForceDirectories(ExtractFileDir(S)) Then Begin
            DoError('directory can''t created'#13#10'"' + ExtractFileDir(S) + '"', GetLastError);
            Exit;
          End;
          _XML.RootNode.Name            := 'poptions';
          _XML.Attribute['company']     := AutorOrCompany;
          _XML.Attribute['application'] := Project;
          _XML.Attribute['version']     := _OptionsVersion;
          _XML.SaveToFile(S);
        Except
          On E: Exception do Begin
            DoError(E);
            Exit;
          End;
        End;
      End;
      If DeleteOther Then Begin
        S := GetPath(_ActiveLocation);
        If (S <> '') and FileExists(S) and not DeleteFile(S) Then Begin
          DoError('can''t delete "' + S + '"', GetLastError);
          Exit;
        End;
      End;
      Result := True;
    End;

  Function TXMLProjectOptions.CheckReadOnly: Boolean;
    Begin
      Result := ReadOnly;
      If Result Then DoError('the options are read only and can''t changed');
    End;

  Function TXMLProjectOptions.CheckName(Value: String): Boolean;
    Var i: Integer;

    Begin
      Result := (Value <> '') and (Trim(Value) = Value);
      For i := 1 to Length(Value) do
        If (Value[i] < #128) and (AnsiChar(Value[i]) in [#0..#31, '"', '*', '/', ':', '<', '>', '?', '\', '|']) Then
          Result := False;
    End;

  Procedure TXMLProjectOptions.SetAutorOrCompany(Value: String);
    Begin
      If CheckReadOnly Then Exit;
      If ((Value = '') and not (_ActiveLocation in [xpoLocalAppDataCP, xpoLocalAppDataC,
            xpoRoamingAppDataCP, xpoRoamingAppDataC, xpoAllUserAppDataCP, xpoAllUserAppDataC]))
          or CheckName(Value) Then Begin
        If MoveFile(_ActiveLocation, Value, _Project, _FileName) Then
          _AutorOrCompany := Value;
      End Else DoError('invalid parameter "' + Value + '"');
    End;

  Procedure TXMLProjectOptions.SetProject(Value: String);
    Begin
      If CheckReadOnly Then Exit;
      If ((Value = '') and not (_ActiveLocation in [xpoLocalAppDataCP, xpoLocalAppDataP,
            xpoRoamingAppDataCP, xpoRoamingAppDataP, xpoAllUserAppDataCP, xpoAllUserAppDataP]))
          or CheckName(Value) Then Begin
        If MoveFile(_ActiveLocation, _AutorOrCompany, Value, _FileName) Then
          _Project := Value;
      End Else DoError('invalid parameter "' + Value + '"');
    End;

  Procedure TXMLProjectOptions.SetOptionsVersion(Value: String);
    Begin
      If CheckReadOnly Then Exit;
      _OptionsVersion := Value;
      Changed;
    End;

  Procedure TXMLProjectOptions.SetAllowedLocations(Value: TXMLPOLocations);
    Begin
      If CheckReadOnly Then Exit;
      If Value = [] Then _AllowedLocations := PossibleLocations
      Else _AllowedLocations := Value * PossibleLocations;
    End;

  Procedure TXMLProjectOptions.SetFileName(Value: String);
    Begin
      If CheckReadOnly Then Exit;
      If Value <> '' Then Begin
        If MoveFile(_ActiveLocation, _AutorOrCompany, _Project, Value) Then
          _FileName := Value;
      End Else DoError('invalid parameter "' + Value + '"');
    End;

  Procedure TXMLProjectOptions.SetProtection(Value: AnsiString);
    Begin
      If CheckReadOnly Then Exit;
      _XML.CryptData['*'] := Value;
      Changed;
    End;

  Procedure TXMLProjectOptions.SetActiveLocation(Value: TXMLPOLocation);
    Begin
      If CheckReadOnly Then Exit;
      If Value = _ActiveLocation Then Exit;
      If MoveFile(Value, AutorOrCompany, Project, _FileName) Then
        _ActiveLocation := Value
      Else DoError('invalid parameter (location: ' + IntToStr(Ord(Value)) + ')');
    End;

  Function TXMLProjectOptions.GetReadOnly: Boolean;
    Begin
      Result := _XML.RootNode.Attributes.Exists('readonly');
    End;

  Procedure TXMLProjectOptions.SetReadOnly(Value: Boolean);
    Var S: String;

    Begin
      Try
        S := GetPath(_ActiveLocation);
        If not ForceDirectories(ExtractFileDir(S)) Then Begin
          DoError('directory can''t created'#13#10'"' + ExtractFileDir(S) + '"', GetLastError);
          Exit;
        End;
        _XML.RootNode.Name            := 'poptions';
        _XML.Attribute['company']     := _AutorOrCompany;
        _XML.Attribute['application'] := _Project;
        _XML.Attribute['version']     := _OptionsVersion;
        If Value Then _XML.RootNode.Attributes['readonly'] := 'yes'
        Else If _XML.RootNode.Attributes.Exists('readonly') Then
          _XML.RootNode.Attributes.Delete('readonly');
        _XML.SaveToFile(S);
      Except
        On E: Exception do DoError(E);
      End;
    End;

  Function TXMLProjectOptions.GetValue(Name: String): Variant;
    Begin
      _XML[Name].Deserialize(Result);
    End;

  Procedure TXMLProjectOptions.SetValue(Name: String; Value: Variant);
    Begin
      If CheckReadOnly Then Exit;
      _XML[Name].Serialize(Value);
      Changed;
    End;

  Function TXMLProjectOptions.GetFormatValue(Name: String; Fmt: Variant): Variant;
    Var S: String;

    Begin
      Try
        S := Format(Name, [Integer(Fmt)]);
      Except
        S := Format(Name, [String(Fmt)]);
      End;
      _XML[S].Deserialize(Result);
    End;

  Procedure TXMLProjectOptions.SetFormatValue(Name: String; Fmt: Variant; Value: Variant);
    Var S: String;

    Begin
      If CheckReadOnly Then Exit;
      Try
        S := Format(Name, [Integer(Fmt)]);
      Except
        S := Format(Name, [String(Fmt)]);
      End;
      _XML[S].Serialize(Value);
      Changed;
    End;

  Function TXMLProjectOptions.GetProtect(Name: String): Boolean;
    Begin
      Result := _XML[Name].Crypt = '';
    End;

  Procedure TXMLProjectOptions.SetProtect(Name: String; Value: Boolean);
    Begin
      If CheckReadOnly Then Exit;
      If Value Then _XML[Name].Crypt := '*'
      Else If _XML.RootNode.Nodes.Exists(Name) Then _XML[Name].Crypt := '';
      Changed;
    End;

  Constructor TXMLProjectOptions.Create;
    Begin
      _XML := TXMLFile.Create(Self, 'poptions');
      _OptionsVersion   := '1.0';
      _AllowedLocations := [xpoSession, xpoAppDir, xpoLocalAppDataC, xpoLocalAppData,
        xpoRoamingAppDataC, xpoRoamingAppData, xpoAllUserAppDataC, xpoAllUserAppData];
      _FileName := ChangeFileExt(ExtractFileName(ParamStr(0)), '.xml');
      _ActiveLocation := xpoSession;
    End;

  Destructor TXMLProjectOptions.Destroy;
    Begin
      Try
        Close;
      Finally
        _XML.Free;
      End;
    End;

  Function TXMLProjectOptions.ExistingLocations: TXMLPOLocations;
    Var L: TXMLPOLocation;
      S:   String;

    Begin
      Result := [xpoAppDir..xpoAllUserAppData];
      For L := Low(TXMLPOLocation) to High(TXMLPOLocation) do
        If L in Result Then Begin
          S := GetPath(L);
          If (S = '') or not FileExists(S) Then Exclude(Result, L);
        End;
    End;

  Function TXMLProjectOptions.PossibleLocations: TXMLPOLocations;
    Function TestPath(L: TXMLPOLocation): Boolean;
      Var S: String;
        H:   THandle;

      Begin
        S := GetPath(L);
        If S <> '' Then Begin
          H := CreateFile(PChar(S + 'CreateFile_{19427AAF-D257-431D-9103-31B7ABFAC958}.test'),
            GENERIC_WRITE or GENERIC_READ, 0, nil, CREATE_ALWAYS, 0, 0);
          CloseHandle(H);
          DeleteFile(S + 'CreateFile_{19427AAF-D257-431D-9103-31B7ABFAC958}.test');
          Result := H <> INVALID_HANDLE_VALUE;
        End Else Result := False;
      End;

    Begin
      If AutorOrCompany <> '' Then Begin
        If Project <> '' Then
             Result := [xpoSession..xpoAllUserAppData]
        Else Result := [xpoSession, xpoAppDir, xpoLocalAppDataC, xpoLocalAppData,
               xpoRoamingAppDataC, xpoRoamingAppData, xpoAllUserAppDataC, xpoAllUserAppData]
      End Else
        If Project <> '' Then
             Result := [xpoSession, xpoAppDir, xpoLocalAppDataP, xpoLocalAppData,
               xpoRoamingAppDataP, xpoRoamingAppData, xpoAllUserAppDataP, xpoAllUserAppData]
        Else Result := [xpoSession, xpoAppDir, xpoLocalAppData, xpoRoamingAppData, xpoAllUserAppData];
      If (xpoAppDir in Result) and not TestPath(xpoAppDir) Then Exclude(Result, xpoAppDir);
      If (Result * [xpoLocalAppDataCP..xpoLocalAppData] <> []) and not TestPath(xpoLocalAppData) Then
        Result := Result - [xpoLocalAppDataCP..xpoLocalAppData];
      If (Result * [xpoRoamingAppDataCP..xpoRoamingAppData] <> []) and not TestPath(xpoRoamingAppData) Then
        Result := Result - [xpoRoamingAppDataCP..xpoRoamingAppData];
      If (Result * [xpoAllUserAppDataCP..xpoAllUserAppData] <> []) and not TestPath(xpoAllUserAppData) Then
        Result := Result - [xpoAllUserAppDataCP..xpoAllUserAppData];
    End;

  Function TXMLProjectOptions.Open: Boolean;
    Var L: TXMLPOLocation;
      i:   Integer;

    Begin
      Result := False;
      _XML.ClearDocument('poptions');
      _ActiveLocation := xpoSession;
      For L := Low(TXMLPOLocation) to High(TXMLPOLocation) do
        If L in _AllowedLocations Then Begin
          _ActiveLocation := L;
          Break;
        End;
      i := 0;
      For L := Low(TXMLPOLocation) to High(TXMLPOLocation) do
        If L in _AllowedLocations Then Begin
          Inc(i);
          If FileExists(GetPath(L)) Then Begin
            If Open(L) Then Begin
              _ActiveLocation := L;
              Result := True;
            End;
            Exit;
          End;
        End;
      If i > 1 Then Begin
        If Assigned(_SelectLocation) Then Begin
          L := _ActiveLocation;
          _SelectLocation(Self, L);
          If not (L in _AllowedLocations) Then Begin
            DoError('OnSelectLocation returned an invalid location');
            Exit;
          End Else _ActiveLocation := L;
        End;
        Result := True;
      End Else If i = 0 Then DoError('allowed location count = 0');
    End;

  Function TXMLProjectOptions.Open(Location: TXMLPOLocation): Boolean;
    Begin
      Try
        _XML.LoadFromFile(GetPath(Location));
        Result := True;
      Except
        On E: Exception do Begin
          _XML.ClearDocument('poptions');
          DoError(E);
          Result := False;
        End;
      End;
    End;

  Function TXMLProjectOptions.GetOptionfiles(Out IndexOfSelf: Integer): TStringDynArray;
    Var S:   String;
      i, i2: Integer;
      SR:    TSearchRec;
      Date:  Array of TFileTime;
      Temp:  TFileTime;

    Begin
      Result := nil;
      IndexOfSelf := -1;
      If _ActiveLocation in [xpoAllUserAppDataCP..xpoAllUserAppData] Then Begin
        S := GetLocation(_ActiveLocation, AutorOrCompany, Project, _FileName, True);
        If FindFirst(S, faReadOnly or faArchive, SR) = 0 Then Begin
          Repeat
            i := Length(Result);
            SetLength(Result, i + 1);
            SetLength(Date,   i + 1);
            Result[i] := ExtractFilePath(S) + SR.Name;
            Date[i]   := SR.FindData.ftLastWriteTime;
          Until FindNext(SR) <> 0;
          FindClose(SR);
        End;
        For i := 0 to High(Result) - 1 do
          For i2 := i + 1 to High(Result) do
            If Int64(Date[i]) > Int64(Date[i2]) Then Begin
              S          := Result[i];
              Result[i]  := Result[i2];
              Result[i2] := S;
              Temp       := Date[i];
              Date[i]    := Date[i2];
              Date[i2]   := Temp;
            End;
        S := GetLocation(_ActiveLocation, AutorOrCompany, Project, _FileName, False);
        For i := High(Result) downto 0 do
          If AnsiSameText(Result[i], S) Then IndexOfSelf := i;
      End;
    End;

  Procedure TXMLProjectOptions.UpdateShareddata(ValueName: String; OptionsFile: String = '');
    Var A: TStringDynArray;
      i:   Integer;
      XML: TXMLFile;

    Begin
      If Trim(OptionsFile) = '' Then Begin
        A := GetOptionfiles(i);
        If i = 0 Then Exit;
        If i > 0 Then OptionsFile := A[0];
      End;
      _XML[ValueName].Attributes.Clear;
      _XML[ValueName].Nodes.Clear;
      XML := TXMLFile.Create(Self, 'poptions');
      Try
        XML.LoadFromFile(OptionsFile);
        _XML[ValueName].Attributes.Assign(XML[ValueName].Attributes);
        _XML[ValueName].Nodes.Assign(XML[ValueName].Nodes);
      Finally
        XML.Free;
      End;
    End;

  Procedure TXMLProjectOptions.BeginUpdate;
    Begin
      Inc(_NoUpdate);
    End;

  Procedure TXMLProjectOptions.SaveObject(Name: String; Value: TObject);
    Begin
      If CheckReadOnly Then Exit;
      _XML[Name].Serialize(Value);
      Changed;
    End;

  Procedure TXMLProjectOptions.LoadObject(Name: String; Value: TObject);
    Begin
      _XML[Name].Deserialize(Value);
    End;

  Function TXMLProjectOptions.Exists(Name: String): Boolean;
    Begin
      Result := _XML.RootNode.Nodes.Exists(Name);
    End;

  Function TXMLProjectOptions.GetValueDef(Name: String; Default: Variant): Variant;
    Begin
      If Exists(Name) Then Result := Self.Value[Name] Else Result := Default;
    End;

  Function TXMLProjectOptions.GetValueDef(Name: String; Default, Min, Max: Variant): Variant;
    Begin
      If Exists(Name) Then Begin
        Result := Self.Value[Name];
        If Result < Min Then Result := Min;
        If Result > Max Then Result := Max;
      End Else Result := Default;
    End;

  Function TXMLProjectOptions.TryGetValue(Name: String; Var Value: Variant): Boolean;
    Begin
      Result := Exists(Name);
      If Result Then Value := Self.Value[Name];
    End;

  Function TXMLProjectOptions.TryLoadObject(Name: String; Value: TObject): Boolean;
    Begin
      Result := Exists(Name);
      If Result Then _XML[Name].Deserialize(Value);
    End;

  Procedure TXMLProjectOptions.DeleteValue(Name: String);
    Begin
      If CheckReadOnly Then Exit;
      If Exists(Name) Then Begin
        _XML.RootNode.Nodes.Delete(Name);
        Changed;
      End;
    End;

  Procedure TXMLProjectOptions.EndUpdate;
    Begin
      Dec(_NoUpdate);
      Changed;
    End;

  Procedure TXMLProjectOptions.Save(Location: TXMLPOLocation; DeleteOther: Boolean);
    Begin
      If CheckReadOnly Then Exit;
      MoveFile(Location, _AutorOrCompany, _Project, _FileName, DeleteOther);
    End;

  Procedure TXMLProjectOptions.Close;
    Begin
      _NoUpdate := 0;
      Changed;
      _XML.ClearDocument('poptions');
      _ActiveLocation := xpoSession;
    End;

  Procedure TXMLProjectOptions.Delete(Location: TXMLPOLocation);
    Var S: String;

    Begin
      S := GetPath(_ActiveLocation);
      If (S <> '') and FileExists(S) and not DeleteFile(S) Then
        DoError('can''t delete ' + S, GetLastError);
    End;

  Procedure TXMLProjectOptions.DeleteAllOptionFiles;
    Var L: TXMLPOLocation;
      E:   TXMLPOLocations;

    Begin
      Close;
      E := ExistingLocations;
      For L := Low(TXMLPOLocation) to High(TXMLPOLocation) do
        If L in E Then Delete(L);
    End;

  Function TXMLProjectOptions.GetPath(Location: TXMLPOLocation): String;
    Begin
      Result := GetLocation(Location, AutorOrCompany, Project, _FileName);
    End;

End.

