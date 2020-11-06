.globl main
.data
# Number of rounds, also number of double words in keccakf_rc
rounds:
    .word 2

# Round constants for keccakf
keccakf_rc:
    .word 0x00000001, 0x00000000
    .word 0x00008082, 0x00000000        
    .word 0x0000808a, 0x80000000
    .word 0x80008000, 0x80000000
    .word 0x0000808b, 0x00000000
    .word 0x80000001, 0x00000000
    .word 0x80008081, 0x80000000
    .word 0x00008009, 0x80000000
    .word 0x0000008a, 0x00000000
    .word 0x00000088, 0x00000000
    .word 0x80008009, 0x00000000
    .word 0x8000000a, 0x00000000
    .word 0x8000808b, 0x00000000
    .word 0x0000008b, 0x80000000
    .word 0x00008089, 0x80000000
    .word 0x00008003, 0x80000000
    .word 0x00008002, 0x80000000
    .word 0x00000080, 0x80000000
    .word 0x0000800a, 0x00000000
    .word 0x8000000a, 0x80000000
    .word 0x80008081, 0x80000000
    .word 0x00008080, 0x80000000
    .word 0x80000001, 0x00000000
    .word 0x80008008, 0x80000000
    
.text	
# Rotates a0 left by a1
.macro rotl (%a, %b)
 	sll t0, %a, %b
  	sub t2, zero, %b
  	srl t1, %a, t2
  	or %a, t0, t1
.end_macro

main:
	#la a1, keccakf_rc
	#ld a1, 16(a1)
	
	jal keccak_f
	
	li a0, 0
    li a7, 93
	ebreak
	ecall
	
# Main function, a0 is r, a1 is c
keccak:
	
	jalr, zero, 0(ra)
	
# a0 is address of A
keccak_f:
	addi sp, sp, -24
	sd ra, 0(sp)
	addi t0, zero, 0
	lw t1, rounds
keccak_f_loop:
	sd t0, 8(sp)
	sd t1, 16(sp)
	la a1, keccakf_rc
	addi t3, zero, 4
	mul t3, t3, t0
	add a1, a1, t3
	ld a1, 0(a1)
	# A = Round[b](A, RC[i])
	ld t0, 8(sp)
	ld t1, 16(sp)
	addi t0, t0, 1
	blt t0, t1, keccak_f_loop 
	ld ra, 0(sp)
	addi sp, sp, 24
	jalr, zero, 0(ra)

# a0 is address of A
round:
	# Allocating C
	addi sp, sp, -40
	
	# Theta step
	addi a2, zero, 0
	addi a3, zero, 5
theta_loop:
	
	
	addi a2, a2, 1
	blt a2, a3, theta_loop	
	
	
	# Rho and Pi step
	addi t0, zero, 1
	addi t1, zero, 1
	rotl(t0, t1)
	
	# Chi step
	
	# Iota step
	addi sp, sp, 40
	ret


