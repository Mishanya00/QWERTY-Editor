﻿unit DrawSymbols;

interface

uses
  System.Types, Vcl.Graphics, DataStructures;

procedure SetCanvaAttributes(canva: TCanvas; penWidth: integer;
  penColor, brushColor: TColor; brushStyle: TBrushStyle);

procedure DrawAll(canva: TCanvas; blocks: PBlock);
procedure DrawProcessSymbol(canva: TCanvas; bounds: TRect);
procedure DrawTeleportSymbol(canva: TCanvas; bounds: TRect);
procedure InitDraw();

var
  penWidth: integer;
  boundColor: TColor;
  fillColor: TColor;
  defaultWidth: integer = 50;
  defaultHeight: integer = 25;

implementation

procedure DrawAll(canva: TCanvas; blocks: PBlock);
begin

  while blocks.next <> nil do
  begin
    blocks := blocks.next;

    case blocks.info.blockType of
      Process:
        DrawProcessSymbol(canva, blocks.info.bounds);
      Teleport:
        DrawTeleportSymbol(canva, blocks.info.bounds);
    end;
  end;

end;

procedure DrawProcessSymbol(canva: TCanvas; bounds: TRect);
begin

  canva.Rectangle(bounds);

end;

procedure DrawTeleportSymbol(canva: TCanvas; bounds: TRect);
begin

  canva.Ellipse(bounds.left, bounds.top, bounds.right, bounds.bottom);

end;

procedure SetCanvaAttributes(canva: TCanvas; penWidth: integer;
  penColor, brushColor: TColor; brushStyle: TBrushStyle);
begin

  canva.Pen.Width := penWidth;
  canva.Pen.Color := penColor;
  canva.Brush.Color := brushColor;
  canva.Brush.style := brushStyle;

end;

procedure InitDraw();
begin
  boundColor := clBlack;
  fillColor := clWhite;

end;

end.
