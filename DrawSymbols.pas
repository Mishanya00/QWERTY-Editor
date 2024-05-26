unit DrawSymbols;

interface

uses
  System.Types, Vcl.Graphics, DataStructures, windows;

procedure DrawAll(canva: TCanvas; blocks: PBlock; labels: PText; lines: PLine);

procedure DrawSelection(canva: TCanvas; bounds: TRect);
procedure DrawLineHooks(canva: TCanvas; bounds: TRect; center: TPoint);

procedure DrawCycleUp(canva: TCanvas; bounds: TRect);
procedure DrawCycleDown(canva: TCanvas; bounds: TRect);
procedure DrawTerminatorSymbol(canva: TCanvas; bounds: TRect);
procedure DrawProcessSymbol(canva: TCanvas; bounds: TRect);
procedure DrawDecisionSymbol(canva: TCanvas; bounds: TRect);
procedure DrawDataSymbol(canva: TCanvas; bounds: TRect);
procedure DrawPredefinedSymbol(canva: TCanvas; bounds: TRect);
procedure DrawTeleportSymbol(canva: TCanvas; bounds: TRect);
procedure DrawStorageDeviceSymbol(canva: TCanvas; bounds: TRect);

procedure DrawLabel(canva: TCanvas; labelToDraw: TTextInfo);
procedure DrawLine(canva: TCanvas; line: PLine);
procedure DrawBorders(canva: TCanvas; width, height: integer);

procedure InitDrawingProperties();
procedure SetCanvaAttributes(canva: TCanvas; state: TState);

implementation

var
  mainPenColor: TColor;
  mainPenWidth: integer;
  mainPenStyle: TPenStyle;
  mainBrushStyle: TBrushStyle;
  mainBrushColor: TColor;

  selectionPenColor: TColor;
  selectionPenStyle: TPenStyle;
  selectionBrushStyle: TBrushStyle;
  selectionBrushColor: TColor;
  selectionPenWidth: integer;
  selectionMargin: integer;

  hookPenColor: TColor;
  hookPenStyle: TPenStyle;
  hookBrushStyle: TBrushStyle;
  hookBrushColor: TColor;
  hookPenWidth: integer;
  hookSize: integer;

  lineMargin: integer;

procedure DrawAll(canva: TCanvas; blocks: PBlock; labels: PText; lines: PLine);
var
  prevBrushStyle: TBrushStyle;
  prevFont: TFont;
begin

  prevFont := canva.Font;

  while lines.next <> nil do
  begin
    lines := lines.next;

    if lines.state = stSelected then
    begin
      canva.Pen.Color := selectionPenColor;
      DrawLine(canva, lines);
      canva.Pen.Color := mainPenColor;
    end
    else
      DrawLine(canva, lines);
  end;

  while blocks.next <> nil do
  begin
    blocks := blocks.next;

    case blocks.info.blockType of
      btTerminator:
        DrawTerminatorSymbol(canva, blocks.info.bounds);
      btProcess:
        DrawProcessSymbol(canva, blocks.info.bounds);
      btDecision:
        DrawDecisionSymbol(canva, blocks.info.bounds);
      btData:
        DrawDataSymbol(canva, blocks.info.bounds);
      btPredefined:
        DrawPredefinedSymbol(canva, blocks.info.bounds);
      btTeleport:
        DrawTeleportSymbol(canva, blocks.info.bounds);
      btCycleUp:
        DrawCycleUp(canva, blocks.info.bounds);
      btCycleDown:
        DrawCycleDown(canva, blocks.info.bounds);
      btStorageDevice:
        DrawStorageDeviceSymbol(canva, blocks.info.bounds);
    end;

    prevBrushStyle := canva.Brush.Style;
    DrawLabel(canva, blocks.info.TextInfo);
    canva.Brush.Style := prevBrushStyle;

    if blocks.state = stSelected then
      DrawSelection(canva, blocks.info.bounds);
    if blocks.state = stLines then
      DrawLineHooks(canva, blocks.info.bounds, blocks.info.center);
  end;

  while labels.next <> nil do
  begin
    labels := labels.next;
    DrawLabel(canva, labels.info);

    if labels.state = stSelected then
      DrawSelection(canva, labels.info.bounds);
  end;

  canva.Brush.Style := prevBrushStyle;
  canva.Font := prevFont;
