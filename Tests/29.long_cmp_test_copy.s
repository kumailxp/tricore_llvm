	.text
	.file	"29.long_cmp_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 24
	mov %d2, 1
	mov %d3, 0
	st.d [%a14] -8, %e2
	mov %d2, 2
	st.d [%a14] -16, %e2
	ld.d %e2, [%a14] -8
	addx %d2, %d2, 11
	addc %d3, %d3, 0
	st.d [%a14] -16, %e2
	ld.d %e4, [%a14] -8
	eq %d15, %d5, %d3
	and.ge.u %d15, %d4, %d2
	or.lt %d15, %d3, %d5
	jnz %d15, .LBB0_2
	j .LBB0_1
.LBB0_1:                                # %if.then
	mov %d15, 9
	st.w [%a14] -20, %d15
.LBB0_2:                                # %if.end
	ld.d %e2, [%a14] -8
	ld.d %e4, [%a14] -16
	eq %d15, %d5, %d3
	and.ge.u %d15, %d4, %d2
	or.lt %d15, %d3, %d5
	jnz %d15, .LBB0_4
	j .LBB0_3
.LBB0_3:                                # %if.then.3
	mov %d15, 10
	st.w [%a14] -20, %d15
.LBB0_4:                                # %if.end.4
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
