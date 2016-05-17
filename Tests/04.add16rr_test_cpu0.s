	.text
	.section .mdebug.abiO32
	.previous
	.file	"04.add16rr_test.bc"
	.globl	main
	.align	2
	.type	main,@function
	.ent	main                    # @main
main:
	.frame	$fp,16,$lr
	.mask 	0x00000000,0
	.set	noreorder
	.set	nomacro
# BB#0:                                 # %entry
	addiu	$sp, $sp, -16
	addiu	$2, $zero, 0
	st	$2, 12($sp)
	addiu	$2, $zero, 2
	st	$2, 8($sp)
	addiu	$2, $zero, 4
	st	$2, 4($sp)
	ld	$2, 8($sp)
	addiu	$2, $2, 4
	st	$2, 8($sp)
	addiu	$sp, $sp, 16
	ret	$lr
	.set	macro
	.set	reorder
	.end	main
$func_end0:
	.size	main, ($func_end0)-main


