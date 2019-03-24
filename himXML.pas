Unit himXML;

Interface

  (************************************************** )
  (                                                   )
  (  Copyright (c) 1997-2009 FNS Enterprize's™        )
  (                2003-2009 himitsu @ Delphi-PRAXiS  )
  (                                                   )
  (  Description   xml document parser ans writer     )
  (  Filename      himXML.pas                         )
  (  Version       v0.99d                             )
  (  Date          12.01.2009                         )
  (  Project       himXML [himix ML]                  )
  (  Info / Help   see "help" region                  )
  (  Support       delphipraxis.net/topic153934.html  )
  (                                                   )
  (  License       MPL v1.1 , GPL v3.0 or LGPL v3.0   )
  (                                                   )
  (  Donation      www.FNSE.de/Spenden                )
  (                                                   )
  (***************************************************)

  // interface regions:       license, help, options, definitions, definitions (internal),
  //                          interfaces and constants (forwarding)
  // implementation regions:  other, TXReader, TXWriter, TXMLFile, TXMLFile - global,
  //                          TXMLNodeList, TXMLAttributes,
  //                          TSAXFile, TSAXNode and initialization

  {$WARNINGS OFF}
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
  {$IF X}{$REGION 'help'}{$IFEND}
  //
  // Conditional Defines:
  //
  //    options for main project    -
  //       hxDisableUnicodeString   since Delphi 2009 - if this is defined then WideString is used instead of UnicodeString
  //       hxExcludeClassesUnit     if this is defined then TStream, THandleStream and TResourceStream may be not used
  //       hxExcludeContnrsUnit     if this is defined then TObjectList, TComponentList and TClassList can not serialized
  //       hxExcludeTIndex          use Variant instead of small TIndex an not use overloadet default properties
  //       hxDebugable              compile the main units with debug informations
  //
  //    define this switches in the delphi project options, if this are required
  //
  //       D7    Menü > Projekt > Optionen... > Verziechnisse/Bedingungen > Definition
  //       D09   Menü > Projekt > Optionen... > Delphi-Compiler > Bedingungen
  //
  //
  //
  // List of Classes:
  //
  //    TXReader         simple xml file reader
  //    TXWriter         simple xml file creater
  //
  //    TXMLFile         xml dom parser (Document Object Model)
  //    TXMLNode         xml node for dom parser
  //    TXMLNodeList     node list
  //    TXMLAttributes   list of node attributes
  //
  //    TSAXFile         sax reader (Simple Api for Xml)
  //    TSAXNode         temoprary level node for sax reader
  //
  //
  //
  // EXMLException                       type of exceptions that create by this classes
  //
  // TXMLFile                            root class
  //    LibVersion                       -
  //
  //    DefaultOptions                   see TXMLOptions
  //    DefaultTextIndent                only ' ' or #9
  //    DefaultLineFeed                  only #13 and/or #10
  //    DefaultValueSeperator            '=' and ' '
  //    DefaultValueQuotation            '"' or ''''
  //    PathDelimiter                    '\' or '/'
  //
  //    Owner                            user defined value (TObject) not used in this component
  //
  //    Create                           parameter: see at .Owner
  //    Free                             -
  //
  //    Options                          see .DefaultOptions        or use XMLUseDefaultOptions
  //    TextIndent                       see .DefaultTextIndent     or use XMLUseDefault
  //    LineFeed                         see .DefaultLineFeed       or use XMLUseDefault
  //    ValueSeperator                   see .DefaultValueSeperator or use XMLUseDefault
  //    ValueQuotation                   see .DefaultValueQuotation or use XMLUseDefault
  //    ParsedSingleTags                 list of non marked closed tags for parsing (seperated with "|")
  //
  //    FileName                         file of file from that loadet the xml-data (.LoadFromFile) or to use for auto save (xoAutoSaveOnClose)
  //    Changed                          -
  //    LoadFromFile      SaveToFile     -
  //    LoadFromStream    SaveToStream   -
  //    LoadFromResource                 -
  //    LoadFromXML       SaveToXML      -
  //    asXML                            see at .LoadFromXML and .SaveToXML (encoding is always xeUTF8)
  //    ClearDocument                    delete all data and create a new file <?xml version="1.0" encoding="UTF-8" standalone="yes" ?><xml />
  //
  //    Version                          -
  //    Encoding                         -
  //    Standalone                       -
  //
  //    NodeCount    NodeCountNF         count of all nodes
  //    Nodes                            -
  //    RootNode                         access to the root node <abc /> of the xml file
  //
  //    Attribute                  (2)   alias for .RootNode.Attributes.Value     see at TXMLAttributes.Value
  //    Node         NodeNF        (1)     .RootNode.Nodes.Node{NF}                 TXMLNodeList.Node
  //    NodeList     NodeListNF    (1)     .RootNode.Nodes.NodeList{NF}             TXMLNodeList.NodeList
  //    FindNode     FindNodeNF    (1)     .RootNode.Nodes.FindNode{NF}             TXMLNodeList.FindNode
  //    FindNodes    FindNodesNF   (1)     .RootNode.Nodes.FindNodes{NF}            TXMLNodeList.FindNodes
  //    AddNode                    (1)     .RootNode.Nodes.Add                      TXMLNodeList.Add
  //
  //    Cryptors                         list of installes encryption functions
  //    SetCryptor                       set/delete the encryption function (delete: proc=nil)
  //    CryptProc                        set a new encryption functions oder delete it
  //    CryptData                        set the intitial values for data-parameter of enctption procedure
  //    CryptAttrName                    name of attribute that markes an node vor encryption (default: "hx:crypt" = cHimXmlNamespace + ":crypt")
  //    SetDefaultCryptor                -
  //
  //    OnNodeChange                     see TXMLNodeChangeEvent for states
  //    OnStatus                         see TXMLFileStatusEvent for states
  //
  //    _Lock                            is not used by this class
  //    _TryLock                           you can it use to make this class threadsave:
  //    _Unlock                            xml._Lock; try ... finally xml._Unlock; end;
  //    _isLocked                          if xml._TryLock then try ... finally xml._Unlock; end;
  //
  // TXMLNodeList                        list of nodes (sub nodes)
  //    Owner                            -
  //    Parent                           -
  //
  //    Create                           -
  //    Free                             -
  //
  //    FirstNode    FirstNodeNF         -
  //    NextNode     NextNodeNF          -
  //
  //    Count        CountNF             -
  //    Node         NodeNF        (1)   -
  //    NodeU        NodeUNF       (1)   see .Node but node always not created, whatever the state of xoNodeAutoCreate (.Owner.Options)
  //    NodeList     NodeListNF    (1)   -
  //    FindNode     FindNodeNF    (1)   -
  //    FindNodes    FindNodesNF   (1)   -
  //
  //    NodeCount    NodeCountNF         count of all subnodes
  //
  //    Add                        (1)   -
  //    Insert       InsertNF      (1)   -
  //    Remove       RemoveNF      (1)   -
  //    Delete       DeleteNF      (1)   -
  //    Clear                            -
  //
  //    IndexOf      IndexOfNF           -
  //    Exists       ExistsNF      (1)   -
  //
  //    CloneNode                        -
  //    CloneNodes                       -
  //
  //    Assign                           -
  //
  //    Sort                             see NodeSortProc
  //
  // TXMLNode                            node
  //    Owner                            -
  //    Parent                           -
  //    ParentList                       -
  //
  //    Create                           -
  //    Free                             -
  //
  //    Index        IndexNF             -
  //    Level                            -
  //
  //    NodeType                         -
  //
  //    FullPath                         get the path of this node
  //    Name                             -
  //    Namespace                        get the namespace of .Name
  //    NameOnly                         get the name without namespace
  //
  //    Attributes                       -
  //
  //    Text                             as Variant
  //    Text_S                           as TWideString
  //    Text_D                           as TWideString and saved as CDATA if data require this
  //    Text_Base64                      -
  //    Text_Base64w                     -
  //    GetBinaryLen                     size of data
  //    GetBinaryData/SetBinaryData      read or write binary data as Base64
  //    XMLText                          -
  //    Serialize/DeSerialize            -
  //
  //    isTextNode                       -
  //    hasCDATA                         -
  //    asCDATA                          -
  //
  //    Crypt                            access to the value of encryption attribute (see at TXMLFile.CryptAttrName)
  //
  //    Nodes                            -
  //
  //    Attribute                  (2)   alias for .RootNode.Attributes.Value     see at TXMLAttributes.Value
  //    Node         NodeNF        (1)     .RootNode.Nodes.Node{NF}                 TXMLNodeList.Node
  //    NodeList     NodeListNF    (1)     .RootNode.Nodes.NodeList{NF}             TXMLNodeList.NodeList
  //    FindNode     FindNodeNF    (1)     .RootNode.Nodes.FindNode{NF}             TXMLNodeList.FindNode
  //    FindNodes    FindNodesNF   (1)     .RootNode.Nodes.FindNodes{NF}            TXMLNodeList.FindNodes
  //    AddNode                    (1)     .RootNode.Nodes.Add                      TXMLNodeList.Add
  //
  //    DeclareNamespace                 declare an namespac in this node - if this namespace is also declared in this nodepath, the URI will also be changed
  //    FindNamespaceDecl                search the node who is declared a namespace with this URI in the akctual node path
  //    FindNamespaceURI                 search the URI of this namespace ("ns" or "ns:tag") in the actual node path
  //    NamespaceURI                     URI for namespace of this node
  //
  //    NextNode     NextNodeNF          -
  //
  // TXMLAttributes                      list of node attributes
  //    Owner                            -
  //    Parent                           -
  //
  //    Create                           -
  //    Free                             -
  //
  //    Count                            -
  //    Name                             -
  //    Namespace                        get the namespace of .Name
  //    NameOnly                         get the name without namespace
  //    Value                      (2)   -
  //    ValueList                  (2)   -
  //
  //    Add                        (2)   -
  //    Insert                     (2)   -
  //    Delete                     (2)   -
  //    Clear                            -
  //
  //    IndexOf                          -
  //    IndexOfCS                        -
  //    Exists                     (2)   -
  //
  //    CloneAttr                        -
  //
  //    Assign                           -
  //
  //    Sort                             see AttributeSortProc
  //
  // ISAXFile/TSAXFile                   -
  //    LibVersion                       -
  //
  //    Owner                            -
  //
  //    Open                             -
  //    FileName                         -
  //    Close                            -
  //
  //    Options
  //    Version                          -
  //    Encoding                         -
  //    Standalone                       -
  //
  //    Levels                           -
  //    Level                            -
  //
  //    Parse                            -
  //
  //    Progress                         -
  //    NodesCount                       -
  //    MaxLevels                        -
  //
  // ISAXNode/TSAXNode                   -
  //    NodeType                         -
  //
  //    Level                            -
  //    FullPath                         -
  //    Name                             -
  //    Namespace                        -
  //    NameOnly                         -
  //
  //    AttributeCount                   -
  //    AttributeName                    -
  //    Attribute                        -
  //
  //    isOpenedTag                      -
  //
  //    Text                             -
  //    hasCDATA                         -
  //    SubNodes                         -
  //
  // TXMLOptions                         -
  //    xoDontWriteBOM                   don't write the BOM (byte order mark)
  //    xoChangeInvalidChars             -
  //    xoAllowUnknownText               -
  //    xoNormalizeText                  -
  //    xoCaseSensitive                  -
  //    xoHideInstructionNodes           don't show nodes with .NodeType=xtInstruction
  //    xoHideTypedefNodes               don't show nodes with .NodeType=xtTypedef
  //    xoHideCDataNodes                 don't show nodes with .NodeType=xtCData
  //    xoHideCommentNodes               don't show nodes with .NodeType=xtComment
  //    xoHideUnknownNodes               don't show nodes with .NodeType=xtUnknown
  //    xoNodeAutoCreate                 -
  //    xoNodeAutoIndent                 -
  //    xoCDataNotAutoIndent             -
  //    xoFullEmptyElements              -
  //    xoAutoSaveOnClose                -
  //
  // TXMLEncoding                        -
  //    xeUTF7                     (3)   UTF-7             Universal Alphabet  (7 bit Unicode-Transformation-Format-codierung)
  //    xeUTF8                           UTF-8             Universal Alphabet  (8 bit Unicode-Transformation-Format-codierung)
  //  //xeUTF16                          UTF-16            Universal Alphabet  (16 bit Unicode-Transformation-Format-codierung)
  //    xeUnicode                        ISO-10646-UCS-2   Universal Alphabet  (little endian 2 byte Unicode)
  //    xeUnicodeBE                                        Universal Alphabet  (big endian 2 byte Unicode)
  //    xeIso8859_1                      ISO-8859-1        Western Alphabet    (ISO)
  //    xeIso8859_2                      ISO-8859-2        Central European Alphabet (ISO)
  //    xeIso8859_3                      ISO-8859-3        Latin 3 Alphabet    (ISO)
  //    xeIso8859_4                      ISO-8859-4        Baltic Alphabet     (ISO)
  //    xeIso8859_5                      ISO-8859-5        Cyrillic Alphabet   (ISO)
  //    xeIso8859_6                      ISO-8859-6        Arabic Alphabet     (ISO)
  //    xeIso8859_7                      ISO-8859-7        Greek Alphabet      (ISO)
  //    xeIso8859_8                      ISO-8859-8        Hebrew Alphabet     (ISO)
  //    xeIso8859_9                      ISO-8859-9        Turkish Alphabet    (ISO)
  //    xeIso2022Jp                (3)   ISO-2022-JP       Japanese            (JIS)
  //    xeEucJp                    (3)   EUC-JP            Japanese            (EUC)
  //    xeShiftJis                       SHIFT-JIS         Japanese            (Shift-JIS)
  //    xeWindows1250                    WINDOWS-1250      Central European Alphabet (Windows)
  //    xeWindows1251                    WINDOWS-1251      Cyrillic Alphabet   (Windows)
  //    xeWindows1252                    WINDOWS-1252      Western Alphabet    (Windows)
  //    xeWindows1253                    WINDOWS-1253      Greek Alphabet      (Windows)
  //    xeWindows1254                    WINDOWS-1254      Turkish Alphabet    (Windows)
  //    xeWindows1255                    WINDOWS-1255      Hebrew Alphabet     (Windows)
  //    xeWindows1256                    WINDOWS-1256      Arabic Alphabet     (Windows)
  //    xeWindows1257                    WINDOWS-1257      Baltic Alphabet     (Windows)
  //    xeWindows1258                    WINDOWS-1258      Vietnamese Alphabet (Windows)
  //
  // TXMLNodeChangeEvent                 -
  //    Node                             xml node to be changed
  //    CType = xcNodeTypeChanged        -
  //            xcNameChanged            -
  //            xcAttributesChanged      -
  //            xcTextChanged            -
  //          //xcChildNodesChanged      -
  //            xcAddetNode              -
  //            xcBeforeDeleteNode       -
  //
  // TXMLFileStatusEvent                 -
  //    XML                              -
  //    SType = xsLoad                   State = progress in percent*1000
  //            xsLoadEnd                State = processed data size in KB
  //            xsSave                   State = saved data size in KB
  //            xsSaveEnd                State = saved data size in KB
  //            xsBeforeSaveNode         TXMLNode(State) = node to be stored
  //            xsBeforeDestroy          State = 0
  //    State                            see at SType
  //
  // TXMLNodeType                        -
  //    xtInstruction                    <?name attributes ?>
  //    xtTypedef                        <!name text>  or  <!name text...[...text]>
  //    xtElement                        <name attributes />  or  <name attributes>text or subnodes</name>
  //    xtCData       (unnamed)          <![CDATA[text]]>
  //    xtComment     (unnamed)          <!--text-->
  //    xtUnknown     (unnamed)          text
  //
  //
  // TXMLSerializeOptions                -
  //    xsSortProperties                 -
  //    xsDefaultProperties              -
  //    xsNonStoredProperties            -
  //    xsSaveClassType                  -
  //    xsSavePropertyInfos              -
  //
  // SerializeProc
  //    Function SerializeProc(C: TObject; Const PropertyName: TWideString; NodeList: TXMLNodeList): Boolean;
  //      Begin
  //
  //      End;
  //
  // DesrializeProc
  //    Function DeserializeProc(C: TObject; Const PropertyName: TWideString; Node: TXMLNode): Boolean;
  //      Begin
  //
  //      End;
  //
  //  ClassCreateProc
  //    Function ClassCreateProc(Const ClassName: TWideString; Parent: TObject; Var C: TObject): Boolean;
  //      Begin
  //
  //      End;
  //
  // NodeSortProc
  //    Function SortProc(Node1, Node2: TXMLNode): TValueRelationship;
  //      Begin
  //        If {Node1} = {Node2} Then Result := 0
  //        Else If {Node1} < {Node2} Then Result := -1
  //        Else (*If {Node1} > {Node2} Then*) Result := 1;
  //      End;
  //
  // AttributeSortProc
  //    if SortProc ist nil, wenn the default sort procedure is used (sort by value name)
  //
  //    Function SortProc(Attributes: TXMLAttributes; Index1, Index2: Integer): TValueRelationship;
  //      Begin
  //        If {Attributes[Index1]} = {Attributes[Index2]} Then Result := 0
  //        Else If {Attributes[Index1]} < {Attributes[Index2]} Then Result := -1
  //        Else (*If {Attributes[Index1]} > {Attributes[Index2]} Then*) Result := 1;
  //      End;
  //
  //
  //
  // (1)  node names allowed paths, attributes and an index
  //         "{\}{.\}{..\}{node...\}{nodeName}{>attr=value{>attr=value{...}}}{[index]}"
  //
  //         Node['\..\node']                       Owner.RootNode.Parent.Node['node']  aka  Owner.Nodes['node']
  //         Node['\node']                          Owner.RootNode.Node['node']  or  {first ParentNodeList}.Node['node']
  //         Node['.\node']                         {Self.}Node['node']
  //         Node['..\node']                        Parent.Node['node']
  //         Node['node1\node2']                    Node['node1'].Node['node2']
  //         Node['node>attr=value']                Node['node'] with Attributes['attr']='value'
  //         Node['node>attr=value>attr2=value2']   Node['node'] with Attributes['attr']='value' and Attributes['attr2']='value2'
  //         Node['node[3]']                        NodeList['node'][3]
  //         Node['[3]']                            Node[3]
  //         Node['>attr=value']                    first of Node.Nodes with Attributes['attr']='value'
  //         Node['>attr=value[3]']                 3rd of Node.Nodes with Attributes['attr']='value'
  //         Node['*:node']                         ignore namespace
  //         Node['name:*']                         first/all nodes with this namespace
  //         Node['#name']                          same as FindNode['name']
  //         Node['#name>attr=value']               same as FindNode['name>attr=value']
  //         Node['#name1\name2']                   same as FindNode['name1'].Node['name2']
  //         Node['name1\#name2']                   same as Node['name1'].FindNode['name2']
  //
  //         Node['node1[2]\node2>attr=value[3]']   NodeList['node1'][2].NodeList['node2'][3] with Attributes['attr']='value'
  //
  //         "#" and "[index]" are not allowed as NodeName in NodeList and NodeListNF,
  //         but this is allowed as path for this property and functions.
  //         And this are only for read operations and not for Add, Insert, Remove or Delete.
  //
  // (2)  attribut names allowed paths - see at (1)
  //         "{nodePath}\attributeName"
  //
  //         Attribute['node\attr']                 Node['node'].Attribute['attr']
  //
  // (3)  this encoding can also used to save - load is not suported
  //
  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'options'}{$IFEND}

    Uses Types, Windows, {$IFNDEF hxExcludeSysutilsUnit} SysUtils, Variants, TypInfo, {$ENDIF}
      {$IFNDEF hxExcludeClassesUnit} RTLConsts, Classes, {$ENDIF}
      {$IFNDEF hxExcludeContnrsUnit} Contnrs, {$ENDIF}
      himXML_Lang;

    {******* user defined options *****************************************************************}

    Const FileBufferSize      = 262144;
      FileBufferSize_Overflow = 128;

    {**********************************************************************************************}

    {$DEFINE CMarker_himXML_Init}
    {$INCLUDE himXMLCheck.inc}

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'definitions'}{$IFEND}

    {***** base definitions ***********************************************************************}

    Type {$IF not Declared(PUInt64)}    PUInt64       = ^UInt64;         {$IFEND}
      {$IF not Declared(RawByteString)} RawByteString = Type AnsiString; {$IFEND}
      {$IFDEF hxDisableUnicodeString}
        TWideString         = WideString;
        TWideStringDynArray = Types.TWideStringDynArray;
      {$ELSE}
        TWideString         = UnicodeString;
        TWideStringDynArray = {$IF Declared(TUnicodeStringDynArray)}TUnicodeStringDynArray{$ELSE}Array of UnicodeString{$IFEND};
      {$ENDIF}
      {$IFDEF hxExcludeSysutilsUnit}
//        ExpandFileName = String;
        Int64Rec = Packed Record
          Lo, Hi: Cardinal;
        End;
        Exception = Class(TObject)
        Private
//          FMessage: string;
//          FHelpContext: Integer;
//          FInnerException: Exception;
//          FStackInfo: Pointer;
//          FAcquireInnerException: Boolean;
        Protected
//          procedure SetInnerException;
//          procedure SetStackInfo(AStackInfo: Pointer);
//          function GetStackTrace: string;
        Public
//          constructor Create(const Msg: string);
//          constructor CreateFmt(const Msg: string; const Args: array of const);
//          constructor CreateRes(Ident: Integer); overload;
//          constructor CreateRes(ResStringRec: PResStringRec); overload;
//          constructor CreateResFmt(Ident: Integer; const Args: array of const); overload;
//          constructor CreateResFmt(ResStringRec: PResStringRec; const Args: array of const); overload;
//          constructor CreateHelp(const Msg: string; AHelpContext: Integer);
//          constructor CreateFmtHelp(const Msg: string; const Args: array of const;
//            AHelpContext: Integer);
//          constructor CreateResHelp(Ident: Integer; AHelpContext: Integer); overload;
//          constructor CreateResHelp(ResStringRec: PResStringRec; AHelpContext: Integer); overload;
//          constructor CreateResFmtHelp(ResStringRec: PResStringRec; const Args: array of const;
//            AHelpContext: Integer); overload;
//          constructor CreateResFmtHelp(Ident: Integer; const Args: array of const;
//            AHelpContext: Integer); overload;
//          destructor Destroy; override;
//          function GetBaseException: Exception; virtual;
//          function ToString: string; override;
//          property BaseException: Exception read GetBaseException;
//          property HelpContext: Integer read FHelpContext write FHelpContext;
//          property InnerException: Exception read FInnerException;
//          property Message: string read FMessage write FMessage;
//          property StackTrace: string read GetStackTrace;
//          property StackInfo: Pointer read FStackInfo;
        End;
      {$ENDIF}

      TIndex = {$IFNDEF hxExcludeTIndex}Record
        ValueType:   (vtIntValue, vtStringValue);
        IntValue:    Integer;
        StringValue: TWideString;
        Class Operator Implicit(      Value: Integer):     TIndex;
        Class Operator Implicit(Const Value: TWideString): TIndex;
      End{$ELSE}Variant{$ENDIF};

      {$IF DELPHI >= 2006}

        TAssocStringRec = Record
          Name:      TWideString;
          Value:     TWideString;
        Private
          NameHash:  LongWord;
        End;
        TAssocVariantRec = Record
          Name:      TWideString;
          Value:     Variant;
          RealIndex: Integer;
        Private
          NameHash:  LongWord;
        End;
        TInternalAssocStringArray  = Array of TAssocStringRec;
        TInternalAssocVariantArray = Array of TAssocVariantRec;

        TAssocStringArray = Record
        Private
          _Data:          TInternalAssocStringArray;
          _DataIndex:     Integer;
          _CaseSensitive: Boolean;
          _ExceptOnError: Boolean;
          _Tag:           Integer;

          Procedure SetCaseSensitive(                              Value: Boolean);
          Function  GetCount:                                             Integer;
          Function  GetName      (      Index:      Integer):             TWideString;
          Procedure SetName      (      Index:      Integer; Const Value: TWideString);
          Function  GetValue     (      Index:      Integer):             TWideString;
          Procedure SetValue     (      Index:      Integer; Const Value: TWideString);
          Function  GetNamedValue(Const Name:   TWideString):             TWideString;
          Procedure SetNamedValue(Const Name:   TWideString; Const Value: TWideString);
        Public
          Property  DoExceptionOnReadError:               Boolean     Read _ExceptOnError Write _ExceptOnError;
          Property  CaseSensitive:                        Boolean     Read _CaseSensitive Write SetCaseSensitive;
          Property  Count:                                Integer     Read GetCount;
          Property  Name     [      Index:      Integer]: TWideString Read GetName        Write SetName;
          Property  Value    [      Index:      Integer]: TWideString Read GetValue       Write SetValue;      Default;
          Property  Value    [Const Name:   TWideString]: TWideString Read GetNamedValue  Write SetNamedValue; Default;

          Procedure Clear;
          Procedure Add      (                Const Name, Value: TWideString);
          Procedure Insert   (Index: Integer; Const Name, Value: TWideString);
          Procedure Move     (        OldIndex, NewIndex:        Integer);
          Function  IndexOf  (                Const Name:        TWideString): Integer;
          Procedure Delete   (                     Index:        Integer);     Overload;
          Procedure Delete   (                Const Name:        TWideString); Overload;

          Procedure Reset;
          Function  Prev:    Boolean;
          Function  Current: TAssocStringRec;
          Function  Next:    Boolean;
          Procedure ToEnd;
          Property  Index:   Integer Read _DataIndex;

          Property  Tag: Integer Read _Tag Write _Tag;
        End;

        TAssocVariantArray = Record
        Private
          _Data:          TInternalAssocVariantArray;
          _DataIndex:     Integer;
          _CaseSensitive: Boolean;
          _ExceptOnError: Boolean;
          _Tag:           Integer;

          Procedure SetCaseSensitive(                              Value: Boolean);
          Function  GetCount:                                             Integer;
          Function  GetName      (      Index:      Integer):             TWideString;
          Procedure SetName      (      Index:      Integer; Const Value: TWideString);
          Function  GetValue     (      Index:      Integer):             Variant;
          Procedure SetValue     (      Index:      Integer; Const Value: Variant);
          Function  GetNamedValue(Const Name:   TWideString):             Variant;
          Procedure SetNamedValue(Const Name:   TWideString; Const Value: Variant);
          Function  GetRealIndex (Const IndexOrName: TIndex):             Integer;
          Procedure SetRealIndex (Const IndexOrName: TIndex;       Value: Integer);
        Public
          Property  DoExceptionOnReadError:               Boolean     Read _ExceptOnError Write _ExceptOnError;
          Property  CaseSensitive:                        Boolean     Read _CaseSensitive Write SetCaseSensitive;
          Property  Count:                                Integer     Read GetCount;
          Property  Name     [      Index:      Integer]: TWideString Read GetName        Write SetName;
          Property  Value    [      Index:      Integer]: Variant     Read GetValue       Write SetValue;      Default;
          Property  Value    [Const Name:   TWideString]: Variant     Read GetNamedValue  Write SetNamedValue; Default;
          Property  RealIndex[Const IndexOrName: TIndex]: Integer     Read GetRealIndex   Write SetRealIndex;

          Procedure Clear;
          Procedure Add      (                Const Name: TWideString; Const Value: Variant; RealIndex: Integer = 0);
          Procedure Insert   (Index: Integer; Const Name: TWideString; Const Value: Variant; RealIndex: Integer = 0);
          Procedure Move     (        OldIndex, NewIndex: Integer);
          Function  IndexOf  (                Const Name: TWideString): Integer;
          Procedure Delete   (                     Index: Integer);     Overload;
          Procedure Delete   (                Const Name: TWideString); Overload;

          Procedure Reset;
          Function  Prev:    Boolean;
          Function  Current: TAssocVariantRec;
          Function  Next:    Boolean;
          Procedure ToEnd;
          Property  Index:   Integer Read _DataIndex;

          Property  Tag: Integer Read _Tag Write _Tag;
        End;

      {$IFEND}

      TXMLFile                  = Class;
      TXMLInnerNode             = Class End;
      TXMLNode                  = Class;
      TXMLNodeArray             = packed Array of TXMLNode;
      TXMLNodeList              = Class;
      TXMLAttributes            = Class;
      TSAXFile                  = Class;
      TSAXNode                  = Class;
      TSAXNodeArray             = packed Array of TSAXNode;

      TXHelper                  = Class;
      TXReader                  = Class;
      TXWriter                  = Class;

    {***** open definitions ***********************************************************************}

      EXMLException             = Class(Exception)
                                    _Info: Array of Record
                                      ErrorClass:    TClass;
                                      FunctionsName: String;
                                      Message:       String;
                                    End;
                                    {$IF DELPHI >= 2006}
                                      Const MaxXMLErrStr = 50;
                                      Class Function Str(S: AnsiString;  MaxLen: Integer = MaxXMLErrStr): String; Overload;
                                      Class Function Str(S: TWideString; MaxLen: Integer = MaxXMLErrStr): String; Overload;
                                    {$ELSE}
                                      Class Function Str(S: AnsiString;  MaxLen: Integer = 50): String; Overload;
                                      Class Function Str(S: TWideString; MaxLen: Integer = 50): String; Overload;
                                    {$IFEND}
                                    Constructor Create(ErrorClass: TClass; Const FunctionsName: String;
                                      ResStringRec: PResStringRec; Const Args: Array of Const;
                                      PrevException: Exception = nil; ErrorCode: LongWord = ERROR_SUCCESS); Overload;
                                    Constructor Create(ErrorClass: TClass; Const FunctionsName: String;
                                      ResStringRec: PResStringRec; Const S: TWideString); Overload;
                                    Constructor Create(ErrorClass: TClass; Const FunctionsName: String;
                                      ResStringRec: PResStringRec; Const S: AnsiString);  Overload;
                                    Constructor Create(ErrorClass: TClass; Const FunctionsName: String;
                                      ResStringRec: PResStringRec; i: Integer = 0);       Overload;
                                 End;
      TXMLOption                = (xoDontWriteBOM, xoChangeInvalidChars, xoAllowUnknownText, xoNormalizeText, xoWrapLongLines, xoCaseSensitive,
                                    xoHideInstructionNodes, xoHideTypedefNodes, xoHideCDataNodes, xoHideCommentNodes, xoHideUnknownNodes,
                                    xoNodeAutoCreate, xoNodeAutoIndent, xoCDataNotAutoIndent, xoFullEmptyElements, xoAutoSaveOnClose,
                                    xo_IgnoreEncoding, xo_useDefault);
      TXMLOptions               = Set of TXMLOption;
      TXMLVersion               = (xvXML10, xvXML11);
      TXMLEncoding              = (xeUTF7, xeUTF8, {xeUTF16,} xeUnicode, xeUnicodeBE, xeIso8859_1, xeIso8859_2, xeIso8859_3,
                                    xeIso8859_4, xeIso8859_5, xeIso8859_6, xeIso8859_7, xeIso8859_8, xeIso8859_9,
                                    xeIso2022Jp, xeEucJp, xeShiftJis, xeWindows1250, xeWindows1251, xeWindows1252,
                                    xeWindows1253, xeWindows1254, xeWindows1255, xeWindows1256, xeWindows1257, xeWindows1258);
      TXMLNodeOption            = (xoAttrIndent, xoTextIndent);  // only used if xoNodeAutoIndent are set
      TXMLNodeOptions           = Set of TXMLNodeOption;
      TXMLNodeChangeType        = (xcNodeTypeChanged, xcNameChanged, xcAttributesChanged, xcTextChanged, {xcChildNodesChanged,} xcAddetNode, xcBeforeDeleteNode);
      TXMLNodeChangeEvent       = Procedure(Node: TXMLNode; CType: TXMLNodeChangeType) of Object;
      TXMLFileStatus            = (xsLoad, xsLoadEnd, xsSave, xsSaveEnd, xsBeforeDestroy);
      TXMLFileStatusEvent       = Procedure(XML: TXMLFile; SType: TXMLFileStatus; State: Integer) of Object;
      TXMLExceptionEvent        = Procedure(Owner: TObject; E: Exception; Var ShowError: Boolean) of Object;
      TXMLNodeType              = (xtInstruction, xtTypedef, xtElement, xtCData, xtComment, xtUnknown);
      TXMLNodeTypes             = Set of TXMLNodeType;
      {$IFNDEF hxExcludeSysutilsUnit}
        TXMLSerializeOptions    = Set of (xsSortProperties, xsDefaultProperties, xsNonStoredProperties, xsNonSubComponents, xsTStringsObjects, xsSaveClassType, xsSavePropertyInfos);
        TXMLSerializeState      = (xqSaveObject, xqSaveProperty, xqCreateObject, xqCreateObjectC, xqLoadObject, xqLoadProperty, xqGetObject);
        TXMLSerializeQuery      = Record
                                  {$IF DELPHI >= 2006}
                                  Strict Private
                                    Function  GetVarObj:   TObject;
                                    Procedure SetVarObj(O: TObject);
                                  Public
                                  {$IFEND}
                                    Obj:             TObject;
                                    Node:            TXMLNode;
                                    PropertyName:    String;
                                    ClassName:       String;
                                    ClassType:       TClass;
                                    Parent:          TObject;
                                    ObjectName:      String;
                                    {$IF DELPHI >= 2006}
                                    _VarObj:         ^TObject;
                                    Property VarObj: TObject Read GetVarObj Write SetVarObj;  Var {...}
                                    {$ELSE}
                                    VarObj:          ^TObject;
                                    {$IFEND}
                                    SOptions:        TXMLSerializeOptions;
                                    SProc:           Procedure{TXMLSerializeProc};
                                    //Case Status: TXMLSerializeState of
                                    //  xqSaveObject:    ({in}  Obj:          TObject;
                                    //                    {out} Node:         TXMLNode);
                                    //  xqSaveProperty:  ({in}  Obj:          TObject;
                                    //                    {in}  PropertyName: String;
                                    //                    {out} Node:         TXMLNode);
                                    //  xqCreateObject:  ({in}  Parent:       TObject;
                                    //                    {in}  ClassName:    String;
                                    //                    {in}  ObjectName:   String:
                                    //                    {out} VarObj:       ^TObject);
                                    //  xqCreateObjectC: ({in}  Parent:       TObject;
                                    //                    {in}  ClassType:    TClass;
                                    //                    {in}  ObjectName:   String:
                                    //                    {out} VarObj:       ^TObject);
                                    //  xqLoadObject:    ({in}  Obj:          TObject;
                                    //                    {in}  Node:         TXMLNode);
                                    //  xqLoadProperty:  ({in}  Obj:          TObject;
                                    //                    {in}  PropertyName: String;
                                    //                    {in}  Node:         TXMLNode);
                                    //  xqGetObject:     ({in}  ClassName:    String;
                                    //                    {in}  ObjectName:   String;
                                    //                    {out} VarObj:       ^TObject);
                                  End;
        TXMLSerializeProcessing = (spProcessAll, spDoNotProcessCallback, spOnlyProcessCallback, spAbort);
        TXMLSerializeProc       = Procedure(Status: TXMLSerializeState; Const Data: TXMLSerializeQuery; Var Automatic: TXMLSerializeProcessing);
        TXMLSerializeRDataType  = (rtBoolean, rtByteBool, rtWordBool, rtLongBool, rtBOOL{*},
                                    rtByte, rtWord, rtLongWord, rtWord64, rtWord64BE{4}, rtWord64LE{4}, rtCardinal{*},
                                    rtShortInt, rtSmallInt, rtLongInt, rtInt64, rtInt64BE{4}, rtInt64LE{4}, rtInteger{*},
                                    rtSingle, rtDouble, rtExtended, rtReal{*}, rtCurrency, rtDateTime,
                                    rtAnsiCharArray, rtWideCharArray, rtCharArray{*}, rtUtf8String,
                                    rtShortString, rtAnsiString, rtWideString, rtUnicodeString, rtString{*},
                                    rtBinary, rtPointer{=rtDynBinary}, rtVariant, rtObject,
                                    rtRecord, rtArray, rtDynArray, rtDummy, rtAlign, rtSplit);
        TXMLSerializeTextFormat = (sfShort, sfFormat1, sfFormat2, sfFormat3, sfFormat4);
        TXMLSerializeRecordInfo = Class
                                  Protected
                                    _Parent:       TXMLSerializeRecordInfo;
                                    _Data: Array of Record
                                      Offset:      Integer;
                                      Size:        Integer;
                                      ElementSize: Integer;
                                      Name:        String;
                                      DType:       TXMLSerializeRDataType;
                                      Elements:    Integer;  // for rtAnsiCharArray, rtWideCharArray, rtCharArray, rtShortString, rtBinary, rtPointer, rtArray, rtDummy, rtAlign and rtSplit
                                      SubInfo:     TXMLSerializeRecordInfo; // for rtRecord, rtArray and rtDynArray
                                    End;
                                    _Align:        LongInt;
                                    _OffsetsOK:    Boolean;
                                    _Size:         LongInt;
                                    _ElementSize:  LongInt;
                                    _SaveInfos:    Boolean;
                                    _SOptions:     TXMLSerializeOptions;
                                    _SerProc:      TXMLSerializeProc;
                                    Procedure CheckOffsets (Intern: Boolean = False);
                                    Procedure CalcOffsets;
                                    Function  GetCount:                       Integer;
                                    Function  GetFullOffset(Index:  Integer): Integer;
                                    Function  GetOffset    (Index:  Integer): Integer;
                                    Function  GetSize      (Index:  Integer): Integer;
                                    Function  GetName      (Index:  Integer): String;
                                    Function  GetDType     (Index:  Integer): TXMLSerializeRDataType;
                                    Function  GetElements  (Index:  Integer): Integer;
                                    Function  GetSubInfo   (Index:  Integer): TXMLSerializeRecordInfo;
                                    Procedure Set_Global   (Source: TXMLSerializeRecordInfo);
                                    Procedure SetSaveInfos (Value:  Boolean);
                                    Procedure SetSOptions  (Value:  TXMLSerializeOptions);
                                    Procedure SetSerProc   (Value:  TXMLSerializeProc);
                                  Public
                                    Constructor Create;
                                    Destructor  Destroy; Override;
                                    Procedure SetAlign (     Align: LongInt = 4 {packed = 1});
                                    Function  Add      (      Name: String; DType: TXMLSerializeRDataType; Elements: Integer = 1): TXMLSerializeRecordInfo;
                                    Function  IndexOf  (Const Name: String):                  Integer; Overload;
                                    Function  IndexOf  (RecordInfo: TXMLSerializeRecordInfo): Integer; Overload;
                                    Procedure Assign   (RecordInfo: TXMLSerializeRecordInfo);
                                    Procedure Parse    (Const    S: String);
                                    Function  GetString(   DFormat: TXMLSerializeTextFormat = sfFormat1): String;
                                    Procedure DebugInfo({out}   SL: TStrings);
                                    Procedure Clear;

                                    Property  Count:                      Integer                 Read GetCount;
                                    Property  FullOffset[Index: Integer]: Integer                 Read GetFullOffset;
                                    Property  Offset    [Index: Integer]: Integer                 Read GetOffset;
                                    Property  Size      [Index: Integer]: Integer                 Read GetSize;
                                    Property  Name      [Index: Integer]: String                  Read GetName;
                                    Property  DType     [Index: Integer]: TXMLSerializeRDataType  Read GetDType;
                                    Property  Elements  [Index: Integer]: Integer                 Read GetElements;
                                    Property  SubInfo   [Index: Integer]: TXMLSerializeRecordInfo Read GetSubInfo;
                                    Property  Align:                      LongInt                 Read _Align;

                                    Property  SaveTypeInfos: Boolean           Read _SaveInfos  Write SetSaveInfos;

                                    // for (de)serialization of objects
                                    Property  SOptions:   TXMLSerializeOptions Read _SOptions   Write SetSOptions;
                                    Property  SerProc:    TXMLSerializeProc    Read _SerProc    Write SetSerProc;
                                  End;
        TXMLValueSerialize      = Function(Const Value: Variant;     PrivParam: Integer): TWideString;
        TXMLValueDeserialize    = Function(Const Value: TWideString; PrivParam: Integer): Variant;
        TXMLValueSerializeArray = Array of Record
                                    VType:        TTypeKind;
                                    Name:         AnsiString;
                                    SerialProc:   TXMLValueSerialize;
                                    DeserialProc: TXMLValueDeserialize;
                                    PrivParam:    Integer;
                                  End;
      {$ENDIF}
      TXMLEncryptionProc        = Procedure(Var Text: TWideString; Const Data: AnsiString; Decrypt: Boolean; Attr: TXMLAttributes);
      TXMLNodeSortProc          = Function(Node1, Node2: TXMLNode): TValueRelationship;
      TXMLAttrSortProc          = Function(Attributes: TXMLAttributes; Index1, Index2: Integer): TValueRelationship;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'definitions (internal)'}{$IFEND}

    {***** internal definitions *******************************************************************}

      TXMLStringCheckType       = (xtInstruction_NodeName, xtInstruction_VersionValue, xtInstruction_EncodingValue, xtInstruction_StandaloneValue,
                                    xtTypedef_NodeName, xtTypedef_SetText,    xtTypedef_GetText,    xtTypedef_LoadText,    xtTypedef_SaveText,
                                    xtElement_NodeName, xtElement_SetText,    xtElement_GetText,    xtElement_LoadText,    xtElement_SaveText,
                                                        xtCData_SetText,      xtCData_GetText,      xtCData_LoadText,      xtCData_SaveText,
                                                        xtComment_SetText,    xtComment_GetText,    xtComment_LoadText,    xtComment_SaveText,
                                    xtAttribute_Name,   xtAttribute_SetValue, xtAttribute_GetValue, xtAttribute_LoadValue, xtAttribute_SaveValue);
      TXMLNodePathOptions       = Set of (xpNotCreate, xpDoCreate, xpNonFilered);
      TXMLAttributeField        = Record
                                    NameHash:    LongWord;
                                    Name, Value: TWideString;
                                  End;
      TXMLAttributeArray        = packed Array of TXMLAttributeField;
      TXMLCryptor               = Record
                                    Name: TWideString;
                                    Proc: TXMLEncryptionProc;
                                    Data: AnsiString;
                                  End;
      TXMLCryptorArray          = packed Array of TXMLCryptor;

      PChangeArray              = ^TChangeArray;
      TChangeArray              = Record  // 16 KB
                                  {$IF DELPHI >= 2006}
                                  Private
                                    _Data: Array[-1..1362] of Record
                                             Pos, Len: Integer;
                                             S:        TWideString;
                                           End;
                                    _S:    ^TWideString;
                                    _P:    PWideChar;
                                    _Len:  Integer;
                                    _Pos:  Integer;
                                  Public
                                    Property  Pos: Integer   Read _Pos;
                                    Property  P:   PWideChar Read _P;
                                    Procedure Initialize(Var S: TWideString); {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
                                    Procedure Add(Len: Word; Const S: TWideString);
                                    Procedure Inc;                            {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
                                    Procedure Finalize;
                                  {$ELSE}
                                    Data: Array[-1..1362] of Record
                                            Pos, Len: Integer;
                                            S:        TWideString;
                                          End;
                                    S:    ^TWideString;
                                    P:    PWideChar;
                                    Len:  Integer;
                                    Pos:  Integer;
                                  {$IFEND}
                                  End;
      {$IFDEF hxExcludeClassesUnit}
        TStreamSeekOrigin       = (soBeginning, soCurrent, soEnd);
        TStream                 = Class
                                  Private
                                    Function  GetPosition:           Int64;
                                    Procedure SetPosition(Const Pos: Int64);
                                  Protected
                                    Function  GetSize:                   Int64;  Virtual; Abstract;
                                    Procedure SetSize    (Const NewSize: Int64); Virtual; Abstract;
                                  Public
                                    Function  Read       (Var   Buffer; Count: LongInt): LongInt; Virtual; Abstract;
                                    function  Write      (Const Buffer; Count: LongInt): LongInt; Virtual; Abstract;
                                    Function  Seek       (Const Offset: Int64; Origin: TStreamSeekOrigin): Int64; Virtual; Abstract;
                                    Procedure ReadBuffer (Var   Buffer; Count: LongInt);
                                    Procedure WriteBuffer(Const Buffer; Count: LongInt);
                                    Property  Position:  Int64 Read GetPosition Write SetPosition;
                                    Property  Size:      Int64 Read GetSize     Write SetSize;
                                  End;
        THandleStream           = Class(TStream)
                                  Protected
                                    FHandle:  THandle;
                                    Procedure SetSize(Const NewSize: Int64); Override;
                                  Public
                                    Constructor Create(AHandle: Integer);
                                    Function  Read (Var   Buffer; Count: LongInt): LongInt; Override;
                                    Function  Write(Const Buffer; Count: LongInt): LongInt; Override;
                                    Function  Seek (Const Offset: Int64; Origin: TStreamSeekOrigin): Int64; Override;
                                    Property  Handle: THandle Read FHandle;
                                  End;
      {$ENDIF}
      TWideFileStream           = Class(THandleStream)
                                    Constructor Create(Const FileName: TWideString; Mode: Word);
                                    Destructor Destroy; Override;
                                    Function GetSize: Int64; Override;
                                  End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'interfaces'}{$IFEND}

    {***** classes : DOM root document ************************************************************}

      TXMLFile = Class
      {$IF DELPHI >= 2006}
      Strict Protected
        Class Var __DefaultOptions: TXMLOptions;
        __DefaultTextIndent:        TWideString;
        __DefaultLineFeed:          TWideString;
        __DefaultValueSeperator:    TWideString;
        __DefaultValueQuotation:    TWideString;
        __PathDelimiter:            TWideString;

        Class Function  GetLibVersion:                        AnsiString;   Static;
        Class Procedure SetDefaultOptions       (      Value: TXMLOptions); Static;
        Class Procedure SetDefaultTextIndent    (Const Value: TWideString); Static;
        Class Procedure SetDefaultLineFeed      (Const Value: TWideString); Static;
        Class Procedure SetDefaultValueSeperator(Const Value: TWideString); Static;
        Class Procedure SetDefaultValueQuotation(Const Value: TWideString); Static;
        Class Procedure SetPathDelimiter        (Const Value: TWideString); Static;
      {$ELSE}
      Protected
        Class Function  GetLibVersion:                        AnsiString;
        Class Function  GetDefaultOptions:                    TXMLOptions;
        Class Procedure SetDefaultOptions       (      Value: TXMLOptions);
        Class Function  GetDefaultTextIndent:                 TWideString;
        Class Procedure SetDefaultTextIndent    (Const Value: TWideString);
        Class Function  GetDefaultLineFeed:                   TWideString;
        Class Procedure SetDefaultLineFeed      (Const Value: TWideString);
        Class Function  GetDefaultValueSeperator:             TWideString;
        Class Procedure SetDefaultValueSeperator(Const Value: TWideString);
        Class Function  GetDefaultValueQuotation:             TWideString;
        Class Procedure SetDefaultValueQuotation(Const Value: TWideString);
        Class Function  GetPathDelimiter:                     TWideString;
        Class Procedure SetPathDelimiter        (Const Value: TWideString);
      {$IFEND}
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        _Owner:            TObject;

        _Options:          TXMLOptions;
        _TextIndent:       TWideString;
        _LineFeed:         TWideString;
        _ValueSeperator:   TWideString;
        _ValueQuotation:   TWideString;
        _ParsedSingleTags: TXMLAttributeArray;

        _FileName:         TWideString;
        _Changed:          Boolean;

        _Nodes:            TXMLNodeList;

        _Cryptors:         TXMLCryptorArray;
        _CryptAttrName:    TWideString;

        _OnNodeChange:     TXMLNodeChangeEvent;
        _OnStatus:         TXMLFileStatusEvent;
        _OnException:      TXMLExceptionEvent;
        _UpdateIntervall:  Integer;
        _StatusScale:      Integer;

        _ThreadLock:       TRTLCriticalSection;

        Function  GetXmlStyleNode:                 TXMLNode;  // used by Get-/SetVersion, Get-/SetEncoding and Get-/SetStandalone
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        Procedure SetOwner           (      Value: TObject);
        Procedure SetOptions         (      Value: TXMLOptions);
        Procedure SetTextIndent      (Const Value: TWideString);
        Procedure SetLineFeed        (Const Value: TWideString);
        Procedure SetValueSeperator  (Const Value: TWideString);
        Procedure SetValueQuotation  (Const Value: TWideString);
        Function  GetParsedSingleTags:             TWideString;
        Procedure SetParsedSingleTags(      Value: TWideString);

        Procedure SetFileName        (Const Value: TWideString);
        {$IFNDEF hxExcludeClassesUnit}
          Function  GetAsXML:                      AnsiString;
          Procedure SetAsXML         (Const Value: AnsiString);
        {$ENDIF}
        Function  GetVersion:                      TWideString;
        Procedure SetVersion         (Const Value: TWideString);
        Function  GetEncoding:                     TWideString;
        Procedure SetEncoding        (Const Value: TWideString);
        Function  GetStandalone:                   TWideString;
        Procedure SetStandalone      (Const Value: TWideString);
        Function  GetNodeCount:                    Integer;
        Function  GetNFNodeCount:                  Integer;
        Procedure AssignNodes        (      Nodes: TXMLNodeList);
        Function  GetRootNode:                     TXMLNode;
        Function  GetAttribute       (Const Name:  TWideString):             Variant;
        Procedure SetAttribute       (Const Name:  TWideString; Const Value: Variant);
        Function  GetNode            (Const Name:  TWideString):             TXMLNode;
        Function  GetNFNode          (Const Name:  TWideString):             TXMLNode;
        Function  GetNodeArray       (Const Name:  TWideString):             TXMLNodeArray;
        Function  GetNFNodeArray     (Const Name:  TWideString):             TXMLNodeArray;
        Function  GetFindNode        (Const Name:  TWideString):             TXMLNode;
        Function  GetNFFindNode      (Const Name:  TWideString):             TXMLNode;
        Function  GetFindNodeArray   (Const Name:  TWideString):             TXMLNodeArray;
        Function  GetNFFindNodeArray (Const Name:  TWideString):             TXMLNodeArray;
        Function  GetCryptProc       (Const CName: TWideString):             TXMLEncryptionProc;
        Procedure SetCryptProc       (Const CName: TWideString;       Value: TXMLEncryptionProc);
        Function  GetCryptData       (Const CName: TWideString):             AnsiString;
        Procedure SetCryptData       (Const CName: TWideString; Const Value: AnsiString);
        Procedure SetCryptName       (Const cName: TWideString);
      Public
        {$IF DELPHI >= 2006}Class{$IFEND} Property LibVersion: AnsiString Read GetLibVersion;

        {$IF DELPHI >= 2006}
        Class Property  DefaultOptions:        TXMLOptions Read __DefaultOptions         Write SetDefaultOptions;
        Class Property  DefaultTextIndent:     TWideString Read __DefaultTextIndent      Write SetDefaultTextIndent;
        Class Property  DefaultLineFeed:       TWideString Read __DefaultLineFeed        Write SetDefaultLineFeed;
        Class Property  DefaultValueSeperator: TWideString Read __DefaultValueSeperator  Write SetDefaultValueSeperator;
        Class Property  DefaultValueQuotation: TWideString Read __DefaultValueQuotation  Write SetDefaultValueQuotation;
        Class Property  PathDelimiter:         TWideString Read __PathDelimiter          Write SetPathDelimiter;
        {$ELSE}
        Property        DefaultOptions:        TXMLOptions Read GetDefaultOptions        Write SetDefaultOptions;
        Property        DefaultTextIndent:     TWideString Read GetDefaultTextIndent     Write SetDefaultTextIndent;
        Property        DefaultLineFeed:       TWideString Read GetDefaultLineFeed       Write SetDefaultLineFeed;
        Property        DefaultValueSeperator: TWideString Read GetDefaultValueSeperator Write SetDefaultValueSeperator;
        Property        DefaultValueQuotation: TWideString Read GetDefaultValueQuotation Write SetDefaultValueQuotation;
        Property        PathDelimiter:         TWideString Read GetPathDelimiter         Write SetPathDelimiter;
        {$IFEND}

        Constructor Create(Owner: TObject = nil; CreateRootNodes: Boolean = True);                   Overload;
        Constructor Create(Owner: TObject;       Const NameOfRootNode: TWideString);                 Overload;
        Constructor Create(Owner: TObject;       Const FileName: TWideString; SaveOnClose: Boolean); Overload;
        Destructor  Destroy; Override;

        Property  Owner:             TObject             Read _Owner              Write SetOwner;

        Property  Options:           TXMLOptions         Read _Options            Write SetOptions;
        Property  TextIndent:        TWideString         Read _TextIndent         Write SetTextIndent;
        Property  LineFeed:          TWideString         Read _LineFeed           Write SetLineFeed;
        Property  ValueSeperator:    TWideString         Read _ValueSeperator     Write SetValueSeperator;
        Property  ValueQuotation:    TWideString         Read _ValueQuotation     Write SetValueQuotation;
        Property  ParsedSingleTags:  TWideString         Read GetParsedSingleTags Write SetParsedSingleTags;

        Property  FileName:          TWideString         Read _FileName           Write SetFileName;
        Property  Changed:           Boolean             Read _Changed;
        Procedure LoadFromFile       (FileName: TWideString = '[default]');
        Procedure SaveToFile         (FileName: TWideString = '[default]');
        Procedure LoadFromStream     (Stream: TStream; StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = False);
        Procedure SaveToStream       (Stream: TStream; StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = False);
        {$IFNDEF hxExcludeClassesUnit}
          Procedure LoadFromResource (Instance: THandle; Const ResName: String;  ResType: PChar = RT_RCDATA{RT_STRING}); Overload;
          Procedure LoadFromResource (Instance: THandle;       ResID:   Integer; ResType: PChar = RT_RCDATA{RT_STRING}); Overload;
          Procedure LoadFromXML      (Const XMLString: AnsiString;  StartEncoding: TXMLEncoding = xeUTF8;    IgnoreEncodingAttributes: Boolean = True); Overload;
          Procedure LoadFromXML      (Const XMLString: TWideString; StartEncoding: TXMLEncoding = xeUnicode; IgnoreEncodingAttributes: Boolean = True); Overload;
          Procedure SaveToXML        (Var   XMLString: AnsiString;  StartEncoding: TXMLEncoding = xeUTF8;    IgnoreEncodingAttributes: Boolean = True); Overload;
          Procedure SaveToXML        (Var   XMLString: TWideString; StartEncoding: TXMLEncoding = xeUnicode; IgnoreEncodingAttributes: Boolean = True); Overload;
          Property  asXML:           AnsiString          Read GetAsXML            Write SetAsXML;
        {$ENDIF}
        Procedure ClearDocument      (CreateRootNodes: Boolean = True);   Overload;
        Procedure ClearDocument      (Const NameOfRootNode: TWideString); Overload;

        Property  Version:           TWideString         Read GetVersion          Write SetVersion;
        Property  Encoding:          TWideString         Read GetEncoding         Write SetEncoding;
        Property  Standalone:        TWideString         Read GetStandalone       Write SetStandalone;

        Property  NodeCount:         Integer             Read GetNodeCount;
        Property  NodeCountNF:       Integer             Read GetNFNodeCount;
        Property  Nodes:             TXMLNodeList        Read _Nodes              Write AssignNodes;
        Property  RootNode:          TXMLNode            Read GetRootNode;

        // forwarding to .RootNode.Attributes.Value, .RootNode.Nodes.Node***, and .RootNode.Nodes.Add
        Property  Attribute          [Const Name: TWideString]: Variant             Read GetAttribute   Write SetAttribute;
        Property  Node               [Const Name: TWideString]: TXMLNode            Read GetNode; Default;
        Property  NodeNF             [Const Name: TWideString]: TXMLNode            Read GetNFNode;
        Property  NodeList           [Const Name: TWideString]: TXMLNodeArray       Read GetNodeArray;
        Property  NodeListNF         [Const Name: TWideString]: TXMLNodeArray       Read GetNFNodeArray;
        Property  FindNode           [Const Name: TWideString]: TXMLNode            Read GetFindNode;
        Property  FindNodeNF         [Const Name: TWideString]: TXMLNode            Read GetNFFindNode;
        Property  FindNodes          [Const Name: TWideString]: TXMLNodeArray       Read GetFindNodeArray;
        Property  FindNodesNF        [Const Name: TWideString]: TXMLNodeArray       Read GetNFFindNodeArray;
        Function  AddNode            (Const Name: TWideString; NodeType: TXMLNodeType = xtElement): TXMLNode; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}

        {$IFNDEF hxExcludeSysutilsUnit}
          // register a procedure for the (de)serilation (Node.Seroalize/Node.DeSerialize)
          Class Function  RegisterSerProc     (Proc: TXMLSerializeProc):  Boolean; Overload;
          Class Procedure DeregisterSerProc   (Proc: TXMLSerializeProc);           Overload;
          Class Function  isRegisteredSerProc (Proc: TXMLSerializeProc):  Boolean; Overload;
          // register a class for the deserilation (Node.DeSerialize) of an not existing object
          Class Function  RegisterSerClass    (      C:          TClass): Boolean; Overload;
          Class Function  RegisterSerClass    (Const C: Array of TClass): Boolean; Overload;
          Class Procedure DeregisterSerClass  (      C:          TClass);          Overload;
          Class Procedure DeregisterSerClass  (Const C: Array of TClass);          Overload;
          Class Function  isRegisteredSerClass(      C:          TClass): Boolean; Overload;
          Class Function  isRegisteredSerClass(Const C: Array of TClass): Boolean; Overload;
          // register a prozedure for property-value-serialization
          Class Procedure SetValueSerProc     (VType: TTypeKind{tkInteger|tkFloat}; Const Name: AnsiString; SProc: TXMLValueSerialize; DProc: TXMLValueDeserialize; PrivParam: Integer = 0);
          Class Function  GetValueSerProc:    TXMLValueSerializeArray;
        {$ENDIF}

        Function  Cryptors:          TWideStringDynArray;
        Procedure SetCryptor         (Const CName: TWideString; Proc: TXMLEncryptionProc; Const Data: AnsiString);
        Property  CryptProc          [Const CName: TWideString]: TXMLEncryptionProc Read GetCryptProc   Write SetCryptProc;
        Property  CryptData          [Const CName: TWideString]: AnsiString         Read GetCryptData   Write SetCryptData;
        Property  CryptAttrName:     TWideString                                    Read _CryptAttrName Write SetCryptName;
        Procedure ChangeAllCryptors  (Const NewCryptName: TWideString);
        Procedure ChangeAllCryptProcs(Const CName: TWideString; NewProc: TXMLEncryptionProc; Const NewData: AnsiString);
        Procedure ChangeAllCryptNames(Const NewAttrName:  TWideString);
        Procedure SetDefaultCryptor  (Const CName:        TWideString);

        Property  OnNodeChange:      TXMLNodeChangeEvent Read _OnNodeChange       Write _OnNodeChange;
        Property  OnStatus:          TXMLFileStatusEvent Read _OnStatus           Write _OnStatus;
        Property  OnException:       TXMLExceptionEvent  Read _OnException        Write _OnException;
        Property  UpdateIntervall:   Integer             Read _UpdateIntervall    Write _UpdateIntervall;
        Property  StatusScale:       Integer             Read _StatusScale        Write _StatusScale;

        Procedure _Lock;                      {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Function  _TryLock:          Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Procedure _Unlock;                    {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Function  _isLocked:         Boolean;
      Protected
        Class Procedure Initialize;

        Class Function  GetOptions   (Owner: TXMLFile = nil): TXMLOptions;   {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  GetNTypeMask (Owner: TXMLFile = nil): TXMLNodeTypes;

        Class Procedure ParsingTree  (Owner: TXMLFile; Reader: TXReader; Tree: TXMLNodeList; StatusTimer: PLongWord; Internal: Boolean = False);
        Class Procedure AssembleTree (Owner: TXMLFile; Writer: TXWriter; Tree: TXMLNodeList; StatusTimer: PLongWord);

        Property        InnerCryptors: TXMLCryptorArray Read _Cryptors;
        Procedure       InnerChangeAllCryptors(Const OldCName, NewCName: TWideString; NewProc: TXMLEncryptionProc; Const NewData: AnsiString; Var E: Exception);

        Procedure       DoChanged;
        Procedure       DoNodeChange (Node: TXMLNode; CType: TXMLNodeChangeType);
        Procedure       DoStatus     (SType: TXMLFileStatus; State: Cardinal = 0);
      End;

    {***** classes : node list ********************************************************************}

      TXMLNodeList = Class
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        _Owner:      TXMLFile;
        _Parent:     TXMLNode;

        _NodesCount: Integer;
        _FirstNode:  TXMLNode;
        _LastNode:   TXMLNode;
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        Function  GetFirstNode:                            TXMLNode;
        Function  GetCount:                                Integer;
        {$IFNDEF hxExcludeTIndex}
          Function GetNode          (Index:      Integer): TXMLNode;
          Function GetNamedNode     (Name:   TWideString): TXMLNode;
        {$ELSE}
          Function GetNode          (IndexOrName: TIndex): TXMLNode;
        {$ENDIF}
        Function  GetNamedNodeU     (Name:   TWideString): TXMLNode;
        Function  GetNodeArray      (Name:   TWideString): TXMLNodeArray;
        Function  GetFindNode       (Name:   TWideString): TXMLNode;
        Function  GetFindNodeArray  (Name:   TWideString): TXMLNodeArray;
        Function  GetNodeCount:                            Integer;
        Function  GetNFNodeCount:                          Integer;
        Function  GetNFNode         (IndexOrName: TIndex): TXMLNode;
        Function  GetNFNodeU        (Name:   TWideString): TXMLNode;
        Function  GetNFNodeArray    (Name:   TWideString): TXMLNodeArray;
        Function  GetNFFindNode     (Name:   TWideString): TXMLNode;
        Function  GetNFFindNodeArray(Name:   TWideString): TXMLNodeArray;
        Function  GetNodeCS         (Name:   TWideString): TXMLNode;
      Public
        Constructor Create(ParentOrOwner: TObject{TXMLNode, TXMLFile});
        Destructor  Destroy; Override;

        Property  Owner:                            TXMLFile      Read _Owner;
        Property  Parent:                           TXMLNode      Read _Parent;

        Property  FirstNode:                        TXMLNode      Read GetFirstNode;
        Function  NextNode   (Node:  TXMLNode):     TXMLNode;

        Property  Count:                            Integer       Read GetCount;
        {$IFNDEF hxExcludeTIndex}
          Property Node      [Index: Integer]:      TXMLNode      Read GetNode;      Default;
          Property Node      [Name:  TWideString]:  TXMLNode      Read GetNamedNode; Default;
        {$ELSE}
          Property Node      [IndexOrName: TIndex]: TXMLNode      Read GetNode;      Default;
        {$ENDIF}
        Property  NodeU      [Name:  TWideString]:  TXMLNode      Read GetNamedNodeU;
        Property  NodeList   [Name:  TWideString]:  TXMLNodeArray Read GetNodeArray;
        Property  FindNode   [Name:  TWideString]:  TXMLNode      Read GetFindNode;
        Property  FindNodes  [Name:  TWideString]:  TXMLNodeArray Read GetFindNodeArray;

        Property  NodeCount:                        Integer       Read GetNodeCount;
        Property  NodeCountNF:                      Integer       Read GetNFNodeCount;

        Function  Add        (Name:  TWideString;                   NodeType:  TXMLNodeType = xtElement): TXMLNode;
        Function  Insert     (Node:  TXMLNode;      RNode: TXMLNode; previousR: Boolean = False):          TXMLNode; Overload;
        Function  Insert     (Node:  TXMLNode;      Index: Integer):                                       TXMLNode; Overload;
        Function  Insert     (Name:  TWideString;   Index: Integer;  NodeType:  TXMLNodeType = xtElement): TXMLNode; Overload;
        Function  Remove     (Node:  TXMLNode):     TXMLNode; Overload;
        Function  Remove     (Name:  TWideString):  TXMLNode; Overload;
        Function  Remove     (Index: Integer):      TXMLNode; Overload;
        Procedure Delete     (Node:  TXMLNode);               Overload;
        Procedure Delete     (Name:  TWideString);            Overload;
        Procedure Delete     (Index: Integer);                Overload;
        Procedure Clear;

        Function  IndexOf    (Node:  TXMLNode):     Integer;  Overload;
        Function  IndexOf    (Name:  TWideString):  Integer;  Overload;
        Function  Exists     (Name:  TWideString):  Boolean;

        Function  CloneNode  (Node:  TXMLNode):     TXMLNode;
        Procedure CloneNodes (Nodes: TXMLNodeList);

        Property  FirstNodeNF:                      TXMLNode      Read _FirstNode;
        Function  NextNodeNF (Node:  TXMLNode):     TXMLNode; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}

        Property  CountNF:                          Integer       Read _NodesCount;
        Property  NodeNF     [IndexOrName: TIndex]: TXMLNode      Read GetNFNode;
        Property  NodeUNF    [Name:  TWideString]:  TXMLNode      Read GetNFNodeU;
        Property  NodeListNF [Name:  TWideString]:  TXMLNodeArray Read GetNFNodeArray;
        Property  FindNodeNF [Name:  TWideString]:  TXMLNode      Read GetNFFindNode;
        Property  FindNodesNF[Name:  TWideString]:  TXMLNodeArray Read GetNFFindNodeArray;

        Function  InsertNF   (Node:  TXMLNode;      Index: Integer):                                     TXMLNode; Overload;
        Function  InsertNF   (Name:  TWideString;   Index: Integer; NodeType: TXMLNodeType = xtElement): TXMLNode; Overload;
        Function  RemoveNF   (Name:  TWideString):  TXMLNode; Overload;
        Function  RemoveNF   (Index: Integer):      TXMLNode; Overload;
        Procedure DeleteNF   (Name:  TWideString);            Overload;
        Procedure DeleteNF   (Index: Integer);                Overload;

        Function  IndexOfNF  (Index: Integer):      Integer;  Overload;
        Function  IndexOfNF  (Node:  TXMLNode):     Integer;  Overload;
        Function  IndexOfNF  (Name:  TWideString):  Integer;  Overload;
        Function  ExistsNF   (Name:  TWideString):  Boolean;

        Property  NodeCS     [Name:  TWideString {CaseSensitive: Boolean = False}]: TXMLNode Read GetNodeCS;
        Function  IndexOfCS  (Name:  TWideString; CaseSensitive: Boolean = False): Integer;
        Function  ExistsCS   (Name:  TWideString; CaseSensitive: Boolean = False): Boolean;

        Procedure Assign{NF} (Nodes: TXMLNodeList);

        Procedure Sort{NF}   (SortProc: TXMLNodeSortProc);
      Protected
        Class Function  ParseNodePath (Var Nodes: TXMLNodeList; Var NodeName: TWideString; PathOptions: TXMLNodePathOptions): Boolean;
        Class Procedure SplittNodeName(                                  Out NodeNameHash: LongWord; Var   NodeName: TWideString; Var   Attributes: TXMLAttributeArray; Out Index: Integer; Const FunctionsName: String);
        Class Function  CompareNode   (Node: TXMLNode; NType: TXMLNodeTypes; NodeNameHash: LongWord; Const NodeName: TWideString; Const Attributes: TXMLAttributeArray): Boolean;                                 {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  CompareNodeCS (Node: TXMLNode;                       NodeNameHash: LongWord; Const NodeName: TWideString; Const Attributes: TXMLAttributeArray; CaseSensitive: Boolean = False): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}

        Procedure SetOwner(NewOwner: TXMLFile);

        Procedure DoNodeChange(Node: TXMLNode; CType: TXMLNodeChangeType); {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
      End;

    {***** classes : node element *****************************************************************}

      TXMLNode = Class(TXMLInnerNode)
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        _Owner:        TXMLFile;
        _Parent:       TXMLNodeList;
        _Prev, _Next:  TXMLNode;

        _NodeType:     TXMLNodeType;
        _NameHash:     LongWord;
        _Name:         TWideString;

        _Attributes:   TXMLAttributes;

        _Text:         TWideString;
        _Nodes:        TXMLNodeList;

        _NodeOptions:  TXMLNodeOptions;

        _isCrypted:    Boolean;
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        Function  GetParent:                      TXMLNode;
        Function  GetNFIndex:                     Integer;
        Function  GetIndex:                       Integer;
        Function  GetLevel:                       Integer;
        Function  GetFullPath:                    TWideString;
        Procedure SetName           (Const Value: TWideString);
        Function  GetNamespace:                   TWideString;
        Procedure SetNamespace      (Const Value: TWideString);
        Function  GetNameOnly:                    TWideString;
        Procedure SetNameOnly       (Const Value: TWideString);
        Procedure AssignAttributes  (      Value: TXMLAttributes);
        Function  GetText:                        Variant;
        Procedure SetText           (Const Value: Variant);
        Function  GetTextS:                       TWideString;
        Procedure SetTextS          (      Value: TWideString);
        Function  GetTextD:                       TWideString;
        Procedure SetTextD          (Const Value: TWideString);
        Function  GetBase64:                      AnsiString;
        Procedure SetBase64         (Const Value: AnsiString);
        Function  GetBase64w:                     TWideString;
        Procedure SetBase64w        (Const Value: TWideString);
        {$IFNDEF hxExcludeClassesUnit}
          Function  GetXMLText:                   TWideString;
          Procedure SetXMLText      (Const Value: TWideString);
        {$ENDIF}
        Function  GetCrypt:                       TWideString;
        Procedure SetCrypt          (      CName: TWideString);
        Procedure AssignNodes       (      Nodes: TXMLNodeList);
        Function  GetAttribute      (Const Name:  TWideString):             Variant;
        Procedure SetAttribute      (Const Name:  TWideString; Const Value: Variant);
        Function  GetNode           (Const Name:  TWideString):             TXMLNode;
        Function  GetNFNode         (Const Name:  TWideString):             TXMLNode;
        Function  GetNodeArray      (Const Name:  TWideString):             TXMLNodeArray;
        Function  GetNFNodeArray    (Const Name:  TWideString):             TXMLNodeArray;
        Function  GetFindNode       (Const Name:  TWideString):             TXMLNode;
        Function  GetNFFindNode     (Const Name:  TWideString):             TXMLNode;
        Function  GetFindNodeArray  (Const Name:  TWideString):             TXMLNodeArray;
        Function  GetNFFindNodeArray(Const Name:  TWideString):             TXMLNodeArray;
        Function  GetNextNode:                    TXMLNode;
      Public
        Constructor Create(ParentOrOwner: TObject{TXMLNodeList, TXMLFile}; NodeType: TXMLNodeType = xtElement; Const NodeName: TWideString = '');
        Destructor  Destroy; Override;

        Property  Owner:        TXMLFile       Read _Owner;
        Property  Parent:       TXMLNode       Read GetParent;
        Property  ParentList:   TXMLNodeList   Read _Parent;

        Property  IndexNF:      Integer        Read GetNFIndex;
        Property  Index:        Integer        Read GetIndex;
        Property  Level:        Integer        Read GetLevel;

        Property  NodeType:     TXMLNodeType   Read _NodeType;

        Property  FullPath:     TWideString    Read GetFullPath;
        Property  Name:         TWideString    Read _Name        Write SetName;
        Property  Namespace:    TWideString    Read GetNamespace Write SetNamespace;
        Property  NameOnly:     TWideString    Read GetNameOnly  Write SetNameOnly;

        Property  Attributes:   TXMLAttributes Read _Attributes  Write AssignAttributes;

        Property  Text:         Variant        Read GetText      Write SetText;
        Property  Text_S:       TWideString    Read GetTextS     Write SetTextS;
        Property  Text_D:       TWideString    Read GetTextD     Write SetTextD;
        Property  Text_Base64:  AnsiString     Read GetBase64    Write SetBase64;
        Property  Text_Base64w: TWideString    Read GetBase64w   Write SetBase64w;
        Function  GetBinaryLen: Integer;
        Function  GetBinaryData (Buffer: Pointer; BufferSize: Integer): Integer; Overload;
        Procedure SetBinaryData (Buffer: Pointer; BufferSize: Integer);          Overload;
        Function  GetBinaryData (Stream: TStream):                      Integer; Overload;
        Procedure SetBinaryData (Stream: TStream; MaxBytes: Integer = MaxInt);   Overload;
        {$IFNDEF hxExcludeClassesUnit}
          Property  XMLText:    TWideString    Read GetXMLText   Write SetXMLText;
        {$ENDIF}
        {$IFNDEF hxExcludeSysutilsUnit}
          Procedure RemoveSerializedData;                     {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
          Procedure Serialize   (Const V: Variant); Overload; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
          Procedure DeSerialize (Var   V: Variant); Overload; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
          Procedure Serialize   (C: TObject; SOptions: TXMLSerializeOptions = []; Proc: TXMLSerializeProc = nil); Overload; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
          Procedure DeSerialize (C: TObject; SOptions: TXMLSerializeOptions = []; Proc: TXMLSerializeProc = nil); Overload; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
          Function  Serialize   (Const Rec; RecInfo: TXMLSerializeRecordInfo): Integer; Overload;
          Function  DeSerialize (Var   Rec; RecInfo: TXMLSerializeRecordInfo): Integer; Overload;
        {$ENDIF}

        Function  isTextNode:   Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Function  hasCDATA:     Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Procedure asCDATA(yes:  Boolean);

        Property  Crypt:        TWideString    Read GetCrypt     Write SetCrypt;
        Procedure Recrypt       (OldProc: TXMLEncryptionProc; OldData: AnsiString; NewProc: TXMLEncryptionProc; NewData: AnsiString);

        Property  Nodes:        TXMLNodeList   Read _Nodes       Write AssignNodes;

        // forwarding to .Attributes.Value, .Nodes.Node, .Nodes.NodeNF and .Nodes.Add
        Property  Attribute     [Const Name: TWideString]: Variant       Read GetAttribute Write SetAttribute;
        Property  Node          [Const Name: TWideString]: TXMLNode      Read GetNode; Default;
        Property  NodeNF        [Const Name: TWideString]: TXMLNode      Read GetNFNode;
        Property  NodeList      [Const Name: TWideString]: TXMLNodeArray Read GetNodeArray;
        Property  NodeListNF    [Const Name: TWideString]: TXMLNodeArray Read GetNFNodeArray;
        Property  FindNode      [Const Name: TWideString]: TXMLNode      Read GetFindNode;
        Property  FindNodeNF    [Const Name: TWideString]: TXMLNode      Read GetNFFindNode;
        Property  FindNodes     [Const Name: TWideString]: TXMLNodeArray Read GetFindNodeArray;
        Property  FindNodesNF   [Const Name: TWideString]: TXMLNodeArray Read GetNFFindNodeArray;
        Function  AddNode       (Const Name: TWideString; NodeType: TXMLNodeType = xtElement): TXMLNode;

        Procedure DeclareNamespace   (Const Prefix, URI:  TWideString);
        Function  FindNamespaceDecl  (      NamespaceURI: TWideString): TXMLNode;
        Function  FindNamespaceURI   (      TagOrPrefix:  TWideString): TWideString;
        Function  NamespaceURI:                                         TWideString; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}

        Property  NextNode:     TXMLNode       Read GetNextNode;
        Property  NextNodeNF:   TXMLNode       Read _Next;
      Protected
        Procedure SetOwner    (NewOwner:  TXMLFile);
        Procedure SetParent   (NewParent: TXMLNodeList);
        Property  InnerPrev:     TXMLNode    Read _Prev Write _Prev;
        Property  InnerNext:     TXMLNode    Read _Next Write _Next;
        Property  InnerNameHash: LongWord    Read _NameHash;
        Property  InnerText:     TWideString Read _Text Write _Text;
        Procedure CheckCrypted(SubCheck: Boolean = False; Const Attr: TWideString = '');

        Procedure DoNodeChange(CType: TXMLNodeChangeType); {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
      End;

    {***** classes : list of node attributes ******************************************************}

      TXMLAttributes = Class
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        _Owner:            TXMLFile;
        _Parent:           TXMLNode;

        _AttributesLength: Integer;
        _Attributes:       TXMLAttributeArray;
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        Function  GetName        (Index: Integer):                   TWideString;
        Procedure SetName        (Index: Integer;       Const Value: TWideString);
        Function  GetNamespace   (Index: Integer):                   TWideString;
        Procedure SetNamespace   (Index: Integer;             Value: TWideString);
        Function  GetNameOnly    (Index: Integer):                   TWideString;
        Procedure SetNameOnly    (Index: Integer;             Value: TWideString);
        {$IFNDEF hxExcludeTIndex}
          Function  GetValue     (Index: Integer):                   Variant;
          Function  GetNamedValue(Name:  TWideString):               Variant;
          Procedure SetValue     (Index: Integer;       Const Value: Variant);
          Procedure SetNamedValue(Name:  TWideString;   Const Value: Variant);
        {$ELSE}
          Function  GetValue     (IndexOrName: TIndex):              Variant;
          Procedure SetValue     (IndexOrName: TIndex;  Const Value: Variant);
        {$ENDIF}
        {$IF DELPHI >= 2006}
        Function  GetNamedList   (Name:  TWideString):               TAssocVariantArray;
        {$IFEND}
        Function  GetValueCS     (Name:  TWideString):               Variant;
        Procedure SetValueCS     (Name:  TWideString;   Const Value: Variant);
      Public
        Constructor Create(Parent: TXMLNode);
        Destructor  Destroy; Override;

        Property  Owner:                               TXMLFile           Read _Owner;
        Property  Parent:                              TXMLNode           Read _Parent;

        Property  Count:                               Integer            Read _AttributesLength;
        Property  Name     [      Index: Integer]:     TWideString        Read GetName       Write SetName;
        Property  Namespace[      Index: Integer]:     TWideString        Read GetNamespace  Write SetNamespace;
        Property  NameOnly [      Index: Integer]:     TWideString        Read GetNameOnly   Write SetNameOnly;
        {$IFNDEF hxExcludeTIndex}
          Property Value   [      Index: Integer]:     Variant            Read GetValue      Write SetValue;      Default;
          Property Value   [      Name:  TWideString]: Variant            Read GetNamedValue Write SetNamedValue; Default;
        {$ELSE}
          Property Value   [IndexOrName: TIndex]:      Variant            Read GetValue      Write SetValue;      Default;
        {$ENDIF}
        {$IF DELPHI >= 2006}
        Property  ValueList[      Name:  TWideString]: TAssocVariantArray Read GetNamedList;  // .Tag = TXMLAttributes(Owner)
        {$IFEND}

        Function  Add      (      Name:  TWideString;                  Const Value: Variant): Integer; Overload;
        Function  Add      (Const Name:  TWideString):                                        Integer; Overload;
        Function  Insert   (      Name:  TWideString;  Index: Integer; Const Value: Variant): Integer; Overload;
        Function  Insert   (Const Name:  TWideString;  Index: Integer):                       Integer; Overload;
        Procedure Delete   (      Name:  TWideString); Overload;
        Procedure Delete   (      Index: Integer);     Overload;
        Procedure Clear;

        Function  IndexOf  (Const Name:  TWideString): Integer;
        Function  Exists   (      Name:  TWideString): Boolean;

        Property  ValueCS  [      Name:  TWideString {CaseSensitive: Boolean = False}]: Variant Read GetValueCS Write SetValueCS;
        Function  IndexOfCS(Const Name:  TWideString; CaseSensitive: Boolean = False): Integer;
        Function  ExistsCS (Const Name:  TWideString; CaseSensitive: Boolean = False): Boolean;

        Procedure CloneAttr(      Attributes: TXMLAttributes);

        Procedure Assign   (      Attributes: TXMLAttributes);

        Procedure Sort     (      SortProc:   TXMLAttrSortProc = nil);
      Protected
        Class Function ParseNodePath(Var Attr: TXMLAttributes; Var AttrName: TWideString; PathOptions: TXMLNodePathOptions): Boolean;

        Procedure SetOwner(NewOwner: TXMLFile);
        Property  InnerAttributes: TXMLAttributeArray Read _Attributes;
        Function  GetInnerAttributeValue(i: Integer):             TWideString;
        Procedure SetInnerAttributeValue(i: Integer; Const Value: TWideString);

        Procedure DoNodeChange(Const Attr: TWideString);
      End;

    {***** classes : SAX root document ************************************************************}

      TSAXFile = Class
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        Class Function GetLibVersion: AnsiString; {$IF DELPHI >= 2006}Static;{$IFEND}
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        _Owner:      TObject;
        _Stream:     TStream;
        _FileName:   TWideString;
        _Reader:     TXReader;

        _LevelCount: Integer;
        _Level:      TSAXNodeArray;

        _NodesCount: Integer;
        _MaxLevels:  Integer;
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        Procedure SetOwner          (Value: TObject);
        Function  GetOptions:               TXMLOptions;
        Procedure SetOptions        (Value: TXMLOptions);
        Function  GetVersion:               TWideString;
        Function  GetEncoding:              TWideString;
        Function  GetStandalone:            TWideString;
        Function  GetLevelCount:            Integer;
        Function  GetLevel(Index: Integer): TSAXNode;
        Function  GetProgress:              LongInt;
      Public
        {$IF DELPHI >= 2006}Class{$IFEND} Property LibVersion: AnsiString Read GetLibVersion;

        Constructor Create(Owner: TObject; Const FileName: TWideString = ''); Overload;
        Constructor Create(Owner: TObject;       Stream:   TStream);          Overload;
        Destructor  Destroy; Override;

        Property  Owner:                 TObject     Read _Owner     Write SetOwner;

        Procedure Open(Const FileName: TWideString);                                                                                          Overload;
        Procedure Open(      Stream:   TStream;             StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = False); Overload;
        {$IFNDEF hxExcludeClassesUnit}
          Procedure Open(    Buffer: Pointer; Len: Integer; StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = False); Overload;
        {$ENDIF}
        Property  FileName:              TWideString Read _FileName;
        Procedure Close;

        Property  Options:               TXMLOptions Read GetOptions Write SetOptions;
        Property  Version:               TWideString Read GetVersion;
        Property  Encoding:              TWideString Read GetEncoding;
        Property  Standalone:            TWideString Read GetStandalone;

        Property  Levels:                Integer     Read GetLevelCount;
        Property  Level[Index: Integer]: TSAXNode    Read GetLevel; Default;

        Function  Parse(Var Node: TSAXNode; Out isClosedTag: Boolean): Boolean;

        Property  Progress:              LongInt     Read GetProgress;
        Property  NodesCount:            Integer     Read _NodesCount;
        Property  MaxLevels:             Integer     Read _MaxLevels;
      Protected
        Property InnerLevel: TSAXNodeArray Read _Level;
      End;

    {***** classes : SAX level node ***************************************************************}

      TSAXNode = Class
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        _Owner:      TSAXFile;
        _NodeType:   TXMLNodeType;
        _Name:       TWideString;
        _AttrCount:  Integer;
        _Attributes: TXMLAttributeArray;
        _isOpen:     Boolean;
        _Text:       TWideString;
        _hasCDATA:   Boolean;
        _SubNodes:   Integer;

        Procedure SetOwner                        (NewOwner:    TSAXFile);
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        Function  GetLevel:                                     Integer;
        Function  GetFullPath:                                  TWideString;
        Function  GetNamespace:                                 TWideString;
        Function  GetNameOnly:                                  TWideString;
        Function  GetAttributeName(      Index:       LongInt): TWideString;
        Function  GetAttribute    (Const IndexOrName: TIndex):  Variant;
        Function  GetText:                                      Variant;
      Public
        Constructor Create(Owner: TSAXFile);
        Destructor  Destroy; Override;

        Property  NodeType:                                  TXMLNodeType Read _NodeType;

        Property  Level:                                     Integer      Read GetLevel;
        Property  FullPath:                                  TWideString  Read GetFullPath;
        Property  Name:                                      TWideString  Read _Name;
        Property  Namespace:                                 TWideString  Read GetNamespace;
        Property  NameOnly:                                  TWideString  Read GetNameOnly;

        Property  AttributeCount:                            Integer      Read _AttrCount;
        Property  AttributeName[      Index:       LongInt]: TWideString  Read GetAttributeName;
        Property  Attribute    [Const IndexOrName: TIndex]:  Variant      Read GetAttribute;

        Property  isOpenedTag:                               Boolean      Read _isOpen;

        Property  Text:                                      Variant      Read GetText;
        Property  hasCDATA:                                  Boolean      Read _hasCDATA;
        Property  SubNodes:                                  Integer      Read _SubNodes;
      End;

    {***** classes : XML helper *******************************************************************}

      TXHelper = Class {$IF DELPHI >= 2006}Abstract{$IFEND}
      {$IF DELPHI >= 2006}
      Strict Protected
        Class Var __ShlWAPI: THandle;
        __StrCmpLogicalW: Function(Const S1, S2: TWideString): Integer; StdCall;

        __LockCArr: TRTLCriticalSection;
        __CArr: TChangeArray;

        __CompareBlock0: Array[$0040..$007F {040}] of WideChar;
        __CompareBlock1: Array[$00C0..$029F {1E0}] of WideChar;
        __CompareBlock2: Array[$0370..$058F {220}] of WideChar;
        __CompareBlock3: Array[$10A0..$10FF {060}] of WideChar;
        __CompareBlock4: Array[$1D78..$1D7F {008}] of WideChar;
        __CompareBlock5: Array[$1E00..$1FFF {200}] of WideChar;
        __CompareBlock6: Array[$2130..$218F {060}] of WideChar;
        __CompareBlock7: Array[$24B0..$24EF {040}] of WideChar;
        __CompareBlock8: Array[$2C00..$2D2F {130}] of WideChar;
        __CompareBlock9: Array[$A640..$A78F {150}] of WideChar;
        __CompareBlockA: Array[$FF20..$FF5F {040}] of WideChar;

        __LowerBlock0:   Array[$0040..$007F {040}] of WideChar;
        __LowerBlock1:   Array[$00C0..$029F {1E0}] of WideChar;
        __LowerBlock2:   Array[$0370..$058F {220}] of WideChar;
        __LowerBlock3:   Array[$10A0..$10FF {060}] of WideChar;
        __LowerBlock4:   Array[$1D78..$1D7F {008}] of WideChar;
        __LowerBlock5:   Array[$1E00..$1FFF {200}] of WideChar;
        __LowerBlock6:   Array[$2130..$218F {060}] of WideChar;
        __LowerBlock7:   Array[$24B0..$24EF {040}] of WideChar;
        __LowerBlock8:   Array[$2C00..$2D2F {130}] of WideChar;
        __LowerBlock9:   Array[$A640..$A78F {150}] of WideChar;
        __LowerBlockA:   Array[$FF20..$FF5F {040}] of WideChar;

        {$IFNDEF hxExcludeSysutilsUnit}
          __SerializeProzedure:  Array of TXMLSerializeProc;
          __SerializeClass:      Array of TClass;
          __ValueSerializeProcs: TXMLValueSerializeArray;
        {$ENDIF}
      {$IFEND}
      Public
        Class Function  CalcArraySize(Len: Integer): Integer; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}

        Class Function  CalcHash     (Const S:       TWideString):                          LongWord;
        Class Function  CompareHash  (      H1, H2:  LongWord):                             Boolean;           {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  SameTextA    (Const S1, S2:  AnsiString):                           Boolean; Overload; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  SameTextW    (Const S1, S2:  TWideString; CaseSensitive: Boolean):  Boolean; Overload;
        Class Function  SameTextW    (Const S1, S2:  TWideString; Owner:         TXMLFile): Boolean; Overload;
        Class Function  CompareText  (Const S1, S2:  TWideString):                          Integer;
        Class Function  Pos          (Const Sub, S:  TWideString):                          Integer;
        Class Function  MatchText    (Const Mask, S: TWideString; CaseSensitive: Boolean):  Boolean; Overload;
        Class Function  MatchText    (Const Mask, S: TWideString; Owner:         TXMLFile): Boolean; Overload; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  Trim         (Const S:       TWideString):                          TWideString;

        Class Function  ValUInt64    (Const S: TWideString; Var i: UInt64): Boolean;
        Class Function  BooleanToXML (Const B;              Size: Integer): TWideString;
        Class Function  isXMLBoolean (      S: TWideString):                Boolean;
        Class Procedure XMLToBoolean (      S: TWideString; Size: Integer;  Var Result);  // Size=0 for Delphi-Boolean
        Class Function  DateTimeToXML(Const D: TDateTime; Option: Integer): TWideString;  // 1=Date 2=Time 4=mSec
        Class Function  isXMLDateTime(Const S: TWideString):                Boolean;
        Class Function  XMLToDateTime(Const S: TWideString):                TDateTime;
        Class Function  VariantToXML (Const V: Variant):                    TWideString;
        Class Procedure XMLToVariant (Const S: TWideString;     Var Result: Variant);

        Class Function  isChar       (C: WideChar): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  isSpace      (C: WideChar): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  isAlpha      (C: WideChar): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  isAlphaNum   (C: WideChar): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  isNum        (C: WideChar): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  isHex        (C: WideChar): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  isNameStart  (C: WideChar): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
      //Class Function  isNameStartEx(C: WideChar): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  isName       (C: WideChar): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Class Function  CheckString  (Const S: TWideString; CType: TXMLStringCheckType): Boolean;
        Class Function  ConvertString(Var   S: TWideString; CType: TXMLStringCheckType; Options: TXMLOptions; Const LineFeed, TextIndent, ValueQuotation: TWideString): Boolean; Overload;
        Class Function  ConvertString(Var   S: TWideString; CType: TXMLStringCheckType; Owner: TXMLFile): Boolean; Overload; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}

        {$IFNDEF hxExcludeSysutilsUnit}
          Class Procedure Serialize_RemoveData(Node: TXMLNode);
          Class Function  DeSerialize_GetNode (Node: TXMLNode;       Name: TWideString): TXMLNode;
          Class Procedure DeSerialize_GetText (Node: TXMLNode; Const Name: TWideString; DType: TXMLSerializeRDataType; Var Result; Size: Integer = 0); Overload;
          Class Procedure DeSerialize_GetText (Node: TXMLNode; Const Name: TWideString; VType: TVarType;               Var Result: Variant);           Overload;
          Class Procedure Serialize_Variant   (Node: TXMLNode; Const V:    Variant);
          Class Procedure DeSerialize_Variant (Node: TXMLNode; Var   V:    Variant);
          Class Procedure Serialize_Object    (Node: TXMLNode;       C:    TObject; SOptions: TXMLSerializeOptions; Proc: TXMLSerializeProc);
          Class Procedure DeSerialize_Object  (Node: TXMLNode;       C:    TObject; SOptions: TXMLSerializeOptions; Proc: TXMLSerializeProc);
          Class Procedure Serialize_Record    (Node: TXMLNode; Const Rec;           RecInfo:  TXMLSerializeRecordInfo);
          Class Procedure DeSerialize_Record  (Node: TXMLNode; Var   Rec;           RecInfo:  TXMLSerializeRecordInfo);

          // register a procedure for the (de)serilation
          Class Function  RegisterSerProc     (Proc: TXMLSerializeProc): Boolean;
          Class Procedure DeregisterSerProc   (Proc: TXMLSerializeProc);
          Class Function  isRegisteredSerProc (Proc: TXMLSerializeProc): Boolean;
          // register a class for the deserilation of an not existing object
          Class Function  RegisterSerClass    (C:    TClass):            Boolean;
          Class Procedure DeregisterSerClass  (C:    TClass);
          Class Function  isRegisteredSerClass(C:    TClass):            Boolean;
          // register a prozedure for property-value-serialization
          Class Procedure SetValueSerProc     (VType: TTypeKind; Const Name: AnsiString; SProc: TXMLValueSerialize; DProc: TXMLValueDeserialize; PrivParam: Integer = 0);
          Class Procedure GetValueSerProc     (Var List: TXMLValueSerializeArray);
        {$ENDIF}

        Class Procedure HandleException(E: Exception; Proc: TXMLExceptionEvent; Owner: TObject);
      Protected
        Class Procedure Initialize;
        Class Procedure Finalize;
      End;

    {***** classes : XML reader *******************************************************************}

      TXDataType = (xdInstruction, xdTypedef, xdElement, xdCData, xdComment, xdAttribute, xdEndAttribute, xdText, xdClose, xdCloseSingle);
      TXReader = Class
      {$IF DELPHI >= 2006}Strict{$IFEND} Protected
        _Stream:         TStream;
        _StreamStart:    Int64;
        _Buffer:         Record
                           Length, Pos: Integer;
                           Data:        Array[1..FileBufferSize + FileBufferSize_Overflow] of WideChar;
                           CharSize:    Array[1..FileBufferSize + FileBufferSize_Overflow] of AnsiChar;
                           XData:       TWideString;
                           XCharSize:   RawByteString;
                         End;
        _Lines, _Col:    Int64;
        _MoreDataExists: Boolean;
        _Temp:           Array[1..FileBufferSize] of AnsiChar;  // used in ReadData ... do not push this on every time to the stack
        _Options:        TXMLOptions;
        _Version:        TXMLVersion;
        _Encoding:       TXMLEncoding;

        _NodeType:       TXDataType;
        _DataType:       TXDataType;
        _Value, _Name:   TWideString;
        _LFBefore:       Boolean;

        Procedure SetBuffer(Size: Integer);
        Function  GetDataP:       PWideChar; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Function  GetCharSizeP:   PAnsiChar; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}

        Procedure ReadBOM;
        Function  ReadData: Boolean;
        Function  CheckLen  (L: Integer; Var i: Integer; Var P: PWideChar): Boolean;
        Function  CheckLB   (i, i2: Integer): Boolean;
        Function  Search    (Var P: PWideChar; Var i: Integer; T: Byte): Boolean;  // T = 0{isSpace...} 1{isName...} 2{..."} 3{...'} 4{...]]>} 5{...]]>} 6{...[...]>} 7{...<}
        Procedure CopyData  (Var S: TWideString; i, Len: Integer);
        Procedure DeleteTemp(Len: Integer);
        Procedure ClearTemp;
      Public
        Constructor Create(Stream: TStream; Options: TXMLOptions; StartEncoding: TXMLEncoding = xeUTF8);
        Property    Stream:   TStream     Read _Stream;
        Property    Options:  TXMLOptions Read _Options;
        Procedure   SetVer(Version:  TXMLVersion);  {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Procedure   SetEnc(Encoding: TXMLEncoding);
        Function    Parse:    Boolean;
        Procedure   CloseSingleNode;  // close an opend xdElement > istread to use is as invalid marked SingleNodeTag (TXMLFile.ParsedSingleTags)
        Property    NewLine:  Boolean     Read _LFBefore;
        Property    DataType: TXDataType  Read _DataType;
        Property    Value:    TWideString Read _Value;
        Property    Name:     TWideString Read _Name;
        Property    Lines:    Int64       Read _Lines;
        Property    Col:      Int64       Read _Col;
        Function    Position: Int64;   {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Function    Size:     Int64;   {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Function    EoF:      Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Destructor  Destroy;           Override;
      End;

    {***** classes : XML writer *******************************************************************}

      TXWriter = Class
        _Stream:         TStream;
        _StreamStart:    Int64;
        _Buffer:         Record
                           Length: Integer;
                           Data:   Array[1..FileBufferSize + FileBufferSize_Overflow] of WideChar;
                         End;
        _Lines, _Col:    Int64;
        _Options:        TXMLOptions;
        _LineFeed:       TWideString;
        _TextIndent:     TWideString;
        _ValueSeperator: TWideString;
        _ValueQuotation: TWideString;
        _Version:        TXMLVersion;
        _Encoding:       TXMLEncoding;
        _IndentLevel:    Integer;
        _SavedLineBreak: Boolean;

        Procedure WriteDataX(Data: PWideChar; Len: Integer);
        Procedure WriteData (Const Data: TWideString);
      Public
        Constructor Create   (Stream: TStream; Options: TXMLOptions; Const LineFeed, TextIndent, ValueSeperator, ValueQuotation: TWideString);
        Property    Stream:  TStream     Read _Stream;
        Property    Options: TXMLOptions Read _Options;
        Procedure   SetVer   (Version:      TXMLVersion);
        Procedure   SetEnc   (Encoding:     TXMLEncoding);
        Procedure   WriteBOM (AllowUTF8BOM: Boolean = False);
        Procedure   OpenNode (DataType: TXDataType; Const NodeName: TWideString);
        Procedure   WriteAttr(Const AttrName: TWideString; Value: TWideString; NewLine: Boolean = False);
        Procedure   WriteText(DataType: TXDataType; Text: TWideString);
        Procedure   CloseNode(DataType: TXDataType);                                                  Overload;
        Procedure   CloseNode(DataType: TXDataType; asSmallEmptyTag: Boolean; NoLF: Boolean = False); Overload;
        Procedure   CloseNode(Const NodeName: TWideString);                                           Overload;
        Procedure   CloseNotMarkedSingleNode;
        Procedure   WriteLF;
        Property    Lines:   Int64 Read _Lines;
        Property    Col:     Int64 Read _Col;
        Function    Size:    Int64; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Procedure   Flush;
        Destructor  Destroy; Override;
      End;

    {***** cryptor - open procedures **************************************************************}

    Procedure Crypt_Base64Decode(Const Source: TWideString; Var Dest: TByteDynArray);
    Procedure Crypt_Base64Encode(Const Source: TByteDynArray; Var Dest: TWideString);
    Procedure RC4Crypt(Var Text: TWideString; Const Data: AnsiString; Decrypt: Boolean; Attr: TXMLAttributes);

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'constants (forwarding)'}{$IFEND}

    {***** constants ******************************************************************************}

    Const XMLUseDefault    = '<default>';      // TXMLFile.FileTextIndent, TXMLFile.FileLineFeed and TXMLFile.AttrValueSep
      XMLUseDefaultOptions = [xo_useDefault];  // TXMLFile.Options
      XMLDefaultOptions    = [xoChangeInvalidChars, xoAllowUnknownText,
                               xoHideInstructionNodes, xoHideTypedefNodes, xoHideCDataNodes, xoHideUnknownNodes,
                               xoNodeAutoCreate, xoNodeAutoIndent, xoCDataNotAutoIndent];

  {$IF X}{$ENDREGION}{$IFEND}

Implementation

  {$IF X}{$REGION 'other'}{$IFEND}

    Const cHimXmlNamespace = 'hx'; {'himxml'}

      // This variables will be updated for every release
      // (I hope, I won't forget to do it everytime ...)
      TXMLFile_LibVersion = 'himXML DOM v0.99d';
      TSAXFile_LibVersion = 'himXML SAX v0.97';

      XMLVersionData: Array[TXMLVersion] of Record
        Version: TWideString;
      End = ((Version: '1.0'), (Version: '1.1'));

      XMLEncodingData: Array[TXMLEncoding] of Record
        BOM:      RawByteString;  // 4 bytes maximum
        Encoding: TWideString;
        CodePage: Word;
        CharSize: Byte;
      End = (
        ({xeUTF7}                                          Encoding: 'UTF-7';           CodePage: 65000; CharSize: 1),
        ({xeUTF8}        BOM: RawByteString(#$EF#$BB#$BF); Encoding: 'UTF-8';           CodePage: 65001; CharSize: 1),
      //({xeUTF16}                                         Encoding: 'UTF-16';          CodePage:  1200; CharSize: 2),
        ({xeUnicode}     BOM: RawByteString(#$FF#$FE);     Encoding: 'ISO-10646-UCS-2'; CodePage:  1200; CharSize: 2),
        ({xeUnicodeBE}   BOM: RawByteString(#$FE#$FF);                                  CodePage:  1201; CharSize: 2),
        ({xeIso8859_1}                                     Encoding: 'ISO-8859-1';      CodePage: 28591; CharSize: 1),
        ({xeIso8859_2}                                     Encoding: 'ISO-8859-2';      CodePage: 28592; CharSize: 1),
        ({xeIso8859_3}                                     Encoding: 'ISO-8859-3';      CodePage: 28593; CharSize: 1),
        ({xeIso8859_4}                                     Encoding: 'ISO-8859-4';      CodePage: 28594; CharSize: 1),
        ({xeIso8859_5}                                     Encoding: 'ISO-8859-5';      CodePage: 28595; CharSize: 1),
        ({xeIso8859_6}                                     Encoding: 'ISO-8859-6';      CodePage: 28596; CharSize: 1),
        ({xeIso8859_7}                                     Encoding: 'ISO-8859-7';      CodePage: 28597; CharSize: 1),
        ({xeIso8859_8}                                     Encoding: 'ISO-8859-8';      CodePage: 28598; CharSize: 1),
        ({xeIso8859_9}                                     Encoding: 'ISO-8859-9';      CodePage: 28599; CharSize: 1),
        ({xeIso2022Jp}                                     Encoding: 'ISO-2022-JP';     CodePage: 50220; CharSize: 1),
        ({xeEucJp}                                         Encoding: 'EUC-JP';          CodePage: 51932; CharSize: 1),
        ({xeShiftJis}                                      Encoding: 'SHIFT-JIS';       CodePage:   932; CharSize: 1),
        ({xeWindows1250}                                   Encoding: 'WINDOWS-1250';    CodePage:  1250; CharSize: 1),
        ({xeWindows1251}                                   Encoding: 'WINDOWS-1251';    CodePage:  1251; CharSize: 1),
        ({xeWindows1252}                                   Encoding: 'WINDOWS-1252';    CodePage:  1252; CharSize: 1),
        ({xeWindows1253}                                   Encoding: 'WINDOWS-1253';    CodePage:  1253; CharSize: 1),
        ({xeWindows1254}                                   Encoding: 'WINDOWS-1254';    CodePage:  1254; CharSize: 1),
        ({xeWindows1255}                                   Encoding: 'WINDOWS-1255';    CodePage:  1255; CharSize: 1),
        ({xeWindows1256}                                   Encoding: 'WINDOWS-1256';    CodePage:  1256; CharSize: 1),
        ({xeWindows1257}                                   Encoding: 'WINDOWS-1257';    CodePage:  1257; CharSize: 1),
        ({xeWindows1258}                                   Encoding: 'WINDOWS-1258';    CodePage:  1258; CharSize: 1));

      HTMLNamedEntities: Array[-5..238] of Record
        Char:   WideChar;
        Entity: TWideString;
      End = (
        (Char: '&';    Entity: '&amp;'),
        (Char: '<';    Entity: '&lt;'),      (Char: '>';    Entity: '&gt;'),
        (Char: '"';    Entity: '&quot;'),    (Char: '''';   Entity: '&apos;'),

        (Char: #$00A0; Entity: '&nbsp;'),
        (Char: #$00A1; Entity: '&iexcl;'),
        (Char: #$00A2; Entity: '&cent;'),    (Char: #$00A3; Entity: '&pound;'),
        (Char: #$00A4; Entity: '&curren;'),  (Char: #$00A5; Entity: '&yen;'),
        (Char: #$00A6; Entity: '&brvbar;'),
        (Char: #$00A7; Entity: '&sect;'),
        (Char: #$00A9; Entity: '&copy;'),    (Char: #$00AE; Entity: '&reg;'),
        (Char: #$00AA; Entity: '&ordf;'),    (Char: #$00B0; Entity: '&deg;'),
        (Char: #$00BA; Entity: '&ordm;'),    (Char: #$00B9; Entity: '&sup1;'),
        (Char: #$00B2; Entity: '&sup2;'),    (Char: #$00B3; Entity: '&sup3;'),
        (Char: #$00AB; Entity: '&laquo;'),   (Char: #$00BB; Entity: '&raquo;'),
        (Char: #$00AC; Entity: '&not;'),
        (Char: #$00AD; Entity: '&shy;'),
        (Char: #$00AF; Entity: '&macr;'),
        (Char: #$00B1; Entity: '&plusmn;'),
        (Char: #$00B5; Entity: '&micro;'),
        (Char: #$00B6; Entity: '&para;'),
        (Char: #$00B7; Entity: '&middot;'),
        (Char: #$00BC; Entity: '&frac14;'),  (Char: #$00BD; Entity: '&frac12;'),
        (Char: #$00BE; Entity: '&frac34;'),
        (Char: #$00BF; Entity: '&iquest;'),

        (Char: #$00B4; Entity: '&acute;'),
        (Char: #$00A8; Entity: '&uml;'),
        (Char: #$00B8; Entity: '&cedil;'),
        (Char: #$00C0; Entity: '&Agrave;'),  (Char: #$00E0; Entity: '&agrave;'),
        (Char: #$00C1; Entity: '&Aacute;'),  (Char: #$00E1; Entity: '&aacute;'),
        (Char: #$00C2; Entity: '&Acirc;'),   (Char: #$00E2; Entity: '&acirc;'),
        (Char: #$00C3; Entity: '&Atilde;'),  (Char: #$00E3; Entity: '&atilde;'),
        (Char: #$00C4; Entity: '&Auml;'),    (Char: #$00E4; Entity: '&auml;'),
        (Char: #$00C5; Entity: '&Aring;'),   (Char: #$00E5; Entity: '&aring;'),
        (Char: #$00C6; Entity: '&AElig;'),   (Char: #$00E6; Entity: '&aelig;'),
        (Char: #$00C7; Entity: '&Ccedil;'),  (Char: #$00E7; Entity: '&ccedil;'),
        (Char: #$00C8; Entity: '&Egrave;'),  (Char: #$00E8; Entity: '&egrave;'),
        (Char: #$00C9; Entity: '&Eacute;'),  (Char: #$00E9; Entity: '&eacute;'),
        (Char: #$00CA; Entity: '&Ecirc;'),   (Char: #$00EA; Entity: '&ecirc;'),
        (Char: #$00CB; Entity: '&Euml;'),    (Char: #$00EB; Entity: '&euml;'),
        (Char: #$00CC; Entity: '&Igrave;'),  (Char: #$00EC; Entity: '&igrave;'),
        (Char: #$00CD; Entity: '&Iacute;'),  (Char: #$00ED; Entity: '&iacute;'),
        (Char: #$00CE; Entity: '&Icirc;'),   (Char: #$00EE; Entity: '&icirc;'),
        (Char: #$00CF; Entity: '&Iuml;'),    (Char: #$00EF; Entity: '&iuml;'),
        (Char: #$00D0; Entity: '&ETH;'),     (Char: #$00F0; Entity: '&eth;'),
        (Char: #$00D1; Entity: '&Ntilde;'),  (Char: #$00F1; Entity: '&ntilde;'),
        (Char: #$00D2; Entity: '&Ograve;'),  (Char: #$00F2; Entity: '&ograve;'),
        (Char: #$00D3; Entity: '&Oacute;'),  (Char: #$00F3; Entity: '&oacute;'),
        (Char: #$00D4; Entity: '&Ocirc;'),   (Char: #$00F4; Entity: '&ocirc;'),
        (Char: #$00D5; Entity: '&Otilde;'),  (Char: #$00F5; Entity: '&otilde;'),
        (Char: #$00D6; Entity: '&Ouml;'),    (Char: #$00F6; Entity: '&ouml;'),
        (Char: #$00D7; Entity: '&times;'),
        (Char: #$00D8; Entity: '&Oslash;'),  (Char: #$00F8; Entity: '&oslash;'),
        (Char: #$00D9; Entity: '&Ugrave;'),  (Char: #$00F9; Entity: '&ugrave;'),
        (Char: #$00DA; Entity: '&Uacute;'),  (Char: #$00FA; Entity: '&uacute;'),
        (Char: #$00DB; Entity: '&Ucirc;'),   (Char: #$00FB; Entity: '&ucirc;'),
        (Char: #$00DC; Entity: '&Uuml;'),    (Char: #$00FC; Entity: '&uuml;'),
        (Char: #$00DD; Entity: '&Yacute;'),  (Char: #$00FD; Entity: '&yacute;'),
        (Char: #$00DE; Entity: '&THORN;'),   (Char: #$00FE; Entity: '&thorn;'),
        (Char: #$00DF; Entity: '&szlig;'),
        (Char: #$00F7; Entity: '&divide;'),
        (Char: #$00FF; Entity: '&yuml;'),

        (Char: #$0391; Entity: '&Alpha;'),   (Char: #$03B1; Entity: '&alpha;'),
        (Char: #$0392; Entity: '&Beta;'),    (Char: #$03B2; Entity: '&beta;'),
        (Char: #$0393; Entity: '&Gamma;'),   (Char: #$03B3; Entity: '&gamma;'),
        (Char: #$0394; Entity: '&Delta;'),   (Char: #$03B4; Entity: '&delta;'),
        (Char: #$0395; Entity: '&Epsilon;'), (Char: #$03B5; Entity: '&epsilon;'),
        (Char: #$0396; Entity: '&Zeta;'),    (Char: #$03B6; Entity: '&zeta;'),
        (Char: #$0397; Entity: '&Eta;'),     (Char: #$03B7; Entity: '&eta;'),
        (Char: #$0398; Entity: '&Theta;'),   (Char: #$03B8; Entity: '&theta;'),
        (Char: #$0399; Entity: '&Iota;'),    (Char: #$03B9; Entity: '&iota;'),
        (Char: #$039A; Entity: '&Kappa;'),   (Char: #$03BA; Entity: '&kappa;'),
        (Char: #$039B; Entity: '&Lambda;'),  (Char: #$03BB; Entity: '&lambda;'),
        (Char: #$039C; Entity: '&Mu;'),      (Char: #$03BC; Entity: '&mu;'),
        (Char: #$039D; Entity: '&Nu;'),      (Char: #$03BD; Entity: '&nu;'),
        (Char: #$039E; Entity: '&Xi;'),      (Char: #$03BE; Entity: '&xi;'),
        (Char: #$039F; Entity: '&Omicron;'), (Char: #$03BF; Entity: '&omicron;'),
        (Char: #$03A0; Entity: '&Pi;'),      (Char: #$03C0; Entity: '&pi;'),
        (Char: #$03A1; Entity: '&Rho;'),     (Char: #$03C1; Entity: '&rho;'),
        (Char: #$03A3; Entity: '&Sigma;'),   (Char: #$03C3; Entity: '&sigma;'),
        (Char: #$03C2; Entity: '&sigmaf;'),
        (Char: #$03A4; Entity: '&Tau;'),     (Char: #$03C4; Entity: '&tau;'),
        (Char: #$03A5; Entity: '&Upsilon;'), (Char: #$03C5; Entity: '&upsilon;'),
        (Char: #$03A6; Entity: '&Phi;'),     (Char: #$03C6; Entity: '&phi;'),
        (Char: #$03A7; Entity: '&Chi;'),     (Char: #$03C7; Entity: '&chi;'),
        (Char: #$03A8; Entity: '&Psi;'),     (Char: #$03C8; Entity: '&psi;'),
        (Char: #$03A9; Entity: '&Omega;'),   (Char: #$03C9; Entity: '&omega;'),
        (Char: #$03D1; Entity: '&thetasym;'),
        (Char: #$03D2; Entity: '&upsih;'),
        (Char: #$03D6; Entity: '&piv;'),

        (Char: #$2200; Entity: '&forall;'),  (Char: #$2202; Entity: '&part;'),
        (Char: #$2203; Entity: '&exist;'),   (Char: #$2205; Entity: '&empty;'),
        (Char: #$2207; Entity: '&nabla;'),   (Char: #$2208; Entity: '&isin;'),
        (Char: #$2209; Entity: '&notin;'),   (Char: #$220B; Entity: '&ni;'),
        (Char: #$220F; Entity: '&prod;'),    (Char: #$2211; Entity: '&sum;'),
        (Char: #$2212; Entity: '&minus;'),   (Char: #$2217; Entity: '&lowast;'),
        (Char: #$221A; Entity: '&radic;'),   (Char: #$221D; Entity: '&prop;'),
        (Char: #$221E; Entity: '&infin;'),   (Char: #$2220; Entity: '&ang;'),
        (Char: #$22A5; Entity: '&and;'),     (Char: #$22A6; Entity: '&or;'),
        (Char: #$2229; Entity: '&cap;'),     (Char: #$222A; Entity: '&cup;'),
        (Char: #$222B; Entity: '&int;'),     (Char: #$2234; Entity: '&there4;'),
        (Char: #$223C; Entity: '&sim;'),     (Char: #$2245; Entity: '&cong;'),
        (Char: #$2248; Entity: '&asymp;'),   (Char: #$2260; Entity: '&ne;'),
        (Char: #$2261; Entity: '&equiv;'),   (Char: #$2264; Entity: '&le;'),
        (Char: #$2265; Entity: '&ge;'),      (Char: #$2282; Entity: '&sub;'),
        (Char: #$2283; Entity: '&sup;'),     (Char: #$2284; Entity: '&nsub;'),
        (Char: #$2286; Entity: '&sube;'),    (Char: #$2287; Entity: '&supe;'),
        (Char: #$2295; Entity: '&oplus;'),   (Char: #$2297; Entity: '&otimes;'),
        (Char: #$22A5; Entity: '&perp;'),    (Char: #$22C5; Entity: '&sdot;'),
        (Char: #$25CA; Entity: '&loz;'),

        (Char: #$2308; Entity: '&lceil;'),   (Char: #$2309; Entity: '&rceil;'),
        (Char: #$230A; Entity: '&lfloor;'),  (Char: #$230B; Entity: '&rfloor;'),
        (Char: #$2329; Entity: '&lang;'),    (Char: #$232A; Entity: '&rang;'),

        (Char: #$2190; Entity: '&larr;'),    (Char: #$21D0; Entity: '&lArr;'),
        (Char: #$2191; Entity: '&uarr;'),    (Char: #$21D1; Entity: '&uArr;'),
        (Char: #$2192; Entity: '&rarr;'),    (Char: #$21D2; Entity: '&rArr;'),
        (Char: #$2193; Entity: '&darr;'),    (Char: #$21D3; Entity: '&dArr;'),
        (Char: #$2194; Entity: '&harr;'),    (Char: #$21D4; Entity: '&hArr;'),
        (Char: #$21B5; Entity: '&crarr;'),

        (Char: #$2022; Entity: '&bull;'),    (Char: #$2026; Entity: '&hellip;'),
        (Char: #$2032; Entity: '&prime;'),   (Char: #$203E; Entity: '&oline;'),
        (Char: #$2044; Entity: '&frasl;'),   (Char: #$2118; Entity: '&weierp;'),
        (Char: #$2111; Entity: '&image;'),   (Char: #$211C; Entity: '&real;'),
        (Char: #$2122; Entity: '&trade;'),   (Char: #$20AC; Entity: '&euro;'),
        (Char: #$2135; Entity: '&alefsym;'), (Char: #$2660; Entity: '&spades;'),
        (Char: #$2663; Entity: '&clubs;'),   (Char: #$2665; Entity: '&hearts;'),
        (Char: #$2666; Entity: '&diams;'),

        (Char: #$2002; Entity: '&ensp;'),    (Char: #$2003; Entity: '&emsp;'),
        (Char: #$2009; Entity: '&thinsp;'),
        (Char: #$200C; Entity: '&zwnj;'),    (Char: #$200D; Entity: '&zwj;'),
        (Char: #$200E; Entity: '&lrm;'),     (Char: #$200F; Entity: '&rlm;'),
        (Char: #$2013; Entity: '&ndash;'),   (Char: #$2014; Entity: '&mdash;'),
        (Char: #$2018; Entity: '&lsquo;'),   (Char: #$2019; Entity: '&rsquo;'),
        (Char: #$201A; Entity: '&sbquo;'),
        (Char: #$201C; Entity: '&ldquo;'),   (Char: #$201D; Entity: '&rdquo;'),
        (Char: #$201E; Entity: '&bdquo;'),
        (Char: #$2020; Entity: '&dagger;'),  (Char: #$2021; Entity: '&Dagger;'),
        (Char: #$2030; Entity: '&permil;'),
        (Char: #$2039; Entity: '&lsaquo;'),  (Char: #$203A; Entity: '&rsaquo;'));

      {$IFDEF hxExcludeClassesUnit}
        fmCreate = $FFFF;
      {$ENDIF}

      ColorStrings: Array[0..51] of Record
        Value: LongWord{TColor};
        Name:  TWideString;
      End = (
        (Value: $000000; Name: 'clBlack'),   (Value: $000080; Name: 'clMaroon'),     (Value: $008000; Name: 'clGreen'),
        (Value: $008080; Name: 'clOlive'),   (Value: $800000; Name: 'clNavy'),       (Value: $800080; Name: 'clPurple'),
        (Value: $808000; Name: 'clTeal'),    (Value: $808080; Name: 'clGray'),       (Value: $808080; Name: 'clDkGray'),
        (Value: $A4A0A0; Name: 'clMedGray'), (Value: $C0C0C0; Name: 'clSilver'),     (Value: $C0C0C0; Name: 'clLtGray'),
        (Value: $0000FF; Name: 'clRed'),     (Value: $00FF00; Name: 'clLime'),       (Value: $00FFFF; Name: 'clYellow'),
        (Value: $FF0000; Name: 'clBlue'),    (Value: $FF00FF; Name: 'clFuchsia'),    (Value: $FFFF00; Name: 'clAqua'),
        (Value: $FFFFFF; Name: 'clWhite'),   (Value: $C0DCC0; Name: 'clMoneyGreen'), (Value: $F0CAA6; Name: 'clSkyBlue'),
        (Value: $F0FBFF; Name: 'clCream'),
        (Value: $FF000000; Name: 'clScrollBar'),             (Value: $FF000001; Name: 'clBackground'),
        (Value: $FF000002; Name: 'clActiveCaption'),         (Value: $FF000003; Name: 'clInactiveCaption'),
        (Value: $FF000004; Name: 'clMenu'),                  (Value: $FF000005; Name: 'clWindow'),
        (Value: $FF000006; Name: 'clWindowFrame'),           (Value: $FF000007; Name: 'clMenuText'),
        (Value: $FF000008; Name: 'clWindowText'),            (Value: $FF000009; Name: 'clCaptionText'),
        (Value: $FF00000A; Name: 'clActiveBorder'),          (Value: $FF00000B; Name: 'clInactiveBorder'),
        (Value: $FF00000C; Name: 'clAppWorkSpace'),          (Value: $FF00000D; Name: 'clHighlight'),
        (Value: $FF00000E; Name: 'clHighlightText'),         (Value: $FF00000F; Name: 'clBtnFace'),
        (Value: $FF000010; Name: 'clBtnShadow'),             (Value: $FF000011; Name: 'clGrayText'),
        (Value: $FF000012; Name: 'clBtnText'),               (Value: $FF000013; Name: 'clInactiveCaptionText'),
        (Value: $FF000014; Name: 'clBtnHighlight'),          (Value: $FF000015; Name: 'cl3DDkShadow'),
        (Value: $FF000016; Name: 'cl3DLight'),               (Value: $FF000017; Name: 'clInfoText'),
        (Value: $FF000018; Name: 'clInfoBk'),                (Value: $FF00001A; Name: 'clHotLight'),
        (Value: $FF00001B; Name: 'clGradientActiveCaption'), (Value: $FF00001C; Name: 'clGradientInactiveCaption'),
        (Value: $FF00001D; Name: 'clMenuHighlight'),         (Value: $FF00001E; Name: 'clMenuBar'));

      {$IFNDEF hxExcludeSysutilsUnit}

        TransformSerializeTypes: Array[TXMLSerializeRDataType] of TXMLSerializeRDataType = (
          rtBoolean, rtByteBool, rtWordBool, rtLongBool, {$If SizeOf(BOOL) = 4}rtLongBool{$ELSE}TXMLSerializeRDataType(-1){$IFEND},
          rtByte, rtWord, rtLongWord, rtWord64, rtWord64, rtWord64LE, {$If SizeOf(Cardinal) = 4}rtLongWord{$ELSE}{$If SizeOf(Cardinal) = 8}rtWord64{$ELSE}TXMLSerializeRDataType(-1){$IFEND}{$IFEND},
          rtShortInt, rtSmallInt, rtLongInt, rtInt64, rtInt64, rtInt64LE, {$If SizeOf(Integer) = 4}rtLongInt{$ELSE}{$If SizeOf(Integer) = 8}rtInt64{$ELSE}TXMLSerializeRDataType(-1){$IFEND}{$IFEND},
          rtSingle, rtDouble, rtExtended, {$If SizeOf(Real) = 4}rtSingle{$ELSE}{$If SizeOf(Real) = 8}rtDouble{$ELSE}{$If SizeOf(Real) = 10}rtExtended{$ELSE}TXMLSerializeRDataType(-1){$IFEND}{$IFEND}{$IFEND}, rtCurrency, rtDateTime,
          rtAnsiCharArray, rtWideCharArray, {$If SizeOf(Char) = 1}rtAnsiCharArray{$ELSE}{$If SizeOf(Char) = 2}rtWideCharArray{$ELSE}TXMLSerializeRDataType(-1){$IFEND}{$IFEND}, rtUtf8String,
          rtShortString, rtAnsiString, rtWideString, rtUnicodeString, {$If SizeOf(Char) = 1}rtAnsiString{$ELSE}{$If SizeOf(Char) = 2}{$IF Declared(UnicodeString)}rtUnicodeString{$ELSE}rtWideString{$IFEND}{$ELSE}TXMLSerializeRDataType(-1){$IFEND}{$IFEND},
          rtBinary, rtPointer{=rtDynBinary}, rtVariant, rtObject,
          rtRecord, rtArray, rtDynArray, rtDummy, rtAlign, rtSplit);

        SerializeTypes: Array[0..43] of Record
            Key:      Char;
            Typ:      TXMLSerializeRDataType;
            Size:     Char;
            Elements: Boolean;
          End = (
            {Key: 'L'; Typ: SetAlign                                  }
            (Key: 'b'; Typ: rtBoolean                                 ),
            (Key: 'b'; Typ: rtByteBool;      Size: '1'                ),
            (Key: 'b'; Typ: rtWordBool;      Size: '2'                ),
            (Key: 'b'; Typ: rtLongBool;      Size: '4'                ),
            (Key: 'b'; Typ: rtBOOL{*};       Size: 'x'                ),
            (Key: 'w'; Typ: rtByte;          Size: '1'                ),
            (Key: 'w'; Typ: rtWord;          Size: '2'                ),
            (Key: 'w'; Typ: rtLongWord;      Size: '4'                ),
            (Key: 'w'; Typ: rtWord64;        Size: '8'                ),
            (Key: 'w'; Typ: rtWord64BE;      Size: 'e'                ),
            (Key: 'w'; Typ: rtWord64LE;      Size: 'x'                ),
            (Key: 'w'; Typ: rtCardinal{*}                             ),
            (Key: 'i'; Typ: rtShortInt;      Size: '1'                ),
            (Key: 'i'; Typ: rtSmallInt;      Size: '2'                ),
            (Key: 'i'; Typ: rtLongInt;       Size: '4'                ),
            (Key: 'i'; Typ: rtInt64;         Size: '8'                ),
            (Key: 'i'; Typ: rtInt64BE;       Size: 'e'                ),
            (Key: 'i'; Typ: rtInt64LE;       Size: 'x'                ),
            (Key: 'i'; Typ: rtInteger{*}                              ),
            (Key: 'f'; Typ: rtSingle;        Size: '4'                ),
            (Key: 'f'; Typ: rtDouble;        Size: '8'                ),
            (Key: 'f'; Typ: rtExtended;      Size: '0'                ),
            (Key: 'f'; Typ: rtReal{*}                                 ),
            (Key: 'y'; Typ: rtCurrency                                ),
            (Key: 't'; Typ: rtDateTime                                ),
            (Key: 'c'; Typ: rtAnsiCharArray; Size: 'a'; Elements: True),
            (Key: 'c'; Typ: rtWideCharArray; Size: 'w'; Elements: True),
            (Key: 'c'; Typ: rtCharArray{*};             Elements: True),
            (Key: 'u'; Typ: rtUtf8String                              ),
            (Key: 's'; Typ: rtShortString;   Size: 's'; Elements: True),
            (Key: 's'; Typ: rtAnsiString;    Size: 'a'                ),
            (Key: 's'; Typ: rtWideString;    Size: 'w'                ),
            (Key: 's'; Typ: rtUnicodeString; Size: 'u'                ),
            (Key: 's'; Typ: rtString{*}                               ),
            (Key: 'x'; Typ: rtBinary;                   Elements: True),
            (Key: 'p'; Typ: rtPointer{=rtDynBinary};    Elements: True),
            (Key: 'v'; Typ: rtVariant                                 ),
            (Key: 'o'; Typ: rtObject                                  ),
            (Key: 'r'; Typ: rtRecord                                  ),
            (Key: 'a'; Typ: rtArray;                    Elements: True),
            (Key: 'd'; Typ: rtDynArray                                ),
            (Key: 'm'; Typ: rtDummy;                    Elements: True),
            (Key: 'n'; Typ: rtAlign;                    Elements: True),
            (Key: 'n'; Typ: rtSplit;         Size: 'x'; Elements: True));

      {$ENDIF}

    {$IF DELPHI < 2006}

      Const MaxXMLErrStr = 50;

      Var TXMLFile__DefaultOptions:      TXMLOptions;
        TXMLFile__DefaultTextIndent:     TWideString;
        TXMLFile__DefaultLineFeed:       TWideString;
        TXMLFile__DefaultValueSeperator: TWideString;
        TXMLFile__DefaultValueQuotation: TWideString;
        TXMLFile__PathDelimiter:         TWideString;
        TXHelper__ShlWAPI:               THandle;
        TXHelper__StrCmpLogicalW:        Function(Const S1, S2: TWideString): Integer; StdCall;
        TXHelper__LockCArr:              TRTLCriticalSection;
        TXHelper__CArr:                  TChangeArray;
        TXHelper__CompareBlock0:         Array[$0040..$007F {040}] of WideChar;
        TXHelper__CompareBlock1:         Array[$00C0..$029F {1E0}] of WideChar;
        TXHelper__CompareBlock2:         Array[$0370..$058F {220}] of WideChar;
        TXHelper__CompareBlock3:         Array[$10A0..$10FF {060}] of WideChar;
        TXHelper__CompareBlock4:         Array[$1D78..$1D7F {008}] of WideChar;
        TXHelper__CompareBlock5:         Array[$1E00..$1FFF {200}] of WideChar;
        TXHelper__CompareBlock6:         Array[$2130..$218F {060}] of WideChar;
        TXHelper__CompareBlock7:         Array[$24B0..$24EF {040}] of WideChar;
        TXHelper__CompareBlock8:         Array[$2C00..$2D2F {130}] of WideChar;
        TXHelper__CompareBlock9:         Array[$A640..$A78F {150}] of WideChar;
        TXHelper__CompareBlockA:         Array[$FF20..$FF5F {040}] of WideChar;
        TXHelper__LowerBlock0:           Array[$0040..$007F {040}] of WideChar;
        TXHelper__LowerBlock1:           Array[$00C0..$029F {1E0}] of WideChar;
        TXHelper__LowerBlock2:           Array[$0370..$058F {220}] of WideChar;
        TXHelper__LowerBlock3:           Array[$10A0..$10FF {060}] of WideChar;
        TXHelper__LowerBlock4:           Array[$1D78..$1D7F {008}] of WideChar;
        TXHelper__LowerBlock5:           Array[$1E00..$1FFF {200}] of WideChar;
        TXHelper__LowerBlock6:           Array[$2130..$218F {060}] of WideChar;
        TXHelper__LowerBlock7:           Array[$24B0..$24EF {040}] of WideChar;
        TXHelper__LowerBlock8:           Array[$2C00..$2D2F {130}] of WideChar;
        TXHelper__LowerBlock9:           Array[$A640..$A78F {150}] of WideChar;
        TXHelper__LowerBlockA:           Array[$FF20..$FF5F {040}] of WideChar;
        TXHelper__SerializeProzedure:    Array of TXMLSerializeProc;
        TXHelper__SerializeClass:        Array of TClass;
        TXHelper__ValueSerializeProcs:   TXMLValueSerializeArray;

    {$IFEND}

    Function ColorVSerial(Const Value: Variant; PrivParam: Integer): TWideString;
      Var i, i2: Integer;

      Begin
        i2 := Value;
        For i := High(ColorStrings) downto 0 do
          If LongInt(ColorStrings[i].Value) = i2 Then Begin
            Result := ColorStrings[i].Name;
            Exit;
          End;
        Result := Value;
      End;

    Function ColorVDeserial(Const Value: TWideString; PrivParam: Integer): Variant;
      Var i: Integer;

      Begin
        For i := High(ColorStrings) downto 0 do
          If TXHelper.SameTextW(ColorStrings[i].Name, Value, False) Then Begin
            Result := Integer(ColorStrings[i].Value);
            Exit;
          End;
        Result := Value;
      End;

    Function DateTimeVSerial(Const Value: Variant; PrivParam: Integer): TWideString;
      Begin
        Result := TXHelper.DateTimeToXML(Value, PrivParam);
      End;

    Function DateTimeVDeserial(Const Value: TWideString; PrivParam: Integer): Variant;
      Begin
        Result := TXHelper.XMLToDateTime(Value);
      End;

    Procedure Crypt_Base64Decode(Const Source: TWideString; Var Dest: TByteDynArray);
      Type TByteArray = Array[0..2] of Byte;

      Var Base:   Array[$00..$7F] of Byte;
        L, i, i2: Integer;
        Pb:       ^TByteArray;
        Ps:       PWideChar;
        D:        Array[0..3] of Byte;

      Begin
        // init
        FillMemory(@Base, SizeOf(Base), $FF);
        For i :=  0 to 25 do Base[Ord('A') + i]    := i;
        For i := 26 to 51 do Base[Ord('a') + i-26] := i;
        For i := 52 to 61 do Base[Ord('0') + i-52] := i;
        Base[Ord('+')] := 62;
        Base[Ord('/')] := 63;
        Base[Ord('=')] := 88;

        // calc len
        Ps := PWideChar(Source);
        L  := Length(Source);
        For i := L - 1 downto 0 do Begin
          If Ps^ < ' ' Then Dec(L);
          Inc(Ps);
        End;
        L := L div 4 * 3;
        If (Source <> '') and (Ps[-1] = '=') Then Begin
          Dec(L);
          If (Length(Source) >= 2) and (Ps[-2] = '=') Then Dec(L);
        End;

        SetLength(Dest, L);
        Ps := PWideChar(Source);
        Pb := Pointer(Dest);
        i  := Length(Source);
        While True do Begin
          PLongWord(@D)^ := $FFFFFFFF;
          i2 := 0;
          While (i > 0) and (i2 < 4) do Begin
            If Ps^ > ' ' Then Begin
              If Ps^ <= #$007F Then D[i2] := Base[Byte(Ps^)];
              Inc(i2);
            End;
            Inc(Ps);
            Dec(i);
          End;
          If i2 = 0 Then Break;
          If (D[0] <= 63) and (D[1] <= 63) and (D[2] = 88) and (D[3] = 88) Then Begin
            Dec(L, 1);
            If L >= 0 Then
              Pb[0] := D[0] shl 2 or D[1] shr 4;
            Break;
          End Else If (D[0] <= 63) and (D[1] <= 63) and (D[2] <= 63) and (D[3] = 88) Then Begin
            Dec(L, 2);
            If L >= 0 Then Begin
              Pb[0] := D[0] shl 2 or D[1] shr 4;
              Pb[1] := D[1] shl 4 or D[2] shr 2;
            End;
            Break;
          End Else If (D[0] <= 63) and (D[1] <= 63) and (D[2] <= 63) and (D[3] <= 63) Then Begin
            Dec(L, 3);
            If L >= 0 Then Begin
              Pb[0] := D[0] shl 2 or D[1] shr 4;
              Pb[1] := D[1] shl 4 or D[2] shr 2;
              Pb[2] := D[2] shl 6 or D[3];
              Inc(Pb);
            End Else Break;
          End Else Break;
        End;
        If (L < 0) or (i > 0) Then Raise EXMLException.Create(TXMLFile,
          'Crypt_Base64Decode', @SCorupptedBase64, Source);
      End;

    Procedure Crypt_Base64Encode(Const Source: TByteDynArray; Var Dest: TWideString);
      Type TByteArray = Array[0..2] of Byte;

      Var i:  Integer;
        Base: Array[0..63] of WideChar;
        Pv:   ^TByteArray;
        Ps:   PWideChar;

      Begin
        // init
        For i :=  0 to 25 do Base[i] := WideChar(Ord('A') + i);
        For i := 26 to 51 do Base[i] := WideChar(Ord('a') + i-26);
        For i := 52 to 61 do Base[i] := WideChar(Ord('0') + i-52);
        Base[62] := '+';
        Base[63] := '/';

        SetLength(Dest, ((Length(Source) + 2) div 3 * 4) + ((Length(Source) - 1) div (3*200)));
        Pv := Pointer(Source);
        Ps := PWideChar(Dest);
        For i := 1 to Length(Source) div 3 do Begin
          Ps^ := Base[ Pv[0] shr 2];                          Inc(Ps);
          Ps^ := Base[(Pv[0] shl 4 or Pv[1] shr 4) and $3F];  Inc(Ps);
          Ps^ := Base[(Pv[1] shl 2 or Pv[2] shr 6) and $3F];  Inc(Ps);
          Ps^ := Base[ Pv[2]                       and $3F];  Inc(Ps);
          Inc(Pv);
          If i mod 200 = 0 Then Begin  Ps^ := #$0A;  Inc(Ps);  End;
        End;
        Case Length(Source) mod 3 of
          1: Begin
            Ps^ := Base[ Pv[0] shr 2];           Inc(Ps);
            Ps^ := Base[(Pv[0] shl 4) and $3F];  Inc(Ps);
            Ps^ := '=';                          Inc(Ps);
            Ps^ := '=';
          End;
          2: Begin
            Ps^ := Base[ Pv[0] shr 2];                          Inc(Ps);
            Ps^ := Base[(Pv[0] shl 4 or Pv[1] shr 4) and $3F];  Inc(Ps);
            Ps^ := Base[(Pv[1] shl 2)                and $3F];  Inc(Ps);
            Ps^ := '=';
          End;
        End;
      End;

    Procedure RC4Crypt(Var Text: TWideString; Const Data: AnsiString; Decrypt: Boolean; Attr: TXMLAttributes);
      Var sBox:  Array[Byte] of Byte;
        i, j, k: Integer;
        Temp:    Byte;
        S:       TByteDynArray;

      Begin
        // init
        For i := Low(sBox) to High(sBox) do sBox[i] := i;
        j := 0;
        For i := 0 to High(sBox) do Begin
          j := Byte(j + sBox[i] + Ord(Data[i mod Length(Data) + 1]));
          Temp    := sBox[i];
          sBox[i] := sBox[j];
          sBox[j] := Temp;
        End;

        If not Decrypt Then Begin
          SetLength(S, (Length(Text) + 1) * 2);
          PWord(S)^ := Random($FFFF);
          MoveMemory(@S[2], Pointer(Text), Length(S) - 2);
        End Else Crypt_Base64Decode(Text, S);

        // calc
        SetLength(S, Length(S));
        i := 0;
        j := 0;
        For k := 0 to High(S) do Begin
          i := Byte(i + 1);
          j := Byte(j + sBox[i]);
          Temp    := sBox[i];
          sBox[i] := sBox[j];
          sBox[j] := Temp;
          S[k] := sBox[Byte(sBox[i] + sBox[j])] xor S[k];
        End;

        If Decrypt Then Begin
          SetLength(Text, Length(S) div 2 - 1);
          If Length(S) > 2 Then MoveMemory(Pointer(Text), @S[2], Length(S));
        End Else Crypt_Base64Encode(S, Text);
      End;

    {$IF not Declared(GetPropName) and not Defined(hxExcludeSysutilsUnit)}

      Function GetPropName(PropInfo: PPropInfo): String;
        Begin
          Result := PropInfo^.Name;
        End;

    {$IFEND}
    {$IFNDEF hxExcludeTIndex}

      Class Operator TIndex.Implicit(Value: Integer): TIndex;
        Begin
          Result.ValueType   := vtIntValue;
          Result.IntValue    := Value;
          Result.StringValue := '';
        End;

      Class Operator TIndex.Implicit(Const Value: TWideString): TIndex;
        Begin
          Result.ValueType   := vtStringValue;
          Result.IntValue    := 0;
          Result.StringValue := Value;
        End;

    {$ENDIF}
    {$IF DELPHI >= 2006}

      Procedure TAssocStringArray.SetCaseSensitive(Value: Boolean);
        Var i: Integer;

        Begin
          For i := High(_Data) downto 0 do
            If not Value and (IndexOf(_Data[i].Name) <> i) Then System.Error(reRangeError);
          _CaseSensitive := Value;
        End;

      Function TAssocStringArray.GetCount: Integer;
        Begin
          Result := Length(_Data);
        End;

      Function TAssocStringArray.GetName(Index: Integer): TWideString;
        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then Result := _Data[Index].Name
          Else If _ExceptOnError Then System.Error(reRangeError) Else Result := '';
        End;

      Procedure TAssocStringArray.SetName(Index: Integer; Const Value: TWideString);
        Var i: Integer;

        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then Begin
            i := IndexOf(Value);
            If (i < 0) or (i = Index) Then Begin
              _Data[Index].NameHash := TXHelper.CalcHash(Value);
              _Data[Index].Name     := Value;
            End Else System.Error(reRangeError);
          End Else System.Error(reRangeError);
        End;

      Function TAssocStringArray.GetValue(Index: Integer): TWideString;
        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then Result := _Data[Index].Value
          Else If _ExceptOnError Then System.Error(reRangeError) Else Result := '';
        End;

      Procedure TAssocStringArray.SetValue(Index: Integer; Const Value: TWideString);
        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then _Data[Index].Value := Value
          Else System.Error(reRangeError);
        End;

      Function TAssocStringArray.GetNamedValue(Const Name: TWideString): TWideString;
        Var i: Integer;

        Begin
          i := IndexOf(Name);
          If i >= 0 Then Result := _Data[i].Value
          Else If _ExceptOnError Then System.Error(reRangeError) Else Result := '';
        End;

      Procedure TAssocStringArray.SetNamedValue(Const Name, Value: TWideString);
        Var i: Integer;

        Begin
          i := IndexOf(Name);
          If i >= 0 Then _Data[i].Value := Value
          Else System.Error(reRangeError);
        End;

      Procedure TAssocStringArray.Clear;
        Begin
          _Data      := nil;
          _DataIndex := 0;
        End;

      Procedure TAssocStringArray.Add(Const Name, Value: TWideString);
        Var i: Integer;

        Begin
          i := IndexOf(Name);
          If i < 0 Then Begin
            i := Length(_Data);
            SetLength(_Data, i + 1);
            _Data[i].NameHash := TXHelper.CalcHash(Name);
            _Data[i].Name     := Name;
          End Else If _ExceptOnError Then System.Error(reRangeError);
          _Data[i].Value := Value;
        End;

      Procedure TAssocStringArray.Insert(Index: Integer; Const Name, Value: TWideString);
        Var i: Integer;

        Begin
          i := IndexOf(Name);
          If i < 0 Then Begin
            i := Length(_Data);
            If Index > i Then System.Error(reRangeError);
            SetLength(_Data, i + 1);
            If Index < i Then Begin
              MoveMemory(@_Data[Index + 1], @_Data[Index], (i - Index) * SizeOf(TAssocStringRec));
              ZeroMemory(@_Data[Index], SizeOf(TAssocStringRec));
            End;
            _Data[Index].NameHash := TXHelper.CalcHash(Name);
            _Data[Index].Name     := Name;
          End Else If _ExceptOnError Then System.Error(reRangeError) Else Index := i;
          _Data[Index].Value := Value;
        End;

      Procedure TAssocStringArray.Move(OldIndex, NewIndex: Integer);
        Var Temp: TAssocStringRec;

        Begin
          If (OldIndex >= 0) and (OldIndex < Length(_Data))
              and (NewIndex >= 0) and (NewIndex < Length(_Data)) Then Begin
            Temp := _Data[OldIndex];
            Delete(OldIndex);
            Insert(NewIndex, Temp.Name, Temp.Value);
          End Else System.Error(reRangeError);
        End;

      Function TAssocStringArray.IndexOf(Const Name: TWideString): Integer;
        Var Hash: LongWord;

        Begin
          Result := High(_Data);
          Hash   := TXHelper.CalcHash(Name);
          While Result >= 0 do Begin
            If TXHelper.CompareHash(_Data[Result].NameHash, Hash)
                and TXHelper.SameTextW(_Data[Result].Name, Name, _CaseSensitive) Then Break;
            Dec(Result);
          End;
        End;

      Procedure TAssocStringArray.Delete(Index: Integer);
        Var i:  Integer;

        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then Begin
            i := System.High(_Data);
            If Index < i Then Begin
              Finalize(_Data[Index]);
              MoveMemory(@_Data[Index], @_Data[Index + 1], (i - Index) * SizeOf(TAssocStringRec));
              ZeroMemory(@_Data[i], SizeOf(TAssocStringRec));
            End;
            SetLength(_Data, i);
          End Else System.Error(reRangeError);
        End;

      Procedure TAssocStringArray.Delete(Const Name: TWideString);
        Begin
          Delete(IndexOf(Name));
        End;

      Procedure TAssocStringArray.Reset;
        Begin
          _DataIndex := 0;
        End;

      Function TAssocStringArray.Prev: Boolean;
        Begin
          Result := _DataIndex > 0;
          If Result Then Dec(_DataIndex);
        End;

      Function TAssocStringArray.Current: TAssocStringRec;
        Begin
          If (_DataIndex < 0) or (_DataIndex >= Length(_Data)) Then Begin
            Result.Name  := '';
            Result.Value := '';
          End Else Result := _Data[_DataIndex];
        End;

      Function TAssocStringArray.Next: Boolean;
        Begin
          Result := _DataIndex < High(_Data);
          If Result Then Inc(_DataIndex);
        End;

      Procedure TAssocStringArray.ToEnd;
        Begin
          _DataIndex := High(_Data);
          If _DataIndex < 0 Then _DataIndex := 0;
        End;

      Procedure TAssocVariantArray.SetCaseSensitive(Value: Boolean);
        Var i: Integer;

        Begin
          For i := High(_Data) downto 0 do
            If not Value and (IndexOf(_Data[i].Name) <> i) Then System.Error(reRangeError);
          _CaseSensitive := Value;
        End;

      Function TAssocVariantArray.GetCount: Integer;
        Begin
          Result := Length(_Data);
        End;

      Function TAssocVariantArray.GetName(Index: Integer): TWideString;
        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then Result := _Data[Index].Name
          Else If _ExceptOnError Then System.Error(reRangeError) Else Result := '';
        End;

      Procedure TAssocVariantArray.SetName(Index: Integer; Const Value: TWideString);
        Var i: Integer;

        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then Begin
            i := IndexOf(Value);
            If (i < 0) or (i = Index) Then Begin
              _Data[Index].NameHash := TXHelper.CalcHash(Value);
              _Data[Index].Name     := Value;
            End Else System.Error(reRangeError);
          End Else System.Error(reRangeError);
        End;

      Function TAssocVariantArray.GetValue(Index: Integer): Variant;
        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then Result := _Data[Index].Value
          Else If _ExceptOnError Then System.Error(reRangeError) Else VarClear(Result);
        End;

      Procedure TAssocVariantArray.SetValue(Index: Integer; Const Value: Variant);
        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then _Data[Index].Value := Value
          Else System.Error(reRangeError);
        End;

      Function TAssocVariantArray.GetNamedValue(Const Name: TWideString): Variant;
        Var i: Integer;

        Begin
          i := IndexOf(Name);
          If i >= 0 Then Result := _Data[i].Value
          Else If _ExceptOnError Then System.Error(reRangeError) Else VarClear(Result);
        End;

      Procedure TAssocVariantArray.SetNamedValue(Const Name: TWideString; Const Value: Variant);
        Var i: Integer;

        Begin
          i := IndexOf(Name);
          If i >= 0 Then _Data[i].Value := Value
          Else System.Error(reRangeError);
        End;

      Function TAssocVariantArray.GetRealIndex(Const IndexOrName: TIndex): Integer;
        Var i: Integer;

        Begin
          If IndexOrName.ValueType = vtIntValue Then Begin
            If (IndexOrName.IntValue < 0) or (IndexOrName.IntValue >= Length(_Data)) Then Begin
              If _ExceptOnError Then System.Error(reRangeError);
              Result := -1;
            End Else Result := _Data[IndexOrName.IntValue].RealIndex;
          End Else Begin
            i := IndexOf(IndexOrName.StringValue);
            If i < 0 Then Begin
              If _ExceptOnError Then System.Error(reRangeError);
              Result := -1;
            End Else Result := _Data[i].RealIndex;
          End;
        End;

      Procedure TAssocVariantArray.SetRealIndex(Const IndexOrName: TIndex; Value: Integer);
        Var i: Integer;

        Begin
          If IndexOrName.ValueType = vtIntValue Then Begin
            If (IndexOrName.IntValue >= 0) and (IndexOrName.IntValue < Length(_Data)) Then
              _Data[IndexOrName.IntValue].Value := Value
            Else System.Error(reRangeError);
          End Else Begin
            i := IndexOf(IndexOrName.StringValue);
            If i >= 0 Then _Data[i].Value := Value
            Else System.Error(reRangeError);
          End;
        End;

      Procedure TAssocVariantArray.Clear;
        Begin
          _Data      := nil;
          _DataIndex := 0;
        End;

      Procedure TAssocVariantArray.Add(Const Name: TWideString; Const Value: Variant; RealIndex: Integer = 0);
        Var i: Integer;

        Begin
          i := IndexOf(Name);
          If i < 0 Then Begin
            i := Length(_Data);
            SetLength(_Data, i + 1);
            _Data[i].NameHash := TXHelper.CalcHash(Name);
            _Data[i].Name     := Name;
          End Else If _ExceptOnError Then System.Error(reRangeError);
          _Data[i].Value     := Value;
          _Data[i].RealIndex := RealIndex;
        End;

      Procedure TAssocVariantArray.Insert(Index: Integer; Const Name: TWideString; Const Value: Variant; RealIndex: Integer = 0);
        Var i: Integer;

        Begin
          i := IndexOf(Name);
          If i < 0 Then Begin
            i := Length(_Data);
            If Index > i Then System.Error(reRangeError);
            SetLength(_Data, i + 1);
            If Index < i Then Begin
              MoveMemory(@_Data[Index + 1], @_Data[Index], (i - Index) * SizeOf(TAssocStringRec));
              ZeroMemory(@_Data[Index], SizeOf(TAssocStringRec));
            End;
            _Data[Index].NameHash := TXHelper.CalcHash(Name);
            _Data[Index].Name     := Name;
          End Else If _ExceptOnError Then System.Error(reRangeError) Else Index := i;
          _Data[Index].Value     := Value;
          _Data[Index].RealIndex := RealIndex;
        End;

      Procedure TAssocVariantArray.Move(OldIndex, NewIndex: Integer);
        Var Temp: TAssocVariantRec;

        Begin
          If (OldIndex >= 0) and (OldIndex < Length(_Data))
              and (NewIndex >= 0) and (NewIndex < Length(_Data)) Then Begin
            Temp := _Data[OldIndex];
            Delete(OldIndex);
            Insert(NewIndex, Temp.Name, Temp.Value, Temp.RealIndex);
          End Else System.Error(reRangeError);
        End;

      Function TAssocVariantArray.IndexOf(Const Name: TWideString): Integer;
        Var Hash: LongWord;

        Begin
          Result := High(_Data);
          Hash   := TXHelper.CalcHash(Name);
          While Result >= 0 do Begin
            If TXHelper.CompareHash(_Data[Result].NameHash, Hash)
                and TXHelper.SameTextW(_Data[Result].Name, Name, _CaseSensitive) Then Break;
            Dec(Result);
          End;
        End;

      Procedure TAssocVariantArray.Delete(Index: Integer);
        Var i:  Integer;

        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then Begin
            i := System.High(_Data);
            If Index < i Then Begin
              Finalize(_Data[Index]);
              MoveMemory(@_Data[Index], @_Data[Index + 1], (i - Index) * SizeOf(TAssocStringRec));
              ZeroMemory(@_Data[i], SizeOf(TAssocStringRec));
            End;
            SetLength(_Data, i);
          End Else System.Error(reRangeError);
        End;

      Procedure TAssocVariantArray.Delete(Const Name: TWideString);
        Begin
          Delete(IndexOf(Name));
        End;

      Procedure TAssocVariantArray.Reset;
        Begin
          _DataIndex := 0;
        End;

      Function TAssocVariantArray.Prev: Boolean;
        Begin
          Result := _DataIndex > 0;
          If Result Then Dec(_DataIndex);
        End;

      Function TAssocVariantArray.Current: TAssocVariantRec;
        Begin
          If (_DataIndex < 0) or (_DataIndex >= Length(_Data)) Then Begin
            Result.Name      := '';
            Result.Value     := '';
            Result.RealIndex := -1;
          End Else Result := _Data[_DataIndex];
        End;

      Function TAssocVariantArray.Next: Boolean;
        Begin
          Result := _DataIndex < High(_Data);
          If Result Then Inc(_DataIndex);
        End;

      Procedure TAssocVariantArray.ToEnd;
        Begin
          _DataIndex := High(_Data);
          If _DataIndex < 0 Then _DataIndex := 0;
        End;

    {$IFEND}

    {$IFNDEF hxExcludeSysutilsUnit}

      Class Function EXMLException.Str(S: AnsiString; MaxLen: Integer = MaxXMLErrStr): String;
        Const Width: Array[Boolean] of Byte = (2, 4);

        Var i: Integer;

        Begin
          If MaxLen < 0 Then Begin
            If Length(S) > -MaxLen Then S := Copy(S, 1, -MaxLen);
          End Else
            If Length(S) >  MaxLen Then S := Copy(S, 1, MaxLen) + '...';
          For i := Length(S) downto 1 do
            If Ord(S[i]) in [0{..9, 11, 12, 14.}..31, 34, 127, 160, 255] Then Begin
              Insert(AnsiString(Format('%.*x', [Width[(i < Length(S))
                and (Ord(S[i + 1]) in [Ord('0')..Ord('9'), Ord('A')..Ord('F'),
                  Ord('a')..Ord('f')])], Ord(S[i])])), S, i + 1);
              S[i] := '#';
            End;
          Result := String(S);
        End;

      Class Function EXMLException.Str(S: TWideString; MaxLen: Integer = MaxXMLErrStr): String;
        Const Width: Array[Boolean] of Byte = (2, 4);

        Var i: Integer;

        Begin
          If MaxLen < 0 Then Begin
            If Length(S) > -MaxLen Then S := Copy(S, 1, -MaxLen);
          End Else
            If Length(S) >  MaxLen Then S := Copy(S, 1, MaxLen) + '...';
          For i := Length(S) downto 1 do
            If ((SizeOf(Char) = 1) and (Ord(S[i]) > 255))
                or (Ord(S[i]) in [0{..9, 11, 12, 14.}..31, 34, 127, 160, 255]) Then Begin
              Insert(TWideString(Format('%.*x', [Width[(i < Length(S))
                and (Ord(S[i + 1]) in [Ord('0')..Ord('9'), Ord('A')..Ord('F'),
                  Ord('a')..Ord('f')])], Ord(S[i])])), S, i + 1);
              S[i] := '#';
            End;
          Result := String(S);
        End;

      Constructor EXMLException.Create(ErrorClass: TClass; Const FunctionsName: String; ResStringRec: PResStringRec;
          Const Args: Array of Const; PrevException: Exception = nil; ErrorCode: LongWord = ERROR_SUCCESS);

        Var i: Integer;

        Begin
          If PrevException is EXMLException Then
            _Info := Copy(EXMLException(PrevException)._Info)
          Else If PrevException is Exception Then Begin
            SetLength(_Info, 1);
            _Info[0].ErrorClass    := ErrorClass;
            _Info[0].FunctionsName := '-';
            _Info[0].Message       := Exception(ErrorClass).Message;
          End;
          If ErrorCode <> ERROR_SUCCESS Then Begin
            i := Length(_Info);
            SetLength(_Info, i + 1);
            _Info[i].ErrorClass    := nil;
            _Info[i].FunctionsName := 'System';
            _Info[i].Message       := SysErrorMessage(ErrorCode);
          End;
          i := Length(_Info);
          SetLength(_Info, i + 1);
          _Info[i].ErrorClass    := ErrorClass;
          _Info[i].FunctionsName := FunctionsName;
          _Info[i].Message       := Format(LoadResString(ResStringRec), Args);
          Message := Format('[%s] ' + '%s.%s:' + sLineBreak + '%s', [ClassName,
            _Info[i].ErrorClass.ClassName, _Info[i].FunctionsName, _Info[i].Message]);
          While (i > 0) and (Length(Message) < 3000) do Begin
            Dec(i);
            Message := Format('%s' + sLineBreak + sLineBreak + '%s.%s:' + sLineBreak + '%s',
              [Message, _Info[i].ErrorClass.ClassName, _Info[i].FunctionsName, _Info[i].Message]);
          End;
          If Length(Message) > 3500 Then Message := Copy(Message, 1, 3497) + '...';
        End;

    {$ELSE}

      Class Function EXMLException.Str(S: AnsiString; MaxLen: Integer = MaxXMLErrStr): String;
        Begin
          Result := String(S);
        End;

      Class Function EXMLException.Str(S: TWideString; MaxLen: Integer = MaxXMLErrStr): String;
        Begin
          Result := String(S);
        End;

      Constructor EXMLException.Create(ErrorClass: TClass; Const FunctionsName: String; ResStringRec: PResStringRec;
          Const Args: Array of Const; PrevException: Exception = nil; ErrorCode: LongWord = ERROR_SUCCESS);

        Begin
          Halt(1);
        End;

    {$ENDIF}

    Constructor EXMLException.Create(ErrorClass: TClass; Const FunctionsName: String;
        ResStringRec: PResStringRec; Const S: TWideString);
      Begin
        Create(ErrorClass, FunctionsName, ResStringRec, [Str(S)]);
      End;

    Constructor EXMLException.Create(ErrorClass: TClass; Const FunctionsName: String;
        ResStringRec: PResStringRec; Const S: AnsiString);
      Begin
        Create(ErrorClass, FunctionsName, ResStringRec, [Str(S)]);
      End;

    Constructor EXMLException.Create(ErrorClass: TClass; Const FunctionsName: String;
        ResStringRec: PResStringRec; i: Integer = 0);
      Begin
        Create(ErrorClass, FunctionsName, ResStringRec, [i]);
      End;

    {$IFNDEF hxExcludeSysutilsUnit}

      {$IF DELPHI >= 2006}

        Function TXMLSerializeQuery.GetVarObj: TObject;
          Begin
            Result := _VarObj^;
          End;

        Procedure TXMLSerializeQuery.SetVarObj(O: TObject);
          Begin
            _VarObj^ := O;
          End;

      {$IFEND}

      Procedure TXMLSerializeRecordInfo.CheckOffsets(Intern: Boolean = False);
        Var i: Integer;

        Begin
          If not Intern Then  While Assigned(_Parent) do Self := _Parent;
          For i := 0 to High(_Data) do
            If _OffsetsOK and Assigned(_Data[i].SubInfo) Then Begin
              _Data[i].SubInfo.CheckOffsets(True);
              _OffsetsOK := _OffsetsOK and _Data[i].SubInfo._OffsetsOK;
            End;
          If not Intern and not _OffsetsOK Then CalcOffsets;
        End;

      Procedure TXMLSerializeRecordInfo.CalcOffsets;
        Const DSize: Array[TXMLSerializeRDataType] of Byte = (
            1, 1, 2, 4, SizeOf(Integer),
            1, 2, 4, 8, 8, 8, SizeOf(Cardinal),
            1, 2, 4, 8, 8, 8, SizeOf(Integer),
            4, 8, 10, SizeOf(Real), 8, 8,
            0, 0, 0, SizeOf(Pointer),
            0, SizeOf(Pointer), SizeOf(Pointer), SizeOf(Pointer), SizeOf(Pointer),
            0, SizeOf(Pointer), SizeOf(Variant), SizeOf(TObject),
            0, 0, SizeOf(Pointer), 0, 0, 0);

        Var Split, i, i2: Integer;

        Begin
          _OffsetsOK   := False;
          _Size        := 0;
          _ElementSize := 1;
          Split        := MaxInt;
          For i := 0 to High(_Data) do Begin
            If Assigned(_Data[i].SubInfo) Then Begin
              _Data[i].SubInfo.CalcOffsets;
              _Data[i].Size        := _Data[i].SubInfo._Size;
              _Data[i].ElementSize := _Data[i].SubInfo._ElementSize;
            End;
            Case TransformSerializeTypes[_Data[i].DType] of
              rtBoolean..rtDateTime, rtUtf8String, rtAnsiString..rtUnicodeString,
              rtPointer..rtObject, rtDynArray: Begin
                i2 := DSize[_Data[i].DType];
                If _Data[i].DType in [rtWord64BE, rtWord64LE, rtInt64BE, rtInt64LE] Then i2 := i2 div 2;
                If i2 > _Align Then i2 := _Align;
                If i2 > Split  Then i2 := Split;
                Inc(_Size, (i2 - _Size mod i2) mod i2);
                _Data[i].Offset      := _Size;
                _Data[i].Size        := DSize[_Data[i].DType];
                _Data[i].ElementSize := i2;
                Inc(_Size, _Data[i].Size);
                Split := MaxInt;
              End;
              rtAnsiCharArray, rtShortString, rtBinary, rtDummy: Begin
                _Data[i].Offset      := _Size;
                _Data[i].Size        := _Data[i].Elements;
                _Data[i].ElementSize := 1;
                If _Data[i].DType = rtShortString Then Inc(_Data[i].Size);
                Inc(_Size, _Data[i].Size);
                Split := MaxInt;
              End;
              rtWideCharArray: Begin
                i2 := 2;
                If i2 > _Align Then i2 := _Align;
                If i2 > Split  Then i2 := Split;
                Inc(_Size, (i2 - _Size mod i2) mod i2);
                _Data[i].Offset      := _Size;
                _Data[i].Size        := _Data[i].Elements * 2;
                _Data[i].ElementSize := i2;
                Inc(_Size, _Data[i].Size);
                Split := MaxInt;
              End;
              rtRecord, rtArray: Begin
                i2 := _Data[i].ElementSize;
                If i2 > _Align Then i2 := _Align;
                If i2 > Split  Then i2 := Split;
                Inc(_Size, (i2 - _Size mod i2) mod i2);
                _Data[i].Offset      := _Size;
                _Data[i].Size        := _Data[i].SubInfo._Size;
                _Data[i].ElementSize := i2;
                If _Data[i].DType = rtRecord Then Inc(_Size, _Data[i].Size)
                Else Inc(_Size, _Data[i].Size * _Data[i].Elements);
                Split := MaxInt;
              End;
              rtAlign: Begin
                i2 := _Data[i].Elements;
                If i2 > _Align Then i2 := _Align;
                If i2 > Split  Then i2 := Split;
                Inc(_Size, (i2 - _Size mod i2) mod i2);
                _Data[i].Offset      := _Size;
                _Data[i].Size        := 0;
                _Data[i].ElementSize := 0;
                Split := MaxInt;
              End;
              rtSplit: Begin
                _Data[i].Offset      := _Size;
                _Data[i].Size        := 0;
                _Data[i].ElementSize := 0;
                Split := _Data[i].Elements;
              End;
            End;
            If _Data[i].ElementSize > _ElementSize Then _ElementSize := _Data[i].ElementSize;
          End;
          If _Size > 0 Then Inc(_Size, (_ElementSize - _Size mod _ElementSize) mod _ElementSize);
          _OffsetsOK := True;
        End;

      Function TXMLSerializeRecordInfo.GetCount: Integer;
        Begin
          Result := Length(_Data);
        End;

      Function TXMLSerializeRecordInfo.GetFullOffset(Index: Integer): Integer;
        Begin
          CheckOffsets;
          If (Index >= 0) and (Index < Length(_Data)) Then Begin
            Result := _Data[Index].Offset;
            If Assigned(_Parent) Then Inc(Result, _Parent.FullOffset[_Parent.IndexOf(Self)]);
          End Else Result := -1;
        End;

      Function TXMLSerializeRecordInfo.GetOffset(Index: Integer): Integer;
        Begin
          CheckOffsets;
          If (Index < 0) or (Index >= Length(_Data)) Then Result := -1
          Else Result := _Data[Index].Offset;
        End;

      Function TXMLSerializeRecordInfo.GetSize(Index: Integer): Integer;
        Begin
          CheckOffsets;
          If (Index < 0) or (Index >= Length(_Data)) Then Result := -1
          Else Result := _Data[Index].Size;
        End;

      Function TXMLSerializeRecordInfo.GetName(Index: Integer): String;
        Var i, i2: Integer;

        Begin
          If (Index >= 0) and (Index < Length(_Data)) Then Begin
            Result := _Data[Index].Name;
            If (Result = '') and not (_Data[Index].DType in [rtAlign, rtSplit]) Then Begin
              i2 := 0;
              For i := 0 to Index - 1 do
                If not (_Data[i].DType in [rtAlign, rtSplit]) Then Inc(i2);
              Result := Format('rec:%d', [i2]);
            End;
          End Else Result := '';
        End;

      Function TXMLSerializeRecordInfo.GetDType(Index: Integer): TXMLSerializeRDataType;
        Begin
          If (Index < 0) or (Index >= Length(_Data)) Then Result := Pred(Low(TXMLSerializeRDataType))
          Else Result := _Data[Index].DType;
        End;

      Function TXMLSerializeRecordInfo.GetElements(Index: Integer): Integer;
        Begin
          If (Index < 0) or (Index >= Length(_Data)) Then Result := -1
          Else Result := _Data[Index].Elements;
        End;

      Function TXMLSerializeRecordInfo.GetSubInfo(Index: Integer): TXMLSerializeRecordInfo;
        Begin
          If (Index < 0) or (Index >= Length(_Data)) Then Result := nil
          Else Result := _Data[Index].SubInfo;
        End;

      Procedure TXMLSerializeRecordInfo.Set_Global(Source: TXMLSerializeRecordInfo);
        Var i: Integer;

        Begin
          _SaveInfos  := Source._SaveInfos;
          _SOptions   := Source._SOptions;
          _SerProc    := Source._SerProc;
          If Assigned(_Parent) and (_Parent <> Source) Then
            _Parent.Set_Global(Self);
          For i := 0 to High(_Data) do
            If Assigned(_Data[i].SubInfo) and (_Data[i].SubInfo <> Source) Then
              _Data[i].SubInfo.Set_Global(Self);
        End;

      Procedure TXMLSerializeRecordInfo.SetSaveInfos(Value: Boolean);
        Begin
          _SaveInfos := Value;
          Set_Global(Self);
        End;

      Procedure TXMLSerializeRecordInfo.SetSOptions(Value: TXMLSerializeOptions);
        Begin
          _SOptions := Value + [xsSaveClassType];
          Set_Global(Self);
        End;

      Procedure TXMLSerializeRecordInfo.SetSerProc(Value: TXMLSerializeProc);
        Begin
          _SerProc := Value;
          Set_Global(Self);
        End;

      Constructor TXMLSerializeRecordInfo.Create;
        Var X: TSearchRec;

        Begin
          Inherited;
          _Align    := Integer(@X.Size) - Integer(@X.Time);
          _SOptions := [xsSaveClassType];
        End;

      Destructor TXMLSerializeRecordInfo.Destroy;
        Begin
          Clear;
          Inherited;
        End;

      Procedure TXMLSerializeRecordInfo.SetAlign(Align: LongInt = 4);
        Begin
          _OffsetsOK := False;
          If Align = 0 Then Align := 1;
          If Align in [1, 2, 4, 8, 16] Then _Align := Align;
        End;

      Function TXMLSerializeRecordInfo.Add(Name: String; DType: TXMLSerializeRDataType; Elements: Integer = 1): TXMLSerializeRecordInfo;
        Var i: Integer;

        Begin
          _OffsetsOK := False;
          i := Length(_Data);
          Name := Trim(Name);
          If (Name <> '') and not TXHelper.CheckString(Name, xtElement_NodeName) and (IndexOf(Name) >= 0) Then
            Raise EXMLException.Create(ClassType, 'Add', @SInvalidValue, Name);
          If (DType > High(TXMLSerializeRDataType))
              or ((DType in [rtAnsiCharArray, rtWideCharArray, rtCharArray, rtShortString, rtBinary,
                rtPointer, rtArray, rtDynArray, rtDummy]) and (Elements < 0))
              or ((DType in [rtAlign, rtSplit]) and not (Elements in [1, 2, 4, 8, 16])) Then
            Raise EXMLException.Create(ClassType, 'Add', @SInvalidValueN);
          SetLength(_Data, i + 1);
          _Data[i].Name  := Name;
          _Data[i].DType := DType;
          If DType in [rtAnsiCharArray, rtWideCharArray, rtCharArray, rtShortString,
              rtBinary, rtPointer, rtArray, rtDynArray, rtDummy, rtAlign, rtSplit] Then
            _Data[i].Elements := Elements Else _Data[i].Elements := 0;
          _Data[i].SubInfo := nil;
          If DType in [rtRecord, rtArray, rtDynArray] Then Begin
            _Data[i].SubInfo := TXMLSerializeRecordInfo.Create;
            _Data[i].SubInfo._Parent     := Self;
            _Data[i].SubInfo._Align      := _Align;
            _Data[i].SubInfo._SOptions   := _SOptions;
            _Data[i].SubInfo._SerProc    := _SerProc;
          End;
          Result := _Data[i].SubInfo;
        End;

      Function TXMLSerializeRecordInfo.IndexOf(Const Name: String): Integer;
        Begin
          Result := High(_Data);
          While (Result >= 0) and not TXHelper.MatchText(Name, _Data[Result].Name, False) do Dec(Result);
        End;

      Function TXMLSerializeRecordInfo.IndexOf(RecordInfo: TXMLSerializeRecordInfo): Integer;
        Begin
          Result := High(_Data);
          While (Result >= 0) and (not Assigned(RecordInfo)
              or (RecordInfo <> _Data[Result].SubInfo)) do Dec(Result);
        End;

      Procedure TXMLSerializeRecordInfo.Assign(RecordInfo: TXMLSerializeRecordInfo);
        Var i: Integer;

        Begin
          Clear;
          SetAlign(RecordInfo.Align);
          For i := 0 to RecordInfo.Count do Begin
            Add(RecordInfo.Name[i], RecordInfo.DType[i], RecordInfo.Elements[i]);
            If Assigned(RecordInfo.SubInfo[i]) Then SubInfo[i].Assign(RecordInfo.SubInfo[i]);
          End;
        End;

      Procedure TXMLSerializeRecordInfo.Parse(Const S: String);
        Var C:           Char;
          S2:            String;
          i, i2, i3, i4: Integer;

        Begin
          i := 1;
          While i <= Length(S) do
            Case S[i] of
              #9, ' ': Inc(i);
              '(', '[', '{': Begin
                Case S[i] of
                  '(': C := ')';
                  '[': C := ']';
                  Else C := '}';
                End;
                i3 := 0;
                i2 := i;
                Repeat
                  If S[i2] = S[i] Then Inc(i3);
                  If S[i2] = C Then Dec(i3);
                  Inc(i2);
                Until (i3 = 0) or (i2 > Length(S));
                If (i3 <> 0) or not Assigned(_Data) or not Assigned(_Data[High(_Data)].SubInfo) Then
                  Raise EXMLException.Create(ClassType, 'Record-Parse', @SInvalidValue, [Copy(S, i, 25)]);
                _Data[High(_Data)].SubInfo.Parse(Copy(S, i + 1, i2 - i - 2));
                i := i2;
              End;
              'L', 'l':
                If (i < Length(S)) and ((S[i + 1] = '1') or (S[i + 1] = '2')
                    or (S[i + 1] = '4') or (S[i + 1] = '8')) Then Begin
                  SetAlign(Ord(S[i + 1]) - Ord('0'));
                  Inc(i, 2);
                End Else Raise EXMLException.Create(ClassType, 'Record-Parse', @SInvalidValue, [Copy(S, i, 25)]);
              Else Begin
                i2 := 0;
                Repeat
                  If (Char(Ord(S[i]) or $20) = SerializeTypes[i2].Key) and ((SerializeTypes[i2].Size = #0) or
                      ((i < Length(S)) and (Char(Ord(S[i + 1]) or $20) = SerializeTypes[i2].Size))) Then Begin
                    Inc(i);
                    If SerializeTypes[i2].Size <> #0 Then Inc(i);
                    If SerializeTypes[i2].Elements Then Begin
                      i3 := 0;
                      While (i3 < $0CCCCCCC) and (i <= Length(S))
                          and (S[i] >= '0') and (S[i] <= '9') do Begin
                        i3 := i3 * 10 + (Ord(S[i]) - Ord('0'));
                        Inc(i);
                      End;
                    End Else i3 := 1;
                    S2 := '';
                    If (i < Length(S)) and (S[i] = '"') Then Begin
                      i4 := i + 1;
                      While (i4 < Length(S)) and (S[i4] <> '"') do Inc(i4);
                      If S[i4] <> '"' Then
                        Raise EXMLException.Create(ClassType, 'Record-Parse', @SInvalidValue, [Copy(S, i, 25)]);
                      S2 := Copy(S, i + 1, i4 - i - 1);
                      i := i4 + 1;
                    End Else If (i < Length(S)) and ((S[i] = '>') or (S[i] = '=')) Then Begin
                      i4 := i + 1;
                      While (i4 <= Length(S)) and (S[i4] <> ' ') and (S[i4] <> #9) do Inc(i4);
                      S2 := Copy(S, i + 1, i4 - i);
                      i := i4;
                    End;
                    Add(S2, SerializeTypes[i2].Typ, i3);
                    Break;
                  End;
                  Inc(i2);
                Until i2 > High(SerializeTypes);
                If i2 > High(SerializeTypes) Then
                  Raise EXMLException.Create(ClassType, 'Record-Parse', @SInvalidValue, [Copy(S, i, 25)]);
              End;
            End;
        End;

      Function TXMLSerializeRecordInfo.GetString(DFormat: TXMLSerializeTextFormat = sfFormat1): String;
        Function Convert(InfoRec: TXMLSerializeRecordInfo; Root: Boolean = False): String;
          Var X:   TSearchRec;
            i, i2: Integer;

          Begin
            Result := '';
            If (not Root and (InfoRec._Align <> InfoRec._Parent._Align))
                or (Root and (InfoRec._Align <> Integer(@X.Size) - Integer(@X.Time))) Then
              Result := Format('%sp%d', [Result, InfoRec._Align]);
            For i := 0 to High(InfoRec._Data) do Begin
              For i2 := 0 to High(SerializeTypes) do
                If InfoRec._Data[i].DType = SerializeTypes[i2].Typ Then Begin
                  Result := Format('%s%s', [Result, SerializeTypes[i2].Key]);
                  If SerializeTypes[i2].Size <> #0 Then
                    Result := Format('%s%s', [Result, SerializeTypes[i2].Size]);
                  If SerializeTypes[i2].Elements Then
                    Result := Format('%s%d', [Result, InfoRec._Data[i].Elements]);
                  If InfoRec._Data[i].Name <> '' Then Begin
                    Case DFormat of
                      sfShort:   ;
                      sfFormat1: Result := Format('%s"%s"',  [Result, InfoRec._Data[i].Name]);
                      sfFormat2: Result := Format('%s"%s" ', [Result, InfoRec._Data[i].Name]);
                      sfFormat3: Result := Format('%s>%s ',  [Result, InfoRec._Data[i].Name]);
                      sfFormat4: Result := Format('%s=%s ',  [Result, InfoRec._Data[i].Name]);
                    End;
                  End Else If DFormat >= sfFormat2 Then Result := Result + ' ';
                  Break;
                End;
              If Assigned(InfoRec._Data[i].SubInfo) Then Begin
                If DFormat >= sfFormat2 Then Result := Result + '( ' Else Result := Result + '(';
                Result := Result + Convert(InfoRec._Data[i].SubInfo);
                If DFormat >= sfFormat2 Then Result := Result + ') ' Else Result := Result + ')';
              End;
            End;
          End;

        Begin
          Result := Trim(Convert(Self, True));
        End;

      Procedure TXMLSerializeRecordInfo.DebugInfo(SL: TStrings);
        Procedure Output(RI: TXMLSerializeRecordInfo; Offset: Integer);
          Var i: Integer;

          Begin
            SL.Add(Format('Align:%d', [RI.Align]));
            For i := 0 to RI.Count - 1 do Begin
              If not (RI.DType[i] in [rtAlign, rtSplit]) Then
                SL.Add(Format('FullOffset:%d   Offset:%d   Size:%d   Name:"%s"   Type:%s',
                  [RI.FullOffset[i] - Offset, RI.Offset[i], RI.Size[i], RI.Name[i],
                  GetEnumName(TypeInfo(TXMLSerializeRDataType), Ord(RI.DType[i]))]));
              If RI.DType[i] in [rtRecord, rtArray, rtDynArray] Then
                Output(RI.SubInfo[i], Offset);
            End;
          End;

        Begin
          If not Assigned(_Parent) Then Output(Self, 0)
          Else Output(Self, _Parent.Offset[_Parent.IndexOf(Self)]);
        End;

      Procedure TXMLSerializeRecordInfo.Clear;
        Var i: Integer;

        Begin
          _OffsetsOK := False;
          For i := High(_Data) downto 0 do _Data[i].SubInfo.Free;
          _Data := nil;
        End;

    {$ENDIF}
    {$IF DELPHI >= 2006}

      Procedure TChangeArray.Initialize(Var S: TWideString);
        {inline}

        Begin
          _S   := @S;
          _P   := PWideChar(S);
          _Len := 0;
          _Pos := 1;
        End;

      Procedure TChangeArray.Add(Len: Word; Const S: TWideString);
        Begin
          If _Len >= High(_Data) Then Finalize;
          _Data[_Len].Pos := _Pos - 1;
          _Data[_Len].Len := Len;
          _Data[_Len].S   := S;
          System.Inc(_Len);
          If Len > 0 Then Begin
            System.Inc(_Pos, Len - 1);
            System.Inc(_P,   Len - 1);
          End;
        End;

      Procedure TChangeArray.Inc;
        {inline}

        Begin
          System.Inc(_Pos);
          System.Inc(_P);
        End;

      Procedure TChangeArray.Finalize;
        Var S:       TWideString;
          i, i2, i3: Integer;
          P, P2:     PWideChar;

        Begin
          If _Len = 0 Then Exit;
          _Data[-1].Pos := 0;  _Data[_Len].Pos := Length(_S^);
          _Data[-1].Len := 0;  _Data[_Len].Len := 0;
                               _Data[_Len].S   := '';
          i2 := 0;
          For i := 0 to _Len - 1 do
            System.Inc(i2, Length(_Data[i].S) - _Data[i].Len);
          System.Inc(_Pos, i2);
          SetLength(S, Length(_S^) + i2);
          P  := PWideChar(_S^);
          P2 := PWideChar(S);
          For i := 0 to _Len do Begin
            i3 := _Data[i - 1].Pos + _Data[i - 1].Len;
            CopyMemory(P2, P + i3, (_Data[i].Pos - i3) * 2);
            System.Inc(P2, _Data[i].Pos - i3);
            CopyMemory(P2, PWideChar(_Data[i].S), Length(_Data[i].S) * 2);
            System.Inc(P2, Length(_Data[i].S));
            _Data[i].S := '';
          End;
          System.Inc(i2, _P - PWideChar(_S^));
          _S^  := S;
          UniqueString(_S^);
          _P   := PWideChar(_S^) + i2;
          _Len := 0;
        End;

    {$ELSE}

      Procedure TChangeArray_Finalize(Var C: TChangeArray); Forward;

      Procedure TChangeArray_Initialize(Var C: TChangeArray; Var _S: TWideString);
        Begin
          C.S   := @_S;
          C.P   := PWideChar(_S);
          C.Len := 0;
          C.Pos := 1;
        End;

      Procedure TChangeArray_Add(Var C: TChangeArray; _Len: Word; Const _S: TWideString);
        Begin
          If C.Len >= High(C.Data) Then TChangeArray_Finalize(C);
          C.Data[C.Len].Pos := C.Pos - 1;
          C.Data[C.Len].Len := _Len;
          C.Data[C.Len].S   := _S;
          System.Inc(C.Len);
          If _Len > 0 Then Begin
            System.Inc(C.Pos, _Len - 1);
            System.Inc(C.P,   _Len - 1);
          End;
        End;

      Procedure TChangeArray_Inc(Var C: TChangeArray);
        Begin
          System.Inc(C.Pos);
          System.Inc(C.P);
        End;

      Procedure TChangeArray_Finalize(Var C: TChangeArray);
        Var S:       TWideString;
          i, i2, i3: Integer;
          P, P2:     PWideChar;

        Begin
          If C.Len = 0 Then Exit;
          C.Data[-1].Pos := 0;  C.Data[C.Len].Pos := Length(C.S^);
          C.Data[-1].Len := 0;  C.Data[C.Len].Len := 0;
                                C.Data[C.Len].S   := '';
          i2 := 0;
          For i := 0 to C.Len - 1 do
            System.Inc(i2, Length(C.Data[i].S) - C.Data[i].Len);
          System.Inc(C.Pos, i2);
          SetLength(S, Length(C.S^) + i2);
          P  := PWideChar(C.S^);
          P2 := PWideChar(S);
          For i := 0 to C.Len do Begin
            i3 := C.Data[i - 1].Pos + C.Data[i - 1].Len;
            CopyMemory(P2, P + i3, (C.Data[i].Pos - i3) * 2);
            System.Inc(P2, C.Data[i].Pos - i3);
            CopyMemory(P2, PWideChar(C.Data[i].S), Length(C.Data[i].S) * 2);
            System.Inc(P2, Length(C.Data[i].S));
          End;
          System.Inc(i2, C.P - PWideChar(C.S^));
          C.S^  := S;
          UniqueString(C.S^);
          C.P   := PWideChar(C.S^) + i2;
          C.Len := 0;
        End;

    {$IFEND}
    {$IFDEF hxExcludeClassesUnit}

      Function TStream.GetPosition: Int64;
        Begin
          Result := Seek(0, soCurrent);
        End;

      Procedure TStream.SetPosition(const Pos: Int64);
        Begin
          Seek(Pos, soBeginning);
        End;

      Procedure TStream.ReadBuffer(Var Buffer; Count: LongInt);
        Begin
          If (Count <> 0) and (Read(Buffer, Count) <> Count) Then
            Raise EXMLException.Create(ClassType, 'ReadBuffer', @SSReadError);
        End;

      Procedure TStream.WriteBuffer(Const Buffer; Count: LongInt);
        Begin
          If (Count <> 0) and (Write(Buffer, Count) <> Count) Then
            Raise EXMLException.Create(ClassType, 'WriteBuffer', @SSWriteError);
        End;

      Procedure THandleStream.SetSize(Const NewSize: Int64);
        Begin
          Seek(NewSize, soBeginning);
          If not SetEndOfFile(FHandle) Then
            {$IFNDEF hxExcludeSysutilsUnit}RaiseLastOSError{$ELSE}Halt(1){$ENDIF};
        End;

      Constructor THandleStream.Create(AHandle: Integer);
        Begin
          Inherited Create;
          FHandle := AHandle;
        End;

      Function THandleStream.Read(Var Buffer; Count: LongInt): LongInt;
        Begin
          If not ReadFile(THandle(FHandle), Buffer, Count, LongWord(Result), nil) Then
            Result := 0;
        End;

      Function THandleStream.Write(Const Buffer; Count: LongInt): LongInt;
        Begin
          If not WriteFile(THandle(FHandle), Buffer, Count, LongWord(Result), nil) Then
            Result := 0;
        End;

      Function THandleStream.Seek(Const Offset: Int64; Origin: TStreamSeekOrigin): Int64;
        Var ResultR: Int64Rec absolute Result;

        Begin
          Result := Offset;
          ResultR.Lo := SetFilePointer(THandle(FHandle), ResultR.Lo, @ResultR.Hi, Ord(Origin));
          If (ResultR.Lo = $FFFFFFFF) and (GetLastError <> 0) Then ResultR.Hi := $FFFFFFFF;
        End;

    {$ENDIF}

    Constructor TWideFileStream.Create(Const FileName: TWideString; Mode: Word);
      Const AccessMode: Array[0..2] of LongWord = (GENERIC_READ, GENERIC_WRITE, GENERIC_READ or GENERIC_WRITE);
        ShareMode: Array[0..7] of LongWord = (0, 0, FILE_SHARE_READ, FILE_SHARE_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, 0, 0, 0);

      Begin
        If Mode = fmCreate Then Begin
          Inherited Create(CreateFileW(PWideChar(FileName), GENERIC_READ or GENERIC_WRITE,
              0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
          If THandle(FHandle) = INVALID_HANDLE_VALUE Then
            {$IFNDEF hxExcludeSysutilsUnit}
              {$IFNDEF hxExcludeClassesUnit}
                Raise EFCreateError.CreateResFmt(@SFCreateErrorEx, [ExpandFileName(FileName), SysErrorMessage(GetLastError)]);
              {$ELSE}
                Raise EXMLException.Create(ClassType, 'Create', @SSCreateError,
                  [EXMLException.Str(ExpandFileName(FileName), MAX_PATH)], GetLastError);
              {$ENDIF}
            {$ELSE}
              Halt(1);
            {$ENDIF}
        End Else Begin
          Inherited Create(CreateFileW(PWideChar(FileName), AccessMode[Mode and 3],
              ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0));
          If THandle(FHandle) = INVALID_HANDLE_VALUE Then
            {$IFNDEF hxExcludeSysutilsUnit}
              {$IFNDEF hxExcludeClassesUnit}
                Raise EFOpenError.CreateResFmt(@SFOpenErrorEx, [ExpandFileName(FileName), SysErrorMessage(GetLastError)]);
              {$ELSE}
                Raise EXMLException.Create(ClassType, 'Create', @SSOpenError,
                  [EXMLException.Str(ExpandFileName(FileName), MAX_PATH)], GetLastError);
              {$ENDIF}
            {$ELSE}
              Halt(1);
            {$ENDIF}
        End;
      End;

    Destructor TWideFileStream.Destroy;
      Begin
        If THandle(FHandle) <> INVALID_HANDLE_VALUE Then CloseHandle(THandle(FHandle));
        Inherited;
      End;

    Function TWideFileStream.GetSize: Int64;
      Var ResultR: Int64Rec absolute Result;

      Begin
        ResultR.Lo := GetFileSize(THandle(FHandle), @ResultR.Hi);
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TXMLFile'}{$IFEND}

    Class Function TXMLFile.GetLibVersion: AnsiString;
      Begin
        Result := TXMLFile_LibVersion;
      End;

    {$IF DELPHI < 2006}

      Class Function TXMLFile.GetDefaultOptions: TXMLOptions;
        Begin
          Result := TXMLFile__DefaultOptions;
        End;

      Class Function TXMLFile.GetDefaultTextIndent: TWideString;
        Begin
          Result := TXMLFile__DefaultTextIndent;
        End;

      Class Function TXMLFile.GetDefaultLineFeed: TWideString;
        Begin
          Result := TXMLFile__DefaultLineFeed;
        End;

      Class Function TXMLFile.GetDefaultValueSeperator: TWideString;
        Begin
          Result := TXMLFile__DefaultValueSeperator;
        End;

      Class Function TXMLFile.GetDefaultValueQuotation: TWideString;
        Begin
          Result := TXMLFile__DefaultValueQuotation;
        End;

      Class Function TXMLFile.GetPathDelimiter: TWideString;
        Begin
          Result := TXMLFile__PathDelimiter;
        End;

    {$IFEND}

    Class Procedure TXMLFile.SetDefaultOptions(Value: TXMLOptions);
      Begin
        If Value - ([Low(TXMLOption)..High(TXMLOption)] - [xo_IgnoreEncoding, xo_useDefault]) <> [] Then
          Raise EXMLException.Create({Self}TXMLFile, 'DefaultOptions', @SInvalidValueX4, LongInt(Value));
        {$IF DELPHI < 2006}TXMLFile__DefaultOptions{$ELSE}__DefaultOptions{$IFEND} := Value;
      End;

    Class Procedure TXMLFile.SetDefaultTextIndent(Const Value: TWideString);
      Var i: Integer;

      Begin
        For i := Length(Value) - 1 downto 0 do
          If (Value[i + 1] <> ' ') and (Value[i + 1] <> #$09) Then
            Raise EXMLException.Create({Self}TXMLFile, 'DefaultTextIndent', @SInvalidValue, Value);
        {$IF DELPHI < 2006}TXMLFile__DefaultTextIndent{$ELSE}__DefaultTextIndent{$IFEND} := Value;
      End;

    Class Procedure TXMLFile.SetDefaultLineFeed(Const Value: TWideString);
      Begin
        If ((Length(Value) <> 1) or ((Value[1] <> #$0D) and (Value[1] <> #$0A)))
            and ((Length(Value) <> 2) or (Value[1] <> #$0D) or (Value[2] <> #$0A)) Then
          Raise EXMLException.Create({Self}TXMLFile, 'DefaultLineFeed', @SInvalidValue, Value);
        {$IF DELPHI < 2006}TXMLFile__DefaultLineFeed{$ELSE}__DefaultLineFeed{$IFEND} := Value;
      End;

    Class Procedure TXMLFile.SetDefaultValueSeperator(Const Value: TWideString);
      Var B: Boolean;
        i:   Integer;

      Begin
        B := True;
        For i := Length(Value) - 1 downto 0 do
          If Value[i + 1] = '=' Then Begin
            If not B Then Begin
              B := True;
              Break;
            End Else B := False;
          End Else If Value[i + 1] <> ' ' Then Begin
            B := True;
            Break;
          End;
        If B Then Raise EXMLException.Create({Self}TXMLFile, 'DefaultValueSeperator', @SInvalidValue, Value);
        {$IF DELPHI < 2006}TXMLFile__DefaultValueSeperator{$ELSE}__DefaultValueSeperator{$IFEND} := Value;
      End;

    Class Procedure TXMLFile.SetDefaultValueQuotation(Const Value: TWideString);
      Begin
        If (Value <> '"') and (Value <> '''') and (Value <> '') Then
          Raise EXMLException.Create({Self}TXMLFile, 'DefaultValueQuotation', @SInvalidValue, Value);
        {$IF DELPHI < 2006}TXMLFile__DefaultValueQuotation{$ELSE}__DefaultValueQuotation{$IFEND} := Value;
      End;

    Class Procedure TXMLFile.SetPathDelimiter(Const Value: TWideString);
      Begin
        If (Value <> '\') and (Value <> '/') Then
          Raise EXMLException.Create({Self}TXMLFile, 'PathDelimiter', @SInvalidValue, Value);
        {$IF DELPHI < 2006}TXMLFile__PathDelimiter{$ELSE}__PathDelimiter{$IFEND} := Value;
      End;

    Function TXMLFile.GetXmlStyleNode: TXMLNode;
      Begin
        Result := _Nodes.FirstNodeNF;
        While Assigned(Result) and ((Result.NodeType <> xtInstruction)
            or not TXHelper.MatchText('xml|XML', Result.Name, Self)) do
          Result := Result.NextNodeNF;
      End;

    Procedure TXMLFile.SetOwner(Value: TObject);
      Begin
        _Owner := Value;
      End;

    Procedure TXMLFile.SetOptions(Value: TXMLOptions);
      Begin
        If Value <> [xo_useDefault] Then Begin
          If Value - ([Low(TXMLOption)..High(TXMLOption)] - [xo_IgnoreEncoding, xo_useDefault]) <> [] Then
            Raise EXMLException.Create(ClassType, 'Options', @SInvalidValueX4, LongInt(Value));
          _Options := Value;
        End Else _Options := {$IF DELPHI < 2006}TXMLFile__DefaultOptions{$ELSE}__DefaultOptions{$IFEND};
      End;

    Procedure TXMLFile.SetTextIndent(Const Value: TWideString);
      Var i: Integer;

      Begin
        If not TXHelper.SameTextW(XMLUseDefault, Value, Self) Then Begin
          For i := Length(Value) - 1 downto 0 do
            If (Value[i + 1] <> ' ') and (Value[i + 1] <> #$09) Then
              Raise EXMLException.Create(ClassType, 'TextIndent', @SInvalidValue, Value);
          _TextIndent := Value;
        End Else _TextIndent := {$IF DELPHI < 2006}TXMLFile__DefaultTextIndent{$ELSE}__DefaultTextIndent{$IFEND};
      End;

    Procedure TXMLFile.SetLineFeed(Const Value: TWideString);
      Begin
        If not TXHelper.SameTextW(XMLUseDefault, Value, Self) Then Begin
          If ((Length(Value) <> 1) or ((Value[1] <> #$0D) and (Value[1] <> #$0A)))
              and ((Length(Value) <> 2) or (Value[1] <> #$0D) or (Value[2] <> #$0A)) Then
            Raise EXMLException.Create(ClassType, 'LineFeed', @SInvalidValue, Value);
          _LineFeed := Value;
        End Else _LineFeed := {$IF DELPHI < 2006}TXMLFile__DefaultLineFeed{$ELSE}__DefaultLineFeed{$IFEND};
      End;

    Procedure TXMLFile.SetValueSeperator(Const Value: TWideString);
      Var B: Boolean;
        i:   Integer;

      Begin
        If not TXHelper.SameTextW(XMLUseDefault, Value, Self) Then Begin
          B := True;
          For i := Length(Value) - 1 downto 0 do
            If Value[i + 1] = '=' Then Begin
              If not B Then Begin
                B := True;
                Break;
              End Else B := False;
            End Else If Value[i + 1] <> ' ' Then Begin
              B := True;
              Break;
            End;
          If B Then Raise EXMLException.Create(ClassType, 'ValueSeperator', @SInvalidValue, Value);
          _ValueSeperator := Value;
        End Else _ValueSeperator := {$IF DELPHI < 2006}TXMLFile__DefaultValueSeperator{$ELSE}__DefaultValueSeperator{$IFEND};
      End;

    Procedure TXMLFile.SetValueQuotation(Const Value: TWideString);
      Begin
        If not TXHelper.SameTextW(XMLUseDefault, Value, Self) Then Begin
          If (Value <> '"') and (Value <> '''') and (Value <> '') Then
            Raise EXMLException.Create(ClassType, 'ValueQuotation', @SInvalidValue, Value);
          _ValueQuotation := Value;
        End Else _ValueQuotation := {$IF DELPHI < 2006}TXMLFile__DefaultValueQuotation{$ELSE}__DefaultValueQuotation{$IFEND};
      End;

    Function TXMLFile.GetParsedSingleTags: TWideString;
      Var i: Integer;

      Begin
        Result := '';
        For i := 0 to High(_ParsedSingleTags) do
          Result := Result + '|' + _ParsedSingleTags[0].Name;
        Delete(Result, 1, 1);
      End;

    Procedure TXMLFile.SetParsedSingleTags(Value: TWideString);
      Var i: Integer;
        S:   TWideString;

      Begin
        _ParsedSingleTags := nil;
        While Value <> '' do Begin
          i := TXHelper.Pos('|', Value);
          If i = 0 Then i := Length(Value) + 1;
          S := Copy(Value, 1, i - 1);
          Delete(Value, 1, i);
          If not TXHelper.CheckString(S, xtElement_NodeName) Then
            Raise EXMLException.Create(ClassType, 'ParsedSingleTags', @SInvalidValue, Value);
          i := Length(_ParsedSingleTags);
          SetLength(_ParsedSingleTags, i + 1);
          _ParsedSingleTags[i].NameHash := TXHelper.CalcHash(S);
          _ParsedSingleTags[i].Name     := S;
        End;
      End;

    Procedure TXMLFile.SetFileName(Const Value: TWideString);
      Begin
        _FileName := Value;
      End;

    {$IFNDEF hxExcludeClassesUnit}

      Function TXMLFile.GetAsXML: AnsiString;
        Begin
          SaveToXML(Result, xeUTF8, False);
        End;

      Procedure TXMLFile.SetAsXML(Const Value: AnsiString);
        Begin
          LoadFromXML(Value, xeUTF8, False);
        End;

    {$ENDIF}

    Function TXMLFile.GetVersion: TWideString;
      Var Node: TXMLNode;

      Begin
        Node := GetXmlStyleNode;
        If not Assigned(Node) Then Result := ''
        Else Result := Node.Attributes['version'];
      End;

    Procedure TXMLFile.SetVersion(Const Value: TWideString);
      Var Node: TXMLNode;

      Begin
        If Value <> '' Then Begin
          If not TXHelper.CheckString(Value, xtInstruction_VersionValue) Then
            Raise EXMLException.Create(ClassType, 'Version', @SInvalidValue, Value);
          Node := GetXmlStyleNode;
          If not Assigned(Node) Then Begin
            Node := TXMLNode.Create(nil, xtInstruction, 'xml');
            Try
              Node.Attributes.Add('version',    Value);
              Node.Attributes.Add('encoding',   'UTF-8');
              Node.Attributes.Add('standalone', 'yes');
              _Nodes.InsertNF(Node, 0);
            Except
              Node.Free;
              Raise;
            End;
          End Else Begin
            If Node.Attributes.Exists('version') and (Node.Attributes['version'] = Value) Then Exit;
            Node.Attributes['version'] := Value;
          End;
        End Else Begin
          Node := GetXmlStyleNode;
          If Assigned(Node) Then
            If Node.Attributes.Exists('version') Then Node.Attributes.Delete('version');
        End;
      End;

    Function TXMLFile.GetEncoding: TWideString;
      Var Node: TXMLNode;

      Begin
        Node := GetXmlStyleNode;
        If not Assigned(Node) Then Result := ''
        Else Result := Node.Attributes['encoding'];
      End;

    Procedure TXMLFile.SetEncoding(Const Value: TWideString);
      Var Node: TXMLNode;

      Begin
        If Value <> '' Then Begin
          If not TXHelper.CheckString(Value, xtInstruction_EncodingValue) Then
            Raise EXMLException.Create(ClassType, 'Encoding', @SInvalidValue, Value);
          Node := GetXmlStyleNode;
          If not Assigned(Node) Then Begin
            Node := TXMLNode.Create(nil, xtInstruction, 'xml');
            Try
              Node.Attributes.Add('version',    '1.0');
              Node.Attributes.Add('encoding',   Value);
              Node.Attributes.Add('standalone', 'yes');
              _Nodes.InsertNF(Node, 0);
            Except
              Node.Free;
              Raise;
            End;
          End Else Begin
            If Node.Attributes.Exists('encoding') and (Node.Attributes['encoding'] = Value) Then Exit;
            Node.Attributes['encoding'] := Value;
          End;
        End Else Begin
          Node := GetXmlStyleNode;
          If Assigned(Node) Then
            If Node.Attributes.Exists('encoding') Then Node.Attributes.Delete('encoding');
        End;
      End;

    Function TXMLFile.GetStandalone: TWideString;
      Var Node: TXMLNode;

      Begin
        Node := GetXmlStyleNode;
        If not Assigned(Node) Then Result := ''
        Else Result := Node.Attributes['standalone'];
      End;

    Procedure TXMLFile.SetStandalone(Const Value: TWideString);
      Var Node: TXMLNode;

      Begin
        If Value <> '' Then Begin
          If not TXHelper.CheckString(Value, xtInstruction_StandaloneValue) Then
            Raise EXMLException.Create(ClassType, 'Standalone', @SInvalidValue, Value);
          Node := GetXmlStyleNode;
          If not Assigned(Node) Then Begin
            Node := TXMLNode.Create(nil, xtInstruction, 'xml');
            Try
              Node.Attributes.Add('version',    '1.0');
              Node.Attributes.Add('encoding',   'UTF-8');
              Node.Attributes.Add('standalone', Value);
              _Nodes.InsertNF(Node, 0);
            Except
              Node.Free;
              Raise;
            End;
          End Else Begin
            If Node.Attributes.Exists('standalone') and (Node.Attributes['standalone'] = Value) Then Exit;
            Node.Attributes['standalone'] := Value;
          End;
        End Else Begin
          Node := GetXmlStyleNode;
          If Assigned(Node) Then
            If Node.Attributes.Exists('standalone') Then Node.Attributes.Delete('standalone');
        End;
      End;

    Function TXMLFile.GetNodeCount: Integer;
      Begin
        Result := _Nodes.NodeCount;
      End;

    Function TXMLFile.GetNFNodeCount: Integer;
      Begin
        Result := _Nodes.NodeCountNF;
      End;

    Procedure TXMLFile.AssignNodes(Nodes: TXMLNodeList);
      Begin
        _Nodes.Assign(Nodes);
      End;

    Function TXMLFile.GetRootNode: TXMLNode;
      Var Node: TXMLNode;

      Begin
        Node := _Nodes.FirstNodeNF;
        While Assigned(Node) and (Node.NodeType <> xtElement) do
          Node := Node.NextNodeNF;
        Result := Node;
      End;

    Function TXMLFile.GetAttribute(Const Name: TWideString): Variant;
      Begin
        Result := RootNode.Attributes.Value[Name];
      End;

    Procedure TXMLFile.SetAttribute(Const Name: TWideString; Const Value: Variant);
      Begin
        RootNode.Attributes.Value[Name] := Value;
      End;

    Function TXMLFile.GetNode(Const Name: TWideString): TXMLNode;
      Begin
        Result := RootNode.Nodes.Node[Name];
      End;

    Function TXMLFile.GetNFNode(Const Name: TWideString): TXMLNode;
      Begin
        Result := RootNode.Nodes.NodeNF[Name];
      End;

    Function TXMLFile.GetNodeArray(Const Name: TWideString): TXMLNodeArray;
      Begin
        Result := RootNode.Nodes.NodeList[Name];
      End;

    Function TXMLFile.GetNFNodeArray(Const Name: TWideString): TXMLNodeArray;
      Begin
        Result := RootNode.Nodes.NodeListNF[Name];
      End;

    Function TXMLFile.GetFindNode(Const Name: TWideString): TXMLNode;
      Begin
        Result := RootNode.Nodes.FindNode[Name];
      End;

    Function TXMLFile.GetNFFindNode(Const Name: TWideString): TXMLNode;
      Begin
        Result := RootNode.Nodes.FindNodeNF[Name];
      End;

    Function TXMLFile.GetFindNodeArray(Const Name: TWideString): TXMLNodeArray;
      Begin
        Result := RootNode.Nodes.FindNodes[Name];
      End;

    Function TXMLFile.GetNFFindNodeArray(Const Name: TWideString): TXMLNodeArray;
      Begin
        Result := RootNode.Nodes.FindNodesNF[Name];
      End;

    Function TXMLFile.GetCryptProc(Const CName: TWideString): TXMLEncryptionProc;
      Var i: Integer;

      Begin
        For i := 0 to High(_Cryptors) do
          If TXHelper.SameTextW(_Cryptors[i].Name, CName, False) Then Begin
            Result := _Cryptors[i].Proc;
            Exit;
          End;
        Result := nil;
      End;

    Procedure TXMLFile.SetCryptProc(Const CName: TWideString; Value: TXMLEncryptionProc);
      Var i: Integer;

      Begin
        If Assigned(Value) Then Begin
          If not TXHelper.CheckString(CName, xtElement_NodeName) Then
            Raise EXMLException.Create(ClassType, 'CryptProc', @SInvalidName, CName);
          For i := 0 to High(_Cryptors) do
            If TXHelper.SameTextW(_Cryptors[i].Name, CName, False) Then Begin
              _Cryptors[i].Proc := Value;
              Exit;
            End;
          i := Length(_Cryptors);
          SetLength(_Cryptors, i + 1);
          _Cryptors[i].Name := CName;
          _Cryptors[i].Proc := Value;
          _Cryptors[i].Data := '';
        End Else
          For i := 0 to High(_Cryptors) do
            If TXHelper.SameTextW(_Cryptors[i].Name, CName, False) Then Begin
              If i < High(_Cryptors) Then Begin
                _Cryptors[i].Name := '';
                _Cryptors[i].Data := '';
                MoveMemory(@_Cryptors[i], @_Cryptors[i + 1], (High(_Cryptors) - i) * SizeOf(TXMLCryptor));
                ZeroMemory(@_Cryptors[High(_Cryptors)], SizeOf(TXMLCryptor));
              End;
              SetLength(_Cryptors, High(_Cryptors));
              Exit;
            End;
      End;

    Function TXMLFile.GetCryptData(Const CName: TWideString): AnsiString;
      Var i: Integer;

      Begin
        For i := 0 to High(_Cryptors) do
          If TXHelper.SameTextW(_Cryptors[i].Name, CName, False)
              or ((i = 0) and (CName = '*')) Then Begin
            Result := _Cryptors[i].Data;
            Exit;
          End;
        Result := '';
      End;

    Procedure TXMLFile.SetCryptData(Const CName: TWideString; Const Value: AnsiString);
      Var i: Integer;

      Begin
        For i := 0 to High(_Cryptors) do
          If TXHelper.SameTextW(_Cryptors[i].Name, CName, False)
              or ((i = 0) and (CName = '*')) Then Begin
            _Cryptors[i].Data := Value;
            Exit;
          End;
        Raise EXMLException.Create(ClassType, 'CryptData', @SInvalidName, CName);
      End;

    Procedure TXMLFile.SetCryptName(Const CName: TWideString);
      Var N: TXMLNode;

      Begin
        If not TXHelper.CheckString(CName, xtElement_NodeName) Then
          Raise EXMLException.Create(ClassType, 'CryptName', @SInvalidName, CName);
        _CryptAttrName := CName;
        N := _Nodes.FirstNodeNF;
        While Assigned(N) do Begin
          N.CheckCrypted(True);
          N := N.NextNodeNF;
        End;
      End;

    Constructor TXMLFile.Create(Owner: TObject = nil; CreateRootNodes: Boolean = True);
      Begin
        If CreateRootNodes Then Create(Owner, 'xml') Else Create(Owner, '')
      End;

    Constructor TXMLFile.Create(Owner: TObject; Const NameOfRootNode: TWideString);
      Begin
        Inherited Create;
        InitializeCriticalSection(_ThreadLock);
        Try
          _Owner            := Owner;
          _Options          := {$IF DELPHI < 2006}TXMLFile__DefaultOptions       {$ELSE}__DefaultOptions{$IFEND};
          _TextIndent       := {$IF DELPHI < 2006}TXMLFile__DefaultTextIndent    {$ELSE}__DefaultTextIndent{$IFEND};
          _LineFeed         := {$IF DELPHI < 2006}TXMLFile__DefaultLineFeed      {$ELSE}__DefaultLineFeed{$IFEND};
          _ValueSeperator   := {$IF DELPHI < 2006}TXMLFile__DefaultValueSeperator{$ELSE}__DefaultValueSeperator{$IFEND};
          _ValueQuotation   := {$IF DELPHI < 2006}TXMLFile__DefaultValueQuotation{$ELSE}__DefaultValueQuotation{$IFEND};
        //_ParsedSingleTags := '';
        //_FileName         := '';
          _Nodes            := TXMLNodeList.Create(Self);
          ClearDocument(NameOfRootNode);
          _Changed          := False;
          _Cryptors         := nil;
          _CryptAttrName    := cHimXmlNamespace + ':crypt';
          SetCryptor('RC4', RC4Crypt, '');
        //_OnNodeChange     := nil;
        //_OnStatus         := nil;
        //_OnException      := nil;
          _UpdateIntervall  := 100;
          _StatusScale      := 1;
        Except
          DeleteCriticalSection(_ThreadLock);
          _Nodes.Free;
          Raise;
        End;
      End;

    Constructor TXMLFile.Create(Owner: TObject; Const FileName: TWideString; SaveOnClose: Boolean);
      Begin
        Create(Owner, True);
        Try
          LoadFromFile(FileName);
          If SaveOnClose Then Include(_Options, xoAutoSaveOnClose);
        Except
          DeleteCriticalSection(_ThreadLock);
          _Nodes.Free;
          Raise;
        End;
      End;

    Destructor TXMLFile.Destroy;
      Begin
        Try
          DoStatus(xsBeforeDestroy);
          If _Changed and (xoAutoSaveOnClose in _Options) and (_FileName <> '') Then
            SaveToFile(_FileName);
        Finally
          _Nodes.Free;
          DeleteCriticalSection(_ThreadLock);
        End;
        Inherited;
      End;

    Procedure TXMLFile.LoadFromFile(FileName: TWideString = '[default]');
      Var Stream: TStream;

      Begin
        If FileName = '[default]' Then FileName := _FileName;
        If FileName = '' Then Raise EXMLException.Create(ClassType, 'LoadFromFile',
          @SInvalidName, [EXMLException.Str(FileName, MAX_PATH)]);
        Stream := TWideFileStream.Create(FileName, fmOpenRead);
        Try
          LoadFromStream(Stream);
          _FileName := FileName;
        Finally
          Stream.Free;
        End;
      End;

    Procedure TXMLFile.SaveToFile(FileName: TWideString = '[default]');
      Var Stream: TStream;

      Begin
        If FileName = '[default]' Then FileName := _FileName;
        If FileName = '' Then Raise EXMLException.Create(ClassType, 'LoadFromFile',
          @SInvalidName, [EXMLException.Str(FileName, MAX_PATH)]);
        Stream := TWideFileStream.Create(FileName, fmCreate);
        Try
          SaveToStream(Stream);
          Stream.Size := Stream.Position;
          _FileName   := FileName;
        Finally
          Stream.Free;
        End;
      End;

    Procedure TXMLFile.LoadFromStream(Stream: TStream;
        StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = False);

      Var O:    TXMLOptions;
        Reader: TXReader;
        Timer:  LongWord;

      Begin
        Try
          _Nodes.Clear;
          O := _Options;
          If IgnoreEncodingAttributes Then Include(O, xo_IgnoreEncoding);
          DoStatus(xsLoad, 0);
          Timer  := GetTickCount + Cardinal(_UpdateIntervall);
          Reader := TXReader.Create(Stream, O, StartEncoding);
          Try
            TXMLFile.ParsingTree(Self, Reader, _Nodes, @Timer);
            DoStatus(xsLoadEnd, (Reader.Position + (_StatusScale div 2)) div _StatusScale);
          Finally
            Reader.Free;
          End;
        Except
          Raise EXMLException.Create(ClassType, 'LoadFromStream', @SInvalidValueN, [], Exception(ExceptObject));
        End;
        _Changed := False;
      End;

    Procedure TXMLFile.SaveToStream(Stream: TStream;
        StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = False);

      Var O:    TXMLOptions;
        Writer: TXWriter;
        Timer:  LongWord;

      Begin
        Try
          O := _Options;
          If IgnoreEncodingAttributes Then Include(O, xo_IgnoreEncoding);
          DoStatus(xsSave, 0);
          Timer  := GetTickCount + Cardinal(_UpdateIntervall);
          Writer := TXWriter.Create(Stream, O, _LineFeed, _TextIndent, _ValueSeperator, _ValueQuotation);
          Try
            If StartEncoding <= High(TXMLEncoding) Then Writer.SetEnc(StartEncoding);
            Writer.WriteBOM;
            TXMLFile.AssembleTree(Self, Writer, _Nodes, @Timer);
            DoStatus(xsSaveEnd, (Writer.Size + (_StatusScale div 2)) div _StatusScale);
          Finally
            Writer.Free;
          End;
        Except
          Raise EXMLException.Create(ClassType, 'SaveToStream', @SInvalidValueN, [], Exception(ExceptObject));
        End;
        _Changed := False;
      End;

    {$IFNDEF hxExcludeClassesUnit}

      Procedure TXMLFile.LoadFromResource(Instance: THandle; Const ResName: String; ResType: PChar = RT_RCDATA);
        Var Stream: TResourceStream;
          ResID:    Integer;

        Begin
          If (ResName = '') or (ResName[1] <> '#')
              or not TryStrToInt(Copy(ResName, 2, Length(ResName)), ResID) Then Begin
            Try
              Stream := TResourceStream.Create(Instance, ResName, ResType);
              Try
                LoadFromStream(Stream);
              Finally
                Stream.Free;
              End;
            Except
              Raise EXMLException.Create(ClassType, 'LoadFromResource', @SInvalidValueN, [], Exception(ExceptObject));
            End;
          End Else LoadFromResource(Instance, ResID, ResType);
        End;

      Procedure TXMLFile.LoadFromResource(Instance: THandle; ResID: Integer; ResType: PChar = RT_RCDATA);
        Var Stream: TResourceStream;
          C:        WideChar;

        Begin
          Try
            If ResType = RT_STRING Then Begin
              Stream := TResourceStream.CreateFromID(Instance, ResID div 16, ResType);
              Try
                ResID := ResID mod 16;
                While (ResID > 0) and (Stream.Read(C, 2) = 2) do
                  If C = #0 Then Dec(ResID);
                If ResID <> 0 Then Raise EXMLException.Create(TXMLFile, 'LoadFromResource', @SInvalidValueN);
                LoadFromStream(Stream, xeUnicode, True);
              Finally
                Stream.Free;
              End;
            End Else Begin
              Stream := TResourceStream.CreateFromID(Instance, ResID, ResType);
              Try
                LoadFromStream(Stream);
              Finally
                Stream.Free;
              End;
            End;
          Except
            Raise EXMLException.Create(ClassType, 'LoadFromResource', @SInvalidValueN, [], Exception(ExceptObject));
          End;
        End;

      Procedure TXMLFile.LoadFromXML(Const XMLString: AnsiString;
          StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = True);

        Var Stream: TStream;

        Begin
          Try
            Stream := TMemoryStream.Create;
            Try
              Stream.WriteBuffer(PAnsiChar(XMLString)^, Length(XMLString));
              Stream.Position := 0;
              LoadFromStream(Stream, StartEncoding, IgnoreEncodingAttributes);
            Finally
              Stream.Free;
            End;
          Except
            Raise EXMLException.Create(ClassType, 'LoadFromXML', @SInvalidValue,
              [EXMLException.Str(XMLString)], Exception(ExceptObject));
          End;
        End;

      Procedure TXMLFile.LoadFromXML(Const XMLString: TWideString;
          StartEncoding: TXMLEncoding = xeUnicode; IgnoreEncodingAttributes: Boolean = True);

        Var Stream: TStream;

        Begin
          Try
            Stream := TMemoryStream.Create;
            Try
              Stream.WriteBuffer(PWideChar(XMLString)^, Length(XMLString) * 2);
              Stream.Position := 0;
              If not (StartEncoding in [xeUnicode, xeUnicodeBE]) Then StartEncoding := xeUnicode;
              LoadFromStream(Stream, StartEncoding, IgnoreEncodingAttributes);
            Finally
              Stream.Free;
            End;
          Except
            Raise EXMLException.Create(ClassType, 'LoadFromXML', @SInvalidValue,
              [EXMLException.Str(XMLString)], Exception(ExceptObject));
          End;
        End;

      Procedure TXMLFile.SaveToXML(Var XMLString: AnsiString;
          StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = True);

        Var Stream: TStream;

        Begin
          Try
            Stream := TMemoryStream.Create;
            Try
              SaveToStream(Stream, StartEncoding, IgnoreEncodingAttributes);
              Stream.Position := 0;
              SetLength(XMLString, Stream.Size);
              Stream.ReadBuffer(PAnsiChar(XMLString)^, Stream.Size);
            Finally
              Stream.Free;
            End;
          Except
            Raise EXMLException.Create(ClassType, 'SaveToXML', @SInvalidValueN, [], Exception(ExceptObject));
          End;
        End;

      Procedure TXMLFile.SaveToXML(Var XMLString: TWideString;
          StartEncoding: TXMLEncoding = xeUnicode; IgnoreEncodingAttributes: Boolean = True);

        Var Stream: TStream;

        Begin
          Try
            Stream := TMemoryStream.Create;
            Try
              If not (StartEncoding in [xeUnicode, xeUnicodeBE]) Then StartEncoding := xeUnicode;
              SaveToStream(Stream, StartEncoding, IgnoreEncodingAttributes);
              Stream.Position := 0;
              SetLength(XMLString, Stream.Size div 2);
              Stream.ReadBuffer(PWideChar(XMLString)^, Stream.Size and -2);
            Finally
              Stream.Free;
            End;
          Except
            Raise EXMLException.Create(ClassType, 'SaveToXML', @SInvalidValueN, [], Exception(ExceptObject));
          End;
        End;

    {$ENDIF}

    Procedure TXMLFile.ClearDocument(CreateRootNodes: Boolean = True);
      Begin
        If CreateRootNodes Then ClearDocument('xml') Else ClearDocument('');
      End;

    Procedure TXMLFile.ClearDocument(Const NameOfRootNode: TWideString);
      Var Node: TXMLNode;

      Begin
        If (NameOfRootNode <> '') and not TXHelper.CheckString(NameOfRootNode, xtElement_NodeName) Then
          Raise EXMLException.Create(ClassType, 'ClearDocument', @SInvalidName, NameOfRootNode);
        _Nodes.Clear;
        If NameOfRootNode = '' Then Exit;
        Node := _Nodes.Add('xml', xtInstruction);
        Node.Attributes.Add('version',    '1.0');
        Node.Attributes.Add('encoding',   'UTF-8');
        Node.Attributes.Add('standalone', 'yes');
        _Nodes.Add(NameOfRootNode);
      End;

    Function TXMLFile.AddNode(Const Name: TWideString; NodeType: TXMLNodeType = xtElement): TXMLNode;
      {inline}

      Begin
        Result := RootNode.Nodes.Add(Name, NodeType);
      End;

    Class Function TXMLFile.RegisterSerProc(Proc: TXMLSerializeProc): Boolean;
      Begin
        Result := TXHelper.RegisterSerProc(Proc);
      End;

    Class Procedure TXMLFile.DeregisterSerProc(Proc: TXMLSerializeProc);
      Begin
        TXHelper.DeregisterSerProc(Proc);
      End;

    Class Function TXMLFile.isRegisteredSerProc(Proc: TXMLSerializeProc): Boolean;
      Begin
        Result := TXHelper.isRegisteredSerProc(Proc);
      End;

    Class Function TXMLFile.RegisterSerClass(C: TClass): Boolean;
      Begin
        Result := TXHelper.RegisterSerClass(C);
      End;

    Class Function TXMLFile.RegisterSerClass(Const C: Array of TClass): Boolean;
      Var i: Integer;

      Begin
        Result := True;
        For i := 0 to High(C) do Result := Result and TXHelper.RegisterSerClass(C[i]);
      End;

    Class Procedure TXMLFile.DeregisterSerClass(C: TClass);
      Begin
        TXHelper.DeregisterSerClass(C);
      End;

    Class Procedure TXMLFile.DeregisterSerClass(Const C: Array of TClass);
      Var i: Integer;

      Begin
        For i := 0 to High(C) do TXHelper.DeregisterSerClass(C[i]);
      End;

    Class Function TXMLFile.isRegisteredSerClass(C: TClass): Boolean;
      Begin
        Result := TXHelper.isRegisteredSerClass(C);
      End;

    Class Function TXMLFile.isRegisteredSerClass(Const C: Array of TClass): Boolean;
      Var i: Integer;

      Begin
        Result := True;
        For i := 0 to High(C) do Result := Result and TXHelper.isRegisteredSerClass(C[i]);
      End;

    Class Procedure TXMLFile.SetValueSerProc(VType: TTypeKind; Const Name: AnsiString;
        SProc: TXMLValueSerialize; DProc: TXMLValueDeserialize; PrivParam: Integer = 0);
      Begin
        TXHelper.SetValueSerProc(VType, Name, SProc, DProc, PrivParam);
      End;

    Class Function TXMLFile.GetValueSerProc: TXMLValueSerializeArray;
      Begin
        TXHelper.GetValueSerProc(Result);
      End;

    Function TXMLFile.Cryptors: TWideStringDynArray;
      Var i: Integer;

      Begin
        SetLength(Result, Length(_Cryptors));
        For i := 0 to High(_Cryptors) do
          Result[i] := _Cryptors[i].Name;
      End;

    Procedure TXMLFile.SetCryptor(Const CName: TWideString; Proc: TXMLEncryptionProc; Const Data: AnsiString);
      Begin
        CryptProc[CName] := Proc;
        If Assigned(Proc) Then CryptData[CName] := Data;
      End;

    Procedure TXMLFile.ChangeAllCryptors(Const NewCryptName: TWideString);
      Var E: Exception;

      Begin
        If not TXHelper.CheckString(NewCryptName, xtElement_NodeName) Then
          Raise EXMLException.Create(ClassType, 'ChangeAllCryptors', @SInvalidName, NewCryptName);
        E := nil;
        Try
          InnerChangeAllCryptors('*', NewCryptName, CryptProc[NewCryptName], CryptData[NewCryptName], E);
        Finally
          If Assigned(E) Then Raise E;
        End;
      End;

    Procedure TXMLFile.ChangeAllCryptProcs(Const CName: TWideString; NewProc: TXMLEncryptionProc; Const NewData: AnsiString);
      Var E: Exception;

      Begin
        If not TXHelper.CheckString(CName, xtElement_NodeName) Then
          Raise EXMLException.Create(ClassType, 'ChangeAllCryptProcs', @SInvalidName, CName);
        If not Assigned(NewProc) Then
          Raise EXMLException.Create(ClassType, 'ChangeAllCryptProcs', @SInvalidValueN);
        E := nil;
        Try
          InnerChangeAllCryptors(CName, CName, NewProc, NewData, E);
        Finally
          SetCryptor(CName, NewProc, NewData);
          If Assigned(E) Then Raise E;
        End;
      End;

    Procedure TXMLFile.ChangeAllCryptNames(Const NewAttrName: TWideString);
      Procedure Change(N: TXMLNode; Const S: TWideString; Var E: Exception);
        Var i, i2: Integer;

        Begin
          While Assigned(N) do Begin
            Try
              i := N.Attributes.IndexOfCS(S);
              If i >= 0 Then Begin
                Repeat
                  i2 := N.Attributes.IndexOfCS(_CryptAttrName);
                  If i2 >= 0 Then N.Attributes.Delete(i2) Else Break;
                Until False;
                N.Attributes.Name[i] := _CryptAttrName;
              End;
            Except
              If not Assigned(E) Then E := AcquireExceptionObject;
            End;
            Change(N.Nodes.FirstNodeNF, S, E);
            N := N.NextNodeNF;
          End;
        End;

      Var E: Exception;
        S:   TWideString;

      Begin
        E := nil;
        Try
          S := _CryptAttrName;
          CryptAttrName := NewAttrName;
          Change(_Nodes.FirstNodeNF, S, E);
        Finally
          If Assigned(E) Then Raise E;
        End;
      End;

    Procedure TXMLFile.SetDefaultCryptor(Const CName: TWideString);
      Var i: Integer;
        T:   TXMLCryptor;

      Begin
        For i := 0 to High(_Cryptors) do
          If TXHelper.SameTextW(_Cryptors[i].Name, CName, Self) Then
            If i <> 0 Then Begin
              T            := _Cryptors[0];
              _Cryptors[0] := _Cryptors[i];
              _Cryptors[i] := T;
              Exit;
            End Else Exit;
        Raise EXMLException.Create(ClassType, 'SetDefaultCryptor', @SInvalidName, CName);
      End;

    Procedure TXMLFile._Lock;
      {inline}

      Begin
        EnterCriticalSection(_ThreadLock);
      End;

    Function TXMLFile._TryLock: Boolean;
      {inline}

      Begin
        Result := TryEnterCriticalSection(_ThreadLock);
      End;

    Procedure TXMLFile._Unlock;
      {inline}

      Begin
        LeaveCriticalSection(_ThreadLock);
      End;

    Function TXMLFile._isLocked: Boolean;
      Begin
        Result := TryEnterCriticalSection(_ThreadLock);
        If Result Then LeaveCriticalSection(_ThreadLock);
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TXMLFile - global'}{$IFEND}

    Class Procedure TXMLFile.Initialize;
      Begin
        {$IF DELPHI < 2006}TXMLFile__DefaultOptions       {$ELSE}__DefaultOptions{$IFEND}        := XMLDefaultOptions;
        {$IF DELPHI < 2006}TXMLFile__DefaultTextIndent    {$ELSE}__DefaultTextIndent{$IFEND}     := '  ';
        {$IF DELPHI < 2006}TXMLFile__DefaultLineFeed      {$ELSE}__DefaultLineFeed{$IFEND}       := sLineBreak;
        {$IF DELPHI < 2006}TXMLFile__DefaultValueSeperator{$ELSE}__DefaultValueSeperator{$IFEND} := '=';
        {$IF DELPHI < 2006}TXMLFile__DefaultValueQuotation{$ELSE}__DefaultValueQuotation{$IFEND} := '"';
        {$IF DELPHI < 2006}TXMLFile__PathDelimiter        {$ELSE}__PathDelimiter{$IFEND}         := SysUtils.PathDelim;
      End;

    Class Function TXMLFile.GetOptions(Owner: TXMLFile = nil): TXMLOptions;
      {inline}

      Begin
        If Assigned(Owner) Then Result := Owner._Options
        Else Result := {$IF DELPHI < 2006}TXMLFile__DefaultOptions{$ELSE}__DefaultOptions{$IFEND};
      End;

    Class Function TXMLFile.GetNTypeMask(Owner: TXMLFile = nil): TXMLNodeTypes;
      Var Options: TXMLOptions;

      Begin
        Result  := [Low(TXMLNodeType)..High(TXMLNodeType)];
        Options := GetOptions(Owner);
        If xoHideInstructionNodes in Options Then Exclude(Result, xtInstruction);
        If xoHideTypedefNodes     in Options Then Exclude(Result, xtTypedef);
        If xoHideCDataNodes       in Options Then Exclude(Result, xtCData);
        If xoHideCommentNodes     in Options Then Exclude(Result, xtComment);
        If xoHideUnknownNodes     in Options Then Exclude(Result, xtUnknown);
      End;

    Class Procedure TXMLFile.ParsingTree(Owner: TXMLFile; Reader: TXReader; Tree: TXMLNodeList; StatusTimer: PLongWord; Internal: Boolean = False);
      Const cDataType: Array[xdInstruction..xdComment] of TXMLNodeType = (xtInstruction, xtTypedef, xtElement, xtCData, xtComment);

      Var Node:    TXMLNode;
        i, i2, i3: Integer;
        B:         Boolean;
        S:         TWideString;
        V:         TXMLVersion;
        E:         TXMLEncoding;

      Begin
        Try
          Node  := nil;
          i     := 0;
          i2    := 0;
          While Reader.Parse do Begin
            Case Reader.DataType of
              xdInstruction, xdElement: Begin
                Node := Tree.Add(Reader.Name, cDataType[Reader.DataType]);
                i    := 0;
                i2   := 0;
              End;
              xdTypedef, xdCData, xdComment:
                Node := Tree.Add(Reader.Name, cDataType[Reader.DataType]);
              xdAttribute:
                If Assigned(Node) and (Node.NodeType in [xtInstruction, xtElement]) Then Begin
                  Node.Attributes.SetInnerAttributeValue(Node.Attributes.Add(Reader.Name, ''), Reader.Value);
                  Inc(i);
                  If Reader.NewLine Then Inc(i2);
                End Else Raise EXMLException.Create(Self, 'ParsingTree', @SInternalError, 1);
              xdEndAttribute:
                If Assigned(Node) and (Node.NodeType = xtElement) Then Begin
                  B := True;
                  If (Node.NodeType = xtElement) and Assigned(Owner) Then
                    For i3 := High(Owner._ParsedSingleTags) downto 0 do
                      If TXHelper.CompareHash(Owner._ParsedSingleTags[i3].NameHash, Node.InnerNameHash)
                          and TXHelper.SameTextW(Owner._ParsedSingleTags[i3].Name, Node.Name,
                            xoCaseSensitive in Reader.Options) Then Begin
                        B := False;
                        Break;
                      End;
                  If B Then ParsingTree(Owner, Reader, Node.Nodes, StatusTimer, True)
                  Else Reader.CloseSingleNode;
                  Node := nil;
                End Else Raise EXMLException.Create(Self, 'ParsingTree', @SInternalError, 2);
              xdText:
                If Assigned(Node) and (Node.NodeType in [xtTypedef, xtCData, xtComment]) Then Begin
                  If Node.InnerText <> '' Then Raise EXMLException.Create(Self, 'ParsingTree', @SInternalError, 3);
                  Node.InnerText := Reader.Value;
                End Else Tree.Add(Reader.Name, xtUnknown).InnerText := Reader.Value;
              xdClose: Begin
                If not Internal Then
                  Raise EXMLException.Create(Self, 'ParsingTree', @SInvalidClosingTag, Reader.Name);
                If not TXHelper.SameTextW(Reader.Name, Tree.Parent.Name, xoCaseSensitive in Reader.Options) Then
                  Raise EXMLException.Create(Self, 'ParsingTree', @SUnknownClosingTag,
                    [EXMLException.Str(Tree.Parent.Name), EXMLException.Str(Reader.Name)]);
                If (Tree.CountNF = 1) and (Tree.FirstNodeNF.NodeType = xtUnknown) and Assigned(Tree.Parent) Then Begin
                  Tree.Parent.InnerText := Tree.FirstNodeNF.InnerText;
                  Tree.Clear;
                End;
                Exit;
              End;
              xdCloseSingle:
                If Assigned(Node) Then Begin
                  If (Node.NodeType = xtInstruction) and TXHelper.MatchText('xml|XML',
                      Node.Name, xoCaseSensitive in Reader.Options) Then Begin
                    If Node.Attributes.Exists('version') Then Begin
                      S := Node.Attributes['version'];
                      V := Low(TXMLVersion);
                      While V <= High(TXMLVersion) do Begin
                        If TXHelper.SameTextW(XMLVersionData[V].Version, S, xoCaseSensitive in Reader.Options) Then Break;
                        Inc(V);
                      End;
                      Reader.SetVer(V);
                    End;
                    If Node.Attributes.Exists('encoding') and not (xo_IgnoreEncoding in Reader.Options) Then Begin
                      S := Node.Attributes['encoding'];
                      E := Low(TXMLEncoding);
                      While E <= High(TXMLEncoding) do Begin
                        If (S <> '') and TXHelper.SameTextW(XMLEncodingData[E].Encoding, S, xoCaseSensitive in Reader.Options) Then Break;
                        Inc(E);
                      End;
                      Reader.SetEnc(E);
                    End;
                  End;
                  Node := nil;
                End Else Raise EXMLException.Create(Self, 'ParsingTree', @SInternalError, 4);
            End;
            If Assigned(Owner) and Assigned(Owner._OnStatus) and Assigned(StatusTimer)
                and (LongInt(GetTickCount - StatusTimer^) >= 0) Then Begin
              Owner.DoStatus(xsLoad, (Reader.Position * 100000 + 50000) div Reader.Size);
              StatusTimer^ := GetTickCount + Cardinal(Owner._UpdateIntervall);
            End;
          End;
          If Internal Then Raise EXMLException.Create(Self, 'ParsingTree', @SEndOfData);
        Except
          Raise EXMLException.Create(Self, 'ParsingTree', @SErrorPos,
            [Reader.Lines / 1, Reader.Col / 1, '', Reader.Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Class Procedure TXMLFile.AssembleTree(Owner: TXMLFile; Writer: TXWriter; Tree: TXMLNodeList; StatusTimer: PLongWord);
      Var i:  Integer;
        B:    Boolean;
        S:    TWideString;
        V:    TXMLVersion;
        E:    TXMLEncoding;
        Node: TXMLNode;

      Begin
        Try
          Node := Tree.FirstNodeNF;
          While Assigned(Node) do Begin
            Case Node.NodeType of
              xtInstruction: Begin
                Writer.OpenNode(xdInstruction, Node.Name);
                For i := 0 to Node.Attributes.Count - 1 do
                  Writer.WriteAttr(Node.Attributes.Name[i], Node.Attributes.GetInnerAttributeValue(i));
                Writer.CloseNode(xdInstruction);
                If TXHelper.MatchText('xml|XML', Node.Name, xoCaseSensitive in Writer.Options) Then Begin
                  If Node.Attributes.Exists('version') Then Begin
                    S := Node.Attributes['version'];
                    V := Low(TXMLVersion);
                    While V <= High(TXMLVersion) do Begin
                      If TXHelper.SameTextW(XMLVersionData[V].Version, S, xoCaseSensitive in Writer.Options) Then Break;
                      Inc(V);
                    End;
                    Writer.SetVer(V);
                  End;
                  If Node.Attributes.Exists('encoding') and not (xo_IgnoreEncoding in Writer.Options) Then Begin
                    S := Node.Attributes['encoding'];
                    E := Low(TXMLEncoding);
                    While E <= High(TXMLEncoding) do Begin
                      If (S <> '') and TXHelper.SameTextW(XMLEncodingData[E].Encoding, S, xoCaseSensitive in Writer.Options) Then Break;
                      Inc(E);
                    End;
                    Writer.SetEnc(E);
                  End;
                End;
              End;
              xtTypedef: Begin
                Writer.OpenNode(xdTypedef, Node.Name);
                Writer.WriteText(xdTypedef, Node.InnerText);
                Writer.CloseNode(xdTypedef);
              End;
              xtElement: Begin
                Writer.OpenNode(xdElement, Node.Name);
                For i := 0 to Node.Attributes.Count - 1 do
                  Writer.WriteAttr(Node.Attributes.Name[i], Node.Attributes.GetInnerAttributeValue(i));
                B := True;
                If Assigned(Owner) Then
                  For i := High(Owner._ParsedSingleTags) downto 0 do
                    If TXHelper.CompareHash(Owner._ParsedSingleTags[i].NameHash, Node.InnerNameHash)
                        and TXHelper.SameTextW(Owner._ParsedSingleTags[i].Name, Node.Name,
                          xoCaseSensitive in Writer.Options) Then Begin
                      B := False;
                      Break;
                    End;
                If B Then Begin
                  If (Node.InnerText <> '') or Assigned(Node.Nodes.FirstNodeNF)
                      or (xoFullEmptyElements in Writer.Options) Then Begin
                    Writer.CloseNode(xdElement, False);
                    If Assigned(Node.Nodes.FirstNodeNF) Then
                      AssembleTree(Owner, Writer, Node.Nodes, StatusTimer)
                    Else Writer.WriteText(xdElement, Node.InnerText);
                    Writer.CloseNode(Node.Name);
                  End Else Writer.CloseNode(xdElement, True);
                End Else
                  If (Node.InnerText = '') and not Assigned(Node.Nodes.FirstNodeNF) Then
                    Writer.CloseNotMarkedSingleNode
                  Else Raise EXMLException.Create(Self, 'AssembleTree', @SNoSubnodes);
              End;
              xtCData: Begin
                Writer.OpenNode(xdCData, Node.Name);
                Writer.WriteText(xdCData, Node.InnerText);
                Writer.CloseNode(xdCData);
              End;
              xtComment: Begin
                Writer.OpenNode(xdComment, Node.Name);
                Writer.WriteText(xdComment, Node.InnerText);
                Writer.CloseNode(xdComment);
              End;
              xtUnknown: Writer.WriteText(xdText, Node.InnerText);
              Else Raise EXMLException.Create(Self, 'AssembleTree', @SInternalError, 1);
            End;
            If Assigned(Owner) and Assigned(Owner._OnStatus) and Assigned(StatusTimer)
                and (LongInt(GetTickCount - StatusTimer^) >= 0) Then Begin
              Owner.DoStatus(xsSave, (Writer.Size + (Owner._StatusScale div 2)) div Owner._StatusScale);
              StatusTimer^ := GetTickCount + Cardinal(Owner._UpdateIntervall);
            End;
            Node := Node.NextNodeNF;
          End;
        Except
          Raise EXMLException.Create(Self, 'AssembleTree', @SErrorPos,
            [Writer.Lines / 1, Writer.Col / 1, '', Writer.Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Procedure TXMLFile.InnerChangeAllCryptors(Const OldCName, NewCName: TWideString;
        NewProc: TXMLEncryptionProc; Const NewData: AnsiString; Var E: Exception);

      Procedure Change(N: TXMLNode);
        Var S: String;

        Begin
          While Assigned(N) do Begin
            Try
              S := N.Attributes[_CryptAttrName];
              If (S <> '') and TXHelper.MatchText(OldCName, S, False) and Assigned(CryptProc[S]) Then Begin
                N.Recrypt(CryptProc[S], CryptData[S], NewProc, NewData);
                N.Attributes[_CryptAttrName] := NewCName;
              End;
            Except
              If not Assigned(E) Then E := AcquireExceptionObject;
            End;
            Change(N.Nodes.FirstNodeNF);
            N := N.NextNodeNF;
          End;
        End;

      Begin
        Change(_Nodes.FirstNodeNF);
      End;

    Procedure TXMLFile.DoChanged;
      Begin
        _Changed := True;
      End;

    Procedure TXMLFile.DoNodeChange(Node: TXMLNode; CType: TXMLNodeChangeType);
      Begin
        _Changed := True;
        If Assigned(_OnNodeChange) Then
          Try
            _OnNodeChange(Node, CType);
          Except
            TXHelper.HandleException(Exception(ExceptObject), Self._OnException, Self);
          End;
      End;

    Procedure TXMLFile.DoStatus(SType: TXMLFileStatus; State: Cardinal = 0);
      Begin
        If Assigned(_OnStatus) Then
          Try
            _OnStatus(Self, SType, State);
          Except
            TXHelper.HandleException(Exception(ExceptObject), Self._OnException, Self);
          End;
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TXMLNodeList'}{$IFEND}

    Function TXMLNodeList.GetFirstNode: TXMLNode;
      Var NType: TXMLNodeTypes;

      Begin
        NType  := TXMLFile.GetNTypeMask(_Owner);
        Result := FirstNodeNF;
        While Assigned(Result) do Begin
          If Result.NodeType in NType Then Exit;
          Result := Result.NextNodeNF;
        End;
      End;

    Function TXMLNodeList.GetCount: Integer;
      Var NType: TXMLNodeTypes;
        Node:    TXMLNode;

      Begin
        Result := 0;
        NType  := TXMLFile.GetNTypeMask(_Owner);
        Node   := FirstNodeNF;
        While Assigned(Node) do Begin
          If Node.NodeType in NType Then Inc(Result);
          Node := Node.NextNodeNF;
        End;
      End;

    {$IFDEF hxExcludeTIndex}
      Function TXMLNodeList.GetNode(IndexOrName: TIndex): TXMLNode;
        Var NType:  TXMLNodeTypes;
          Name:     TWideString;
          NameHash: LongWord;
          Index, i: Integer;
          Attr:     TXMLAttributeArray;

        Begin
          If VarIsType(IndexOrName, [varShortInt, varSmallInt, varInteger, varByte, varWord, varLongWord]) Then Begin
            Index := IndexOrName;
    {$ELSE}
      Function TXMLNodeList.GetNode(Index: Integer): TXMLNode;
        Var NType: TXMLNodeTypes;

        Begin
    {$ENDIF}
          NType  := TXMLFile.GetNTypeMask(_Owner);
          Result := FirstNodeNF;
          While Assigned(Result) do Begin
            If Result.NodeType in NType Then
              If Index = 0 Then Break Else Dec(Index);
            Result := Result.NextNodeNF;
          End;
    {$IFDEF hxExcludeTIndex}
          End Else If VarIsType(IndexOrName, [varOleStr, varString {$IF Declared(UnicodeString)}, varUString{$IFEND}]) Then Begin
            Name := IndexOrName;
    {$ELSE}
        End;

      Function TXMLNodeList.GetNamedNode(Name: TWideString): TXMLNode;
        Var NType:  TXMLNodeTypes;
          NameHash: LongWord;
          Attr:     TXMLAttributeArray;
          Index, i: Integer;

        Begin
    {$ENDIF}
          If ParseNodePath(Self, Name, []) Then Begin
            If (Name <> '') and (Name[1] = '#') Then Begin
              Result := FindNode[Copy(Name, 2, Length(Name))];
              Exit;
            End;
            SplittNodeName(NameHash, Name, Attr, Index, 'Node');
            NType  := TXMLFile.GetNTypeMask(_Owner);
            Result := FirstNodeNF;
            While Assigned(Result) do Begin
              If CompareNode(Result, NType, NameHash, Name, Attr) Then
                If Index <= 0 Then Break Else Dec(Index);
              Result := Result.NextNodeNF;
            End;
            If not Assigned(Result) and (xoNodeAutoCreate in TXMLFile.GetOptions(_Owner)) Then Begin
              Repeat
                Result := Add(Name);
                Try
                  For i := 0 to High(Attr) do
                    Result.Attributes.Add(Attr[i].Name, Attr[i].Value);
                Except
                  Result.Free;
                  Raise;
                End;
                Dec(Index);
              Until Index <= 0;
            End;
          End Else Result := nil;
    {$IFNDEF hxExcludeTIndex}
        End;
    {$ELSE}
          End Else Result := nil;
        End;
    {$ENDIF}

    Function TXMLNodeList.GetNamedNodeU(Name: TWideString): TXMLNode;
      Var NType:  TXMLNodeTypes;
        NameHash: LongWord;
        Attr:     TXMLAttributeArray;
        Index:    Integer;

      Begin
        If ParseNodePath(Self, Name, [xpNotCreate]) Then Begin
          If (Name <> '') and (Name[1] = '#') Then Begin
            Result := FindNode[Copy(Name, 2, Length(Name))];
            Exit;
          End;
          SplittNodeName(NameHash, Name, Attr, Index, 'NodeU');
          NType  := TXMLFile.GetNTypeMask(_Owner);
          Result := FirstNodeNF;
          While Assigned(Result) do Begin
            If CompareNode(Result, NType, NameHash, Name, Attr) Then
              If Index <= 0 Then Break Else Dec(Index);
            Result := Result.NextNodeNF;
          End;
        End Else Result := nil;
      End;

    Function TXMLNodeList.GetNodeArray(Name: TWideString): TXMLNodeArray;
      Var NType:  TXMLNodeTypes;
        NameHash: LongWord;
        Attr:     TXMLAttributeArray;
        Node:     TXMLNode;
        i:        Integer;

      Begin
        Result := nil;
        If ParseNodePath(Self, Name, []) Then Begin
          SplittNodeName(NameHash, Name, Attr, i, 'NodeList');
          If i >= 0 Then Raise EXMLException.Create(ClassType, 'NodeList',
            @SIndexNotAllowed, [EXMLException.Str(Name), i]);
          NType := TXMLFile.GetNTypeMask(_Owner);
          Node  := FirstNodeNF;
          i     := 0;
          While Assigned(Node) do Begin
            If CompareNode(Node, NType, NameHash, Name, Attr) Then Begin
              SetLength(Result, (i + 16) and -16);
              Result[i] := Node;
              Inc(i);
            End;
            Node := Node.NextNodeNF;
          End;
          SetLength(Result, i);
        End;
      End;

    Function TXMLNodeList.GetFindNode(Name: TWideString): TXMLNode;
      Var A: TXMLNodeArray;
        i:   Integer;

      Begin
        Result := NodeU[Name];
        If not Assigned(Result) Then Begin
          A := NodeList['*'];
          For i := 0 to High(A) do Begin
            Result := A[i].FindNode[Name];
            If Assigned(Result) Then Exit;
          End;
        End;
      End;

    Function TXMLNodeList.GetFindNodeArray(Name: TWideString): TXMLNodeArray;
      Var N:   TXMLNode;
        A, A2: TXMLNodeArray;
        i, i2: Integer;

      Begin
        Result := nil;
        N := NodeU[Name];
        If Assigned(N) Then Begin
          SetLength(Result, 1);
          Result[0] := N;
        End;
        A := NodeList['*'];
        For i := 0 to High(A) do Begin
          A2 := A[i].FindNodes[Name];
          If Assigned(A2) Then Begin
            i2 := Length(Result);
            SetLength(Result, i2 + Length(A2));
            MoveMemory(@Result[i2], @A2[0], Length(A2) * SizeOf(TXMLNode));
          End;
        End;
      End;

    Function TXMLNodeList.GetNodeCount: Integer;
      Var NType: TXMLNodeTypes;
        Node:    TXMLNode;

      Begin
        Result := 0;
        NType  := TXMLFile.GetNTypeMask(_Owner);
        Node   := FirstNodeNF;
        While Assigned(Node) do Begin
          If Node.NodeType in NType Then
            Inc(Result, Node.Nodes.NodeCount + 1);
          Node := Node.NextNodeNF;
        End;
      End;

    Function TXMLNodeList.GetNFNodeCount: Integer;
      Var Node: TXMLNode;

      Begin
        Result := 0;
        Node   := FirstNodeNF;
        While Assigned(Node) do Begin
          Inc(Result, Node.Nodes.NodeCount + 1);
          Node := Node.NextNodeNF;
        End;
      End;

    Function TXMLNodeList.GetNFNode(IndexOrName: TIndex): TXMLNode;
      Var NameHash:  LongWord;
        Attr:        TXMLAttributeArray;
        Index, i:    Integer;
        {$IFDEF hxExcludeTIndex}
        StringValue: TWideString;
        IntValue:    Integer;
        {$ENDIF}

      Begin
        {$IFNDEF hxExcludeTIndex}
          With IndexOrName do
            Case ValueType of
              vtStringValue: Begin
        {$ELSE}
              If VarIsType(IndexOrName, [varOleStr, varString {$IF Declared(UnicodeString)}, varUString{$IFEND}]) Then Begin
                StringValue := IndexOrName;
        {$ENDIF}
                If ParseNodePath(Self, StringValue, [xpNonFilered]) Then Begin
                  If (StringValue <> '') and (StringValue[1] = '#') Then Begin
                    Result := FindNodeNF[Copy(StringValue, 2, Length(StringValue))];
                    Exit;
                  End;
                  SplittNodeName(NameHash, StringValue, Attr, Index, 'NodeNF');
                  Result := FirstNodeNF;
                  While Assigned(Result) do Begin
                    If CompareNode(Result, [Low(TXMLNodeType)..High(TXMLNodeType)], NameHash, StringValue, Attr) Then
                      If Index <= 0 Then Break Else Dec(Index);
                    Result := Result.NextNodeNF;
                  End;
                  If Assigned(Result) and (xoNodeAutoCreate in TXMLFile.GetOptions(_Owner)) Then
                    Repeat
                      Result := Add(StringValue);
                      Try
                        For i := 0 to High(Attr) do
                          Result.Attributes.Add(Attr[i].Name, Attr[i].Value);
                      Except
                        Result.Free;
                        Raise;
                      End;
                      Dec(Index);
                    Until Index <= 0;
                End Else Result := nil;
        {$IFNDEF hxExcludeTIndex}
              End;
              vtIntValue: Begin
        {$ELSE}
              End Else If VarIsType(IndexOrName, [varShortInt, varSmallInt, varInteger, varByte, varWord, varLongWord]) Then Begin
                IntValue := IndexOrName;
        {$ENDIF}
                Result := FirstNodeNF;
                While Assigned(Result) do Begin
                  If IntValue = 0 Then Exit Else Dec(IntValue);
                  Result := Result.NextNodeNF;
                End;
              End;
        {$IFNDEF hxExcludeTIndex}
              Else Result := nil;
            End;
        {$ENDIF}
      End;

    Function TXMLNodeList.GetNFNodeU(Name: TWideString): TXMLNode;
      Var NameHash: LongWord;
        Attr:       TXMLAttributeArray;
        Index:      Integer;

      Begin
        If ParseNodePath(Self, Name, [xpNotCreate, xpNonFilered]) Then Begin
          If (Name <> '') and (Name[1] = '#') Then Begin
            Result := FindNodeNF[Copy(Name, 2, Length(Name))];
            Exit;
          End;
          SplittNodeName(NameHash, Name, Attr, Index, 'NodeUNF');
          Result := FirstNodeNF;
          While Assigned(Result) do Begin
            If CompareNode(Result, [Low(TXMLNodeType)..High(TXMLNodeType)], NameHash, Name, Attr) Then
              If Index <= 0 Then Exit Else Dec(Index);
            Result := Result.NextNodeNF;
          End;
        End Else Result := nil;
      End;

    Function TXMLNodeList.GetNFNodeArray(Name: TWideString): TXMLNodeArray;
      Var i:      Integer;
        NameHash: LongWord;
        Attr:     TXMLAttributeArray;
        Node:     TXMLNode;

      Begin
        Result := nil;
        If ParseNodePath(Self, Name, [xpNonFilered]) Then Begin
          SplittNodeName(NameHash, Name, Attr, i, 'NodeListNF');
          If i >= 0 Then Raise EXMLException.Create(ClassType, 'NodeListNF',
            @SIndexNotAllowed, [EXMLException.Str(Name), i]);
          Node := FirstNodeNF;
          i    := 0;
          While Assigned(Node) do Begin
            If CompareNode(Node, [Low(TXMLNodeType)..High(TXMLNodeType)], NameHash, Name, Attr) Then Begin
              SetLength(Result, (i + 16) and -16);
              Result[i] := Node;
              Inc(i);
            End;
            Node := Node.NextNodeNF;
          End;
          SetLength(Result, i);
        End;
      End;

    Function TXMLNodeList.GetNFFindNode(Name: TWideString): TXMLNode;
      Var A: TXMLNodeArray;
        i:   Integer;

      Begin
        Result := NodeUNF[Name];
        If not Assigned(Result) Then Begin
          A := NodeListNF['*'];
          For i := 0 to High(A) do Begin
            Result := A[i].FindNodeNF[Name];
            If Assigned(Result) Then Exit;
          End;
        End;
      End;

    Function TXMLNodeList.GetNFFindNodeArray(Name: TWideString): TXMLNodeArray;
      Var N:   TXMLNode;
        A, A2: TXMLNodeArray;
        i, i2: Integer;

      Begin
        Result := nil;
        N := NodeUNF[Name];
        If Assigned(N) Then Begin
          SetLength(Result, 1);
          Result[0] := N;
        End;
        A := NodeListNF['*'];
        For i := 0 to High(A) do Begin
          A2 := A[i].FindNodesNF[Name];
          If Assigned(A2) Then Begin
            i2 := Length(Result);
            SetLength(Result, i2 + Length(A2));
            MoveMemory(@Result[i2], @A2[0], Length(A2) * SizeOf(TXMLNode));
          End;
        End;
      End;

      Function TXMLNodeList.GetNodeCS(Name: TWideString): TXMLNode;
        Var NameHash: LongWord;
          Attr:       TXMLAttributeArray;
          Index:      Integer;

        Begin
          SplittNodeName(NameHash, Name, Attr, Index, 'NodeCS');
          Result := FirstNodeNF;
          While Assigned(Result) do Begin
            If CompareNodeCS(Result, NameHash, Name, Attr, False) Then
              If Index <= 0 Then Break Else Dec(Index);
            Result := Result.NextNodeNF;
          End;
        End;

    Constructor TXMLNodeList.Create(ParentOrOwner: TObject{TXMLNode, TXMLFile});
      Begin
        Inherited Create;
        If ParentOrOwner is TXMLNode Then Begin
          _Owner      := TXMLNode(ParentOrOwner).Owner;
          _Parent     := TXMLNode(ParentOrOwner);
        End Else If (ParentOrOwner is TXMLFile) or (ParentOrOwner = nil) Then Begin
          _Owner      := TXMLFile(ParentOrOwner);
          //_Parent   := nil;
        End Else Raise EXMLException.Create(ClassType, 'Create', @SInvalidParent2);
        //_NodesCount := 0;
        //_FirstNode  := nil;
        //_LastNode   := nil;
      End;

    Destructor TXMLNodeList.Destroy;
      Begin
        Clear;
        Inherited;
      End;

    Function TXMLNodeList.NextNode(Node: TXMLNode): TXMLNode;
      Var NType: TXMLNodeTypes;

      Begin
        If Assigned(Node) Then Begin
          If Node is TXMLNode Then Begin
            NType  := TXMLFile.GetNTypeMask(Node.Owner);
            Result := Node.NextNodeNF;
          End Else Result := nil;
        End Else Begin
          NType  := TXMLFile.GetNTypeMask(_Owner);
          Result := FirstNodeNF;
        End;
        While Assigned(Result) do Begin
          If Result.NodeType in NType Then Exit;
          Result := Result.NextNodeNF;
        End;
      End;

    Function TXMLNodeList.Add(Name: TWideString; NodeType: TXMLNodeType = xtElement): TXMLNode;
      Var i:     Integer;
        Attr:    TXMLAttributeArray;
        W:       LongWord;

      Begin
        If ParseNodePath(Self, Name, [xpDoCreate]) Then Begin
          If (Assigned(_Parent) and (_Parent.InnerText <> '')) or (Assigned(_FirstNode)
              and ((_FirstNode.NodeType = xtCData) or (NodeType = xtCData))) Then
            Raise EXMLException.Create(ClassType, 'Add', @SIsTextNode, _Parent.Name);
          SplittNodeName(W, Name, Attr, i, 'Add');
          If i >= 0 Then Raise EXMLException.Create(ClassType, 'Add',
            @SIndexNotAllowed, [EXMLException.Str(Name), i]);
          If not (NodeType in [xtInstruction..xtUnknown])
              //or ((NodeType = xtInstruction) and not TXHelper.CheckString(Name, xtInstruction_NodeName))
              //or ((NodeType = xtTypedef)     and not TXHelper.CheckString(Name, xtTypedef_NodeName))
              //or ((NodeType = xtElement)     and not TXHelper.CheckString(Name, xtElement_NodeName))
              {}or ((NodeType <= xtElement)    and not TXHelper.CheckString(Name, xtElement_NodeName))
              //or ((NodeType in [xtCData..xtUnknown]) and (Name <> '')) Then
              {}or ((NodeType >= xtCData) and (Name <> '')) Then
            Raise EXMLException.Create(ClassType, 'Add', @SInvalidName, Name);
          Result := TXMLNode.Create(nil, NodeType, Name);
          Try
            For i := 0 to High(Attr) do Result.Attributes.Add(Attr[i].Name, Attr[i].Value);
            Result.SetParent(Self);
            Result.SetOwner(_Owner);

            Inc(_NodesCount);
            If not Assigned(_FirstNode) Then _FirstNode := Result;
            If Assigned(_LastNode) Then _LastNode.InnerNext := Result;
            Result.InnerPrev := _LastNode;
            _LastNode        := Result;
            DoNodeChange(Result, xcAddetNode);
          Except
            Result.Free;
            Raise;
          End;
        End Else Raise EXMLException.Create(ClassType, 'Add', @SMissingPath, Name);
      End;

    Function TXMLNodeList.Insert(Node, RNode: TXMLNode; previousR: Boolean = False): TXMLNode;
      Begin
        If not (Node is TXMLNode) Then
          Raise EXMLException.Create(ClassType, 'Insert', @SInvalidNode);
        If (Assigned(_Parent) and (_Parent.InnerText <> '')) or (Assigned(_FirstNode)
            and ((_FirstNode.NodeType = xtCData) or (Node.NodeType = xtCData))) Then
          Raise EXMLException.Create(ClassType, 'Insert', @SIsTextNode, _Parent.Name);
        If Assigned(RNode) and (not (RNode is TXMLNode) or (RNode.ParentList <> Self)) Then
          Raise EXMLException.Create(ClassType, 'Insert', @SNodeNotInList);
        If Assigned(Node.ParentList) Then Node := Node.ParentList.Remove(Node);
        Inc(_NodesCount);
        If previousR Then Begin
          If not Assigned(RNode) Then RNode := _FirstNode;

          If not Assigned(_FirstNode) or (_FirstNode = RNode) Then _FirstNode := Node;
          If not Assigned(_LastNode)                          Then _LastNode  := Node;
          If Assigned(RNode) Then Begin
            If Assigned(RNode.InnerPrev) Then RNode.InnerPrev.InnerNext := Node;
            Node.InnerPrev  := RNode.InnerPrev;
            RNode.InnerPrev := Node;
          End;
        End Else Begin
          If not Assigned(RNode) Then RNode := _LastNode;

          If not Assigned(_FirstNode)                         Then _FirstNode := Node;
          If not Assigned(_LastNode)  or (_FirstNode = RNode) Then _LastNode  := Node;
          If Assigned(RNode) Then Begin
            If Assigned(RNode.InnerNext) Then RNode.InnerNext.InnerPrev := Node;
            Node.InnerNext  := RNode.InnerNext;
            RNode.InnerNext := Node;
          End;
        End;
        Node.CheckCrypted(True);
        Result := Node;
        DoNodeChange(Result, xcAddetNode);
      End;

    Function TXMLNodeList.Insert(Node: TXMLNode; Index: Integer): TXMLNode;
      Var NType: TXMLNodeTypes;
        RNode:   TXMLNode;

      Begin
        NType := TXMLFile.GetNTypeMask(_Owner);
        If Index >= 0 Then Begin
          RNode := _FirstNode;
          While Assigned(RNode) do Begin
            If RNode.NodeType in NType Then
              If Index = 0 Then Begin
                Result := Insert(Node, RNode, False);
                Exit;
              End Else Dec(Index);
            RNode := RNode.InnerNext;
          End;
          Result := Insert(Node, nil, False);
        End Else Result := Insert(Node, nil, True);
      End;

    Function TXMLNodeList.Insert(Name: TWideString; Index: Integer; NodeType: TXMLNodeType = xtElement): TXMLNode;
      Var i:  Integer;
        Node: TXMLNode;
        Attr: TXMLAttributeArray;
        W:    LongWord;

      Begin
        If ParseNodePath(Self, Name, [xpDoCreate]) Then Begin
          SplittNodeName(W, Name, Attr, i, 'Insert');
          If i >= 0 Then Raise EXMLException.Create(ClassType, 'Insert',
            @SIndexNotAllowed, [EXMLException.Str(Name), i]);
          If not (NodeType in [xtInstruction..xtUnknown])
              //or ((NodeType = xtInstruction) and not TXHelper.CheckString(Name, xtInstruction_NodeName))
              //or ((NodeType = xtTypedef)     and not TXHelper.CheckString(Name, xtTypedef_NodeName))
              //or ((NodeType = xtElement)     and not TXHelper.CheckString(Name, xtElement_NodeName))
              {}or ((NodeType <= xtElement)    and not TXHelper.CheckString(Name, xtElement_NodeName))
              //or ((NodeType in [xtCData..xtUnknown]) and (Name <> '')) Then
              {}or ((NodeType >= xtCData) and (Name <> '')) Then
            Raise EXMLException.Create(ClassType, 'Add', @SInvalidName, Name);
          Node := TXMLNode.Create(nil, NodeType, Name);
          Try
            For i := 0 to High(Attr) do Node.Attributes.Add(Attr[i].Name, Attr[i].Value);
            Result := Insert(Node, Index);
          Except
            Node.Free;
            Raise;
          End;
        End Else Raise EXMLException.Create(ClassType, 'Insert', @SMissingPath, Name);
      End;

    Function TXMLNodeList.Remove(Node: TXMLNode): TXMLNode;
      Begin
        If Assigned(Node) and (Node.ParentList = Self) Then Begin
          If _FirstNode = Node Then _FirstNode := Node.InnerNext;
          If _LastNode  = Node Then _LastNode  := Node.InnerPrev;
          If Assigned(Node.InnerPrev) Then Node.InnerPrev.InnerNext := Node.InnerNext;
          If Assigned(Node.InnerNext) Then Node.InnerNext.InnerPrev := Node.InnerPrev;
          Node.SetOwner(nil);
          Node.SetParent(nil);
          Node.InnerPrev := nil;
          Node.InnerNext := nil;
          Result         := Node;
          Node.CheckCrypted(True);
        End Else Result := nil;
      End;

    Function TXMLNodeList.Remove(Name: TWideString): TXMLNode;
      Begin
        If not ParseNodePath(Self, Name, [xpNotCreate]) Then Begin
          Result := NodeU[Name];
          If Assigned(Result) Then Result := Remove(Result);
        End Else Result := nil;
      End;

    Function TXMLNodeList.Remove(Index: Integer): TXMLNode;
      Begin
        Result := Node[Index];
        If Assigned(Result) Then Result := Remove(Result);
      End;

    Procedure TXMLNodeList.Delete(Node: TXMLNode);
      Begin
        If not Assigned(Node) Then Raise EXMLException.Create(ClassType, 'Delete', @SMissingNode);
        Node := Remove(Node);
        If not Assigned(Node) Then Raise EXMLException.Create(ClassType, 'Delete', @SInvalidNode);
        Node.Free;
      End;

    Procedure TXMLNodeList.Delete(Name: TWideString);
      Begin
        If not ParseNodePath(Self, Name, [xpNotCreate]) Then
          Raise EXMLException.Create(ClassType, 'Delete', @SMissingPath, Name);
        Delete(NodeU[Name]);
      End;

    Procedure TXMLNodeList.Delete(Index: Integer);
      Begin
        Delete(Node[Index]);
      End;

    Procedure TXMLNodeList.Clear;
      Var Node: TXMLNode;

      Begin
        If Assigned(_FirstNode) Then
          Try
            Repeat
              Node       := _FirstNode;
              _FirstNode := _FirstNode.InnerNext;
              Node.Free;
            Until not Assigned(_FirstNode);
          Finally
            If Assigned(_FirstNode) Then _FirstNode.InnerPrev := nil Else _LastNode := nil;
            _NodesCount := 0;
            Node := FirstNodeNF;
            While Assigned(Node) do Begin
              Inc(_NodesCount);
              Node := Node.NextNodeNF;
            End;
          End;
      End;

    Function TXMLNodeList.IndexOf(Node: TXMLNode): Integer;
      Var NType: TXMLNodeTypes;

      Begin
        Result := -1;
        NType  := TXMLFile.GetNTypeMask(_Owner);
        If (Node is TXMLNode) and (Node.ParentList = Self) and (Node.NodeType in NType) Then
          While Assigned(Node) do Begin
            If Node.NodeType in NType Then Inc(Result);
            Node := Node.InnerPrev;
          End;
      End;

    Function TXMLNodeList.IndexOf(Name: TWideString): Integer;
      Var NType:  TXMLNodeTypes;
        NameHash: LongWord;
        Attr:     TXMLAttributeArray;
        Index:    Integer;
        Node:     TXMLNode;

      Begin
        SplittNodeName(NameHash, Name, Attr, Index, 'IndexOf');
        NType  := TXMLFile.GetNTypeMask(_Owner);
        Node   := FirstNodeNF;
        Result := 0;
        While Assigned(Node) do Begin
          If CompareNode(Node, NType, NameHash, Name, Attr) Then
            If Index <= 0 Then Exit Else Dec(Index);
          If Node.NodeType in NType Then Inc(Result);
          Node := Node.NextNodeNF;
        End;
        Result := -1;
      End;

    Function TXMLNodeList.Exists(Name: TWideString): Boolean;
      Begin
        If ParseNodePath(Self, Name, [xpNotCreate]) Then Begin
          If (Name <> '') and (Name[1] = '#') Then
            Result := Assigned(FindNode[Copy(Name, 2, Length(Name))])
          Else Result := IndexOf(Name) >= 0;
        End Else Result := False;
      End;

    Function TXMLNodeList.CloneNode(Node: TXMLNode): TXMLNode;
      Begin
        If not (Node is TXMLNode) Then
          Raise EXMLException.Create(ClassType, 'CloneNode', @SInvalidNode);
        Result := Add(Node.Name, Node.NodeType);
        Result.Attributes.CloneAttr(Node.Attributes);
        If Node.InnerText <> '' Then
          Result.Text_S := Node.Text_S Else Result.Nodes.CloneNodes(Node.Nodes);
      End;

    Procedure TXMLNodeList.CloneNodes(Nodes: TXMLNodeList);
      Var i: Integer;

      Begin
        For i := 0 to Nodes.CountNF - 1 do
          CloneNode(Nodes.NodeNF[i]);
      End;

    Function TXMLNodeList.NextNodeNF(Node: TXMLNode): TXMLNode;
      {inline}

      Begin
        If Assigned(Node) Then Result := Node.NextNodeNF Else Result := nil;
      End;

    Function TXMLNodeList.InsertNF(Node: TXMLNode; Index: Integer): TXMLNode;
      Var RNode: TXMLNode;

      Begin
        If Index >= 0 Then Begin
          RNode := FirstNodeNF;
          While Assigned(RNode) do Begin
            If Index = 0 Then Begin
              Result := Insert(Node, RNode, False);
              Exit;
            End Else Dec(Index);
            RNode := RNode.NextNodeNF;
          End;
          Result := Insert(Node, nil, False);
        End Else Result := Insert(Node, nil, True);
      End;

    Function TXMLNodeList.InsertNF(Name: TWideString; Index: Integer; NodeType: TXMLNodeType = xtElement): TXMLNode;
      Var i:  Integer;
        Node: TXMLNode;
        Attr: TXMLAttributeArray;
        W:    LongWord;

      Begin
        If ParseNodePath(Self, Name, [xpDoCreate, xpNonFilered]) Then Begin
          SplittNodeName(W, Name, Attr, i, 'InsertNF');
          If i >= 0 Then Raise EXMLException.Create(ClassType, 'InsertNF',
            @SIndexNotAllowed, [EXMLException.Str(Name), i]);
          Node := TXMLNode.Create(nil, NodeType, Name);
          Try
            For i := 0 to High(Attr) do Node.Attributes.Add(Attr[i].Name, Attr[i].Value);
            Result := InsertNF(Node, Index);
          Except
            Node.Free;
            Raise;
          End;
        End Else Raise EXMLException.Create(ClassType, 'InsertNF', @SMissingPath, Name);
      End;

    Function TXMLNodeList.RemoveNF(Name: TWideString): TXMLNode;
      Begin
        If not ParseNodePath(Self, Name, [xpNotCreate, xpNonFilered]) Then Result := nil
        Else Result := Remove(NodeNF[Name]);
      End;

    Function TXMLNodeList.RemoveNF(Index: Integer): TXMLNode;
      Begin
        Result := Remove(NodeNF[Index]);
      End;

    Procedure TXMLNodeList.DeleteNF(Name: TWideString);
      Begin
        If not ParseNodePath(Self, Name, [xpNotCreate, xpNonFilered]) Then
          Raise EXMLException.Create(ClassType, 'DeleteNF', @SMissingPath, Name);
        DeleteNF(IndexOf(Name));
      End;

    Procedure TXMLNodeList.DeleteNF(Index: Integer);
      Begin
        If (Index < 0) or (Index >= _NodesCount) Then
          Raise EXMLException.Create(ClassType, 'DeleteNF', @SMissingNode);
        RemoveNF(Index).Free;
      End;

    Function TXMLNodeList.IndexOfNF(Index: Integer): Integer;
      Var Node: TXMLNode;
        NType:  TXMLNodeTypes;

      Begin
        NType  := TXMLFile.GetNTypeMask(_Owner);
        Node   := FirstNodeNF;
        Result := 0;
        While Assigned(Node) do Begin
          If Node.NodeType in NType Then
            If Index = 0 Then Exit Else Dec(Index);
          Inc(Result);
          Node := Node.NextNodeNF;
        End;
        Result := -1;
      End;

    Function TXMLNodeList.IndexOfNF(Node: TXMLNode): Integer;
      Begin
        Result := -1;
        If Assigned(Node) and (Node.ParentList = Self) Then
          Repeat
            Inc(Result);
            Node := Node.InnerPrev;
          Until not Assigned(Node);
      End;

    Function TXMLNodeList.IndexOfNF(Name: TWideString): Integer;
      Var Attr:   TXMLAttributeArray;
        NameHash: LongWord;
        Index:    Integer;
        Node:     TXMLNode;

      Begin
        SplittNodeName(NameHash, Name, Attr, Index, 'IndexOfNF');
        Node   := FirstNodeNF;
        Result := 0;
        While Assigned(Node) do Begin
          If CompareNode(Node, [Low(TXMLNodeType)..High(TXMLNodeType)], NameHash, Name, Attr) Then
            If Index <= 0 Then Exit Else Dec(Index);
          Inc(Result);
          Node := Node.NextNodeNF;
        End;
        Result := -1;
      End;

    Function TXMLNodeList.ExistsNF(Name: TWideString): Boolean;
      Begin
        If ParseNodePath(Self, Name, [xpNotCreate, xpNonFilered]) Then Begin
          If (Name <> '') and (Name[1] = '#') Then
            Result := Assigned(FindNodeNF[Copy(Name, 2, Length(Name))])
          Else Result := IndexOfNF(Name) >= 0;
        End Else Result := False;
      End;

    Function TXMLNodeList.IndexOfCS(Name: TWideString; CaseSensitive: Boolean = False): Integer;
      Var
        NameHash: LongWord;
        Attr:     TXMLAttributeArray;
        Index:    Integer;
        Node:     TXMLNode;

      Begin
        SplittNodeName(NameHash, Name, Attr, Index, 'IndexOfCS');
        Node   := FirstNodeNF;
        Result := 0;
        While Assigned(Node) do Begin
          If CompareNodeCS(Node, NameHash, Name, Attr, CaseSensitive) Then
            If Index <= 0 Then Exit Else Dec(Index);
          If Node.NodeType = xtElement Then Inc(Result);
          Node := Node.NextNodeNF;
        End;
        Result := -1;
      End;

    Function TXMLNodeList.ExistsCS(Name: TWideString; CaseSensitive: Boolean = False): Boolean;
      Begin
        Result := IndexOfCS(Name, CaseSensitive) >= 0;
      End;

    Procedure TXMLNodeList.Assign{NF}(Nodes: TXMLNodeList);
      Begin
        Clear;
        CloneNodes(Nodes);
      End;

    Procedure TXMLNodeList.Sort{NF}(SortProc: TXMLNodeSortProc);
      Var i, i2: Integer;
        B:       Boolean;
        Temp:    TXMLNode;
        Nodes:   Array of TXMLNode;

      Begin
        SetLength(Nodes, _NodesCount);
        Temp := FirstNodeNF;
        For i := 0 to _NodesCount - 1 do Begin
          Nodes[i] := Temp;
          Temp := Temp.NextNodeNF;
        End;
        B := False;
        For i := 0 to _NodesCount - 2 do
          For i2 := i + 1 to _NodesCount - 1 do
            If SortProc(Nodes[i], Nodes[i2]) > 0 Then Begin
              Temp      := Nodes[i];
              Nodes[i]  := Nodes[i2];
              Nodes[i2] := Temp;
              B         := False;
            End;
        If B Then Begin
          _FirstNode := Nodes[0];
          _LastNode  := Nodes[_NodesCount - 1];
          For i := 0 to _NodesCount - 1 do Begin
            If i = 0               Then Nodes[i].InnerPrev := nil Else Nodes[i].InnerPrev := Nodes[i - 1];
            If i = _NodesCount - 1 Then Nodes[i].InnerNext := nil Else Nodes[i].InnerNext := Nodes[i + 1];
          End;
          //If Assigned(_Parent) Then DoNodeChange(_Parent, xcChildNodesChanged);
        End;
      End;

    Class Function TXMLNodeList.ParseNodePath(Var Nodes: TXMLNodeList; Var NodeName: TWideString; PathOptions: TXMLNodePathOptions): Boolean;
      Var B:  Boolean;
        Temp: TXMLNodeList;
        i:    Integer;
        S:    TWideString;
        Node: TXMLNode;

      Begin
        Temp := Nodes;
        B    := True;
        Repeat
          i := TXHelper.Pos(TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.PathDelimiter, NodeName);
          If i > 0 Then Begin
            S := Copy(NodeName, 1, i - 1);
            System.Delete(NodeName, 1, i);
            If B and (S = '') Then Begin
              While Assigned(Temp) do
                If not Assigned(Temp.Parent) Then Temp := nil
                Else Temp := Temp.Parent.ParentList;
            End Else If S = '..' Then Begin
              If not Assigned(Temp.Parent) Then Temp := nil
              Else Temp := Temp.Parent.ParentList;
            End Else If S <> '.' Then
              If xpNotCreate in PathOptions Then Begin
                If xpNonFilered in PathOptions Then Begin
                  If Temp.ExistsNF(S) Then Node := Temp.NodeNF[S] Else Node := nil;
                End Else
                  If Temp.Exists(S)   Then Node := Temp.Node[S]   Else Node := nil;
                If Assigned(Node) Then Temp := Node.Nodes Else Temp := nil;
              End Else If xpDoCreate in PathOptions Then Begin
                If xpNonFilered in PathOptions Then Node := Temp.NodeNF[S] Else Node := Temp.Node[S];
                If Assigned(Node) Then Temp := Node.Nodes
                Else Temp := Temp.Add(S).Nodes;
              End Else Begin
                If xpNonFilered in PathOptions Then Node := Temp.NodeNF[S] Else Node := Temp.Node[S];
                If Assigned(Node) Then Temp := Node.Nodes Else Temp := nil;
              End;
          End;
          B := False;
        Until (i <= 0) or not Assigned(Temp);
        Result := Assigned(Temp);
        If Result Then Nodes := Temp Else NodeName := S;
      End;

    Class Procedure TXMLNodeList.SplittNodeName(Out NodeNameHash: LongWord; Var NodeName: TWideString;
        Var Attributes: TXMLAttributeArray; Out Index: Integer; Const FunctionsName: String);

      Var i, i2: Integer;
        S:       TWideString;

      Begin
        Attributes := nil;

        i := TXHelper.Pos('[', NodeName);
        If i > 0 Then Begin
          If NodeName[Length(NodeName)] = ']' Then Begin
            S := Copy(NodeName, i + 1, Length(NodeName) - i - 1);
            Index := StrToIntDef(S, -1);
            If Index < 0 Then Raise EXMLException.Create(Self, FunctionsName, @SInvalidIndex, NodeName);
            System.Delete(NodeName, i, Length(NodeName));
          End Else Raise EXMLException.Create(Self, FunctionsName, @SCorruptedIndex, NodeName);
        End Else Index := -1;

        i := TXHelper.Pos('>', NodeName);
        If i > 0 Then Begin
          S := Copy(NodeName, i + 1, Length(NodeName));
          System.Delete(NodeName, i, Length(NodeName));
          While S <> '' do Begin
            i := TXHelper.Pos('>', S);
            If i <= 0 Then i := Length(S) + 1;

            i2 := Length(Attributes);
            SetLength(Attributes, i2 + 1);
            Attributes[i2].Name := Copy(S, 1, i - 1);
            System.Delete(S, 1, i);

            i := TXHelper.Pos('=', Attributes[i2].Name);
            If i > 0 Then Begin
              Attributes[i2].Value := Copy(Attributes[i2].Name, i + 1, Length(Attributes[i2].Name));
              System.Delete(Attributes[i2].Name, i, Length(Attributes[i2].Name));
            End Else Attributes[i2].Value := '';

            Attributes[i2].NameHash := TXHelper.CalcHash(Attributes[i2].Name);
          End;
        End;

        NodeNameHash := TXHelper.CalcHash(NodeName);
      End;

    Class Function TXMLNodeList.CompareNode(Node: TXMLNode; NType: TXMLNodeTypes; NodeNameHash: LongWord;
        Const NodeName: TWideString; Const Attributes: TXMLAttributeArray): Boolean;
      {inline}

      Var i: Integer;

      Begin
        Result := (Node.NodeType in NType) and (((NodeName = '') and (Attributes <> nil))
          or (TXHelper.CompareHash(NodeNameHash, Node.InnerNameHash)
            and TXHelper.MatchText(NodeName, Node.Name, Node.Owner)));
        If Result Then
          For i := 0 to High(Attributes) do
            Result := Result and TXHelper.MatchText(Attributes[i].Value, Node.Attributes[Attributes[i].Name], Node.Owner);
      End;

    Class Function TXMLNodeList.CompareNodeCS(Node: TXMLNode; NodeNameHash: LongWord; Const NodeName: TWideString;
        Const Attributes: TXMLAttributeArray; CaseSensitive: Boolean = False): Boolean;
      {inline}

      Var i: Integer;

      Begin
        Result := (Node.NodeType = xtElement) and (((NodeName = '') and (Attributes <> nil))
          or (TXHelper.CompareHash(NodeNameHash, Node.InnerNameHash)
            and TXHelper.MatchText(NodeName, Node.Name, CaseSensitive)));
        If Result Then
          For i := 0 to High(Attributes) do
            Result := Result and TXHelper.MatchText(Attributes[i].Value, Node.Attributes[Attributes[i].Name], CaseSensitive);
      End;

    Procedure TXMLNodeList.SetOwner(NewOwner: TXMLFile);
      Var Node: TXMLNode;

      Begin
        _Owner := NewOwner;
        Node   := FirstNodeNF;
        While Assigned(Node) do Begin
          Node.SetOwner(NewOwner);
          Node := Node.NextNodeNF;
        End;
      End;

    Procedure TXMLNodeList.DoNodeChange(Node: TXMLNode; CType: TXMLNodeChangeType);
      {inline}

      Begin
        If Assigned(_Owner) Then _Owner.DoNodeChange(Node, CType);
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TXMLNode'}{$IFEND}

    Function TXMLNode.GetParent: TXMLNode;
      Begin
        If Assigned(_Parent) Then Result := _Parent.Parent Else Result := nil;
      End;

    Function TXMLNode.GetNFIndex: Integer;
      Begin
        If not Assigned(_Parent) Then Result := -1
        Else Result := _Parent.IndexOfNF(Self);
      End;

    Function TXMLNode.GetIndex: Integer;
      Begin
        If not Assigned(_Parent) Then Result := -1
        Else Result := _Parent.IndexOf(Self);
      End;

    Function TXMLNode.GetLevel: Integer;
      Var Node: TXMLNode;

      Begin
        Result := -1;
        Node   := Self;
        While Assigned(Node) do Begin
          Inc(Result);
          Node := Node.Parent;
        End;
      End;

    Function TXMLNode.GetFullPath: TWideString;
      Var List: TXMLNodeList;

      Begin
        Result := _Name;
        List   := _Parent;
        While Assigned(List) and Assigned(List.Parent) do Begin
          Result := List.Parent.Name + TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.PathDelimiter + Result;
          List   := List.Parent.ParentList;
        End;
        Delete(Result, Length(Result), 1);
      End;

    Procedure TXMLNode.SetName(Const Value: TWideString);
      Begin
        If ((_NodeType <= xtElement) and not TXHelper.CheckString(Value, xtElement_NodeName))
            or ((_NodeType >= xtCData) and (Value <> '')) Then
          Raise EXMLException.Create(ClassType, 'Name', @SInvalidValue, Value);
        _Name     := Value;
        _NameHash := TXHelper.CalcHash(Value);
        DoNodeChange(xcNameChanged);
      End;

    Function TXMLNode.GetNamespace: TWideString;
      Begin
        Result := Copy(_Name, 1, TXHelper.Pos(':', _Name) - 1);
      End;

    Procedure TXMLNode.SetNamespace(Const Value: TWideString);
      Begin
        If not TXHelper.CheckString(Value, xtElement_NodeName)
            or (TXHelper.Pos(':', Value) > 0) or ((_NodeType >= xtCData) and (Value <> '')) Then
          Raise EXMLException.Create(ClassType, 'Namespace', @SInvalidValue, Value);
        If Value = '' Then _Name := NameOnly
        Else _Name := Value + ':' + NameOnly;
        _NameHash := TXHelper.CalcHash(_Name);
      End;

    Function TXMLNode.GetNameOnly: TWideString;
      Begin
        Result := Copy(_Name, TXHelper.Pos(':', _Name) + 1, Length(_Name));
      End;

    Procedure TXMLNode.SetNameOnly(Const Value: TWideString);
      Var S: TWideString;

      Begin
        If not TXHelper.CheckString(Value, xtElement_NodeName)
            or (TXHelper.Pos(':', Value) > 0) or ((_NodeType >= xtCData) and (Value <> '')) Then
          Raise EXMLException.Create(ClassType, 'NameOnly', @SInvalidValue, Value);
        S := Namespace;
        If S = '' Then _Name := Value
        Else _Name := S + ':' + Value;
        _NameHash := TXHelper.CalcHash(_Name);
      End;

    Procedure TXMLNode.AssignAttributes(Value: TXMLAttributes);
      Begin
        _Attributes.Assign(Value);
      End;

    Function TXMLNode.GetText: Variant;
      Begin
        TXHelper.XMLToVariant(Text_S, Result);
      End;

    Procedure TXMLNode.SetText(Const Value: Variant);
      Begin
        Try
          Text_S := TXHelper.VariantToXML(Value);
        Except
          Raise EXMLException.Create(ClassType, 'Text', @SInvalidValueN, [], Exception(ExceptObject));
        End;
      End;

    Function TXMLNode.GetTextS: TWideString;
      Var S:   TWideString;
        CProc: TXMLEncryptionProc;

      Begin
        If isTextNode Then Begin
          If not Assigned(_Nodes.FirstNodeNF) Then Begin
            Result := _Text;
            Case _NodeType of
              //xtInstruction: ;
              xtTypedef: TXHelper.ConvertString(Result, xtTypedef_GetText, _Owner);
              xtUnknown,
              xtElement: TXHelper.ConvertString(Result, xtElement_GetText, _Owner);
              xtCData:   TXHelper.ConvertString(Result, xtCData_GetText,   _Owner);
              xtComment: TXHelper.ConvertString(Result, xtComment_GetText, _Owner);
            End;
          End Else Result := _Nodes.FirstNodeNF.Text_S;
          If _isCrypted Then Begin
            S     := Crypt;
            CProc := _Owner.CryptProc[S];
            If Assigned(CProc) Then CProc(Result, _Owner.CryptData[S], True, _Attributes)
            Else Raise EXMLException.Create(ClassType, 'Text', @SNotImplemented, S);
          End;
        End Else Result := '';
      End;

    Procedure TXMLNode.SetTextS(Value: TWideString);
      Var B:   Boolean;
        S:     TWideString;
        CProc: TXMLEncryptionProc;

      Begin
        If isTextNode Then Begin
          If _isCrypted Then Begin
            S     := Crypt;
            CProc := _Owner.CryptProc[S];
            If Assigned(CProc) Then CProc(Value, _Owner.CryptData[S], False, _Attributes)
            Else Raise EXMLException.Create(ClassType, 'Text', @SNotImplemented, S);
          End;
          If not Assigned(_Nodes.FirstNodeNF) Then Begin
            Case _NodeType of
              //xtInstruction: ;
              xtTypedef: B := TXHelper.ConvertString(Value, xtTypedef_SetText, _Owner);
              xtUnknown,
              xtElement: B := TXHelper.ConvertString(Value, xtElement_SetText, _Owner);
              xtCData:   B := TXHelper.ConvertString(Value, xtCData_SetText,   _Owner);
              xtComment: B := TXHelper.ConvertString(Value, xtComment_SetText, _Owner);
              Else       Raise EXMLException.Create(ClassType, 'Text', @SInternalError, 1);
            End;
            If B Then Begin
              _Text := Value;
              DoNodeChange(xcTextChanged);
            End Else Raise EXMLException.Create(ClassType, 'Text', @SInvalidValue, Value);
          End Else _Nodes.FirstNodeNF.Text_S := Value;
        End Else Raise EXMLException.Create(ClassType, 'Text', @SNoNodeText, _Name);
      End;

    Function TXMLNode.GetTextD: TWideString;
      Begin
        Result := GetTextS;
      End;

    Procedure TXMLNode.SetTextD(Const Value: TWideString);
      Var Temp: TWideString;

      Begin
        If isTextNode Then Begin
          If not hasCDATA Then Begin
            Try
              SetTextS(Value);
            Except
              Temp := GetTextS;
              Try
                SetTextS('');
                asCDATA(True);
                SetTextS(Value);
              Except
                Nodes.Clear;
                SetTextS(Temp);
                Raise;
              End;
            End;
          End Else SetTextS(Value);
        End Else Raise EXMLException.Create(ClassType, 'Text', @SNoNodeText, _Name);
      End;

    Function TXMLNode.GetBASE64: AnsiString;
      Begin
        SetLength(Result, GetBinaryLen);
        GetBinaryData(Pointer(Result), Length(Result));
      End;

    Procedure TXMLNode.SetBASE64(Const Value: AnsiString);
      Begin
        SetBinaryData(Pointer(Value), Length(Value));
      End;

    Function TXMLNode.GetBASE64w: TWideString;
      Var i: Integer;

      Begin
        i := GetBinaryLen;
        SetLength(Result, (i + 1) div 2);
        If i and $1 <> 0 Then PWideChar(Result)[Length(Result) - 1] := #0;
        GetBinaryData(Pointer(Result), Length(Result) * 2);
      End;

    Procedure TXMLNode.SetBASE64w(Const Value: TWideString);
      Begin
        SetBinaryData(Pointer(Value), Length(Value) * 2);
      End;

    {$IFNDEF hxExcludeClassesUnit}

      Function TXMLNode.GetXMLText: TWideString;
        Var Stream: TStream;
          Writer:   TXWriter;

        Begin
          Try
            Stream := TMemoryStream.Create;
            Try
              If Assigned(_Owner) Then
                Writer := TXWriter.Create(Stream, _Owner.Options + [xo_IgnoreEncoding],
                  _Owner.LineFeed, _Owner.TextIndent, _Owner.ValueSeperator, _Owner.ValueQuotation)
              Else
                Writer := TXWriter.Create(Stream, TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultOptions + [xo_IgnoreEncoding],
                  TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultLineFeed, TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultTextIndent,
                  TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultValueSeperator, TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultValueQuotation);
              Try
                Writer.SetEnc(xeUnicode);
                TXMLFile.AssembleTree(_Owner, Writer, _Nodes, nil);
              Finally
                Writer.Free;
              End;
              SetLength(Result, Stream.Size div 2);
              Stream.Position := 0;
              Stream.ReadBuffer(PWideChar(Result)^, Length(Result) * 2);
            Finally
              Stream.Free;
            End;
          Except
            Raise EXMLException.Create(ClassType, 'XMLText', @SInternalError, [1], Exception(ExceptObject));
          End;
        End;

      Procedure TXMLNode.SetXMLText(Const Value: TWideString);
        Var S:    String;
          Stream: TStream;
          Reader: TXReader;

        Begin
          Try
            Try
              _Text := '';
              _Nodes.Clear;
              Stream := TMemoryStream.Create;
              Try
                Stream.WriteBuffer(PWideChar(Value)^, Length(Value) * 2);
                Stream.Position := 0;
                Reader := TXReader.Create(Stream, TXMLFile.GetOptions(_Owner) + [xo_IgnoreEncoding], xeUnicode);
                Try
                  TXMLFile.ParsingTree(_Owner, Reader, _Nodes, nil);
                Finally
                  Reader.Free;
                End;
                If (_Nodes.Count = 1) and (_Nodes[0].NodeType = xtUnknown) Then Begin
                  S := _Nodes[0].Text_S;
                  _Nodes.Clear;
                  Text_S := S;
                End;
              Finally
                Stream.Free;
              End;
            Finally
              DoNodeChange(xcTextChanged);
            End;
          Except
            Raise EXMLException.Create(ClassType, 'XMLText', @SInvalidValue,
              [EXMLException.Str(Value)], Exception(ExceptObject));
          End;
        End;

    {$ENDIF}

    Function TXMLNode.GetCrypt: TWideString;
      Begin
        If Assigned(_Owner) Then Result := _Attributes[_Owner.CryptAttrName]
        Else Raise EXMLException.Create(ClassType, 'Crypt', @SOwnerRequired);
      End;

    Procedure TXMLNode.SetCrypt(CName: TWideString);
      Var C: TXMLCryptorArray;
        i:   Integer;

      Begin
        If Assigned(_Owner) Then Begin
          If isTextNode Then Begin
            C := _Owner.InnerCryptors;
            If (CName = '*') and Assigned(C) Then CName := C[0].Name;
            For i := High(C) downto 0 do
              If TXHelper.SameTextW(C[i].Name, CName, _Owner) Then Begin
                Recrypt(_Owner.CryptProc[Crypt], _Owner.CryptData[Crypt], C[i].Proc, C[i].Data);
                _Attributes[_Owner.CryptAttrName] := C[i].Name;
                Exit;
              End;
            Raise EXMLException.Create(ClassType, 'Crypt', @SInvalidName, CName);
          End Else Raise EXMLException.Create(ClassType, 'Crypt', @SNoNodeText, _Name);
        End Else Raise EXMLException.Create(ClassType, 'Crypt', @SOwnerRequired);
      End;

    Procedure TXMLNode.AssignNodes(Nodes: TXMLNodeList);
      Begin
        _Nodes.Assign(Nodes);
      End;

    Function TXMLNode.GetAttribute(Const Name: TWideString): Variant;
      Begin
        Result := _Attributes.Value[Name];
      End;

    Procedure TXMLNode.SetAttribute(Const Name: TWideString; Const Value: Variant);
      Begin
        _Attributes.Value[Name] := Value;
      End;

    Function TXMLNode.GetNode(Const Name: TWideString): TXMLNode;
      Begin
        Result := _Nodes.Node[Name];
      End;

    Function TXMLNode.GetNFNode(Const Name: TWideString): TXMLNode;
      Begin
        Result := _Nodes.NodeNF[Name];
      End;

    Function TXMLNode.GetNodeArray(Const Name: TWideString): TXMLNodeArray;
      Begin
        Result := _Nodes.NodeList[Name];
      End;

    Function TXMLNode.GetNFNodeArray(Const Name: TWideString): TXMLNodeArray;
      Begin
        Result := _Nodes.NodeListNF[Name];
      End;

    Function TXMLNode.GetFindNode(Const Name: TWideString): TXMLNode;
      Begin
        Result := _Nodes.FindNode[Name];
      End;

    Function TXMLNode.GetNFFindNode(Const Name: TWideString): TXMLNode;
      Begin
        Result := _Nodes.FindNodeNF[Name];
      End;

    Function TXMLNode.GetFindNodeArray(Const Name: TWideString): TXMLNodeArray;
      Begin
        Result := _Nodes.FindNodes[Name];
      End;

    Function TXMLNode.GetNFFindNodeArray(Const Name: TWideString): TXMLNodeArray;
      Begin
        Result := _Nodes.FindNodesNF[Name];
      End;

    Function TXMLNode.GetNextNode: TXMLNode;
      Var NType: TXMLNodeTypes;

      Begin
        NType  := TXMLFile.GetNTypeMask(_Owner);
        Result := _Next;
        While Assigned(Result) do Begin
          If Result._NodeType in NType Then Exit;
          Result := Result._Next;
        End;
      End;

    Constructor TXMLNode.Create(ParentOrOwner: TObject{TXMLNodeList, TXMLFile};
        NodeType: TXMLNodeType = xtElement; Const NodeName: TWideString = '');

      Begin
        Inherited Create;
        If ParentOrOwner is TXMLNodeList Then Begin
          _Owner    := TXMLNodeList(ParentOrOwner).Owner;
          _Parent   := TXMLNodeList(ParentOrOwner);
        End Else If (ParentOrOwner is TXMLFile) or not Assigned(ParentOrOwner) Then Begin
          _Owner    := TXMLFile(ParentOrOwner);
          //_Parent := nil;
        End Else Raise EXMLException.Create(ClassType, 'Create', @SInvalidParent2);
        _NodeType   := NodeType;
        If NodeName <> '' Then Begin
          If //((_NodeType = xtInstruction)   and not TXHelper.CheckString(NodeName, xtInstruction_NodeName))
              //or ((_NodeType = xtTypedef)   and not TXHelper.CheckString(NodeName, xtTypedef_NodeName))
              //or ((_NodeType = xtElement)   and not TXHelper.CheckString(NodeName, xtElement_NodeName))
              {}   ((_NodeType <= xtElement)  and not TXHelper.CheckString(NodeName, xtElement_NodeName))
              //or (_NodeType in [xtCData..xtUnknown]) Then
              {}or (_NodeType > xtCData) Then
            Raise EXMLException.Create(ClassType, 'Create', @SInvalidName, NodeName);
          _Name     := NodeName;
        End Else If _NodeType <= xtElement Then
          _Name     := 'node'
        {Else _Name := ''};
        _NameHash   := TXHelper.CalcHash(_Name);
        _Attributes := TXMLAttributes.Create(Self);
        //_Data     := '';
        _Nodes      := TXMLNodeList.Create(Self);
      End;

    Destructor TXMLNode.Destroy;
      Begin
        _Text := '';
        _Attributes.Free;
        _Nodes.Free;
        DoNodeChange(xcTextChanged);
        Inherited;
      End;

    Function TXMLNode.GetBinaryLen: Integer;
      Var P:   PWideChar;
        i, i2: Integer;

      Begin
        If hasCDATA Then Self := _Nodes.FirstNodeNF;

        P := PWideChar(_Text);
        i := Length(_Text);
        For i2 := i - 1 downto 0 do Begin
          If P^ < ' ' Then Dec(i);
          Inc(P);
        End;
        Result := i div 4 * 3;
        If (_Text <> '') and (P[-1] = '=') Then Begin
          Dec(Result);
          If (Length(_Text) >= 2) and (P[-2] = '=') Then Dec(Result);
        End;
      End;

    Function TXMLNode.GetBinaryData(Buffer: Pointer; BufferSize: Integer): Integer;
      Type TByteArray = Array[0..2] of Byte;

      Var Base: Array[$00..$7F] of Byte;
        i, i2:  Integer;
        Pb:     ^TByteArray absolute Buffer;
        Ps:     PWideChar;
        D:      Array[0..3] of Byte;

      Begin
        If hasCDATA Then Self := _Nodes.FirstNodeNF;

        FillMemory(@Base, SizeOf(Base), $FF);
        For i :=  0 to 25 do Base[Ord('A') + i]    := i;
        For i := 26 to 51 do Base[Ord('a') + i-26] := i;
        For i := 52 to 61 do Base[Ord('0') + i-52] := i;
        Base[Ord('+')] := 62;
        Base[Ord('/')] := 63;
        Base[Ord('=')] := 88;

        Result := 0;
        i      := Length(_Text);
        Ps     := Pointer(_Text);
        While True do Begin
          PLongWord(@D)^ := $FFFFFFFF;
          i2 := 0;
          While (i > 0) and (i2 < 4) do Begin
            If Ps^ > ' ' Then Begin
              If Ps^ <= #$007F Then D[i2] := Base[Byte(Ps^)];
              Inc(i2);
            End;
            Inc(Ps);
            Dec(i);
          End;
          If i2 = 0 Then Break;
          If (D[0] <= 63) and (D[1] <= 63) and (D[2] = 88) and (D[3] = 88) Then Begin
            Dec(BufferSize, 1);
            If BufferSize >= 0 Then Begin
              Pb[0] := D[0] shl 2 or D[1] shr 4;
              Inc(Result, 1);
            End;
            Break;
          End Else If (D[0] <= 63) and (D[1] <= 63) and (D[2] <= 63) and (D[3] = 88) Then Begin
            Dec(BufferSize, 2);
            If BufferSize >= 0 Then Begin
              Pb[0] := D[0] shl 2 or D[1] shr 4;
              Pb[1] := D[1] shl 4 or D[2] shr 2;
              Inc(Result, 2);
            End;
            Break;
          End Else If (D[0] <= 63) and (D[1] <= 63) and (D[2] <= 63) and (D[3] <= 63) Then Begin
            Dec(BufferSize, 3);
            If BufferSize >= 0 Then Begin
              Pb[0] := D[0] shl 2 or D[1] shr 4;
              Pb[1] := D[1] shl 4 or D[2] shr 2;
              Pb[2] := D[2] shl 6 or D[3];
              Inc(Result, 3);
              Inc(Pb);
            End Else Break;
          End Else Break;
        End;
        If BufferSize < 0 Then Raise EXMLException.Create(ClassType, 'Base64', @SSmallBuffer)
        Else If i > 0 Then Raise EXMLException.Create(ClassType, 'Base64',
          @SCorupptedBase64, [Copy(_Text, Length(_Text) - i, 20)]);
      End;

    Procedure TXMLNode.SetBinaryData(Buffer: Pointer; BufferSize: Integer);
      Type TByteArray = Array[0..2] of Byte;

      Var i:  Integer;
        Base: Array[0..63] of WideChar;
        Pv:   ^TByteArray absolute Buffer;
        Ps:   PWideChar;

      Begin
        If hasCDATA Then Self := _Nodes.FirstNodeNF;

        If not isTextNode Then
          Raise EXMLException.Create(ClassType, 'Base64', @SNoNodeText, _Name);
        If not (_NodeType in [xtTypedef, xtElement, xtCData, xtComment, xtUnknown]) Then
          Raise EXMLException.Create(ClassType, 'Base64', @SInternalError, 1);

        For i :=  0 to 25 do Base[i] := WideChar(Ord('A') + i);
        For i := 26 to 51 do Base[i] := WideChar(Ord('a') + i-26);
        For i := 52 to 61 do Base[i] := WideChar(Ord('0') + i-52);
        Base[62] := '+';
        Base[63] := '/';

        SetLength(_Text, ((BufferSize + 2) div 3 * 4) + ((BufferSize - 1) div (3*200)));
        Try
          Ps := PWideChar(_Text);
          For i := 1 to BufferSize div 3 do Begin
            Ps^ := Base[ Pv[0] shr 2];                          Inc(Ps);
            Ps^ := Base[(Pv[0] shl 4 or Pv[1] shr 4) and $3F];  Inc(Ps);
            Ps^ := Base[(Pv[1] shl 2 or Pv[2] shr 6) and $3F];  Inc(Ps);
            Ps^ := Base[ Pv[2]                       and $3F];  Inc(Ps);
            Inc(Pv);
            If i mod 200 = 0 Then Begin  Ps^ := #$0A;  Inc(Ps);  End;
          End;
          Case BufferSize mod 3 of
            1: Begin
              Ps^ := Base[ Pv[0] shr 2];           Inc(Ps);
              Ps^ := Base[(Pv[0] shl 4) and $3F];  Inc(Ps);
              Ps^ := '=';                          Inc(Ps);
              Ps^ := '=';
            End;
            2: Begin
              Ps^ := Base[ Pv[0] shr 2];                          Inc(Ps);
              Ps^ := Base[(Pv[0] shl 4 or Pv[1] shr 4) and $3F];  Inc(Ps);
              Ps^ := Base[(Pv[1] shl 2)                and $3F];  Inc(Ps);
              Ps^ := '=';
            End;
          End;
        Except
          _Text := '';
          Raise;
        End;
        DoNodeChange(xcTextChanged);
      End;

    Function TXMLNode.GetBinaryData(Stream: TStream): Integer;
      Var Base: Array[$00..$7F] of Byte;
        i, i2:  Integer;
        Ps:     PWideChar;
        D:      Array[0..3] of Byte;
        Buffer: Array[0..2] of Byte;

      Begin
        If hasCDATA Then Self := _Nodes.FirstNodeNF;

        FillMemory(@Base, SizeOf(Base), $FF);
        For i :=  0 to 25 do Base[Ord('A') + i]    := i;
        For i := 26 to 51 do Base[Ord('a') + i-26] := i;
        For i := 52 to 61 do Base[Ord('0') + i-52] := i;
        Base[Ord('+')] := 62;
        Base[Ord('/')] := 63;
        Base[Ord('=')] := 88;

        Result := 0;
        i      := Length(_Text);
        Ps     := Pointer(_Text);
        While True do Begin
          PLongWord(@D)^ := $FFFFFFFF;
          i2 := 0;
          While (i > 0) and (i2 < 4) do Begin
            If Ps^ > ' ' Then Begin
              If Ps^ <= #$007F Then D[i2] := Base[Byte(Ps^)];
              Inc(i2);
            End;
            Inc(Ps);
            Dec(i);
          End;
          If i2 = 0 Then Break;
          If (D[0] <= 63) and (D[1] <= 63) and (D[2] = 88) and (D[3] = 88) Then Begin
            Buffer[0] := D[0] shl 2 or D[1] shr 4;
            Stream.WriteBuffer(Buffer, 1);
            Inc(Result, 1);
            Break;
          End Else If (D[0] <= 63) and (D[1] <= 63) and (D[2] <= 63) and (D[3] = 88) Then Begin
            Buffer[0] := D[0] shl 2 or D[1] shr 4;
            Buffer[1] := D[1] shl 4 or D[2] shr 2;
            Stream.WriteBuffer(Buffer, 2);
            Inc(Result, 2);
            Break;
          End Else If (D[0] <= 63) and (D[1] <= 63) and (D[2] <= 63) and (D[3] <= 63) Then Begin
            Buffer[0] := D[0] shl 2 or D[1] shr 4;
            Buffer[1] := D[1] shl 4 or D[2] shr 2;
            Buffer[2] := D[2] shl 6 or D[3];
            Stream.WriteBuffer(Buffer, 3);
            Inc(Result, 3);
          End Else Break;
        End;
        If i > 0 Then Raise EXMLException.Create(ClassType, 'Base64',
          @SCorupptedBase64, [Copy(_Text, Length(_Text) - i, 20)]);
      End;

    Procedure TXMLNode.SetBinaryData(Stream: TStream; MaxBytes: Integer = MaxInt);
      Var i:    Integer;
        Base:   Array[0..63] of WideChar;
        Ps:     PWideChar;
        Buffer: Array[0..2] of Byte;

      Begin
        If hasCDATA Then Self := _Nodes.FirstNodeNF;

        If not isTextNode Then
          Raise EXMLException.Create(ClassType, 'Base64', @SNoNodeText, _Name);
        If not (_NodeType in [xtTypedef, xtElement, xtCData, xtComment, xtUnknown]) Then
          Raise EXMLException.Create(ClassType, 'Base64', @SInternalError, 1);

        For i :=  0 to 25 do Base[i] := WideChar(Ord('A') + i);
        For i := 26 to 51 do Base[i] := WideChar(Ord('a') + i-26);
        For i := 52 to 61 do Base[i] := WideChar(Ord('0') + i-52);
        Base[62] := '+';
        Base[63] := '/';

        If Stream.Size > MaxInt div 2 Then OutOfMemoryError;
        If Stream.Size < MaxBytes Then MaxBytes := Stream.Size;
        SetLength(_Text, ((MaxBytes + 2) div 3 * 4) + ((MaxBytes - 1) div (3*200)));
        Try
          Ps := PWideChar(_Text);
          For i := 1 to MaxBytes div 3 do Begin
            Stream.ReadBuffer(Buffer, 3);
            Ps^ := Base[ Buffer[0] shr 2];                              Inc(Ps);
            Ps^ := Base[(Buffer[0] shl 4 or Buffer[1] shr 4) and $3F];  Inc(Ps);
            Ps^ := Base[(Buffer[1] shl 2 or Buffer[2] shr 6) and $3F];  Inc(Ps);
            Ps^ := Base[ Buffer[2]                           and $3F];  Inc(Ps);
            If i mod 200 = 0 Then Begin  Ps^ := #$0A;  Inc(Ps);  End;
          End;
          Case MaxBytes mod 3 of
            1: Begin
              Stream.ReadBuffer(Buffer, 1);
              Ps^ := Base[ Buffer[0] shr 2];           Inc(Ps);
              Ps^ := Base[(Buffer[0] shl 4) and $3F];  Inc(Ps);
              Ps^ := '=';                              Inc(Ps);
              Ps^ := '=';
            End;
            2: Begin
              Stream.ReadBuffer(Buffer, 2);
              Ps^ := Base[ Buffer[0] shr 2];                              Inc(Ps);
              Ps^ := Base[(Buffer[0] shl 4 or Buffer[1] shr 4) and $3F];  Inc(Ps);
              Ps^ := Base[(Buffer[1] shl 2)                    and $3F];  Inc(Ps);
              Ps^ := '=';
            End;
          End;
        Except
          _Text := '';
          Raise;
        End;
        DoNodeChange(xcTextChanged);
      End;

    Procedure TXMLNode.RemoveSerializedData;
      {inline}

      Begin
        TXHelper.Serialize_RemoveData(Self);
      End;

    Procedure TXMLNode.Serialize(Const V: Variant);
      {inline}

      Begin
        TXHelper.Serialize_RemoveData(Self);
        TXHelper.Serialize_Variant(Self, V);
      End;

    Procedure TXMLNode.DeSerialize(Var V: Variant);
      {inline}

      Begin
        TXHelper.DeSerialize_Variant(Self, V);
      End;

    Procedure TXMLNode.Serialize(C: TObject; SOptions: TXMLSerializeOptions = []; Proc: TXMLSerializeProc = nil);
      {inline}

      Begin
        TXHelper.Serialize_RemoveData(Self);
        TXHelper.Serialize_Object(Self, C, SOptions, Proc);
      End;

    Procedure TXMLNode.DeSerialize(C: TObject; SOptions: TXMLSerializeOptions = []; Proc: TXMLSerializeProc = nil);
      {inline}

      Begin
        TXHelper.DeSerialize_Object(Self, C, SOptions, Proc);
      End;

    Function TXMLNode.Serialize(Const Rec; RecInfo: TXMLSerializeRecordInfo): Integer;
      Begin
        TXHelper.Serialize_RemoveData(Self);
        RecInfo.CheckOffsets;
        If not RecInfo._OffsetsOK Then
          Raise EXMLException.Create(ClassType, 'Serialize', @SInvalidValueS, 'invalid RecInfo');
        TXHelper.Serialize_Record(Self, Rec, RecInfo);
        Result := RecInfo._Size;
      End;

    Function TXMLNode.DeSerialize(Var Rec; RecInfo: TXMLSerializeRecordInfo): Integer;
      Begin
        RecInfo.CheckOffsets;
        If not RecInfo._OffsetsOK Then
          Raise EXMLException.Create(ClassType, 'Serialize', @SInvalidValueS, 'invalid RecInfo');
        TXHelper.DeSerialize_Record(Self, Rec, RecInfo);
        Result := RecInfo._Size;
      End;

    Function TXMLNode.isTextNode: Boolean;
      {inline}

      Begin
        Result := (_Nodes.FirstNodeNF = nil) or hasCDATA;
      End;

    Function TXMLNode.hasCDATA: Boolean;
      {inline}

      Begin
        Result := (_Nodes.CountNF <> 0) and (_Nodes.FirstNodeNF.NodeType = xtCData);
      End;

    Procedure TXMLNode.asCDATA(yes: Boolean);
      Var S:  TWideString;
        Node: TXMLNode;

      Begin
        If not isTextNode or (yes and (_NodeType <> xtElement)) Then
          Raise EXMLException.Create(ClassType, 'asCDATA', @SNoNodeText, _Name);
        If yes <> hasCDATA Then
          If yes Then Begin
            S := Text_S;
            Try
              Text_S := '';
              Node := _Nodes.Add('', xtCData);
              Try
                Node.Text_S := S;
              Except
                _Nodes.Delete(Node);
                Raise;
              End;
            Except
              Text_S := S;
              Raise;
            End;
          End Else
            Try
              S := _Nodes.FirstNodeNF.Text_S;
              Try
                _Nodes.DeleteNF(0);
              Finally
                Text_S := S;
              End;
            Except
              _Nodes.Add('', xtCData).Text_S := S;
              Raise;
            End;
      End;

    Procedure TXMLNode.Recrypt(OldProc: TXMLEncryptionProc; OldData: AnsiString;
        NewProc: TXMLEncryptionProc; NewData: AnsiString);

      Var S: TWideString;
        B:   Boolean;

      Begin
        If isTextNode Then Begin
          If not Assigned(_Nodes.FirstNodeNF) Then Begin
            S := _Text;
            Case _NodeType of
              //xtInstruction: ;
              xtTypedef: TXHelper.ConvertString(S, xtTypedef_GetText, _Owner);
              xtUnknown,
              xtElement: TXHelper.ConvertString(S, xtElement_GetText, _Owner);
              xtCData:   TXHelper.ConvertString(S, xtCData_GetText,   _Owner);
              xtComment: TXHelper.ConvertString(S, xtComment_GetText, _Owner);
            End;
          End Else S := _Nodes.FirstNodeNF.Text_S;
          If Assigned(OldProc) Then OldProc(S, OldData, True,  _Attributes);
          If Assigned(NewProc) Then NewProc(S, NewData, False, _Attributes);
          If not Assigned(_Nodes.FirstNodeNF) Then Begin
            Case _NodeType of
              //xtInstruction: ;
              xtTypedef: B := TXHelper.ConvertString(S, xtTypedef_SetText, _Owner);
              xtUnknown,
              xtElement: B := TXHelper.ConvertString(S, xtElement_SetText, _Owner);
              xtCData:   B := TXHelper.ConvertString(S, xtCData_SetText,   _Owner);
              xtComment: B := TXHelper.ConvertString(S, xtComment_SetText, _Owner);
              Else       Raise EXMLException.Create(ClassType, 'Recrypt', @SInternalError, 1);
            End;
            If B Then Begin
              _Text := S;
              DoNodeChange(xcTextChanged);
            End Else Raise EXMLException.Create(ClassType, 'Recrypt', @SInvalidValue, S);
          End Else _Nodes.FirstNodeNF.Text_S := S;
        End;
      End;

    Function TXMLNode.AddNode(Const Name: TWideString; NodeType: TXMLNodeType = xtElement): TXMLNode;
      Begin
        Result := _Nodes.Add(Name, NodeType);
      End;

    Procedure TXMLNode.DeclareNamespace(Const Prefix, URI: TWideString);
      Var i:  Integer;
        Node: TXMLNode;

      Begin
        If not TXHelper.CheckString(Prefix + ':node', xtAttribute_Name) Then
          Raise EXMLException.Create(ClassType, 'DeclareNamespace', @SInvalidValue, Prefix);
        Node := Self;
        While Assigned(Node) do Begin
          i := Node._Attributes.IndexOf('xmlns:' + Prefix + '|XMLNS:' + Prefix);
          If i >= 0 Then Begin
            Node._Attributes[i] := URI;
            Exit;
          End;
          Node := Node.Parent;
        End;
        Attribute['xmlns:' + Prefix + '|XMLNS:' + Prefix] := URI;
      End;

    Function TXMLNode.FindNamespaceDecl(NamespaceURI: TWideString): TXMLNode;
      Function LowerTrim(Const S: TWideString): TWideString;
        Var i: Integer;

        Begin
          Result := S;
          i := 0;
          UniqueString(Result);
          While (i <= Length(Result)) and (Result[i + 1] <> ':') do Inc(i);
          CharLowerBuffW(PWideChar(Result), i);
          While (Result <> '') and (Result[Length(Result)] = '/') do
            Delete(Result, Length(Result), 1);
        End;

      Var i: Integer;

      Begin
        NamespaceURI := LowerTrim(NamespaceURI);
        Result := Self;
        While Assigned(Result) do Begin
          For i := 0 to Result._Attributes.Count - 1 do
            If TXHelper.MatchText('xmlns:*|XMLNS:*', Result._Attributes.Name[i], _Owner)
                and TXHelper.SameTextW(NamespaceURI, LowerTrim(Result._Attributes.Value[i]), _Owner) Then Exit;
          Result := Result.Parent;
        End;
        Result := nil;
      End;

    Function TXMLNode.FindNamespaceURI(TagOrPrefix: TWideString): TWideString;
      Var i:  Integer;
        Node: TXMLNode;

      Begin
        i := TXHelper.Pos(':', TagOrPrefix);
        If i > 0 Then Delete(TagOrPrefix, i, Length(TagOrPrefix));
        If TXHelper.Pos('|', TagOrPrefix) > 0 Then
          Raise EXMLException.Create(ClassType, 'FindNamespaceURI', @SInvalidValue, TagOrPrefix);
        Node := Self;
        While Assigned(Node) do Begin
          If Node._Attributes.Exists('xmlns:' + TagOrPrefix + '|XMLNS:' + TagOrPrefix) Then Begin
            Result := Node._Attributes['xmlns:' + TagOrPrefix + '|XMLNS:' + TagOrPrefix];
            Exit;
          End;
          Node := Node.Parent;
        End;
        Result := '';
      End;

    Function TXMLNode.NamespaceURI: TWideString;
      {inline}

      Begin
        Result := FindNamespaceURI(Namespace);
      End;

    Procedure TXMLNode.SetOwner(NewOwner: TXMLFile);
      Begin
        _Owner := NewOwner;
        _Attributes.SetOwner(NewOwner);
        _Nodes.SetOwner(NewOwner);
      End;

    Procedure TXMLNode.SetParent(NewParent: TXMLNodeList);
      Begin
        _Parent := NewParent;
      End;

    Procedure TXMLNode.CheckCrypted(SubCheck: Boolean = False; Const Attr: TWideString = '');
      Var N: TXMLNode;

      Begin
        Try
          If (Attr = '') or not Assigned(_Owner)
              or TXHelper.SameTextW(Attr, _Owner.CryptAttrName, False) Then Begin
            _isCrypted := Assigned(_Owner) and (_Attributes.IndexOfCS(_Owner.CryptAttrName) >= 0);
            If SubCheck Then Begin
              N := _Nodes.FirstNodeNF;
              While Assigned(N) do Begin
                N.CheckCrypted(True);
                N := N.NextNodeNF;
              End;
            End;
          End;
        Except
          // do nothing *blush*
        End;
      End;

    Procedure TXMLNode.DoNodeChange(CType: TXMLNodeChangeType);
      {inline}

      Begin
        If Assigned(_Owner) Then _Owner.DoNodeChange(Self, CType);
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TXMLAttributes'}{$IFEND}

    Function TXMLAttributes.GetName(Index: Integer): TWideString;
      Begin
        If (Index < 0) or (Index >= _AttributesLength) Then Result := ''
        Else Result := _Attributes[Index].Name;
      End;

    Procedure TXMLAttributes.SetName(Index: Integer; Const Value: TWideString);
      Begin
        If (Index < 0) or (Index >= _AttributesLength) Then
          Raise EXMLException.Create(ClassType, 'Name', @SOutOfRange, [Index, _AttributesLength]);
        If not TXHelper.CheckString(Value, xtAttribute_Name) Then
          Raise EXMLException.Create(ClassType, 'Name', @SInvalidName, Value);
        If (IndexOf(Value) >= 0) and (IndexOf(Value) <> Index) Then
          Raise EXMLException.Create(ClassType, 'Name', @SDuplicateAttr, Value);
        _Attributes[Index].Name     := Value;
        _Attributes[Index].NameHash := TXHelper.CalcHash(Value);
        DoNodeChange('');
      End;

    Function TXMLAttributes.GetNamespace(Index: Integer): TWideString;
      Begin
        If (Index < 0) or (Index >= _AttributesLength) Then
          Raise EXMLException.Create(ClassType, 'Name', @SOutOfRange, [Index, _AttributesLength]);
        Result := Copy(_Attributes[Index].Name, 1, TXHelper.Pos(':', _Attributes[Index].Name) - 1);
      End;

    Procedure TXMLAttributes.SetNamespace(Index: Integer; Value: TWideString);
      Begin
        If (Index < 0) or (Index >= _AttributesLength) Then
          Raise EXMLException.Create(ClassType, 'Name', @SOutOfRange, [Index, _AttributesLength]);
        If Value = '' Then Value := NameOnly[Index]
        Else Value := Value + ':' + NameOnly[Index];
        Name[Index] := Value;
      End;

    Function TXMLAttributes.GetNameOnly(Index: Integer): TWideString;
      Begin
        If (Index < 0) or (Index >= _AttributesLength) Then
          Raise EXMLException.Create(ClassType, 'Name', @SOutOfRange, [Index, _AttributesLength]);
        Result := Copy(_Attributes[Index].Name, TXHelper.Pos(':', _Attributes[Index].Name) + 1,
          Length(_Attributes[Index].Name));
      End;

    Procedure TXMLAttributes.SetNameOnly(Index: Integer; Value: TWideString);
      Begin
        If (Index < 0) or (Index >= _AttributesLength) Then
          Raise EXMLException.Create(ClassType, 'NameOnly', @SOutOfRange, [Index, _AttributesLength]);
        If TXHelper.Pos(':', _Attributes[Index].Name) > 0 Then Value := Namespace[Index] + ':' + Value;
        Name[Index] := Value;
      End;

    {$IFDEF hxExcludeTIndex}
      Function TXMLAttributes.GetValue(IndexOrName: TIndex): Variant;
        Var Name, S: TWideString;
          Index, i:  Integer;

        Begin
          If VarIsType(IndexOrName, [varShortInt, varSmallInt, varInteger, varByte, varWord, varLongWord]) Then Begin
            Index := IndexOrName;
    {$ELSE}
      Function TXMLAttributes.GetValue(Index: Integer): Variant;
        Var S: TWideString;

        Begin
    {$ENDIF}
          If (Index >= 0) and (Index < _AttributesLength) Then Begin
            S := _Attributes[Index].Value;
            TXHelper.ConvertString(S, xtAttribute_GetValue, _Owner);
            TXHelper.XMLToVariant(S, Result);
          End Else VarClear(Result);
    {$IFDEF hxExcludeTIndex}
          End Else If VarIsType(IndexOrName, [varOleStr, varString {$IF Declared(UnicodeString)}, varUString{$IFEND}]) Then Begin
            Name := IndexOrName;
    {$ELSE}
        End;

      Function TXMLAttributes.GetNamedValue(Name: TWideString): Variant;
        Var i: Integer;
          S:   TWideString;

        Begin
    {$ENDIF}
          If ParseNodePath(Self, Name, [xpNotCreate]) Then Begin
            i := IndexOf(Name);
            If i >= 0 Then Begin
              S := _Attributes[i].Value;
              TXHelper.ConvertString(S, xtAttribute_GetValue, _Owner);
              TXHelper.XMLToVariant(S, Result);
              Exit;
            End;
          End;
          VarClear(Result);
    {$IFNDEF hxExcludeTIndex}
        End;
    {$ELSE}
          End Else Result := Variants.Null;
        End;
    {$ENDIF}

    {$IFDEF hxExcludeTIndex}
      Procedure TXMLAttributes.SetValue(IndexOrName: TIndex; Const Value: Variant);
        Var Name, S: TWideString;
          Index, i:  Integer;

        Begin
          If VarIsType(IndexOrName, [varShortInt, varSmallInt, varInteger, varByte, varWord, varLongWord]) Then Begin
            Index := IndexOrName;
    {$ELSE}
      Procedure TXMLAttributes.SetValue(Index: Integer; Const Value: Variant);
        Var S: TWideString;

        Begin
    {$ENDIF}
          Try
            S := TXHelper.VariantToXML(Value);
          Except
            Raise EXMLException.Create(ClassType, 'Value', @SInvalidValueN, [], Exception(ExceptObject));
          End;
          If (Index < 0) or (Index >= _AttributesLength) Then
            Raise EXMLException.Create(ClassType, 'Value', @SOutOfRange, [Index, _AttributesLength]);
          If not TXHelper.ConvertString(S, xtAttribute_SetValue, _Owner) Then
            Raise EXMLException.Create(ClassType, 'Value', @SInvalidValue, S);
          _Attributes[Index].Value := S;
          DoNodeChange(_Attributes[Index].Name);
    {$IFDEF hxExcludeTIndex}
          End Else If VarIsType(IndexOrName, [varOleStr, varString {$IF Declared(UnicodeString)}, varUString{$IFEND}]) Then Begin
            Name := IndexOrName;
    {$ELSE}
        End;

      Procedure TXMLAttributes.SetNamedValue(Name: TWideString; Const Value: Variant);
        Var S: TWideString;
          i:   Integer;

        Begin
    {$ENDIF}
          Try
            S := TXHelper.VariantToXML(Value);
          Except
            Raise EXMLException.Create(ClassType, 'Value', @SInvalidValueN, [], Exception(ExceptObject));
          End;
          If not TXHelper.ConvertString(S, xtAttribute_SetValue, _Owner) Then
            Raise EXMLException.Create(ClassType, 'Value', @SInvalidValueS, 'variant value');
          If ParseNodePath(Self, Name, []) Then Begin
            If Assigned(_Parent) and not (_Parent.NodeType in [xtInstruction, xtElement]) Then
              Raise EXMLException.Create(ClassType, 'Value', @SNoAttributes);
            i := IndexOf(Name);
            If i < 0 Then Begin
              If not TXHelper.CheckString(Name, xtAttribute_Name) Then
                Raise EXMLException.Create(ClassType, 'Value', @SInvalidName, Name);
              i := _AttributesLength;
              Inc(_AttributesLength);
              SetLength(_Attributes, TXHelper.CalcArraySize(_AttributesLength));
              _Attributes[i].NameHash := TXHelper.CalcHash(Name);
              _Attributes[i].Name     := Name;
            End;
            _Attributes[i].Value := S;
            DoNodeChange(_Attributes[i].Name);
          End Else Raise EXMLException.Create(ClassType, 'Value', @SMissingNode);
    {$IFNDEF hxExcludeTIndex}
        End;
    {$ELSE}
          End Else Raise EXMLException.Create(ClassType, 'Value', @SInvalidValueS, 'variant value');
        End;
    {$ENDIF}

    {$IF DELPHI >= 2006}

      Function TXMLAttributes.GetNamedList(Name: TWideString): TAssocVariantArray;
        Var S:   TWideString;
          i, i2: Integer;

        Begin
          Result.Clear;
          If ParseNodePath(Self, Name, [xpNotCreate]) Then Begin
            Result.Tag := Integer(Self);
            i2 := 0;
            For i := 0 to _AttributesLength - 1 do
              If TXHelper.MatchText(Name, _Attributes[i].Name, _Owner) Then Begin
                S := _Attributes[i].Value;
                Inc(i2);
                SetLength(Result._Data, TXHelper.CalcArraySize(i2));
                Result._Data[i2].RealIndex := i;
                Result._Data[i2].NameHash  := TXHelper.CalcHash(_Attributes[i].Name);
                Result._Data[i2].Name      := _Attributes[i].Name;
                TXHelper.ConvertString(S, xtAttribute_GetValue, _Owner);
                TXHelper.XMLToVariant(S, Result._Data[i2].Value);
              End;
            SetLength(Result._Data, i2);
          End Else Result.Tag := Integer(nil);
        End;

    {$IFEND}

    Function TXMLAttributes.GetValueCS(Name: TWideString): Variant;
      Var i: Integer;
        S:   TWideString;

      Begin
        i := IndexOfCS(Name);
        If i >= 0 Then Begin
          S := _Attributes[i].Value;
          TXHelper.ConvertString(S, xtAttribute_GetValue, _Owner);
          TXHelper.XMLToVariant(S, Result);
        End Else VarClear(Result);
      End;

    Procedure TXMLAttributes.SetValueCS(Name: TWideString; Const Value: Variant);
      Var S: TWideString;
        i:   Integer;

      Begin
        Try
          S := TXHelper.VariantToXML(Value);
        Except
          Raise EXMLException.Create(ClassType, 'ValueCS', @SInvalidValueN, [], Exception(ExceptObject));
        End;
        If not TXHelper.ConvertString(S, xtAttribute_SetValue, _Owner) Then
          Raise EXMLException.Create(ClassType, 'ValueCS', @SInvalidValueS, 'variant value');
        i := IndexOfCS(Name);
        If i >= 0 Then Begin
          _Attributes[i].Value := S;
          DoNodeChange(_Attributes[i].Name);
        End Else Add(Name, S);
      End;

    Constructor TXMLAttributes.Create(Parent: TXMLNode);
      Begin
        Inherited Create;
        If Parent is TXMLNode Then Begin
          _Owner           := Parent.Owner;
          _Parent          := Parent;
        End Else If not Assigned(Parent) Then Begin
          //_Owner          := nil;
          //_Parent         := nil;
        End Else Raise EXMLException.Create(ClassType, 'Create', @SInvalidParent);
        //_AttributesLength := 0;
        //_Attributes       := nil;
      End;

    Destructor TXMLAttributes.Destroy;
      Begin
        Clear;
        Inherited;
      End;

    Function TXMLAttributes.Add(Name: TWideString; Const Value: Variant): Integer;
      Var S: TWideString;
        i:   Integer;

      Begin
        Try
          S := TXHelper.VariantToXML(Value);
        Except
          Raise EXMLException.Create(ClassType, 'Add', @SInvalidValueN, [], Exception(ExceptObject));
        End;
        If not TXHelper.CheckString(Name, xtAttribute_Name) Then
          Raise EXMLException.Create(ClassType, 'Add', @SInvalidName, Name);
        If not TXHelper.ConvertString(S, xtAttribute_SetValue, _Owner) Then
          Raise EXMLException.Create(ClassType, 'Add', @SInvalidValueS, 'variant value');
        If ParseNodePath(Self, Name, []) Then Begin
          If IndexOf(Name) >= 0 Then
            Raise EXMLException.Create(ClassType, 'Add', @SDuplicateAttr, Name);
          If Assigned(_Parent) and not (_Parent.NodeType in [xtInstruction, xtElement]) Then
            Raise EXMLException.Create(ClassType, 'Add', @SNoAttributes);
          i := _AttributesLength;
          Inc(_AttributesLength);
          SetLength(_Attributes, TXHelper.CalcArraySize(_AttributesLength));
          _Attributes[i].NameHash := TXHelper.CalcHash(Name);
          _Attributes[i].Name     := Name;
          _Attributes[i].Value    := S;
          Result                  := i;
          DoNodeChange(Name);
        End Else Raise EXMLException.Create(ClassType, 'Add', @SMissingNode);
      End;

    Function TXMLAttributes.Add(Const Name: TWideString): Integer;
      Begin
        Result := Add(Name, '');
      End;

    Function TXMLAttributes.Insert(Name: TWideString; Index: Integer; Const Value: Variant): Integer;
      Var S: TWideString;
        i:   Integer;

      Begin
        Try
          S := TXHelper.VariantToXML(Value);
        Except
          Raise EXMLException.Create(ClassType, 'Insert', @SInvalidValueN, [], Exception(ExceptObject));
        End;
        If not TXHelper.CheckString(Name, xtAttribute_Name) Then
          Raise EXMLException.Create(ClassType, 'Insert', @SInvalidName, Name);
        If not TXHelper.ConvertString(S, xtAttribute_SetValue, _Owner) Then
          Raise EXMLException.Create(ClassType, 'Insert', @SInvalidValue, S);
        If ParseNodePath(Self, Name, []) Then Begin
          If IndexOf(Name) >= 0 Then
            Raise EXMLException.Create(ClassType, 'Insert', @SDuplicateAttr, Name);
          If Assigned(_Parent) and not (_Parent.NodeType in [xtInstruction, xtElement]) Then
            Raise EXMLException.Create(ClassType, 'Insert', @SNoAttributes);
          i := _AttributesLength;
          If Index < 0 Then Index := 0 Else If Index > i Then Index := i;
          Inc(_AttributesLength);
          SetLength(_Attributes, TXHelper.CalcArraySize((_AttributesLength)));
          If Index < i Then CopyMemory(@_Attributes[Index + 1], @_Attributes[Index], (i - Index) * SizeOf(TXMLAttributeField));
          ZeroMemory(@_Attributes[Index], SizeOf(TXMLAttributeField));
          _Attributes[Index].NameHash := TXHelper.CalcHash(Name);
          _Attributes[Index].Name     := Name;
          _Attributes[Index].Value    := S;
          Result := Index;
          DoNodeChange(Name);
        End Else Raise EXMLException.Create(ClassType, 'Insert', @SMissingNode);
      End;

    Function TXMLAttributes.Insert(Const Name: TWideString; Index: Integer): Integer;
      Begin
        Result := Insert(Name, Index, '');
      End;

    Procedure TXMLAttributes.Delete(Name: TWideString);
      Begin
        If ParseNodePath(Self, Name, [xpNotCreate]) Then Delete(IndexOf(Name))
        Else Raise EXMLException.Create(ClassType, 'Delete', @SMissingNode);
      End;

    Procedure TXMLAttributes.Delete(Index: Integer);
      Var S: TWideString;

      Begin
        If (Index >= 0) and (Index < _AttributesLength) Then Begin
          S := _Attributes[Index].Name;
          _Attributes[Index].Name  := '';
          _Attributes[Index].Value := '';
          Dec(_AttributesLength);
          If _AttributesLength > 0 Then CopyMemory(@_Attributes[Index], @_Attributes[Index + 1],
            (_AttributesLength - Index) * SizeOf(TXMLAttributeField));
          ZeroMemory(@_Attributes[_AttributesLength], SizeOf(TXMLAttributeField));
          SetLength(_Attributes, TXHelper.CalcArraySize(_AttributesLength));
          DoNodeChange(S);
        End Else Raise EXMLException.Create(ClassType, 'Delete', @SOutOfRange, [Index, _AttributesLength]);
      End;

    Procedure TXMLAttributes.Clear;
      Begin
        _AttributesLength := 0;
        _Attributes       := nil;
        DoNodeChange('');
      End;

    Function TXMLAttributes.IndexOf(Const Name: TWideString): Integer;
      Var i:      Integer;
        NameHash: LongWord;

      Begin
        NameHash := TXHelper.CalcHash(Name);
        For i := 0 to _AttributesLength - 1 do
          If TXHelper.CompareHash(NameHash, _Attributes[i].NameHash)
              and TXHelper.MatchText(Name, _Attributes[i].Name, _Owner) Then Begin
            Result := i;
            Exit;
          End;
        Result := -1;
      End;

    Function TXMLAttributes.Exists(Name: TWideString): Boolean;
      Begin
        Result := ParseNodePath(Self, Name, [xpNotCreate]) and (IndexOf(Name) >= 0);
      End;

    Function TXMLAttributes.IndexOfCS(Const Name: TWideString; CaseSensitive: Boolean = False): Integer;
      Var i:      Integer;
        NameHash: LongWord;

      Begin
        NameHash := TXHelper.CalcHash(Name);
        For i := 0 to _AttributesLength - 1 do
          If TXHelper.CompareHash(NameHash, _Attributes[i].NameHash)
              and TXHelper.MatchText(Name, _Attributes[i].Name, CaseSensitive) Then Begin
            Result := i;
            Exit;
          End;
        Result := -1;
      End;

    Function TXMLAttributes.ExistsCS(Const Name: TWideString; CaseSensitive: Boolean = False): Boolean;
      Begin
        Result := IndexOfCS(Name, CaseSensitive) >= 0;
      End;

    Procedure TXMLAttributes.CloneAttr(Attributes: TXMLAttributes);
      Var i: Integer;

      Begin
        For i := 0 to Attributes.Count - 1 do
          Value[Attributes.Name[i]] := Attributes.Value[i];
      End;

    Procedure TXMLAttributes.Assign(Attributes: TXMLAttributes);
      Begin
        Clear;
        CloneAttr(Attributes);
      End;

    Procedure TXMLAttributes.Sort(SortProc: TXMLAttrSortProc = nil);
      Var i, i2: Integer;
        B, B2:   Boolean;
        Temp:    TXMLAttributeField;

      Begin
        B2 := False;
        For i := 0 to _AttributesLength - 2 do
          For i2 := i + 1 to _AttributesLength - 1 do Begin
            If Assigned(SortProc) Then B := SortProc(Self, i, i2) > 0
            Else B := TXHelper.CompareText(_Attributes[i].Name, _Attributes[i2].Name) > 0;
            If B Then Begin
              Temp            := _Attributes[i];
              _Attributes[i]  := _Attributes[i2];
              _Attributes[i2] := Temp;
              B2 := True;
            End;
          End;
        If B2 Then DoNodeChange('*');
      End;

    Class Function TXMLAttributes.ParseNodePath(Var Attr: TXMLAttributes; Var AttrName: TWideString; PathOptions: TXMLNodePathOptions): Boolean;
      Var i:   Integer;
        Nodes: TXMLNodeList;

      Begin
        i := TXHelper.Pos(TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.PathDelimiter, AttrName);
        If i > 0 Then Begin
          If Assigned(Attr._Parent) Then Begin
            Nodes  := Attr._Parent.Nodes;
            Result := TXMLNodeList.ParseNodePath(Nodes, AttrName, PathOptions);
            If Result Then Attr := Nodes.Parent.Attributes;
          End Else Result := False;
        End Else Result := True;
      End;

    Procedure TXMLAttributes.SetOwner(NewOwner: TXMLFile);
      Begin
        _Owner := NewOwner;
      End;

    Function TXMLAttributes.GetInnerAttributeValue(i: Integer): TWideString;
      Begin
        Result := _Attributes[i].Value;
      End;

    Procedure TXMLAttributes.SetInnerAttributeValue(i: Integer; Const Value: TWideString);
      Begin
        _Attributes[i].Value := Value;
      End;

    Procedure TXMLAttributes.DoNodeChange(Const Attr: TWideString);
      Begin
        If Assigned(_Parent) Then Begin
          _Parent.DoNodeChange(xcAttributesChanged);
          _Parent.CheckCrypted(False, Attr);
        End;
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TSAXFile'}{$IFEND}

    Class Function TSAXFile.GetLibVersion: AnsiString;
      Begin
        Result := TSAXFile_LibVersion;
      End;

    Procedure TSAXFile.SetOwner(Value: TObject);
      Begin
        _Owner := Value;
      End;

    Function TSAXFile.GetOptions: TXMLOptions;
      Begin
//        Result := _Helper.Options;
      End;

    Procedure TSAXFile.SetOptions(Value: TXMLOptions);
      Begin
//        _Helper.Options := Value * [xoChangeInvalidChars, xoCaseSensitive];
      End;

    Function TSAXFile.GetVersion: TWideString;
      Begin
//        Result := _Helper.Version;
      End;

    Function TSAXFile.GetEncoding: TWideString;
      Begin
//        Result := _Helper.Encoding;
      End;

    Function TSAXFile.GetStandalone: TWideString;
      Begin
//        Result := _Helper.Standalone;
      End;

    Function TSAXFile.GetLevelCount: Integer;
      Begin
        Result := _LevelCount;
      End;

    Function TSAXFile.GetLevel(Index: Integer): TSAXNode;
      Begin
        If (Index < 0) or (Index >= _LevelCount) Then Result := nil
        Else Result := _Level[Index];
      End;

    Function TSAXFile.GetProgress: LongInt;
      Var i:    Integer;
        i2, i3: Int64;
        Ps:     PAnsiChar;

      Begin
//        i2 := _Stream.Position - _AOptions.StreamStart;
//        Ps := _AOptions.Buffer.GetCharSizeP;
//        For i := _AOptions.Buffer.Pos to _AOptions.Buffer.Length - 1 do Dec(i2, Byte(Ps[i]));
//        i3 := _Stream.Size - _AOptions.StreamStart;
        If i3 <= 0 Then i3 := 1;
        Result := i2 * 100000 div i3;
      End;

    Constructor TSAXFile.Create(Owner: TObject; Const FileName: TWideString = '');
      Begin
        Inherited Create;
        _Owner          := Owner;
//        _Helper         := TXMLFile.Create(Self, True);
//        _Helper.Options := [];
        //_Stream       := nil;
        //_FileName     := '';
        //_AOptions     := ...
        //_LevelCount   := 0;
        //_Level        := nil;
        If FileName <> '' Then
          Try
            Open(FileName);
          Except
//            _Helper.Free;
            Raise;
          End;
      End;

    Constructor TSAXFile.Create(Owner: TObject; Stream: TStream);
      Begin
        Inherited Create;
        _Owner          := Owner;
//        _Helper         := TXMLFile.Create(Self, True);
//        _Helper.Options := [];
        //_Stream       := nil;
        //_FileName     := '';
        //_AOptions     := ...
        //_LevelCount   := 0;
        //_Level        := nil;
        If _FileName <> '' Then
          Try
            Open(Stream);
          Except
//            _Helper.Free;
            Raise;
          End;
      End;

    Destructor TSAXFile.Destroy;
      Begin
//        _Helper.Free;
        Close;
        Inherited;
      End;

    Procedure TSAXFile.Open(Const FileName: TWideString);
      Var Stream: TStream;

      Begin
        Stream := TWideFileStream.Create(FileName, fmOpenRead);
        Try
          Open(Stream);
          _FileName := FileName;
        Except
          Stream.Free;
          Raise;
        End;
      End;

    Procedure TSAXFile.Open(Stream: TStream;
        StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = False);

      Var i: Integer;

      Begin
        Close;
        If Stream.Size = 0 Then ;  // simple access check
        _Stream := Stream;
//        TXMLFile.SetXOptions(_Helper, _AOptions);
//        If IgnoreEncodingAttributes Then Include(_AOptions.Options, xo_IgnoreEncoding);
//        If StartEncoding <= High(TXMLEncoding) Then _AOptions.Encoding := StartEncoding;

//        _AOptions.StreamStart := Stream.Position;
//        TXMLFile.ReadBOM(_Stream, _AOptions.Encoding);

        _LevelCount := 0;
        SetLength(_Level, 64);
        For i := 0 to High(_Level) do _Level[i] := TSAXNode.Create(Self);
        _NodesCount := 0;
        _MaxLevels  := 0;
      End;

    {$IFNDEF hxExcludeClassesUnit}

      Procedure TSAXFile.Open(Buffer: Pointer; Len: Integer;
          StartEncoding: TXMLEncoding = xeUTF8; IgnoreEncodingAttributes: Boolean = False);

        Var Stream: TStream;

        Begin
          Stream := TMemoryStream.Create;
          Try
            If Len > 0 Then Stream.WriteBuffer(Buffer^, Len);
            Stream.Position := 0;
            Open(Stream, StartEncoding, IgnoreEncodingAttributes);
            _FileName := Format('[Memory:$%.8x:%d]', [Buffer, Len]);
          Except
            Stream.Free;
            Raise;
          End;
        End;

    {$ENDIF}

    Procedure TSAXFile.Close;
      Var i: Integer;

      Begin
//        _Helper.Options := _Helper.Options - [xo_IgnoreEncoding];
//        If Assigned(_Stream) Then TXMLFile.ClearTemp(_Stream, _AOptions.Buffer);
        If _FileName <> '' Then Begin
          _Stream.Free;
          _Filename := '';
        End;
        _Stream := nil;
//        Finalize(_AOptions);
        _LevelCount := 0;
        For i := High(_Level) downto 0 do _Level[i].Free;
        _Level := nil;
      End;

    Function TSAXFile.Parse(Var Node: TSAXNode; Out isClosedTag: Boolean): Boolean;
      (*Procedure _DoException(ResStringRec: PResStringRec; Const Args: Array of Const); Overload;
        Var L: Int64;
          i:   Integer;
          S:   TWideString;

        Begin
//          TXMLFile.DeleteTemp(_AOptions.Buffer.Pos, _AOptions.Buffer);
          L := _AOptions.Buffer.ProcessedLines;
          i := _AOptions.Buffer.Length;
          If i > 20 Then i := 20;
          _CopyData(S, 1, i);
//          TXMLFile.ClearTemp(_Stream, _AOptions.Buffer);
          Raise EXMLException.Create(ClassType, 'Read', ResStringRec, Args,
            @SErrorPos*, [_Stream.Position / 1, L / 1, S, '', False]);
        End;

      Procedure _DoException(ResStringRec: PResStringRec); Overload;
        Begin
          _DoException(ResStringRec, []);
        End;

      Function _CallNode(Const NodeName: TWideString; NodeType: TXMLNodeType): TSAXNode;
        Var i: Integer;

        Begin
          If (_LevelCount <= 0) or _Level[_LevelCount - 1]._isOpen Then Begin
            Inc(_LevelCount);
            If _LevelCount > Length(_Level) Then Begin
              SetLength(_Level, (_LevelCount + 63) and -64);
              For i := _LevelCount - 1 to High(_Level) do
                _Level[i] := TSAXNode.Create(Self);
            End;
          End;

          Inc(_NodesCount);
          If _LevelCount > _MaxLevels Then _MaxLevels := _LevelCount;

          If _LevelCount > 1 Then _Level[_LevelCount - 2]._SubNodes := _Level[_LevelCount - 2]._SubNodes + 1;

          Result := _Level[_LevelCount - 1];
          If (Result._NodeType = xtCData) and (_LevelCount - 1 > 0) Then _Level[_LevelCount - 2]._hasCDATA := False;
          Result._NodeType  := NodeType;
          Result._Name      := NodeName;
          Result._AttrCount := 0;
          Result._isOpen    := False;
          Result._Text      := '';
          Result._hasCDATA  := False;
          Result._SubNodes  := 0;
          If (Result._NodeType = xtCData) and (_LevelCount - 1 > 0) Then _Level[_LevelCount - 2]._hasCDATA := True;
        End;

      Procedure _SetAttribute(Node: TSAXNode; Const Name, Value: TWideString);
        Var i:   Integer;
          Hash:  LongWord;
          NodeO: TSAXNode;

        Begin
          NodeO := Node;
          Hash  := TXHelper.CalcHash(Name);
          For i := NodeO._AttrCount - 1 downto 0 do
            If TXHelper.CompareHash(NodeO._Attributes~[i].NameHash, Hash)
                and TXHelper.SameTextW(NodeO._Attributes~[i].Name, Name, _Helper) Then Begin
              NodeO._Attributes~[i].Value := Value;
              Exit;
            End;
          Inc(NodeO._AttrCount);
          SetLength(NodeO._Attributes~, (NodeO._AttrCount + 63) and -64);
          NodeO._Attributes~[NodeO._AttrCount - 1].NameHash := Hash;
          NodeO._Attributes~[NodeO._AttrCount - 1].Name     := Name;
          NodeO._Attributes~[NodeO._AttrCount - 1].Value    := Value;
        End;

      Var i3:  Integer;
        i, i2: Integer;
        S, S2: TWideString;
        P:     PWideChar;
        Ps:    PAnsiChar;
        X:     Set of (Xqout, Xapos, Xdeli);*)

      Begin
        (*Node        := nil;
        isClosedTag := False;
        If not Assigned(_Stream) Then Begin
          Result := False;
          Exit;
        End;

        i := _AOptions.Buffer.Pos;
        P := _AOptions.Buffer.GetDataP;
        _Search(P, i, 0{isSpace...});

        If not CheckLen(0, i, P) Then Begin
          If _LevelCount <> 0 Then _DoException(@SEndOfData);
          Result := False;
          Exit;

        End Else If (P[i] = '<') and CheckLen(1, i, P) and (P[i + 1] = '?') Then Begin
          // xtInstruction   <?name attributes ?>

          _AOptions.Buffer.Pos := i;
          Inc(i, 2);
          If CheckLen(0, i, P) and TXHelper.isNameStart(P[i]) Then Begin
            Inc(i);
            _Search(P, i, 1{isName...});
          End;
          _CopyData(S, _AOptions.Buffer.Pos + 3, i - _AOptions.Buffer.Pos - 2);
          If not TXHelper.CheckString(S, xtInstruction_NodeName) Then _DoException(@SInvalidName, [S]);
          Node := _CallNode(S, xtInstruction);
          _AOptions.Buffer.Pos := i;

          While True do Begin
            _Search(P, i, 0{isSpace...});
            _AOptions.Buffer.Pos := i;

            If CheckLen(0, i, P) and TXHelper.isNameStart(P[i]) Then Begin
              Inc(i);
              _Search(P, i, 1{isName...});
              _CopyData(S, _AOptions.Buffer.Pos + 1, i - _AOptions.Buffer.Pos);
              If not TXHelper.CheckString(S, xtAttribute_Name) Then _DoException(@SInvalidName, [S]);
              _Search(P, i, 0{isSpace...});
              If not CheckLen(0, i, P) Then _DoException(@SEndOfData)
              Else If P[i] = '=' Then Inc(i) Else _DoException(@SCharNotFound, '=');
              _Search(P, i, 0{isSpace...});
              _AOptions.Buffer.Pos := i;
              If CheckLen(0, i, P) and ((P[i] = '"') or (P[i] = '''')) Then Begin
                Inc(i);
                If P[_AOptions.Buffer.Pos] = '"' Then _Search(P, i, 2{..."}) Else _Search(P, i, 3{...'});
                If CheckLen(0, i, P) Then _DoException(@SEndOfData)
                Else If P[i] = P[_AOptions.Buffer.Pos] Then Inc(i) Else _DoException(@SInvalidValueN);
                _CopyData(S2, _AOptions.Buffer.Pos + 2, i - _AOptions.Buffer.Pos - 2);
              End Else Begin
                _Search(P, i, 1{isName...});
                _CopyData(S2, _AOptions.Buffer.Pos + 1, i - _AOptions.Buffer.Pos);
              End;
              If not TXHelper.ConvertString(S2, xtAttribute_LoadValue, _AOptions) Then _DoException(@SInvalidValue, [S2]);
              _SetAttribute(Node, S, S2);
              _AOptions.Buffer.Pos := i;
            End Else If CheckLen(1, i, P) and (P[i] = '?') and (P[i + 1] = '>') Then Begin
              Inc(i, 2);
              _AOptions.Buffer.Pos := i;
              Break;
            End Else _DoException(@SInvalidNameN);
          End;

          If TXHelper.MatchText('xml|XML', Node._Name, _Helper) and (_NodesCount <= 2) Then
            For i2 := Node._AttrCount - 1 downto 0 do
              If TXHelper.SameTextW(Node._Attributes~[i2].Name, 'version', _Helper) Then Begin
                S := Node._Attributes~[i2].Value;
                _AOptions.Version := Low(TXMLVersion);
                While _AOptions.Version <= High(TXMLVersion) do Begin
                  If TXHelper.SameTextW(XMLVersionData[_AOptions.Version].Version, S, _Helper) Then Break;
                  Inc(_AOptions.Version);
                End;
                If _AOptions.Version > High(TXMLVersion) Then _DoException(@SUnknownXmlVersion);

                If _NodesCount = 1 Then _Helper.Version := S;
              End Else If TXHelper.SameTextW(Node._Attributes~[i2].Name, 'encoding', _Helper) Then Begin
//                TXMLFile.DeleteTemp(i, _AOptions.Buffer);
//                TXMLFile.ClearTemp(_Stream, _AOptions.Buffer);
                i3 := XMLEncodingData[_AOptions.Encoding].CharSize;
                S  := Node._Attributes~[i2].Value;
                _AOptions.Encoding := Low(TXMLEncoding);
                While _AOptions.Encoding <= High(TXMLEncoding) do Begin
                  If (S <> '') and TXHelper.SameTextW(XMLEncodingData[_AOptions.Encoding].Encoding, S, _Helper) Then Break;
                  Inc(_AOptions.Encoding);
                End;
                If (_AOptions.Encoding > High(TXMLEncoding)) or (i3 > XMLEncodingData[_AOptions.Encoding].CharSize) Then
                  _DoException(@SUnknownEncoding);

                If _NodesCount = 1 Then _Helper.Encoding := S;
              End Else If TXHelper.SameTextW(Node._Attributes~[i2].Name, 'standalone', _Helper) Then
                If _NodesCount = 1 Then _Helper.Encoding := Node._Attributes~[i2].Value;

        End Else If (P[i] = '<') and CheckLen(2, i, P) and (P[i + 1] = '!') and (P[i + 2] = '[') Then Begin
          // xtCData   <![CDATA[data]]>

          _AOptions.Buffer.Pos := i;
          Inc(i, 3);
          _Search(P, i, 1{isName...});
          _CopyData(S, _AOptions.Buffer.Pos + 4, i - _AOptions.Buffer.Pos - 3);
          If (S <> 'CDATA') and ((xoCaseSensitive in _AOptions.Options) or not TXHelper.SameTextW(S, 'CDATA', True)) Then
            _DoException(@SInvalidName, [S]);
          If not CheckLen(0, i, P) Then _DoException(@SEndOfData)
          Else If P[i] <> '[' Then _DoException(@SInvalidChar, P[i]);
          Node := _CallNode('', xtCData);
          Inc(i);
          While CheckLen(2, i, P) and ((P[i] <> ']') or (P[i + 1] <> ']') or (P[i + 2] <> '>')) do Inc(i);
          If not CheckLen(2, i, P) Then _DoException(@SEndOfData)
          Else If (P[i] <> ']') or (P[i + 1] <> ']') or (P[i + 2] <> '>') Then _DoException(@SInvalidValueN);
          _CopyData(S, _AOptions.Buffer.Pos + 10, i - _AOptions.Buffer.Pos - 9);
          If not TXHelper.ConvertString(S, xtCData_LoadText, _AOptions) Then _DoException(@SInvalidValue, [S]);
          Node._Text := S;
          Inc(i, 3);
          _AOptions.Buffer.Pos := i;

        End Else If (P[i] = '<') and CheckLen(3, i, P) and (P[i + 1] = '!') and (P[i + 2] = '-') and (P[i + 3] = '-') Then Begin
          // xtComment   <!--data-->

          _AOptions.Buffer.Pos := i;
          Inc(i, 4);
          Node := _CallNode('', xtComment);
          While CheckLen(2, i, P) and ((P[i] <> '-') or (P[i + 1] <> '-') or (P[i + 2] <> '>')) do Inc(i);
          If not CheckLen(2, i, P) Then _DoException(@SEndOfData)
          Else If (P[i] <> '-') or (P[i + 1] <> '-') or (P[i + 2] <> '>') Then _DoException(@SInvalidValueN);
          _CopyData(S, _AOptions.Buffer.Pos + 5, i - _AOptions.Buffer.Pos - 4);
          If not TXHelper.ConvertString(S, xtComment_LoadText, _AOptions) Then _DoException(@SInvalidValue, [S]);
          Node._Text := S;
          Inc(i, 3);
          _AOptions.Buffer.Pos := i;

        End Else If (P[i] = '<') and CheckLen(1, i, P) and (P[i + 1] = '!') Then Begin
          // xtTypedef   <!name data>  or  <!name data...[...data]>

          _AOptions.Buffer.Pos := i;
          Inc(i, 2);
          _Search(P, i, 1{isName...});
          _CopyData(S, _AOptions.Buffer.Pos + 3, i - _AOptions.Buffer.Pos - 2);
          If not TXHelper.CheckString(S, xtTypedef_NodeName) Then _DoException(@SInvalidName, [S]);
          Node := _CallNode(S, xtTypedef);
          _AOptions.Buffer.Pos := i;

          X := [];
          While CheckLen(0, i, P) do Begin
            Case P[i] of
              '[':      If X * [Xqout, Xapos] = [] Then
                          If Xdeli in X Then Break Else Include(X, Xdeli);
              ']':      If X * [Xqout, Xapos] = [] Then
                          If not (Xdeli in X) or not CheckLen(1, i, P) or (P[i + 1] <> '>') Then
                            Break Else Exclude(X, Xdeli);
              '=':      ;
              '"':      If not (Xapos in X) Then
                          If Xqout in X Then Exclude(X, Xqout) Else Include(X, Xqout);
              '''':     If not (Xqout in X) Then
                          If Xapos in X Then Exclude(X, Xapos) Else Include(X, Xapos);
              '<', '>': If X * [Xdeli, Xqout, Xapos] = [] Then Break;
            End;
            Inc(i);
          End;
          If (X <> []) or not CheckLen(0, i, P) or (P[i] <> '>') Then Begin
            _AOptions.Buffer.Pos := i;
            _DoException(@SInvalidValueN);
          End;
          _CopyData(S, _AOptions.Buffer.Pos + 1, i - _AOptions.Buffer.Pos);
          i2 := 0;
          While (i2 < Length(S)) and TXHelper.isSpace(S[i2 + 1]) do Inc(i2);
          Delete(S, 1, i2);
          i2 := Length(S) - 1;
          While (i2 >= 0) and TXHelper.isSpace(S[i2 + 1]) do Dec(i2);
          Delete(S, i2 + 1, Length(S));
          If not TXHelper.ConvertString(S, xtTypedef_LoadText, _AOptions) Then _DoException(@SInvalidValue, [S]);
          Node._Text := S;
          Inc(i);
          _AOptions.Buffer.Pos := i;

        End Else If (P[i] = '<') and CheckLen(1, i, P) and (P[i + 1] = '/') Then Begin
          // xtElement   </name>

          _AOptions.Buffer.Pos := i;
          Inc(i, 2);
          If CheckLen(0, i, P) and TXHelper.isNameStart(P[i]) Then Begin
            Inc(i);
            _Search(P, i, 1{isName...});
          End;
          _CopyData(S, _AOptions.Buffer.Pos + 3, i - _AOptions.Buffer.Pos - 2);
          If ((_LevelCount > 0) and _Level[_LevelCount - 1]._isOpen and ((_Level[_LevelCount - 1]._Name = S)
              or (not (xoCaseSensitive in _AOptions.Options) and TXHelper.SameTextW(S, _Level[_LevelCount - 1]._Name, True)))) Then
            Dec(_LevelCount)
          Else If ((_LevelCount > 1) and not _Level[_LevelCount - 1]._isOpen and _Level[_LevelCount - 2]._isOpen
              and ((_Level[_LevelCount - 2]._Name = S) or (not (xoCaseSensitive in _AOptions.Options)
              and TXHelper.SameTextW(S, _Level[_LevelCount - 2]._Name, True)))) Then Begin
            Dec(_LevelCount, 2);
          End Else
            //_DoException(@SUnknownClosingTag, [Tree._Parent._Name, S]);
            {}_DoException(@SInvalidClosingTag, [S]);
          _Search(P, i, 0{isSpace...});
          _AOptions.Buffer.Pos := i;
          If not CheckLen(0, i, P) Then _DoException(@SEndOfData)
          Else If P[i] <> '[' Then _DoException(@SInvalidChar, P[i]);
          Inc(i);
          _AOptions.Buffer.Pos := i;

          Node := _Level[_LevelCount];
          Node._isOpen := False;

          If _LevelCount > 0 Then
            If _Level[_LevelCount]._NodeType = xtCData Then Begin
              _Level[_LevelCount - 1]._hasCDATA := True;
              _Level[_LevelCount - 1]._Text := _Level[_LevelCount]._Text;
            End Else If _Level[_LevelCount]._NodeType = xtUnknown Then
              _Level[_LevelCount - 1]._Text := _Level[_LevelCount]._Text;

        End Else If P[i] = '<' Then Begin
          // xtElement   <name attributes />  or  <name attributes>

          _AOptions.Buffer.Pos := i;
          Inc(i, 1);
          If CheckLen(0, i, P) and TXHelper.isNameStart(P[i]) Then Begin
            Inc(i);
            _Search(P, i, 1{isName...});
          End;
          _CopyData(S, _AOptions.Buffer.Pos + 2, i - _AOptions.Buffer.Pos - 1);
          If not TXHelper.CheckString(S, xtElement_NodeName) Then _DoException(@SInvalidName, [S]);
          Node := _CallNode(S, xtElement);
          _AOptions.Buffer.Pos := i;

          While True do Begin
            _Search(P, i, 0{isSpace...});
            _AOptions.Buffer.Pos := i;

            If CheckLen(0, i, P) and TXHelper.isNameStart(P[i]) Then Begin
              Inc(i);
              _Search(P, i, 1{isName...});
              _CopyData(S, _AOptions.Buffer.Pos + 1, i - _AOptions.Buffer.Pos);
              If not TXHelper.CheckString(S, xtAttribute_Name) Then _DoException(@SInvalidName, [S]);
              _Search(P, i, 0{isSpace...});
              If not CheckLen(0, i, P) Then _DoException(@SEndOfData)
              Else If P[i] = '=' Then Inc(i) Else _DoException(@SCharNotFound, '=');
              _Search(P, i, 0{isSpace...});
              _AOptions.Buffer.Pos := i;
              If CheckLen(0, i, P) and ((P[i] = '"') or (P[i] = '''')) Then Begin
                Inc(i);
                If P[_AOptions.Buffer.Pos] = '"' Then _Search(P, i, 2{..."}) Else _Search(P, i, 3{...'});
                If CheckLen(0, i, P) Then _DoException(@SEndOfData)
                Else If P[i] = P[_AOptions.Buffer.Pos] Then Inc(i) Else _DoException(@SInvalidValueN);
                _CopyData(S2, _AOptions.Buffer.Pos + 2, i - _AOptions.Buffer.Pos - 2);
              End Else Begin
                _Search(P, i, 1{isName...});
                _CopyData(S2, _AOptions.Buffer.Pos + 1, i - _AOptions.Buffer.Pos);
              End;
              If not TXHelper.ConvertString(S2, xtAttribute_LoadValue, _AOptions) Then _DoException(@SInvalidValue, [S2]);
              _SetAttribute(Node, S, S2);
              _AOptions.Buffer.Pos := i;
            End Else If CheckLen(1, i, P) and (P[i] = '/') and (P[i + 1] = '>') Then Begin
              Inc(i, 2);
              _AOptions.Buffer.Pos := i;
              Break;
            End Else If CheckLen(0, i, P) and (P[i] = '>') Then Begin
              _AOptions.Buffer.Pos := i + 1;
              Node._isOpen := True;
              Break;
            End Else _DoException(@SInvalidNameN, [S]);
          End;

        End Else Begin
          // xtElement   data
          // xtUnknown   data

          While CheckLen(0, i, P) and (P[i] <> '<') do Inc(i);
          _CopyData(S, _AOptions.Buffer.Pos + 1, i - _AOptions.Buffer.Pos);
          If not TXHelper.ConvertString(S, xtElement_LoadText, _AOptions) Then _DoException(@SInvalidValue, [S]);
          Node := _CallNode('', xtUnknown);
          Node._Text := S;
          _AOptions.Buffer.Pos := i;
        End;

        Result := True;*)
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TSAXNode'}{$IFEND}

    Procedure TSAXNode.SetOwner(NewOwner: TSAXFile);
      Begin
        _Owner := NewOwner;
      End;

    Function TSAXNode.GetLevel: Integer;
      Var i: Integer;

      Begin
        If Assigned(_Owner) Then
          For i := 0 to _Owner.NodesCount - 1 do
//            If _Owner.Level.InnerLevel[i] = Self Then Begin
//              Result := i;
//              Exit;
//            End;
        Result := -1;
      End;

    Function TSAXNode.GetFullPath: TWideString;
      Var i: Integer;

      Begin
        Result := _Name;
        If Assigned(_Owner) Then Begin
          i := GetLevel - 1;
          While i >= 0 do Begin
            Result := _Owner.InnerLevel[i]._Name + TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.PathDelimiter + Result;
            Dec(i);
          End;
        End;
      End;

    Function TSAXNode.GetNamespace: TWideString;
      Begin
        Result := Copy(_Name, 1, TXHelper.Pos(':', _Name) - 1);
      End;

    Function TSAXNode.GetNameOnly: TWideString;
      Begin
        Result := Copy(_Name, TXHelper.Pos(':', _Name) + 1, Length(_Name));
      End;

    Function TSAXNode.GetAttributeName(Index: LongInt): TWideString;
      Begin
        If (Index < 0) or (Index >= _AttrCount) Then Result := ''
        Else Result := _Attributes[Index].Name;
      End;

    Function TSAXNode.GetAttribute(Const IndexOrName: TIndex): Variant;
      Var O: TXMLFile;
        i:   Integer;
        S:   TWideString;
        {$IFDEF hxExcludeTIndex}
        StringValue: TWideString;
        IntValue:    Integer;
        {$ENDIF}

      Begin
//        If Assigned(_Owner) Then O := _Owner._Helper Else O := nil;
        {$IFNDEF hxExcludeTIndex}
          With IndexOrName do
            Case ValueType of
              vtStringValue: Begin
        {$ELSE}
              If VarIsType(IndexOrName, [varOleStr, varString {$IF Declared(UnicodeString)}, varUString{$IFEND}]) Then Begin
                StringValue := IndexOrName;
        {$ENDIF}
                For i := 0 to _AttrCount - 1 do
                  If TXHelper.SameTextW(StringValue, _Attributes[i].Name, O) Then Begin
                    S := _Attributes[i].Value;
                    TXHelper.ConvertString(S, xtAttribute_GetValue, O);
                    TXHelper.XMLToVariant(S, Result);
                    Exit;
                  End;
        {$IFNDEF hxExcludeTIndex}
              End;
              vtIntValue: Begin
        {$ELSE}
              End Else If VarIsType(IndexOrName, [varShortInt, varSmallInt, varInteger, varByte, varWord, varLongWord]) Then Begin
                IntValue := IndexOrName;
        {$ENDIF}
                If (IntValue >= 0) and (IntValue < _AttrCount) Then Begin
                  S := _Attributes[IntValue].Value;
                  TXHelper.ConvertString(S, xtAttribute_GetValue, O);
                  TXHelper.XMLToVariant(S, Result);
                  Exit;
                End;
              End;
        {$IFNDEF hxExcludeTIndex}
            End;
        {$ENDIF}
        Result := Variants.Null;
      End;

    Function TSAXNode.GetText: Variant;
      Var O: TXMLFile;
        S:   TWideString;

      Begin
//        If Assigned(_Owner) Then O := _Owner._Helper Else O := nil;
        S := _Text;
        If not _hasCDATA Then Begin
          Case _NodeType of
            //xtInstruction: ;
            xtTypedef: TXHelper.ConvertString(S, xtTypedef_GetText, O);
            xtUnknown,
            xtElement: TXHelper.ConvertString(S, xtElement_GetText, O);
            xtCData:   TXHelper.ConvertString(S, xtCData_GetText  , O);
            xtComment: TXHelper.ConvertString(S, xtComment_GetText, O);
          End;
        End Else TXHelper.ConvertString(S, xtCData_GetText, O);
        TXHelper.XMLToVariant(S, Result);
      End;

    Constructor TSAXNode.Create(Owner: TSAXFile);
      Begin
        Inherited Create;
        _Owner        := Owner;
        _NodeType     := xtUnknown;
        //_Name       := '';
        //_AttrCount  := 0;
        //_Attributes := nil;
        //_isOpen     := False;
        //_Text       := '';
        //_hasCDATA   := False;
        //_SubNodes   := 0;
      End;

    Destructor TSAXNode.Destroy;
      Begin
        Inherited;
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TXHelper'}{$IFEND}

    Class Function TXHelper.CalcArraySize(Len: Integer): Integer;
      {inline}

      Begin
        If      Len <  4 Then Result := Len
        Else If Len < 96 Then Result := (Len +  7) and  -8
        Else                  Result := (Len + 31) and -32;
      End;

    Class Function TXHelper.CalcHash(Const S: TWideString): LongWord;
      Var P: PWideChar;
        i:   Integer;
        x:   LongWord;
        T:   WideChar;

      Begin
        Result := 1;
        P := Pointer(S);
        {$IF DELPHI >= 2006}
        If __CompareBlock0[Low(__CompareBlock0)] <> #0 Then Begin
          For i := Length(S) - 1 downto 0 do Begin
            Case Word(P^) of
              Ord('*'), Ord('?'), Ord('\'): Begin      Result := 0;  Exit;  End;
              Low(__LowerBlock0)..Ord('\')-1:          Result := (Result shl 4) + Word(__LowerBlock0[Word(P^)]);
              Ord('\')+1        ..High(__LowerBlock0): Result := (Result shl 4) + Word(__LowerBlock0[Word(P^)]);
              Low(__LowerBlock1)..High(__LowerBlock1): Result := (Result shl 4) + Word(__LowerBlock1[Word(P^)]);
              Low(__LowerBlock2)..High(__LowerBlock2): Result := (Result shl 4) + Word(__LowerBlock2[Word(P^)]);
              Low(__LowerBlock3)..High(__LowerBlock3): Result := (Result shl 4) + Word(__LowerBlock3[Word(P^)]);
              Low(__LowerBlock4)..High(__LowerBlock4): Result := (Result shl 4) + Word(__LowerBlock4[Word(P^)]);
              Low(__LowerBlock5)..High(__LowerBlock5): Result := (Result shl 4) + Word(__LowerBlock5[Word(P^)]);
              Low(__LowerBlock6)..High(__LowerBlock6): Result := (Result shl 4) + Word(__LowerBlock6[Word(P^)]);
              Low(__LowerBlock7)..High(__LowerBlock7): Result := (Result shl 4) + Word(__LowerBlock7[Word(P^)]);
              Low(__LowerBlock8)..High(__LowerBlock8): Result := (Result shl 4) + Word(__LowerBlock8[Word(P^)]);
              Low(__LowerBlock9)..High(__LowerBlock9): Result := (Result shl 4) + Word(__LowerBlock9[Word(P^)]);
              Low(__LowerBlockA)..High(__LowerBlockA): Result := (Result shl 4) + Word(__LowerBlockA[Word(P^)]);
              Else                                     Result := (Result shl 4) + Word(P^);
        {$ELSE}
        If TXHelper__CompareBlock0[Low(TXHelper__CompareBlock0)] <> #0 Then Begin
          For i := Length(S) - 1 downto 0 do Begin
            Case Word(P^) of
              Ord('*'), Ord('?'), Ord('\'): Begin                      Result := 0;  Exit;  End;
              Low(TXHelper__LowerBlock0)..Ord('\')-1:                  Result := (Result shl 4) + Word(TXHelper__LowerBlock0[Word(P^)]);
              Ord('\')+1                ..High(TXHelper__LowerBlock0): Result := (Result shl 4) + Word(TXHelper__LowerBlock0[Word(P^)]);
              Low(TXHelper__LowerBlock1)..High(TXHelper__LowerBlock1): Result := (Result shl 4) + Word(TXHelper__LowerBlock1[Word(P^)]);
              Low(TXHelper__LowerBlock2)..High(TXHelper__LowerBlock2): Result := (Result shl 4) + Word(TXHelper__LowerBlock2[Word(P^)]);
              Low(TXHelper__LowerBlock3)..High(TXHelper__LowerBlock3): Result := (Result shl 4) + Word(TXHelper__LowerBlock3[Word(P^)]);
              Low(TXHelper__LowerBlock4)..High(TXHelper__LowerBlock4): Result := (Result shl 4) + Word(TXHelper__LowerBlock4[Word(P^)]);
              Low(TXHelper__LowerBlock5)..High(TXHelper__LowerBlock5): Result := (Result shl 4) + Word(TXHelper__LowerBlock5[Word(P^)]);
              Low(TXHelper__LowerBlock6)..High(TXHelper__LowerBlock6): Result := (Result shl 4) + Word(TXHelper__LowerBlock6[Word(P^)]);
              Low(TXHelper__LowerBlock7)..High(TXHelper__LowerBlock7): Result := (Result shl 4) + Word(TXHelper__LowerBlock7[Word(P^)]);
              Low(TXHelper__LowerBlock8)..High(TXHelper__LowerBlock8): Result := (Result shl 4) + Word(TXHelper__LowerBlock8[Word(P^)]);
              Low(TXHelper__LowerBlock9)..High(TXHelper__LowerBlock9): Result := (Result shl 4) + Word(TXHelper__LowerBlock9[Word(P^)]);
              Low(TXHelper__LowerBlockA)..High(TXHelper__LowerBlockA): Result := (Result shl 4) + Word(TXHelper__LowerBlockA[Word(P^)]);
              Else                                                     Result := (Result shl 4) + Word(P^);
        {$IFEND}
            End;
            x := Result and $F0000000;
            If x <> 0 Then Result := Result xor (x shr 24);
            Result := Result and not x;
            Inc(P);
          End;
        End Else
          // if __CompareBlock's are not can't be initialized
          For i := Length(S) - 1 downto 0 do Begin
            Case Word(P^) of
              Ord('*'), Ord('?'), Ord('\'): Begin
                Result := 0;
                Exit;
              End;
              Else Begin
                T := P^;
                CharLowerBuffW(@T, 1);
                Result := (Result shl 4) + Word(T);
              End;
            End;
            x := Result and $F0000000;
            If x <> 0 Then Result := Result xor (x shr 24);
            Result := Result and not x;
            Inc(P);
          End;
        If Result = 0 Then Dec(Result);
      End;

    Class Function TXHelper.CompareHash(H1, H2: LongWord): Boolean;
      {inline}

      Begin
        Result := (H1 = H2) or (H1 = 0) or (H2 = 0);
      End;

    Class Function TXHelper.SameTextA(Const S1, S2: AnsiString): Boolean;
      {inline}

      Begin
        Result := CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
          Pointer(S1), Length(S1), Pointer(S2), Length(S2)) = CSTR_EQUAL;
      End;

    Class Function TXHelper.SameTextW(Const S1, S2: TWideString; CaseSensitive: Boolean): Boolean;
      Var Flags: LongWord;

      Begin
        If CaseSensitive Then Flags := 0 Else Flags := NORM_IGNORECASE;
        Result := CompareStringW(LOCALE_USER_DEFAULT, Flags,
          Pointer(S1), Length(S1), Pointer(S2), Length(S2)) = CSTR_EQUAL;
      End;

    Class Function TXHelper.SameTextW(Const S1, S2: TWideString; Owner: TXMLFile): Boolean;
      Var Flags: LongWord;

      Begin
        If (Assigned(Owner) and (xoCaseSensitive in Owner.Options))
            or (not Assigned(Owner) and (xoCaseSensitive in TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultOptions)) Then
          Flags := 0 Else Flags := NORM_IGNORECASE;
        Result := CompareStringW(LOCALE_USER_DEFAULT, Flags,
          Pointer(S1), Length(S1), Pointer(S2), Length(S2)) = CSTR_EQUAL;
      End;

    Class Function TXHelper.CompareText(Const S1, S2: TWideString): Integer;
      Begin
        If not Assigned({$IF DELPHI < 2006}TXHelper__StrCmpLogicalW{$ELSE}__StrCmpLogicalW{$IFEND}) Then Begin
          Result := CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE or SORT_STRINGSORT,
            Pointer(S1), Length(S1), Pointer(S2), Length(S2)) - CSTR_EQUAL;
          If Result = 0 Then
            Result := CompareStringW(LOCALE_USER_DEFAULT, SORT_STRINGSORT,
              Pointer(S1), Length(S1), Pointer(S2), Length(S2)) - CSTR_EQUAL;
        End Else
          Result := {$IF DELPHI < 2006}TXHelper__StrCmpLogicalW{$ELSE}__StrCmpLogicalW{$IFEND}(S1, S2) - CSTR_EQUAL;
      End;

    Class Function TXHelper.Pos(Const Sub, S: TWideString): Integer;
      ASM
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        TEST    EDX, EDX
        JE      @@Zero
        TEST    ECX, ECX
        JE      @@Zero
        MOV     ESI, EDX
        MOV     EDI, ECX
        MOV     ECX, [EDI-4]
        {$IFDEF hxDisableUnicodeString}
          SHR   ECX, 1
        {$ENDIF}
        MOV     EDX, [ESI-4]
        {$IFDEF hxDisableUnicodeString}
          SHR   EDX, 1
        {$ENDIF}
        DEC     EDX
        JS      @@Zero
        MOV     AX, [ESI]
        ADD     ESI, 2
        SUB     ECX, EDX
        JLE     @@Zero
        PUSH    EDI

        @@Loop:
        REPNE   SCASW
        JNE     @@Fail
        MOV     EBX, ECX
        PUSH    ESI
        PUSH    EDI
        MOV     ECX, EDX
        REPE    CMPSW
        POP     EDI
        POP     ESI
        JE      @@Found
        MOV     ECX, EBX
        JMP     @@Loop

        @@Fail:
        POP     EDX

        @@Zero:
        XOR     EAX, EAX
        JMP     @@Exit

        @@Found:
        POP     EDX
        MOV     EAX, EDI
        SUB     EAX, EDX
        SHR     EAX, 1

        @@Exit:
        POP     EDI
        POP     ESI
        POP     EBX
      End;

    Class Function TXHelper.MatchText(Const Mask, S: TWideString; CaseSensitive: Boolean): Boolean;
      Var Mp, Me2, Me, Mm, Sp, Se, Sm: PWideChar;
        Mt: TWideString;
        T: Array[0..1] of WideChar;

      Label LMulti, LMask, LElse;

      Begin
        Mp  := PWideChar(Mask);
        Me  := Mp + Length(Mask);
        Me2 := Me;
        Sp  := PWideChar(S);
        Se  := Sp + Length(S);

        LMulti:
        Mm := nil;
        Sm := Se;
        While (Mp < Me2) or (Sp < Se) do Begin
          Case Mp^ of
            '*': Begin
              While Mp^ = '*' do Inc(Mp);
              Mm := Mp;
              Sm := Sp + 1;
              Continue;

              LMask:
              Mp := Mm;
              Sp := Sm;
              Inc(Sm);
              If (Mp < Me2) and (Sp >= Se) Then
                If Me2 < Me Then Begin
                  Inc(Me2);
                  Mp := Me2;
                  Sp := PWideChar(S);
                  While Me2 < Me do
                    Case Me2^ of
                      '\': Case (Me2 + 1)^ of
                             '*', '?', '|', '\': Inc(Me2, 2);
                             Else                Inc(Me2);
                           End;
                      '|': Begin
                             Me2^ := #0;
                             Goto LMulti;
                           End;
                      Else Inc(Me2);
                    End;
                  Goto LMulti;
                End Else Begin
                  Result := False;
                  Exit;
                End;
              Continue;
            End;
            '?': ;
            '|': Begin
                   If (Mt = '') and (Mask <> '') Then Begin
                     Mt := Mask;
                     UniqueString(Mt);
                     Mp := Mp - PWideChar(Mask) + PWideChar(Mt);
                     Me := PWideChar(Mt) + Length(Mask);
                     If Mm <> nil Then Mm := Mm - PWideChar(Mask) + PWideChar(Mt);
                   End;
                   Mp^ := #0;
                   Me2 := Mp;
                   Continue;
                 End;
            '\': Begin
              Case (Mp + 1)^ of  '*', '?', '|', '\': Inc(Mp);  End;
              Goto LElse;
            End;
            Else Begin
              LElse:
              If Mp^ <> Sp^ Then
                If CaseSensitive Then
                  GoTo LMask
                {$IF DELPHI >= 2006}
                Else If __CompareBlock0[Low(__CompareBlock0)] = #0 Then Begin
                  // if __CompareBlock's are not can't be initialized
                  T[0] := Mp^;
                  T[1] := Sp^;
                  CharLowerBuffW(@T, 2);
                  If T[0] <> T[1] Then GoTo LMask;
                End Else
                  Case Word(Mp^) of
                    Low(__CompareBlock0)..High(__CompareBlock0): If __CompareBlock0[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlock1)..High(__CompareBlock1): If __CompareBlock1[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlock2)..High(__CompareBlock2): If __CompareBlock2[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlock3)..High(__CompareBlock3): If __CompareBlock3[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlock4)..High(__CompareBlock4): If __CompareBlock4[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlock5)..High(__CompareBlock5): If __CompareBlock5[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlock6)..High(__CompareBlock6): If __CompareBlock6[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlock7)..High(__CompareBlock7): If __CompareBlock7[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlock8)..High(__CompareBlock8): If __CompareBlock8[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlock9)..High(__CompareBlock9): If __CompareBlock9[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(__CompareBlockA)..High(__CompareBlockA): If __CompareBlockA[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Else GoTo LMask;
                  End
                {$ELSE}
                Else If TXHelper__CompareBlock0[Low(TXHelper__CompareBlock0)] = #0 Then Begin
                  // if __CompareBlock's are not can't be initialized
                  T[0] := Mp^;
                  T[1] := Sp^;
                  CharLowerBuffW(@T, 2);
                  If T[0] <> T[1] Then GoTo LMask;
                End Else
                  Case Word(Mp^) of
                    Low(TXHelper__CompareBlock0)..High(TXHelper__CompareBlock0): If TXHelper__CompareBlock0[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlock1)..High(TXHelper__CompareBlock1): If TXHelper__CompareBlock1[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlock2)..High(TXHelper__CompareBlock2): If TXHelper__CompareBlock2[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlock3)..High(TXHelper__CompareBlock3): If TXHelper__CompareBlock3[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlock4)..High(TXHelper__CompareBlock4): If TXHelper__CompareBlock4[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlock5)..High(TXHelper__CompareBlock5): If TXHelper__CompareBlock5[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlock6)..High(TXHelper__CompareBlock6): If TXHelper__CompareBlock6[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlock7)..High(TXHelper__CompareBlock7): If TXHelper__CompareBlock7[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlock8)..High(TXHelper__CompareBlock8): If TXHelper__CompareBlock8[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlock9)..High(TXHelper__CompareBlock9): If TXHelper__CompareBlock9[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Low(TXHelper__CompareBlockA)..High(TXHelper__CompareBlockA): If TXHelper__CompareBlockA[Word(Mp^)] <> Sp^ Then GoTo LMask;
                    Else GoTo LMask;
                  End
                {$IFEND}
            End;
          End;
          If (Mp >= Me2) or (Sp >= Se) Then GoTo LMask;
          Inc(Mp);
          Inc(Sp);
        End;
        Result := True;
      End;

    Class Function TXHelper.MatchText(Const Mask, S: TWideString; Owner: TXMLFile): Boolean;
      {inline}

      Begin
        Result := MatchText(Mask, S, (Assigned(Owner) and (xoCaseSensitive in Owner.Options))
          or (not Assigned(Owner) and (xoCaseSensitive in TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultOptions)));
      End;

    Class Function TXHelper.Trim(Const S: TWideString): TWideString;
      Var i, i2: Integer;

      Begin
        i2 := Length(S);
        i  := 1;
        While (i <= i2) and (S[i] <= ' ') do Inc(i);
        If i <= i2 Then Begin
          While S[i2] <= ' ' do Dec(i2);
          Result := Copy(S, i, i2 - i + 1);
        End Else Result := '';
      End;

    Class Function TXHelper.ValUInt64(Const S: TWideString; Var i: UInt64): Boolean;
      Var P: PWideChar;

      Begin
        P := PWideChar(S);
        i := 0;
        While P^ = ' ' do Inc(P);
        If (P^ = '$') or (P^ = 'x') or (P^ = 'X')
            or ((P^ = '0') and ((P[1] = 'x') or (P[1] = 'X'))) Then Begin
          If P^ = '0' Then Inc(P, 2) Else Inc(P);
          While True do Begin
            If (i < 0) or (Int64Rec(i).Hi > $0FFFFFFF) Then Break;
            Case P^ of
              '0'..'9': i := i shl 4 or (Word(P^) - Ord('0'));
              'A'..'F': i := i shl 4 or (Word(P^) - Ord('A') + 10);
              'a'..'f': i := i shl 4 or (Word(P^) - Ord('a') + 10);
              Else Break;
            End;
            Inc(P);
          End;
        End Else
          While True do Begin
            If (i < 0) or (i > (High(Int64) div 10)) Then Break;
            Case P^ of
              '0'..'9': i := i * 10 + (Word(P^) - Ord('0'));
              Else Break;
            End;
            Inc(P);
          End;
        Result := PWideChar(S) + Length(S) = P;
      End;

    Class Function TXHelper.BooleanToXML(Const B; Size: Integer): TWideString;
      Begin
        Case Size of
          0: If      Byte(B)     = 0{False} Then Result := DefaultFalseBoolStr
             Else If Byte(B)     = 1{True}  Then Result := DefaultTrueBoolStr
             Else                                Result := Format('$%.2x', [Byte(B)]);
          1: If      Byte(B)     = 0{False} Then Result := DefaultFalseBoolStr
             Else If Byte(B)     = 1{True}  Then Result := DefaultTrueBoolStr
             Else                                Result := Format('$%.2x', [Byte(B)]);
          2: If      Word(B)     = 0{False} Then Result := DefaultFalseBoolStr
             Else If Word(B)     = 1{True}  Then Result := DefaultTrueBoolStr
             Else                                Result := Format('$%.4x', [Word(B)]);
          4: If      LongWord(B) = 0{False} Then Result := DefaultFalseBoolStr
             Else If LongWord(B) = 1{True}  Then Result := DefaultTrueBoolStr
             Else                                Result := Format('$%.8x', [LongWord(B)]);
        End;
      End;

    Class Function TXHelper.isXMLBoolean(S: TWideString {; Size: Integer}): Boolean;
      //Var i: Integer;

      Begin
        S      := Trim(S);
        Result := SameTextW(S, DefaultTrueBoolStr, True) or SameTextW(S, DefaultFalseBoolStr, True);
        //If not Result and TryStrToInt(String(S), i) Then
        //  Case Size of
        //    1: Result := (i >= 0) and (i <= $FF);
        //    2: Result := (i >= 0) and (i <= $FFFF);
        //    4: Result := {$IF SizeOf(Integer) > 4} (i >= 0) and (i <= $FFFFFFFF) {$ELSE} True {$IFEND};
        //  End;
      End;

    Class Procedure TXHelper.XMLToBoolean(S: TWideString; Size: Integer; Var Result);
      Var i: Integer;

      Begin
        S := Trim(S);
        If SameTextW(S, DefaultTrueBoolStr, True) Then Begin
          Case Size of
            0: Boolean(Result)  := True;
            1: ByteBool(Result) := True;
            2: WordBool(Result) := True;
            4: LongBool(Result) := True;
          End;
        End Else If SameTextW(S, DefaultFalseBoolStr, True) Then Begin
          Case Size of
            0: Boolean(Result)  := False;
            1: ByteBool(Result) := False;
            2: WordBool(Result) := False;
            4: LongBool(Result) := False;
          End;
        End Else Begin
          i := StrToIntDef(String(S), Ord(True));
          Case Size of
            0, 1: Byte(Result)  := i;
            2: Word(Result)     := i;
            4: LongWord(Result) := i;
          End;
        End;
      End;

    Class Function TXHelper.DateTimeToXML(Const D: TDateTime; Option: Integer): TWideString;
      Begin
        If Option and 1 = 1 {Date} Then Result := 'yyyy-mm-dd' Else Result := '';
        If Option and 2 = 2 {Time} Then Result := Result + '"T"hh-nn-ss';
        If Option and 6 = 6 {Time+mSec} Then Result := Result + '.zzz';
        Result := FormatDateTime(Result, D);
      End;

    Class Function TXHelper.isXMLDateTime(Const S: TWideString): Boolean;
      Var P, i, i2, i3: Integer;
        D:              TDateTime;

      Begin
        P := 0;
        If (Length(S) >= P + 10) and (S[P + 5] = '-') and (S[P + 8] = '-')
            and TryStrToInt(Copy(S, P + 1, 4), i) and TryStrToInt(Copy(S, P + 6, 2), i2)
            and TryStrToInt(Copy(S, P + 9, 2), i3) and TryEncodeDate(i, i2, i3, D) Then
          Inc(P, 10);
        If (Length(S) >= P + 9) and (S[P + 1] = 'T') and (((S[P + 4] = '-') and (S[P + 7] = '-'))
            or ((S[P + 4] = ':') and (S[P + 7] = ':')))
            and TryStrToInt(Copy(S, P + 2, 2), i) and TryStrToInt(Copy(S, P + 5, 2), i2)
            and TryStrToInt(Copy(S, P + 8, 2), i3) and TryEncodeTime(i, i2, i3, 0, D) Then
          Inc(P, 9);
        If (Length(S) >= P + 4) and (S[P + 1] = '.') and TryStrToInt(Copy(S, P + 2, 3), i) Then
          Inc(P, 4);
        If (Length(S) >= P + 1) and (S[P + 1] = 'Z') Then
          Inc(P);
        Result := (S <> '') and (Length(S) = P);
      End;

    Class Function TXHelper.XMLToDateTime(Const S: TWideString): TDateTime;
      Var P, i, i2, i3: Integer;
        D:              TDateTime;

      Begin
        Result := 0;
        P := 0;
        If (Length(S) >= P + 10) and (S[P + 5] = '-') and (S[P + 8] = '-')
            and TryStrToInt(Copy(S, P + 1, 4), i) and TryStrToInt(Copy(S, P + 6, 2), i2)
            and TryStrToInt(Copy(S, P + 9, 2), i3) and TryEncodeDate(i, i2, i3, D) Then Begin
          Inc(P, 10);
          Result := D;
        End;
        If (Length(S) >= P + 9) and (S[P + 1] = 'T') and (((S[P + 4] = '-') and (S[P + 7] = '-'))
            or ((S[P + 4] = ':') and (S[P + 7] = ':')))
            and TryStrToInt(Copy(S, P + 2, 2), i) and TryStrToInt(Copy(S, P + 5, 2), i2)
            and TryStrToInt(Copy(S, P + 8, 2), i3) and TryEncodeTime(i, i2, i3, 0, D) Then Begin
          Inc(P, 9);
          Result := Result + D;
        End;
        If (Length(S) >= P + 4) and (S[P + 1] = '.') and TryStrToInt(Copy(S, P + 2, 3), i) Then Begin
          Inc(P, 4);
          Result := Result + (i / (24*60*60*1000));
        End;
        If (Length(S) >= P + 1) and (S[P + 1] = 'Z') Then
          Inc(P);
        If (S = '') or (Length(S) <> P) Then
          Raise EXMLException.Create(Self, 'XMLToDateTime', @SCorupptedDateTime, Copy(S, P + 1, 20));
      End;

    Class Function TXHelper.VariantToXML(Const V: Variant): TWideString;
      Begin
        Case TVarData(V).VType of
          varEmpty:                             Result := '';
          varNull:                              Result := '[[NULL]]';
          varShortInt, varShortInt or varByRef,
          varSmallInt, varSmallInt or varByRef,
          varInteger,  varInteger  or varByRef,
          varInt64,    varInt64    or varByRef,
          varByte,     varByte     or varByRef,
          varWord,     varWord     or varByRef,
          varLongWord, varLongWord or varByRef,
          varSingle,   varSingle   or varByRef,
          varDouble,   varDouble   or varByRef,
          varCurrency, varCurrency or varByRef,
          varOleStr,   varOleStr   or varByRef,
          varString,   varString   or varByRef: Result := V;
          varError,    varError    or varByRef: Result := Format('$%.8x', [HRESULT(V)]);
          varDate,     varDate     or varByRef: Result := DateTimeToXML(TDateTime(V), 7{Date|Time|mSec});
          varBoolean:                           Result := BooleanToXML(TVarData(V).VBoolean, 2);
          varBoolean  or varByRef:              Result := BooleanToXML(PWordBool(TVarData(V).VPointer)^, 2);
          {$IF Declared(varUInt64)}
          varUInt64:                            If Int64(TVarData(V).VUInt64) < 0 Then
                                                 Result := Format('$%.16x', [Int64(TVarData(V).VUInt64)])
                                                Else Result := Format('%d', [Int64(TVarData(V).VUInt64)]);
          varUInt64 or varByRef:                If PInt64(TVarData(V).VPointer)^ < 0 Then
                                                  Result := Format('$%.16x', [PInt64(TVarData(V).VPointer)^])
                                                Else Result := Format('%d', [PInt64(TVarData(V).VPointer)^]);
          {$IFEND}
          {$IF Declared(UnicodeString)}
          varUString,  varUString  or varByRef: Result := V;
          {$IFEND}

          Else Raise EXMLException.Create(Self, 'VariantToXML', @SNotImplemented,
            Format('TVarType(%d)', [Ord(TVarData(V).VType)]));
        End;
      End;

    Class Procedure TXHelper.XMLToVariant(Const S: TWideString; Var Result: Variant);
      Var S2: TWideString;
        {$IF Declared(varUInt64)} W: UInt64; {$IFEND}
        B: WordBool;

      Begin
        S2 := Trim(S);
        If S = '' Then VarClear(Result)
        Else If S2 = '[[NULL]]' Then Result := Variants.Null
        {$IF Declared(varUInt64)}
        Else If (Length(S2) = 17) and (S2[1] = '$') and ValUInt64(S2, W) Then Result := W
        {$IFEND}
        Else If isXMLBoolean(S2)  Then Begin
          XMLToBoolean(S2, 2, B);
          Result := B;
        End Else If isXMLDateTime(S2) Then Result := XMLToDateTime(S2)
        Else Result := S;
      End;

    Class Function TXHelper.isChar(C: WideChar): Boolean;
      {inline}

      Begin
        Case C of
          #$09, #$0A, #$0D, #$20..#$007E, #$0085, #$00A0..#$D7FF, #$E000..#$FDCF, #$FDE0..#$FFFD: Result := True;
          Else Result := False;
        End;
      End;

    Class Function TXHelper.isSpace(C: WideChar): Boolean;
      {inline}

      Begin
        Case C of
          #$0D, #$0A, #$0085, #$2028,  // line feeds
          #$20, #$09: Result := True;
          Else Result := False;
        End;
      End;

    Class Function TXHelper.isAlpha(C: WideChar): Boolean;
      {inline}

      Begin
        Case C of
          'A'..'Z', 'a'..'z': Result := True;
          Else Result := False;
        End;
      End;

    Class Function TXHelper.isAlphaNum(C: WideChar): Boolean;
      {inline}

      Begin
        Case C of
          'A'..'Z', 'a'..'z', '0'..'9', '-', '.', '_': Result := True;
          Else Result := False;
        End;
      End;

    Class Function TXHelper.isNum(C: WideChar): Boolean;
      {inline}

      Begin
        Case C of
          '0'..'9': Result := True;
          Else Result := False;
        End;
      End;

    Class Function TXHelper.isHex(C: WideChar): Boolean;
      {inline}

      Begin
        Case C of
          '0'..'9', 'a'..'f', 'A'..'F': Result := True;
          Else Result := False;
        End;
      End;

    Class Function TXHelper.isNameStart(C: WideChar): Boolean;
      {inline}

      Begin
        Case C of
          '_', ':', 'A'..'Z', 'a'..'z', #$00C0..#$00D6, #$00D8..#$00F6, #$00F8..#$02FF, #$0370..#$037D, #$037F..#$1FFF, #$200C..#$200D, #$2070..#$218F, #$2C00..#$2FEF, #$3001..#$D7FF, #$F900..#$FDCF, #$FDF0..#$FFFD: Result := True;
          Else Result := False;
        End;
      End;

  //Class Function TXHelper.isNameStartEx(C: WideChar): Boolean;
  //  {inline}
  //
  //  Begin
  //    Case C of
  //      '_', ':', 'A'..'Z', 'a'..'z', #$00C0..#$00D6, #$00D8..#$00F6, #$00F8..#$02FF, #$0370..#$037D, #$037F..#$1FFF, #$200C..#$200D, #$2070..#$218F, #$2C00..#$2FEF, #$3001..#$D7FF, #$F900..#$FDCF, #$FDF0..#$FFFD,
  //      '-', '.', '0'..'9': Result := True;
  //      Else Result := False;
  //    End;
  //  End;

    Class Function TXHelper.isName(C: WideChar): Boolean;
      {inline}

      Begin
        Case C of
          '_', ':', 'A'..'Z', 'a'..'z', #$00C0..#$00D6, #$00D8..#$00F6, #$00F8..#$02FF, #$0370..#$037D, #$037F..#$1FFF, #$200C..#$200D, #$2070..#$218F, #$2C00..#$2FEF, #$3001..#$D7FF, #$F900..#$FDCF, #$FDF0..#$FFFD,
          '-', '.', '0'..'9', #$00B7, #$0300..#$036F, #$203F..#$2040: Result := True;
          Else Result := False;
        End;
      End;

    Class Function TXHelper.CheckString(Const S: TWideString; CType: TXMLStringCheckType): Boolean;
      Var i: Integer;
        P:   PWideChar;
        B:   Boolean;

      Begin
        Case CType of
          xtInstruction_NodeName, xtTypedef_NodeName, xtElement_NodeName, xtAttribute_Name: Begin
            P      := PWideChar(S);
            Result := (S <> '') and isNameStart(P^) and (S[Length(S)] <> ':');
            B      := (S <> '') and (P^ = ':');
            For i := Length(S) - 2 downto 0 do Begin
              Inc(P);
              If P^ = ':' Then Begin
                If B Then Result := False Else B := True;
              End Else If not isName(P^) Then Result := False;
            End;
          End;
          xtInstruction_VersionValue: Begin
            Result := (S <> '');
            For i := Length(S) - 1 downto 0 do
              If not isAlphaNum(S[i + 1]) Then Result := False;
          End;
          xtInstruction_EncodingValue: Begin
            Result := (S <> '') and isAlpha(S[1]);
            For i := Length(S) - 2 downto 0 do
              If not isAlphaNum(S[i + 2]) Then Result := False;
          End;
          xtInstruction_StandaloneValue:
            Result := MatchText('yes|no', S, False);
          //xtTypedef_NodeName    > xtInstruction_NodeName
          //xtTypedef_SetText     > ConvertString
          //xtTypedef_GetText     > ConvertString
          //xtTypedef_LoadText    > ConvertString
          //xtTypedef_SaveText    > ConvertString
          //xtElement_NodeName    > xtInstruction_NodeName
          //xtElement_SetText     > ConvertString
          //xtElement_GetText     > ConvertString
          //xtElement_LoadText    > ConvertString
          //xtElement_SaveText    > ConvertString
          //xtCData_SetText       > ConvertString
          //xtCData_GetText       > ConvertString
          //xtCData_LoadText      > ConvertString
          //xtCData_SaveText      > ConvertString
          //xtComment_SetText     > ConvertString
          //xtComment_GetText     > ConvertString
          //xtComment_LoadText    > ConvertString
          //xtComment_SaveText    > ConvertString
          //xtAttribute_Name      > xtInstruction_NodeName
          //xtAttribute_SetValue  > ConvertString
          //xtAttribute_GetValue  > ConvertString
          //xtAttribute_LoadValue > ConvertString
          //xtAttribute_SaveValue > ConvertString
          Else Raise EXMLException.Create(Self, 'CheckString', @SInternalError, 1);
        End;
      End;

    Class Function TXHelper.ConvertString(Var S: TWideString; CType: TXMLStringCheckType;
        Options: TXMLOptions; Const LineFeed, TextIndent, ValueQuotation: TWideString): Boolean;

      Const HexDecode: Array[Ord('0')..Ord('f')] of Byte = (0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,10,11,12,13,14,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,11,12,13,14,15);

      Var i, i2:   Integer;
        B, B2, B3: Boolean;

      Label ElementLoadNormalize;

      Function _CompChar2(P1: PWideChar; Const P2: TWideString): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Begin
          Result := PLongInt(P1)^ = PLongInt(@P2[1])^;
        End;

      Function _CompChar4(P1: PWideChar; Const P2: TWideString): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Begin
          Result := PInt64(P1)^ = PInt64(@P2[1])^;
        End;

      Function _CompChar6(P1: PWideChar; Const P2: TWideString): Boolean; {$IFNDEF hxDontUseInline}Inline;{$ENDIF}
        Begin
          Result := (PInt64(P1)^ = PInt64(@P2[1])^)
              and ((PLongInt(P1 + 4)^ = PLongInt(@P2[5])^));
        End;

      Begin
        {$IF DELPHI >= 2006}
          EnterCriticalSection(__LockCArr);
          Try
            Result := True;
            Case CType of
              //xtInstruction_NodeName        > CheckString
              //xtInstruction_VersionValue    > CheckString
              //xtInstruction_EncodingValue   > CheckString
              //xtInstruction_StandaloneValue > CheckString
              //xtTypedef_NodeName            > CheckString
              xtTypedef_SetText: Begin
                // B=[   B2="   B3='
                B  := False;
                B2 := False;
                B3 := False;
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    '[':            If not (B2 or B3) Then
                                      If B Then Result := False Else B := True;
                    ']':            If not (B2 or B3) Then
                                      If (__CArr.Pos <> Length(S)) or not B Then Result := False Else B := False;
                    '=':            ;
                    '"':            If not B3 Then B2 := not B2;
                    '''':           If not B2 Then B3 := not B3;
                    '<', '>':       If not (B or B2 or B3) Then Result := False;
                    #$0D:           If ((__CArr.P + 1)^ = #$0A) or ((__CArr.P + 1)^ = #$0085) Then
                                      __CArr.Add(2, #$0A) Else __CArr.Add(1, #$0A);
                    #$0085, #$2028: __CArr.Add(1, #$0A);
                  End;
                  __CArr.Inc;
                End;
                If B or B2 or B3 Then Result := False;
                __CArr.Finalize;
              End;
              xtTypedef_GetText, xtComment_GetText: Begin
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  If __CArr.P^ = #$0A Then __CArr.Add(1, LineFeed);
                  __CArr.Inc;
                End;
                __CArr.Finalize;
              End;
              xtTypedef_LoadText, xtCData_LoadText, xtComment_LoadText: Begin
                Result := True;
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    #$0D:           If ((__CArr.P + 1)^ = #$0A) or ((__CArr.P + 1)^ = #$0085) Then __CArr.Add(2, #$0A) Else __CArr.Add(1, #$0A);
                    #$0085, #$2028: __CArr.Add(1, #$0A);
                    Else            If not isChar(__CArr.P^) Then Begin
                                      __CArr.Add(1, Format('#%d;', [Word(__CArr.P^)]));
                                      If not (xoChangeInvalidChars in Options) Then Result := False;
                                    End;
                  End;
                  __CArr.Inc;
                End;
                __CArr.Finalize;
              End;
              xtTypedef_SaveText, xtElement_SaveText, xtCData_SaveText, xtComment_SaveText: Begin
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  If __CArr.P^ = #$0A Then __CArr.Add(1, LineFeed);
                  __CArr.Inc;
                End;
                __CArr.Finalize;
                Result := True;
              End;
              //xtElement_NodeName > CheckString
              xtElement_SetText: Begin
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    '<':            __CArr.Add(1, '&lt;');
                    '>':            __CArr.Add(1, '&gt;');
                    '"':            __CArr.Add(1, '&quot;');
                    '''':           __CArr.Add(1, '&apos;');
                    '&':            __CArr.Add(1, '&amp;');
                    #$0D:           If ((__CArr.P + 1)^ = #$0A) or ((__CArr.P + 1)^ = #$0085) Then
                                      __CArr.Add(2, #$0A) Else __CArr.Add(1, #$0A);
                    #$0085, #$2028: __CArr.Add(1, #$0A);
                    Else            If not isChar(__CArr.P^) Then Begin
                                      __CArr.Add(1, Format('#%d;', [Word(__CArr.P^)]));
                                      If not (xoChangeInvalidChars in Options) Then Result := False;
                                    End;
                  End;
                  __CArr.Inc;
                End;
                __CArr.Finalize;
              End;
              xtElement_GetText, xtAttribute_GetValue: Begin
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    '&':  If      (__CArr.Pos + 3 <= Length(S)) and _CompChar4(__CArr.P,   '&lt;')   Then __CArr.Add(4, '<')
                          Else If (__CArr.Pos + 3 <= Length(S)) and _CompChar4(__CArr.P,   '&gt;')   Then __CArr.Add(4, '>')
                          Else If (__CArr.Pos + 5 <= Length(S)) and _CompChar6(__CArr.P,   '&quot;') Then __CArr.Add(6, '"')
                          Else If (__CArr.Pos + 5 <= Length(S)) and _CompChar6(__CArr.P,   '&apos;') Then __CArr.Add(6, '''')
                          Else If (__CArr.Pos + 4 <= Length(S)) and _CompChar4(__CArr.P + 1, 'amp;') Then __CArr.Add(5, '&')
                          Else If (__CArr.Pos + 4 <= Length(S)) and _CompChar2(__CArr.P + 1, '#x')   Then Begin
                            i  := 3;
                            i2 := 0;
                            While isHex(__CArr.P[i]) do Begin
                              i2 := (i2 shl 8) or HexDecode[Word(__CArr.P[i])];
                              Inc(i);
                            End;
                            If (i in [4..7]) and (__CArr.P[i] = ';') Then __CArr.Add(i + 1, WideChar(i2));
                          End Else If (__CArr.Pos + 4 <= Length(S)) and ((__CArr.P + 1)^ = '#') Then Begin
                            i  := 2;
                            i2 := 0;
                            While isNum(__CArr.P[i]) do Begin
                              i2 := (i2 * 10) + (Word(__CArr.P[i]) - Word('0'));
                              Inc(i);
                            End;
                            If (i in [3..7]) and (__CArr.P[i] = ';') Then __CArr.Add(i + 1, WideChar(i2));
                          End;
                    #$0A: __CArr.Add(1, LineFeed);
                  End;
                  __CArr.Inc;
                End;
                __CArr.Finalize;
              End;
              xtElement_LoadText, xtAttribute_LoadValue: Begin
                Result := True;
                __CArr.Initialize(S);
                If xoNormalizeText in Options Then Begin
                  i := 0;
                  While (__CArr.Pos + i <= Length(S)) and TXHelper.isSpace((__CArr.P + i)^) do Inc(i);
                  If i > 0 Then __CArr.Add(i, '');
                End;
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    #$0A: If xoNormalizeText in Options Then Goto ElementLoadNormalize;
                    #$0D: Begin
                      If xoNormalizeText in Options Then Goto ElementLoadNormalize;
                      If ((__CArr.P + 1)^ = #$0A) or ((__CArr.P + 1)^ = #$0085) Then __CArr.Add(2, #$0A) Else __CArr.Add(1, #$0A);
                    End;
                    #$0085, #$2028: Begin
                      If xoNormalizeText in Options Then Goto ElementLoadNormalize;
                      __CArr.Add(1, #$0A)
                    End;
                    Else If not isChar(__CArr.P^) Then Begin
                      __CArr.Add(1, Format('#%d;', [Word(__CArr.P^)]));
                      If not (xoChangeInvalidChars in Options) Then Result := False;
                    End;
                  End;
                  __CArr.Inc;
                  Continue;

                  ElementLoadNormalize:
                  i := 1;
                  While (__CArr.Pos - i > 0) and TXHelper.isSpace((__CArr.P - i)^) do Inc(i);
                  Dec(__CArr._P,   i - 1);
                  Dec(__CArr._Pos, i - 1);
                  While (__CArr.Pos + i <= Length(S)) and TXHelper.isSpace((__CArr.P + i)^) do Inc(i);
                  __CArr.Add(i, #$0A);
                  __CArr.Inc;
                End;
                If (S <> '') and (xoNormalizeText in Options) and TXHelper.isSpace((__CArr.P - 1)^) Then
                  If (__CArr._Len = 0) or (__CArr._Data[__CArr._Len - 1].Pos
                      + __CArr._Data[__CArr._Len - 1].Len < Length(S)) Then Begin
                    i := 1;
                    While (__CArr.Pos - i > 0) and TXHelper.isSpace((__CArr.P - i)^) do Inc(i);
                    Dec(__CArr._P,   i - i);
                    Dec(__CArr._Pos, i - i);
                    __CArr.Add(i, '');
                  End Else __CArr._Data[__CArr._Len - 1].S := '';
                __CArr.Finalize;
              End;
              //xtElement_SaveText > xtTypedef_SaveText
              xtCData_SetText: Begin
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    '>':            If (__CArr.Pos >= 3) and _CompChar2(__CArr.P - 2, ']]') Then
                                      If xoChangeInvalidChars in Options Then __CArr.Add(1, '&gt;')
                                      Else Result := False;
                    #$0D:           If ((__CArr.P + 1)^ = #$0A) or ((__CArr.P + 1)^ = #$0085) Then
                                      __CArr.Add(2, #$0A) Else __CArr.Add(1, #$0A);
                    #$0085, #$2028: If xoChangeInvalidChars in Options Then
                                      __CArr.Add(1, Format('#%d;', [Word(__CArr.P^)]))
                                    Else Result := False;
                    Else            If not isChar(__CArr.P^) Then
                                      If xoChangeInvalidChars in Options Then
                                        __CArr.Add(1, Format('#%d;', [Word(__CArr.P^)]))
                                      Else Result := False;
                  End;
                  __CArr.Inc;
                End;
                __CArr.Finalize;
              End;
              xtCData_GetText: Begin
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    '&':  If xoChangeInvalidChars in Options Then
                            If (__CArr.Pos + 5 <= Length(S)) and _CompChar6(__CArr.P, ']]&gt;') Then
                              __CArr.Add(6, ']]>')
                            Else If (__CArr.Pos + 4 <= Length(S)) and _CompChar2(__CArr.P + 1, '#x')   Then Begin
                              i  := 3;
                              i2 := 0;
                              While isHex(__CArr.P[i]) do Begin
                                i2 := (i2 shl 8) or HexDecode[Word(__CArr.P[i])];
                                Inc(i);
                              End;
                              If (i in [4..7]) and (__CArr.P[i] = ';') and not isChar(WideChar(i2)) Then
                                __CArr.Add(i + 1, WideChar(i2));
                            End Else If (__CArr.Pos + 4 <= Length(S)) and ((__CArr.P + 1)^ = '#') Then Begin
                              i  := 2;
                              i2 := 0;
                              While isNum(__CArr.P[i]) do Begin
                                i2 := (i2 * 10) + (Word(__CArr.P[i]) - Ord('0'));
                                Inc(i);
                              End;
                              If (i in [3..7]) and (__CArr.P[i] = ';') and not isChar(WideChar(i2)) Then
                                __CArr.Add(i + 1, WideChar(i2));
                            End;
                    #$0A: __CArr.Add(1, LineFeed);
                  End;
                  __CArr.Inc;
                End;
                __CArr.Finalize;
              End;
              //xtCData_LoadText > xtTypedef_LoadText
              //xtCData_SaveText > xtTypedef_SaveText
              xtComment_SetText: Begin
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    '>':            If (__CArr.Pos >= 3) and _CompChar2(__CArr.P - 2, '--') Then
                                      __CArr.Add(1, '&gt;');
                    #$0D:           If ((__CArr.P + 1)^ = #$0A) or ((__CArr.P + 1)^ = #$0085) Then
                                      __CArr.Add(2, #$0A) Else __CArr.Add(1, #$0A);
                    #$0085, #$2028: __CArr.Add(1, #$0A);
                    Else            If not isChar(__CArr.P^) Then Result := False;
                  End;
                  __CArr.Inc;
                End;
                If S = '' Then __CArr.Add(0, '');
                __CArr.Finalize;
              End;
              //xtComment_GetText  > xtTypedef_GetText
              //xtComment_LoadText > xtTypedef_LoadText
              //xtComment_SaveText > xtTypedef_SaveText
              //xtAttribute_Name   > CheckString
              xtAttribute_SetValue: Begin
                __CArr.Initialize(S);
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    '<':            __CArr.Add(1, '&lt;');
                    '>':            __CArr.Add(1, '&gt;');
                    '&':            __CArr.Add(1, '&amp;');
                    #$0D:           If ((__CArr.P + 1)^ = #$0A) or ((__CArr.P + 1)^ = #$0085) Then
                                      __CArr.Add(2, #$0A) Else __CArr.Add(1, #$0A);
                    #$0085, #$2028: __CArr.Add(1, #$0A);
                    Else            If not isChar(__CArr.P^) Then Begin
                                      __CArr.Add(1, Format('#%d;', [Word(__CArr.P^)]));
                                      If not (xoChangeInvalidChars in Options) Then Result := False;
                                    End;
                  End;
                  __CArr.Inc;
                End;
                __CArr.Finalize;
              End;
              //xtAttribute_GetValue  > xtElement_GetText
              //xtAttribute_LoadValue > xtElement_LoadText
              xtAttribute_SaveValue: Begin
                __CArr.Initialize(S);
                __CArr.Add(0, ValueQuotation);
                While __CArr.Pos <= Length(S) do Begin
                  Case __CArr.P^ of
                    #$0A: __CArr.Add(1, LineFeed);
                    '"':  __CArr.Add(1, '&quot;');
                    '''': If ValueQuotation <> '"' Then __CArr.Add(1, '&apos;');
                  End;
                  __CArr.Inc;
                End;
                __CArr.Add(0, ValueQuotation);
                __CArr.Finalize;
                Result := True;
              End;
              Else Raise EXMLException.Create(Self, 'ConvertString', @SInternalError, 1);
            End;
          Finally
            LeaveCriticalSection(__LockCArr);
          End;
        {$ELSE}
          EnterCriticalSection(TXHelper__LockCArr);
          Try
            Result := True;
            Case CType of
              //xtInstruction_NodeName        > CheckString
              //xtInstruction_VersionValue    > CheckString
              //xtInstruction_EncodingValue   > CheckString
              //xtInstruction_StandaloneValue > CheckString
              //xtTypedef_NodeName            > CheckString
              xtTypedef_SetText: Begin
                // B=[   B2="   B3='
                B  := False;
                B2 := False;
                B3 := False;
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    '[':            If not (B2 or B3) Then
                                      If B Then Result := False Else B := True;
                    ']':            If not (B2 or B3) Then
                                      If (TXHelper__CArr.Pos <> Length(S)) or not B Then Result := False Else B := False;
                    '=':            ;
                    '"':            If not B3 Then B2 := not B2;
                    '''':           If not B2 Then B3 := not B3;
                    '<', '>':       If not (B or B2 or B3) Then Result := False;
                    #$0D:           If ((TXHelper__CArr.P + 1)^ = #$0A) or ((TXHelper__CArr.P + 1)^ = #$0085) Then
                                      TChangeArray_Add(TXHelper__CArr, 2, #$0A) Else TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    #$0085, #$2028: TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                If B or B2 or B3 Then Result := False;
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              xtTypedef_GetText, xtComment_GetText: Begin
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  If TXHelper__CArr.P^ = #$0A Then TChangeArray_Add(TXHelper__CArr, 1, LineFeed);
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              xtTypedef_LoadText, xtCData_LoadText, xtComment_LoadText: Begin
                Result := True;
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    #$0D:           If ((TXHelper__CArr.P + 1)^ = #$0A) or ((TXHelper__CArr.P + 1)^ = #$0085) Then TChangeArray_Add(TXHelper__CArr, 2, #$0A) Else TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    #$0085, #$2028: TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    Else            If not isChar(TXHelper__CArr.P^) Then Begin
                                      TChangeArray_Add(TXHelper__CArr, 1, Format('#%d;', [Word(TXHelper__CArr.P^)]));
                                      If not (xoChangeInvalidChars in Options) Then Result := False;
                                    End;
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              xtTypedef_SaveText, xtElement_SaveText, xtCData_SaveText, xtComment_SaveText: Begin
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  If TXHelper__CArr.P^ = #$0A Then TChangeArray_Add(TXHelper__CArr, 1, LineFeed);
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                TChangeArray_Finalize(TXHelper__CArr);
                Result := True;
              End;
              //xtElement_NodeName > CheckString
              xtElement_SetText: Begin
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    '<':            TChangeArray_Add(TXHelper__CArr, 1, '&lt;');
                    '>':            TChangeArray_Add(TXHelper__CArr, 1, '&gt;');
                    '"':            TChangeArray_Add(TXHelper__CArr, 1, '&quot;');
                    '''':           TChangeArray_Add(TXHelper__CArr, 1, '&apos;');
                    '&':            TChangeArray_Add(TXHelper__CArr, 1, '&amp;');
                    #$0D:           If ((TXHelper__CArr.P + 1)^ = #$0A) or ((TXHelper__CArr.P + 1)^ = #$0085) Then
                                      TChangeArray_Add(TXHelper__CArr, 2, #$0A) Else TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    #$0085, #$2028: TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    Else            If not isChar(TXHelper__CArr.P^) Then Begin
                                      TChangeArray_Add(TXHelper__CArr, 1, Format('#%d;', [Word(TXHelper__CArr.P^)]));
                                      If not (xoChangeInvalidChars in Options) Then Result := False;
                                    End;
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              xtElement_GetText, xtAttribute_GetValue: Begin
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    '&':  If      (TXHelper__CArr.Pos + 3 <= Length(S)) and _CompChar4(TXHelper__CArr.P,   '&lt;')   Then TChangeArray_Add(TXHelper__CArr, 4, '<')
                          Else If (TXHelper__CArr.Pos + 3 <= Length(S)) and _CompChar4(TXHelper__CArr.P,   '&gt;')   Then TChangeArray_Add(TXHelper__CArr, 4, '>')
                          Else If (TXHelper__CArr.Pos + 5 <= Length(S)) and _CompChar6(TXHelper__CArr.P,   '&quot;') Then TChangeArray_Add(TXHelper__CArr, 6, '"')
                          Else If (TXHelper__CArr.Pos + 5 <= Length(S)) and _CompChar6(TXHelper__CArr.P,   '&apos;') Then TChangeArray_Add(TXHelper__CArr, 6, '''')
                          Else If (TXHelper__CArr.Pos + 4 <= Length(S)) and _CompChar4(TXHelper__CArr.P + 1, 'amp;') Then TChangeArray_Add(TXHelper__CArr, 5, '&')
                          Else If (TXHelper__CArr.Pos + 4 <= Length(S)) and _CompChar2(TXHelper__CArr.P + 1, '#x')   Then Begin
                            i  := 3;
                            i2 := 0;
                            While isHex(TXHelper__CArr.P[i]) do Begin
                              i2 := (i2 shl 8) or HexDecode[Word(TXHelper__CArr.P[i])];
                              Inc(i);
                            End;
                            If (i in [4..7]) and (TXHelper__CArr.P[i] = ';') Then TChangeArray_Add(TXHelper__CArr, i + 1, WideChar(i2));
                          End Else If (TXHelper__CArr.Pos + 4 <= Length(S)) and ((TXHelper__CArr.P + 1)^ = '#') Then Begin
                            i  := 2;
                            i2 := 0;
                            While isNum(TXHelper__CArr.P[i]) do Begin
                              i2 := (i2 * 10) + (Word(TXHelper__CArr.P[i]) - Word('0'));
                              Inc(i);
                            End;
                            If (i in [3..7]) and (TXHelper__CArr.P[i] = ';') Then TChangeArray_Add(TXHelper__CArr, i + 1, WideChar(i2));
                          End;
                    #$0A: TChangeArray_Add(TXHelper__CArr, 1, LineFeed);
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              xtElement_LoadText, xtAttribute_LoadValue: Begin
                Result := True;
                TChangeArray_Initialize(TXHelper__CArr, S);
                If xoNormalizeText in Options Then Begin
                  i := 0;
                  While (TXHelper__CArr.Pos + i <= Length(S)) and TXHelper.isSpace((TXHelper__CArr.P + i)^) do Inc(i);
                  If i > 0 Then TChangeArray_Add(TXHelper__CArr, i, '');
                End;
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    #$0A: If xoNormalizeText in Options Then Goto ElementLoadNormalize;
                    #$0D: Begin
                      If xoNormalizeText in Options Then Goto ElementLoadNormalize;
                      If ((TXHelper__CArr.P + 1)^ = #$0A) or ((TXHelper__CArr.P + 1)^ = #$0085) Then TChangeArray_Add(TXHelper__CArr, 2, #$0A) Else TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    End;
                    #$0085, #$2028: Begin
                      If xoNormalizeText in Options Then Goto ElementLoadNormalize;
                      TChangeArray_Add(TXHelper__CArr, 1, #$0A)
                    End;
                    Else If not isChar(TXHelper__CArr.P^) Then Begin
                      TChangeArray_Add(TXHelper__CArr, 1, Format('#%d;', [Word(TXHelper__CArr.P^)]));
                      If not (xoChangeInvalidChars in Options) Then Result := False;
                    End;
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                  Continue;

                  ElementLoadNormalize:
                  i := 1;
                  While (TXHelper__CArr.Pos - i > 0) and TXHelper.isSpace((TXHelper__CArr.P - i)^) do Inc(i);
                  Dec(TXHelper__CArr.P,   i - 1);
                  Dec(TXHelper__CArr.Pos, i - 1);
                  While (TXHelper__CArr.Pos + i <= Length(S)) and TXHelper.isSpace((TXHelper__CArr.P + i)^) do Inc(i);
                  TChangeArray_Add(TXHelper__CArr, i, #$0A);
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                If (S <> '') and (xoNormalizeText in Options) and TXHelper.isSpace((TXHelper__CArr.P - 1)^) Then
                  If (TXHelper__CArr.Len = 0) or (TXHelper__CArr.Data[TXHelper__CArr.Len - 1].Pos
                      + TXHelper__CArr.Data[TXHelper__CArr.Len - 1].Len < Length(S)) Then Begin
                    i := 1;
                    While (TXHelper__CArr.Pos - i > 0) and TXHelper.isSpace((TXHelper__CArr.P - i)^) do Inc(i);
                    Dec(TXHelper__CArr.P,   i - i);
                    Dec(TXHelper__CArr.Pos, i - i);
                    TChangeArray_Add(TXHelper__CArr, i, '');
                  End Else TXHelper__CArr.Data[TXHelper__CArr.Len - 1].S := '';
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              //xtElement_SaveText > xtTypedef_SaveText
              xtCData_SetText: Begin
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    '>':            If (TXHelper__CArr.Pos >= 3) and _CompChar2(TXHelper__CArr.P - 2, ']]') Then
                                      If xoChangeInvalidChars in Options Then TChangeArray_Add(TXHelper__CArr, 1, '&gt;')
                                      Else Result := False;
                    #$0D:           If ((TXHelper__CArr.P + 1)^ = #$0A) or ((TXHelper__CArr.P + 1)^ = #$0085) Then
                                      TChangeArray_Add(TXHelper__CArr, 2, #$0A) Else TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    #$0085, #$2028: If xoChangeInvalidChars in Options Then
                                      TChangeArray_Add(TXHelper__CArr, 1, Format('#%d;', [Word(TXHelper__CArr.P^)]))
                                    Else Result := False;
                    Else            If not isChar(TXHelper__CArr.P^) Then
                                      If xoChangeInvalidChars in Options Then
                                        TChangeArray_Add(TXHelper__CArr, 1, Format('#%d;', [Word(TXHelper__CArr.P^)]))
                                      Else Result := False;
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              xtCData_GetText: Begin
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    '&':  If xoChangeInvalidChars in Options Then
                            If (TXHelper__CArr.Pos + 5 <= Length(S)) and _CompChar6(TXHelper__CArr.P, ']]&gt;') Then
                              TChangeArray_Add(TXHelper__CArr, 6, ']]>')
                            Else If (TXHelper__CArr.Pos + 4 <= Length(S)) and _CompChar2(TXHelper__CArr.P + 1, '#x')   Then Begin
                              i  := 3;
                              i2 := 0;
                              While isHex(TXHelper__CArr.P[i]) do Begin
                                i2 := (i2 shl 8) or HexDecode[Word(TXHelper__CArr.P[i])];
                                Inc(i);
                              End;
                              If (i in [4..7]) and (TXHelper__CArr.P[i] = ';') and not isChar(WideChar(i2)) Then
                                TChangeArray_Add(TXHelper__CArr, i + 1, WideChar(i2));
                            End Else If (TXHelper__CArr.Pos + 4 <= Length(S)) and ((TXHelper__CArr.P + 1)^ = '#') Then Begin
                              i  := 2;
                              i2 := 0;
                              While isNum(TXHelper__CArr.P[i]) do Begin
                                i2 := (i2 * 10) + (Word(TXHelper__CArr.P[i]) - Ord('0'));
                                Inc(i);
                              End;
                              If (i in [3..7]) and (TXHelper__CArr.P[i] = ';') and not isChar(WideChar(i2)) Then
                                TChangeArray_Add(TXHelper__CArr, i + 1, WideChar(i2));
                            End;
                    #$0A: TChangeArray_Add(TXHelper__CArr, 1, LineFeed);
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              //xtCData_LoadText > xtTypedef_LoadText
              //xtCData_SaveText > xtTypedef_SaveText
              xtComment_SetText: Begin
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    '>':            If (TXHelper__CArr.Pos >= 3) and _CompChar2(TXHelper__CArr.P - 2, '--') Then
                                      TChangeArray_Add(TXHelper__CArr, 1, '&gt;');
                    #$0D:           If ((TXHelper__CArr.P + 1)^ = #$0A) or ((TXHelper__CArr.P + 1)^ = #$0085) Then
                                      TChangeArray_Add(TXHelper__CArr, 2, #$0A) Else TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    #$0085, #$2028: TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    Else            If not isChar(TXHelper__CArr.P^) Then Result := False;
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                If S = '' Then TChangeArray_Add(TXHelper__CArr, 0, '');
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              //xtComment_GetText  > xtTypedef_GetText
              //xtComment_LoadText > xtTypedef_LoadText
              //xtComment_SaveText > xtTypedef_SaveText
              //xtAttribute_Name   > CheckString
              xtAttribute_SetValue: Begin
                TChangeArray_Initialize(TXHelper__CArr, S);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    '<':            TChangeArray_Add(TXHelper__CArr, 1, '&lt;');
                    '>':            TChangeArray_Add(TXHelper__CArr, 1, '&gt;');
                    '&':            TChangeArray_Add(TXHelper__CArr, 1, '&amp;');
                    #$0D:           If ((TXHelper__CArr.P + 1)^ = #$0A) or ((TXHelper__CArr.P + 1)^ = #$0085) Then
                                      TChangeArray_Add(TXHelper__CArr, 2, #$0A) Else TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    #$0085, #$2028: TChangeArray_Add(TXHelper__CArr, 1, #$0A);
                    Else            If not isChar(TXHelper__CArr.P^) Then Begin
                                      TChangeArray_Add(TXHelper__CArr, 1, Format('#%d;', [Word(TXHelper__CArr.P^)]));
                                      If not (xoChangeInvalidChars in Options) Then Result := False;
                                    End;
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                TChangeArray_Finalize(TXHelper__CArr);
              End;
              //xtAttribute_GetValue  > xtElement_GetText
              //xtAttribute_LoadValue > xtElement_LoadText
              xtAttribute_SaveValue: Begin
                TChangeArray_Initialize(TXHelper__CArr, S);
                TChangeArray_Add(TXHelper__CArr, 0, ValueQuotation);
                While TXHelper__CArr.Pos <= Length(S) do Begin
                  Case TXHelper__CArr.P^ of
                    #$0A: TChangeArray_Add(TXHelper__CArr, 1, LineFeed);
                    '"':  TChangeArray_Add(TXHelper__CArr, 1, '&quot;');
                    '''': If ValueQuotation <> '"' Then TChangeArray_Add(TXHelper__CArr, 1, '&apos;');
                  End;
                  TChangeArray_Inc(TXHelper__CArr);
                End;
                TChangeArray_Add(TXHelper__CArr, 0, ValueQuotation);
                TChangeArray_Finalize(TXHelper__CArr);
                Result := True;
              End;
              Else Raise EXMLException.Create(Self, 'ConvertString', @SInternalError, 1);
            End;
          Finally
            LeaveCriticalSection(TXHelper__LockCArr);
          End;
        {$IFEND}
      End;

    Class Function TXHelper.ConvertString(Var S: TWideString; CType: TXMLStringCheckType; Owner: TXMLFile): Boolean;
      Begin
        If Assigned(Owner) Then Result := ConvertString(S, CType,Owner.Options, Owner.LineFeed, Owner.TextIndent, Owner.ValueQuotation)
        Else Result := ConvertString(S, CType, TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultOptions, TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultLineFeed, TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultTextIndent, TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.DefaultValueQuotation);
      End;

    Class Procedure TXHelper.Serialize_RemoveData(Node: TXMLNode);
      Var i: Integer;

      Begin
        If not Assigned(Node) Then Exit;
        Repeat
          i := Node.Attributes.IndexOfCS(cHimXmlNamespace + ':Variant|'
             + cHimXmlNamespace + ':Dimensions|' + cHimXmlNamespace + ':Count*|'
             + cHimXmlNamespace + ':Low*|'       + cHimXmlNamespace + ':Name|'
             + cHimXmlNamespace + ':Type|'       + cHimXmlNamespace + ':ClassType');
          If i >= 0 Then Node.Attributes.Delete(i) Else Break;
        Until False;
        Node.Nodes.Clear;
        Node.Text_S := '';
      End;

    Class Function TXHelper.DeSerialize_GetNode(Node: TXMLNode; Name: TWideString): TXMLNode;
      Var i: Integer;

      Begin
        Result := Node;
        While Assigned(Node) and (Name <> '') do Begin
          i := Pos(TXMLFile{$IF DELPHI < 2006}(nil){$IFEND}.PathDelimiter, Name);
          If i <= 0 Then i := Length(Name) + 1;
          Result := Result.Nodes.NodeCS[Copy(Name, 1, i - 1)];
          Delete(Name, 1, i);
        End;
      End;

    Class Procedure TXHelper.DeSerialize_GetText(Node: TXMLNode; Const Name: TWideString; DType: TXMLSerializeRDataType; Var Result; Size: Integer = 0);
      Var V: Variant;
        S:   TWideString;
        A:   AnsiString;

      Begin
        Node := DeSerialize_GetNode(Node, Name);
        If Assigned(Node) and Node.isTextNode and (Trim(Node.Text_S) <> '') Then Begin
          Case TransformSerializeTypes[DType] of
            rtBoolean: Begin
              S := Trim(Node.Text_S);
              If S = '' Then Boolean(Result) := False
              Else XMLToBoolean(S, 0, Boolean(Result));
            End;
            rtByteBool: Begin
              S := Trim(Node.Text_S);
              If S = '' Then Byte(Result) := Ord(False)
              Else XMLToBoolean(S, 1, ByteBool(Result));
            End;
            rtWordBool: Begin
              S := Trim(Node.Text_S);
              If S = '' Then Word(Result) := Ord(False)
              Else XMLToBoolean(S, 2, WordBool(Result));
            End;
            rtLongBool: Begin
              S := Trim(Node.Text_S);
              If S = '' Then LongWord(Result) := Ord(False)
              Else XMLToBoolean(S, 4, LongBool(Result));
            End;
            rtByte..rtCurrency: Begin
              V := Trim(Node.Text_S);
              If V = '' Then V := 0;
              Case TransformSerializeTypes[DType] of
                rtByte:                  Byte(Result) := V;
                rtWord:                  Word(Result) := V;
                rtLongWord:          LongWord(Result) := V;
                rtWord64: ValUInt64(V, UInt64(Result));
                rtShortInt:          ShortInt(Result) := V;
                rtSmallInt:          SmallInt(Result) := V;
                rtLongInt:            LongInt(Result) := V;
                rtInt64:                Int64(Result) := V;
                rtSingle:              Single(Result) := V;
                rtDouble:              Double(Result) := V;
                rtExtended:          Extended(Result) := V;
                rtCurrency:          Currency(Result) := V;
                rtWord64LE: Begin
                  ValUInt64(V, UInt64(Result));
                  UInt64(Result) := UInt64(LongWord(Result)) shl 32 or PLongWord(Integer(@Result) + 4)^;
                End;
                rtInt64LE: Begin
                  Int64(Result) := V;
                  Int64(Result) := Int64(LongWord(Result)) shl 32 or PLongWord(Integer(@Result) + 4)^;
                End;
              End;
            End;
            rtDateTime: Begin
              S := Trim(Node.Text_S);
              If S = '' Then TDateTime(Result) := 0
              Else TDateTime(Result) := XMLToDateTime(S);
            End;
            rtAnsiCharArray, rtShortString, rtAnsiString: Begin
              A := AnsiString(Node.Text_S);
              Case TransformSerializeTypes[DType] of
                rtAnsiCharArray: Begin
                  If Length(A) < Size Then Size := Length(A) Else Dec(Size);
                  MoveMemory(PAnsiChar(@Result), PAnsiChar(A), Size);
                  PAnsiChar(@Result)[Size] := #0;
                End;
                rtShortString: Begin
                  If Length(A) < Size Then Size := Length(A);
                  ShortString(Result)[0] := AnsiChar(Size);
                  MoveMemory(@ShortString(Result)[1], PAnsiChar(A), Size);
                End;
                rtAnsiString: AnsiString(Result) := A;
              End;
            End;
            rtWideCharArray, rtUtf8String, rtWideString
            {$IF Declared(UnicodeString)}, rtUnicodeString{$IFEND}: Begin
              S := Node.Text_S;
              Case TransformSerializeTypes[DType] of
                rtWideCharArray: Begin
                  If Length(S) < Size Then Size := Length(S) Else Dec(Size);
                  MoveMemory(PWideChar(@Result), PWideChar(S), Size);
                  PWideChar(@Result)[Size] := #0;
                End;
                rtUtf8String:         UTF8String(Result) := UTF8Encode(Node.Text_S);
                rtWideString:         WideString(Result) := S;
                {$IF Declared(UnicodeString)}
                  rtUnicodeString: UnicodeString(Result) := S;
                {$IFEND}
              End;
            End;
            //rtBinary, rtPointer, rtVariant, rtObject,
            //rtRecord, rtArray, rtDynArray, rtDummy, rtAlign, rtSplit
          End;
        End Else
          Case TransformSerializeTypes[DType] of
            rtBoolean, rtByteBool, rtByte, rtShortInt, rtAnsiCharArray, rtShortString:
                                        Byte(Result) := 0;
            rtWordBool, rtWord, rtSmallInt, rtWideCharArray:
                                        Word(Result) := 0;
            rtLongBool, rtLongWord, rtLongInt, rtSingle:
                                    LongWord(Result) := 0;
            rtWord64, rtWord64LE, rtInt64, rtInt64LE, rtDouble, rtCurrency, rtDateTime:
                                      UInt64(Result) := 0;
            rtExtended:             Extended(Result) := 0;
            rtUtf8String:         UTF8String(Result) := '';
            rtAnsiString:         AnsiString(Result) := '';
            rtWideString:         WideString(Result) := '';
            {$IF Declared(UnicodeString)}
              rtUnicodeString: UnicodeString(Result) := '';
            {$IFEND}
            //rtBinary, rtPointer, rtVariant, rtObject,
            //rtRecord, rtArray, rtDynArray, rtDummy, rtAlign, rtSplit
          End;
      End;

    Class Procedure TXHelper.DeSerialize_GetText(Node: TXMLNode; Const Name: TWideString; VType: TVarType; Var Result: Variant);
      Begin
        VarClear(Result);
        TVarData(Result).VType := VType;
        Case VType of
          varShortInt:  DeSerialize_GetText(Node, Name, rtShortInt,      TVarData(Result).VShortInt);
          varSmallint:  DeSerialize_GetText(Node, Name, rtSmallInt,      TVarData(Result).VSmallInt);
          varInteger:   DeSerialize_GetText(Node, Name, rtLongInt,       TVarData(Result).VInteger);
          varError:     DeSerialize_GetText(Node, Name, rtLongWord,      TVarData(Result).VError);
          varInt64:     DeSerialize_GetText(Node, Name, rtInt64,         TVarData(Result).VInt64);
          varByte:      DeSerialize_GetText(Node, Name, rtByte,          TVarData(Result).VByte);
          varWord:      DeSerialize_GetText(Node, Name, rtWord,          TVarData(Result).VWord);
          varLongWord:  DeSerialize_GetText(Node, Name, rtLongWord,      TVarData(Result).VLongWord);
          {$IF Declared(varUInt64)}
            varUInt64:  DeSerialize_GetText(Node, Name, rtWord64,        TVarData(Result).VUInt64);
          {$IFEND}
          varSingle:    DeSerialize_GetText(Node, Name, rtSingle,        TVarData(Result).VSingle);
          varDouble:    DeSerialize_GetText(Node, Name, rtDouble,        TVarData(Result).VDouble);
          varCurrency:  DeSerialize_GetText(Node, Name, rtCurrency,      TVarData(Result).VCurrency);
          varDate:      DeSerialize_GetText(Node, Name, rtDateTime,      TVarData(Result).VDate);
          varBoolean:   DeSerialize_GetText(Node, Name, rtWordBool,      TVarData(Result).VBoolean);
          varOleStr:    DeSerialize_GetText(Node, Name, rtWideString,    TVarData(Result).VOleStr);
          varString:    DeSerialize_GetText(Node, Name, rtAnsiString,    TVarData(Result).VString);
          {$IF Declared(UnicodeString)}
            varUString: DeSerialize_GetText(Node, Name, rtUnicodeString, TVarData(Result).VUString);
          {$IFEND}
        End;
      End;

    Class Procedure TXHelper.Serialize_Variant(Node: TXMLNode; Const V: Variant);
      Var i, i2, i3: Integer;
        aArr:  PVarArray;
        aData: PByte;
        aDim:  TIntegerDynArray;
        S:     String;

      Begin
        Case TVarData(V).VType of
          varEmpty: ;
          varNull:  Node.Attributes[cHimXmlNamespace + ':Variant'] := 'NULL';

          varShortInt, varShortInt or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'ShortInt';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text := TVarData(V).VShortInt
            Else Node.Text := PShortInt(TVarData(V).VPointer)^;
          End;
          varSmallInt, varSmallInt or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'SmallInt';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text := TVarData(V).VSmallInt
            Else Node.Text := PSmallint(TVarData(V).VPointer)^;
          End;
          varInteger, varInteger or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Integer';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text := TVarData(V).VInteger
            Else Node.Text := PInteger(TVarData(V).VPointer)^;
          End;
          varError, varError or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'HRESULT';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text_S := Format('$%.8x', [TVarData(V).VError])
            Else Node.Text_S := Format('$%.8x', [{HRESULT}PLongInt(TVarData(V).VPointer)^]);
          End;
          varInt64, varInt64 or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Int64';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text := TVarData(V).VInt64
            Else Node.Text := PInt64(TVarData(V).VPointer)^;
          End;
          varByte, varByte or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Byte';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text := TVarData(V).VByte
            Else Node.Text := PByte(TVarData(V).VPointer)^;
          End;
          varWord, varWord or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Word';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text := TVarData(V).VWord
            Else Node.Text := PWord(TVarData(V).VPointer)^;
          End;
          varLongWord, varLongWord or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'LongWord';
            If TVarData(V).VType and varByRef = 0 Then Begin
              If LongInt(TVarData(V).VLongWord) < 0 Then
                Node.Text_S := Format('$%.8x', [LongInt(TVarData(V).VLongWord)])
              Else Node.Text := LongInt(TVarData(V).VLongWord);
            End Else
              If PLongWord(TVarData(V).VPointer)^ < 0 Then
                Node.Text_S := Format('$%.8x', [PLongInt(TVarData(V).VPointer)^])
              Else Node.Text := PLongInt(TVarData(V).VPointer)^;
          End;
          {$IF Declared(varUInt64)}
          varUInt64, varUInt64 or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'UInt64';
            If TVarData(V).VType and varByRef = 0 Then Begin
              If Int64(TVarData(V).VUInt64) < 0 Then
                Node.Text_S := Format('$%.16x', [Int64(TVarData(V).VUInt64)])
              Else Node.Text := Int64(TVarData(V).VUInt64);
            End Else
              If PInt64(TVarData(V).VPointer)^ < 0 Then
                Node.Text_S := Format('$%.16x', [PInt64(TVarData(V).VPointer)^])
              Else Node.Text := PInt64(TVarData(V).VPointer)^;
          End;
          {$IFEND}
          varSingle, varSingle or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Single';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text := TVarData(V).VSingle
            Else Node.Text := PSingle(TVarData(V).VPointer)^;
          End;
          varDouble, varDouble or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Double';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text := TVarData(V).VDouble
            Else Node.Text := PDouble(TVarData(V).VPointer)^;
          End;
          varCurrency, varCurrency or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Currency';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text := TVarData(V).VCurrency
            Else Node.Text := PCurrency(TVarData(V).VPointer)^;
          End;
          varDate, varDate or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'DateTime';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text_S := DateTimeToXML(TVarData(V).VDate, 7{Date|Time|mSec})
            Else Node.Text_S := DateTimeToXML(PDateTime(TVarData(V).VPointer)^, 7{Date|Time|mSec});
          End;
          varBoolean, varBoolean or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Boolean';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text_S := BooleanToXML(TVarData(V).VBoolean, 2)
            Else Node.Text_S := BooleanToXML(PWordBool(TVarData(V).VPointer)^, 2);
          End;
          varOleStr, varOleStr or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'OLEStr';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text_D := WideString(Pointer(TVarData(V).VOleStr))
            Else Node.Text_D := PWideString(TVarData(V).VPointer)^;
          End;
          varString, varString or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'AnsiString';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text_D := TWideString(AnsiString(TVarData(V).VString))
            Else Node.Text_D := TWideString(PAnsiString(TVarData(V).VPointer)^);
          End;
          {$IF Declared(UnicodeString)}
          varUString, varUString or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'WideString';
            If TVarData(V).VType and varByRef = 0 Then
              Node.Text_D := UnicodeString(TVarData(V).VUString)
            Else Node.Text_D := PUnicodeString(TVarData(V).VPointer)^;
          End;
          {$IFEND}
          varVariant or varByRef: Begin
            Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Variant';
            Serialize_Variant(Node.Nodes.Add('Data'), PVariant(TVarData(V).VPointer)^);
          End;
        //varStrArg: only internal used by Variant

        //varShortInt or varArray [or varByRef]: not implemented in Variant
          varSmallInt or varArray, varSmallInt or varArray or varByRef,
          varInteger  or varArray, varInteger  or varArray or varByRef,
        //varError    or varArray [or varByRef]: converted to varInteger = Integer-Array
        //varInt64    or varArray [or varByRef]: not implemented in Variant
          varByte     or varArray, varByte     or varArray or varByRef,
        //varWord     or varArray [or varByRef]: not implemented in Variant
        //varLongWord or varArray [or varByRef]: converted to varInteger = Integer-Array
        //varUInt64   or varArray [or varByRef]: not implemented in Variant
          varSingle   or varArray, varSingle   or varArray or varByRef,
          varDouble   or varArray, varDouble   or varArray or varByRef,
          varCurrency or varArray, varCurrency or varArray or varByRef,
          varDate     or varArray, varDate     or varArray or varByRef,
          varBoolean  or varArray, varBoolean  or varArray or varByRef,
          varOleStr   or varArray, varOleStr   or varArray or varByRef,
        //varString   or varArray [or varByRef]: converted to varOleStr = OleStr-Array
        //varUString  or varArray [or varByRef]: not implemented in Variant
          varVariant  or varArray, varVariant  or varArray or varByRef: Begin
            VarArrayLock(V);
            Try
              Case TVarData(V).VType and varTypeMask of
                varSmallInt: Node.Attributes[cHimXmlNamespace + ':Variant'] := 'SmallInt-Array';
                varInteger:  Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Integer-Array';
                varByte:     Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Byte-Array';
                varSingle:   Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Single-Array';
                varDouble:   Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Double-Array';
                varCurrency: Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Currency-Array';
                varDate:     Node.Attributes[cHimXmlNamespace + ':Variant'] := 'DateTime-Array';
                varBoolean:  Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Boolean-Array';
                varOleStr:   Node.Attributes[cHimXmlNamespace + ':Variant'] := 'OLEStr-Array';
                varVariant:  Node.Attributes[cHimXmlNamespace + ':Variant'] := 'Variant-Array';
              End;
              If TVarData(V).VType and varByRef = 0 Then aArr := TVarData(V).VArray
              Else aArr := PVarArray(TVarData(V).VPointer^);
              Node.Attributes[cHimXmlNamespace + ':Dimensions'] := aArr.DimCount;
              If aArr.DimCount > 0 Then Begin
                SetLength(aDim, aArr.DimCount);
                i2 := 1;
                For i := 0 to aArr.DimCount - 1 do Begin
                  aDim[i] := aArr.Bounds[aArr.DimCount - i - 1].ElementCount;
                  Node.Attributes[Format(cHimXmlNamespace + ':Count%d', [i])] := aDim[i];
                  Node.Attributes[Format(cHimXmlNamespace + ':Low%d',   [i])] := aArr.Bounds[aArr.DimCount - i - 1].LowBound;
                  i2 := i2 * aDim[i];
                End;
                aData := aArr.Data;
                For i := 0 to i2 - 1 do Begin
                  S  := '.';
                  i3 := i;
                  For i2 := 0 to aArr.DimCount - 1 do Begin
                    S  := Format('%s\Dim%d', [S, i3 mod aDim[i2]]);
                    i3 := i3 div aDim[i2];
                  End;

                  Case TVarData(V).VType and varTypeMask of
                    varSmallInt: Node.Nodes.Add(S).Text   := PSmallInt(aData)^;
                    varInteger:  Node.Nodes.Add(S).Text   := PInteger(aData)^;
                    varByte:     Node.Nodes.Add(S).Text   := PByte(aData)^;
                    varSingle:   Node.Nodes.Add(S).Text   := PSingle(aData)^;
                    varDouble:   Node.Nodes.Add(S).Text   := PDouble(aData)^;
                    varCurrency: Node.Nodes.Add(S).Text   := PCurrency(aData)^;
                    varDate:     Node.Nodes.Add(S).Text_S := DateTimeToXML(PDateTime(aData)^, 7{Date|Time|mSec});
                    varBoolean:  Node.Nodes.Add(S).Text_S := BooleanToXML(PWordBool(aData)^, 2);
                    varOleStr:   Node.Nodes.Add(S).Text_D := WideString(Pointer(aData));
                    varVariant:  Serialize_Variant(Node.Nodes.Add(S).Nodes.Add('data'), PVariant(aData)^);
                  End;
                  Case TVarData(V).VType and varTypeMask of
                    varByte:                         Inc(aData, 1);
                    varSmallInt, varBoolean:         Inc(aData, 2);
                    varSingle:                       Inc(aData, 4);
                    varDouble, varCurrency, varDate: Inc(aData, 8);
                    varInteger, varOleStr:           Inc(aData, SizeOf(Integer));
                    varVariant:                      Inc(aData, SizeOf(Variant));
                  End;
                End;
              End;
            Finally
              VarArrayUnlock(V);
            End;
          End;

          Else Raise EXMLException.Create(Self, 'Serialize_Variant', @SNotImplemented,
            Format('TVarType(%d)', [Ord(TVarData(V).VType)]));
        End;
      End;

    Class Procedure TXHelper.DeSerialize_Variant(Node: TXMLNode; Var V: Variant);
      Const TypeList: Array[0..29] of TWideString = ('', 'NULL', 'ShortInt', 'SmallInt', 'Integer', 'HRESULT', 'Int64',
          'Byte', 'Word', 'LongWord', 'UInt64', 'Single', 'Double', 'Currency', 'DateTime', 'Boolean', 'OLEStr',
          'AnsiString', 'WideString', 'Variant', 'SmallInt-Array', 'Integer-Array', 'Byte-Array', 'Single-Array',
          'Double-Array', 'Currency-Array', 'DateTime-Array', 'Boolean-Array', 'OLEStr-Array', 'Variant-Array');

      Var S:    TWideString;
        T, i:   Integer;
        i2, i3: Integer;
        aArr:   PVarArray;
        aData:  PByte;
        aDim:   TIntegerDynArray;
        N:      TXMLNode;

      Begin
        If Assigned(Node) Then S := Node.Attributes.ValueCS[cHimXmlNamespace + ':Variant'] Else S := '';
        T := High(TypeList);
        While (T >= 0) and not SameTextW(TypeList[T], S, False) do Dec(T);
        Try
          Case T of
            0{''}:            VarClear(V);
            1{NULL}:          V := Variants.Null;
            2{ShortInt}:      DeSerialize_GetText(Node, '', varShortInt, V);
            3{SmallInt}:      DeSerialize_GetText(Node, '', varSmallInt, V);
            4{Integer}:       DeSerialize_GetText(Node, '', varInteger,  V);
            5{HRESULT}:       DeSerialize_GetText(Node, '', varError,    V);
            6{Int64}:         DeSerialize_GetText(Node, '', varInt64,    V);
            7{Byte}:          DeSerialize_GetText(Node, '', varByte,     V);
            8{Word}:          DeSerialize_GetText(Node, '', varWord,     V);
            9{LongWord}:      DeSerialize_GetText(Node, '', varLongWord, V);
            {$IF Declared(varUInt64)}
              10{UInt64}:     DeSerialize_GetText(Node, '', varUInt64,   V);
            {$IFEND}
            11{Single}:       DeSerialize_GetText(Node, '', varSingle,   V);
            12{Double}:       DeSerialize_GetText(Node, '', varDouble,   V);
            13{Currency}:     DeSerialize_GetText(Node, '', varCurrency, V);
            14{DateTime}:     DeSerialize_GetText(Node, '', varDate,     V);
            15{Boolean}:      DeSerialize_GetText(Node, '', varBoolean,  V);
            16{OLEStr}:       DeSerialize_GetText(Node, '', varOleStr,   V);
            17{AnsiString}:   DeSerialize_GetText(Node, '', varString,   V);
            {$IF Declared(UnicodeString)}
              18{WideString}: DeSerialize_GetText(Node, '', varUString,  V);
            {$IFEND}
            19{Variant}: Begin
              VarAsType(V, varVariant);
              N := DeSerialize_GetNode(Node, 'Data');
              DeSerialize_Variant(N, PVariant(TVarData(V).VPointer)^);
            End;
            20{SmallInt-Array}..29{Variant-Array}: Begin
              Try
                SetLength(aDim, Integer(Node.Attributes.ValueCS[cHimXmlNamespace + ':Dimensions']) * 2);
                For i := 0 to Length(aDim) div 2 - 1 do Begin
                  i3 := Integer(Node.Attributes.ValueCS[Format(cHimXmlNamespace + ':Count%d', [i])]);
                  aDim[i * 2]     := Integer(Node.Attributes.ValueCS[Format(cHimXmlNamespace + ':Low%d', [i])]);
                  aDim[i * 2 + 1] := aDim[i * 2] + i3 - 1;
                End;
              Except
                Raise EXMLException.Create(Self, 'DeSerialize_Variant', @SCorruptedVarArray,
                  [Node.FullPath], Exception(ExceptObject));
              End;
              Case T of
                20{SmallInt-Array}: V := VarArrayCreate(aDim, varSmallInt);
                21{Integer-Array}:  V := VarArrayCreate(aDim, varInteger);
                22{Byte-Array}:     V := VarArrayCreate(aDim, varByte);
                23{Single-Array}:   V := VarArrayCreate(aDim, varSingle);
                24{Double-Array}:   V := VarArrayCreate(aDim, varDouble);
                25{Currency-Array}: V := VarArrayCreate(aDim, varCurrency);
                26{DateTime-Array}: V := VarArrayCreate(aDim, varDate);
                27{Boolean-Array}:  V := VarArrayCreate(aDim, varBoolean);
                28{OLEStr-Array}:   V := VarArrayCreate(aDim, varOleStr);
                29{Variant-Array}:  V := VarArrayCreate(aDim, varVariant);
              End;
              i2 := 0;
              For i := 0 to Length(aDim) div 2 - 1 do Begin
                aDim[i] := aDim[i * 2 + 1] - aDim[i * 2] + 1;
                Inc(i2, aDim[i]);
              End;
              SetLength(aDim, Length(aDim) div 2);
              VarArrayLock(V);
              Try
                aArr := TVarData(V).VArray;
                If aArr.DimCount > 0 Then Begin
                  aData := aArr.Data;
                  For i := 0 to i2 - 1 do Begin
                    S  := '.';
                    i3 := i;
                    For i2 := 0 to aArr.DimCount - 1 do Begin
                      S  := Format('%s\Dim%d', [S, i3 mod aDim[i2]]);
                      i3 := i3 div aDim[i2];
                    End;
                    Case T of
                      20{SmallInt-Array}: DeSerialize_GetText(Node, S, rtSmallInt,   PSmallInt(aData)^);
                      21{Integer-Array}:  DeSerialize_GetText(Node, S, rtLongInt,    PInteger(aData)^);
                      22{Byte-Array}:     DeSerialize_GetText(Node, S, rtByte,       PByte(aData)^);
                      23{Single-Array}:   DeSerialize_GetText(Node, S, rtSingle,     PSingle(aData)^);
                      24{Double-Array}:   DeSerialize_GetText(Node, S, rtDouble,     PDouble(aData)^);
                      25{Currency-Array}: DeSerialize_GetText(Node, S, rtCurrency,   PCurrency(aData)^);
                      26{DateTime-Array}: DeSerialize_GetText(Node, S, rtDateTime,   PDateTime(aData)^);
                      27{Boolean-Array}:  DeSerialize_GetText(Node, S, rtWordBool,   PWordBool(aData)^);
                      28{OLEStr-Array}:   DeSerialize_GetText(Node, S, rtWideString, WideString(Pointer(aData)));
                      29{Variant-Array}:  Begin
                                            VarAsType(PVariant(aData)^, varVariant);
                                            N := DeSerialize_GetNode(Node, 'Data');
                                            DeSerialize_Variant(N, PVariant(PVarData(aData).VPointer)^);
                                          End;
                    End;
                    Case T of
                      20{SmallInt-Array}: Inc(aData, SizeOf(SmallInt));
                      21{Integer-Array}:  Inc(aData, SizeOf(Integer));
                      22{Byte-Array}:     Inc(aData, SizeOf(Byte));
                      23{Single-Array}:   Inc(aData, SizeOf(Single));
                      24{Double-Array}:   Inc(aData, SizeOf(Double));
                      25{Currency-Array}: Inc(aData, SizeOf(Currency));
                      26{DateTime-Array}: Inc(aData, SizeOf(TDateTime));
                      27{Boolean-Array}:  Inc(aData, SizeOf(WordBool));
                      28{OLEStr-Array}:   Inc(aData, SizeOf(WideString));
                      29{Variant-Array}:  Inc(aData, SizeOf(Variant));
                    End;
                  End;
                End;
              Finally
                VarArrayUnlock(V);
              End;
            End;
            Else Raise EXMLException.Create(Self, 'DeSerialize_Variant', @SUnknownVariant);
          End;
        Except
          Raise EXMLException.Create(Self, 'DeSerialize_Variant', @SInvalidValueN, [], Exception(ExceptObject));
        End;
      End;

    Class Procedure TXHelper.Serialize_Object(Node: TXMLNode; C: TObject; SOptions: TXMLSerializeOptions; Proc: TXMLSerializeProc);
      Procedure _SavePropInfos(Node2: TXMLNode; Info: PPropInfo);
        Const cTypeKindEnd = {$IF     DELPHI >= 2010} tkProcedure
                             {$ELSEIF DELPHI >= 2009} tkUString
                             {$ELSE}                  tkDynArray {$IFEND};
          cTypeKind: Array[{TTypeKind} tkUnknown..cTypeKindEnd] of AnsiString = (
            'Unknown', 'Integer', 'Char', 'Enumeration', 'Float', 'String', 'Set',
            'Class', 'Method', 'WChar', 'LString', 'WString', 'Variant', 'Array',
            'Record', 'Interface', 'Int64', 'DynArray'
            {$IF DELPHI >= 2009}, 'UString'{$IFEND}
            {$IF DELPHI >= 2010}, 'ClassRef', 'Pointer', 'Procedure'{$IFEND});

        {$IF High(TTypeKind) <> High(cTypeKind)}
          {$MESSAGE Hint 'project himXML: TTypeKind includes new types that are not yet supported by the serialization'}
        {$IFEND}

        Begin
          If not (xsSavePropertyInfos in SOptions) Then Exit;
          If not Assigned(Node2) Then Node2 := Node.Nodes.Add(TWideString({Info.Name}GetPropName(Info)));
          Node2.Attributes[cHimXmlNamespace + ':Name'] := TWideString(Info.PropType^.Name);
          Node2.Attributes[cHimXmlNamespace + ':Type'] := cTypeKind[Info.PropType^.Kind];
        End;

      Var List: PPropList;
        Node2:  TXMLNode;
        PData:  TXMLSerializeQuery;
        PRes:   TXMLSerializeProcessing;
        i, i2:  Integer;
        i3, i4: LongInt;
        i64:    Int64;
        F:      Extended;
        O:      TObject;
        S:      TWideString;
        M:      TMethod;
        V:      Variant;
        B, B2:  Boolean;

      Begin
        Raise EXMLException.Create(Self, 'Serialize_Object', @SNotImplemented, 'TObject');
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        If (xsSaveClassType in SOptions) and Assigned(C) Then
          Node.Attributes[cHimXmlNamespace + ':ClassType'] := C.ClassType.ClassName;
        PData.Obj  := C;
        PData.Node := Node;
        PRes       := spProcessAll;
        If Assigned(Proc) Then Proc(xqSaveObject, PData, PRes);
        {$IF DELPHI >= 2006}
          For i2 := High(__SerializeProzedure) downto 0 do
            If PRes in [spProcessAll, spOnlyProcessCallback] Then
              __SerializeProzedure[i2](xqSaveObject, PData, PRes);
        {$ELSE}
          For i2 := High(TXHelper__SerializeProzedure) downto 0 do
            If PRes in [spProcessAll, spOnlyProcessCallback] Then
              TXHelper__SerializeProzedure[i2](xqSaveObject, PData, PRes);
        {$IFEND}
        If PRes in [spProcessAll, spDoNotProcessCallback] Then Begin
          i2 := GetPropList(PTypeInfo(C.ClassInfo), List);
          If i2 > 0 Then
            Try
              If xsSortProperties in SOptions Then SortPropList(List, i2);
              For i := 0 to i2 - 1 do Begin
                PData.Obj          := C;
                PData.PropertyName := {List[i].Name}GetPropName(List[i]);
                PData.Node         := Node;
                If (xsNonStoredProperties in SOptions) or IsStoredProp(C, List[i]) Then
                  PRes := spOnlyProcessCallback Else PRes := spProcessAll;
                If Assigned(Proc) Then Proc(xqSaveProperty, PData, PRes);
                {$IF DELPHI >= 2006}
                  For i2 := High(__SerializeProzedure) downto 0 do
                    If PRes in [spProcessAll, spOnlyProcessCallback] Then
                      __SerializeProzedure[i2](xqSaveProperty, PData, PRes);
                {$ELSE}
                  For i2 := High(TXHelper__SerializeProzedure) downto 0 do
                    If PRes in [spProcessAll, spOnlyProcessCallback] Then
                      TXHelper__SerializeProzedure[i2](xqSaveProperty, PData, PRes);
                {$IFEND}
                If PRes in [spProcessAll, spDoNotProcessCallback] Then
                  Case List[i].PropType^.Kind of
                    tkUnknown: _SavePropInfos(nil, List[i]);
                    tkInteger: Begin
                      i3 := GetOrdProp(C, List[i]);
                      If (List[i].Default <> Low(LongInt)) or (i3 <> List[i].Default)
                          or (xsDefaultProperties in SOptions) Then Begin
                        Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                        _SavePropInfos(Node2, List[i]);
                        {$IF DELPHI >= 2006}
                          For i4 := High(__ValueSerializeProcs) downto 0 do
                            If (__ValueSerializeProcs[i4].VType = tkInteger)
                                and SameTextA(__ValueSerializeProcs[i4].Name, List[i].PropType^.Name) Then Begin
                              Node2.Text_S := __ValueSerializeProcs[i4].SerialProc(i3, __ValueSerializeProcs[i4].PrivParam);
                              Continue;
                            End;
                        {$ELSE}
                          For i4 := High(TXHelper__ValueSerializeProcs) downto 0 do
                            If (TXHelper__ValueSerializeProcs[i4].VType = tkInteger)
                                and SameTextA(TXHelper__ValueSerializeProcs[i4].Name, List[i].PropType^.Name) Then Begin
                              Node2.Text_S := TXHelper__ValueSerializeProcs[i4].SerialProc(i3, TXHelper__ValueSerializeProcs[i4].PrivParam);
                              Continue;
                            End;
                        {$IFEND}
                        Node2.Text := i3;
                      End;
                    End;
                    tkInt64: Begin
                      i64 := GetInt64Prop(C, List[i]);
                      If (List[i].Default <> Low(LongInt)) or (i64 <> List[i].Default)
                          or (xsDefaultProperties in SOptions) Then Begin
                        Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                        _SavePropInfos(Node2, List[i]);
                        Node2.Text := i64;
                      End;
                    End;
                    tkEnumeration: Begin
                      i2 := GetOrdProp(C, List[i]);
                      If (List[i].Default <> Low(LongInt)) or (i2 <> List[i].Default)
                          or (xsDefaultProperties in SOptions) Then Begin
                        Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                        _SavePropInfos(Node2, List[i]);
                        If List[i].PropType^ = TypeInfo(Boolean) Then Begin
                          i3 := GetOrdProp(C, List[i]);
                          Node2.Text_S := BooleanToXML(i3, 1);
                        End Else Node2.Text_S := GetEnumProp(C, List[i]);
                      End;
                    End;
                    tkSet: Begin
                      Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                      _SavePropInfos(Node2, List[i]);
                      Node2.Text_S := GetSetProp(C, List[i], True);
                    End;
                    tkFloat: Begin
                      Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                      _SavePropInfos(Node2, List[i]);
                      F := GetFloatProp(C, List[i]);
                      {$IF DELPHI >= 2006}
                        For i4 := High(__ValueSerializeProcs) downto 0 do
                          If (__ValueSerializeProcs[i4].VType = tkFloat)
                              and SameTextA(__ValueSerializeProcs[i4].Name, List[i].PropType^.Name) Then Begin
                            Node2.Text_S := __ValueSerializeProcs[i4].SerialProc(F, __ValueSerializeProcs[i4].PrivParam);
                            Continue;
                          End;
                      {$ELSE}
                        For i4 := High(TXHelper__ValueSerializeProcs) downto 0 do
                          If (TXHelper__ValueSerializeProcs[i4].VType = tkFloat)
                              and SameTextA(TXHelper__ValueSerializeProcs[i4].Name, List[i].PropType^.Name) Then Begin
                            Node2.Text_S := TXHelper__ValueSerializeProcs[i4].SerialProc(F, TXHelper__ValueSerializeProcs[i4].PrivParam);
                            Continue;
                          End;
                      {$IFEND}
                      Node2.Text := F;
                    End;
                    tkChar, tkWChar: Begin
                      i3 := Word(GetOrdProp(C, List[i]));
                      If (List[i].Default <> Low(LongInt)) or (i3 <> List[i].Default)
                          or (xsDefaultProperties in SOptions) Then Begin
                        Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                        _SavePropInfos(Node2, List[i]);
                        If (i3 > 32) and (i3 < 128) Then Node2.Text_S := WideChar(i3)
                        Else Node2.Text_S := Format('#%d', [i3]);
                      End;
                    End;
                    tkString, tkLString, tkWString {$IF Declared(UnicodeString)}, tkUString{$IFEND}: Begin
                      Case List[i].PropType^.Kind of
                        tkLString: S := TWideString({$IF Declared(UnicodeString)}GetAnsiStrProp{$ELSE}GetStrProp{$IFEND}(C, List[i]));
                        {$IF Declared(UnicodeString)} tkUString: S := GetUnicodeStrProp(C, List[i]); {$IFEND}
                        tkWString: S := GetWideStrProp(C, List[i]);
                        Else S := {$IFDEF UNICODE}GetUnicodeStrProp{$ELSE} {$IF Declared(UnicodeString)}GetAnsiStrProp{$ELSE}GetStrProp{$IFEND} {$ENDIF}(C, List[i]);
                      End;
                      If (S <> '') or (xsDefaultProperties in SOptions) Then Begin
                        Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                        _SavePropInfos(Node2, List[i]);
                        Node2.Text_D := S;
                      End Else _SavePropInfos(nil, List[i]);
                    End;
                    tkClass: Begin
                      O := GetObjectProp(C, List[i]);
                      If Assigned(O) Then Begin
                        Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                        _SavePropInfos(Node2, List[i]);
                        TXHelper.Serialize_Object(Node2, O, SOptions + [xsSaveClassType], Proc);
                      End Else _SavePropInfos(nil, List[i]);
                    End;
                    tkMethod: Begin
                      M := GetMethodProp(C, List[i]);
                      If not Assigned(M.Data) Then Begin
                        _SavePropInfos(nil, List[i]);
                      {$IFNDEF hxExcludeClassesUnit}
                      End Else If (TObject(M.Data) is TComponent) and (TComponent(M.Data).Name <> '')
                          and (TComponent(M.Data).MethodName(M.Code) <> '') Then Begin
                        Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                        _SavePropInfos(Node2, List[i]);
                        Node2.Text_S := Format('%s:%s:%s', [TComponent(M.Data).ClassName, TComponent(M.Data).Name,
                          TComponent(M.Data).MethodName(M.Code)]);
                      {$ENDIF}
                      End Else Raise EXMLException.Create(Self, 'Serialize', @SUnsuppPropType, {Info.Name}GetPropName(List[i]));
                    End;
                    tkVariant: Begin
                      V := GetVariantProp(C, List[i]);
                      If (TVarData(V).VType <> varEmpty) or (xsDefaultProperties in SOptions) Then Begin
                        Node2 := Node.Nodes.Add(TWideString({List[i].Name}GetPropName(List[i])));
                        _SavePropInfos(Node2, List[i]);
                        TXHelper.Serialize_Variant(Node2, V);
                      End Else _SavePropInfos(nil, List[i]);
                    End;
                  //tkRecord: ;
                  //tkInterface: ;
                  //tkArray: ;
                  //tkDynArray: ;
                  //tkClassRef: ;
                  //tkPointer: ;
                  //tkProcedure: ;
                    Else Raise EXMLException.Create(Self, 'Serialize', @SUnsuppPropType, {Info.Name}GetPropName(List[i]));
                  End;
              End;
            Finally
              FreeMem(List);
            End;
        End;
      End;

    Class Procedure TXHelper.DeSerialize_Object(Node: TXMLNode; C: TObject; SOptions: TXMLSerializeOptions; Proc: TXMLSerializeProc);
      Begin
        Raise EXMLException.Create(Self, 'DeSerialize_Object', @SNotImplemented, 'TObject');
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
      End;

    Class Procedure TXHelper.Serialize_Record(Node: TXMLNode; Const Rec; RecInfo: TXMLSerializeRecordInfo);
      Const DTName: Array[TXMLSerializeRDataType] of TWideString = (
          'Boolean', 'WordBool', 'BOOL', '', '',
          'Byte', 'Word', 'LongWord', 'Word64', 'Word64BE', 'Word64LE', '',
          'ShortInt', 'SmallInt', 'LongInt', 'Int64', 'Int64BE', 'Int64LE', '',
          'Single', 'Double', 'Extended', '', 'Currency', 'TDateTime',
          'AnsiCharArray', 'WideCharArray', '', 'Utf8String',
          'ShortString', 'AnsiString', 'WideString', 'WideString', '',
          'Binary', 'Binary', 'Variant', 'Object',
          'Record', 'Array', 'Array', '', '', '');

      Var P, P2: Pointer;
        i, i2:   Integer;
        Node2:   TXMLNode;
        A:       AnsiString;
        S:       TWideString;

      Procedure _AddNode(Const TypeName: TWideString);
        Begin
          Node2 := Node.Nodes.Add(RecInfo.GetName(i));
          If RecInfo._SaveInfos Then Node2.Attributes[cHimXmlNamespace + ':Type'] := TypeName;
        End;

      Begin
        For i := 0 to High(RecInfo._Data) do Begin
          S := DTName[TransformSerializeTypes[RecInfo._Data[i].DType]];
          If S <> '' Then _AddNode(S);
          P := PAnsiChar(@Rec) + RecInfo._Data[i].Offset;
          Case TransformSerializeTypes[RecInfo._Data[i].DType] of
            rtBoolean:            Node2.Text := BooleanToXML(PByte(P)^, 0);
            rtByteBool:           Node2.Text := BooleanToXML(PByte(P)^, 1);
            rtWordBool:           Node2.Text := BooleanToXML(PWord(P)^, 2);
            rtLongBool:           Node2.Text := BooleanToXML(PLongWord(P)^, 4);
            rtByte:               Node2.Text := PByte(P)^;
            rtWord:               Node2.Text := PWord(P)^;
            rtLongWord:           Node2.Text := PLongWord(P)^;
            rtWord64, rtWord64BE: {$IF Declared(varUInt64)}
                                    Node2.Text := PUInt64(P)^;
                                  {$ELSE}
                                    If PInt64(P)^ < 0 Then
                                      Node2.Text_S := Format('$%.16x', [PInt64(P)^])
                                    Else Node2.Text_S := Format('%d', [PInt64(P)^]);
                                  {$IFEND}
            rtWord64LE:           {$IF Declared(varUInt64)}
                                    Node2.Text := UInt64(UInt64(PLongWord(P)^) shl 32
                                      or PLongWord(Integer(P) + 4)^);
                                  {$ELSE}
                                    If PInt64(P)^ < 0 Then
                                      Node2.Text_S := Format('$%.16x', [Int64(Int64(PLongWord(P)^) shl 32
                                        or PLongWord(Integer(P) + 4)^)])
                                    Else Node2.Text_S := Format('%d', [Int64(Int64(PLongWord(P)^) shl 32
                                      or PLongWord(Integer(P) + 4)^)]);
                                  {$IFEND}
            rtShortInt:           Node2.Text := PShortInt(P)^;
            rtSmallInt:           Node2.Text := PSmallInt(P)^;
            rtLongInt:            Node2.Text := PLongInt(P)^;
            rtInt64, rtInt64BE:   Node2.Text := PInt64(P)^;
            rtInt64LE:            Node2.Text := Int64(Int64(PLongWord(P)^) shl 32
                                   or PLongWord(Integer(P) + 4)^);
            rtSingle:             Node2.Text := PSingle(P)^;
            rtDouble:             Node2.Text := PDouble(P)^;
            rtExtended:           Node2.Text := PExtended(P)^;
            rtCurrency:           Node2.Text := PCurrency(P)^;
            rtDateTime:           Node2.Text_S := DateTimeToXML(PDateTime(P)^, 7);
            rtAnsiCharArray:      Begin
                                    SetLength(A, RecInfo._Data[i].Elements);
                                    CopyMemory(PAnsiChar(A), P, RecInfo._Data[i].Elements);
                                    S := TWideString(PAnsiChar(A));
                                    A := '';
                                    Node2.Text_D := S;
                                    S := '';
                                  End;
            rtWideCharArray:      Begin
                                    SetLength(S, RecInfo._Data[i].Elements);
                                    CopyMemory(PWideChar(S), P, RecInfo._Data[i].Elements * 2);
                                    S := PWideChar(S);
                                    Node2.Text_D := S;
                                    S := '';
                                  End;
            rtUtf8String:         Begin
                                    S := {$IF Declared(UnicodeString) and not Defined(hxDisableUnicodeString)}
                                           UTF8ToUnicodeString(PUTF8String(P)^)
                                         {$ELSEIF Declared(UTF8ToWideString)}
                                           UTF8ToWideString(PUTF8String(P)^)
                                         {$ELSE}
                                           UTF8Decode(PUTF8String(P)^)
                                         {$IFEND};
                                    If (S = '') and Assigned(PPointer(P)^) Then Begin
                                      A := PAnsiString(P)^;
                                      SetLength(S, Length(A));
                                      For i2 := 1 to Length(A) do S[i2] := WideChar(Byte(A[i2]));
                                    End;
                                    Node2.Text_D := S;
                                    S := '';
                                  End;
            rtShortString:        Node2.Text_D := TWideString(PShortString(P)^);
            rtAnsiString:         Node2.Text_D := TWideString(PAnsiString(P)^);
            rtWideString:         Node2.Text_D := PWideString(P)^;
            {$IF Declared(UnicodeString)}
            rtUnicodeString:      Node2.Text_D := PUnicodeString(P)^;
            {$IFEND}
            rtBinary:             Node2.SetBinaryData(P, RecInfo._Data[i].Elements);
            rtPointer:            Node2.SetBinaryData(PPointer(P)^, RecInfo._Data[i].Elements);
            rtVariant:            Serialize_Variant(Node2, PVariant(P)^);
            rtObject:             Serialize_Object(Node2, TObject(PPointer(P)^), RecInfo._SOptions, RecInfo._SerProc);
            rtRecord:             Serialize_Record(Node2, P^, RecInfo._Data[i].SubInfo);
            rtArray:              Begin
                                    P2 := P;
                                    For i2 := RecInfo._Data[i].Elements - 1 downto 0 do Begin
                                      Serialize_Record(Node2.Nodes.Add('Element'), P2^, RecInfo._Data[i].SubInfo);
                                      Inc(Integer(P2), RecInfo._Data[i].SubInfo._Size);
                                    End;
                                  End;
            rtDynArray:           Begin
                                    P2 := PPointer(P)^;
                                    If Assigned(P2) Then
                                      For i2 := PInteger(Integer(P2) - 4)^ - 1 downto 0 do Begin
                                        Serialize_Record(Node2.Nodes.Add('Element'), P2^, RecInfo._Data[i].SubInfo);
                                        Inc(Integer(P2), RecInfo._Data[i].SubInfo._Size);
                                      End;
                                  End;
            rtDummy:              ;
            rtAlign:              ;
            rtSplit:              ;
            Else Raise EXMLException.Create(Self, 'Serialize_Record', @SInvalidValueS, 'record type');
          End;
        End;
      End;

    Class Procedure TXHelper.DeSerialize_Record(Node: TXMLNode; Var Rec; RecInfo: TXMLSerializeRecordInfo);
      Var T:   TXMLSerializeRDataType;
        N, S:  TWideString;
        P, P2: Pointer;
        A:     AnsiString;
        i, i2: Integer;
        Node2: TXMLNode;

      Begin
        Try
          For i := 0 to RecInfo.Count - 1 do Begin
            T := TransformSerializeTypes[RecInfo._Data[i].DType];
            N := RecInfo.GetName(i);
            P := PAnsiChar(@Rec) + RecInfo._Data[i].Offset;
            Case T of
              rtBoolean..rtUnicodeString: DeSerialize_GetText(Node, N, T, P^, RecInfo._Data[i].Elements);
              Else Begin
                If Assigned(Node) Then Node2 := Node.Nodes.NodeCS[N] Else Node2 := nil;
                Case T of
                  rtBinary:   Begin
                                ZeroMemory(P, RecInfo._Data[i].Elements);
                                If Assigned(Node2) Then Node2.GetBinaryData(P, RecInfo._Data[i].Elements);
                              End;
                  rtPointer:  Begin
                                ZeroMemory(PPointer(P)^, RecInfo._Data[i].Elements);
                                If Assigned(Node2) Then Node2.GetBinaryData(PPointer(P)^, RecInfo._Data[i].Elements);
                              End;
                  rtVariant:  DeSerialize_Variant(Node2, PVariant(P)^);
                  rtObject:   DeSerialize_Object(Node2, TObject(PPointer(P)^), RecInfo._SOptions, RecInfo._SerProc);
                  rtRecord:   DeSerialize_Record(Node2, P^, RecInfo._Data[i].SubInfo);
                  rtArray:    Begin
                                P2 := P;
                                For i2 := 0 to RecInfo._Data[i].Elements - 1 do Begin
                                  DeSerialize_Record(Node2.Nodes.NodeCS[Format('Element[%d]', [i2])], P2^, RecInfo._Data[i].SubInfo);
                                  Inc(Integer(P2), RecInfo._Data[i].SubInfo._Size);
                                End;
                              End;
                  rtDynArray: Begin
                                P2 := PPointer(P)^;
                                If Assigned(P2) Then
                                  For i2 := PInteger(Integer(P2) - 4)^ - 1 downto 0 do Begin
                                    DeSerialize_Record(Node2.Nodes.NodeCS[Format('Element[%d]', [i2])], P2^, RecInfo._Data[i].SubInfo);
                                    Inc(Integer(P2), RecInfo._Data[i].SubInfo._Size);
                                  End;
                              End;
                  rtDummy:    ;
                  rtAlign:    ;
                  rtSplit:    ;
                  Else Raise EXMLException.Create(Self, 'DeSerialize_Record', @SInvalidValueS, 'variant type');
                End;
              End;
            End;
          End;
        Except
          Raise EXMLException.Create(Self, 'DeSerialize', @SInvalidValueN, [], Exception(ExceptObject));
        End;
      End;

    Class Function TXHelper.RegisterSerProc(Proc: TXMLSerializeProc): Boolean;
      Var i: Integer;

      Begin
        Result := True;
        {$IF DELPHI >= 2006}
          For i := High(__SerializeProzedure) downto 0 do
            If @__SerializeProzedure[i] = @Proc Then Result := False;
          If Result Then Begin
            i := Length(__SerializeProzedure);
            SetLength(__SerializeProzedure, i + 1);
            __SerializeProzedure[i] := Proc;
          End;
        {$ELSE}
          For i := High(TXHelper__SerializeProzedure) downto 0 do
            If @TXHelper__SerializeProzedure[i] = @Proc Then Result := False;
          If Result Then Begin
            i := Length(TXHelper__SerializeProzedure);
            SetLength(TXHelper__SerializeProzedure, i + 1);
            TXHelper__SerializeProzedure[i] := Proc;
          End;
        {$IFEND}
      End;

    Class Procedure TXHelper.DeregisterSerProc(Proc: TXMLSerializeProc);
      Var i, i2: Integer;

      Begin
        {$IF DELPHI >= 2006}
          For i := High(__SerializeProzedure) downto 0 do
            If @__SerializeProzedure[i] = @Proc Then Begin
              i2 := Length(__SerializeProzedure);
              MoveMemory(@__SerializeProzedure[i], @__SerializeProzedure[i + 1],
                (i2 - i - 1) * SizeOf(TXMLSerializeProc));
              SetLength(__SerializeProzedure, i2 - 1);
              Break;
            End;
        {$ELSE}
          For i := High(TXHelper__SerializeProzedure) downto 0 do
            If @TXHelper__SerializeProzedure[i] = @Proc Then Begin
              i2 := Length(TXHelper__SerializeProzedure);
              MoveMemory(@TXHelper__SerializeProzedure[i], @TXHelper__SerializeProzedure[i + 1],
                (i2 - i - 1) * SizeOf(TXMLSerializeProc));
              SetLength(TXHelper__SerializeProzedure, i2 - 1);
              Break;
            End;
        {$IFEND}
      End;

    Class Function TXHelper.isRegisteredSerProc(Proc: TXMLSerializeProc): Boolean;
      Var i: Integer;

      Begin
        Result := False;
        {$IF DELPHI >= 2006}
          For i := High(__SerializeProzedure) downto 0 do
            If @__SerializeProzedure[i] = @Proc Then Begin
              Result := True;
              Break;
            End;
        {$ELSE}
          For i := High(TXHelper__SerializeProzedure) downto 0 do
            If @TXHelper__SerializeProzedure[i] = @Proc Then Begin
              Result := True;
              Break;
            End;
        {$IFEND}
      End;

    Class Function TXHelper.RegisterSerClass(C: TClass): Boolean;
      Var i: Integer;

      Begin
        Result := True;
        {$IF DELPHI >= 2006}
          For i := High(__SerializeClass) downto 0 do
            If @__SerializeClass[i] = @C Then Result := False;
          If Result Then Begin
            i := Length(__SerializeClass);
            SetLength(__SerializeClass, i + 1);
            __SerializeClass[i] := C;
          End;
        {$ELSE}
          For i := High(TXHelper__SerializeClass) downto 0 do
            If @TXHelper__SerializeClass[i] = @C Then Result := False;
          If Result Then Begin
            i := Length(TXHelper__SerializeClass);
            SetLength(TXHelper__SerializeClass, i + 1);
            TXHelper__SerializeClass[i] := C;
          End;
        {$IFEND}
      End;

    Class Procedure TXHelper.DeregisterSerClass(C: TClass);
      Var i, i2: Integer;

      Begin
        {$IF DELPHI >= 2006}
          For i := High(__SerializeClass) downto 0 do
            If @__SerializeClass[i] = @C Then Begin
              i2 := Length(__SerializeClass);
              MoveMemory(@__SerializeClass[i], @__SerializeClass[i + 1],
                (i2 - i - 1) * SizeOf(TXMLSerializeProc));
              SetLength(__SerializeClass, i2 - 1);
              Break;
            End;
        {$ELSE}
          For i := High(TXHelper__SerializeClass) downto 0 do
            If @TXHelper__SerializeClass[i] = @C Then Begin
              i2 := Length(TXHelper__SerializeClass);
              MoveMemory(@TXHelper__SerializeClass[i], @TXHelper__SerializeClass[i + 1],
                (i2 - i - 1) * SizeOf(TXMLSerializeProc));
              SetLength(TXHelper__SerializeClass, i2 - 1);
              Break;
            End;
        {$IFEND}
      End;

    Class Function TXHelper.isRegisteredSerClass(C: TClass): Boolean;
      Var i: Integer;

      Begin
        Result := False;
        {$IF DELPHI >= 2006}
          For i := High(__SerializeClass) downto 0 do
            If @__SerializeClass[i] = @C Then Begin
              Result := True;
              Break;
            End;
        {$ELSE}
          For i := High(TXHelper__SerializeClass) downto 0 do
            If @TXHelper__SerializeClass[i] = @C Then Begin
              Result := True;
              Break;
            End;
        {$IFEND}
      End;

    Class Procedure TXHelper.SetValueSerProc(VType: TTypeKind; Const Name: AnsiString;
        SProc: TXMLValueSerialize; DProc: TXMLValueDeserialize; PrivParam: Integer = 0);

      Var i: Integer;

      Begin
        {$IF DELPHI >= 2006}
          i := High(__ValueSerializeProcs);
          While (i >= 0) and ((__ValueSerializeProcs[i].VType <> VType)
              or not TXHelper.SameTextA(__ValueSerializeProcs[i].Name, Name)) do Dec(i);
          If Assigned(SProc) and Assigned(DProc) Then Begin
            If i < 0 Then Begin
              i := Length(__ValueSerializeProcs);
              SetLength(__ValueSerializeProcs, i + 1);
              __ValueSerializeProcs[i].VType := VType;
              __ValueSerializeProcs[i].Name  := Name;
            End;
            __ValueSerializeProcs[i].SerialProc   := SProc;
            __ValueSerializeProcs[i].DeserialProc := DProc;
            __ValueSerializeProcs[i].PrivParam    := PrivParam;
          End Else
            If i >= 0 Then Begin
              If i < High(__ValueSerializeProcs) Then Begin
                __ValueSerializeProcs[i].Name := '';
                MoveMemory(@__ValueSerializeProcs[i], @__ValueSerializeProcs[i + 1],
                  (High(__ValueSerializeProcs) - i) * SizeOf(__ValueSerializeProcs[0]));
                ZeroMemory(@__ValueSerializeProcs[High(__ValueSerializeProcs)], SizeOf(__ValueSerializeProcs[0]));
              End;
              SetLength(__ValueSerializeProcs, High(__ValueSerializeProcs));
            End;
        {$ELSE}
          i := High(TXHelper__ValueSerializeProcs);
          While (i >= 0) and ((TXHelper__ValueSerializeProcs[i].VType <> VType)
              or not TXHelper.SameTextA(TXHelper__ValueSerializeProcs[i].Name, Name)) do Dec(i);
          If Assigned(SProc) and Assigned(DProc) Then Begin
            If i < 0 Then Begin
              i := Length(TXHelper__ValueSerializeProcs);
              SetLength(TXHelper__ValueSerializeProcs, i + 1);
              TXHelper__ValueSerializeProcs[i].VType := VType;
              TXHelper__ValueSerializeProcs[i].Name  := Name;
            End;
            TXHelper__ValueSerializeProcs[i].SerialProc   := SProc;
            TXHelper__ValueSerializeProcs[i].DeserialProc := DProc;
            TXHelper__ValueSerializeProcs[i].PrivParam    := PrivParam;
          End Else
            If i >= 0 Then Begin
              If i < High(TXHelper__ValueSerializeProcs) Then Begin
                TXHelper__ValueSerializeProcs[i].Name := '';
                MoveMemory(@TXHelper__ValueSerializeProcs[i], @TXHelper__ValueSerializeProcs[i + 1],
                  (High(TXHelper__ValueSerializeProcs) - i) * SizeOf(TXHelper__ValueSerializeProcs[0]));
                ZeroMemory(@TXHelper__ValueSerializeProcs[High(TXHelper__ValueSerializeProcs)], SizeOf(TXHelper__ValueSerializeProcs[0]));
              End;
              SetLength(TXHelper__ValueSerializeProcs, High(TXHelper__ValueSerializeProcs));
            End;
        {$IFEND}
      End;

    Class Procedure TXHelper.GetValueSerProc(Var List: TXMLValueSerializeArray);
      Begin
        {$IF DELPHI >= 2006}
          List := Copy(__ValueSerializeProcs);
        {$ELSE}
          List := Copy(TXHelper__ValueSerializeProcs);
        {$IFEND}
      End;

    Class Procedure TXHelper.HandleException(E: Exception; Proc: TXMLExceptionEvent; Owner: TObject);
      Var B: Boolean;

      Begin
        Try
          B := False;
          If Assigned(Proc) Then Proc(Owner, E, B);
          If B Then ShowException(E, nil);
        Except
          ShowException(ExceptObject, nil);
        End;
      End;

    Function SHGetSpecialFolderLocation(Owner: HWND; Folder: Integer; Var pPIDL: Pointer): HResult; StdCall;
      External 'shell32.dll';

    Function SHGetPathFromIDList(pPIDL: Pointer; Path: PChar): LongBool; StdCall;
      External 'shell32.dll' Name {$IF SizeOf(Char) = 2}'SHGetPathFromIDListW'{$ELSE}'SHGetPathFromIDListA'{$IFEND};

    Procedure CoTaskMemFree(P: Pointer); StdCall;
      External 'ole32.dll';

    {$IFNDEF hxExcludeClassesUnit}

      // TStrings, TStringList, TComponent, TCollection, TCollectionItem

      Procedure ClassSerializeProc(Status: TXMLSerializeState; Const Data: TXMLSerializeQuery; Var Automatic: TXMLSerializeProcessing);
        Var S:   TWideString;
          B, B2: Boolean;
          N:     TXMLNode;
          i, i2: Integer;

        Begin
          Case Status of
            xqSaveObject:
              If Data.Obj is TStrings Then Begin
                B  := xsDefaultProperties in Data.SOptions;
                S  := TStrings(Data.Obj).Delimiter;           If B or (S <> ',') Then Data.Node.Attributes['Delimiter'] := S;
                S  := TStrings(Data.Obj).QuoteChar;           If B or (S <> '"') Then Data.Node.Attributes['QuoteChar'] := S;
                {$IF DELPHI >= 2006}
                  B2 := TStrings(Data.Obj).StrictDelimiter;   If B or B2         Then Data.Node.Attributes['StrictDel'] := B2;
                {$IFEND}
                S  := TStrings(Data.Obj).NameValueSeparator;  If B or (S <> '=') Then Data.Node.Attributes['Separator'] := S;
                {$IF DELPHI >= 2006}
                  S  := TStrings(Data.Obj).LineBreak;  If B or (S <> sLineBreak) Then Data.Node.Attributes['LineBreak'] := S;
                {$IFEND}
                If Data.Obj is TStringList Then Begin
                  S  := GetEnumName(TypeInfo(TDuplicates), Ord(TStringList(Data.Obj).Duplicates));
                                              If B or (S <> 'dupIgnore') Then Data.Node.Attributes['Duplicates']    := S;
                  B2 := TStringList(Data.Obj).Sorted;         If B or B2 Then Data.Node.Attributes['Sorted']        := B2;
                  B2 := TStringList(Data.Obj).CaseSensitive;  If B or B2 Then Data.Node.Attributes['CaseSensitive'] := B2;
                  {$IF DELPHI >= 2009}
                    B2 := TStringList(Data.Obj).OwnsObjects;  If B or B2 Then Data.Node.Attributes['OwnsObjects']   := B2;
                  {$IFEND}
                End;
                If B or (TStrings(Data.Obj).Count > 0) Then Begin
                  N := Data.Node.Nodes.Add('Strings');
                  For i := 0 to TStrings(Data.Obj).Count - 1 do Begin
                    N.Nodes.Add('String').Text_D := TStrings(Data.Obj).Strings[i];
                    If (xsTStringsObjects in Data.SOptions) and Assigned(TStrings(Data.Obj).Objects[i])
                        and (not (Data.Obj is TComponent) or not (csTransient in TComponent(Data.Obj).ComponentStyle)
                          or (xsNonSubComponents in Data.SOptions) or (csSubComponent in TComponent(Data.Obj).ComponentStyle)) Then
                      N.Nodes.Add('Object').Serialize(TStrings(Data.Obj).Objects[i], Data.SOptions + [xsSaveClassType], TXMLSerializeProc(Data.SProc));
                  End;
                End;
              End Else If Data.Obj is TComponent Then Begin
                If TComponent(Data.Obj).Name <> '' Then
                  Data.Node.Attributes['Name'] := TComponent(Data.Obj).Name;
                i2 := TComponent(Data.Obj).ComponentCount;
                If (i2 <> 0) or (xsDefaultProperties in Data.SOptions) Then Begin
                  N := Data.Node.Nodes.Add('Components');
                  For i := 0 to i2 - 1 do
                    If not (csTransient in TComponent(Data.Obj).Components[i].ComponentStyle) or (xsNonSubComponents in Data.SOptions)
                        or (csSubComponent in TComponent(Data.Obj).Components[i].ComponentStyle) Then
                      N.Nodes.Add('Component').Serialize(TComponent(Data.Obj).Components[i], Data.SOptions + [xsSaveClassType], TXMLSerializeProc(Data.SProc));
                End;
              End Else If Data.Obj is TCollection Then Begin
                i2 := TCollection(Data.Obj).Count;
                If (i2 <> 0) or (xsDefaultProperties in Data.SOptions) Then Begin
                  N := Data.Node.Nodes.Add('Items');
                  For i := 0 to i2 - 1 do
                    N.Nodes.Add('Item').Serialize(TCollection(Data.Obj).Items[i], Data.SOptions + [xsSaveClassType], TXMLSerializeProc(Data.SProc));
                End;
              End Else If Data.Obj is TCollectionItem Then Begin
                If TCollectionItem(Data.Obj).DisplayName <> TCollectionItem(Data.Obj).ClassName Then
                  Data.Node.Nodes.Add('DisplayName').Text_S := TCollectionItem(Data.Obj).DisplayName;
                Data.Node.Nodes.Add('Collection').Serialize(TCollectionItem(Data.Obj).Collection, Data.SOptions + [xsSaveClassType], TXMLSerializeProc(Data.SProc));
              End;
            xqSaveProperty, xqLoadProperty:
              If ((Data.Obj is TStrings) and TXHelper.MatchText('Delimiter|QuoteChar|StrictDelimiter|NameValueSeparator|LineBreak|Count|Strings|Objects'
                    + 'Capacity|CommaText|DelimitedText|Names|QuoteChar|Values|ValueFromIndex|Text|StringsAdapter', Data.PropertyName, False))
                  or ((Data.Obj is TStringList) and TXHelper.MatchText('Duplicates|Sorted|CaseSensitive|OwnsObjects', Data.PropertyName, False))
                  or ((Data.Obj is TComponent) and TXHelper.MatchText('Name|ComponentCount|Components'
                    + 'ComObject|ComponentIndex|ComponentState|ComponentStyle|DesignInfo|Owner|VCLComObject', Data.PropertyName, False))
                  or ((Data.Obj is TCollection) and TXHelper.MatchText('Capacity|Count|ItemClass|Items', Data.PropertyName, False))
                  or ((Data.Obj is TCollectionItem) and TXHelper.MatchText('DisplayName|Collection|ID|Index', Data.PropertyName, False)) Then
                Automatic := spAbort;
            xqCreateObject:
              If TXHelper.SameTextW(Data.ClassName, 'TStringList', False) Then
                Data.VarObj{$IF DELPHI < 2006}^{$IFEND} := TStringList.Create;
            xqCreateObjectC:
              If Data.ClassType.InheritsFrom(TComponent) Then Begin
                If Data.Parent is TComponent Then
                  Data.VarObj{$IF DELPHI < 2006}^{$IFEND} := TComponentClass(Data.ClassType).Create(TComponent(Data.Parent))
                Else Data.VarObj{$IF DELPHI < 2006}^{$IFEND} := TComponentClass(Data.ClassType).Create(nil);
              End Else If Data.ClassType.InheritsFrom(TCollectionItem) Then
                If Data.Parent is TCollection Then
                  Data.VarObj{$IF DELPHI < 2006}^{$IFEND} := TCollectionItemClass(Data.ClassType).Create(TCollection(Data.Parent))
                Else Data.VarObj{$IF DELPHI < 2006}^{$IFEND} := TCollectionItemClass(Data.ClassType).Create(nil);
            xqLoadObject: ;
            xqGetObject: ;

        {End Else If C is TObjectList Then Begin
          If (xsDefaultProperties in SOptions) or (TObjectList(C).Count > 0) Then Begin
            Node2 := Node._Nodes.Add('Objects');
            For i := 0 to TStrings(C).Count - 1 do Begin
              Node2._Nodes.Add('String').Text_D := TStrings(C).Strings[i];
              If (xsTStringsObjects in SOptions) and Assigned(TStrings(C).Objects[i]) Then
                Serialize_Object(Node2._Nodes.Add('Object'), TStrings(C).Objects[i], SOptions + [xsSaveClassType], Proc);
            End;
          End;}


            //  xqSaveObject:    ({in}  Obj:          TObject;
            //                    {out} Node:         TXMLNode);
            //  xqSaveProperty:  ({in}  Obj:          TObject;
            //                    {in}  PropertyName: TWideString;
            //                    {out} Node:         TXMLNode);
            //  xqCreateObject:  ({in}  Parent:       TObject;
            //                    {in}  ClassName:    TWideString;
            //                    {in}  ObjectName:   TWideString:
            //                    {out} VarObj:       ^TObject);
            //  xqCreateObjectC: ({in}  Parent:       TObject;
            //                    {in}  ClassType:    TClass;
            //                    {in}  ObjectName:   TWideString:
            //                    {out} VarObj:       ^TObject);
            //  xqLoadObject:    ({in}  Obj:          TObject;
            //                    {in}  Node:         TXMLNode);
            //  xqLoadProperty:  ({in}  Obj:          TObject;
            //                    {in}  PropertyName: TWideString;
            //                    {in}  Node:         TXMLNode);
            //  xqGetObject:     ({in}  ClassName:    TWideString;
            //                    {in}  ObjectName:   TWideString;
            //                    {out} VarObj:       ^TObject);
          End;
        End;

    {$ENDIF}

    Class Procedure TXHelper.Initialize;
      Procedure OpenLog(Var F: TextFile);
        Var i:  Integer;
          PIDL: Pointer;
          Path: Array[1..MAX_PATH] of Char;

        Begin
          If Succeeded(SHGetSpecialFolderLocation(0, 0{CSIDL_DESKTOP}, PIDL)) Then Begin
            If SHGetPathFromIDList(PIDL, @Path) Then Begin
              Try
                i := Length(ParamStr(0));
                While (i > 0) and (ParamStr(0)[i] <> SysUtils.PathDelim) do Dec(i);
                AssignFile(F, String(PChar(@Path)) + SysUtils.PathDelim
                  + Copy(ParamStr(0), i + 1, 888) + '.log');
                Try
                  {$i+}
                  Rewrite(F);
                Except
                  Raise EXMLException.Create(Self, 'Initialize', @SInternalError, [3], Exception(ExceptObject));
                End;
              Finally
                CoTaskMemFree(PIDL);
              End;
            End Else Begin
              CoTaskMemFree(PIDL);
              Raise EXMLException.Create(Self, 'Initialize', @SInternalError, 2);
            End;
          End Else Raise EXMLException.Create(Self, 'Initialize', @SInternalError, 1);
        End;

      Const toHex: Array[0..15] of Char = '0123456789ABCDEF';

      Var Chars, Chars2: Array[Word] of Word;
        C: Word;
        i: Integer;
        F: TextFile;

      Begin
        {$IF DELPHI >= 2006}
          __ShlWAPI        := LoadLibrary('ShlWAPI.dll');
          __StrCmpLogicalW := GetProcAddress(__ShlWAPI, 'StrCmpLogicalW');

          InitializeCriticalSection(__LockCArr);

          // create lower char list
          ZeroMemory(@Chars, SizeOf(Chars));
          For C := Low(Chars) to High(Chars) do Chars2[C] := C;
          CharLowerBuffW(@Chars2, Length(Chars));
          // copy lower blocks
          CopyMemory(@__LowerBlock0, @Chars2[Low(__LowerBlock0)], SizeOf(__LowerBlock0));
          CopyMemory(@__LowerBlock1, @Chars2[Low(__LowerBlock1)], SizeOf(__LowerBlock1));
          CopyMemory(@__LowerBlock2, @Chars2[Low(__LowerBlock2)], SizeOf(__LowerBlock2));
          CopyMemory(@__LowerBlock3, @Chars2[Low(__LowerBlock3)], SizeOf(__LowerBlock3));
          CopyMemory(@__LowerBlock4, @Chars2[Low(__LowerBlock4)], SizeOf(__LowerBlock4));
          CopyMemory(@__LowerBlock5, @Chars2[Low(__LowerBlock5)], SizeOf(__LowerBlock5));
          CopyMemory(@__LowerBlock6, @Chars2[Low(__LowerBlock6)], SizeOf(__LowerBlock6));
          CopyMemory(@__LowerBlock7, @Chars2[Low(__LowerBlock7)], SizeOf(__LowerBlock7));
          CopyMemory(@__LowerBlock8, @Chars2[Low(__LowerBlock8)], SizeOf(__LowerBlock8));
          CopyMemory(@__LowerBlock9, @Chars2[Low(__LowerBlock9)], SizeOf(__LowerBlock9));
          CopyMemory(@__LowerBlockA, @Chars2[Low(__LowerBlockA)], SizeOf(__LowerBlockA));
          // copy lowercase chars
          For C := Low(Chars) to High(Chars) do Begin
            If Chars2[C] <> C Then Chars[C] := Chars2[C];
            Chars2[C] := C;
          End;
          // create upper char list
          For C := Low(Chars) to High(Chars) do Chars2[C] := C;
          CharUpperBuffW(@Chars2, Length(Chars));
          // copy uppercase chars + check for lower/upper collisions + create check char list
          // + fill non-upper/lower chars (#0)
          For C := Low(Chars) to High(Chars) do Begin
            If Chars2[C] <> C Then
              If Chars[C] <> 0 Then Begin
                __CompareBlock0[Low(__CompareBlock0)] := #0;
                OpenLog(F);
                Try
                  WriteLn(F, '>>> himXML - initialize error <<<');
                  WriteLn(F, 'please contact the software distributor');
                  WriteLn(F, 'file:');
                  WriteLn(F, '  ', ParamStr(0));
                  WriteLn(F, 'date:');
                  WriteLn(F, '  ', DateTimeToStr(Now));
                  WriteLn(F, 'info:');
                  WriteLn(F, '  C         = #', Ord(C));
                  WriteLn(F, '  Chars2[C] = #', Ord(Chars2[C]));
                  WriteLn(F, '  Chars[C]  = #', Ord(Chars[C]));
                  WriteLn(F);
                  WriteLn(F, '*end*');
                Finally
                  CloseFile(F);
                End;
                Exit;
              End Else Chars[C] := Chars2[C];
            Chars2[C] := C;
            If Chars[C] = 0 Then Chars[C] := C;
          End;
          // copy upper/lower blocks
          CopyMemory(@__CompareBlock0, @Chars[Low(__CompareBlock0)], SizeOf(__CompareBlock0));
          CopyMemory(@__CompareBlock1, @Chars[Low(__CompareBlock1)], SizeOf(__CompareBlock1));
          CopyMemory(@__CompareBlock2, @Chars[Low(__CompareBlock2)], SizeOf(__CompareBlock2));
          CopyMemory(@__CompareBlock3, @Chars[Low(__CompareBlock3)], SizeOf(__CompareBlock3));
          CopyMemory(@__CompareBlock4, @Chars[Low(__CompareBlock4)], SizeOf(__CompareBlock4));
          CopyMemory(@__CompareBlock5, @Chars[Low(__CompareBlock5)], SizeOf(__CompareBlock5));
          CopyMemory(@__CompareBlock6, @Chars[Low(__CompareBlock6)], SizeOf(__CompareBlock6));
          CopyMemory(@__CompareBlock7, @Chars[Low(__CompareBlock7)], SizeOf(__CompareBlock7));
          CopyMemory(@__CompareBlock8, @Chars[Low(__CompareBlock8)], SizeOf(__CompareBlock8));
          CopyMemory(@__CompareBlock9, @Chars[Low(__CompareBlock9)], SizeOf(__CompareBlock9));
          CopyMemory(@__CompareBlockA, @Chars[Low(__CompareBlockA)], SizeOf(__CompareBlockA));
          // "delete" upper/lower blocks from char list
          CopyMemory(@Chars2[Low(__CompareBlock0)], @__CompareBlock0, SizeOf(__CompareBlock0));
          CopyMemory(@Chars2[Low(__CompareBlock1)], @__CompareBlock1, SizeOf(__CompareBlock1));
          CopyMemory(@Chars2[Low(__CompareBlock2)], @__CompareBlock2, SizeOf(__CompareBlock2));
          CopyMemory(@Chars2[Low(__CompareBlock3)], @__CompareBlock3, SizeOf(__CompareBlock3));
          CopyMemory(@Chars2[Low(__CompareBlock4)], @__CompareBlock4, SizeOf(__CompareBlock4));
          CopyMemory(@Chars2[Low(__CompareBlock5)], @__CompareBlock5, SizeOf(__CompareBlock5));
          CopyMemory(@Chars2[Low(__CompareBlock6)], @__CompareBlock6, SizeOf(__CompareBlock6));
          CopyMemory(@Chars2[Low(__CompareBlock7)], @__CompareBlock7, SizeOf(__CompareBlock7));
          CopyMemory(@Chars2[Low(__CompareBlock8)], @__CompareBlock8, SizeOf(__CompareBlock8));
          CopyMemory(@Chars2[Low(__CompareBlock9)], @__CompareBlock9, SizeOf(__CompareBlock9));
          CopyMemory(@Chars2[Low(__CompareBlockA)], @__CompareBlockA, SizeOf(__CompareBlockA));
          // check for chars out of upper/lower blocks
          If not CompareMem(@Chars, @Chars2, SizeOf(Chars)) Then Begin
            __CompareBlock0[Low(__CompareBlock0)] := #0;
            OpenLog(F);
            Try
              WriteLn(F, '>>> himXML - initialize error <<<');
              WriteLn(F, 'please contact the software distributor');
              WriteLn(F, 'file:');
              WriteLn(F, '  ', ParamStr(0));
              WriteLn(F, 'date:');
              WriteLn(F, '  ', DateTimeToStr(Now));
              WriteLn(F, 'chars:');
              For C := Low(Chars) to High(Chars) do
                If Chars[C] <> Chars2[C] Then Begin
                  Write(F, '  ');
                  For i := 3 downto 0 do Write(F, toHex[(C shr (i * 4)) and $0F]);
                  Write(F, ' [', C:5, ']: ');
                  For i := 3 downto 0 do Write(F, toHex[(Ord(Chars[C]) shr (i * 4)) and $0F]);
                  Write(F, ' ');
                  For i := 3 downto 0 do Write(F, toHex[(Ord(Chars2[C]) shr (i * 4)) and $0F]);
                  WriteLn(F);
                End;
              WriteLn(F);
              WriteLn(F, '*end*');
            Finally
              CloseFile(F);
            End;
          End;
        {$ELSE}
          TXHelper__ShlWAPI        := LoadLibrary('ShlWAPI.dll');
          TXHelper__StrCmpLogicalW := GetProcAddress(TXHelper__ShlWAPI, 'StrCmpLogicalW');

          InitializeCriticalSection(TXHelper__LockCArr);

          // create lower char list
          ZeroMemory(@Chars, SizeOf(Chars));
          For C := Low(Chars) to High(Chars) do Chars2[C] := C;
          CharLowerBuffW(@Chars2, Length(Chars));
          // copy lower blocks
          CopyMemory(@TXHelper__LowerBlock0, @Chars2[Low(TXHelper__LowerBlock0)], SizeOf(TXHelper__LowerBlock0));
          CopyMemory(@TXHelper__LowerBlock1, @Chars2[Low(TXHelper__LowerBlock1)], SizeOf(TXHelper__LowerBlock1));
          CopyMemory(@TXHelper__LowerBlock2, @Chars2[Low(TXHelper__LowerBlock2)], SizeOf(TXHelper__LowerBlock2));
          CopyMemory(@TXHelper__LowerBlock3, @Chars2[Low(TXHelper__LowerBlock3)], SizeOf(TXHelper__LowerBlock3));
          CopyMemory(@TXHelper__LowerBlock4, @Chars2[Low(TXHelper__LowerBlock4)], SizeOf(TXHelper__LowerBlock4));
          CopyMemory(@TXHelper__LowerBlock5, @Chars2[Low(TXHelper__LowerBlock5)], SizeOf(TXHelper__LowerBlock5));
          CopyMemory(@TXHelper__LowerBlock6, @Chars2[Low(TXHelper__LowerBlock6)], SizeOf(TXHelper__LowerBlock6));
          CopyMemory(@TXHelper__LowerBlock7, @Chars2[Low(TXHelper__LowerBlock7)], SizeOf(TXHelper__LowerBlock7));
          CopyMemory(@TXHelper__LowerBlock8, @Chars2[Low(TXHelper__LowerBlock8)], SizeOf(TXHelper__LowerBlock8));
          CopyMemory(@TXHelper__LowerBlock9, @Chars2[Low(TXHelper__LowerBlock9)], SizeOf(TXHelper__LowerBlock9));
          CopyMemory(@TXHelper__LowerBlockA, @Chars2[Low(TXHelper__LowerBlockA)], SizeOf(TXHelper__LowerBlockA));
          // copy lowercase chars
          For C := Low(Chars) to High(Chars) do Begin
            If Chars2[C] <> C Then Chars[C] := Chars2[C];
            Chars2[C] := C;
          End;
          // create upper char list
          For C := Low(Chars) to High(Chars) do Chars2[C] := C;
          CharUpperBuffW(@Chars2, Length(Chars));
          // copy uppercase chars + check for lower/upper collisions + create check char list
          // + fill non-upper/lower chars (#0)
          For C := Low(Chars) to High(Chars) do Begin
            If Chars2[C] <> C Then
              If Chars[C] <> 0 Then Begin
                TXHelper__CompareBlock0[Low(TXHelper__CompareBlock0)] := #0;
                OpenLog(F);
                Try
                  WriteLn(F, '>>> himXML - initialize error <<<');
                  WriteLn(F, 'please contact the software distributor');
                  WriteLn(F, 'file:');
                  WriteLn(F, '  ', ParamStr(0));
                  WriteLn(F, 'date:');
                  WriteLn(F, '  ', DateTimeToStr(Now));
                  WriteLn(F, 'info:');
                  WriteLn(F, '  C         = #', Ord(C));
                  WriteLn(F, '  Chars2[C] = #', Ord(Chars2[C]));
                  WriteLn(F, '  Chars[C]  = #', Ord(Chars[C]));
                  WriteLn(F);
                  WriteLn(F, '*end*');
                Finally
                  CloseFile(F);
                End;
                Exit;
              End Else Chars[C] := Chars2[C];
            Chars2[C] := C;
            If Chars[C] = 0 Then Chars[C] := C;
          End;
          // copy upper/lower blocks
          CopyMemory(@TXHelper__CompareBlock0, @Chars[Low(TXHelper__CompareBlock0)], SizeOf(TXHelper__CompareBlock0));
          CopyMemory(@TXHelper__CompareBlock1, @Chars[Low(TXHelper__CompareBlock1)], SizeOf(TXHelper__CompareBlock1));
          CopyMemory(@TXHelper__CompareBlock2, @Chars[Low(TXHelper__CompareBlock2)], SizeOf(TXHelper__CompareBlock2));
          CopyMemory(@TXHelper__CompareBlock3, @Chars[Low(TXHelper__CompareBlock3)], SizeOf(TXHelper__CompareBlock3));
          CopyMemory(@TXHelper__CompareBlock4, @Chars[Low(TXHelper__CompareBlock4)], SizeOf(TXHelper__CompareBlock4));
          CopyMemory(@TXHelper__CompareBlock5, @Chars[Low(TXHelper__CompareBlock5)], SizeOf(TXHelper__CompareBlock5));
          CopyMemory(@TXHelper__CompareBlock6, @Chars[Low(TXHelper__CompareBlock6)], SizeOf(TXHelper__CompareBlock6));
          CopyMemory(@TXHelper__CompareBlock7, @Chars[Low(TXHelper__CompareBlock7)], SizeOf(TXHelper__CompareBlock7));
          CopyMemory(@TXHelper__CompareBlock8, @Chars[Low(TXHelper__CompareBlock8)], SizeOf(TXHelper__CompareBlock8));
          CopyMemory(@TXHelper__CompareBlock9, @Chars[Low(TXHelper__CompareBlock9)], SizeOf(TXHelper__CompareBlock9));
          CopyMemory(@TXHelper__CompareBlockA, @Chars[Low(TXHelper__CompareBlockA)], SizeOf(TXHelper__CompareBlockA));
          // "delete" upper/lower blocks from char list
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock0)], @TXHelper__CompareBlock0, SizeOf(TXHelper__CompareBlock0));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock1)], @TXHelper__CompareBlock1, SizeOf(TXHelper__CompareBlock1));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock2)], @TXHelper__CompareBlock2, SizeOf(TXHelper__CompareBlock2));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock3)], @TXHelper__CompareBlock3, SizeOf(TXHelper__CompareBlock3));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock4)], @TXHelper__CompareBlock4, SizeOf(TXHelper__CompareBlock4));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock5)], @TXHelper__CompareBlock5, SizeOf(TXHelper__CompareBlock5));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock6)], @TXHelper__CompareBlock6, SizeOf(TXHelper__CompareBlock6));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock7)], @TXHelper__CompareBlock7, SizeOf(TXHelper__CompareBlock7));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock8)], @TXHelper__CompareBlock8, SizeOf(TXHelper__CompareBlock8));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlock9)], @TXHelper__CompareBlock9, SizeOf(TXHelper__CompareBlock9));
          CopyMemory(@Chars2[Low(TXHelper__CompareBlockA)], @TXHelper__CompareBlockA, SizeOf(TXHelper__CompareBlockA));
          // check for chars out of upper/lower blocks
          If not CompareMem(@Chars, @Chars2, SizeOf(Chars)) Then Begin
            TXHelper__CompareBlock0[Low(TXHelper__CompareBlock0)] := #0;
            OpenLog(F);
            Try
              WriteLn(F, '>>> himXML - initialize error <<<');
              WriteLn(F, 'please contact the software distributor');
              WriteLn(F, 'file:');
              WriteLn(F, '  ', ParamStr(0));
              WriteLn(F, 'date:');
              WriteLn(F, '  ', DateTimeToStr(Now));
              WriteLn(F, 'chars:');
              For C := Low(Chars) to High(Chars) do
                If Chars[C] <> Chars2[C] Then Begin
                  Write(F, '  ');
                  For i := 3 downto 0 do Write(F, toHex[(C shr (i * 4)) and $0F]);
                  Write(F, ' [', C:5, ']: ');
                  For i := 3 downto 0 do Write(F, toHex[(Ord(Chars[C]) shr (i * 4)) and $0F]);
                  Write(F, ' ');
                  For i := 3 downto 0 do Write(F, toHex[(Ord(Chars2[C]) shr (i * 4)) and $0F]);
                  WriteLn(F);
                End;
              WriteLn(F);
              WriteLn(F, '*end*');
            Finally
              CloseFile(F);
            End;
          End;
        {$IFEND}

        {$IFNDEF hxExcludeClassesUnit}
          RegisterSerProc(ClassSerializeProc);
        {$ENDIF}
//        hxExcludeContnrsUnit     if this is defined then TObjectList, TComponentList and TClassList can not serialized

//        RegisterSerClass(Contnrs.TObjectList{TObjectList});
//        RegisterSerClass(ComCtrls.TListItemClass{TListItem});
//        RegisterSerClass(ComCtrls.TTreeNodeClass{TTreeNode});
//        RegisterSerClass(Graphics.TGraphicClass{TGraphic});
//
//        RegisterSerClass(MxArrays.TSmallIntArray{TSmallIntArray});
//        RegisterSerClass(MxArrays.TIntArray{TIntArray});
//        RegisterSerClass(MxArrays.TSingleArray{TSingleArray});
//        RegisterSerClass(MxArrays.TDoubleArray{TDoubleArray});
//        RegisterSerClass(MxArrays.TCurrencyArray{TCurrencyArray});
//        RegisterSerClass(MxArrays.TWordArray{TWordArray});
//        RegisterSerClass(MxArrays.TStringArray{TStringArray});

        SetValueSerProc(tkInteger, 'TColor',    ColorVSerial,    ColorVDeserial);
        SetValueSerProc(tkFloat,   'TDateTime', DateTimeVSerial, DateTimeVDeserial, 7{Date|Time|mSec});
        SetValueSerProc(tkFloat,   'TDate',     DateTimeVSerial, DateTimeVDeserial, 1{Date});
        SetValueSerProc(tkFloat,   'TTime',     DateTimeVSerial, DateTimeVDeserial, 6{Time|mSec});
      End;

    Class Procedure TXHelper.Finalize;
      Begin
        {$IF DELPHI >= 2006}
          DeleteCriticalSection(__LockCArr);
          FreeLibrary(__ShlWAPI);
        {$ELSE}
          DeleteCriticalSection(TXHelper__LockCArr);
          FreeLibrary(TXHelper__ShlWAPI);
        {$IFEND}
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TXReader'}{$IFEND}

    Procedure TXReader.SetBuffer(Size: Integer);
      Var i: Integer;

      Begin
        If _Buffer.Length <= FileBufferSize + FileBufferSize_Overflow Then Begin
          If Size > FileBufferSize + FileBufferSize_Overflow Then Begin
            If Size < _Buffer.Length Then i := Size Else i := _Buffer.Length;
            SetLength(_Buffer.XData,     Size);
            SetLength(_Buffer.XCharSize, Size);
            CopyMemory(Pointer(_Buffer.XData),     @_Buffer.Data,     i * 2);
            CopyMemory(Pointer(_Buffer.XCharSize), @_Buffer.CharSize, i);
          End;
        End Else Begin
          If Size <= FileBufferSize + FileBufferSize_Overflow Then Begin
            If Size < _Buffer.Length Then i := Size Else i := _Buffer.Length;
            CopyMemory(@_Buffer.Data,     Pointer(_Buffer.XData),     i * 2);
            CopyMemory(@_Buffer.CharSize, Pointer(_Buffer.XCharSize), i);
            _Buffer.XData     := '';
            _Buffer.XCharSize := '';
          End Else Begin
            SetLength(_Buffer.XData,     Size);
            SetLength(_Buffer.XCharSize, Size);
          End;
        End;
        _Buffer.Length := Size;
      End;

    Function TXReader.GetDataP: PWideChar;
      {inline}

      Begin
        If _Buffer.Length <= FileBufferSize + FileBufferSize_Overflow Then
          Result := @_Buffer.Data Else Result := Pointer(_Buffer.XData);
      End;

    Function TXReader.GetCharSizeP: PAnsiChar;
      {inline}

      Begin
        If _Buffer.Length <= FileBufferSize + FileBufferSize_Overflow Then
          Result := @_Buffer.CharSize Else Result := Pointer(_Buffer.XCharSize);
      End;

    Procedure TXReader.ReadBOM;
      Var E:   TXMLEncoding;
        S, S2: RawByteString;

      Begin
        SetLength(S, 4);
        SetLength(S, _Stream.Read(PAnsiChar(S)^, Length(S)));
        If (Length(S) >= 4) and (PLongWord(S)^ = $003F003C) {'<0?0'} Then
          _Encoding := xeUnicode
        Else If (Length(S) >= 4) and (PLongWord(S)^ = $3F003C00) {'0<0?'} Then
          _Encoding := xeUnicodeBE
        Else Begin
          E := Low(TXMLEncoding);
          While E <= High(TXMLEncoding) do Begin
            S2 := XMLEncodingData[E].BOM;
            If (S2 <> '') and (Copy(S, 1, Length(S2)) = S2) Then Break;
            Inc(E);
          End;
          If E <= High(TXMLEncoding) Then Begin
            _Stream.Seek(Length(XMLEncodingData[E].BOM) - Length(S), soCurrent);
            _Encoding := E;
          End Else _Stream.Seek(-Length(S), soCurrent);
        End;
      End;

    Function TXReader.ReadData: Boolean;
      Var TempLen: Integer;
        i, i2:     Integer;
        C:         AnsiChar;
        P, Pe, P1: PAnsiChar;
        P2:        PWideChar;
        CP:        TCPInfo;

      Begin
        TempLen := _Stream.Read(_Temp, SizeOf(_Temp));
        Result  := TempLen > 0;
        If not Result Then
          If _Stream.Position >= _Stream.Size Then Exit
          Else Raise EXMLException.Create(ClassType, 'ReadData', @SReadError);
        Case _Encoding of
          xeUTF7: Raise EXMLException.Create(ClassType, 'ReadData', @SNotImplemented, 'UTF-7');
          xeUTF8: Begin
            i := TempLen;
            While (i > 0) and (Byte(_Temp[i]) and $C0 = $80) do Dec(i);
            If (i > 0) and (Byte(_Temp[i]) and $C0 = $C0) Then Dec(i);
            P  := @_Temp;
            Pe := P + i;
            i  := 0;
            For i2 := TempLen - 1 downto 0 do
              If Byte(_Temp[i2 + 1]) and $C0 <> $80 Then Inc(i);
            i2 := _Buffer.Length;
            P2 := GetDataP + i2;
            Try
              SetBuffer(i2 + i);
              FillMemory(GetCharSizeP + i2, i, 1);
              P2 := GetDataP     + i2;
              P1 := GetCharSizeP + i2;
              While P < Pe do
                If Byte(P^) and $80 = 0 Then Begin
                  Word(P2^) := Byte(P^);
                  Inc(P);
                  Inc(P2);
                  Inc(P1);
                End Else If (Byte(P^) and $E0 = $C0) and (P + 1 < Pe)
                    and (Byte(P[1]) and $C0 = $80) Then Begin
                  Word(P2^) := (Word(Byte(P^) and $1F) shl 6) or (Byte(P[1]) and $3F);
                  Byte(P1^) := 2;
                  Inc(P, 2);
                  Inc(P2);
                  Inc(P1);
                End Else If (Byte(P^) and $F0 = $E0) and (P + 2 < Pe)
                    and (Byte(P[1]) and $C0 = $80) and (Byte(P[2]) and $C0 = $80) Then Begin
                  Word(P2^) := (Word(Byte(P^) and $0F) shl 12)
                    or (Word(Byte(P[1]) and $3F) shl 6) or (Byte(P[2]) and $3F);
                  Byte(P1^) := 3;
                  Inc(P, 3);
                  Inc(P2);
                  Inc(P1);
                End Else If (Byte(P^) and $F8 = $F0) and (P + 3 < Pe)
                    and (Byte(P[1]) and $C0 = $80) and (Byte(P[2]) and $C0 = $80)
                    and (Byte(P[3]) and $C0 = $80) Then Begin
                  Word(P2^) := Ord('?');
                  Byte(P1^) := 4;
                  Inc(P, 4);
                  Inc(P2);
                  Inc(P1);
                End Else Break;
            Finally
              If P - @_Temp < TempLen Then _Stream.Seek((P - @_Temp) - TempLen, soCurrent);
              SetBuffer(P2 - GetDataP);
              Result := P <> @_Temp;
              If not Result Then Begin
                i  := P - @_Temp;
                i2 := TempLen - i;
                If i2 > 15 Then i2 := 15;
                Raise EXMLException.Create(ClassType, 'ReadData', @SCorruptedUtf8, Copy(_Temp, i + 1, i2));
              End;
            End;
          End;
          xeUnicode, xeUnicodeBE:
            If TempLen > 1 Then Begin
              i := TempLen div 2;
              If _Encoding = xeUnicodeBE Then
                For i2 := i - 1 downto 0 do Begin
                  C                 := _Temp[i2 * 2 + 1];
                  _Temp[i2 * 2 + 1] := _Temp[i2 * 2 + 2];
                  _Temp[i2 * 2 + 2] := C;
                End;
              i2 := _Buffer.Length;
              Try
                SetBuffer(i2 + i);
                CopyMemory(GetDataP + i2, @_Temp, i * 2);
                FillMemory(GetCharSizeP + i2, i, 2);
                If i * 2 <> TempLen Then _Stream.Seek(i * 2 - TempLen, soCurrent);
              Except
                SetBuffer(i2);
                Raise;
              End;
            End;
          xeIso2022Jp: Raise EXMLException.Create(ClassType, 'ReadData', @SNotImplemented, 'ISO-2022-JP');
          Else Begin
            With XMLEncodingData[_Encoding] do Begin
              If (CodePage = 0) or not GetCPInfo(CodePage, CP)
                  or ((CP.MaxCharSize > 1) and (CP.LeadByte[1] = 0)) Then
                Raise EXMLException.Create(ClassType, 'ReadData', @SNotImplemented, Encoding);
              i := MultiByteToWideChar(CodePage, 8{MB_ERR_INVALID_CHARS}, @_Temp, TempLen, nil, 0);
              If ((i = 0) and (TempLen > 0)) or (i > TempLen) Then
                Raise EXMLException.Create(ClassType, 'ReadData', @SInvalidEncoding);
              i2 := _Buffer.Length;
              Try
                SetBuffer(i2 + i);
                If i > 0 Then
                  i := MultiByteToWideChar(CodePage, 8{MB_ERR_INVALID_CHARS}, @_Temp, TempLen, GetDataP + i2, i);
                If i <> _Buffer.Length - i2 Then
                  Raise EXMLException.Create(ClassType, 'ReadData', @SInvalidEncoding);
                If _Buffer.Length - i2 < TempLen Then Begin
                  P  := @_Temp;
                  Pe := P + TempLen;
                  P1 := GetCharSizeP + i2 - 1;
                  While (P < Pe) and (P1 < GetCharSizeP + _Buffer.Length) do Begin
                    i := Integer(CharNextExA(CodePage, P, 0) - P);
                    If i <= 0 Then Break;
                    Byte(P1^) := i;
                    Inc(P, i);
                    Inc(P1);
                  End;
                  If (P <> Pe) or (P1 <> GetCharSizeP + _Buffer.Length) Then
                    Raise EXMLException.Create(ClassType, 'ReadData', @SInvalidEncoding);
                End Else FillMemory(GetCharSizeP + i2, i, 1);
              Except
                SetBuffer(i2);
                Raise;
              End;
            End;
          End;
        End;
      End;

    Procedure TXReader.CopyData(Var S: TWideString; i, Len: Integer);
      Begin
        If Len > _Buffer.Length - _Buffer.Pos Then Len := _Buffer.Length - _Buffer.Pos;
        SetLength(S, Len);
        CopyMemory(Pointer(S), GetDataP + (i - 1), Len * 2);
      End;

    Function TXReader.CheckLen(L: Integer; Var i: Integer; Var P: PWideChar): Boolean;
      Var Ps:       PAnsiChar;
        i3, i4, i5: Integer;

      Begin
        Result := i + L < _Buffer.Length;
        If not Result and _MoreDataExists Then Begin
          Dec(i, _Buffer.Pos);
          DeleteTemp(_Buffer.Pos);
          _MoreDataExists := ReadData;
          P := GetDataP;
          For i3 := 0 to _Buffer.Length - 1 do
            If not TXHelper.isChar(P[i3]) Then
              If P[i3] = #0 Then Begin
                Ps := GetCharSizeP;
                i5 := 0;
                For i4 := i3 to _Buffer.Length - 1 do Dec(i5, Byte(Ps[i4]));
                _Stream.Seek(i5, soCurrent);
                SetBuffer(i3);
                _MoreDataExists := False;
                Break;
              End Else If not (xoChangeInvalidChars in _Options) Then Begin
                _Buffer.Pos := i3;
                Raise EXMLException.Create(ClassType, 'CheckLen', @SInvalidChar, P[i3]);
              End Else P[i3] := ' ';
          P := GetDataP;
          Result := i + L < _Buffer.Length;
        End;
      End;

    Function TXReader.CheckLB(i, i2: Integer): Boolean;
      Var P: PWideChar;

      Begin
        P := GetDataP;
        While i < i2 do
          Case P[i] of
            #10, #13: Begin
                        Result := True;
                        Exit;
                      End;
            Else      Inc(i);
          End;
        Result := False;
      End;

    Function TXReader.Search(Var P: PWideChar; Var i: Integer; T: Byte): Boolean;
      Var i2: Integer;
        X:    Set of (Xqout, Xapos, Xdeli);

      Begin
        i2 := _Buffer.Length;
        Case T of
          0{isSpace...}:
            While True do Begin
              If i >= i2 Then Begin
                If not CheckLen(0, i, P) Then Break;
                i2 := _Buffer.Length;
              End;
              If not TXHelper.isSpace(P[i]) Then Break;
              Inc(i);
            End;
          1{isName...}:
            While True do Begin
              If i >= i2 Then Begin
                If not CheckLen(0, i, P) Then Break;
                i2 := _Buffer.Length;
              End;
              If not TXHelper.isName(P[i]) Then Break;
              Inc(i);
            End;
          2{..."}:
            While True do Begin
              If i >= i2 Then Begin
                If not CheckLen(0, i, P) Then Break;
                i2 := _Buffer.Length;
              End;
              If P[i] = '"' Then Break;
              Inc(i);
          End;
          3{...'}:
            While True do Begin
              If i >= i2 Then Begin
                If not CheckLen(0, i, P) Then Break;
                i2 := _Buffer.Length;
              End;
              If P[i] = '''' Then Break;
              Inc(i);
            End;
          4{...]]>}:
            While True do Begin
              If i + 2 >= i2 Then Begin
                If not CheckLen(2, i, P) Then Break;
                i2 := _Buffer.Length;
              End;
              If (P[i] = ']') and (P[i + 1] = ']') and (P[i + 2] = '>') Then Break;
              Inc(i);
            End;
          5{...]]>}:
            While True do Begin
              If i + 2 >= i2 Then Begin
                If not CheckLen(2, i, P) Then Break;
                i2 := _Buffer.Length;
              End;
              If (P[i] = '-') and (P[i + 1] = '-') and (P[i + 2] = '>') Then Break;
              Inc(i);
            End;
          6{...[...]>}: Begin
            X := [];
            While True do Begin
              If i >= i2 Then Begin
                If not CheckLen(0, i, P) Then Break;
                i2 := _Buffer.Length;
              End;
              Case P[i] of
                '[':      If X * [Xqout, Xapos] = [] Then
                            If Xdeli in X Then Break Else Include(X, Xdeli);
                ']':      If X * [Xqout, Xapos] = [] Then
                            If not (Xdeli in X) or not CheckLen(1, i, P) or (P[i + 1] <> '>') Then
                              Break Else Exclude(X, Xdeli);
                '=':      ;
                '"':      If not (Xapos in X) Then
                            If Xqout in X Then Exclude(X, Xqout) Else Include(X, Xqout);
                '''':     If not (Xqout in X) Then
                            If Xapos in X Then Exclude(X, Xapos) Else Include(X, Xapos);
                '<', '>': If X * [Xdeli, Xqout, Xapos] = [] Then Break;
              End;
              Inc(i);
            End;
            Result := X = [];
            Exit;
          End;
          7{...<}:
            While True do Begin
              If i >= i2 Then Begin
                If not CheckLen(0, i, P) Then Break;
                i2 := _Buffer.Length;
              End;
              If P[i] = '<' Then Break;
              Inc(i);
            End;
        End;
        Result := True;
      End;

    Procedure TXReader.DeleteTemp(Len: Integer);
      Var P: PWideChar;
        i:   Integer;

      Begin
        If Len > _Buffer.Length Then Len := _Buffer.Length
        Else If Len <= 0 Then Exit;
        P := GetDataP;
        i := Len;
        While i > 0 do Begin
          Case P^ of
            #$0A, #$0085, #$2028: Begin
              Inc(_Lines);
              _Col := 0;
            End;
            #$0D: Begin
              If (i > 1) and ((P + 1)^ = #$0A) or ((P + 1)^ = #$0085) Then Begin
                Inc(P);
                Dec(i);
              End;
              Inc(_Lines);
              _Col := 0;
            End;
            Else Inc(_Col);
          End;
          Inc(P);
          Dec(i);
        End;
        CopyMemory(GetDataP,     GetDataP     + Len, (_Buffer.Length - Len) * 2);
        CopyMemory(GetCharSizeP, GetCharSizeP + Len,  _Buffer.Length - Len);
        SetBuffer(_Buffer.Length - Len);
        Dec(_Buffer.Pos, Len);
      End;

    Procedure TXReader.ClearTemp;
      Var Ps:  PAnsiChar;
        i, i2: Integer;

      Begin
        Ps := GetCharSizeP;
        i2 := 0;
        For i := _Buffer.Length - 1 downto 0 do Dec(i2, Byte(Ps[i]));
        _Stream.Seek(i2, soCurrent);
        SetBuffer(0);
        _Buffer.Pos := 0;
      End;

    Constructor TXReader.Create(Stream: TStream; Options: TXMLOptions; StartEncoding: TXMLEncoding = xeUTF8);
      Begin
        Inherited Create;
        _Stream         := Stream;
        _StreamStart    := Stream.Position;
      //SetBuffer(0);
      //_Lines          := 0;
      //_Col            := 0;
        _MoreDataExists := True;
      //_Temp
        _Options        := Options;
        _Version        := xvXML10;
        _Encoding       := StartEncoding;
        _NodeType       := xdText;
        _DataType       := xdText;
      //_Value          := '';
      //_Name           := '';
      //_LFBefore       := False;
        If _Encoding > High(TXMLEncoding) Then _Encoding := xeUTF8;
        ReadBOM;
      End;

    Procedure TXReader.SetVer(Version: TXMLVersion);
      {inline}

      Begin
        _Version := Version;
      End;

    Procedure TXReader.SetEnc(Encoding: TXMLEncoding);
      Begin
        If Encoding = _Encoding Then Exit;
        If (Encoding > High(TXMLEncoding))
            or (XMLEncodingData[_Encoding].CharSize > XMLEncodingData[Encoding].CharSize) Then
          Raise EXMLException.Create(ClassType, 'SetEnc', @SUnknownEncoding);
        DeleteTemp(_Buffer.Pos);
        ClearTemp;
        _Encoding := Encoding;
      End;

    Function TXReader.Parse: Boolean;
      Var i:    Integer;
        i2, i3: Int64;
        S:      TWideString;
        P:      PWideChar;

      Begin
        Try
          i := _Buffer.Pos;
          P := GetDataP;
          Search(P, i, 0{isSpace...});

          If not CheckLen(0, i, P) Then Begin
            _LFBefore := CheckLB(_Buffer.Pos, _Buffer.Length);
            _NodeType := xdText;
            _DataType := xdText;
            _Value    := '';
            _Name     := '';
            DeleteTemp(_Buffer.Length);
            Result := False;
            Exit;

          End Else If (_NodeType = xdText) and (P[i] = '<')
              and CheckLen(1, i, P) and (P[i + 1] = '?') Then Begin
            // xtInstruction   <?name attributes ?>

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            _NodeType   := xdInstruction;
            _DataType   := xdInstruction;
            _Value      := '';
            _Name       := ''; {*}
            _Buffer.Pos := i;
            Inc(i, 2);
            If CheckLen(0, i, P) and TXHelper.isNameStart(P[i]) Then Begin
              Inc(i);
              Search(P, i, 1{isName...});
            End;
            CopyData(_Name, _Buffer.Pos + 3, i - _Buffer.Pos - 2);
            If not TXHelper.CheckString(_Name, xtInstruction_NodeName) Then
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidName, _Name);
            _Buffer.Pos := i;

          End Else If (_NodeType = xdInstruction) and (P[i] = '?')
              and CheckLen(1, i, P) and (P[i + 1] = '>') Then Begin
            // end of xtInstruction   ?>

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            _NodeType   := xdText;
            _DataType   := xdCloseSingle;
            _Value      := '';
            _Name       := '';
            _Buffer.Pos := i + 2;

          End Else If (_NodeType = xdText) and (P[i] = '<') and CheckLen(2, i, P)
              and (P[i + 1] = '!') and (P[i + 2] = '[') Then Begin
            // xtCData   <![CDATA[data]]>

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            _NodeType   := xdCData;
            _DataType   := xdCData;
            _Value      := '';
            _Name       := ''; {*}
            _Buffer.Pos := i;
            Inc(i, 3);
            Search(P, i, 1{isName...});
            CopyData(_Name, _Buffer.Pos + 4, i - _Buffer.Pos - 3);
            If not TXHelper.SameTextW(_Name, 'CDATA', xoCaseSensitive in _Options) Then
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidName, _Name)
            Else If not CheckLen(0, i, P) Then
              Raise EXMLException.Create(ClassType, 'Parse', @SEndOfData)
            Else If P[i] <> '[' Then
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidChar, P[i]);
            _Buffer.Pos := i + 1;
            _Name       := ''; {himXML don't save this name}

          End Else If _NodeType = xdCData Then Begin
            If _DataType = xdCData Then Begin
              // text from xtCData

              _LFBefore   := False;//CheckLB(_Buffer.Pos, i);
              //_NodeType := xdCData;
              _DataType   := xdText;
              _Value      := ''; {*}
              _Name       := '';
              Search(P, i, 4{...]]>});
              CopyData(_Value, _Buffer.Pos + 1, i - _Buffer.Pos);
              If not TXHelper.ConvertString(_Value, xtCData_LoadText, _Options, {not used} '', '', '') Then
                Raise EXMLException.Create(ClassType, 'Parse', @SInvalidValue, _Value);
              _Buffer.Pos := i;

            End Else If (P[i] = ']') and CheckLen(2, i, P) and (P[i + 1] = ']') and (P[i + 2] = '>') Then Begin
              // end of xtCData   ]]>

              _LFBefore   := CheckLB(_Buffer.Pos, i);
              _NodeType   := xdText;
              _DataType   := xdCloseSingle;
              _Value      := '';
              _Name       := '';
              _Buffer.Pos := i + 3;

            End Else Begin
              CopyData(S, i, 3);
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidData, S);
            End;

          End Else If (_NodeType = xdText) and (P[i] = '<') and CheckLen(3, i, P)
              and (P[i + 1] = '!') and (P[i + 2] = '-') and (P[i + 3] = '-') Then Begin
            // xtComment   <!--data-->

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            _NodeType   := xdComment;
            _DataType   := xdComment;
            _Value      := '';
            _Name       := '';
            _Buffer.Pos := i + 4;

          End Else If _NodeType = xdComment Then Begin
            If _DataType = xdComment Then Begin
              // text from xtComment

              _LFBefore   := False;//CheckLB(_Buffer.Pos, i);
              //_NodeType := xdComment;
              _DataType   := xdText;
              _Value      := ''; {*}
              _Name       := '';
              Search(P, i, 5{...-->});
              CopyData(_Value, _Buffer.Pos + 1, i - _Buffer.Pos);
              If not TXHelper.ConvertString(_Value, xtComment_LoadText, _Options, {not used} '', '', '') Then
                Raise EXMLException.Create(ClassType, 'Parse', @SInvalidValue, _Value);
              _Buffer.Pos := i;

            End Else If (P[i] = '-') and CheckLen(2, i, P) and (P[i + 1] = '-') and (P[i + 2] = '>') Then Begin
              // end of xtComment   -->

              _LFBefore   := CheckLB(_Buffer.Pos, i);
              _NodeType   := xdText;
              _DataType   := xdCloseSingle;
              _Value      := '';
              _Name       := '';
              _Buffer.Pos := i + 3;

            End Else Begin
              CopyData(S, i, 3);
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidData, S);
            End;

          End Else If (_NodeType = xdText) and (P[i] = '<')
              and CheckLen(1, i, P) and (P[i + 1] = '!') Then Begin
            // xtTypedef   <!name data>  or  <!name data...[...data]>

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            _NodeType   := xdTypedef;
            _DataType   := xdTypedef;
            _Value      := '';
            _Name       := ''; {*}
            _Buffer.Pos := i;
            Inc(i, 2);
            Search(P, i, 1{isName...});
            CopyData(_Name, _Buffer.Pos + 3, i - _Buffer.Pos - 2);
            If not TXHelper.CheckString(_Name, xtTypedef_NodeName) Then
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidName, _Name);
            _Buffer.Pos := i;

          End Else If _NodeType = xdTypedef Then Begin
            If _DataType = xdTypedef Then Begin
              // text from xtTypedef

              _LFBefore := False;//CheckLB(_Buffer.Pos, i);
            //_NodeType := xdTypedef;
              _DataType := xdText;
              _Value    := ''; {*}
              _Name     := '';
              If not Search(P, i, 6{...[...]>}) Then Begin
                _Buffer.Pos := i;
                If CheckLen(0, i, P) Then
                  Raise EXMLException.Create(ClassType, 'Parse', @SInvalidValueN)
                Else
                  Raise EXMLException.Create(ClassType, 'Parse', @SEndOfData);
              End;
              CopyData(_Value, _Buffer.Pos + 1, i - _Buffer.Pos);
              If not TXHelper.ConvertString(_Value, xtTypedef_LoadText, _Options, {not used} '', '', '') Then
                Raise EXMLException.Create(ClassType, 'Parse', @SInvalidValue, _Value);
              _Buffer.Pos := i;

            End Else If P[i] = '>' Then Begin
              // end of xtTypedef   >

              _LFBefore   := CheckLB(_Buffer.Pos, i);
              _NodeType   := xdText;
              _DataType   := xdCloseSingle;
              _Value      := '';
              _Name       := '';
              _Buffer.Pos := i + 1;

            End Else Raise EXMLException.Create(ClassType, 'Parse', @SInvalidChar, P[i]);

          End Else If (_NodeType = xdText) and (P[i] = '<')
              and CheckLen(1, i, P) and (P[i + 1] = '/') Then Begin
            // end tag from xtElement   </name>

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            _NodeType   := xdText;
            _DataType   := xdClose;
            _Value      := '';
            _Name       := ''; {*}
            _Buffer.Pos := i;
            Inc(i, 2);
            If CheckLen(0, i, P) and TXHelper.isNameStart(P[i]) Then Begin
              Inc(i);
              Search(P, i, 1{isName...});
            End;
            CopyData(_Name, _Buffer.Pos + 3, i - _Buffer.Pos - 2);
            Search(P, i, 0{isSpace...});
            _Buffer.Pos := i;
            If not CheckLen(0, i, P) Then
              Raise EXMLException.Create(ClassType, 'Parse', @SEndOfData)
            Else If P[i] <> '>' Then
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidChar, P[i]);
            _Buffer.Pos := i + 1;

          End Else If (_NodeType = xdText) and (P[i] = '<') Then Begin
            // xtElement   <name>  or  <name/>

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            _NodeType   := xdElement;
            _DataType   := xdElement;
            _Value      := '';
            _Name       := ''; {*}
            _Buffer.Pos := i;
            Inc(i, 1);
            If CheckLen(0, i, P) and TXHelper.isNameStart(P[i]) Then Begin
              Inc(i);
              Search(P, i, 1{isName...});
            End;
            CopyData(_Name, _Buffer.Pos + 2, i - _Buffer.Pos - 1);
            If not TXHelper.CheckString(_Name, xtElement_NodeName) Then
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidName, _Name);
            _Buffer.Pos := i;

          End Else If (_NodeType = xdElement) and (P[i] = '>') Then Begin
            // end of xtElement   >

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            _NodeType   := xdText;
            _DataType   := xdEndAttribute;
            _Value      := '';
            _Name       := '';
            _Buffer.Pos := i + 1;

          End Else If (_NodeType = xdElement) and (P[i] = '/')
              and CheckLen(1, i, P) and (P[i + 1] = '>') Then Begin
            // end of xtElement   />

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            _NodeType   := xdText;
            _DataType   := xdCloseSingle;
            _Value      := '';
            _Name       := '';
            _Buffer.Pos := i + 2;

          End Else If (_NodeType in [xdInstruction, xdElement]) and TXHelper.isNameStart(P[i]) Then Begin
            // attributes from xdInstruction or xdElement

            _LFBefore   := CheckLB(_Buffer.Pos, i);
            //_NodeType := xdElement or xdInstruction;
            _DataType   := xdAttribute;
            _Value      := ''; {*}
            _Name       := ''; {*}
            _Buffer.Pos := i;
            Inc(i);
            Search(P, i, 1{isName...});
            CopyData(_Name, _Buffer.Pos + 1, i - _Buffer.Pos);
            If not TXHelper.CheckString(_Name, xtAttribute_Name) Then
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidName, _Name);
            Search(P, i, 0{isSpace...});
            If not CheckLen(0, i, P) Then
              Raise EXMLException.Create(ClassType, 'Parse', @SEndOfData)
            Else If P[i] <> '=' Then
              Raise EXMLException.Create(ClassType, 'Parse', @SCharNotFound, '=');
            Inc(i);
            Search(P, i, 0{isSpace...});
            _Buffer.Pos := i;
            If CheckLen(0, i, P) and ((P[i] = '"') or (P[i] = '''')) Then Begin
              Inc(i);
              If P[_Buffer.Pos] = '"' Then Search(P, i, 2{..."}) Else Search(P, i, 3{...'});
              If not CheckLen(0, i, P) Then
                Raise EXMLException.Create(ClassType, 'Parse', @SEndOfData)
              Else If P[i] <> P[_Buffer.Pos] Then
                Raise EXMLException.Create(ClassType, 'Parse', @SInvalidValueN);
              Inc(i);
              CopyData(_Value, _Buffer.Pos + 2, i - _Buffer.Pos - 2);
            End Else Begin
              Search(P, i, 1{isName...});
              CopyData(_Value, _Buffer.Pos + 1, i - _Buffer.Pos);
            End;
            If not TXHelper.ConvertString(_Value, xtAttribute_LoadValue, _Options, {not used} '', '', '') Then
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidValue, _Value);
            _Buffer.Pos := i;

          End Else If _NodeType = xdText Then Begin
            // xdText   data

            _LFBefore   := CheckLB(_Buffer.Pos, i) and not (xoNormalizeText in _Options);
            _NodeType   := xdText;
            _DataType   := xdText;
            _Value      := ''; {*}
            _Name       := '';
            Search(P, i, 7{...<});
            CopyData(_Value, _Buffer.Pos + 1, i - _Buffer.Pos);
            If not TXHelper.ConvertString(_Value, xtElement_LoadText, _Options, {not used} '', '', '') Then
              Raise EXMLException.Create(ClassType, 'Parse', @SInvalidValue, _Value);
            _Buffer.Pos := i;

          End Else Begin
            CopyData(S, i, {$IF DELPHI >= 2006}EXMLException.{$IFEND}MaxXMLErrStr + 1);
            Raise EXMLException.Create(ClassType, 'Parse', @SInvalidData, S);
          End;
          Result := True;
        Except
          DeleteTemp(_Buffer.Pos);
          i2 := _Lines + 1;
          i3 := _Col   + 1;
          i  := _Buffer.Length;
          If i > {$IF DELPHI >= 2006}EXMLException.{$IFEND}MaxXMLErrStr Then i := {$IF DELPHI >= 2006}EXMLException.{$IFEND}MaxXMLErrStr + 1;
          CopyData(S, 1, i);
          ClearTemp;
          Raise EXMLException.Create(ClassType, 'Parse', @SErrorPos,
            [i2 / 1, i3 / 1, '"' + EXMLException.Str(S) + '" ', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Procedure TXReader.CloseSingleNode;
      Begin
        If (_NodeType = xdText) and (_DataType = xdEndAttribute) Then Begin
          _NodeType := xdText;
          _DataType := xdCloseSingle;
          //_Value  := '';
          //_Name   := '';
        End Else Raise EXMLException.Create(ClassType, 'CloseNode', @SInvalidState);
      End;

    Function TXReader.Position: Int64;
      {inline}

      Begin
        Result := _Stream.Position - _StreamStart + _Buffer.Pos;
      End;

    Function TXReader.Size: Int64;
      {inline}

      Begin
        Result := _Stream.Size - _StreamStart;
      End;

    Function TXReader.EoF: Boolean;
      {inline}

      Begin
        Result := Position >= Size;
      End;

    Destructor TXReader.Destroy;
      Begin
        DeleteTemp(_Buffer.Pos);
        ClearTemp;
        Inherited;
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'TXWriter'}{$IFEND}

    Procedure TXWriter.WriteDataX(Data: PWideChar; Len: Integer);
      Var R:  RawByteString;
        i:    Integer;
        Temp: AnsiChar;
        P:    PAnsiChar;
        CP:   TCPInfo;

      Begin
        Case _Encoding of
          xeUnicode, xeUnicodeBE: Begin
            SetLength(R, Len * 2);
            CopyMemory(PAnsiChar(R), Data, Len * 2);
            If _Encoding = xeUnicodeBE Then Begin
              P := PAnsiChar(R);
              For i := Len - 1 downto 0 do Begin
                Temp := P[0];
                P[0] := P[1];
                P[1] := Temp;
                Inc(P, 2);
              End;
            End;
            _Stream.WriteBuffer(PAnsiChar(R)^, Length(R));
          End;
          Else
            With XMLEncodingData[_Encoding] do Begin
              If (CodePage = 0) or not GetCPInfo(CodePage, CP) Then
                Raise EXMLException.Create(ClassType, 'WriteDataX', @SNotImplemented, Encoding);
              i := WideCharToMultiByte(CodePage, 0, Data, Len, nil, 0, nil, nil);
              If i < Len Then Raise EXMLException.Create(ClassType, 'WriteDataX', @SInvalidEncoding);
              SetLength(R, i);
              i := WideCharToMultiByte(CodePage, 0, Data, Len, PAnsiChar(R), Length(R), nil, nil);
              If i <> Length(R) Then Raise EXMLException.Create(ClassType, 'WriteDataX', @SInvalidEncoding);
              _Stream.WriteBuffer(PAnsiChar(R)^, Length(R));
            End;
        End;
      End;

    Procedure TXWriter.WriteData(Const Data: TWideString);
      Var P:   PWideChar;
        i, i2: Integer;

      Begin
        P  := PWideChar(Data);
        i2 := Length(Data);
        i  := 0;
        While i < i2 do
          Case P[i] of
            #10: Begin
              _Col := 0;
              Inc(_Lines);
              Inc(i);
            End;
            #13: Begin
              _Col := 0;
              Inc(_Lines);
              Inc(i);
              If (i < i2) and (P[i] = #10) Then Inc(i);
            End;
            Else Begin
              Inc(_Col);
              Inc(i);
            End;
          End;
        If _Buffer.Length + Length(Data) > FileBufferSize + FileBufferSize_Overflow Then
          Flush;
        i := Length(Data);
        While {_Buffer.Length +} i > FileBufferSize + FileBufferSize_Overflow do Begin
          WriteDataX(P, FileBufferSize);
          Inc(P, FileBufferSize);
          Dec(i, FileBufferSize);
        End;
        If i > 0 Then Begin
          i2 := _Buffer.Length;
          _Buffer.Length := i2 + i;
          CopyMemory(PWideChar(@_Buffer.Data) + i2, P, i * 2);
        End;
      End;

    Constructor TXWriter.Create(Stream: TStream; Options: TXMLOptions;
        Const LineFeed, TextIndent, ValueSeperator, ValueQuotation: TWideString);
      Begin
        Inherited Create;
        _Stream         := Stream;
        _StreamStart    := Stream.Position;
      //_Buffer.Length  := 0;
      //_Lines          := 0;
      //_Col            := 0;
        _Options        := Options;
        _LineFeed       := LineFeed;
        _TextIndent     := TextIndent;
        _ValueSeperator := ValueSeperator;
        _ValueQuotation := ValueQuotation;
        _Version        := xvXML10;
        _Encoding       := xeUTF8;
      //_IndentLevel    := 0;
      //_SavedLineBreak := False;
      End;

    Procedure TXWriter.WriteBOM(AllowUTF8BOM: Boolean = False);
      Begin
        If (XMLEncodingData[_Encoding].BOM > '') and (xoDontWriteBOM in _Options)
            and ((_Encoding <> xeUTF8) or AllowUTF8BOM) Then Begin
          Flush;
          _Stream.WriteBuffer(XMLEncodingData[_Encoding].BOM[1],
            Length(XMLEncodingData[_Encoding].BOM));
        End;
      End;

    Procedure TXWriter.SetVer(Version: TXMLVersion);
      Begin
        If Version > High(TXMLVersion) Then
          Raise EXMLException.Create(ClassType, 'SetVer', @SUnknownXmlVersion);
        _Version := Version;
      End;

    Procedure TXWriter.SetEnc(Encoding: TXMLEncoding);
      Begin
        If (Encoding > High(TXMLEncoding))
            or (XMLEncodingData[_Encoding].CharSize > XMLEncodingData[Encoding].CharSize) Then
          Raise EXMLException.Create(ClassType, 'SetEnc', @SUnknownEncoding);
        If _Encoding <> Encoding Then Begin
          Flush;
          _Encoding := Encoding;
        End;
      End;

    Procedure TXWriter.OpenNode(DataType: TXDataType; Const NodeName: TWideString);
      Var i: Integer;

      Begin
        Try
          Case DataType of
            xdInstruction, xdTypedef, xdElement: Begin
              If (xoNodeAutoIndent in _Options) and _SavedLineBreak Then Begin
                WriteData(_LineFeed);
                For i := _IndentLevel - 1 downto 0 do WriteData(_TextIndent);
              End;
              Case DataType of
                xdInstruction: WriteData('<?');
                xdTypedef:     WriteData('<!');
                xdElement:     WriteData('<');
              End;
              WriteData(NodeName);
              Inc(_IndentLevel);
              _SavedLineBreak := False;
            End;
            xdCData: Begin
              If (xoNodeAutoIndent in _Options) and _SavedLineBreak
                  and not (xoCDataNotAutoIndent in _Options) Then Begin
                WriteData(_LineFeed);
                For i := _IndentLevel - 1 downto 0 do WriteData(_TextIndent);
              End;
              WriteData('<![CDATA[');
              Inc(_IndentLevel);
              _SavedLineBreak := False;
            End;
            xdComment: Begin
              If (xoNodeAutoIndent in _Options) and _SavedLineBreak Then Begin
                WriteData(_LineFeed);
                For i := _IndentLevel - 1 downto 0 do WriteData(_TextIndent);
              End;
              WriteData('<!--');
              Inc(_IndentLevel);
              _SavedLineBreak := False;
            End;
            Else Raise EXMLException.Create(ClassType, 'OpenNode', @SInternalError, 1);
          End;
        Except
          Raise EXMLException.Create(ClassType, 'OpenNode', @SErrorPos,
            [_Lines / 1, _Col / 1, '', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Procedure TXWriter.WriteAttr(Const AttrName: TWideString; Value: TWideString; NewLine: Boolean = False);
      Var i: Integer;

      Begin
        Try
          If (xoNodeAutoIndent in _Options) and NewLine Then Begin
            WriteData(_LineFeed);
            For i := _IndentLevel - 1 downto 0 do WriteData(_TextIndent);
          End Else WriteData(' ');
          TXHelper.ConvertString(Value, xtAttribute_SaveValue, _Options, _LineFeed, _TextIndent, _ValueQuotation);
          WriteData(AttrName);
          WriteData(_ValueSeperator);
          WriteData(Value);
          _SavedLineBreak := True;
        Except
          Raise EXMLException.Create(ClassType, 'WriteAttr', @SErrorPos,
            [_Lines / 1, _Col / 1, '', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Procedure TXWriter.WriteText(DataType: TXDataType; Text: TWideString);
      Begin
        Try
          Case DataType of
            xdTypedef: Begin
              TXHelper.ConvertString(Text, xtTypedef_SaveText, _Options, _LineFeed, _TextIndent, {not used} '');
              If (Text = '') and ((Text[1] = ' ') or (Text[1] = #13) or (Text[1] = #10)) Then
                WriteData(' ');
              WriteData(Text);
              _SavedLineBreak := False;
            End;
            xdElement, xdText: Begin
              TXHelper.ConvertString(Text, xtElement_SaveText, _Options, _LineFeed, _TextIndent, {not used} '');
              WriteData(Text);
              _SavedLineBreak := False;
            End;
            xdCData: Begin
              TXHelper.ConvertString(Text, xtCData_SaveText, _Options, _LineFeed, _TextIndent, {not used} '');
              WriteData(Text);
              _SavedLineBreak := False;
            End;
            xdComment:Begin
              TXHelper.ConvertString(Text, xtComment_SaveText, _Options, _LineFeed, _TextIndent, {not used} '');
              If Text = '' Then Text := ' ';
              WriteData(Text);
              _SavedLineBreak := False;
            End;
            //xdText > xdElement
            Else Raise EXMLException.Create(ClassType, 'WriteText', @SInternalError, 1);
          End;
        Except
          Raise EXMLException.Create(ClassType, 'WriteText', @SErrorPos,
            [_Lines / 1, _Col / 1, '', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Procedure TXWriter.CloseNode(DataType: TXDataType);
      Begin
        Try
          Case DataType of
            xdInstruction: Begin
              Dec(_IndentLevel);
              If _SavedLineBreak Then WriteData(' ');
              WriteData('?>');
              _SavedLineBreak := True;
            End;
            xdTypedef, xdElement: Begin
              WriteData('>');
              _SavedLineBreak := True;
            End;
            xdCData: Begin
              Dec(_IndentLevel);
              WriteData(']]>');
              _SavedLineBreak := not (xoCDataNotAutoIndent in _Options);
            End;
            xdComment:Begin
              Dec(_IndentLevel);
              WriteData('-->');
              _SavedLineBreak := True;
            End;
            Else Raise EXMLException.Create(ClassType, 'CloseNode', @SInternalError, 1);
          End;
        Except
          Raise EXMLException.Create(ClassType, 'CloseNode', @SErrorPos,
            [_Lines / 1, _Col / 1, '', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Procedure TXWriter.CloseNode(DataType: TXDataType; asSmallEmptyTag: Boolean; NoLF: Boolean = False);
      Begin
        Try
          If DataType = xdElement Then Begin
            If asSmallEmptyTag Then Begin
              Dec(_IndentLevel);
              WriteData('/>');
            End Else WriteData('>');
            _SavedLineBreak := not NoLF;
          End Else CloseNode(DataType);
        Except
          Raise EXMLException.Create(ClassType, 'CloseNode', @SErrorPos,
            [_Lines / 1, _Col / 1, '', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Procedure TXWriter.CloseNode(Const NodeName: TWideString);
      Var i: Integer;

      Begin
        Try
          Dec(_IndentLevel);
          If (xoNodeAutoIndent in _Options) and _SavedLineBreak Then Begin
            WriteData(_LineFeed);
            For i := _IndentLevel - 1 downto 0 do WriteData(_TextIndent);
          End;
          WriteData('</');
          WriteData(NodeName);
          WriteData('>');
          _SavedLineBreak := True;
        Except
          Raise EXMLException.Create(ClassType, 'CloseNode', @SErrorPos,
            [_Lines / 1, _Col / 1, '', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Procedure TXWriter.CloseNotMarkedSingleNode;
      Begin
        Try
          Dec(_IndentLevel);
          WriteData('>');
        Except
          Raise EXMLException.Create(ClassType, 'CloseNode', @SErrorPos,
            [_Lines / 1, _Col / 1, '', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Procedure TXWriter.WriteLF;
      Begin
        Try
          If (xoNodeAutoIndent in _Options) and _SavedLineBreak Then WriteData(_LineFeed);
          _SavedLineBreak := True;
        Except
          Raise EXMLException.Create(ClassType, 'WriteLF', @SErrorPos,
            [_Lines / 1, _Col / 1, '', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Function TXWriter.Size: Int64;
      {inline}

      Begin
        Result := _Stream.Size - _StreamStart + _Buffer.Length;
      End;

    Procedure TXWriter.Flush;
      Begin
        Try
          WriteDataX(@_Buffer.Data, _Buffer.Length);
          _Buffer.Length := 0;
        Except
          Raise EXMLException.Create(ClassType, 'Flush', @SErrorPos,
            [_Lines / 1, _Col / 1, '', _Stream.Position / 1], Exception(ExceptObject));
        End;
      End;

    Destructor TXWriter.Destroy;
      Begin
        Flush;
        Inherited;
      End;

  {$IF X}{$ENDREGION}{$IFEND}
  {$IF X}{$REGION 'initialization'}{$IFEND}

Initialization
  TXHelper.Initialize;
  TXMLFile.Initialize;

Finalization
  TXHelper.Finalize;
  {$IF X}{$ENDREGION}{$IFEND}

End.

    Class Procedure TXHelper.DeSerialize_Object(Node: TXMLNode; C: TObject; SOptions: TXMLSerializeOptions; Proc: TXMLSerializeProc);

xoChangeInvalidChars
xoAllowUnknownText
xoWrapLongLines
xoNormalizeText

