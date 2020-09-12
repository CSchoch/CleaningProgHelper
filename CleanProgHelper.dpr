program CleanProgHelper;

uses
  FastMM4,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  fMain in 'fMain.pas' {MainForm},
  csCSV in 'csCSV.pas',
  ucleanprog.parser in 'ucleanprog.parser.pas',
  VTreeHelper in 'VTreeHelper.pas',
  VPropertyTreeEditors in 'VPropertyTreeEditors.pas',
  uVisio in 'uVisio.pas',
  fSelectTarget in 'fSelectTarget.pas' {SelectTarget},
  fEditMessages in 'fEditMessages.pas' {EditMessages},
  fSelectLangIndex in 'fSelectLangIndex.pas' {SelectLangIndex},
  fAbout in 'fAbout.pas' {AboutBox},
  uParser in 'uParser.pas',
  uCleanProg.Settings in 'uCleanProg.Settings.pas',
  uCleanProg in 'uCleanProg.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
