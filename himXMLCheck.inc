(************************************************************************************************ )
(***** Delphi Versions ************************************************************************** )
(*************************************************************************************************)

{$IFNDEF CONDITIONALEXPRESSIONS} {$MESSAGE Fatal 'Version is not supperted'} {$ENDIF}
{$IF     CompilerVersion < 12.0} {$MESSAGE Fatal 'Version is not supperted'}
{$ELSEIF CompilerVersion < 13.0} {$DEFINE DELPHI_4}
{$ELSEIF CompilerVersion < 14.0} {$DEFINE DELPHI_5}
{$ELSEIF CompilerVersion < 15.0} {$DEFINE DELPHI_6}
{$ELSEIF CompilerVersion < 16.0} {$DEFINE DELPHI_7}
{$ELSEIF CompilerVersion < 17.0} {$DEFINE DELPHI_2005}
{$ELSEIF CompilerVersion < 18.0} {$DEFINE DELPHI_2006}
{$ELSEIF CompilerVersion < 19.0} {$DEFINE DELPHI_2007}
{$ELSEIF CompilerVersion < 20.0} {$DEFINE DELPHI_2008}
{$ELSEIF CompilerVersion < 21.0} {$DEFINE DELPHI_2009}
{$ELSEIF CompilerVersion < 22.0} {$DEFINE DELPHI_2010}
{$ELSE}                          {$DEFINE DELPHI_HIGH} {$IFEND}

{$IFDEF DELPHI_4}    {$DEFINE DELPHI_4_NEWER}    {$DEFINE DELPHI_4_OLDER}    {$ENDIF}
{$IFDEF DELPHI_5}    {$DEFINE DELPHI_5_NEWER}    {$DEFINE DELPHI_5_OLDER}    {$ENDIF}
{$IFDEF DELPHI_6}    {$DEFINE DELPHI_6_NEWER}    {$DEFINE DELPHI_6_OLDER}    {$ENDIF}
{$IFDEF DELPHI_7}    {$DEFINE DELPHI_7_NEWER}    {$DEFINE DELPHI_7_OLDER}    {$ENDIF}
{$IFDEF DELPHI_2005} {$DEFINE DELPHI_2005_NEWER} {$DEFINE DELPHI_2005_OLDER} {$ENDIF}
{$IFDEF DELPHI_2006} {$DEFINE DELPHI_2006_NEWER} {$DEFINE DELPHI_2006_OLDER} {$ENDIF}
{$IFDEF DELPHI_2007} {$DEFINE DELPHI_2007_NEWER} {$DEFINE DELPHI_2007_OLDER} {$ENDIF}
{$IFDEF DELPHI_2009} {$DEFINE DELPHI_2009_NEWER} {$DEFINE DELPHI_2009_OLDER} {$ENDIF}
{$IFDEF DELPHI_2010} {$DEFINE DELPHI_2010_NEWER} {$DEFINE DELPHI_2010_OLDER} {$ENDIF}
{$IFDEF DELPHI_HIGH} {$DEFINE DELPHI_2010_NEWER}                             {$ENDIF}

{$IFDEF DELPHI_2010_NEWER} {$DEFINE DELPHI_2009_NEWER} {$ENDIF}
{$IFDEF DELPHI_2009_NEWER} {$DEFINE DELPHI_2007_NEWER} {$ENDIF}
{$IFDEF DELPHI_2007_NEWER} {$DEFINE DELPHI_2006_NEWER} {$ENDIF}
{$IFDEF DELPHI_2006_NEWER} {$DEFINE DELPHI_2005_NEWER} {$ENDIF}
{$IFDEF DELPHI_2005_NEWER} {$DEFINE DELPHI_7_NEWER}    {$ENDIF}
{$IFDEF DELPHI_7_NEWER}    {$DEFINE DELPHI_6_NEWER}    {$ENDIF}
{$IFDEF DELPHI_6_NEWER}    {$DEFINE DELPHI_5_NEWER}    {$ENDIF}
{$IFDEF DELPHI_5_NEWER}    {$DEFINE DELPHI_4_NEWER}    {$ENDIF}

