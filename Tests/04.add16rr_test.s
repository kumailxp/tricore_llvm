	.text
	.file	"04.add16rr_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 16
	st.w [%a14] -4, %d4
	mov %d15, 230
	st.w [%a14] -8, %d15
	mov %d15, 210
	st.w [%a14] -12, %d15
	ld.w %d15, [%a14] -8
	ld.w %d0, [%a14] -4
	add %d15, %d15, %d0
	st.w [%a14] -16, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
