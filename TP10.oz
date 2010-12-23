
declare
proc {NewPortObject Init Fun ?P}
   proc {MsgLoop S1 State}
      
      case S1 of Msg|S2 then
	 {MsgLoop S2 {Fun Msg State}}
      [] nil then skip end
   end
   Sin
in
   thread {MsgLoop Sin Init} end
   {NewPort Sin P}
end
proc {NewPortObject2 Proc ?P}
   Sin in
   thread for Msg in Sin do {Proc Msg} end end
   {NewPort Sin P}
end
proc {Controller ?Cid}
   {NewPortObject2
    proc {$ Msg}
       case Msg
       of step(Lid Pos Dest) then
	  if Pos<Dest then
	     {Delay 1000} {Send Lid 'at'(Pos+1)}
	  elseif Pos>Dest then
	     {Delay 1000} {Send Lid 'at'(Pos-1)}
	  end
       end
    end Cid}
end
proc {Floor Num Init Lifts ?Fid}
   {NewPortObject Init
    fun {$ Msg state(Called)}
       case Msg
       of call then
	  {Browse 'Floor '#Num#' calls a lift!'}
	  if {Not Called} then Lran in
	     Lran=Lifts.(1+{OS.rand} mod {Width Lifts})
	     {Send Lran call(Num)}
	  end
	  state(true)
       [] arrive(Ack) then
	  {Browse 'Lift at floor '#Num#': open doors'}
	  {Delay 2000}
	  {Browse 'Lift at floor '#Num#': close doors'}
	  Ack=unit
	  state(false)
       end
    end Fid}
end
proc {Lift Num Init Cid Floors ?Lid}
   {NewPortObject Init
    fun {$ Msg state(Pos Sched Moving)}
       case Msg
       of call(N) then
	  {Browse 'Lift '#Num#' needed at floor '#N}
	  if N==Pos andthen {Not Moving} then
	     {Wait {Send Floors.Pos arrive($)}}
	     state(Pos Sched false)
	  else Sched2 in
	     Sched2={Append Sched [N]}
	     if {Not Moving} then
		{Send Cid step(Lid Pos Sched2.1)} end
	     state(Pos Sched2 true)
	  end
       [] 'at'(NewPos) then
	  {Browse 'Lift '#Num#' at floor '#NewPos}
	  case Sched
	  of nil then
	     state(NewPos Sched Moving)
	  [] S|Sched2 then
	     if NewPos==S then
		{Wait {Send Floors.S arrive($)}}
		if Sched2==nil then
		   state(NewPos nil false)
		else
		   {Send Cid step(Lid NewPos Sched2.1)}
		   state(NewPos Sched2 true)
		end
	     else
		{Send Cid step(Lid NewPos S)}
		state(NewPos Sched true)
	     end
	  end
       end
    end Lid}
end
proc {Building FN LN ?Floors ?Lifts}
   Lifts={MakeTuple lifts LN}
   for I in 1..LN do C in
      {Controller C}
      Lifts.I={Lift I state(1 nil false) C Floors}
   end
   Floors={MakeTuple floors FN}
   for I in 1..FN do
      Floors.I={Floor I state(false) Lifts}
   end
end
local X Y in
   {Building 20 2 X Y}
   for I in 1..20 do
      {Send X.I call}

   end
end


%question 6
%When a new call is triggered, add the new Floor to the Scheduller.
