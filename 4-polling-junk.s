
; Mask for bits 16 to 19: 0x000f000
; Mask for bits 20 to 23: 0x00f00000

		ldr r1, =IOSET1				; the memory address where the value for the pins 

		ldr r7 =0x00f00000		; Bit mask to and with to get push buttons

poll
		ldr r3, [r1]						; get the value from memory
		and r3, r3, r7					; zero out all the non push button bits
		cmp r2, #0						; check if it matches the no button pressed value
		beq sleep						; sleep if no button was pressed

		; at this point something has  been pressed
		; r3 now contains the full 32 bit value of the register
		mov r0, r3						; Set up first parameter
		bl get_button_index



; Chunk of code to sleep
sleep
	ldr r9, =40000000
sleep_loop
	cmp r9, #0
	beq poll
	sub r9, #1
	b sleep_loop



; functions
get_button_index
	// todo.