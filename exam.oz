%Question 1
declare
fun lazy {OscillatorGate N}
   if N==0 then
      0|{OscillatorGate 1}
   else 1|{OscillatorGate 0}
   end
end

fun lazy {DelayGate L N}
   case L of Xs|Ys then
      {Delay N}
      Xs|{DelayGate Ys N}
   else nil
   end
end

fun lazy {XORGate L1 L2}
   case L1#L2 of (Xs|Ys)#(Xl|Yl) then
      if (Xs ==0 andthen Xl==0) orelse (Xs==1 andthen Xl==1) then
	 0|{XORGate Ys Yl}
      elseif (Xs==0 andthen Xl==1) orelse (Xs==1 andthen Xl==0) then
	 1|{XORGate Ys Yl}
      end
   else nil
   end
end
fun lazy {MyCircuit}
   local X Y Z in
      X={OscillatorGate 1} 
      Y={DelayGate 0|Z 1000} 
      Z={XORGate X Y} 
      Z
   end
end

%{Browse {MyCircuit}.1}
%{Browse {MyCircuit}.2.1}

% Soit A= 1|0|1|0|1|0|_
% Soit B= 1|C
% Soit C= A Xor B

% C= 1 Xor 1 = 0|_
% C= 0 Xor 0 =0|1|_
% C= 1 Xor 1 =0|1|0|_
%...

%Une suppresion de lazy doit être remplacée par un thread
%Un lazy utilise le mécanisme de waitondemand.

%Question 2

declare

fun {MakeAgent Behaviour Init}
   proc {MsgLoop S1 State}
      case S1 of Msg|S2 then
	 {MsgLoop S2 {Behaviour Msg State}}
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin Init} end
   {NewPort Sin}
end

