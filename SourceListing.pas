unit SourceListing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmDelphiListing = class(TForm)
    memoListing: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDelphiListing: TfrmDelphiListing;

implementation

{$R *.dfm}

end.