{$IFDEF DELPHI_4_OLDER}    {$DEFINE DELPHI_5_OLDER}    {$ENDIF}
{$IFDEF DELPHI_5_OLDER}    {$DEFINE DELPHI_6_OLDER}    {$ENDIF}
{$IFDEF DELPHI_6_OLDER}    {$DEFINE DELPHI_7_OLDER}    {$ENDIF}
{$IFDEF DELPHI_7_OLDER}    {$DEFINE DELPHI_2005_OLDER} {$ENDIF}
{$IFDEF DELPHI_2005_OLDER} {$DEFINE DELPHI_2006_OLDER} {$ENDIF}
{$IFDEF DELPHI_2006_OLDER} {$DEFINE DELPHI_2007_OLDER} {$ENDIF}
{$IFDEF DELPHI_2007_OLDER} {$DEFINE DELPHI_2009_OLDER} {$ENDIF}
{$IFDEF DELPHI_2009_OLDER} {$DEFINE DELPHI_2010_OLDER} {$ENDIF}

{$IF Defined(CMarker_himXML_Init) or Defined(CMarker_himXMLLang_Init)
    or Defined(CMarker_himXMLXPath_Init)
    or Defined(CMarker_himXMLIni_Init) or Defined(CMarker_himXMLReg_Init)
    or Defined(CMarker_himXMLOpt_Init) or Defined(CMarker_himXMLOptOSF_Init)
    or Defined(CMarker_himXMLRPC_Init) or Defined(CMarker_himXMLDB_Init)
    or Defined(CMarker_himXMLDLL_Init) or Defined(CMarker_himXMLUseDLL_Init)}
  {$IFDEF DELPHI_4}    Const DELPHI = 4;    {$ENDIF}
  {$IFDEF DELPHI_5}    Const DELPHI = 5;    {$ENDIF}
  {$IFDEF DELPHI_6}    Const DELPHI = 6;    {$ENDIF}
  {$IFDEF DELPHI_7}    Const DELPHI = 7;    {$ENDIF}
  {$IFDEF DELPHI_2005} Const DELPHI = 2005; {$ENDIF}
  {$IFDEF DELPHI_2006} Const DELPHI = 2006; {$ENDIF}
  {$IFDEF DELPHI_2007} Const DELPHI = 2007; {$ENDIF}
  {$IFDEF DELPHI_2009} Const DELPHI = 2009; {$ENDIF}
  {$IFDEF DELPHI_2010} Const DELPHI = 2010; {$ENDIF}
  {$IFDEF DELPHI_HIGH} Const DELPHI = 9999; {$ENDIF}
{$IFEND}

(************************************************************************************************ )
(***** Global Compiler Settings ***************************************************************** )
(*************************************************************************************************)

{$IF Defined(CMarker_himXML_Init) or Defined(CMarker_himXMLLang_Init)
    or Defined(CMarker_himXMLXPath_Init)
    or Defined(CMarker_himXMLIni_Init) or Defined(CMarker_himXMLReg_Init)
    or Defined(CMarker_himXMLOpt_Init) or Defined(CMarker_himXMLOptOSF_Init)
    or Defined(CMarker_himXMLRPC_Init) or Defined(CMarker_himXMLDB_Init)
    or Defined(CMarker_himXMLDLL_Init) or Defined(CMarker_himXMLUseDLL_Init)}
  {$ALIGN            4}
  {$BOOLEVAL       OFF}
  {.EXTENDEDSYNTAX  ON}  // global
  {.FINITEFLOAT     ON}  // global
  {.IMPORTEDDATA   OFF}
  {$LONGSTRINGS     ON}
  {$METHODINFO     OFF}
  {$MINENUMSIZE      1}
  {$OPENSTRINGS     ON}
  {$OPTIMIZATION    ON}
  {$OVERFLOWCHECKS OFF}
  {$RANGECHECKS    OFF}
  {$STACKFRAMES    OFF}
  {$TYPEDADDRESS   OFF}
  {$TYPEINFO       OFF}
  {$WRITEABLECONST OFF}
  {$IFDEF DELPHI_2009}
    {$POINTERMATH    OFF}
    {$STRINGCHECKS   OFF}
  {$ENDIF}
  {$IFDEF hxDebugable}
    {$DEBUGINFO      ON}
    {$DEFINITIONINFO ON}
    {$LOCALSYMBOLS   ON}
  {$ELSE}
    {$DEBUGINFO      OFF}
    {$DEFINITIONINFO OFF}
    {$LOCALSYMBOLS   OFF}
  {$ENDIF}

  {$ASSERTIONS OFF}
  {$WARN COMPARISON_FALSE OFF}
{$IFEND}
{$IF not Declared(UnicodeString)}
  {$DEFINE hxDisableUnicodeString}
{$IFEND}
{$IFDEF DELPHI_2005_OLDER}
  {$DEFINE hxExcludeTIndex}
  {$DEFINE hxDontUseInline}
{$ENDIF}

