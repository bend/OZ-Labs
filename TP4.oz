declare

fun {RandomChar}
   local N Chars in
      Chars = rec(a b c d e)
      N=({OS.rand} mod 5) +1
      Chars.N
   end
end
declare 
fun {Mine N}
   {Delay 2000}
   if N==0 then
      nil
   else
      {RandomChar}|{Mine N-1}
   end
end

fun {Count E L2}
   case L2 of (Name#Times)|T then
      if E==Name then Name#(Times+1)|T
      else Name#Times|{Count E T}
      end
   else E#1|nil
   end
end

fun {Counter L}
   fun {CounterAcc L L2}
      case L of H|T then
	 local E in E={Count H L2}
	    E|{CounterAcc T E}
	 end
      else
	 nil
      end
   end
in
   {CounterAcc L nil}
end

/*local X Y in
   thread X={Mine 1000} end
   thread Y = {Counter X} end
   {Browse Y}
end*/

proc {PassingTheToken Id Tin Tout}
   case Tin of H|T then X in
      {Show Id#H} {Delay 1000}
      Tout = H|X
      {PassingTheToken Id T X}
   [] nil then skip
   end
end

local X Y Z in
   thread {PassingTheToken 1 foo|Z X} end
   thread {PassingTheToken 2 X Y} end
   thread {PassingTheToken 3 Y Z} end
end


   