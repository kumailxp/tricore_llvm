	.text
	.file	"20.global_test_leg.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	sub sp, sp, #4
	movw r0, #0
	str r0, [sp]
	movw r0, a
	movt r0, a
	ldr r1, [r0]
	str r1, [sp]
	movw r1, #54
	str r1, [r0]
	add sp, sp, #4
	bx lr
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.type	a,@object               # @a
	.data
	.globl	a
	.align	4
a:
	.long	24                      # 0x18
	.size	a, 4


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
