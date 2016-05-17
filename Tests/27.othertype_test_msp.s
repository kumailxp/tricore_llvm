	.text
	.file	"27.othertype_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#6, r1
	mov.b	#120, -1(r4)
	mov.w	#11, -4(r4)
	mov.b	-4(r4), r12
	sxt	r12
	mov.b	-1(r4), r13
	add.w	r12, r13
	mov.w	r13, -6(r4)
	add.w	#6, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
