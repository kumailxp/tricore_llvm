	.text
	.file	"26.logical_assign_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#6, r1
	mov.b	#0, r12
	mov.w	#0, -2(r4)
	mov.w	#3, -4(r4)
	mov.w	#3, -6(r4)
	cmp.w	#0, -4(r4)
	jeq	.LBB0_2
; BB#1:                                 ; %land.rhs
	cmp.w	#0, -6(r4)
	mov.w	r2, r13
	rra.w	r13
	mov.w	#1, r12
	bic.w	r13, r12
.LBB0_2:                                ; %land.end
	mov.w	r12, -2(r4)
	add.w	#6, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