end;

procedure DrawBorders(canva: TCanvas; width, height: integer);
begin
  with canva do
  begin
    MoveTo(0, 0);
    LineTo(width, 0);
    LineTo(width, height);
    LineTo(0, height);
    LineTo(0, 0);
  end;
end;

procedure DrawCycleDown(canva: TCanvas; bounds: TRect);
begin

  with canva do
  begin
    // 15 это скос
    Polygon([Point(bounds.Left, bounds.Top), Point(bounds.Right, bounds.Top),
      Point(bounds.Right, bounds.Bottom - 15), Point(bounds.Right - 15,
      bounds.Bottom), Point(bounds.Left + 15, bounds.Bottom),
      Point(bounds.Left, bounds.Bottom - 15), Point(bounds.Left, bounds.Top)]);
  end;

end;

procedure DrawCycleUp(canva: TCanvas; bounds: TRect);
begin

  with canva do
  begin
    // 15 это скос
    Polygon([Point(bounds.Left, bounds.Top + 15), Point(bounds.Left + 15,
      bounds.Top), Point(bounds.Right - 15, bounds.Top), Point(bounds.Right,
      bounds.Top + 15), Point(bounds.Right, bounds.Bottom), Point(bounds.Left,
      bounds.Bottom), Point(bounds.Left, bounds.Top + 15)]);
  end;

end;

procedure DrawDataSymbol(canva: TCanvas; bounds: TRect);
begin

  with canva do
  begin
    Polygon([Point(bounds.Left + (bounds.Right - bounds.Left) div 8,
      bounds.Top), Point(bounds.Right + (bounds.Right - bounds.Left) div 8,
      bounds.Top), Point(bounds.Right - (bounds.Right - bounds.Left) div 8,
      bounds.Bottom), Point(bounds.Left - (bounds.Right - bounds.Left) div 8,
      bounds.Bottom)]);
  end;

end;

procedure DrawDecisionSymbol(canva: TCanvas; bounds: TRect);
begin
  with canva do
  begin
    Polygon([Point((bounds.Left + bounds.Right) div 2, bounds.Top),
      Point(bounds.Right, (bounds.Bottom + bounds.Top) div 2),
      Point((bounds.Left + bounds.Right) div 2, bounds.Bottom),
      Point(bounds.Left, (bounds.Bottom + bounds.Top) div 2)]);
  end;
end;

procedure DrawLabel(canva: TCanvas; labelToDraw: TTextInfo);
begin
  canva.Font.Name := labelToDraw.FontName;
  canva.Font.Size := labelToDraw.fontSize;
  canva.Brush.Style := bsClear;

  DrawText(canva.Handle, labelToDraw.text, Length(labelToDraw.text),
    labelToDraw.bounds, DT_CENTER);
end;

procedure DrawLine(canva: TCanvas; line: PLine);
begin
  with canva do
  begin

    MoveTo(line.vertexes[0].x, line.vertexes[0].y);

    for var i := 1 to Length(line.vertexes) - 1 do
    begin
      LineTo(line.vertexes[i].x, line.vertexes[i].y);
    end;

  end;
end;

procedure DrawLineHooks(canva: TCanvas; bounds: TRect; center: TPoint);
begin

  SetCanvaAttributes(canva, stLines);

  with canva do
  begin
    Rectangle(bounds.Left - hookSize, center.y - hookSize,
      bounds.Left + hookSize, center.y + hookSize);
    Rectangle(center.x - hookSize, bounds.Top - hookSize, center.x + hookSize,
      bounds.Top + hookSize);
    Rectangle(bounds.Right - hookSize, center.y - hookSize,
      bounds.Right + hookSize, center.y + hookSize);
    Rectangle(center.x - hookSize, bounds.Bottom - hookSize,
      center.x + hookSize, bounds.Bottom + hookSize);
  end;

  SetCanvaAttributes(canva, stNormal); // restore default drawing settings

