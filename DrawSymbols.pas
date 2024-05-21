unit DrawSymbols;

interface

uses
  System.Types, Vcl.Graphics, DataStructures;

{
  procedure SetCanvaAttributes(canva: TCanvas; penWidthArg: integer;
  penColorArg, brushColorArg: TColor; brushStyleArg: TBrushStyle);
}

procedure DrawAll(canva: TCanvas; blocks: PBlock; labels: PText; lines: PLine);

procedure DrawSelection(canva: TCanvas; bounds: TRect);
procedure DrawLineHooks(canva: TCanvas; bounds: TRect; center: TPoint);

procedure DrawTerminatorSymbol(canva: TCanvas; bounds: TRect);
procedure DrawProcessSymbol(canva: TCanvas; bounds: TRect);
procedure DrawDecisionSymbol(canva: TCanvas; bounds: TRect);
procedure DrawDataSymbol(canva: TCanvas; bounds: TRect);
procedure DrawPredefinedSymbol(canva: TCanvas; bounds: TRect);
procedure DrawTeleportSymbol(canva: TCanvas; bounds: TRect);

procedure DrawVertLine(canva: TCanvas; x: integer);

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

procedure DrawAll(canva: TCanvas; blocks: PBlock; labels: PText; lines: PLine);
begin

  while blocks.next <> nil do
  begin
    blocks := blocks.next;

    case blocks.info.blockType of
      Terminator:
        DrawTerminatorSymbol(canva, blocks.info.bounds);
      Process:
        DrawProcessSymbol(canva, blocks.info.bounds);
      Decision:
        DrawDecisionSymbol(canva, blocks.info.bounds);
      Data:
        DrawDataSymbol(canva, blocks.info.bounds);
      Predefined:
        DrawPredefinedSymbol(canva, blocks.info.bounds);
      Teleport:
        DrawTeleportSymbol(canva, blocks.info.bounds);
    end;

    if blocks.state = stSelected then
      DrawSelection(canva, blocks.info.bounds);
    if blocks.state = stLines then
      DrawLineHooks(canva, blocks.info.bounds, blocks.info.center);
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

procedure DrawLineHooks(canva: TCanvas; bounds: TRect; center: TPoint);
begin

  SetCanvaAttributes(canva, stLines);

  with canva do
  begin
    Rectangle(bounds.Left - hookSize, center.Y - hookSize,
      bounds.Left + hookSize, center.Y + hookSize);
    Rectangle(center.x - hookSize, bounds.Top - hookSize, center.x + hookSize,
      bounds.Top + hookSize);
    Rectangle(bounds.Right - hookSize, center.Y - hookSize,
      bounds.Right + hookSize, center.Y + hookSize);
    Rectangle(center.x - hookSize, bounds.Bottom - hookSize,
      center.x + hookSize, bounds.Bottom + hookSize);
  end;

  SetCanvaAttributes(canva, stNormal); // restore default drawing settings

end;

procedure DrawVertLine(canva: TCanvas; x: integer);
begin
  with canva do
  begin
    MoveTo(x, 0);
    LineTo(x, ClipRect.Bottom);
  end;
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

procedure DrawTeleportSymbol(canva: TCanvas; bounds: TRect);
begin

  canva.Ellipse(bounds.Left, bounds.Top, bounds.Right, bounds.Bottom);

end;

procedure InitDrawingProperties();
begin
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
        canva.Pen.Width := mainPenWidth;
        canva.Pen.Color := mainPenColor;
        canva.Pen.Style := mainPenStyle;
        canva.Brush.Color := mainBrushColor;
        canva.Brush.Style := mainBrushStyle;
      end;
    stSelected:
      begin
        canva.Pen.Width := selectionPenWidth;
        canva.Pen.Color := selectionPenColor;
        canva.Pen.Style := selectionPenStyle;
        canva.Brush.Color := selectionBrushColor;
        canva.Brush.Style := selectionBrushStyle;
      end;
    stLines:
      begin
        canva.Pen.Width := hookPenWidth;
        canva.Pen.Color := hookPenColor;
        canva.Pen.Style := hookPenStyle;
        canva.Brush.Color := hookBrushColor;
        canva.Brush.Style := hookBrushStyle;
      end;
  end;
end;

end.
