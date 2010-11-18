declare 
proc {Ping L}
   case L of H|T then T2 in
      {Delay 500}{Browse 'Ping'}
      T=_|T2
      {Ping T2}
   end
end

proc {Pong L}
   case L of H|T then T2 in T=_|T2
      {Browse 'Pong'}
      {Pong T2}
   end
end

declare L in
thread {Ping L} end
thread {Pong L.2} end
L=_|_