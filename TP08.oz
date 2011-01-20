%Exo 1
declare
proc {ReadList L}
   case L of H|T then
      {Browse H}{ReadList T}
   end
end

proc {RandomSenderManiac N P}
   for I in 1..N do
      thread
	 {Delay ({OS.rand}mod (3000-1000-1000))+1000}
	 {Send P finish#I}
      end
   end
end

P S in
P = {NewPort S}
thread {ReadList S} end
{RandomSenderManiac 10 P}

declare

fun {WaitTwo X Y} %returns 1 if X bound before Y, 2 otherwise
   P S in P={NewPort S}
   thread {Wait X} {Send P 1} end
   thread {Wait Y} {Send P 2} end
   S.1
end
/*X Y in
thread {Delay 2000} X=unit end
thread {Delay 3000} Y=unit end 
{Browse {WaitTwo X Y }}*/

declare
proc {Server S}
   case S of Msg#Ack|T then {Delay {OS.rand} mod ((1500 - 500) + 500)} Ack=unit end
end

fun {SafeSend P M T}
   X Ack in
   thread {Delay T} X=unit end
   {Send P M#Ack}
   if {WaitTwo X Ack}==1 then false else true end
end

/*P S Msg Ack in P ={NewPort S}
thread {Server S} end
{Browse {SafeSend P test 1000}}
*/

declare

fun {StreamMerger S1 S2}
   if {WaitTwo S1 S2} ==1 then
      S1.1|{StreamMerger S1.2 S2}
   else
      S2.1|{StreamMerger S1 S2.2}
   end
end

declare

fun {StreamMergerWP S1 S2}
   P S 
   proc {Aux S1 S2}
      if {WaitTwo S1 S2} == 1 then
	 {Send P S1.1}
	 {Aux S1.2 S2}
      else
	 {Send P S2.1}
	 {Aux S1 S2.2}
      end
   end
in
   P={NewPort S}
   {Aux S1 S2}
   S
end

proc {ReadList L}
   case L of H|T then
      {Browse H}{ReadList T}
   end
end



{Browse {StreamMergerWP 1|2|3|4|_ 1|2|3|4|_ }}



   
   
   
      
