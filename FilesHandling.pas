unit FilesHandling;

interface

uses System.SysUtils, System.Classes, Vcl.ExtCtrls, Vcl.Graphics, DrawSymbols,
  DataStructures;

procedure SaveBitMapAsPng(const FileToSaveAs: string; pbToExport: TPaintBox;
  blocks: PBlock; labels: PText; lines: PLine);
procedure SaveFileAsRog(const FileToSaveAs: string; blocks: PBlock;
  labels: PText; lines: PLine);
procedure ReadFileAsRog(const FileToRead: string; blocks: PBlock;
  labels: PText; lines: PLine);

implementation

const
  blockSeparator: TBlockInfo = (id: -999;);
  labelSeparator: TTextInfo = (id: -999;);
  lineSeparator: TLineInfo = (id: -999;);
  separatorID: integer = -999;

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

procedure ReadFileAsRog(const FileToRead: string; blocks: PBlock;
  labels: PText; lines: PLine);

var
  FMainStream: TFileStream;
  tempBlockInfo: TBlockInfo;
  tempTextInfo: TTextInfo;
  tempLineInfo: TLineInfo;

begin

  FMainStream := TFileStream.Create(FileToRead, fmOpenRead or fmShareDenyNone);

  FMainStream.ReadBuffer(tempBlockInfo, sizeof(TBlockInfo));

  while (tempBlockInfo.id <> separatorID) do
  begin
    AddBlock(blocks, tempBlockInfo);
    FMainStream.ReadBuffer(tempBlockInfo, sizeof(TBlockInfo));
  end;

  FMainStream.ReadBuffer(tempTextInfo, sizeof(TTextInfo));

  while tempTextInfo.id <> separatorID do
  begin
    AddLabel(labels, tempTextInfo);
    FMainStream.ReadBuffer(tempTextInfo, sizeof(TTextInfo));
  end;

  FMainStream.ReadBuffer(tempLineInfo, sizeof(TLineInfo));

  while tempLineInfo.id <> -999 do
  begin
    AddLine(lines, tempLineInfo);
    FMainStream.ReadBuffer(tempLineInfo, sizeof(TLineInfo));
  end;

  FMainStream.Destroy;
end;

procedure SaveFileAsRog(const FileToSaveAs: string; blocks: PBlock;
  labels: PText; lines: PLine);

var
  FMainStream: TFileStream;
begin

  FMainStream := TFileStream.Create(FileToSaveAs, fmCreate or fmOpenWrite or fmShareDenyNone);

  while blocks.next <> nil do
  begin
    blocks := blocks.next;
    FMainStream.WriteBuffer(blocks.info, sizeof(TBlockInfo));
  end;

  FMainStream.WriteBuffer(blockSeparator, sizeof(TBlockInfo));

  while labels.next <> nil do
  begin
    labels := labels.next;
    FMainStream.WriteBuffer(labels.info, sizeof(TTextInfo));
  end;

  FMainStream.WriteBuffer(labelSeparator, sizeof(TTextInfo));

  while lines.next <> nil do
  begin
    lines := lines.next;
    FMainStream.WriteBuffer(lines.info, sizeof(TLineInfo));
  end;

  FMainStream.WriteBuffer(lineSeparator, sizeof(TLineInfo));

  FMainStream.Destroy;
end;

end.
