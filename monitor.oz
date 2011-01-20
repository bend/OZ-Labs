%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

declare
fun {NewQueue}
   X in
   q(0 X X)
end   

fun {Insert q(N S E) X}
   E1 in
   E=X|E1 q(N+1 S E1)
end

fun {Delete q(N S E) X}
   S1 in
   S=X|S1 q(N-1 S1 E)
end

fun {DeleteNonBlock q(N S E) X}
   if N>0 then H S1 in
      X=[H] S=H|S1 q(N-1 S1 E)
   else
      X=nil q(N S E)
   end
end

fun {DeleteAll q(_ S E) L}
   X in
   L=S E=nil
   q(0 X X)
end

fun {Size q(N _ _)} N end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Includes bug fix (see Errata page)

declare
proc {NewMonitor ?LockM ?WaitM ?NotifyM ?NotifyAllM}
   Q={NewCell {NewQueue}}
   Token1={NewCell unit}
   Token2={NewCell unit}
   CurThr={NewCell unit}

   % Returns true if got the lock, false if not (already inside)
   fun {GetLock}
      if {Thread.this}\=@CurThr then Old New in
	 {Exchange Token1 Old New}
	 {Wait Old}
	 Token2:=New
	 CurThr:={Thread.this}
	 true
      else false end
   end
   
   proc {ReleaseLock}
      CurThr:=unit
      unit=@Token2
   end
in
   proc {LockM P}
      if {GetLock} then
	 try {P} finally {ReleaseLock} end
      else {P} end
   end
   
   proc {WaitM}
   X in
      Q:={Insert @Q X}
      {ReleaseLock} {Wait X}
      if {GetLock} then skip end
   end
   
   proc {NotifyM}
   X in
      Q:={DeleteNonBlock @Q X}
      case X of [U] then U=unit else skip end
   end
   
   proc {NotifyAllM}
   L in
      Q:={DeleteAll @Q L}
      {ForAll L proc {$ X} X=unit end}
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
