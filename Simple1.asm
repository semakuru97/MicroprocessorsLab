#include p18f87k22.inc
	
	code
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	
	goto	start
	; ******* My data and where to put it in RAM *
	constant 	myArray=0x400	; Address in RAM for data
	constant 	counter=0x10	; Address of counter variable
	; ******* Main programme *********************
start 	lfsr	FSR0, 0x002	    ; Load FSR0 with starting address, this works
				    ; Load number incrementing in 0x00 and 0x01
	movlw   0x03  
	movwf   0x00		    ; Starting number 11, this works
loop8bit
	movlw	0x1
	CPFSLT	0x01, 0		    ; If 0x01 less than 1, i.e. number is 8 bits, dont add 4 bits to anything.
	call	addNext4Bit	    ; Subroutine to add the third number to the next FSR location in RAM
	
	incf    0x00, 1 ,ACCESS	    ; Increment count
	call	add8Bit
	
	movlw	0xFF
	CPFSEQ  0x00, 0		    ; If count reaches FF, exit loop 
	bra     loop8bit	 
	
	incf    0x01, 1, ACCESS	    ; Each time 0x00 reaches FF, add 1 to 0x01 which will mean number 0x1FF
	call	addNext4Bit	    ; 
	movlw   0x0		    ; Set 0x00 to 0 so we have 0x100
	movwf   0x00
	call	add8Bit
	bra	loop8bit
	
addNext4Bit
	movff   0x01, TABLAT	    ; Move count to TABLAT
	movff	TABLAT, POSTINC0    ; This takes TABLAT to location at FSR, increasing FSR0 by 1
	return
add8Bit
	movff   0x00, TABLAT	    ; Move count to TABLAT
	movff	TABLAT, POSTINC0    ; This takes TABLAT to location at FSR, increasing FSR0 by 1
	return
	

loop 	tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	

	call subroutine
	decfsz	counter	; count down to zero
	bra	loop		; keep going until finished
	; test comment
	; test branch
	goto	0
	
subroutine  
	movlw .10
	movwf 0x20 ; store 10 in 0x20
subroutine_loop
	call subsubroutine
	decfsz 0x20 ; count down from 10 to 0
	bra subroutine_loop
	return
	; test comment commit
subsubroutine	
	movlw .3
	movwf 0x21 ; store 3 in 0x21	
subsubroutine_loop decfsz 0x21 ; count down from 3 to 0
	bra subsubroutine_loop
	return
	end
