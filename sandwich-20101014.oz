{Browse '|'(1:foo 2:'|'(2:nil 1:bar))}

{Browse rec(a:foo b:bar)}

{Browse a#b#c}
{Browse '#'(1:a 2:b 3:c)}

local
   X in
   X = a
   local X in
      X = b
      {Browse X}
   end
   {Browse X}
end

declare
fun {Add X Y}
   X+Y
end

{Browse {Add 30 12}}

declare
proc {Add2 X Y ?R}
   R = X + Y
end

local T in
   {Add2 300 366 T}
   {Browse T}
end

local T in
   T = {Add2 300 366}
   {Browse T}
end

{Browse {Add2 300 366}}

local T in
   {Add 300 366 T}
   {Browse T}
end

{Browse Add}
{Browse Add2}
{Browse Browse}
{Browse [Add Add2]}

declare
fun {Sum N}
   fun {SumLoop N Acc}
      if N == 0 then Acc
      else NewAcc in
         NewAcc = Acc+N
         {SumLoop N-1 NewAcc}
      end
   end
in
   {SumLoop N 0}
end

declare
X Y
X = 1|Y
{Browse X}

Y = 2|nil

declare
X Y
X = thread 1+Y end
{Browse X}
{Delay 3000}
Y = 2

declare
%warning, this is pseudo code.
proc {TraverseTree T}
   case T
   of tree(info:I left:LT right:RT) then
      <do something>
   [] nil then
      <do something else>
   end
end

declare
proc {AlmostUseless X}
   if X == 666 then skip else skip end
end

declare
X
{Show X}
thread {AlmostUseless X} {Show X} end
{Delay 3000}
X = 42


