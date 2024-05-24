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
    panelSymbols: TPanel;
    actPaste: TAction;
    sbSupport: TStatusBar;
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
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    actLinesMode: TAction;
    actNormalMode: TAction;
    ToolButton12: TToolButton;
    actTextMode: TAction;
    ToolButton13: TToolButton;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    pnlCycleUp: TPanel;
    imgCycleUp: TImage;
    pnlCycleDown: TPanel;
    imgCycleDown: TImage;
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
    procedure pbWorkingAreaClick(Sender: TObject);

  private
    currentMode: TState;
    FFileName: string;

    blocks: PBlock;
    labels: PText;
    lines: PLine;

    defaultWidth: Integer;
    defaultHeight: Integer;

    tempLine: TLineInfo;
    tempLineId: Integer;
    tempLineAddr: PLine;

    startDraggingPoint: TPoint;
    draggingStep: Integer;
    liningStep: integer;

    startLiningPoint: TPoint;

    fLining: Boolean; // Process of creating lines in lines mode
    fDragging: Boolean;
    fSelecting: Boolean; // Process of selecting items inside the area
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
  NORMAL_MODE_TAG = 9;
  LINES_MODE_TAG = 10;
  TEXT_MODE_TAG = 11;

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
        ShowMessage('Save as routine');
      EXPORT_TAG:
        begin
          if not(sdMain.Execute()) then
            Exit;
          FFileName := sdMain.Files[0];
          if SameText(ExtractFileExt(FFileName), '.png') then
            SaveBitMapAsPng(FFileName, pbWorkingArea, blocks, labels, lines);
        end;

      CUT_TAG:
        ShowMessage('CUT routine');
      COPY_TAG:
        ShowMessage('COPY routine');
      PASTE_TAG:
        ShowMessage('PASTE routine');
      NORMAL_MODE_TAG:
        begin
          currentMode := stNormal;
          SetSymbolsState(stNormal, blocks, labels, lines);
          sbSupport.Panels[1].Text := 'Текущий режим: Основной';
          pbWorkingArea.Invalidate;
        end;
      LINES_MODE_TAG:
        begin
          currentMode := stLines;
          SetSymbolsState(stLines, blocks, labels, lines);
          sbSupport.Panels[1].Text := 'Текущий режим: Линии';
          pbWorkingArea.Invalidate;
        end;
      TEXT_MODE_TAG:
        begin
          sbSupport.Panels[1].Text := 'Текущий режим: Текст';
        end;
    end;

  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  InitDataStructures(blocks, lines, labels);
  InitDrawingProperties();

  pbWorkingArea.Width := 500;
  pbWorkingArea.Height := 800;

  SetCanvaAttributes(pbWorkingArea.Canvas, stNormal);
  sbSupport.Panels[1].Text := 'Текущий режим: Основной';

  // fCentered := false;

  selectedSymbolsCount := 0;
  defaultWidth := 50;
  defaultHeight := 25;
  draggingStep := 30;
  liningStep := 20;

  // Assignment of actions' tags
  actCreate.Tag := 1;
  actOpen.Tag := 2;
  actSave.Tag := 3;
  actSaveAs.Tag := 4;
  actExport.Tag := 5;
  actCut.Tag := 6;
  actCopy.Tag := 7;
  actPaste.Tag := 8;
  actNormalMode.Tag := 9;
  actLinesMode.Tag := 10;

  // Assignment of image-symbols tags
  imgTerminator.Tag := 1;
  imgProcess.Tag := 2;
  imgDecision.Tag := 3;
  imgData.Tag := 4;
  imgPredefined.Tag := 5;
  imgTeleport.Tag := 6;
  imgCycleUp.Tag := 7;
  imgCycleDown.Tag := 8;
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
    Accept := false;
end;

procedure TfrmMain.pbWorkingAreaClick(Sender: TObject);
begin
  case currentMode of
    stLines:
      begin
        if fLining = True then
        begin
          fLining := false;
          tempLine.finish := (Sender as TControl)
            .ScreenToClient(Mouse.CursorPos);
          AddLine(lines, tempLine);
          pbWorkingArea.Invalidate;
        end
        else
        begin
          fLining := True;
          tempLine.start := (Sender as TControl)
            .ScreenToClient(Mouse.CursorPos);
          tempLine.finish := tempLine.start; // Начало и конец линии совпадают
        end;
      end;
  end;

end;

procedure TfrmMain.pbWorkingAreaDragDrop(Sender, Source: TObject;
  X, Y: Integer);

var
  point: TPoint;
  tempBlock: TBlockInfo;

