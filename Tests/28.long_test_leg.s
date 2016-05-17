	.text
	.file	"28.long_test_leg.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	sub sp, sp, #8
	ldr r0, [sp]
	movw r1, #1
	movt r1, #4096
	add r0, r0, r1
	str r0, [sp, #4]
	add sp, sp, #8
	bx lr
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
