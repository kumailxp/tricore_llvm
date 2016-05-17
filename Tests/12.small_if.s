	.text
	.file	"12.small_if.ll"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	st.w [%a14] -4, %d4
	ge %d15, %d4, 6
	jnz %d15, .LBB0_2
# BB#1:                                 # %entry
	mov %d4, 6
.LBB0_2:                                # %entry
	mov %d15, %d4
	and %d15, 1
	st.w [%a14] -8, %d15
	mov %d2, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
