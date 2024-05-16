﻿unit SourceListing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmDelphiListing = class(TForm)
    memoListing: TMemo;
    panelListingActions: TPanel;
    btnGenerateFlowchart: TButton;
    procedure btnGenerateFlowchartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDelphiListing: TfrmDelphiListing;

implementation

{$R *.dfm}

procedure TfrmDelphiListing.btnGenerateFlowchartClick(Sender: TObject);
begin
  ShowMessage('Создание блоксхемы из кода!');
end;

end.
