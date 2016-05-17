	.text
	.file	"test.bc"
	.globl	sum_i
	.type	sum_i,@function
sum_i:                                  # @sum_i
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	st.w [%a14] -4, %d4
	mov %d2, %d4
	ret
.Lfunc_end0:
	.size	sum_i, .Lfunc_end0-sum_i

	.globl	call_sum_i
	.type	call_sum_i,@function
call_sum_i:                             # @call_sum_i
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	mov %d4, 1
	st.w [%a14] -4, %d4
	call sum_i
	ret
.Lfunc_end1:
	.size	call_sum_i, .Lfunc_end1-call_sum_i


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
