unit StackRoutine;

interface

uses
  DataStructures;

function CreateStack: PStack;
function Pop(var stack: PStack): TStack;
procedure Push(var stack: PStack; const value: TStack);
function GetTop(const stack: PStack): TStack;
procedure DisposeStack(var stack: PStack);

implementation

function CreateStack: PStack;
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

  temp.blocks := value.blocks;
  temp.labels := value.labels;
  temp.lines := value.lines;
  temp.next := stack;

  stack := temp;
end;

function GetTop(const stack: PStack): TStack;
begin
  Result.blocks := stack.blocks;
  Result.labels := stack.labels;
  Result.lines := stack.lines;
end;

procedure DisposeStack(var stack: PStack);
begin
  while stack.blocks <> nil do
    Pop(stack);

  Dispose(stack);
end;

end.
