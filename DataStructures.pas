﻿unit DataStructures;

interface

uses
  Vcl.Graphics, System.Types;

type

  TLineType = (Straight, Arrow, DualArrow);
  TBlockType = (Terminator, Process, Decision, Data, Predefined, Teleport);

  PBlock = ^TBlock;
  PText = ^TText;
  PLine = ^TLine;

  TBlockInfo = record
    id: integer;
    blockType: TBlockType;
    bounds: TRect;
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

procedure AddBlock(blocks: PBlock; blockToAdd: TBlockInfo);
function GetIdByCoord(blocks: PBlock; lines: PLine; labels: PText; point: TPoint): integer;
function RemoveBlock(blocks: PBlock; idToRemove: integer): boolean;
procedure StartupInit(var blocks: PBlock; var lines: PLine; var labels: PText);

implementation

procedure AddBlock(blocks: PBlock; blockToAdd: TBlockInfo);
var
  id: integer;
begin

  inc(blocks.info.id);
  id := blocks.info.id;

  while blocks.next <> nil do
    blocks := blocks.next;

  New(blocks.next);

  blocks.next.info := blockToAdd;
  blocks.next.info.id := id;
  blocks.next.next := nil;

  exit;
end;

function GetIdByCoord(blocks: PBlock; lines: PLine; labels: PText; point: TPoint): integer;
begin

  Result := -1;

  while blocks.next <> nil do
  begin 
    blocks := blocks.next; 
    if PtInRect(blocks.info.bounds, point) then
    begin
      Result := blocks.info.id;
      break;
    end;
  end;

  while labels.next <> nil do
  begin 
    labels := labels.next;
  end;

  while lines.next <> nil do
  begin 
    lines := lines.next;
  end;

end;

function RemoveBlock(blocks: PBlock; idToRemove: integer): boolean;

var
  temp: PBlock;

begin

  Result := false;

  while ((blocks^.next <> nil) and not(Result)) do
  begin

    if blocks.next.info.id = idToRemove then
    begin

      temp := blocks.next;
      blocks.next := blocks.next.next;
      Result := true;

      temp.next := nil;
      Dispose(temp);

    end;

    // In case of last element deletion
    if blocks.next <> nil then
      blocks := blocks.next;

  end;

end;

procedure StartupInit(var blocks: PBlock; var lines: PLine; var labels: PText);
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
