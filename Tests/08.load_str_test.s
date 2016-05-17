	.text
	.file	"08.load_str_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	mov %d15, 9
	st.w [%a14] -4, %d15
	mov %d15, 0
	st.w [%a14] -8, %d15
	ld.w %d15, [%a14] -4
	add %d2, %d15, 9
	st.w [%a14] -8, %d2
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
