
declare

proc {Buffer N Xs Ys}
   fun {Startup N ?Xs}
      if N==0 then Xs
      else Xr in Xs=_|Xr Xs|{Startup N-1 Xr} end
   end

   proc {AskLoop Ys ?Xs ?End}
      case Ys of Y|Yr then Xr End2 in
	 Xs=Y|Yr
	 End = _|End2
	 {AskLoop Yr Xr End2}
      end
   end

   End = {Startup N Xs}
in
   {AskLoop Ys Xs End}
end

proc {DGenerate N Xs}
   case Xs of X|Xr then
      X=N
      {Delay 500}{DGenerate N+1 Xr}
   end
end

fun {DSum ?Xs A Limit}
   if Limit>0 then
      X|Xr=Xs
   in
      {Delay 1200}A+X|{DSum Xr A+X Limit-1}
   else A end
end

% local Xs Ys S in
%    thread {DGenerate 0 Xs} end
%    thread {Buffer 4 Xs Ys} end
%    thread S={DSum Ys 0 10} end
% {Browse Xs}{Browse Ys}{Browse S}
%   end
proc lazy {Bar Xs}
   case Xs of H|T then
      H='Beer'
      {Delay 1}{Bar T}
   end
end


fun  {Foo ?Xs Limit}
   if Limit>0 then
      _|Xr=Xs in
      {Delay 1200} 'Burp'|{Foo Xr Limit-1}
   else nil
   end
end

local Xs Ys S in
   thread {Bar Xs} end
   thread {Buffer 4 Xs Ys} end
   thread S={Foo Ys 10} end
{Browse Xs}{Browse Ys}{Browse S}
end
