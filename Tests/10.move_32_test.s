	.text
	.file	"10.move_32_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 4
	movh %d15, 17
	addi %d15, %d15, 32767
	st.w [%a14] 0, %d15
	movh %d2, 17
	addi %d2, %d2, 32767
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
