	.text
	.file	"14.pointer_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#4, r1
	mov.w	#15, -4(r4)
	mov.w	r4, r12
	sub.w	#4, r12
	mov.w	r12, -2(r4)
	add.w	#4, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
