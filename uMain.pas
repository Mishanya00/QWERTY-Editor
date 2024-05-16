﻿unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.ToolWin, Vcl.ComCtrls, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls,

  // custom imports
  DrawSymbols, DataStructures, SourceListing, Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage;

type
  TfrmMain = class(TForm)
    alMain: TActionList;
    ilMain: TImageList;
    actOpen: TAction;
    actSave: TAction;
    actCreate: TAction;
    actSaveAs: TAction;
    actExport: TAction;
    actCut: TAction;
    tbMain: TToolBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    PNG1: TMenuItem;
    N8: TMenuItem;
    actCopy: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    panelSymbols: TPanel;
    actPaste: TAction;
    StatusBar1: TStatusBar;
    N9: TMenuItem;
    N10: TMenuItem;
    odMain: TOpenDialog;
    ilFlowchartSymbols: TImageList;
    actDragSymbol: TAction;
    pnlTerminator: TPanel;
    pnlProcess: TPanel;
    imgTerminator: TImage;
    pnlMain: TPanel;
    pbWorkingArea: TImage;
    Image1: TImage;
    Panel1: TPanel;
    Image2: TImage;
    Panel2: TPanel;
    Image3: TImage;
    Panel3: TPanel;
    Image4: TImage;
    Panel4: TPanel;
    Image5: TImage;
    Panel5: TPanel;
    Image6: TImage;
    Panel6: TPanel;
    Image7: TImage;
    procedure pbWorkingAreaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbWorkingAreaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbWorkingAreaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure actionsExecuter(Sender: TObject);
    procedure panelSymbolsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure imgTerminatorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbWorkingAreaDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure pbWorkingAreaDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);

  private
    paintMode: boolean;
    FFileName: string;

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

procedure InitTags(); forward;

const
  CREATE_TAG    = 1;
  OPEN_TAG      = 2;
  SAVE_TAG      = 3;
  SAVE_AS_TAG   = 4;
  EXPORT_TAG    = 5;
  CUT_TAG       = 6;
  COPY_TAG      = 7;
  PASTE_TAG     = 8;

{$R *.dfm}

procedure InitTags();
begin

end;

procedure TfrmMain.actionsExecuter(Sender: TObject);
begin

  if Sender is TAction then
  begin

    case TAction(Sender).Tag of

      CREATE_TAG:
        ShowMessage('Create routine');
      OPEN_TAG:
      begin
         if not(odMain.Execute()) then Exit;
         FFileName := odMain.Files[0];
         frmDelphiListing.Show();
         frmDelphiListing.memoListing.Lines.LoadFromFile(FFileName);
         frmDelphiListing.Caption := 'Listing - ' + FFileName;
      end;
      SAVE_TAG:
         ShowMessage('Save routine');
      SAVE_AS_TAG:
         ShowMessage('Save as routine');
      EXPORT_TAG:
         ShowMessage('Export routine');

      CUT_TAG:
        ShowMessage('CUT routine');
      COPY_TAG:
        ShowMessage('COPY routine');
      PASTE_TAG:
         ShowMessage('PASTE routine');
    end;

  end;


end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  pbWorkingArea.Canvas.Pen.Color := clBlue;
  pbWorkingArea.Canvas.Pen.Mode := pmCopy;
  pbWorkingArea.Canvas.Brush.Style := bsSolid;
  pbWorkingArea.Canvas.Brush.Color := clBlue;

  SetCanvaAttributes(pbWorkingArea.Canvas, clBlack, clWhite, bsSolid);

  // Assignment of actions' tags
  actCreate.Tag   := 1;
  actOpen.Tag     := 2;
  actSave.Tag     := 3;
  actSaveAs.Tag   := 4;
  actExport.Tag   := 5;
  actCut.Tag      := 6;
  actCopy.Tag     := 7;
  actPaste.Tag    := 8;
end;

procedure TfrmMain.imgTerminatorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TImage).BeginDrag(True);
end;

procedure TfrmMain.panelSymbolsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source.ClassName = 'TImage' then
    Accept := True
  else
    Accept := False;
end;

procedure TfrmMain.pbWorkingAreaDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin

  case (Source as TImage).tag of
    1:
      DrawProcessSymbol(pbWorkingArea.canvas, x, y, x + 50, y + 50);
  end;
end;

procedure TfrmMain.pbWorkingAreaDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  exit;
end;

procedure TfrmMain.pbWorkingAreaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  paintMode := true;
end;

procedure TfrmMain.pbWorkingAreaMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if paintMode then
  begin
    //pbWorkingArea.Canvas.MoveTo(x-1, y-1);
    //pbWorkingArea.Canvas.LineTo(x, y);
    pbWorkingArea.Canvas.Rectangle(X, Y, X+10, Y+10);
  end;
end;

procedure TfrmMain.pbWorkingAreaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  paintMode := false;
end;

end.
