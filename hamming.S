		;		ARM Programming Assignment #4: Encode in Hamming(15, 11)
		;
		;		Write a subroutine that encodes 11 bits of data into a 15-bit
		;       block, using 4 parity bits. Assume even parity, that is,
		;       the parity of the bits covered by a parity bit, including
		;       the parity bit, has to be an even number. Assume the bits are
		;       written in the following sequence: p1, p2, d1, p4, d2, d3, d4,
		;       p8, d5, d6, d7, d8, d9, d10, d11, p16, d12, d13, d14, d15.
		;       Call the subroutine `hencode`.
		;
		;       Write a subroutine that decodes a H(15, 11) block to extract
		;       the 11 data bits. Call it `hdecode`. It should:
		;       - calculate the correcting code
		;       - dentify the case: no error (noer), one-bit error (onee)
		;       - write the result in `case` using the encoding provided
		;       - if there is a one-bit error, write the number of the
		;         erroneous bit in `berr`
		;       - if there is a one-bit error, correct the data
		;       - write the result in `corr`
		;
		;       Now, write a main function which uses `hencode` and `decode`
		;       to encode `data` and then, after a simulated transmission,
		;       decode `recv`. Assume that `recv` contains what is received
		;       at the other end.

		;		Your code here
		
		adr		r0, data
		adr		r11,p1
		adr		r10,p2
		adr		r9,p4
		adr		r8,p8
		ldr		r11,[r11]
		ldr		r10,[r10]
		ldr		r9,[r9]
		ldr		r8,[r8]
		ldr		r1,[r0]
		
hencode	;extends data to 15 bits making room for parity bits(=0 currently)
		
		mov		r2,r1,lsr #4	    ;splits bits up to parity bit
		lsl		r2,r2,#8            ;shifts for 15 total bits
		and		r3,r1,#4            ;
		add		r2,r2,r3, lsl #3    ;adds r2 to r3 shifted to copy bits in respective places
		and		r3,r1,#1            ;copy first bit
		add		r2,r2,r3, lsl #2    ;copies first bit to respective place
		mov		r12,r2		    ;saves non-adjusted 15 bit value(parity bits=0)
		bl		parity              ;adjusts parity bits
		
		end
		
		
parity	;adds 1 to to respective parity bits depending on respective data bits
		lsrs		r2,r2,#3			;positon 3
		eorcs	r4,r4,#1			;p1
		eorcs	r5,r5,#1			;p2
		
		lsrs		r2,r2,#2			;pos 5
		eorcs	r4,r4,#1
		addcs	r6,r6,#1			;P4
		
		lsrs		r2,r2,#1			;pos 6
		eorcs	r5,r5,#1			;p2
		eorcs	r6,r6,#1			;p4
		
		lsrs		r2,r2,#1			;pos 7
		eorcs	r4,r4,#1			;p1
		eorcs	r5,r5,#1			;p2
		eorcs	r6,r6,#1			;p4
		
		lsrs		r2,r2,#2			;pos 9
		eorcs	r4,r4,#1			;p1
		eorcs	r7,r7,#1			;p8
		
		lsrs		r2,r2,#1			;pos 10
		eorcs	r5,r5,#1			;p2
		eorcs	r7,r7,#1			;p8
		
		lsrs		r2,r2,#1			;pos 11
		eorcs	r4,r4,#1			;p1
		eorcs	r5,r5,#1			;P2
		eorcs	r7,r7,#1			;P8
		
		lsrs		r2,r2,#1			;pos 12
		eorcs	r6,r6,#1			;p4
		eorcs	r7,r7,#1			;p8
		
		lsrs		r2,r2,#1			;pos 13
		eorcs	r4,r4,#1			;p1
		eorcs	r6,r6,#1			;p4
		eorcs	r7,r7,#1			;p8
		
		lsrs		r2,r2,#1			;pos 14
		eorcs	r5,r5,#1			;p2
		eorcs	r6,r6,#1			;p4
		eorcs	r7,r7,#1			;p8
		
		lsrs		r2,r2,#1			;pos 15
		eorcs	r4,r4,#1			;p1
		eorcs	r5,r5,#1			;p2
		eorcs	r6,r6,#1			;p4
		eorcs	r7,r7,#1			;p8
		
		;adjusts	parity bits
		cmp		r4,#1 			;p1
		orreq	r12,r12,r11
		
		cmp		r5,#1					;p2
		orreq	r12,r12,r10
		
		cmp		r6,#1					;p4
		orreq	r12,r12,r9
		
		cmp		r7,#1					;p8
		orreq	r12,r12,r8
		
		
		mov		pc,lr
		

data	DCD	0b10100100101
recv    DCD     0b101111010100101

p1		dcd		0b000000000000001
p2		dcd		0b000000000000010
p4		dcd		0b000000000001000
p8		dcd		0b000000010000000

noer    DCD     0x00
onee    DCD     0x01

case    FILL    4
berr    FILL    4
corr    FILL    4
