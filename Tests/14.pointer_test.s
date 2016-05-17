	.text
	.file	"14.pointer_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 16
	mov %d15, 0
	st.w [%a14] -12, %d15
	st.w [%a14] -8, %d15
	mov %d15, 15
	st.w [%a14] -4, %d15
	mov %d15, 42
	st.w [%a14] 0, %d15
	mov.d %d15, %a14
	add %d15, %d15, -4
	st.w [%a14] -8, %d15
	mov.d %d15, %a14
	st.w [%a14] -12, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
