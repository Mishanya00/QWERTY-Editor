﻿unit DataStructures;

interface

uses
  Vcl.Graphics;

type

  TLineType = (Straight, Arrow, DualArrow);
  TBlockType = (Symbol, Decision, Teleport);

  PBlock = ^TBlock;
  PText = ^TText;
  PLine = ^TLine;

  TBlockInfo = record
    id: integer;
    blockType: TBlockType;
    x: integer;
    y: integer;
    length: integer;
    height: integer;

  end;

  TBlock = record
    info: TBlockInfo;
    next: PBlock;
  end;

  TTextInfo = record
    id: integer;
    size: integer;
    font: TFont;
    x: integer;
    y: integer;
    angle: integer;

  end;

  TText = record
    info: TTextInfo;
    next: PText;
  end;

  TLineInfo = record
    id: integer;
    lineType: TLineType;
    width: integer;
    x1, y1: integer;
    x2, y2: integer;

  end;

  TLine = record
    info: TLineInfo;
    next: PLine;
  end;

procedure startupInit(blocks: PBlock; lines: PLine; labels: PText);

implementation

procedure startupInit(blocks: PBlock; lines: PLine; labels: PText);
begin

  New(blocks);
  blocks.next := nil;
  blocks.info.id := 0;

  New(lines);
  lines.next := nil;
  lines.info.id := 0;

  New(labels);
  labels.next := nil;
  labels.info.id := 0;

end;

end.
