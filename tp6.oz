declare
%Exo 1
fun lazy {Gen I}
  I|{Gen I+1}
end

fun {GiveMeNth N L}
   case L of H|T then
      if N==1 then H else {GiveMeNth N-1 T}
      end
   else nil
   end
end

%{Browse {GiveMeNth 10 {Gen 0}}}


%Exo 2
declare
fun lazy {Filter Xs P}
   case Xs of H|T then
      if {P H} then H|{Filter T P}
      else {Filter T P}end
      else nil
   end
end

fun lazy {Sieve Xs}
   case Xs of nil then nil
   [] X|Xr then
      X|{Sieve {Filter Xr fun {$ Y} Y mod X \= 0 end} }
   end
end

fun {Primes}
   {Sieve {Gen 2}}
end


fun {ShowPrimes N}
   {GiveMeNth N {Primes}}{ShowPrimes N-1}
end



%Exo 4
declare 
fun {Gen I N}
   {Delay 500}
   if I==N then [I]
   else I|{Gen I+1 N} end
end

fun {Filter L F}
   case L of nil then nil
   [] H|T then
      if {F H} then H|{Filter T F} else {Filter T F} end end
end
fun {Map L F}
case L of nil then nil [] H|T then {F H}|{Map T F} end
end
%a
declare Xs Ys Zs
/*{Browse Zs}
thread {Gen 1 100 Xs} end
thread {Filter Xs fun {$ X} (X mod 2)==0 end Ys} end
{Map Ys fun {$ X} X*X end Zs}*/

%b

declare 
fun lazy {Gen I N}
   {Delay 500}
   if I==N then [I]
   else I|{Gen I+1 N} end
end

fun lazy {Filter L F}
   case L of nil then nil
   [] H|T then
      if {F H} then H|{Filter T F} else {Filter T F} end end
end
fun {Map L F}
case L of nil then nil [] H|T then {F H}|{Map T F} end
end

/*declare Xs Ys Zs
{Browse Zs}
{Gen 1 100 Xs}
{Filter Xs fun {$ X} (X mod 2)==0 end Ys}
{Map Ys fun {$ X} X*X end Zs}
*/
%Exo 5
%a

%Complexité Minimum : O(N^2)
%Complexité de Insert :O(N)
  
declare
fun lazy  {Insert X Ys}
   case Ys of nil then [X]
   [] Y|Yr then
      if X < Y then X|Ys
      else {Show 'Passed'}  Y|{Insert X Yr} end
   end
end

fun  lazy {InSort Xs} %% Sorts list Xs
   case Xs of nil then nil
   [] X|Xr then {Insert X {InSort Xr}} end
end

fun {Minimum Xs}
   {InSort Xs}
end

{Browse {Minimum [9 8 7 6 5 4 3 2 1 0]}}
%6 Lazy ne change rien car on va chercher le dernier element de la liste.

%8

declare

fun {Buffer In N}
   End=thread {List.drop In N} end
   fun lazy {Loop In End}
      case In of I|In2 then
	 I|{Loop In2 thread End.2 end}
       
      end
   end
in
{Loop In End} end
fun lazy  {DGenerate N}
   N|{DGenerate N+1}
end

fun {DSum01 ?Xs A Limit}
   {Delay {OS.rand} mod 10}
   if Limit>0 then
      X|Xr=Xs
   in
      {DSum01 Xr A+X Limit-1} else A end
end
fun {DSum02 ?Xs A Limit}
   {Delay {OS.rand} mod 10}
   if Limit>0 then
      X|Xr=Xs
   in
      {DSum02 Xr A+X Limit-1} else A end
end
local Xs Ys V1 V2 in
       thread Xs={DGenerate 1} end % Producer thread
       thread {Buffer  Xs 4 Ys} end % Buffer thread
       thread V1={DSum01 Ys 0 1500} end % Consumer thread
       thread V2={DSum02 Ys 2 1500} end % Consumer thread
       {Browse [Xs Ys V1 V2]}
    end