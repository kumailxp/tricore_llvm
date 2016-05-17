	.text
	.file	"11.if_cond_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#6, r1
	mov.w	r15, -4(r4)
	mov.w	#3, -6(r4)
	cmp.w	#6, -4(r4)
	jge	.LBB0_2
; BB#1:                                 ; %if.then
	mov.w	#45, -2(r4)
	jmp	.LBB0_3
.LBB0_2:                                ; %if.else
	mov.w	#30, -2(r4)
.LBB0_3:                                ; %return
	mov.w	-2(r4), r15
	add.w	#6, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
