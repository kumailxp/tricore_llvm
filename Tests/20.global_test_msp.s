	.text
	.file	"20.global_test_msp.bc"
	.globl	foo
	.align	2
	.type	foo,@function
foo:                                    ; @foo
; BB#0:                                 ; %entry
	push.w	r4
	mov.w	r1, r4
	pop.w	r4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.type	v,@object               ; @v
	.data
	.globl	v
	.align	1
v:
	.short	10                      ; 0xa
	.short	2                       ; 0x2
	.short	3                       ; 0x3
	.short	4                       ; 0x4
	.short	5                       ; 0x5
	.short	6                       ; 0x6
	.size	v, 12

	.type	w,@object               ; @w
	.globl	w
	.align	1
w:
	.short	10                      ; 0xa
	.short	2                       ; 0x2
	.short	3                       ; 0x3
	.short	4                       ; 0x4
	.short	5                       ; 0x5
	.short	6                       ; 0x6
	.size	w, 12

	.type	z,@object               ; @z
	.globl	z
	.align	3
z:
	.quad	1123213213213133        ; 0x3fd8e7494a1cd
	.quad	2                       ; 0x2
	.quad	3                       ; 0x3
	.quad	4                       ; 0x4
	.quad	5                       ; 0x5
	.quad	6                       ; 0x6
	.size	z, 48


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
