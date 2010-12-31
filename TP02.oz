declare R L
proc {Max L R}
   proc {MaxLoop L M R}
      case L of nil then R=M
      [] H|T then
	 if M > H then {MaxLoop T M R}
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

%2 Tail recursion

fun {Sum N}
   if N==0 then 0
   else N+{Sum N-1}
   end
end

%a not tail recursive, because the program will calculate {Sum N-1} to add it to N.
% tail recursive version.

fun {Sum N Acc}
   if N==0 then Acc
   else {Sum N-1 N+Acc}
   end
end

%b tail recursive cause it uses list.

%c tail recursive version of fact

fun {FactTail N Acc}
   if N==0 then Acc
   else {FactTail N-1 Acc*N}
   end
end

% stream version
declare
fun {FactStream N Acc}
   if N==0 then nil
   else N*Acc|{FactStream N-1 Acc*N} end
end

{Browse {FactStream 10 1}}

%3
% it will browse a anbound variable.
%
% in this version it will browse the record with the second value unbound, and then when binding of Y is done it will appear in the browse, with a delay , we can see it more clearly
local
   X Y
in
   {Browse 'hello nurse'}
   X = sum(2 Y)
   {Browse X}
   {Delay 1000}
   Y = 40
end

%4
declare
proc {ForAllTail Xs P}
   case Xs of H|T then
      {P H}{ForAllTail T P}
   end
end

%{ForAllTail [1 2 3 4] Browse}

%5
declare

fun {Fibo N}
   if N<2 then 1
   else
      {Fibo N-1}+{Fibo N-2}
   end
end

{Browse {Fibo 6}}

%Acc version
declare
fun {Fibo2 N}
   fun {FiboAux N2 B1 B2 Acc}
      if N2==3 then Acc+1
      else
	 {FiboAux N2-1 B1+B2 B1 Acc+B1+B2}
      end
   end
in
   {FiboAux N 1 0 1}
end

{Browse {Fibo2 100010}}