	.text
	.file	"21.switch_test_leg.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	sub sp, sp, #12
	str r0, [sp, #8]
	movw r0, #0
	str r0, [sp, #4]
	str r0, [sp]
	ldr r0, [sp, #8]
	movw r1, #20
	cmp r0, r1
	beq .LBB0_3
	b .LBB0_1
.LBB0_3:                                # %sw.bb.1
	movw r0, #34
	str r0, [sp, #4]
	str r0, [sp]
	add sp, sp, #12
	bx lr
.LBB0_1:                                # %entry
	movw r1, #10
	cmp r0, r1
	bne .LBB0_4
# BB#2:                                 # %sw.bb
	movw r0, #34
	b .LBB0_5
.LBB0_4:                                # %sw.default
	movw r0, #100
.LBB0_5:                                # %sw.epilog
	str r0, [sp, #4]
	add sp, sp, #12
	bx lr
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
