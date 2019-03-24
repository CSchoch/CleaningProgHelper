Unit himXML_XPath;

Interface

  (****************************************************** )
  (                                                       )
  (  Copyright (c) 1997-2009 FNS Enterprize's™            )
  (                2003-2009 himitsu @ Delphi-PRAXiS      )
  (                                                       )
  (  Description   allows the use of XPath within himXML  )
  (  Filename      himXML_XPath.pas                       )
  (  Version       v0.99                                  )
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

  Uses Types, SysUtils, Classes, himXML_Lang, himXML;

  {$DEFINE CMarker_himXMLXPath_Init}
  {$DEFINE CMarker_himXMLLang}
  {$DEFINE CMarker_himXML}
  {$INCLUDE himXMLCheck.inc}

  Type TXPathText = Class(TXMLInnerNode)
    Protected
      _Parent: TXMLNode;
      _Name:   TWideString;
      _Text:   Variant;
      _Text_S: TWideString;
    Public
      Property Parent: TXMLNode    Read _Parent;
      Property Name:   TWideString Read _Name;     // if .Name = '' then this is a text from a node
      Property Text:   Variant     Read _Text;     // if .Name > '' then this is a text from a attribute
      Property Text_S: TWideString Read _Text_S;
    End;

    TXPathNodeList = Class(TXMLInnerNode)
    Protected
      _Parent: TXMLNode;
      _Items:  packed Array of TXMLInnerNode;
      Function GetItem(Index: Integer): TXMLInnerNode;
      Function GetNode(Index: Integer): TXMLNode;
      Function GetText(Index: Integer): TXPathText;
    Public
      Constructor Create(Parent: TXMLNode);
      Destructor  Destroy; Override;
      Property Parent: TXMLNode Read _Parent;
      Function Count:  Integer; Inline;
      Property Item  [Index: Integer]: TXMLInnerNode Read GetItem; Default;
      Property asNode[Index: Integer]: TXMLNode      Read GetNode;
      Property asText[Index: Integer]: TXPathText    Read GetText;
    End;

    TXMLFile_Helper = Class Helper for TXMLFile
    Protected
      Function GetXPath  (Const Name: TWideString): TXMLInnerNode;
      Function GetNFXPath(Const Name: TWideString): TXMLInnerNode;
    Public
      Property XPath  [Const Name: TWideString]: TXMLInnerNode Read GetXPath;
      Property XPathNF[Const Name: TWideString]: TXMLInnerNode Read GetNFXPath;
    End;

    TXMLNodeList_Helper = Class Helper for TXMLNodeList
    Protected
      Function GetXPath  (Const Name: TWideString): TXMLInnerNode;
      Function GetNFXPath(Const Name: TWideString): TXMLInnerNode;
    Public
      Property XPath  [Const Name: TWideString]: TXMLInnerNode Read GetXPath;
      Property XPathNF[Const Name: TWideString]: TXMLInnerNode Read GetNFXPath;
    End;

    TXMLNode_Helper = Class Helper for TXMLNode
    Protected
      Procedure _XPath    (Out Result: TXMLInnerNode; Name: TWideString; NF: Boolean);
      Function  GetXPath  (Const Name: TWideString): TXMLInnerNode;
      Function  GetNFXPath(Const Name: TWideString): TXMLInnerNode;
    Public
      Property XPath  [Const Name: TWideString]: TXMLInnerNode Read GetXPath;
      Property XPathNF[Const Name: TWideString]: TXMLInnerNode Read GetNFXPath;
    End;

    Var XPath_AlwaysAsList: Boolean = False;

    Procedure ClearXPathCache;

Implementation
  Var Cache: TThreadList;

  Constructor TXPathNodeList.Create(Parent: TXMLNode);
    Begin
      Inherited Create;
      _Parent := Parent;
      Cache.Add(Self);
    End;

  Destructor TXPathNodeList.Destroy;
    Begin
      Cache.Remove(Self);
      Inherited;
    End;

  Function TXPathNodeList.Count: Integer;
    {inline}

    Begin
      Result := Length(_Items);
    End;

  Function TXPathNodeList.GetItem(Index: Integer): TXMLInnerNode;
    Begin
      If (Index >= 0) and (Index < Length(_Items)) Then
        Result := _Items[Index] Else Result := nil;
    End;

  Function TXPathNodeList.GetNode(Index: Integer): TXMLNode;
    Begin
      If (Index >= 0) and (Index < Length(_Items)) Then
        Result := _Items[Index] as TXMLNode Else Result := nil;
    End;

  Function TXPathNodeList.GetText(Index: Integer): TXPathText;
    Begin
      If (Index >= 0) and (Index < Length(_Items)) Then
        Result := _Items[Index] as TXPathText Else Result := nil;
    End;

  Function TXMLFile_Helper.GetXPath(Const Name: TWideString): TXMLInnerNode;
    Begin
      RootNode._XPath(Result, Name, False);
    End;

  Function TXMLFile_Helper.GetNFXPath(Const Name: TWideString): TXMLInnerNode;
    Begin
      RootNode._XPath(Result, Name, True);
    End;

  Function TXMLNodeList_Helper.GetXPath(Const Name: TWideString): TXMLInnerNode;
    Begin
      Parent._XPath(Result, Name, False);
    End;

  Function TXMLNodeList_Helper.GetNFXPath(Const Name: TWideString): TXMLInnerNode;
    Begin
      Parent._XPath(Result, Name, True);
    End;

  Procedure TXMLNode_Helper._XPath(Out Result: TXMLInnerNode; Name: TWideString; NF: Boolean);
    (*Procedure Find(Var Result: TXPathNodeList; Node: TXMLNode; Name: TWideString; NF: Boolean);
      Var i, i2: Integer;
        S, S2:   TWideString;
        A:       TStringDynArray;
        B1, B2:  Boolean;

      Begin
        i := TXHelper.Pos(TXMLFile.PathDelimiter, Name);
        If i = 0 Then i := Length(Name) + 1;
        If (i = 1) and (Copy(Name, 1, 3) = '.' + TXMLFile.PathDelimiter + TXMLFile.PathDelimiter) Then Begin
          S := Copy(Name, 1, 3);
          Delete(Name, 1, 3);
        End Else If (i = 0) and (Copy(Name, 1, 2) = TXMLFile.PathDelimiter + TXMLFile.PathDelimiter) Then Begin
          S := Copy(Name, 1, 2);
          Delete(Name, 1, 2);
        End Else Begin
          S := Copy(Name, 1, i - 1);
          Delete(Name, 1, i);
        End;

        i := TXHelper.Pos('[', S);
        If i = 0 Then i := Length(Name) + 1;
        S2 := Copy(S, 1, i - 1);
        Delete(S, 1, i);

        If S = '' Then Exit;

        B1 := False;
        B2 := False;
        SetLength(A, 0);
        For i := 1 to Length(S2) do Begin
          i2 := High(A);
          Case S2[i] of
            '[', ']', '(', ')':
              If not (B1 or B2) Then Begin
                Inc(i2);
                SetLength(A, i2 + 2);
                A[i2] := S2[i];
              End Else A[i2] := A[i2] + S2[i];
            '"':  If B1 Then A[i2] := A[i2] + '"'  Else B2 := not B2;
            '''': If B2 Then A[i2] := A[i2] + '''' Else B1 := not B1;
            #0..' ': SetLength(A, i2 + 2);
            '<', '>', '=', '-', '+', '*', '!':
              If (S2[i] = '=') and (i2 >= 2) and (A[i2] = '')
                  and ((A[i2] = '!') or (A[i2] = '<') or (A[i2] = '>')) Then Begin
                Inc(i2);
                A[i2] := A[i2] + '=';
              End Else Begin
                Inc(i2);
                SetLength(A, i2 + 2);
                A[i2] := S2[i];
              End;
            Else

          End;
        End;

        If TXHelper.MatchText('child::*', S, False) Then Begin
          Delete(S, 1, 7);

        End Else If TXHelper.MatchText('parent::*', S, False) Then Begin
          Delete(S, 1, 8);

        End Else If TXHelper.MatchText('self::*', S, False) Then Begin
          Delete(S, 1, 6);

        End Else If TXHelper.MatchText('ancestor::*', S, False) Then Begin
          Delete(S, 1, 10);

        End Else If TXHelper.MatchText('ancestor-or-self::*', S, False) Then Begin
          Delete(S, 1, 18);

        End Else If TXHelper.MatchText('descendant::*', S, False) Then Begin
          Delete(S, 1, 12);

        End Else If TXHelper.MatchText('descendant-or-self::*', S, False) Then Begin
          Delete(S, 1, 20);

        End Else If TXHelper.MatchText('following::*', S, False) Then Begin
          Delete(S, 1, 11);

        End Else If TXHelper.MatchText('following-sibling::*', S, False) Then Begin
          Delete(S, 1, 19);

        End Else If TXHelper.MatchText('preceding::*', S, False) Then Begin
          Delete(S, 1, 11);

        End Else If TXHelper.MatchText('preceding-sibling::*', S, False) Then Begin
          Delete(S, 1, 19);

        End Else If TXHelper.MatchText('attribute::*', S, False) Then Begin
          Delete(S, 1, 11);

        End Else If S = '.' Then Begin

        End Else If S = '..' Then Begin

        End Else If S = '.' + TXMLFile.PathDelimiter + TXMLFile.PathDelimiter Then Begin

        End Else If S = TXMLFile.PathDelimiter + TXMLFile.PathDelimiter Then Begin

        End Else Begin

        End;

child 	direkt untergeordnete Knoten 	./
parent 	der direkt übergeordnete Elternknoten 	..
self 	der Kontextknoten selbst (nützlich für zusätzliche Bedingungen) 	.
ancestor 	übergeordnete Knoten
ancestor-or-self 	übergeordnete Knoten inklusive des Kontextknotens
descendant 	untergeordnete Knoten 	.//
descendant-or-self 	untergeordnete Knoten inklusive des Kontextknotens
following 	nachfolgend im XML-Dokument (ohne untergeordnete Knoten)
following-sibling 	wie following, und vom gleichen parent stammend
preceding 	vorhergehend im XML-Dokument ohne übergeordnete Knoten
preceding-sibling 	wie preceding, und vom gleichen parent stammend
attribute 	Attributknoten 	@

      End;

    Procedure Loop(Var Result: TXPathNodeList; Node: TXMLNode; Name: TWideString; NF: Boolean);
      Var i: Integer;

      Begin
        Find(Result, Node, Name, NF);
        If NF Then Begin
          For i := 0 to Node.Nodes.CountNF do
            Loop(Result, Node.Nodes.NodeNF[i], Name, NF);
        End Else
          For i := 0 to Node.Nodes.Count do
            Loop(Result, Node.Nodes.Node[i], Name, NF);
      End;

    Var L:       Boolean;
      i:         Integer;
      B, B1, B2: Boolean;
      S:         TWideString;
      Node:      TXMLNode;
      ResL:      TXPathNodeList absolute Result;*)

    Begin
      (*If TXMLFile.PathDelimiter = '\' Then
        While True do Begin
          i := TXHelper.Pos('/', Name);
          If i = 0 Then Break;
          Name[i] := '\';
        End;
      ResL := TXPathNodeList.Create(Parent);
      Try
        While True do Begin
          L := False;
          i := 1;

          i := TXHelper.Pos('|', Name);
          If i = 0 Then i := Length(Name) + 1;
          S := Copy(Name, 1, i - 1);
          System.Delete(Name, 1, i);
          If S = '' Then Break;
          If S[1] = TXMLFile.PathDelimiter Then Begin
            If (Length(S) < 2) or (S[2] <> TXMLFile.PathDelimiter) Then Begin
              System.Delete(S, 1, 2);
              L := True;
            End Else System.Delete(S, 1, 1);
            If not Assigned(Owner) Then Begin
              Node := Self;
              While Assigned(Node.Parent) do Node := Node.Parent;
            End Else Node := Owner.RootNode;
          End Else Node := Self;
          If L Then Loop(ResL, Node, Name, NF) Else Find(ResL, Node, Name, NF);
        End;
        If Length(ResL._Nodes) = 1 Then Begin
          i := Integer(ResL[0]);
          FreeAndNil(ResL);
          Result := TXMLInnerNode(i);
        End Else If not Assigned(ResL._Nodes) Then FreeAndNil(ResL);
      Except
        ResL.Free;
        Raise;
      End;*)
    End;

  Function TXMLNode_Helper.GetXPath(Const Name: TWideString): TXMLInnerNode;
    Begin
      _XPath(Result, Name, False);
    End;

  Function TXMLNode_Helper.GetNFXPath(Const Name: TWideString): TXMLInnerNode;
    Begin
      _XPath(Result, Name, True);
    End;

  Procedure ClearXPathCache;
    Begin
      Cache.Clear;
    End;

Initialization
  Cache := TThreadList.Create;

Finalization
  Cache.Free;

End.

