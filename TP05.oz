declare
%1 a
fun {Numbers N I J}
   if N==0 then nil
   else
      {Delay 500}
      {OS.rand} mod (J-I+1) +I|{Numbers N-1 I J}
   end
end

%{Browse {Numbers  10 0 1}}
%1 b
fun {SumAndCount L Sum Count}
   case L of Xs|Ys then
      {Delay 250}Sum+Xs#Count+1|{SumAndCount Ys Sum+Xs Count+1}
   else nil
   end
end

%{Browse {SumAndCount [1 2 3 4 5] 0 0}}

%local X Y in
 %  thread X={Numbers 10 5 50} end
  % thread Y={SumAndCount X 0 0} end
   %{Browse X}
   %{Browse Y}
%end

%1 c
%Teta(N)
%1 d

fun {IsIn E L}
   case L of H|T then
      if E==H then true
      else {IsIn E T}
      end
   else false
   end
end



fun {FilterList Xs Ys}
   case Xs of H|T then
      if {Not {IsIn H Ys}} then
	    H|{FilterList T Ys}
      else {FilterList T Ys}
      end
   else nil
   end
end

%{Browse {FilterList [1 2 3 4] [2 4]}}

%local X Y Z in
 %  thread X={Numbers 100 1 10} end
  % thread Y={FilterList X [2 4 6 8 10]} end
   %thread Z={SumAndCount Y 0 0}end
   %{Browse X}
%   {Browse Y}
%   {Browse Z}
%end

%2

fun {MNot E}
   1-E
end

fun {NotGate Xs}
   case Xs of H|T then {MNot H}|{NotGate T}
   else nil
   end
end

fun {AndGate L L2}
   case L of H|T then
      case L2 of Xs|Ys then
	 if H==1 andthen H==Xs then 1|{AndGate T Ys}
	 else 0|{AndGate T Ys}
	 end
      else nil
      end
   else nil
   end
end

fun {OrGate L L2}
   case L of Xs|Ys then
      case L2 of H|T then
	 if Xs==1 orelse H==1 then 1|{OrGate Ys T}
	 else 0|{OrGate Ys T}
	 end
      else nil
      end
   else nil
   end
end

fun {Simulate G Ss}
   case G of gate(value:'not' In) then
      thread {NotGate {Simulate In Ss}}end
   [] gate(value:'and' In1 In2) then
      thread {AndGate {Simulate In1 Ss} {Simulate In2 Ss}} end
   [] gate(value:'or' In1 In2) then
      thread {OrGate {Simulate In1 Ss} {Simulate In2 Ss}} end
   [] input(X) then Ss.X end
end

local G I in
   I =input(x)
   G=gate(value:'or' gate(value:'and'
			  input(x)
			  input(y)) gate(value:'not'
					 input(z)))

%{Browse {Simulate G input(x:1|0|1|0|_ y:0|1|0|1|_ z:1|1|0|0|_ )}} 
end

fun {Foo Xs C}
   case Xs of H|T then  {Delay 1200}{Decrement C} 'Burp'|{Foo T C}
   else nil
   end
end


fun {Foo2 Xs C}
   case Xs of H|T then  {Delay 800}{Decrement C} 'Burp2'|{Foo2 T C}
   else nil
   end
end

proc {Increment C}
   C:=@C+1

end

proc {Decrement C}
   C:=@C-1
end


fun {Bar N C}
   if N==0 then nil
   elseif @C>=4 then {Bar N C}
   else {Delay 500}{Increment C} 'Beer'|{Bar N-1 C}
   end
end
   

   local X Y Z C in
    C = {NewCell 0}
   thread X={Bar 100 C} end
   thread Y={Foo X C} end
   thread Z={Foo2 X C} end

   {Browse X}{Browse Y}{Browse Z}
end


declare
L1 L2 F End
L1 = [1 2 3]
F = fun {$ X} {Delay 200} X*X end
thread L2 = {Map L1 F} End=unit end
{Wait End}
{Show L2}

declare
L1 L2 L3 L4 L1 = [1 2 3] End1 End2 End3
thread L2 = {Map L1 fun {$ X} {Delay 200} X*X end}End1=unit end
thread L3 = {Map L1 fun {$ X} {Delay 200} 2*X end} End2 = End1 end
thread L4 = {Map L1 fun {$ X} {Delay 200} 3*X end} End3 = End2 end
{Wait End3}
{Show L2#L3#L4}