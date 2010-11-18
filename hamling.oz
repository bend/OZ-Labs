declare

fun {Main1 L2 L3 L5}
   case L2 of H2|T2 then 
      case L3 of H3|T3 then 
	 case L5 of H5|T5 then 
	    if {Min H2 H3} == H2 then 
	       if {Min H2 H5} == H2 then 
		  H2|{Main1 T2 L3 L5}
	       else H5|{Main1 L2 L3 T5} end
	    else 
	       if {Min H3 H5} == H3 then
		  H3|{Main1 L2 T3 L5}
	       else H5|{Main1 L2 L3 T5} end
	    end
	 end
      end
   end
end







fun {L2 L}
   case L of H|T then 2*H|{L2 T}
   else nil
   end
end

fun {L3 L}
    case L of H|T then 3*H|{L3 T}
    else nil
    end
end

fun {L5 L}
    case L of H|T then 5*H|{L5 T}
    else nil
    end
end


local X Y Z W in
   thread X={Main1 [2 4 6 8] [3 6 9 12] [5 10 15 20]} end
   %thread Y={L2 X} end
   %thread Z={L3 X} end
   %thread W={L5 X} end
   {Browse X}%{Browse Y}{Browse Z}{Browse W}
   %X=1|_
end
