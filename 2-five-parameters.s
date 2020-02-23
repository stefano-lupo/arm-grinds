			;		Procedure contracts:
			;		NOTE: These are implemented at the assembly level --> Hardware doesn't help us!
			;		Well behaved: Abides by agreed upon procedure convetion
			;		- From the caller's point of view, the only thing that should change are the volatile registers
			;
			;		r0: the return register (Can use r0 | r1 if need to return 64  bit)
			;		r1-r3 are volatile registers (callee may use overwrite these when implementing the desired function)
			;		r4 - r11 are callee-save (non volatile): these MUST be perserved
			;		r12 - r15 are reserved registgers and must be used correctly to implement the actual function calling
			
			;		The ARM calling convetion only allows 4 parameters to be passed via registers
			;		If we want to pass more than 4, the rest of the parameters are passed via the stack
			
			;--------------	Program Start ------------------
start
			;		Set up our parameters
			mov		r0, #1
			mov		r1, #2
			mov		r2, #3
			mov		r3, #4
			
			
			;		The 5th parameter must be passed via the stack
			mov		r10, #5						; Note this r10 is NOT passed to the function! Just storing 5 in r10 for the next line
			stmfd	r13!, {r10}					; Push 5 onto the stack - use full descending stack and ! to make sure the SP (R13) is updated
			
			;		Lets calculate what we expect the result to be and store it in r9
			add		r9, r0, r1
			add		r9, r9, r2
			add		r9, r9, r3
			add		r9, r9, r10
			
			;		Call our function now that the 5 parameters are set up
			bl		add5Numbers
			
			;		Check if their the same (Z (zero bit) should be set)
			cmp		r0, r9
			
			b		done
			
			;---------------	Define functions here -----------------------------------
			
			;		Function that adds 5 numbers together
			;		int add5Numbers(int a, int b, int c, int d, int e) { return a + b + c +d + e; }
add5Numbers
			add		r0, r0, r1				; res = a + b
			add		r0, r0, r2				; res = res + c
			add		r0, r0, r3				; res = res + d
			
			ldmia	r13!, {r2}
			add		r0, r0, r2
			
			mov		pc, lr					; I thinkt his can be done with bx lr in real ARM	
			
done
			
