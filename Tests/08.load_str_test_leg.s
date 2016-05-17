	.text
	.file	"08.load_str_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	sub sp, sp, #8
	movw r0, #9
	str r0, [sp, #4]
	movw r0, #0
	str r0, [sp]
	ldr r0, [sp, #4]
	add r0, r0, #9
	str r0, [sp]
	add sp, sp, #8
	bx lr
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
