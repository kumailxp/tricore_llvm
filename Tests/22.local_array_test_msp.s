	.text
	.file	"22.local_array_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	sub.w	#6, r1
	mov.w	&.Lfoo.a+2, -2(r4)
	mov.w	&.Lfoo.a, -4(r4)
	mov.w	-2(r4), -6(r4)
	add.w	#6, r1
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.type	.Lfoo.a,@object         ; @foo.a
	.section	.rodata.cst4,"aM",@progbits,4
	.align	1
.Lfoo.a:
	.short	45                      ; 0x2d
	.short	56                      ; 0x38
	.size	.Lfoo.a, 4


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
