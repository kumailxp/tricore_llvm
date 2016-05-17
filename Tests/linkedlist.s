	.text
	.file	"linkedlist.bc"
	.globl	main
	.type	main,@function
main:                                   # @main
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 16
	mov %d3, 0
	st.w [%a14] -4, %d3
	mov %d15, 8
	st.w [%a10] 0, %d15
	call malloc
	st.w [%a14] -8, %d2
	mov.a %a15, %d2
	st.w [%a15] 4, %d3
	ld.w %d15, [%a14] -8
	mov %d2, 12
	mov.a %a15, %d15
	st.w [%a15] 0, %d2
	ld.w %d15, [%a14] -8
	st.w [%a14] -12, %d15
	eq %d15, %d15, 0
	jnz %d15, .LBB0_3
	j .LBB0_1
.LBB0_2:                                # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	ld.w %d15, [%a14] -12
	mov.a %a15, %d15
	ld.w %d15, [%a15] 4
	st.w [%a14] -12, %d15
	j .LBB0_1
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	ld.w %d15, [%a14] -12
	mov.a %a15, %d15
	ld.w %d15, [%a15] 4
	eq %d15, %d15, 0
	jnz %d15, .LBB0_3
	j .LBB0_2
.LBB0_3:                                # %if.end
	ld.w %d15, [%a14] -12
	mov.a %a15, %d15
	ld.w %d15, [%a15] 4
	st.w [%a14] -12, %d15
	ne %d15, %d15, 0
	jnz %d15, .LBB0_5
	j .LBB0_4
.LBB0_4:                                # %if.then.6
	st.w [%a14] -4, %d3
	j .LBB0_6
.LBB0_5:                                # %if.end.7
	ld.w %d15, [%a14] -12
	mov.a %a15, %d15
	st.w [%a15] 4, %d3
	ld.w %d15, [%a14] -12
	mov %d2, 42
	mov.a %a15, %d15
	st.w [%a15] 0, %d2
	st.w [%a14] -4, %d3
.LBB0_6:                                # %return
	ld.w %d2, [%a14] -4
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
