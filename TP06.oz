%1
declare
fun lazy {Gen I}
   I|{Gen I+1}
end

%{Browse {Gen 1}}

fun {GiveMeNth N L}
   case L of H|T then
      if N==0 then H else {GiveMeNth N-1 T}
      end
   else nil
   end
end

%{Browse {GiveMeNth 10 {Gen 1}}}

%2
declare
fun lazy {Sieve Xs}
   case Xs of nil then nil
   [] X|Xr then
      X|{Sieve {Filter Xr fun {$ Y} Y mod X \= 0 end}}
   end
end


fun lazy {Filter Xs P}
   case Xs of
      nil then nil
   [] X|Xr then
      if {P X} then
	 X|{Filter Xr P}
      else
	 {Filter Xr P}
      end
   end
end


fun {Primes}
   {Sieve {Gen 2}}
end

fun {ShowPrimes N}
   fun {ShowAux N L}
      case L of H|T then
	 if N==0 then nil
	 else H|{ShowAux N-1 T} end
      else nil
      end
   end
in
   {ShowAux N {Primes}}
end

%{Browse {ShowPrimes 10}}

%Thread Termination
declare
proc {X}
R in
   thread {Browse begin}{Delay 1000}R=unit end
   {Wait R}
   {Browse finish}
end

{X}