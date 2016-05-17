	.text
	.file	"16.incr_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#4, r1
	mov.w	#10, -2(r4)
	mov.w	#4, -4(r4)
	mov.w	-2(r4), r12
	mov.w	r12, r13
	add.w	#4, r13
	mov.w	r13, -2(r4)
	mov.w	r12, r13
	add.w	#5, r13
	mov.w	r13, -2(r4)
	mov.w	r12, r13
	add.w	#6, r13
	mov.w	r13, -2(r4)
	mov.w	r12, r15
	add.w	#7, r15
	mov.w	r15, -2(r4)
	add.w	#8, r12
	mov.w	r12, -2(r4)
	add.w	#4, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
