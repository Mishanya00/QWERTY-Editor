unit SourceListing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmDelphiListing = class(TForm)
    memoListing: TMemo;
    panelListingActions: TPanel;
    btnGenerateFlowchart: TButton;
    procedure btnGenerateFlowchartClick(Sender: TObject);
  private

    codeText: string;

  public
    { Public declarations }
  end;

var
  frmDelphiListing: TfrmDelphiListing;

implementation

{$R *.dfm}

type
  TTokens = array of string;

procedure ParseBySpaces(toParse: string; var result: TTokens); forward;




procedure TfrmDelphiListing.btnGenerateFlowchartClick(Sender: TObject);
var
  line: string;
begin

  codeText := '';

  for line in memoListing.Lines do
  begin
    codeText := codeText + line;
  end;

  ShowMessage('Создание блоксхемы из кода!');
end;

end.
