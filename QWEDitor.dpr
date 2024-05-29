program QWEDitor;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  DataStructures in 'DataStructures.pas',
  SourceListing in 'SourceListing.pas' {frmDelphiListing},
  DrawSymbols in 'DrawSymbols.pas',
  FilesHandling in 'FilesHandling.pas',
  StackRoutine in 'StackRoutine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDelphiListing, frmDelphiListing);
  Application.Run;
end.
