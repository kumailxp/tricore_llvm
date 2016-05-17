	.text
	.file	"11.if_cond_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	st.w [%a14] -4, %d4
	st.w [%a14] -8, %d5
	ld.w %d15, [%a14] -4
	ge %d15, %d5, %d15
	jnz %d15, .LBB0_2
	j .LBB0_1
.LBB0_1:                                # %if.then
	ld.w %d15, [%a14] -4
	mov %d2, 1
	add %d2, %d15
	st.w [%a14] -4, %d2
	j .LBB0_3
.LBB0_2:                                # %if.else
	ld.w %d15, [%a14] -4
	mov %d2, -1
	add %d2, %d15
	st.w [%a14] -4, %d2
.LBB0_3:                                # %if.end
	mov %d2, 1
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
