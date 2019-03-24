Unit himXML_Lang;

Interface

  (************************************************** )
  (                                                   )
  (  Copyright (c) 1997-2009 FNS Enterprize's™        )
  (                2003-2009 himitsu @ Delphi-PRAXiS  )
  (                                                   )
  (  Description   language strings for himXML        )
  (  Filename      himXML_Lang.pas                    )
  (  Version       v0.99a                             )
  (  Date          25.11.2009                         )
  (  Project       himXML [himix ML]                  )
  (  Info / Help   see "help" region in himXML.pas    )
  (  Support       delphipraxis.net/topic153934.html  )
  (                                                   )
  (  License       -                                  )
  (                                                   )
  (  Donation      www.FNSE.de/Spenden                )
  (                                                   )
  (***************************************************)

  {$DEFINE CMarker_himXMLLang_Init}
  {$INCLUDE himXMLCheck.inc}

  ResourceString
    // read
    SReadError         = 'read error';
    SCorruptedUtf8     = 'corrupted utf-8 (%s)';
    SInvalidEncoding   = 'invalid file encoding';
    SInvalidChar       = 'invalid char (%s)';
    SInvalidData       = 'invalid data ("%s")';
    SCharNotFound      = '"%s" does not found';
    SUnknownClosingTag = 'unknown closing tag - node "%s" is the last opened, but closing "%s" is found';
    SInvalidClosingTag = 'invalid closing tag - node "%s" is not opened';
    SErrorPos          = 'error on line %.0n and col %.0n (%sat byte position %.0n)';
    SEndOfData         = 'unexcepting end of data - not all opened tags are closed';
    SCorruptedVarArray = 'corrupted definition of an variant array ("%s")';

    // write
    SUnknownXmlVersion = 'unknown xml version';
    SUnknownEncoding   = 'unknown encoding';
    SEncodingChange    = 'uninvalid unknown encoding';

    // other
    SCorupptedDateTime = 'invalid date/time-string ("%s")';
    SCorupptedBase64   = 'corrupted base64 ("%s")';
    SUnknownVariant    = 'unknown or corrupted variant';
    SUnsuppPropType    = 'unsupported PropType (%s)';

    // global
    SSimpleError       = 'error';
    SOwnerRequired     = 'owner required';
    SInvalidParent     = 'invalid parent';
    SInvalidParent2    = 'invalid parent/owner';
    SInvalidNode       = 'invalid node';
    SMissingNode       = 'node does not exists';
    SMissingPath       = 'node path does not exists';
    SIndexNotAllowed   = 'node index doesn''t allowed ("%s[%d]")';
    SCorruptedIndex    = 'corrupted node index ("%s")';
    SInvalidIndex      = 'invalid node index ("%s")';
    SOutOfRange        = 'index out of range (0 <= "%d" < %d)';
    SNodeNotInList     = 'node ist not in list';
    SInvalidName       = 'invalid name ("%s")';
    SInvalidNameN      = 'invalid name';
    SInvalidValue      = 'invalid value ("%s")';
    SInvalidValueS     = 'invalid value (%s)';
    SInvalidValueX4    = 'invalid value ($%.8x)';
    SInvalidValueN     = 'invalid value';
    SInvalidState      = 'invalid state';
    SDuplicateAttr     = 'duplicate attribute ("%s")';
    SNoAttributes      = 'node type dont support attributes';
    SNoSubnodes        = 'node type dont support subnodes';
    SNoNodeText        = 'text can''t set (node "%s" constain subnotes)';
    SIsTextNode        = 'text node can''t constain subnodes ("%s")';
    SSmallBuffer       = 'buffer too small';

    // internal
    SNotImplemented    = '%s is not implemented';  // Raise EXMLException.Create(ClassType, 'Function', @SNotImplemented, '{Name}');
    SInternalError     = 'internal error (%d)';

    // streams (hxExcludeClassesUnit)
    SSCreateError      = 'file "%s" can''t created';
    SSOpenError        = 'file "%s" can''t open';
    SSReadError        = 'stream read error';
    SSWriteError       = 'stream write error';

Implementation

End.

