declare
% Exo 1
% If there are concurrent access, the change can lead to a invalid value. We can fix this by adding locks between @P = ... and P:=... or using the {Exchange C Old New } function

% Exo 2

%local X in X = C := X+1 end
% this does not work because X is waiting for an unbound variable.
% we can fix this by doing this as 2 separate operations, this will not be atomic.
% Her's the version without a lock
local X C in
   C = {NewCell 0}
   X=@C
   C:=X+1
end

%version with a lock
local Old New C in 
   C= {NewCell 0}
   {Exchange C Old New}
   New = Old+1
end

%Exo 3
declare
class BankAccount
   attr balance
   meth init()
      @balance={NewCell 0}
      {Browse init_ok}
   end

   meth deposit(Amount)
      Old New in
      {Exchange @balance Old New}
      New = Old + Amount
      {Browse deposit#Amount}
   end

   meth withdraw(Amount)
      Old New in
      {Exchange @balance Old New}
      New = Old - Amount
      {Browse withdraw#Amount}
   end

   meth getBalance($)
      @@balance
   end

end

%Exo 4

proc {TransfertAccount From To Amount}
   Lock in Lock = {NewLock}
   lock Lock then
      if {From getBalance($)} >0 andthen {From getBalance($)}>= Amount then
	 {From withdraw(Amount)}
	 {To deposit(Amount)}
      else {Browse balance_to_low} end
   end
end

declare A1 A2 A3 A4 A
A1={New BankAccount init }
A2={New BankAccount init }
A3={New BankAccount init }
A4={New BankAccount init }
{A1 deposit(10000)}
{A2 deposit(10000)}
{A3 deposit(10000)}
{A4 deposit(10000)}


thread {Delay 100}{TransfertAccount A1 A2 1000}end% A1 = 9000 A2 = 11000
thread {Delay 300}{TransfertAccount A1 A3 1000}end% A1 = 8000 A3 = 11000 
thread{Delay 320}{TransfertAccount A2 A3 1000}end% A2 = 10000 A3 = 12000
thread{Delay 230}{TransfertAccount A3 A4 1000}end% A1 = 8000 A2= 1000A3 = 11000 A4= 11000
{Delay 1000}
{Browse {A1 getBalance($)}}
{Browse {A2 getBalance($)}}
{Browse {A3 getBalance($)}}
{Browse {A4 getBalance($)}}

