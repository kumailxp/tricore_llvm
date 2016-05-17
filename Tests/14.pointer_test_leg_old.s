	.text
	.file	"14.pointer_test_leg.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	sub sp, sp, #8
	movw r0, #15

	str r0, [sp, #4294967292] ; [sp+429...] = r0
	mov r0, sp                ; r0 = sp
	
        sub r0, r0, #4            ; r0 = r0 - 4 = sp -4
	str r0, [sp]              ; sp +-0 = sp - 4 
	
        
        
        add sp, sp, #8
	bx lr
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