end;

procedure DrawProcessSymbol(canva: TCanvas; bounds: TRect);
begin

  canva.Rectangle(bounds);

end;

procedure DrawTerminatorSymbol(canva: TCanvas; bounds: TRect);
begin

  canva.RoundRect(bounds.Left, bounds.Top, bounds.Right, bounds.Bottom,
    (bounds.Right - bounds.Left) div 2, (bounds.Right - bounds.Left) div 2);

end;

procedure DrawPredefinedSymbol(canva: TCanvas; bounds: TRect);
begin

  with canva do
  begin
    Rectangle(bounds);
    MoveTo(bounds.Left + 10, bounds.Top);
    LineTo(bounds.Left + 10, bounds.Bottom);
    MoveTo(bounds.Right - 10, bounds.Top);
    LineTo(bounds.Right - 10, bounds.Bottom);
    {
      canva.Rectangle(bounds.Left + 2 * (bounds.Right - bounds.Left) div 3,
      bounds.Top, bounds.Right - (bounds.Right - bounds.Left) div 3,
      bounds.Bottom);
    }
  end;

end;

procedure DrawSelection(canva: TCanvas; bounds: TRect);
begin

  SetCanvaAttributes(canva, stSelected);

  canva.Rectangle(bounds.Left - selectionMargin, bounds.Top - selectionMargin,
    bounds.Right + selectionMargin, bounds.Bottom + selectionMargin);

  SetCanvaAttributes(canva, stNormal);

end;

procedure DrawStorageDeviceSymbol(canva: TCanvas; bounds: TRect);
begin
  with canva do
  begin
    Rectangle(bounds);
    MoveTo(bounds.Left+5, bounds.Top);
    LineTo(bounds.Left+5, bounds.Bottom);
    MoveTo(bounds.Left, bounds.Top+5);
    LineTo(bounds.Right, bounds.Top+5);
  end;
end;

procedure DrawTeleportSymbol(canva: TCanvas; bounds: TRect);
begin

  canva.Ellipse(bounds.Left, bounds.Top, bounds.Right, bounds.Bottom);

end;

procedure InitDrawingProperties();
begin

  lineMargin := 20;

  mainPenWidth := 3;
  mainPenColor := clBlack;
  mainPenStyle := psSolid;
  mainBrushColor := clWhite;
  mainBrushStyle := bsSolid;

  selectionPenColor := clLime;
  selectionPenStyle := psDash;
  selectionPenWidth := 1;
  selectionBrushStyle := bsClear;
  selectionBrushColor := clNone;
  selectionMargin := 15;

  hookPenColor := clBlue;
  hookPenStyle := psSolid;
  hookBrushStyle := bsSolid;
  hookBrushColor := clBlue;
  hookPenWidth := 1;
  hookSize := 3;
end;

procedure SetCanvaAttributes(canva: TCanvas; state: TState);
begin
  case state of
    stNormal:
      begin
        canva.Pen.width := mainPenWidth;
        canva.Pen.Color := mainPenColor;
        canva.Pen.Style := mainPenStyle;
        canva.Brush.Color := mainBrushColor;
        canva.Brush.Style := mainBrushStyle;
      end;
    stSelected:
      begin
        canva.Pen.width := selectionPenWidth;
        canva.Pen.Color := selectionPenColor;
        canva.Pen.Style := selectionPenStyle;
        canva.Brush.Color := selectionBrushColor;
        canva.Brush.Style := selectionBrushStyle;
      end;
    stLines:
      begin
        canva.Pen.width := hookPenWidth;
        canva.Pen.Color := hookPenColor;
        canva.Pen.Style := hookPenStyle;
        canva.Brush.Color := hookBrushColor;
        canva.Brush.Style := hookBrushStyle;
      end;
  end;
end;

end.
