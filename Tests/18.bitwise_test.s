	.text
	.file	"18.bitwise_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 12
	mov %d15, 17
	st.w [%a14] -8, %d15
	mov %d15, 51
	st.w [%a14] -4, %d15
	mov %d15, 0
	st.w [%a14] 0, %d15
	ld.w %d0, [%a14] -8
	eq %d1, %d0, 0
	jnz %d1, .LBB0_2
# BB#1:                                 # %entry
	mov %d0, %d15
.LBB0_2:                                # %entry
	and %d15, %d0, 1
	st.w [%a14] 0, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
