unit DataStructures;

interface

uses
  Vcl.Graphics, System.Types;

type

  TState = (stNormal, stSelected, stLines);
  TLineType = (ltStraight, ltArrow, ltDualArrow);
  TBlockType = (Terminator, Process, Decision, Data, Predefined, Teleport, CycleUp, CycleDown);

  PBlock = ^TBlock;
  PText = ^TText;
  PLine = ^TLine;

  TBlockInfo = record
    id: integer;
    blockType: TBlockType;
    bounds: TRect;
    center: TPoint;
  end;

  TBlock = record
    state: TState;
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
    state: TState;
    info: TTextInfo;
    next: PText;
  end;

  TLineInfo = record
    id: integer;
    lineType: TLineType;
    startID: integer; // ID of connected to this line symbol
    finishID: integer; // ID of connected to the end of this line symbol
    start: TPoint; // In case there is no startID
    finish: TPoint; // In case there is no finishID

  end;

  TLine = record
    state: TState;
    info: TLineInfo;
    next: PLine;
  end;

procedure AddBlock(blocks: PBlock; blockToAdd: TBlockInfo);
procedure AddLine(lines: PLine; lineToAdd: TLineInfo);

function GetIdByCoord(point: TPoint; blocks: PBlock; labels: PText;
  lines: PLine): integer;
function GetNearestSymbolCoord(segment: integer; blocks: PBlock): TPoint;
function isPointInLine(point: TPoint; line: TLineInfo): boolean;

function RemoveBlock(blocks: PBlock; idToRemove: integer): boolean;
function RemoveLine(lines: PLine; idToRemove: integer): boolean;

procedure RemoveSelectedSymbols(canva: TCanvas; blocks: PBlock; labels: PText;
  lines: PLine);

procedure SelectSymbol(blocks: PBlock; lines: PLine; labels: PText;
  id: integer);
procedure OffsetSelectedSymbols(canva: TCanvas; blocks: PBlock; labels: PText;
  lines: PLine; offsetX, offsetY: integer);

procedure StartupInit(var blocks: PBlock; var lines: PLine; var labels: PText);
procedure UnselectSymbols(blocks: PBlock; labels: PText; lines: PLine);
procedure SetSymbolsState(state: TState; blocks: PBlock; labels: PText;
  lines: PLine);

implementation

var
  CurrentID: integer;
  lineArea: integer = 5;

procedure AddBlock(blocks: PBlock; blockToAdd: TBlockInfo);
begin
  inc(CurrentID);

  while blocks.next <> nil do
    blocks := blocks.next;

  New(blocks.next);

  blocks.state := stNormal;
  blocks.next.info := blockToAdd;
  blocks.next.info.id := CurrentID;
  blocks.next.next := nil;
end;

procedure AddLine(lines: PLine; lineToAdd: TLineInfo);
begin
  inc(CurrentID);

  while lines.next <> nil do
    lines := lines.next;

  New(lines.next);

  lines.state := stNormal;
  lines.next.info := lineToAdd;
  lines.next.info.id := CurrentID;
  lines.next.next := nil;
end;

function GetIdByCoord(point: TPoint; blocks: PBlock; labels: PText;
  lines: PLine): integer;
begin

  Result := -1;

  while blocks.next <> nil do
  begin
    blocks := blocks.next;
    if PtInRect(blocks.info.bounds, point) then
    begin
      Result := blocks.info.id;
      exit;
    end;
  end;

  while labels.next <> nil do
  begin
    labels := labels.next;
  end;

  while lines.next <> nil do
  begin
    lines := lines.next;
    if isPointInLine(point, lines.info) then
    begin
      Result := lines.info.id;
      exit;
    end;

  end;

end;

function GetNearestSymbolCoord(segment: integer; blocks: PBlock): TPoint;
var
  x, y: integer;
  yMin: integer;
  xMin: integer;
  centerX: integer;
  centerY: integer;
