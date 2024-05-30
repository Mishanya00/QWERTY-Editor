unit StackRoutine;

interface

uses
  DataStructures;

function CreateStack(): PStack;
function Pop(var stack: PStack): TStack;
procedure Push(var stack: PStack; const value: TStack);
function GetTop(const stack: PStack): TStack;
procedure DisposeStack(var stack: PStack);

implementation

function CreateStack(): PStack;
var
  stack: PStack;
begin
  New(stack);

  stack.blocks := nil;
  stack.labels := nil;
  stack.lines := nil;
  stack.next := nil;

  Result := stack;
end;

// Popped value must be NiledAndDisposed
function Pop(var stack: PStack): TStack;
var
  temp: PStack;
begin
  if stack.blocks <> nil then
  begin
    temp := stack;
    stack := stack.next;

    Result.blocks := temp.blocks;
    Result.labels := temp.labels;
    Result.lines := temp.lines;

    temp.next := nil;
    Dispose(temp);
  end;
end;

procedure Push(var stack: PStack; const value: TStack);
var
  temp: PStack;
begin
  New(temp);

  New(temp.blocks);
  temp.blocks.next := nil;
  New(temp.labels);
  temp.labels.next := nil;
  New(temp.lines);
  temp.lines.next := nil;
  temp.next := stack;

  CopySymbolsFromTo(value.blocks, value.labels, value.lines, temp.blocks,
    temp.labels, temp.lines);

  stack := temp;
end;

function GetTop(const stack: PStack): TStack;
begin
  Result.blocks := stack.blocks;
  Result.labels := stack.labels;
  Result.lines := stack.lines;
end;

procedure DisposeStack(var stack: PStack);
var
  tempStack: TStack;
begin
  while stack.blocks <> nil do
  begin
    tempStack := Pop(stack);
    SetSymbolsState(stSelected, tempStack.blocks, tempStack.labels,
      tempStack.lines);
    RemoveSelectedSymbols(tempStack.blocks, tempStack.labels, tempStack.lines);
    Dispose(tempStack.blocks);
    Dispose(tempStack.labels);
    Dispose(tempStack.lines);
  end;

  Dispose(stack);
end;

end.
