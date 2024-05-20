unit DataStructures;

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
    isSelected: boolean;
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
    isSelected: boolean;
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

function GetIdByCoord(blocks: PBlock; lines: PLine; labels: PText;
  point: TPoint): integer;
function GetNearestSymbolCoord(x, y, segment: integer; blocks: PBlock): TPoint;

function RemoveBlock(blocks: PBlock; idToRemove: integer): boolean;
procedure RemoveSelectedSymbols(canva: TCanvas; blocks: PBlock; labels: PText;
  lines: PLine);

procedure SelectSymbol(blocks: PBlock; lines: PLine; labels: PText;
  id: integer);
procedure OffsetSelectedSymbols(canva: TCanvas; blocks: PBlock; labels: PText;
  lines: PLine; offsetX, offsetY: integer);

procedure StartupInit(var blocks: PBlock; var lines: PLine; var labels: PText);
procedure UnselectSymbols(blocks: PBlock; labels: PText; lines: PLine);

implementation

var
  CurrentID: integer;

procedure AddBlock(blocks: PBlock; blockToAdd: TBlockInfo);
begin
  inc(CurrentID);

  while blocks.next <> nil do
    blocks := blocks.next;

  New(blocks.next);

  blocks.isSelected := false;
  blocks.next.info := blockToAdd;
  blocks.next.info.id := CurrentID;
  blocks.next.next := nil;
end;

function GetIdByCoord(blocks: PBlock; lines: PLine; labels: PText;
  point: TPoint): integer;
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

function GetNearestSymbolCoord(x, y, segment: integer; blocks: PBlock): TPoint;
var
  yMin: integer;
  xMin: integer;
  centerX: integer;
  centerY: integer;
begin

  Result.x := 9999999;
  Result.y := 9999999;
  yMin := 9999999;
  xMin := 9999999;

  while blocks.next <> nil do
  begin

    blocks := blocks.next;
    centerX := (blocks.info.bounds.right + blocks.info.bounds.left) div 2;
    centerY := (blocks.info.bounds.top + blocks.info.bounds.bottom) div 2;

    // Selected block cannot be centered on itself
    if (centerX < x + segment) and (centerX > x - segment) and
      (blocks.isSelected = false) then
    begin
      if (abs(centerY - y)) < yMin then
      begin
        yMin := abs(centerY - y);
        Result.x := centerX;
      end;
    end
    else if (centerY < y + segment) and (centerY > y - segment) and
      (blocks.isSelected = false) then
    begin
      if (abs(centerX - x)) < xMin then
      begin
        xMin := abs(centerX - x);
        Result.y := centerY;
      end;
    end;

  end;

end;

procedure OffsetSelectedSymbols(canva: TCanvas; blocks: PBlock; labels: PText;
  lines: PLine; offsetX, offsetY: integer);
begin

  while (blocks.next <> nil) do
  begin
    blocks := blocks.next;

    if blocks.isSelected = true then
    begin
      inc(blocks.info.bounds.left, offsetX);
      inc(blocks.info.bounds.right, offsetX);
      inc(blocks.info.bounds.top, offsetY);
      inc(blocks.info.bounds.bottom, offsetY);
    end;
  end;

  {
    while (labels.next <> nil) do
    begin
    labels := labels.next;

    if labels.isSelected = true then
    begin
    Inc(labels.info.bounds.Left, offsetX);
    Inc(labels.info.bounds.Right, offsetX);
    Inc(labels.info.bounds.Top, offsetY);
    Inc(labels.info.bounds.Bottom, offsetY);
    end;
    end;
  }
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

procedure RemoveSelectedSymbols(canva: TCanvas; blocks: PBlock; labels: PText;
  lines: PLine);

var
  temp: PBlock;
  tempLabel: PText;

begin

  while (blocks.next <> nil) do
  begin

    if blocks.next.isSelected = true then
    begin
      temp := blocks.next;
      blocks.next := blocks.next.next;
      temp.next := nil;
      Dispose(temp);
    end
    else
      blocks := blocks.next;
  end;

  while (labels.next <> nil) do
  begin

    if labels.next.isSelected = true then
    begin
      tempLabel := labels.next;
      labels.next := labels.next.next;
      tempLabel.next := nil;
      Dispose(tempLabel);
    end
    else
      labels := labels.next;
  end;

end;

procedure SelectSymbol(blocks: PBlock; lines: PLine; labels: PText;
  id: integer);
begin

  while blocks.next <> nil do
  begin
    blocks := blocks.next;
    if blocks.info.id = id then
    begin
      blocks.isSelected := true;
      exit;
    end;
  end;

  while labels.next <> nil do
  begin
    labels := labels.next;
    if labels.info.id = id then
    begin
      labels.isSelected := true;
      exit;
    end;
  end;

  {
    while lines.next <> nil do
    begin
    labels := labels.next;
    if labels.info.id = id then
    begin
    labels.isSelected := true;
    exit;
    end;
    end;
  }
end;

procedure StartupInit(var blocks: PBlock; var lines: PLine; var labels: PText);
begin

  CurrentID := 0;
  New(blocks);
  blocks.next := nil;

  New(lines);
  lines.next := nil;

  New(labels);
  labels.next := nil;

end;

procedure UnselectSymbols(blocks: PBlock; labels: PText; lines: PLine);
begin

  while blocks.next <> nil do
  begin
    blocks := blocks.next;
    blocks.isSelected := false;
  end;

  while labels.next <> nil do
  begin
    labels := labels.next;
    labels.isSelected := false;
  end;

  {
    while lines.next <> nil do
    begin
    lines := labels.next;
    lines.isSelected := false;
    end;
  }

end;

end.