begin

  Result.x := 9999999;
  Result.y := 9999999;
  yMin := 9999999;
  xMin := 9999999;

  // Search of selected block
  while blocks.next <> nil do
  begin

    blocks := blocks.next;
    if blocks.state = stSelected then
    begin
      x := (blocks.info.bounds.right + blocks.info.bounds.left) div 2;
      y := (blocks.info.bounds.top + blocks.info.bounds.bottom) div 2;
      break;
    end;

  end;

  while blocks.next <> nil do
  begin

    blocks := blocks.next;
    centerX := (blocks.info.bounds.right + blocks.info.bounds.left) div 2;
    centerY := (blocks.info.bounds.top + blocks.info.bounds.bottom) div 2;

    // Selected block cannot be centered on itself
    if (centerX < x + segment) and (centerX > x - segment) and
      (blocks.state <> stSelected) then
    begin
      if (abs(centerY - y)) < yMin then
      begin
        yMin := abs(centerY - y);
        Result.x := centerX;
      end;
    end
    else if (centerY < y + segment) and (centerY > y - segment) and
      (blocks.state <> stSelected) then
    begin
      if (abs(centerX - x)) < xMin then
      begin
        xMin := abs(centerX - x);
        Result.y := centerY;
      end;
    end;

  end;

end;

function isPointInLine(point: TPoint; line: TLineInfo): boolean;
begin

  if (line.start.x = line.finish.x) or (line.start.y = line.finish.y) then
  begin
    if (point.x >= line.start.x - lineArea) and
      (point.x <= line.finish.x + lineArea) and
      (point.y >= line.start.y - lineArea) and
      (point.y <= line.finish.y + lineArea) then
      Result := true;

  end {
    else if (line.finish.y - line.start.y > 0) then
    begin
    LineTo(line.start.x, line.start.y + lineMargin);
    LineTo(line.finish.x, line.start.y + lineMargin);
    LineTo(line.finish.x, line.finish.y);
    end
    else if (line.finish.y - line.start.y < 0) then
    begin
    LineTo(line.start.x, line.start.y - lineMargin);
    LineTo(line.finish.x, line.start.y - lineMargin);
    LineTo(line.finish.x, line.finish.y);
    end; }

end;

procedure OffsetSelectedSymbols(canva: TCanvas; blocks: PBlock; labels: PText;
  lines: PLine; offsetX, offsetY: integer);
begin

  while (blocks.next <> nil) do
  begin
    blocks := blocks.next;

    if blocks.state = stSelected then
    begin
      inc(blocks.info.bounds.left, offsetX);
      inc(blocks.info.bounds.right, offsetX);
      inc(blocks.info.bounds.top, offsetY);
      inc(blocks.info.bounds.bottom, offsetY);
      inc(blocks.info.center.x, offsetX);
      inc(blocks.info.center.y, offsetY);
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

function RemoveLine(lines: PLine; idToRemove: integer): boolean;

var
  temp: PLine;

begin

  Result := false;

  while ((lines.next <> nil) and not(Result)) do
  begin

    if lines.next.info.id = idToRemove then
    begin

      temp := lines.next;
      lines.next := lines.next.next;
      Result := true;

      temp.next := nil;
      Dispose(temp);

    end;

    // In case of last element deletion
    if lines.next <> nil then
      lines := lines.next;

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

    if blocks.next.state = stSelected then
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

    if labels.next.state = stSelected then
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
      blocks.state := stSelected;
      exit;
    end;
  end;

  while labels.next <> nil do
  begin
    labels := labels.next;
    if labels.info.id = id then
    begin
      labels.state := stSelected;
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

procedure SetSymbolsState(state: TState; blocks: PBlock; labels: PText;
  lines: PLine);
begin

  while blocks.next <> nil do
  begin
    blocks := blocks.next;
    blocks.state := state;
  end;

  while labels.next <> nil do
  begin
    labels := labels.next;
    labels.state := state;
  end;

  {
    while lines.next <> nil do
    begin
    lines := labels.next;
    lines.isSelected := false;
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
    blocks.state := stNormal;
  end;

  while labels.next <> nil do
  begin
    labels := labels.next;
    labels.state := stNormal;
  end;

  while lines.next <> nil do
  begin
    lines := lines.next;
    lines.state := stNormal;
  end;
end;

end.
