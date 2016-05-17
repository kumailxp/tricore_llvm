	.text
	.file	"28.long_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#28, r1
	mov.w	#1, -6(r4)
	mov.w	#1, -8(r4)
	mov.w	#3, -10(r4)
	mov.w	#3, -12(r4)
	mov.w	#2, -14(r4)
	mov.w	#2, -16(r4)
	mov.w	#4, -18(r4)
	mov.w	#4, -20(r4)
	mov.w	#4, r12
	mov.w	-8(r4), r13
	mov.w	-6(r4), r14
	mov.w	#4, r15
	add.w	-12(r4), r15
	addc.w	-10(r4), r12
	addc.w	#2, r13
	addc.w	#2, r14
	mov.w	r14, -22(r4)
	mov.w	r13, -24(r4)
	mov.w	r12, -26(r4)
	mov.w	r15, -28(r4)
	add.w	#28, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
