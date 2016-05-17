	.text
	.file	"25.shift_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#4, r1
	mov.w	#8, -2(r4)
	mov.w	#3, -4(r4)
	mov.b	-4(r4), r13
	mov.w	-2(r4), r12
	cmp.b	#0, r13
	mov.w	r12, r14
	jeq	.LBB0_3
; BB#1:
	mov.w	r12, r14
.LBB0_2:                                ; %entry
                                        ; =>This Inner Loop Header: Depth=1
	rla.w	r14
	sub.b	#1, r13
	jne	.LBB0_2
.LBB0_3:                                ; %entry
	add.w	r14, r12
	mov.w	r12, -2(r4)
	add.w	#4, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
