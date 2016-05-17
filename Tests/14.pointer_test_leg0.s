	.text
	.file	"14.pointer_test_leg.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	sub sp, sp, #16
	movw r0, #0
	str r0, [sp, #12]

	str r0, [sp, #8]
	
        movw r0, #15
	str r0, [sp, #4]
	
        movw r0, #42
	str r0, [sp]
	
        
        mov r0, sp
	sub r0, r0, #8
	str r0, [sp, #12]
	
        
        
        
        
        add sp, sp, #16
	bx lr
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
