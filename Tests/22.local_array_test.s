	.text
	.file	"22.local_array_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 32
	mov %d15, 99
	st.w [%a14] -20, %d15
	movh %d15, hi:.Lfoo.a
	addi %d15, %d15, lo:.Lfoo.a
	mov.a %a0, %d15
	ldr %d15, [%a0] 8
	st.w [%a14] -8, %d15
	movh %d15, hi:.Lfoo.a
	addi %d15, %d15, lo:.Lfoo.a
	mov.a %a0, %d15
	ldr %d15, [%a0] 4
	st.w [%a14] -4, %d15
	movh %d15, hi:.Lfoo.a
	addi %d15, %d15, lo:.Lfoo.a
	mov.a %a0, %d15
	ldr %d15, [%a0] 0
	st.w [%a14] 0, %d15
	ldr %d15, [%a14] -4
	st.w [%a14] -20, %d15
	mov %d15, 129
	st.w [%a14] -20, %d15
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.type	.Lfoo.a,@object         # @foo.a
	.section	.rodata,"a",@progbits
	.align	4
.Lfoo.a:
	.word	45                      # 0x2d
	.word	56                      # 0x38
	.word	99                      # 0x63
	.size	.Lfoo.a, 12


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
