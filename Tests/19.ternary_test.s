	.text
	.file	"19.ternary_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 32
	mov %d15, 6
	st.w [%a14] -28, %d15
	mov %d15, 3
	st.w [%a14] -24, %d15
	ld.w %d0, [%a14] -28
	ne %d1, %d0, 3
	jnz %d1, .LBB0_2
# BB#1:                                 # %entry
	mov %d0, %d15
.LBB0_2:                                # %entry
	and %d15, %d0, 1
	st.w [%a14] -16, %d15
	ld.w %d15, [%a14] -28
	ld.w %d0, [%a14] -24
	lt %d0, %d0, %d15
	mov %d15, 22
	jnz %d0, .LBB0_4
# BB#3:                                 # %entry
	mov %d15, 33
.LBB0_4:                                # %entry
	st.w [%a14] -4, %d15
	ld.w %d15, [%a14] -28
	ld.w %d0, [%a14] -24
	ge %d0, %d15, %d0
	mov %d15, 11
	jnz %d0, .LBB0_6
# BB#5:                                 # %entry
	mov %d15, 44
.LBB0_6:                                # %entry
	st.w [%a14] 0, %d15
	mov %d2, 0
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
