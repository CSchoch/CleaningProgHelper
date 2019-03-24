Unit himXML_RPC;

Interface

  (****************************************************** )
  (                                                       )
  (  Copyright (c) 1997-2009 FNS Enterprize's™            )
  (                2003-2009 himitsu @ Delphi-PRAXiS      )
  (                                                       )
  (  Description   remote procedure call tool for himXML  )
  (  Filename      himXML_RPC.pas                         )
  (  Version       v0.97                                  )
  (  Date          21.09.2009                             )
  (  Project       himXML [himix ML]                      )
  (  Info / Help   see "help" region in himXML.pas        )
  (  Support       www.delphipraxis.net/topic153934.html  )
  (                                                       )
  (  License       MPL v1.1 , GPL v3.0 or LGPL v3.0       )
  (                                                       )
  (  Donation      www.FNSE.de/Spenden                    )
  (                                                       )
  (*******************************************************)

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

  {$IF X}{$ENDREGION}{$IFEND}

  Uses Types, Windows, SysUtils, Classes, himXML_Lang, himXML,
    IdGlobal, IdResourceStringsCore, IdExceptionCore, IdTCPClient,
    IdHTTP, IdSSLOpenSSL {, IdBaseComponent, IdComponent, IdTCPConnection};

  {$DEFINE CMarker_himXMLRPC_Init}
  {$DEFINE CMarker_himXMLLang}
  {$DEFINE CMarker_himXML}
  {$INCLUDE himXMLCheck.inc}

  Type TXMLRPCFunction = Record
      Name:           String;
      Request:        TXMLFile;
      Response:       TXMLFile;
      ResponseHeader: Array of String;
    End;

    TXMLRPCClient = Class
    Private
      _TCPClient:       TIdTCPClient;
      _HTTPClient:      TIdHTTP;
      _UserAgent:       String;
      _TimeOut:         Integer;
      _IPVersion:       TIdIPVersion;
      _Host:            String;
      _Port:            Word;
      _URI:             String;
      _ProxyServer:     String;
      _ProxyPort:       Word;
      _ProxyUserName:   String;
      _ProxyPassword:   String;
      _SSLRootCertFile: String;
      _SSLCertFile:     String;
      _SSLKeyFile:      String;
      _Functions:       Array of TXMLRPCFunction;

      Procedure SetRPCError       (FuncIndex, FaultCode: Integer; Const FaultString: String);
      Procedure SetUserAgent      (Const Value: String);
      Procedure SetTimeOut        (      Value: Integer);
      Procedure SetIPVersion      (      Value: TIdIPVersion);
      Procedure SetHost           (Const Value: String);
      Procedure SetPort           (      Value: Word);
      Procedure SetURI            (Const Value: String);
      Procedure SetProxyServer    (Const Value: String);
      Procedure SetProxyPort      (      Value: Word);
      Procedure SetProxyUserName  (Const Value: String);
      Procedure SetProxyPassword  (Const Value: String);
      Procedure SetSSLRootCertFile(Const Value: String);
      Procedure SetSSLCertFile    (Const Value: String);
      Procedure SetSSLKeyFile     (Const Value: String);
      Function  GetFunctionIndex  (Const Func:  String): Integer;
      Function  GetActiveFunction:              String;
      Procedure SetActiveFunction (Const Func:  String);
      Function  GetRequestXML     (      Func:  String = ''): TXMLFile;
      Function  GetResponseXML    (      Func:  String = ''): TXMLFile;
    Public
      Constructor Create;
      Destructor  Destroy; Override;

      Property  TCPClient:       TIdTCPClient Read _TCPClient;
      Property  HTTPClient:      TIdHTTP      Read _HTTPClient;

      Property  UserAgent:       String       Read _UserAgent       Write SetUserAgent;
      Property  TimeOut:         Integer      Read _TimeOut         Write SetTimeOut;

      Property  IPVersion:       TIdIPVersion Read _IPVersion       Write SetIPVersion;
      Property  Host:            String       Read _Host            Write SetHost;
      Property  Port:            Word         Read _Port            Write SetPort;
      Property  URI:             String       Read _URI             Write SetURI;

      Procedure Open   (Const Host: String = ''; Port: Word = 0; TimeOut: Integer = 0);
      Function  Execute(Const Func: String = ''; Const EndPoint: String = ''): Boolean;
      Procedure Close;
      Function  Send   (Const Func: String = ''; Const EndPoint: String = '';
                        Const Host: String = ''; Port: Word = 0; TimeOut: Integer = 0): Boolean;

      Property  ProxyServer:     String       Read _ProxyServer     Write SetProxyServer;
      Property  ProxyPort:       Word         Read _ProxyPort       Write SetProxyPort;
      Property  ProxyUserName:   String       Read _ProxyUserName   Write SetProxyUserName;
      Property  ProxyPassword:   String       Read _ProxyPassword   Write SetProxyPassword;

      Property  SSLRootCertFile: String       Read _SSLRootCertFile Write SetSSLRootCertFile;
      Property  SSLCertFile:     String       Read _SSLCertFile     Write SetSSLCertFile;
      Property  SSLKeyFile:      String       Read _SSLKeyFile      Write SetSSLKeyFile;

      Function  SecureSend(Const Func: String = ''; Const EndPoint: String = '';
                           Const Host: String = ''; Port: Word = 0; TimeOut: Integer = 0): Boolean;

      Function ListFunktions:    TStringDynArray;
      Property ActiveFunction:   String       Read GetActiveFunction Write SetActiveFunction;

      Property Request    [Func: String = '']: TXMLFile Read GetRequestXML;
      Property Response   [Func: String = '']: TXMLFile Read GetResponseXML;
    End;

Implementation
  Procedure TXMLRPCClient.SetRPCError(FuncIndex, FaultCode: Integer; Const FaultString: String);
    Begin
      With _Functions[FuncIndex].Request do Begin
        ClearDocument('methodResponse');
        Standalone := '';
        With AddNode('fault\value\struct') do Begin
          With AddNode('member') do Begin
            AddNode('name').Text         := 'faultCode';
            AddNode('value\int').Text    := FaultCode;
          End;
          With AddNode('member') do Begin
            AddNode('name').Text         := 'faultString';
            AddNode('value\string').Text := FaultString;
          End;
        End;
      End;
    End;

  Procedure TXMLRPCClient.SetUserAgent(Const Value: String);
    Begin
      _UserAgent := Value;
    End;

  Procedure TXMLRPCClient.SetTimeOut(Value: Integer);
    Begin
      _TimeOut := Value;
    End;

  Procedure TXMLRPCClient.SetIPVersion(Value: TIdIPVersion);
    Begin
      _IPVersion := Value;
    End;

  Procedure TXMLRPCClient.SetHost(Const Value: String);
    Begin
      _Host := Value;
    End;

  Procedure TXMLRPCClient.SetPort(Value: Word);
    Begin
      _Port := Value;
    End;

  Procedure TXMLRPCClient.SetURI(Const Value: String);
    Begin
      _URI := Value;
    End;

  Procedure TXMLRPCClient.SetProxyServer(Const Value: String);
    Begin
      _ProxyServer := Value;
    End;

  Procedure TXMLRPCClient.SetProxyPort(Value: Word);
    Begin
      _ProxyPort := Value;
    End;

  Procedure TXMLRPCClient.SetProxyUserName(Const Value: String);
    Begin
      _ProxyUserName := Value;
    End;

  Procedure TXMLRPCClient.SetProxyPassword(Const Value: String);
    Begin
      _ProxyPassword := Value;
    End;

  Procedure TXMLRPCClient.SetSSLRootCertFile(Const Value: String);
    Begin
      _SSLRootCertFile := Value;
    End;

  Procedure TXMLRPCClient.SetSSLCertFile(Const Value: String);
    Begin
      _SSLCertFile := Value;
    End;

  Procedure TXMLRPCClient.SetSSLKeyFile(Const Value: String);
    Begin
      _SSLKeyFile := Value;
    End;

  Function TXMLRPCClient.GetFunctionIndex(Const Func: String): Integer;
    Begin
      Result := 0;
      If Func = '' Then Exit;
      While Result < Length(_Functions) do Begin
        If SameText(_Functions[Result].Name, Func) Then Exit;
        Inc(Result);
      End;
      Raise EXMLException.CreateFmt('function "%s" does not exists', [Func]);
    End;

  Function TXMLRPCClient.GetActiveFunction: String;
    Begin
      Result := _Functions[0].Name;
    End;

  Procedure TXMLRPCClient.SetActiveFunction(Const Func: String);
    Var i:  Integer;
      Temp: TXMLRPCFunction;

    Begin
      i := GetFunctionIndex(Func);
      Temp          := _Functions[0];
      _Functions[0] := _Functions[i];
      _Functions[i] := Temp;
    End;

  Function TXMLRPCClient.GetRequestXML(Func: String = ''): TXMLFile;
    Var i:  Integer;

    Begin
      i := GetFunctionIndex(Func);
      Result := _Functions[i].Request;
    End;

  Function TXMLRPCClient.GetResponseXML(Func: String = ''): TXMLFile;
    Var i:  Integer;

    Begin
      i := GetFunctionIndex(Func);
      Result := _Functions[i].Response;
    End;

  Constructor TXMLRPCClient.Create;
    Begin
      _TCPClient       := nil;
      _HTTPClient      := nil;
      _UserAgent       := 'himXML-RPC/1.0.0 (WinNT)';
      _TimeOut         := 30000;
      _IPVersion       := Id_IPv4;
      _Host            := '';
      _Port            := 80;
      _URI             := '/RPC2';
      _ProxyServer     := '';
      _ProxyPort       := 0;
      _ProxyUserName   := '';
      _ProxyPassword   := '';
      _SSLRootCertFile := '';
      _SSLCertFile     := '';
      _SSLKeyFile      := '';
      _Functions       := nil;
    End;

  Destructor TXMLRPCClient.Destroy;
    Begin
      Close;
      If Assigned(_TCPClient)  Then _TCPClient.Free;
      If Assigned(_HTTPClient) Then _HTTPClient.Free;
    End;

  Procedure TXMLRPCClient.Open(Const Host: String = ''; Port: Word = 0; TimeOut: Integer = 0);
    Begin
      Close;

      If Host    <> '' Then _Host    := Host;
      If Port    <> 0  Then _Port    := Port;
      If TimeOut <> 0  Then _TimeOut := TimeOut;

      If not Assigned(_TCPClient) Then _TCPClient := TIdTCPClient.Create(nil);

      _TCPClient.ConnectTimeout := TimeOut;
      _TCPClient.ReadTimeout    := TimeOut;

      _TCPClient.IPVersion := _IPVersion;
      _TCPClient.Host      := Host;
      _TCPClient.Port      := Port;

      _TCPClient.Connect;
    End;

  Function TXMLRPCClient.Execute(Const Func: String = ''; Const EndPoint: String = ''): Boolean;
    Var S: String;
      i:   Integer;

    Begin
      If not Assigned(_TCPClient) or not _TCPClient.Connected Then
        Raise EIdNotConnected.Create(RSNotConnected);
      i := GetFunctionIndex(Func);

      If EndPoint <> '' Then _URI := EndPoint;

      Try
        _Functions[i].ResponseHeader := nil;
        _Functions[i].Request.SaveToXML(S);

        _TCPClient.IOHandler.WriteBufferClear;
        _TCPClient.IOHandler.WriteBufferOpen;
        Try
          _TCPClient.IOHandler.WriteLn('GET ' + _URI + ' HTTP/1.0');
          _TCPClient.IOHandler.WriteLn('User-Agent: ' + _UserAgent);
          _TCPClient.IOHandler.WriteLn('Host: ' + _Host);
          _TCPClient.IOHandler.WriteLn('Content-Type: text/xml');
          _TCPClient.IOHandler.WriteLn('Content-length: ' + IntToStr(Length(S)));
          _TCPClient.IOHandler.WriteLn;
          _TCPClient.IOHandler.Write(S);
          _TCPClient.IOHandler.WriteBufferFlush;
          _TCPClient.IOHandler.WriteBufferClose;
        Except
          _TCPClient.IOHandler.WriteBufferCancel;
          Raise;
        End;

        Repeat
          S := _TCPClient.IOHandler.ReadLn{$IF Declared(UnicodeString)}(enUTF8){$IFEND};
          If Trim(S) = '' Then Break;
          i := Length(_Functions[i].ResponseHeader);
          SetLength(_Functions[i].ResponseHeader, i + 1);
          _Functions[i].ResponseHeader[i] := S;
        Until not _TCPClient.Connected;
        S := _TCPClient.IOHandler.AllData{$IF Declared(UnicodeString)}(enUTF8){$IFEND};
        Try
          _Functions[i].Response.LoadFromXML(S);
        Except
          On E: Exception do Begin
            E.Message := E.Message + #13#10#13#10 + S;
            Raise E;
          End;
        End;
        Result := Trim(S) <> '';
        If Assigned(_Functions[i].ResponseHeader) Then
          S := _Functions[i].ResponseHeader[0] Else S := '';
        S := Trim(Copy(S, Pos(' ', S) + 1, Length(S)));
        S := Trim(Copy(S, 1, Pos(' ', S) - 1));
        Result := Result and (S = '200');
      Except
        On E: Exception do Begin
          SetRPCError(i, -1, E.Message);
          Raise;
        End;
      End;
    End;

  Procedure TXMLRPCClient.Close;
    Begin
      If Assigned(_TCPClient) and _TCPClient.Connected Then
        _TCPClient.Disconnect;
    End;

  Function TXMLRPCClient.Send(Const Func: String = ''; Const EndPoint: String = '';
      Const Host: String = ''; Port: Word = 0; TimeOut: Integer = 0): Boolean;

    Begin
      Open(Host, Port, TimeOut);
      Try
        Result := Execute(Func, EndPoint);
      Finally
        Close;
      End;
    End;

  Function TXMLRPCClient.SecureSend(Const Func: String = ''; Const EndPoint: String = '';
      Const Host: String = ''; Port: Word = 0; TimeOut: Integer = 0): Boolean;

    Begin

    End;

  Function TXMLRPCClient.ListFunktions: TStringDynArray;
    Begin

    End;

End.

