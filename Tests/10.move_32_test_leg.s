	.text
	.file	"10.move_32_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	sub sp, sp, #4
	movw r0, #0
	movt r0, #1
	str r0, [sp]
	add sp, sp, #4
	bx lr
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
