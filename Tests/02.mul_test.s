	.text
	.file	"02.mul_test.bc"
	.globl	f
	.type	f,@function
f:                                      # @f
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 16
	st.w [%a14] -4, %d4
	mov %d15, 4
	st.w [%a14] -8, %d15
	mov %d15, 9
	st.w [%a14] -12, %d15
	ld.w %d15, [%a14] -8
	movh %d2, 34953
	addi %d2, %d2, -30583
	mov %d3, -1
	mul %e2, %e2, %d15
	add %d15, %d3
	sha %d3, %d15, -3
	sh %d2, %d15, -31
	add %d2, %d3
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
