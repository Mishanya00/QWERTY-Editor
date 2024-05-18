﻿unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
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
    actDragSymbol: TAction;
    pnlDecision: TPanel;
    imgDecision: TImage;
    pnlPredefined: TPanel;
    imgPredefined: TImage;
    pnlTeleport: TPanel;
    imgTeleport: TImage;
    pnlData: TPanel;
    imgData: TImage;
    pbWorkingArea: TImage;
    ScrollBox1: TScrollBox;
    Splitter1: TSplitter;
    ilFlowchartSymbols: TImageList;
    pnlTerminator: TPanel;
    imgTerminator: TImage;
    pnlProcess: TPanel;
    imgProcess: TImage;
    procedure pbWorkingAreaMouseDown(Sender: TObject; Button: TMouseButton;
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
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

  private
    paintMode: Boolean;
    FFileName: string;

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

var
  blocks: PBlock;
  labels: PText;
  lines: PLine;

  fDragging: Boolean;
  fSelection: Boolean; // Process of selecting items inside the area
  FMayDrag:  Boolean;

procedure InitTags(); forward;

const
  CREATE_TAG = 1;
  OPEN_TAG = 2;
  SAVE_TAG = 3;
  SAVE_AS_TAG = 4;
  EXPORT_TAG = 5;
  CUT_TAG = 6;
  COPY_TAG = 7;
  PASTE_TAG = 8;

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
          if not(odMain.Execute()) then
            Exit;
          FFileName := odMain.Files[0];
          frmDelphiListing.Show();
          frmDelphiListing.memoListing.lines.LoadFromFile(FFileName);
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

  StartupInit(blocks, lines, labels);
  pbWorkingArea.Canvas.Pen.Color := clBlue;
  pbWorkingArea.Canvas.Pen.Mode := pmCopy;
  pbWorkingArea.Canvas.Brush.Style := bsSolid;
  pbWorkingArea.Canvas.Brush.Color := clBlue;

  SetCanvaAttributes(pbWorkingArea.Canvas, 3, clBlack, clWhite, bsSolid);

  // Assignment of actions' tags
  actCreate.Tag := 1;
  actOpen.Tag := 2;
  actSave.Tag := 3;
  actSaveAs.Tag := 4;
  actExport.Tag := 5;
  actCut.Tag := 6;
  actCopy.Tag := 7;
  actPaste.Tag := 8;

  // Assignment of image-symbols tags
  imgTerminator.Tag := 1;
  imgProcess.Tag := 2;
  imgDecision.Tag := 3;
  imgData.Tag := 4;
  imgPredefined.Tag := 5;
  imgTeleport.Tag := 6;
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

procedure TfrmMain.pbWorkingAreaDragDrop(Sender, Source: TObject;
  X, Y: Integer);

var
  point: TPoint;
  tempBlock: TBlockInfo;

begin
  point := (Sender as TControl).ScreenToClient(Mouse.CursorPos);

  // Numbers equal the value of the corresponding tag
  case (Source as TImage).Tag of
    2:
      begin
        tempBlock.bounds := Rect(point.X - defaultWidth,
          point.Y - defaultHeight, point.X + defaultWidth,
          point.Y + defaultHeight);
        tempBlock.blockType := Process;
        AddBlock(blocks, tempBlock);
      end;
    6:
      begin
        tempBlock.bounds := Rect(point.X - defaultHeight,
          point.Y - defaultHeight, point.X + defaultHeight,
          point.Y + defaultHeight);
        tempBlock.blockType := Teleport;
        AddBlock(blocks, tempBlock);
      end;
  end;

  DrawAll(pbWorkingArea.Canvas, blocks);
end;

procedure TfrmMain.pbWorkingAreaDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Exit;
end;

procedure TfrmMain.pbWorkingAreaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft:
      begin
        if GetIdByCoord(blocks, lines, labels, Point(x, y)) <> -1 then
          
      end;
  end;
end;

procedure TfrmMain.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  Exit;
end;

end.
