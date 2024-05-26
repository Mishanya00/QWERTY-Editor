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
    actPrint: TAction;
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
    actSelectAll: TAction;
    SelectAll1: TMenuItem;
    fdTextMode: TFontDialog;
    N15: TMenuItem;
    N16: TMenuItem;
    actChooseFont: TAction;
    ToolButton14: TToolButton;
    reMainInput: TRichEdit;
    pdMain: TPrintDialog;
    ilFlowchartSymbols: TImageList;
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
    procedure reMainInputChange(Sender: TObject);
    procedure reMainInputKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure reMainInputExit(Sender: TObject);
    procedure sdMainTypeChange(Sender: TObject);

  private
    currentMode: TState;
    FFileName: string;

    blocks: PBlock;
    labels: PText;
    lines: PLine;

    defaultWidth: Integer;
    defaultHeight: Integer;

    tempLabel: PText;
    tempBlock: PBlock;
    tempLine: TLineInfo;
    tempLineId: Integer;
    tempLineAddr: PLine;

    startDraggingPoint: TPoint;
    startDraggingDrawingPoint: TPoint;
    draggingStep: Integer;
    draggingDrawingStep: Integer;
    liningStep: Integer;
    textInBlockMargin: Integer;

    startLiningPoint: TPoint;

    fLining: Boolean; // Process of creating lines in lines mode
    fDragging: Boolean;
    fSelecting: Boolean; // Process of selecting items inside the area
    fCentered: Boolean; // To prevent from centering after centering
    fTexting: Boolean;

    BlockTextingID: Integer;
    LabelTextingID: Integer;
    // ID of block being texting inside. Equals -1 if outside any block

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
  PRINT_TAG = 5;
  CUT_TAG = 6;
  COPY_TAG = 7;
  PASTE_TAG = 8;
  NORMAL_MODE_TAG = 9;
  LINES_MODE_TAG = 10;
  TEXT_MODE_TAG = 11;
  SELECT_ALL_TAG = 12;
  CHOOSE_FONT_TAG = 13;

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
          if FFileName = '' then
          begin
            if not(sdMain.Execute()) then
              Exit;

            FFileName := sdMain.Files[0];
          end;

          if SameText(ExtractFileExt(FFileName), '.rog') then
            SaveFileAsRog(FFileName, blocks, labels, lines)
          else if SameText(ExtractFileExt(FFileName), '.png') then
            SaveBitMapAsPng(FFileName, pbWorkingArea, blocks, labels, lines);

        end;

      SAVE_AS_TAG:
        begin
          if not(sdMain.Execute()) then
            Exit;

          FFileName := sdMain.Files[0];

          if SameText(ExtractFileExt(FFileName), '.rog') then
            SaveFileAsRog(FFileName, blocks, labels, lines)
          else if SameText(ExtractFileExt(FFileName), '.png') then
            SaveBitMapAsPng(FFileName, pbWorkingArea, blocks, labels, lines);
        end;

      PRINT_TAG:
        begin

          ShowMessage('Print action');

        end;

      CUT_TAG:
        ShowMessage('CUT routine');
      COPY_TAG:
        ShowMessage('COPY routine');
      PASTE_TAG:
        ShowMessage('PASTE routine');
      SELECT_ALL_TAG:
        begin
          SetSymbolsState(stSelected, blocks, labels, lines);
          pbWorkingArea.Invalidate;
        end;

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
          currentMode := stText;
          SetSymbolsState(stNormal, blocks, labels, lines);
          sbSupport.Panels[1].Text := 'Текущий режим: Текст';
          pbWorkingArea.Invalidate;
        end;
      CHOOSE_FONT_TAG:
        begin
          if not(fdTextMode.Execute()) then
            Exit;
          reMainInput.Font := fdTextMode.Font;
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

  tempBlock := nil;
  tempLabel := nil;
  FFileName := '';

  selectedSymbolsCount := 0;
  defaultWidth := 50;
  defaultHeight := 25;
  draggingStep := 3;
  draggingDrawingStep := 20;
  liningStep := 20;
  textInBlockMargin := 5;

  reMainInput.Font := fdTextMode.Font;
  reMainInput.Width := 100;

  fLining := false;
  fDragging := false;
  fSelecting := false;
  fTexting := false;

  BlockTextingID := -1;
  LabelTextingID := -1;

  // Assignment of actions' tags
  actCreate.Tag := CREATE_TAG;
  actOpen.Tag := OPEN_TAG;
  actSave.Tag := SAVE_TAG;
  actSaveAs.Tag := SAVE_AS_TAG;
  actPrint.Tag := PRINT_TAG;
  actCut.Tag := CUT_TAG;
  actCopy.Tag := COPY_TAG;
  actPaste.Tag := PASTE_TAG;
  actNormalMode.Tag := NORMAL_MODE_TAG;
  actLinesMode.Tag := LINES_MODE_TAG;
  actTextMode.Tag := TEXT_MODE_TAG;
  actSelectAll.Tag := SELECT_ALL_TAG;
  actChooseFont.Tag := CHOOSE_FONT_TAG;

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
var
  point: TPoint;

