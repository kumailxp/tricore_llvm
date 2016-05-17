	.text
	.file	"23.func_call_leg.bc"
	.globl	charfoo2
	.type	charfoo2,@function
charfoo2:                               # @charfoo2
# BB#0:                                 # %entry
	sub sp, sp, #8
	str r0, [sp, #4]
	str r1, [sp]
	ldr r0, [sp, #4]
	add r0, r0, r1
	str r0, [sp, #4]
	add sp, sp, #8
	bx lr
.Lfunc_end0:
	.size	charfoo2, .Lfunc_end0-charfoo2

	.globl	ffff
	.type	ffff,@function
ffff:                                   # @ffff
# BB#0:                                 # %entry
	sub sp, sp, #12
	movw r0, #4
	str r0, [sp, #8]
	movw r1, #6
	str r1, [sp, #4]
	ldr r0, [sp, #8]
	movw r2, charfoo2
	movt r2, charfoo2
	bl r2
	str r0, [sp]
	add sp, sp, #12
	bx lr
.Lfunc_end1:
	.size	ffff, .Lfunc_end1-ffff


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
