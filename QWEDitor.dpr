program QWEDitor;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  DataStructures in 'DataStructures.pas',
  DrawSymbols in 'DrawSymbols.pas',
  FilesHandling in 'FilesHandling.pas',
  StackRoutine in 'StackRoutine.pas',
  Settings in 'Settings.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
