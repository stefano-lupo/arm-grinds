		;		Pre-reqs
		;		---------------------
		;		32 bit Instruction layouts
		;		Program counter
		;		Stacks: (stack overflows, memory layout (stack vs heap))
		
		
		
		;		Procedure contracts:
		;		NOTE: These are implemented at the assembly level --> Hardware doesn't help us!
		;		Well behaved: Abides by agreed upon procedure convetion
		;		- From the caller's point of view, the only thing that should change are the volatile registers
		;
		;		r0: the return register (Can use r0 | r1 if need to return 64  bit)
		;		r1-r3 are volatile registers (callee may use overwrite these when implementing the desired function)
		;		r4 - r11 are callee-save (non volatile): these MUST be perserved
		;		r12 - r15 are reserved registgers and must be used correctly to implement the actual function calling
		
		;		Sub procedures calling another sub procedure
		;		- Must save all volatile registers and the caller's LR before calling the sub routine!
		
		;		Instructions
		;		- bl: "branch and link" (set LR to next PC)
		
		;--------------	Program Start ------------------
start
		;		random insturctions
		mov		r0, #5
		add		r1, r0, r0
		
		;		Okay lets call a function
		bl		return99
		
		;		Great, now r0 contains the result (99)
		
		;		Lets call the other function and pass a parameter
		bl		add10
		
		;		Now r0 contains 99 + 10 = 109
		
		b		done
		
		;--------------- Define functions here -----------------------------------		

		;		Simple function that returns 99
return99
		mov		r0, #99
		mov		pc, lr					; I thinkt his can be done with bx lr in real ARM
		
		
		;		Adds 10 to passed parameter
		;		int add10(int x) { return x + 10; }
add10
		add		r0, r0, #10
		mov		pc, lr
		
		
		
		
done
		
