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
myTable data	"This is just some data"
	constant 	myArray=0x400	; Address in RAM for data
	constant 	counter=0x10	; Address of counter variable
	; ******* Main programme *********************
start 	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.22		; 22 bytes to read
	movwf 	counter		; our counter register
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
	
subsubroutine	
	movlw .3
	movwf 0x21 ; store 3 in 0x21	
subsubroutine_loop decfsz 0x21 ; count down from 3 to 0
	bra subsubroutine_loop
	return
	end
