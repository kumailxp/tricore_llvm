	.text
	.file	"27.othertype_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 16
	mov %d15, 120
	st.b [%a14] -1, %d15
	mov %d15, 11
	st.h [%a14] -4, %d15
	ld.bu %d15, [%a14] -4
	st.w [%a14] -8, %d15
	ld.b %d15, [%a14] -1
	st.w [%a14] -12, %d15
	ld.hu %d15, [%a14] -4
	st.w [%a14] -16, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
