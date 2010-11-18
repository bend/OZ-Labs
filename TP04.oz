

declare

fun {Incrementor L C}
   case L of (Char#Count)|T then
      if Char == C then Char#(Count+1)|T
      else Char#Count|{Incrementor T C}
      end
   else
      C#1|nil
   end
end


fun {Counter L Acc}
   case L of Xs|Ys then
      {Counter Ys {Incrementor Acc Xs}}
   else
      Acc
   end
end


%{Browse {Counter ['r' 'c' 'b'] nil}}
%{Browse {Incrementor nil 'b'}}

%Exo 3

proc {PassingTheToken Id Tin Tout}
   case Tin of H|T then X in
      {Show Id#H} {Delay 1000}
      Tout = H|X
      {PassingTheToken Id T X}
   [] nil then skip
   end
end


local X Y Z in
   thread {PassingTheToken 1 foo|Z s} end
   thread {PassingTheToken 2 X Y} end
   thread {PassingTheToken 3 Y Z} end
end

%Exo 4

fun {Bar N}
   if N==0 then nil
   else {Delay 500}'Beer'|{Bar N-1}
   end
end

fun {Foo L}
   case L of Xs|Ys then {Delay 1200} 'EmptyBeer'|{Foo Ys}
   else 'Burp'|nil
   end
end

local X Y in
thread X={Bar 20} end
thread Y={Foo X} end
{Browse Y}
end


	 
	 