(************************************************************************************************ )
(***** Save Compiler Settings - Create Marker *************************************************** )
(*************************************************************************************************)

{$IFDEF hxExcludeSysutilsUnit}
  {$IFNDEF hxExcludeClassesUnit}
    {$DEFINE hxExcludeClassesUnit}
    {$MESSAGE Hint 'project himXML: hxExcludeClassesUnit has been enabled by the compiler switch hxExcludeSysutilsUnit'}
  {$ENDIF}
  {$IFNDEF hxExcludeContnrsUnit}
    {$DEFINE hxExcludeContnrsUnit}
    {$MESSAGE Hint 'project himXML: hxExcludeContnrsUnit has been enabled by the compiler switch hxExcludeSysutilsUnit'}
  {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXML_Init}
  Const CMarker_himXML = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXML_hxDisableUnicodeString       = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXML_hxExcludeClassesUnit         = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXML_hxExcludeTIndex              = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXML_hxDebugable                  = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXML_hxDontUseInline              = 1; {$ENDIF}

  {$IF Defined(hxDisableUnicodeString) and Declared(UnicodeString)}
                                {$MESSAGE Hint 'project himXML: TWideString is defined as threadsave WideString (UnicodeString avaible)'} {$IFEND}
  {$IFDEF hxExcludeClassesUnit} {$MESSAGE Hint 'project himXML ist compiled without unit Classes'}              {$ENDIF}
  {$IFDEF hxExcludeTIndex}      {$MESSAGE Hint 'project himXML: Variant is uses used instead of TIndex'}        {$ENDIF}
  {$IFDEF hxDebugable}          {$MESSAGE Hint 'units of project himXML are compile with debug informations'}   {$ENDIF}
  {$IFDEF hxDontUseInline}      {$MESSAGE Hint 'units of project himXML are compile without inline procedures'} {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLLang_Init}
  Const CMarker_himXMLLang = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXMLLang_hxDisableUnicodeString   = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXMLLang_hxExcludeClassesUnit     = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXMLLang_hxExcludeTIndex          = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXMLLang_hxDebugable              = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXMLLang_hxDontUseInline          = 1; {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLXPath_Init}
  Const CMarker_himXMLXPath = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXMLXPath_hxDisableUnicodeString  = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXMLXPath_hxExcludeClassesUnit    = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXMLXPath_hxExcludeTIndex         = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXMLXPath_hxDebugable             = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXMLXPath_hxDontUseInline         = 1; {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLIni_Init}
  Const CMarker_himXMLIni = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXMLIni_hxDisableUnicodeString    = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXMLIni_hxExcludeClassesUnit      = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXMLIni_hxExcludeTIndex           = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXMLIni_hxDebugable               = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXMLIni_hxDontUseInline           = 1; {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLReg_Init}
  Const CMarker_himXMLReg = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXMLReg_hxDisableUnicodeString    = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXMLReg_hxExcludeClassesUnit      = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXMLReg_hxExcludeTIndex           = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXMLReg_hxDebugable               = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXMLReg_hxDontUseInline           = 1; {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLOpt_Init}
  Const CMarker_himXMLOpt = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXMLOpt_hxDisableUnicodeString    = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXMLOpt_hxExcludeClassesUnit      = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXMLOpt_hxExcludeTIndex           = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXMLOpt_hxDebugable               = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXMLOpt_hxDontUseInline           = 1; {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLOptOSF_Init}
  Const CMarker_himXMLOptOSF = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXMLOptOSF_hxDisableUnicodeString = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXMLOptOSF_hxExcludeClassesUnit   = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXMLOptOSF_hxExcludeTIndex        = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXMLOptOSF_hxDebugable            = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXMLOptOSF_hxDontUseInline        = 1; {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLRPC_Init}
  Const CMarker_himXMLRPC = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXMLRPC_hxDisableUnicodeString    = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXMLRPC_hxExcludeClassesUnit      = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXMLRPC_hxExcludeTIndex           = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXMLRPC_hxDebugable               = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXMLRPC_hxDontUseInline           = 1; {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLDB_Init}
  Const CMarker_himXMLDB = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXMLDB_hxDisableUnicodeString     = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXMLDB_hxExcludeClassesUnit       = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXMLDB_hxExcludeTIndex            = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXMLDB_hxDebugable                = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXMLDB_hxDontUseInline            = 1; {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLDLL_Init}
  // NOT A UNIT
  {$IFDEF hxExcludeClassesUnit} {$MESSAGE Error 'the compiler directive hxExcludeClassesUnit does not allowed (see at help region in himXML.pas)'} {$ENDIF}
{$ENDIF}

