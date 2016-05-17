	.text
	.file	"26.logical_assign_test.bc.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 12
	mov %d15, 0
	st.w [%a14] -8, %d15
	mov %d0, 3
	st.w [%a14] -4, %d0
	st.w [%a14] 0, %d0
	ld.w %d0, [%a14] -4
	mov.a %a0, %d15
	eq %d0, %d0, 0
	jnz %d0, .LBB0_4
	j .LBB0_1
.LBB0_1:                                # %land.rhs
	ld.w %d0, [%a14] 0
	ne %d1, %d0, 0
	jnz %d1, .LBB0_3
# BB#2:                                 # %land.rhs
	mov %d0, %d15
.LBB0_3:                                # %land.rhs
	mov.a %a0, %d0
.LBB0_4:                                # %land.end
	mov.d %d15, %a0
	and %d15, %d15, 1
	st.w [%a14] -8, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
