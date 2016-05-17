	.text
	.file	"19.ternary_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#4, r1
	mov.w	#4, -2(r4)
	mov.w	#3, -4(r4)
	mov.w	#1, r12
	cmp.w	#4, -2(r4)
	jge	.LBB0_2
; BB#1:                                 ; %entry
	mov.w	#0, r12
.LBB0_2:                                ; %entry
	mov.w	r12, -2(r4)
	add.w	#4, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
