	.text
	.file	"06.add32_imm_rr_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	movh %d15, 1
	addi %d15, %d15, 8
	st.w [%a14] -4, %d15
	movh %d15, 65417
	addi %d15, %d15, 23196
	st.w [%a14] -8, %d15
	ld.w %d2, [%a14] -4
	add %d15, %d2, %d15
	movh %d2, hi:d
	addi %d2, %d2, lo:d
	mov.a %a15, %d2
	st.h [%a15] 2, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.type	d,@object               # @d
	.data
	.globl	d
	.align	1
d:
	.byte	2                       # 0x2
	.zero	1
	.short	2                       # 0x2
	.size	d, 4


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
