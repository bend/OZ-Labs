declare

proc {Server S}
   case S of add( X Y R)|T then
      R = X+Y
   [] pow(X Y R)|T then
      R={Pow X Y}
   [] 'div'(X Y R)|T then
      R=X div Y
   else {Show 'message not understood'}
   end
   {Server S.2}
end

local S P M R in
   P = {NewPort S}
   thread {Server S} end
   M = 'div'( 2 3 R)
   {Send P M}
   %thread {Show R} end
end

fun {StudentRMI}
   S
in
   thread
      for ask(howmany:Beers) in S do
	 Beers = {OS.rand} mod 24
      end
   end
   {NewPort S}
end

fun {CreateUniversity Size}
   fun {CreateLoop I}
      if I =< Size then
	 {StudentRMI}|{CreateLoop I+1}
      
      else nil end
   end
in
   %% Kraft dinner is full of love and butter
   {CreateLoop 1}
end

fun {Ask L}
   Beers in
   case L of H|T then
      {Send H ask(howmany:Beers)}
      {Wait Beers}{Delay 200}
      Beers|{Ask T}
   else nil
   end
end

   
local P X Students in
Students = {CreateUniversity 10}
   thread X = {Ask Students} end
%{Browse X}
end

declare 
fun {NewPortObject Behaviour Init}
   proc {MsgLoop S1 State}
      case S1 of Msg|S2 then
	 {MsgLoop S2 {Behaviour Msg State}}
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin Init} end
   {NewPort Sin}
end
fun {Porter L Acc}
   case L of getIn(N) then Acc+N
   []getOut(N) then Acc-N
   []getCount(N) then N=Acc 
   else Acc
   end
end
local Port R in
   Port = {NewPortObject Porter 0}
   {Send Port getIn(5)}
   {Send Port getCount(R)}
   {Browse R}
end

declare
fun {NewStack}
   {NewPortObject Exec nil}
end

fun {NewPortObject Behaviour Init}
   proc {MsgLoop S1 State}
      case S1 of Msg|S2 then
	 {MsgLoop S2 {Behaviour Msg State}}
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin Init} end
   {NewPort Sin}
end

fun {Exec M Pile}
   case M of pop(X) then
      if Pile ==nil then X=nil Pile
      else 
	 X=Pile.1
	 Pile.2
      end
   [] push(X) then
      X|Pile
   [] isEmpty(X) then
      if Pile == nil then X=true else X=false end
      Pile
   [] pstack(X) then
      X=Pile
      Pile
   end
end

fun {Pop P}
   X in
   {Send P pop(X)}
   {Wait X}
   X
end

proc {Push E P}
   {Send P push(E)}
end

fun {PStack P}
   X in
   {Send P pstack(X)}
   {Wait X}
   X
end


local X P in
   P= {NewStack}
   %{Browse {Pop P }}   
end


declare

fun {NewQueue}
   {NewPortObject ExecQueue nil}
end

fun {NewPortObject Behaviour Init}
   proc {MsgLoop S1 State}
      case S1 of Msg|S2 then
	 {MsgLoop S2 {Behaviour Msg State}}
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin Init} end
   {NewPort Sin}
end

fun {ExecQueue M Queue}
   case M of dequeue(X) then
      if Queue ==nil then X=nil Queue
      else 
	 X=Queue.1
	 Queue.2
      end
   [] enqueue(X) then
      {Append [X] Queue}
   [] isEmpty(X) then
      if Queue == nil then X=true else X=false end
      Queue
   [] qstack(X) then
      X=Queue
      Queue
   end
end

fun {Dequeue P}
   X in
   {Send P dequeue(X)}
   {Wait X}
   X
end

proc {Enqueue E P}
   {Send P enqueue(E)}
end

fun {PQueue P}
   X in
   {Send P qstack(X)}
   {Wait X}
   X
end


local X P in
   P = {NewQueue}
   {Enqueue P 2}
   {Browse {PQueue P}}
end