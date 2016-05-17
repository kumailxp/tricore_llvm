	.text
	.file	"28.long_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 24
	movh %d2, 61439
	addi %d2, %d2, -1
	movh %d3, 4096
	st.d [%a14] -8, %e2
	mov %d2, 14
	movh %d3, 16384
	st.d [%a14] -8, %e2
	mov %d2, 1
	mov %d3, 0
	st.d [%a14] -8, %e2
	movh %d2, 4
	addi %d2, %d2, 4
	movh %d3, 2
	addi %d3, %d3, 2
	st.d [%a14] -16, %e2
	ld.d %e2, [%a14] -8
	addx %d2, %d2, 255
	addc %d3, %d3, 0
	st.d [%a14] -16, %e2
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