begin
  case currentMode of
    stText:
      begin

        point := (Sender as TControl).ScreenToClient(Mouse.CursorPos);

        // If user has already typed text and then clicked to the empty place. We should launch RichEdit.Exit
        if (reMainInput.Enabled = True) then
        begin
          reMainInput.Enabled := false;
          reMainInput.Visible := false;
        end

        else
        begin

          BlockTextingID := GetBlockIdByCoord(point, blocks);
          LabelTextingID := GetLabelIDByCoord(point, labels);

          if BlockTextingID <> -1 then
          begin
            tempBlock := GetBlockByID(BlockTextingID, blocks);
            if tempBlock <> nil then
            begin
              reMainInput.Left := tempBlock.info.bounds.Left;
              reMainInput.Top := tempBlock.info.bounds.Top;
              reMainInput.Width := tempBlock.info.bounds.Right -
                tempBlock.info.bounds.Left;
              reMainInput.Height := tempBlock.info.bounds.Bottom -
                tempBlock.info.bounds.Top;
              reMainInput.Text := tempBlock.info.TextInfo.Text;
            end
            else // In case existed block surprizingly dissapears
            begin
              BlockTextingID := -1;
              Exit;
            end;
          end
          else if LabelTextingID <> -1 then
          begin
            tempLabel := GetLabelByID(BlockTextingID, labels);
            if tempLabel <> nil then
            begin
              reMainInput.Left := tempLabel.info.bounds.Left;
              reMainInput.Top := tempLabel.info.bounds.Top;
              reMainInput.Width := tempLabel.info.bounds.Right -
                tempLabel.info.bounds.Left;
              reMainInput.Height := tempLabel.info.bounds.Bottom -
                tempLabel.info.bounds.Top;
              reMainInput.Text := tempLabel.info.Text;
            end
            else // In case existed block surprizingly dissapears
            begin
              LabelTextingID := -1;
              Exit;
            end;
          end
          else
          begin
            reMainInput.Left := point.X;
            reMainInput.Top := point.Y;
            reMainInput.Height := 5 * fdTextMode.Font.Size;
          end;

          reMainInput.Enabled := True;
          reMainInput.Visible := True;
          reMainInput.SetFocus;

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

  tempBlock.LLineID := -1;
  tempBlock.ULineID := -1;
  tempBlock.RLineID := -1;
  tempBlock.BLineID := -1;

  tempBlock.TextInfo.bounds.Left := tempBlock.bounds.Left + textInBlockMargin;
  tempBlock.TextInfo.bounds.Top := tempBlock.bounds.Top;
  // + textInBlockMargin;
  tempBlock.TextInfo.bounds.Right := tempBlock.bounds.Right - textInBlockMargin;
  tempBlock.TextInfo.bounds.Bottom := tempBlock.bounds.Bottom;
  // - textInBlockMargin;

  tempBlock.TextInfo.fontName := fdTextMode.Font.Name;
  tempBlock.TextInfo.fontSize := fdTextMode.Font.Size;
  tempBlock.TextInfo.Text := 'Текст';

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
  // Without this empty function DragDrop does not work
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
                startDraggingDrawingPoint.X := X;
                startDraggingDrawingPoint.Y := Y;

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

    stText:
      begin
        case Button of
          mbLeft:
            begin
              id := GetBlockIdByCoord(point(X, Y), blocks);
              if id <> -1 then
              begin

                // smth is here

              end;
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

      { // Increasing draggingStep during drag
        if draggingStep <= 30 then
        draggingStep := draggingStep + 3;
      }

      OffsetSelectedSymbols(pbWorkingArea.Canvas, blocks, labels, lines,
        X - startDraggingPoint.X, Y - startDraggingPoint.Y);

      startDraggingPoint.X := X;
      startDraggingPoint.Y := Y;

      if (abs(X - startDraggingDrawingPoint.X) >= draggingDrawingStep) or
        (abs(Y - startDraggingDrawingPoint.Y) >= draggingDrawingStep) then
      begin
        startDraggingDrawingPoint.X := X;
        startDraggingDrawingPoint.Y := Y;
        pbWorkingArea.Invalidate;
      end;
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

  if fSelecting = True then
  begin

  end;

