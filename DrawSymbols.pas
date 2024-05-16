unit DrawSymbols;

interface

uses
  System.Types, Vcl.Graphics;

procedure SetCanvaAttributes(canva: TCanvas; penColor, brushColor: TColor;
  brushStyle: TBrushStyle);
procedure DrawProcessSymbol(canva: TCanvas; x, y, width, height: integer);
procedure InitDraw();

var
  boundColor: TColor;
  fillColor: TColor;

implementation

procedure DrawProcessSymbol(canva: TCanvas; x, y, width, height: integer);
begin

  canva.Rectangle(x, y, width, height);

end;

procedure SetCanvaAttributes(canva: TCanvas; penColor, brushColor: TColor;
  brushStyle: TBrushStyle);
begin

  canva.Pen.Color := penColor;
  canva.Brush.Color := brushColor;
  canva.Brush.style := brushStyle;;

end;

procedure InitDraw();
begin
  boundColor := clBlack;
  fillColor := clWhite;
end;

end.
