	.text
	.file	"20.global_test_arm.bc"
	.globl	foo
	.align	4
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	stmg	%r11, %r15, 88(%r15)
	lgr	%r11, %r15
	lmg	%r11, %r15, 88(%r11)
	br	%r14
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.type	v,@object               # @v
	.data
	.globl	v
	.align	4
v:
	.long	10                      # 0xa
	.long	2                       # 0x2
	.long	3                       # 0x3
	.long	4                       # 0x4
	.long	5                       # 0x5
	.long	6                       # 0x6
	.size	v, 24

	.type	w,@object               # @w
	.globl	w
	.align	2
w:
	.short	10                      # 0xa
	.short	2                       # 0x2
	.short	3                       # 0x3
	.short	4                       # 0x4
	.short	5                       # 0x5
	.short	6                       # 0x6
	.size	w, 12

	.type	z,@object               # @z
	.globl	z
	.align	8
z:
	.quad	1123213213213133        # 0x3fd8e7494a1cd
	.quad	2                       # 0x2
	.quad	3                       # 0x3
	.quad	4                       # 0x4
	.quad	5                       # 0x5
	.quad	6                       # 0x6
	.size	z, 48


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
