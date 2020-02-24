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
		
		;		If a procedure calls another procudure, WE NEED TO SAVE THE 1ST FUNCTIONS LR ONTO THE STACK
		
		;--------------	Program Start ------------------
start
		;		Check that 2x3 = 6
		mov		r0, #2
		mov		r1, #3
		bl		multiply
		cmp		r0, #6
		
		
		;		Check that 2x0 = 0
		mov		r0, #2
		mov		r1, #0
		bl		multiply
		cmp		r0, #0
		
		
		mov		r4, #3					; Putting value in r4 to check it is perserved
		
		;		Check that 2^2 = 4
		mov		r0, #2
		bl		square
		cmp		r0, #4
		cmp		r4, #3
		
		b		done
		
		
		
		
		
		;---------------	Function that squares a number -----------------------------------
		;		int square(int a) { return multiply(a, a); }
square
		
		;		Imagine for some reason this function needed to use r4 during its calculations
		;		r4 is NOT a volatile register, so the value of r4 must be saved somewhere and then restored before the function returns
		
		stmfd	r13!, {r4}				; Store r4 onto the stack
		
		;		NOTE: now r13 is not the same as what it was when the callee called this function!
		;		Need to make sure to pop r13 later!
		
		;		Now we can use r4 for whatever we like (just an example here)
		mov		r4, #9
		
		
		;		Now lets implement the actual function
		;		Remeber, r0-r3 are volatile so we can overwrite them in our function without needing to worry about saving / restoring them
		
		;		When we call a function we use "bl <func>" - this sets the LR equal to the PC, meaning whatever is currently in the LR is lost"
		;		But we need to be able to return from this function, so we need to remember LR as thats what we need to set the PC to return from this function
		
		;		Save the LR onto the stack too
		stmfd	r13!, {LR}
		
		;		OKay now ready to call the other function
		;		r0 contains a already
		;		We also want r1 to contain a (the second parameter of multiply)
		mov		r1, r0
		
		;		Call the function now that our parameters are set up
		bl		multiply
		
		;		Now r0 contains a^2 as desired
		
		;		Before we return we need to clean up after ourselves - otherwise the caller's context will be messed up and their program could break
		;		We have 3 things to clean up:
		;		1 We overwrote r4 which is a NON volatile register
		;		2 We wrote stuff to the stack using "r13!" (note the !) which updated  the stack pointer (R13)
		;		- We have to fix this because the caller might have stored stuff on the stack too
		;		- If the caller tries to pop stuff from the stack and the stack pointer has changed from where it was when the caller called the function
		;		it will get back different values than what it pushed!
		;		3 We called another function which set the link register, so we have to restore that before we can exit
		
		;		Remember stacks are LIFO (last in first out) so things should be popped in reverse order!
		
		;		(3): Reset the LR to what it was when the caller called this function (pop from the stack into the LR)
		ldmfd	r13!, {LR}
		
		;		(1): Reset r4 to what it was (pop from the stack into r4)
		ldmfd	r13!, {r4}
		
		;		(2): Since we used "!" when popping from the stack the stack pointer was updated each time, meaning it's back to what it was!
		;		This means we don't need to do anything else
		
		;		Now we can fianlly return
		mov		pc, lr
		bx lr
		
		;		---------------- End of Square -------------------------
		
		
		
		
		
		;		--------------- Function that multiples two numbers --------------------
		;		This stupid emulator doesn't let you use mul so need to loop
		
		;		int multiply(int x, int y) {
		;		int result = 0;
		;		for (int i=0; i<x; i++) {
		;		result += y;
		;		}
		;		return result;
multiply
		;		r0 contains x, r1 contains y
		mov		r2, r0			; we need a copy of x that we can decrement (i in the C implementation)
		mov		r3, #0		; Store the result in r3 for now
		
		
loop
		cmp		r2, #0			; Check if reached zero
		beq		loop_done		; Exit loop if we have
		add		r3, r3, r1		; Add x to result
		sub		r2, r2, #1		; Decrement copy of x
		b		loop
		
loop_done
		mov		r0, r3				; Put the result into the return register
		mov		pc, lr				; Exit the function
		
		
		;		---------------- End of multiply -------------------------
		
		
done
		
