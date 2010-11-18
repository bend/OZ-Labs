declare R L
proc {Max L R}
   proc {MaxLoop L M R}
      case L of nil then R=M
      [] H|T then
	 if M > H then R={MaxLoop T M }
	 else {MaxLoop T H R} end
      end
   end
in
   if L == nil then R=error
   else {MaxLoop L.2 L.1 R} end
end

%exo 1.b

fun {Fact N Acc}
   if N==0 then Acc
   else {Fact N-1 Acc*N}
   end
end

fun {Prod N}
   N|{Prod N+1}
end

fun {FactN N N2}
   if N2==N then nil
   else {Fact N2 1}|{FactN N N2+1}
   end
end


%{Browse {FactN 10 1}}