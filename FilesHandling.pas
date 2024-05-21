unit FilesHandling;

interface

uses Vcl.ExtCtrls, Vcl.Graphics, DrawSymbols, DataStructures;

procedure SaveBitMapAsPng(const FileToSaveAs: string; pbToExport: TPaintBox;
  blocks: PBlock; labels: PText; lines: PLine);

implementation

procedure SaveBitMapAsPng(const FileToSaveAs: string; pbToExport: TPaintBox;
  blocks: PBlock; labels: PText; lines: PLine);
var
  interimBitmap: TBitmap;
begin

  interimBitmap := TBitmap.Create;
  try
    interimBitmap.SetSize(pbToExport.Width, pbToExport.Height);
    SetSymbolsState(stNormal, blocks, labels, lines);
    SetCanvaAttributes(interimBitmap.Canvas, stNormal);
    DrawAll(interimBitmap.Canvas, blocks, labels, lines);
    interimBitmap.SaveToFile(FileToSaveAs);
  finally
    interimBitmap.Free;
  end;

end;

end.
