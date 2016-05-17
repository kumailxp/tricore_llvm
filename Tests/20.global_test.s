	.text
	.file	"20.global_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	st.w [%a14] -4, %d4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.type	z,@object               # @z
	.data
	.globl	z
	.align	3
z:
	.word	1955897805              # 0x3fd8e7494a1cd
	.word	261518
	.word	2                       # 0x2
	.word	0
	.word	3                       # 0x3
	.word	0
	.word	4                       # 0x4
	.word	0
	.word	5                       # 0x5
	.word	0
	.word	6                       # 0x6
	.word	0
	.size	z, 48


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
