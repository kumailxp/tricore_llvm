	.text
	.file	"11.if_cond_test_leg.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	sub sp, sp, #12
	movw r0, #23
	str r0, [sp, #4]
	movw r0, #21
	str r0, [sp]
	ldr r1, [sp, #4]
	cmp r1, r0
	blt .LBB0_2
# BB#1:                                 # %if.then
	movw r0, #45
	b .LBB0_3
.LBB0_2:                                # %if.else
	movw r0, #30
.LBB0_3:                                # %return
	str r0, [sp, #8]
	ldr r0, [sp, #8]
	add sp, sp, #12
	bx lr
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
