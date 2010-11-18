declare
proc {Max L ?R}
   proc {MaxLoop L M R}
      case L of nil then R=M
      [] H|T then
	 if M > H then R={MaxLoop T M}
	 else R={MaxLoop T H} end
      end
   end
in
   if L == nil then R=error
   else {MaxLoop L.2 L.1 R}
   end
end

%{Browse {Max [1 2 3 4 5 220 6 7 8 ]}}

fun {FactN N Acc}
   if N==0 then Acc
   else {FactN N-1 Acc*N}
   end
end

fun {FactList N M}
   if N==M then nil
   else {FactN M 1}|{FactList N M+1}
   end
end
%{Browse {FactList 101 1}}

fun {Flatten L}
   case L of H|T then
      case H of H2|T2 then
	 {Append {Flatten H} {Flatten T }}
      else H|{Flatten T} end
   else nil end
end


{Browse {Flatten [1[2[3 4 5 ] 6] 7] } } 