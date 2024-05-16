﻿program QWEDitor;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  DataStructures in 'DataStructures.pas',
  SourceListing in 'SourceListing.pas' {frmDelphiListing};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDelphiListing, frmDelphiListing);
  Application.Run;
end.
