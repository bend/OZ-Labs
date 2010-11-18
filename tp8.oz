declare

proc {ReadList L}
   case L of Xs|Ys then
      {Browse Xs}{ReadList Ys}
   else {Browse nil}
   end
end

declare P S
{NewPort S P}
{Send P foo}
{Send P bar}
%{Browse S}

declare P S L
L = [1 2 3 4 5 6 7]
{NewPort S P}
{Send P L}
%{ReadList S}

proc {RandomSenderManiac N P}
   if N > 0 then {CreateThread P N}{RandomSenderManiac N-1 P}
   else skip
   end
end

proc {CreateThread P V}
   thread {Delay {OS.rand} mod (3000 - 1000 +1) +1000} {Send P V} end
end


local P S in
{NewPort S P}
   {RandomSenderManiac 10 P}
  % thread {ReadList S} end
end
local P S in
fun {WaitTwo X Y}
      {NewPort S P}
      thread {Wait X} {Send P x} end
      thread {Wait Y} {Send P y} end
      thread
	 case S of x|_ then 2
	 [] y|_ then 1
	 end
      end
end
end

local X Y in
  % {Browse {WaitTwo X Y}}
   X=1
end

proc {Server L}
   case L of (Msg#Ack)|T then
      {Delay {OS.rand} mod (1500 - 500 +1) +500}
      Ack = unit
      {Server T}
   end
end

fun {SafeSend P M T}
   local Ack TimeOut X in
   {Send P M#Ack}
   thread {Delay T} TimeOut = unit end
   if {WaitTwo Ack TimeOut} == 1 then false else true end
   
   end
end

local  M T P S in
   {NewPort S P}
   thread {Server S} end
   M='msg'
   T=5000
  % {Browse {SafeSend P M T}}
end

declare

fun {WaitTwo X Y}
   local P S in
      {NewPort S P}
      thread {Wait X} {Send P x} end
      thread {Wait Y} {Send P y} end
      thread
	 case S of x|_ then 2
	 [] y|_ then 1
	 end
      end
   end
end

fun {StreamMerger S1 S2}
   local H1 H2 T1 T2 in
   S1 = H1|T1
   S2 = H2|T2
   if {WaitTwo H1 H2} ==2 then H1|{StreamMerger T1 S2}
   else H2|{StreamMerger S1 T2}
   end
   end
end

local A B in
   %{Browse thread {StreamMerger 1|2|3|A 4|5|6|B }end }
   {Delay 1000}
   A = 1|2|_
   {Delay 1000 }
   B = 2|2|_
end

fun {StreamMergerWPort S1 S2}
   local H1 H2 T1 T2 in
   S1 = H1|T1
   S2 = H2|T2
   if {WaitTwo H1 H2} ==2 then H1|{StreamMerger T1 S2}
   else H2|{StreamMerger S1 T2}
   end
   end
end
