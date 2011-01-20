%%%%%% Active objects
declare
fun {NewActive Class Init}      
   Obj={New Class Init}    
   P
in
   thread S in
      {NewPort S P}
      {ForAll S proc {$ M} {Obj M} end}
   end
   proc {$ M} {Send P M} end
end


%%%%%% Priority queue
declare
fun {NewPrioQueue}
   Q={NewCell nil}
   proc {Enqueue X Prio}
      fun {InsertLoop L}
         case L of pair(Y P)|L2 then
            if Prio<P then pair(X Prio)|L
            else pair(Y P)|{InsertLoop L2} end
         [] nil then [pair(X Prio)] end
      end
   in Q:={InsertLoop @Q} end

   fun {Dequeue}
      pair(Y _)|L2=@Q
   in
      Q:=L2 Y
   end

   fun {Delete Prio}
      fun {DeleteLoop L}
         case L of pair(Y P)|L2 then
            if P==Prio then X=Y L2
            else pair(Y P)|{DeleteLoop L2} end
         [] nil then nil end
      end X
   in Q:={DeleteLoop @Q} X end

   fun {IsEmpty} @Q==nil end
in
   queue(enqueue:Enqueue dequeue:Dequeue
         delete:Delete isEmpty:IsEmpty)
end

%%%%%% Transaction manager
declare
class TMClass
   attr timestamp tm
   meth init(TM) timestamp:=0 tm:=TM end
    
   meth Unlockall(T RestoreFlag)
      for save(cell:C state:S) in {Dictionary.items T.save} do
         (C.owner):=unit
         if RestoreFlag then (C.state):=S end
         if {Not {C.queue.isEmpty}} then
         Sync2#T2={C.queue.dequeue} in
            (T2.state):=running
            (C.owner):=T2 Sync2=ok
         end
      end
   end
  
  meth Trans(P ?R TS)
     Halt={NewName}
     T=trans(stamp:TS save:{NewDictionary} body:P
             state:{NewCell running} result:R)
     proc {ExcT C X Y} S1 S2 in
        {@tm getlock(T C S1)}
        if S1==halt then raise Halt end end
        {@tm savestate(T C S2)} {Wait S2}
        {Exchange C.state X Y}
     end
     proc {AccT C ?X} {ExcT C X X} end
     proc {AssT C X} {ExcT C _ X} end
     proc {AboT} {@tm abort(T)} R=abort raise Halt end end
  in
     thread try Res={T.body t(access:AccT assign:AssT
                              exchange:ExcT abort:AboT)}
            in {@tm commit(T)} R=commit(Res)
            catch E then
               if E\=Halt then {@tm abort(T)} R=abort(E) end
     end end
  end
  
  meth getlock(T C ?Sync)
     if @(T.state)==probation then
        {self Unlockall(T true)}
        {self Trans(T.body T.result T.stamp)} Sync=halt
     elseif @(C.owner)==unit then 
        (C.owner):=T Sync=ok
     elseif T.stamp==@(C.owner).stamp then
        Sync=ok
     else /* T.stamp\=@(C.owner).stamp */ T2=@(C.owner) in
        {C.queue.enqueue Sync#T T.stamp}
        (T.state):=waiting_on(C)
        if T.stamp<T2.stamp then
           case @(T2.state) of waiting_on(C2) then
           Sync2#_={C2.queue.delete T2.stamp} in
              {self Unlockall(T2 true)}
              {self Trans(T2.body T2.result T2.stamp)}
              Sync2=halt
           [] running then
              (T2.state):=probation
           [] probation then skip end
        end
     end
  end 

   meth newtrans(P ?R)
      timestamp:=@timestamp+1 {self Trans(P R @timestamp)}
   end
   meth savestate(T C ?Sync)
      if {Not {Dictionary.member T.save C.name}} then
         (T.save).(C.name):=save(cell:C state:@(C.state))
      end Sync=ok
   end
   meth commit(T) {self Unlockall(T false)} end
   meth abort(T) {self Unlockall(T true)} end
end

proc {NewTrans ?Trans ?NewCellT}
TM={NewActive TMClass init(TM)} in
   fun {Trans P ?B} R in
      {TM newtrans(P R)}
      case R of abort then B=abort unit
      [] abort(Exc) then B=abort raise Exc end
      [] commit(Res) then B=commit Res end
   end
   fun {NewCellT X}
      cell(name:{NewName} owner:{NewCell unit}
           queue:{NewPrioQueue} state:{NewCell X})
   end
end
