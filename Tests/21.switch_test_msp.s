	.text
	.file	"21.switch_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#6, r1
	mov.w	r15, -2(r4)
	mov.w	#0, -4(r4)
	mov.w	#0, -6(r4)
	mov.w	-2(r4), r12
	cmp.w	#23, r12
	jne	.LBB0_2
; BB#1:                                 ; %sw.bb.1
	add.w	#2, -2(r4)
	jmp	.LBB0_4
.LBB0_2:                                ; %entry
	cmp.w	#10, r12
	jne	.LBB0_4
; BB#3:                                 ; %sw.bb
	mov.w	#34, -4(r4)
	jmp	.LBB0_5
.LBB0_4:                                ; %sw.default
	mov.w	#100, -4(r4)
.LBB0_5:                                ; %sw.epilog
	add.w	#6, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
