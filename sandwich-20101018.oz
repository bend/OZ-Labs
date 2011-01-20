{Browse 666}

declare
P S

P = {NewPort S}

{Browse P}
{Browse S}

thread
   {Delay {OS.rand} mod 1000}
   {Send P foo}
end
thread
   {Delay {OS.rand} mod 1000}
   {Send P bar}
end


declare
proc {ReadList L}
   case L
   of H|T then
      {Browse H}
      {ReadList T}
   [] nil then
      skip
   end
end

declare
P S
{NewPort S P}
thread {ReadList S} end
{Browse bla}

{Send P 42}

declare
proc {RandomSenderManiac N P}
   for I in 1..N do
      thread
         {Delay 1000 + {OS.rand} mod 2000}
         {Send P I}
      end
   end
end

declare
S P
P = {NewPort S}
thread {ReadList S} end
{RandomSenderManiac 11 P}

declare
fun {WaitTwo X Y}
   P S
in
   P = {NewPort S}
   thread {Wait X} {Send P 1} end
   thread {Wait Y} {Send P 2} end
   S.1
end

declare
X Y
thread
   {Delay {OS.rand} mod 1000}
   X = foo
end
thread
   {Delay {OS.rand} mod 1000}
   Y = bar
end
{Browse {WaitTwo X Y}}

declare
fun {Server}
   P S
   proc {Loop S}
      case S
      of (Msg#Ack)|NewS then
         {Delay 500 + {OS.rand} mod 1000}
         {Show Msg}
         Ack = unit
         {Loop NewS}
      end
   end
in
   P = {NewPort S}
   thread {Loop S} end
   P
end

declare
Serveur = {Server}

declare
Ack
{Browse Ack}

{Send Serveur achel#Ack}

declare
fun {SafeSend P M T}
   Timeout Ack
in
   {Send P M#Ack}
   thread
      {Delay T}
      Timeout = unit
   end
   if {WaitTwo Timeout Ack} == 1 then false
   else true end
end

{Browse {SafeSend Serveur orval 1000}}


declare
fun {StreamMerger S1 S2}
   if {WaitTwo S1 S2} == 1 then
      S1.1|{StreamMerger S1.2 S2}
   else
      S2.1|{StreamMerger S1 S2.2}
   end
end

declare
C D E
A = 1|3|5|C
B = 2|4|6|D

{Browse thread {StreamMerger A B} end}

D = 8|E

C = 7|9|11|_

declare
fun {StreamMerger S1 S2}
   H1 T1 H2 T2
in
   S1 = H1|T1
   S2 = H2|T2
   if {WaitTwo H1 H2} == 1 then
      H1|{StreamMerger S2 T1}
   else
      H2|{StreamMerger T2 S1}
   end
end

declare
P1 P2 S1 S2
{NewPort S1 P1}
{NewPort S2 P2}

thread
   {Delay {OS.rand} mod 1000}
   {Send P1 foo}
end
thread
   {Delay {OS.rand} mod 1000}
   {Send P2 bar}
end

{Browse thread {StreamMerger S1 S2} end}
