unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.ToolWin, Vcl.ComCtrls, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls,

  // custom imports
  DrawSymbols, DataStructures, SourceListing, FilesHandling, Vcl.Imaging.jpeg,
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
    sbMain: TScrollBox;
    Splitter1: TSplitter;
    ilFlowchartSymbols: TImageList;
    pnlTerminator: TPanel;
    imgTerminator: TImage;
    pnlProcess: TPanel;
    imgProcess: TImage;
    pbWorkingArea: TPaintBox;
    sdMain: TSaveDialog;
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
    procedure pbWorkingAreaPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pbWorkingAreaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbWorkingAreaMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure sbMainMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sbMainMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);

  private
    paintMode: Boolean;
    FFileName: string;

    blocks: PBlock;
    labels: PText;
    lines: PLine;

    defaultWidth: Integer;
    defaultHeight: Integer;

    // workingAreaWidth: Integer = 3000;
    // workingAreaHeight: Integer = 3000;

    startDraggingPoint: TPoint;
    finishDraggingPoint: TPoint;
    draggingTicks: Integer; // Probably remove due to irrelevance
    draggingStep: Integer;

    fDragging: Boolean;
    fSelection: Boolean; // Process of selecting items inside the area
    fMayDrag: Boolean;
    fCentered: Boolean; // To prevent from centering after centering

    selectedSymbolsCount: Integer;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

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
        begin
          ShowMessage('Save routine');
        end;
      SAVE_AS_TAG:
        begin
          if not(sdMain.Execute()) then
            Exit;
          FFileName := sdMain.Files[0];
          if SameText(ExtractFileExt(FFileName), '.png') then
            SaveBitMapAsPng(FFileName, pbWorkingArea, blocks, labels, lines);
        end;
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

  fCentered := false;

  selectedSymbolsCount := 0;

  pbWorkingArea.Width := 3000;
  pbWorkingArea.Height := 3000;

  defaultWidth := 50;
  defaultHeight := 25;
  draggingStep := 30;

  InitDrawingProperties();
  UpdateCanvaAttributes(pbWorkingArea.Canvas);

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

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE:
      RemoveSelectedSymbols(pbWorkingArea.Canvas, blocks, labels, lines);
  end;

  pbWorkingArea.Invalidate;
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
    1:
      begin
        tempBlock.bounds := Rect(point.X - defaultWidth,
          point.Y - defaultHeight, point.X + defaultWidth,
          point.Y + defaultHeight);
        tempBlock.blockType := Terminator;
        AddBlock(blocks, tempBlock);
      end;
    2:
      begin
        tempBlock.bounds := Rect(point.X - defaultWidth,
          point.Y - defaultHeight, point.X + defaultWidth,
          point.Y + defaultHeight);
        tempBlock.blockType := Process;
        AddBlock(blocks, tempBlock);
      end;
    3:
      begin
        tempBlock.bounds := Rect(point.X - defaultWidth,
          point.Y - defaultHeight, point.X + defaultWidth,
          point.Y + defaultHeight);
        tempBlock.blockType := Decision;
        AddBlock(blocks, tempBlock);
      end;
    4:
      begin
        tempBlock.bounds := Rect(point.X - defaultWidth,
          point.Y - defaultHeight, point.X + defaultWidth,
          point.Y + defaultHeight);
        tempBlock.blockType := Data;
        AddBlock(blocks, tempBlock);
      end;
    5:
      begin
        tempBlock.bounds := Rect(point.X - defaultWidth,
          point.Y - defaultHeight, point.X + defaultWidth,
          point.Y + defaultHeight);
        tempBlock.blockType := Predefined;
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

  pbWorkingArea.Invalidate;
end;

procedure TfrmMain.pbWorkingAreaDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Exit;
end;

procedure TfrmMain.pbWorkingAreaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var
  id: Integer;

begin
  case Button of
    mbLeft:
      begin
        id := GetIdByCoord(blocks, lines, labels, point(X, Y));
        if id <> -1 then
        begin
          // fMayDrag := true;
          fDragging := True;
          draggingTicks := 0;
          startDraggingPoint := (Sender as TControl)
            .ScreenToClient(Mouse.CursorPos);

          if not(ssShift in Shift) then
          begin
            UnselectSymbols(blocks, labels, lines);
            selectedSymbolsCount := 0;
          end;

          SelectSymbol(blocks, lines, labels, id);
          Inc(selectedSymbolsCount);
        end
        else
          UnselectSymbols(blocks, labels, lines);
      end;
  end;

  pbWorkingArea.Invalidate; // To redraw the whole PaintBox
end;

procedure TfrmMain.pbWorkingAreaMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);

var
  centered: TPoint;

begin
  if fDragging = True then
  begin
    // Place to implement centering
    if (abs(X - startDraggingPoint.X) >= draggingStep) or
      (abs(Y - startDraggingPoint.Y) >= draggingStep) then
    begin

      if (selectedSymbolsCount > 1) or (fCentered = true) then
      begin
        fCentered := false;

        OffsetSelectedSymbols(pbWorkingArea.Canvas, blocks, labels, lines,
          X - startDraggingPoint.X, Y - startDraggingPoint.Y);
        startDraggingPoint.X := x;
        startDraggingPoint.Y := y;
      end
      else
      begin
        centered := GetNearestSymbolCoord(X, Y, draggingStep div 2, blocks);
        if centered.X = 9999999 then
        begin
          centered.X := X - startDraggingPoint.X;
          startDraggingPoint.X := X;
        end
        else
        begin
          fCentered := true;
          //centered.X := centered.X +
          startDraggingPoint.X := X + centered.X;
        end;
        if centered.Y = 9999999 then
        begin
          centered.Y := Y - startDraggingPoint.Y;
          startDraggingPoint.Y := Y;
        end
        else
        begin
          fCentered := true;
          startDraggingPoint.Y := Y + centered.Y;
        end;

        OffsetSelectedSymbols(pbWorkingArea.Canvas, blocks, labels, lines,
          centered.X, centered.Y);
      end;

      pbWorkingArea.Invalidate;
    end;
    {
      if (abs(X - startDraggingPoint.X) >= draggingStep) or
      (abs(Y - startDraggingPoint.Y) >= draggingStep) then
      begin
      OffsetSelectedSymbols(pbWorkingArea.Canvas, blocks, labels, lines,
      X - startDraggingPoint.X, Y - startDraggingPoint.Y);

      {
      startDraggingPoint := (Sender as TControl)
      .ScreenToClient(Mouse.CursorPos);
    }{
      startDraggingPoint.X := X;
      startDraggingPoint.Y := y;
      pbWorkingArea.Invalidate;
      // inc(draggingTicks);
      end;
    }
  end;
end;

procedure TfrmMain.pbWorkingAreaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fDragging := False;
end;

procedure TfrmMain.pbWorkingAreaPaint(Sender: TObject);
begin
  DrawAll(pbWorkingArea.Canvas, blocks, labels, lines);
end;

procedure TfrmMain.sbMainMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (ssShift in Shift) then
    sbMain.HorzScrollBar.Position := sbMain.HorzScrollBar.Position + 10
  else
    sbMain.VertScrollBar.Position := sbMain.VertScrollBar.Position + 10;
end;

procedure TfrmMain.sbMainMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (ssShift in Shift) then
    sbMain.HorzScrollBar.Position := sbMain.HorzScrollBar.Position - 10
  else
    sbMain.VertScrollBar.Position := sbMain.VertScrollBar.Position - 10;
end;

end.
