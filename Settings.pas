unit Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmSettings = class(TForm)
    lblDefaultWidth: TLabel;
    lblDefaultHeight: TLabel;
    editBlockHeight: TEdit;
    lblCanvasWidth: TLabel;
    lblCanvasHeight: TLabel;
    editCanvasWidth: TEdit;
    editCanvasHeight: TEdit;
    btnAcceptSettings: TButton;
    btnCancelSettings: TButton;
    editBlockWidth: TEdit;
    procedure btnAcceptSettingsClick(Sender: TObject);
    procedure btnCancelSettingsClick(Sender: TObject);
  private
    { Private declarations }
  public
    defaultWidth: Integer;
    defaultHeight: Integer;
    isAccepted: boolean;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

procedure TfrmSettings.btnAcceptSettingsClick(Sender: TObject);
begin
  isAccepted := true;
  frmSettings.Close();
end;

procedure TfrmSettings.btnCancelSettingsClick(Sender: TObject);
begin
  frmSettings.Close();
end;

end.
