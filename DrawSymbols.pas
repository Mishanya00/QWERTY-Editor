﻿unit DrawSymbols;

interface

uses
  System.Types, Vcl.Graphics, DataStructures;

{
  procedure SetCanvaAttributes(canva: TCanvas; penWidthArg: integer;
  penColorArg, brushColorArg: TColor; brushStyleArg: TBrushStyle);
}

procedure DrawAll(canva: TCanvas; blocks: PBlock);
procedure DrawProcessSymbol(canva: TCanvas; bounds: TRect);
procedure DrawSelection(canva: TCanvas; bounds: TRect);
procedure DrawTeleportSymbol(canva: TCanvas; bounds: TRect);
procedure DrawTerminatorSymbol(canva: TCanvas; bounds: TRect);

procedure InitDrawingProperties();
procedure UpdateCanvaAttributes(canva: TCanvas);

implementation

procedure SetSelectionCanvaAttributes(canva: TCanvas); forward;

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

procedure DrawAll(canva: TCanvas; blocks: PBlock);
begin

  while blocks.next <> nil do
  begin
    blocks := blocks.next;

    case blocks.info.blockType of
      Terminator:
        DrawTerminatorSymbol(canva, blocks.info.bounds);
      Process:
        DrawProcessSymbol(canva, blocks.info.bounds);
      Teleport:
        DrawTeleportSymbol(canva, blocks.info.bounds);
    end;

    if blocks.isSelected = true then
      DrawSelection(canva, blocks.info.bounds);
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

procedure DrawSelection(canva: TCanvas; bounds: TRect);
begin

  SetSelectionCanvaAttributes(canva);

  canva.Rectangle(bounds.Left - selectionMargin, bounds.Top - selectionMargin,
    bounds.Right + selectionMargin, bounds.Bottom + selectionMargin);

  UpdateCanvaAttributes(canva);

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

end;

procedure UpdateCanvaAttributes(canva: TCanvas);
begin

  canva.Pen.Width := mainPenWidth;
  canva.Pen.Color := mainPenColor;
  canva.Pen.Style := mainPenStyle;
  canva.Brush.Color := mainBrushColor;
  canva.Brush.Style := mainBrushStyle;

end;

procedure SetSelectionCanvaAttributes(canva: TCanvas);
begin

  canva.Pen.Width := selectionPenWidth;
  canva.Pen.Color := selectionPenColor;
  canva.Pen.Style := selectionPenStyle;
  canva.Brush.Color := selectionBrushColor;
  canva.Brush.Style := selectionBrushStyle;

end;

end.
