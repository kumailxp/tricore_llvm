	.text
	.file	"28.long_test_systemz.bc"
	.globl	foo
	.align	4
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	stmg	%r11, %r15, 88(%r15)
	aghi	%r15, -168
	lgr	%r11, %r15
	llihf	%r0, 131074
	oilf	%r0, 131074
	stg	%r0, 160(%r11)
	lmg	%r11, %r15, 256(%r11)
	br	%r14
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
