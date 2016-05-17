	.text
	.file	"32.loop_text.bc"
	.globl	f
	.type	f,@function
f:                                      # @f
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 16
	st.w [%a14] -4, %d4
	st.w [%a14] -8, %d5
	mov %d15, 0
	st.w [%a14] -12, %d15
	mov %d15, 1
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	ld.w %d2, [%a14] -12
	ld.w %d3, [%a14] -4
	ge %d2, %d2, %d3
	jnz %d2, .LBB0_4
	j .LBB0_2
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	ld.w %d2, [%a14] -8
	mov %d3, %d15
	add %d3, %d2
	st.w [%a14] -8, %d3
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	ld.w %d2, [%a14] -12
	mov %d3, %d15
	add %d3, %d2
	st.w [%a14] -12, %d3
	j .LBB0_1
.LBB0_4:                                # %for.end
	mov %d2, 1
	ret
.Lfunc_end0:
	.size	f, .Lfunc_end0-f


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
