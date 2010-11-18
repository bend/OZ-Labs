declare
 fun {Buffer In N}
    End=thread {List.drop In N} end
    fun lazy {Loop In End}
       case In of I|In2 then
	  I|{Loop In2 thread End.2 end}
       end
    end
 in
    {Loop In End}
 end
declare
fun lazy {DGenerate N}
      N|{DGenerate N+1}
end
fun {DSum01 ?Xs A Limit}
   if Limit>0 then
      {Delay {OS.rand} mod 10}
      {DSum01 Xs.2 A+Xs.1 Limit-1}
   else A end
end
fun {DSum02 ?Xs A Limit}
   {Delay {OS.rand} mod 10}
   if Limit>0 then
      X|Xr=Xs
   in
      {DSum02 Xr A+X Limit-1}
   else A end
end
local Xs Ys V1 V2 in
    {DGenerate 1 Xs} % Producer thread
    {Buffer Xs 4 Ys}  % Buffer thread
   thread V1={DSum01 Ys 0 100} end % Consumer thread
  % thread V2={DSum02 Ys 2 100} end % Consumer thread
   {Browse Xs}
   {Browse Ys}
   {Browse V1} {Browse V2}
end
local N in
   {Browse {List.drop [1 2 3 4 5 6] N}}
   {Browse N}
end

{Browse {List.drop [1 2 3 4] 2}}