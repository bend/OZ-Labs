%Ex 1
%{Show A==B} == true
%{Show T1==T2} == true
%{Show T1=T2 } == 0
%A:=@B
%{Show A==B} == false

%Ex 1
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

fun {CellBehaviour Msg Init}
   case Msg of assign(Val) then
      Val
   [] access(res:Res) then
      Res = Init
      Init
   else
      Init
   end
end
	 
fun {NewPCell }
  {NewPortObject CellBehaviour 0}
end

proc {Assign P Val}
   {Send P assign(Val)}
end

fun {Access P }
   Res in
   {Send P access(res:Res)}
   %{Wait Res}
   Res
end

%declare P
%P={NewPCell }
%{Assign P 22}
%{Browse {Access P}}

%Exo 3

fun {NewCPort Init}
   {NewCell Init|nil}
end

proc {SendC C Msg}
   T V in
   %Msg|T = @C
   %C:=T
   %Exchange is better
   {Exchange P Msg|T T}
end

%declare C in
%C ={NewCPort 2}
%{Browse @C}
%{SendC C test}
%{Browse @C}

%Exo 4
declare
proc {NewPortClose S ?SendC ?CloseC}
   C in
   proc {CloseC }
      @C=nil
   end
   proc {SendC Msg}
      T in
      {Exchange C Msg|T T}
   end
   C={NewCell S}
end

%Exo 5
declare
%Not synchronized
fun {Q A B}
   C in C = {NewCell 0}
   for I in A..B do
      C:=@C+I
   end
   C
end

%Synchronized

fun {Q A B}
   C in C = {NewCell 0}
   for I in A..B do
      New Old
   in
      {Exchange C Old New}
      New=Old+I % no need to wait because the adition will wait to Old to be bound
   end
end

%6 a
declare
class Counter
   attr c

   meth init()
      c:=0
   end

   meth add(N)
      Old New in      
      {Exchange c Old New}
      New:=Old+N
   end

   meth read(N)
      N=@c
   end

end
declare
fun {QObj A B}
   C R in C = {New Counter init}
   for I in A..B do
      {C add(I)}
   end
   {C read(R)}
   R
end

% 6 b

declare

class Port
   attr c
   meth init()
      S in 
      {Browse S}
      c:={NewCell S}
   end

   meth send(N)
      Old New in
      {Exchange @c N|New New}
   end

end

class PortClose from Port

   meth close()
      @c:=nil
   end

end

declare S
S = {New PortClose init}
{S send(5)}
{S close()}

