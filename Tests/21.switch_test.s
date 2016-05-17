	.text
	.file	"21.switch_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 12
	mov %d15, 20
	st.w [%a14] -8, %d15
	mov %d15, 10
	st.w [%a14] -4, %d15
	mov %d15, 0
	st.w [%a14] 0, %d15
	ld.w %d15, [%a14] -8
	ld.w %d0, [%a14] -4
	add %d15, %d15, %d0
	add %d15, %d15, 22
	st.w [%a14] 0, %d15
	eq %d0, %d15, 23
	jnz %d0, .LBB0_3
	j .LBB0_1
.LBB0_3:                                # %sw.bb.2
	ld.w %d15, [%a14] 0
	add %d15, 2
	st.w [%a14] 0, %d15
	j .LBB0_5
.LBB0_1:                                # %entry
	ne %d15, %d15, 10
	jnz %d15, .LBB0_4
	j .LBB0_2
.LBB0_2:                                # %sw.bb
	mov %d15, 34
	st.w [%a14] -8, %d15
	j .LBB0_5
.LBB0_4:                                # %sw.default
	mov %d15, 100
	st.w [%a14] -8, %d15
.LBB0_5:                                # %sw.epilog
	mov %d2, 1
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