end;

procedure TfrmMain.pbWorkingAreaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if fDragging = True then
  begin
    fDragging := false;
    pbWorkingArea.Invalidate;
  end;
  fLining := false;
  fSelecting := false;
end;

procedure TfrmMain.pbWorkingAreaPaint(Sender: TObject);
begin
  DrawAll(pbWorkingArea.Canvas, blocks, labels, lines);
  DrawBorders(pbWorkingArea.Canvas, pbWorkingArea.Width - 1,
    pbWorkingArea.Height - 1);
end;

procedure TfrmMain.reMainInputChange(Sender: TObject);
begin
  reMainInput.Height := reMainInput.lines.Count * 3 * fdTextMode.Font.Size;
end;

procedure TfrmMain.reMainInputExit(Sender: TObject);
var
  tempLabelInfo: TTextInfo;
  line: string;
begin
  // Save of input data when user finishes writing text
  if Length(reMainInput.Text) >= 99 then
    ShowMessage('Длина текста не должна превышать 99 символов! У вас: ' +
      IntToStr(Length(reMainInput.Text)))
  else if Length(reMainInput.Text) <> 0 then
  begin

    tempLabelInfo.fontName := reMainInput.Font.Name;
    tempLabelInfo.fontSize := reMainInput.Font.Size;

    tempLabelInfo.bounds := reMainInput.BoundsRect;
    tempLabelInfo.Text := '';

    for line in reMainInput.lines do
      tempLabelInfo.Text := tempLabelInfo.Text + line + #10;

    if BlockTextingID <> -1 then
      SetBlockTextInfo(BlockTextingID, tempLabelInfo, blocks)
    else if LabelTextingID <> -1 then
      SetLabelInfo(LabelTextingID, tempLabelInfo, labels)
    else
      AddLabel(labels, tempLabelInfo);

    pbWorkingArea.Invalidate;
  end;

  BlockTextingID := -1;
  reMainInput.Text := '';
end;

procedure TfrmMain.reMainInputKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        reMainInput.Enabled := false;
        reMainInput.Visible := false;
      end;
  end;
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

procedure TfrmMain.sdMainTypeChange(Sender: TObject);
begin
  case sdMain.FilterIndex of
    1:
      sdMain.DefaultExt := 'rog';
    2:
      sdMain.DefaultExt := 'png';
  else
    sdMain.DefaultExt := '';
  end;
end;

end.
