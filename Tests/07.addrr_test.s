	.text
	.file	"07.addrr_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	st.w [%a14] -4, %d4
	st.w [%a14] -8, %d5
	ld.w %d15, [%a14] -4
	add %d2, %d15, %d5
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
