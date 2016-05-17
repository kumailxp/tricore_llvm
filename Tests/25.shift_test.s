	.text
	.file	"25.shift_test.ll"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 16
	st.w [%a14] -4, %d4
	mov %d15, 8
	st.w [%a14] -8, %d15
	mov %d15, 6
	st.w [%a14] -12, %d15
	mov %d15, 4
	st.w [%a14] -16, %d15
	ld.w %d15, [%a14] -8
	ld.w %d2, [%a14] -4
	rsub %d2, %d2, 2
	rsub %d2
	sh %d15, %d15, %d2
	st.w [%a14] -8, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
