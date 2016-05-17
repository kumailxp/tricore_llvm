	.text
	.file	"determinant.bc"
	.globl	main
	.type	main,@function
main:                                   # @main
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 64
	mov %d7, 0
	st.w [%a14] -4, %d7
	st.w [%a14] -52, %d7
	st.w [%a14] -44, %d7
	mov.d %d15, %a14
	add %d15, %d15, -40
	st.w [%a14] -56, %d15           # 4-byte Folded Spill
	mov %d8, 1
	movh %d4, 21845
	addi %d4, %d4, 21846
	mov %d5, 0
	mov %d3, 12
	add %d3, %d15
	mov %d2, 2
	st.w [%a14] -60, %d2            # 4-byte Folded Spill
	mov %d9, 24
	add %d9, %d15
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	ld.w %d10, [%a14] -44
	ge %d10, %d10, 3
	jnz %d10, .LBB0_3
	j .LBB0_2
.LBB0_2:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	ld.w %d10, [%a14] -52
	ld.w %d14, [%a14] -44
	sh %d11, %d14, 2
	ld.w %d15, [%a14] -56           # 4-byte Folded Reload
	add %d11, %d15
	mov.a %a15, %d11
	ld.w %d11, [%a15] 0
	mov %d12, %d8
	add %d12, %d14
	mul %e0, %e4, %d12
	sh %d6, %d1, -31
	mov %d13, %d6
	add %d13, %d1
	mul %d13, %d13, 3
	mov.a %a15, %d12
	mov.a %a2, %d13
	sub.a %a15, %a15, %a2
	mov.d %d12, %a15
	sh %d13, %d12, 2
	mov %d12, %d13
	mov %d1, %d3
	add %d12, %d1
	mov.a %a15, %d12
	ld.w %d12, [%a15] 0
	ld.w %d0, [%a14] -60            # 4-byte Folded Reload
	add %d0, %d14
	mul %e14, %e4, %d0
	sh %d2, %d15, -31
	mov %d3, %d7
	add %d2, %d15
	mul %d15, %d2, 3
	mov.a %a15, %d0
	mov.a %a2, %d15
	sub.a %a15, %a15, %a2
	mov.d %d15, %a15
	sh %d15, %d15, 2
	mov %d2, %d15
	add %d2, %d9
	mov.a %a15, %d2
	ld.w %d2, [%a15] 0
	mul %d12, %d2
	add %d15, %d1
	mov %d3, %d1
	mov.a %a15, %d15
	ld.w %d15, [%a15] 0
	add %d13, %d9
	mov.a %a15, %d13
	ld.w %d2, [%a15] 0
	mul %d15, %d2
	mov.a %a15, %d12
	mov.a %a2, %d15
	sub.a %a15, %a15, %a2
	mov.d %d15, %a15
	mul %d11, %d15
	add %d11, %d10
	st.w [%a14] -52, %d11
	ld.w %d15, [%a14] -44
	mov %d2, %d8
	add %d2, %d15
	st.w [%a14] -44, %d2
	j .LBB0_1
.LBB0_3:                                # %for.end
	mov %d2, 0
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
