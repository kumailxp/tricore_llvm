	.text
	.file	"30.float_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#12, r1
	mov.w	#16257, -2(r4)
	mov.w	#9961, -4(r4)
	mov.w	#16390, -6(r4)
	mov.w	#26214, -8(r4)
	mov.w	-4(r4), r14
	mov.w	-2(r4), r15
	mov.w	#26214, r12
	mov.w	#16390, r13
	_call	#__addsf3
	mov.w	r15, -10(r4)
	mov.w	r14, -12(r4)
	add.w	#12, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
