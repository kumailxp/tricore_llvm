	.text
	.file	"28.long_test.bc.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	movh %d15, 2
	addi %d15, %d15, 2
	st.w [%a14] -8, %d15
	st.w [%a14] -8, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
