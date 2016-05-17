	.text
	.file	"29.long_cmp_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	push.w	r11
	push.w	r10
	sub.w	#24, r1
	mov.w	#0, -6(r4)
	mov.w	#0, -8(r4)
	mov.w	#0, -10(r4)
	mov.w	#1, -12(r4)
	mov.w	#0, -14(r4)
	mov.w	#0, -16(r4)
	mov.w	#0, -18(r4)
	mov.w	#2, -20(r4)
	mov.w	-10(r4), r12
	cmp.w	#0, r12
	mov.w	r2, r14
	mov.w	#1, r12
	cmp.w	#2, -12(r4)
	jeq	.LBB0_2
; BB#1:                                 ; %entry
	rra.w	r14
	mov.w	#1, r13
	bic.w	r14, r13
	jmp	.LBB0_3
.LBB0_2:
	mov.w	r2, r13
	and.w	#1, r13
.LBB0_3:                                ; %entry
	mov.w	-6(r4), r14
	cmp.w	#1, r14
	mov.w	#1, r11
	jge	.LBB0_5
; BB#4:                                 ; %entry
	mov.w	#0, r11
.LBB0_5:                                ; %entry
	mov.w	-8(r4), r15
	cmp.w	#0, r15
	mov.w	r2, r10
	cmp.w	#0, r14
	jeq	.LBB0_7
; BB#6:                                 ; %entry
	mov.w	r11, r12
	jmp	.LBB0_8
.LBB0_7:
	rra.w	r10
	bic.w	r10, r12
.LBB0_8:                                ; %entry
	bis.w	r14, r15
	cmp.w	#0, r15
	jeq	.LBB0_10
; BB#9:                                 ; %entry
	mov.w	r12, r13
.LBB0_10:                               ; %entry
	bit.w	#1, r13
	jne	.LBB0_12
; BB#11:                                ; %if.then
	mov.w	#9, -22(r4)
.LBB0_12:                               ; %if.end
	add.w	#24, r1
	pop.w	r10
	pop.w	r11
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