{$IFDEF CMarker_himXMLUseDLL_Init}
  Const CMarker_himXMLUseDLL = 1;
  {$IFDEF hxDisableUnicodeString} CMarker_himXMLUseDLL_hxDisableUnicodeString = 1; {$ENDIF}
  {$IFDEF hxExcludeClassesUnit}   CMarker_himXMLUseDLL_hxExcludeClassesUnit   = 1; {$ENDIF}
  {$IFDEF hxExcludeTIndex}        CMarker_himXMLUseDLL_hxExcludeTIndex        = 1; {$ENDIF}
  {$IFDEF hxDebugable}            CMarker_himXMLUseDLL_hxDebugable            = 1; {$ENDIF}
  {$IFDEF hxDontUseInline}        CMarker_himXMLUseDLL_hxDontUseInline        = 1; {$ENDIF}

  {$IFDEF hxExcludeClassesUnit} {$MESSAGE Error 'the compiler directive hxExcludeClassesUnit does not allowed (see at help region in himXML.pas)'} {$ENDIF}
{$ENDIF}

(************************************************************************************************ )
(***** Check Compiler Settings ****************************************************************** )
(*************************************************************************************************)

{$IF Declared(CMarker_himXML)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXML_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXML_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXML_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXML_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXML_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

{$IF Declared(CMarker_himXMLLang)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXMLLang_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXMLLang_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXMLLang_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXMLLang_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXMLLang_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML_Lang.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

{$IF Declared(CMarker_himXMLXPath)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXMLXPath_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXMLXPath_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXMLXPath_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXMLXPath_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXMLXPath_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML_XPath.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

{$IF Declared(CMarker_himXMLIni)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXMLIni_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXMLIni_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXMLIni_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXMLIni_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXMLIni_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML_Ini.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

{$IF Declared(CMarker_himXMLReg)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXMLReg_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXMLReg_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXMLReg_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXMLReg_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXMLReg_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML_Reg.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

{$IF Declared(CMarker_himXMLOpt)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXMLOpt_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXMLOpt_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXMLOpt_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXMLOpt_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXMLOpt_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML_Opt.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

{$IF Declared(CMarker_himXMLOptOSF)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXMLOptOSF_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXMLOptOSF_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXMLOptOSF_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXMLOptOSF_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXMLOptOSF_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML_OptOSF.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

{$IF Declared(CMarker_himXMLRPC)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXMLRPC_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXMLRPC_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXMLRPC_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXMLRPC_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXMLRPC_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML_RPC.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

{$IF Declared(CMarker_himXMLDB)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXMLDB_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXMLDB_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXMLDB_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXMLDB_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXMLDB_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML_DB.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

{$IF Declared(CMarker_himXMLUseDLL)
    and ((Defined(hxDisableUnicodeString) <> Declared(CMarker_himXMLUseDLL_hxDisableUnicodeString))
    or   (Defined(hxExcludeClassesUnit)   <> Declared(CMarker_himXMLUseDLL_hxExcludeClassesUnit))
    or   (Defined(hxExcludeTIndex)        <> Declared(CMarker_himXMLUseDLL_hxExcludeTIndex))
    or   (Defined(hxDebugable)            <> Declared(CMarker_himXMLUseDLL_hxDebugable))
    or   (Defined(hxDontUseInline)        <> Declared(CMarker_himXMLUseDLL_hxDontUseInline)))}
  {$MESSAGE Error 'unit himXML_UseDLL.dcu are compiled with differend options - please recompile this unit (Shift+F9)'} {$IFEND}

