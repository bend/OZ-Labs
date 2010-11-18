declare
fun {ProdInts N N2}
   if N2==N then nil else
   {Delay 500}
      N|{ProdInts N+1 N2}
      end
end

fun {RemoveMultiple N L}
   case L of Xs|Ys then
      if Xs mod N==0 then
	 {RemoveMultiple N Ys}
      else
	 Xs|{RemoveMultiple N Ys}
      end
   else nil
   end
end

fun {Erastoth L}
   case L of Xs|Ys then
      Xs|{Erastoth thread {RemoveMultiple Xs L} end}
   else nil
   end
end




local X Y in
   thread X={ProdInts 2 1000} end
   thread Y={Erastoth X} end
   {Browse X}{Browse Y}
end
