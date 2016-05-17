	.text
	.file	"29.long_cmp_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 24
	ld.d %e2, [%a14] -8
	addx %d2, %d2, 3
	addc %d3, %d3, 0
	and %d15, %d2, 255
	st.w [%a14] -9, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