begin

  tempBlock.bounds := Rect(X - defaultWidth, Y - defaultHeight,
    X + defaultWidth, Y + defaultHeight);
  tempBlock.center.X := X;
  tempBlock.center.Y := Y;
  SetSymbolsState(stNormal, blocks, labels, lines);

  // Numbers equal the value of the corresponding tag
  case (Source as TImage).Tag of
    1:
      begin
        tempBlock.blockType := Terminator;
        AddBlock(blocks, tempBlock);
      end;
    2:
      begin
        tempBlock.blockType := Process;
        AddBlock(blocks, tempBlock);
      end;
    3:
      begin
        tempBlock.blockType := Decision;
        AddBlock(blocks, tempBlock);
      end;
    4:
      begin
        tempBlock.blockType := Data;
        AddBlock(blocks, tempBlock);
      end;
    5:
      begin
        tempBlock.blockType := Predefined;
        AddBlock(blocks, tempBlock);
      end;
    6:
      begin
        tempBlock.bounds := Rect(X - defaultHeight, Y - defaultHeight,
          X + defaultHeight, Y + defaultHeight);
        tempBlock.blockType := Teleport;
        AddBlock(blocks, tempBlock);
      end;
    7:
      begin
        tempBlock.blockType := CycleUp;
        AddBlock(blocks, tempBlock);
      end;
    8:
      begin
        tempBlock.blockType := CycleDown;
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
  case currentMode of

    stNormal:
      begin

        case Button of
          mbLeft:
            begin
              id := GetIdByCoord(point(X, Y), blocks, labels, lines);
              if id <> -1 then
              begin
                fDragging := True;

                startDraggingPoint.X := X;
                startDraggingPoint.Y := Y;

                if not(ssShift in Shift) then
                begin
                  SetSymbolsState(stNormal, blocks, labels, lines);
                  selectedSymbolsCount := 0;
                end;

                SelectSymbol(blocks, lines, labels, id);
                Inc(selectedSymbolsCount);
              end
              else
              begin
                SetSymbolsState(stNormal, blocks, labels, lines);
                fSelecting := True;
              end;
            end;
        end;

      end;

    stLines:
      begin

        case Button of
          mbLeft:
            begin
              fLining := True;
              tempLineId := -1;
              // It means that this line hasnt been added to lines list
              startLiningPoint.X := X;
              startLiningPoint.Y := Y;
              tempLine.start.X := X;
              tempLine.start.Y := Y;
            end;
        end;

      end;
  end;

  pbWorkingArea.Invalidate; // To redraw the whole PaintBox
end;

procedure TfrmMain.pbWorkingAreaMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);

var
  centered: TPoint;

begin

  sbSupport.Panels[0].Text := 'X: ' + IntToStr(X) + '  Y: ' + IntToStr(Y);

  if fDragging = True then
  begin

    if (X + defaultWidth >= pbWorkingArea.Width) then
      pbWorkingArea.Width := X + defaultWidth + 100;
    if (Y + defaultHeight >= pbWorkingArea.Height) then
      pbWorkingArea.Height := Y + defaultHeight + 100;

    if (abs(X - startDraggingPoint.X) >= draggingStep) or
      (abs(Y - startDraggingPoint.Y) >= draggingStep) then
    begin
      OffsetSelectedSymbols(pbWorkingArea.Canvas, blocks, labels, lines,
        X - startDraggingPoint.X, Y - startDraggingPoint.Y);
      startDraggingPoint.X := X;
      startDraggingPoint.Y := Y;
      pbWorkingArea.Invalidate;
    end;
  end;

  if fLining = True then
  begin
    if (abs(X - startLiningPoint.X) >= liningStep) or
      (abs(Y - startLiningPoint.Y) >= liningStep) then
    begin
      {
      if (abs(X - startLiningPoint.X) >= draggingStep) then
        tempLine.finish.X := X
      else
        tempLine.finish.X := startLiningPoint.X;
      if (abs(Y - startLiningPoint.Y) >= draggingStep) then
        tempLine.finish.Y := Y
      else
        tempLine.finish.Y := startLiningPoint.Y;
      }

      tempLine.finish.X := X;
      tempLine.finish.Y := Y;

      if tempLineId = -1 then
      begin
        tempLineId := AddLine(lines, tempLine);
        tempLineAddr := GetLineById(tempLineId, lines);
      end
      else
        SetLineCoord(tempLineAddr, tempLine.start, tempLine.finish);

      startLiningPoint.X := X;
      startLiningPoint.Y := Y;

      pbWorkingArea.Invalidate;
    end;
  end;

end;

procedure TfrmMain.pbWorkingAreaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fDragging := false;
  fLining := false;
  fSelecting := false;
end;

procedure TfrmMain.pbWorkingAreaPaint(Sender: TObject);
begin
  DrawAll(pbWorkingArea.Canvas, blocks, labels, lines);
  DrawBorders(pbWorkingArea.Canvas, pbWorkingArea.Width - 1,
    pbWorkingArea.Height - 1);
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
