	.text
	.file	"31.qsort.bc"
	.globl	swap
	.type	swap,@function
swap:                                   # @swap
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 24
	st.a [%a14] -4, %a4
	st.a [%a14] -8, %a5
	st.w [%a14] -12, %d4
	ld.w %d15, [%a14] -4
	st.w [%a14] -16, %d15
	ld.w %d15, [%a14] -8
	st.w [%a14] -20, %d15
	mov %d15, -1
	mov %d2, 1
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	ld.w %d3, [%a14] -12
	mov %d4, %d15
	add %d4, %d3
	st.w [%a14] -12, %d4
	eq %d3, %d3, 0
	jnz %d3, .LBB0_3
	j .LBB0_2
.LBB0_2:                                # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	ld.w %d3, [%a14] -16
	mov.a %a15, %d3
	ld.b %d3, [%a15] 0
	st.b [%a14] -21, %d3
	ld.w %d3, [%a14] -20
	mov.a %a15, %d3
	ld.b %d3, [%a15] 0
	ld.w %d4, [%a14] -16
	mov %d5, %d2
	add %d5, %d4
	st.w [%a14] -16, %d5
	mov.a %a15, %d4
	st.b [%a15] 0, %d3
	ld.b %d3, [%a14] -21
	ld.w %d4, [%a14] -20
	mov %d5, %d2
	add %d5, %d4
	st.w [%a14] -20, %d5
	mov.a %a15, %d4
	st.b [%a15] 0, %d3
	j .LBB0_1
.LBB0_3:                                # %while.end
	ret
.Lfunc_end0:
	.size	swap, .Lfunc_end0-swap

	.globl	_cmp
	.type	_cmp,@function
_cmp:                                   # @_cmp
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 16
	st.a [%a14] -8, %a4
	st.a [%a14] -12, %a5
	mov %d15, 0
	st.w [%a14] -16, %d15
	mov %d2, 1
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	ld.w %d3, [%a14] -16
	ld.w %d4, [%a14] -8
	mov %d5, %d3
	add %d5, %d4
	mov.a %a15, %d5
	ld.b %d4, [%a15] 0
	ld.w %d5, [%a14] -12
	add %d3, %d5
	mov.a %a15, %d3
	ld.b %d3, [%a15] 0
	ne %d3, %d4, %d3
	jnz %d3, .LBB1_5
	j .LBB1_2
.LBB1_2:                                # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	ld.w %d3, [%a14] -16
	ld.w %d4, [%a14] -8
	add %d3, %d4
	mov.a %a15, %d3
	ld.b %d3, [%a15] 0
	eq %d3, %d3, 0
	jnz %d3, .LBB1_5
	j .LBB1_3
.LBB1_3:                                # %lor.lhs.false
                                        #   in Loop: Header=BB1_1 Depth=1
	ld.w %d3, [%a14] -16
	ld.w %d4, [%a14] -12
	add %d3, %d4
	mov.a %a15, %d3
	ld.b %d3, [%a15] 0
	eq %d3, %d3, 0
	jnz %d3, .LBB1_5
	j .LBB1_4
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	ld.w %d3, [%a14] -16
	mov %d4, %d2
	add %d4, %d3
	st.w [%a14] -16, %d4
	j .LBB1_1
.LBB1_5:                                # %while.end
	ld.w %d2, [%a14] -16
	ld.w %d3, [%a14] -8
	add %d2, %d3
	mov.a %a15, %d2
	ld.b %d2, [%a15] 0
	ne %d2, %d2, 0
	jnz %d2, .LBB1_8
	j .LBB1_6
.LBB1_6:                                # %land.lhs.true
	ld.w %d2, [%a14] -16
	ld.w %d3, [%a14] -12
	add %d2, %d3
	mov.a %a15, %d2
	ld.b %d2, [%a15] 0
	ne %d2, %d2, 0
	jnz %d2, .LBB1_8
	j .LBB1_7
.LBB1_7:                                # %if.then.20
	st.w [%a14] -4, %d15
	j .LBB1_9
.LBB1_8:                                # %if.else
	mov %d15, -1
	st.w [%a14] -4, %d15
.LBB1_9:                                # %return
	ld.w %d2, [%a14] -4
	ret
.Lfunc_end1:
	.size	_cmp, .Lfunc_end1-_cmp

	.globl	insertion_sort
	.type	insertion_sort,@function
insertion_sort:                         # @insertion_sort
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 24
	st.a [%a14] -4, %a4
	st.w [%a14] -8, %d4
	mov %d2, 1
	st.w [%a14] -12, %d2
	mov %d3, -1
	mov %d4, 0
.LBB2_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
	ld.w %d15, [%a14] -12
	ld.w %d5, [%a14] -8
	mov %d6, %d3
	add %d6, %d5
	lt %d15, %d6, %d15
	jnz %d15, .LBB2_9
	j .LBB2_2
.LBB2_2:                                # %for.body
                                        #   in Loop: Header=BB2_1 Depth=1
	ld.w %d15, [%a14] -12
	st.w [%a14] -16, %d15
.LBB2_3:                                # %while.cond
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	ld.w %d15, [%a14] -16
	lt %d5, %d15, 1
	mov %d15, %d4
	jnz %d5, .LBB2_6
	j .LBB2_4
.LBB2_4:                                # %land.rhs
                                        #   in Loop: Header=BB2_3 Depth=2
	ld.w %d15, [%a14] -16
	ld.w %d5, [%a14] -4
	sh %d6, %d15, 2
	add %d6, %d5
	mov.a %a15, %d6
	ld.w %d15, [%a15] 0
	mov.a %a15, %d6
	ld.w %d5, [%a15] -4
	lt %d6, %d15, %d5
	jnz %d6, .LBB2_6
# BB#5:                                 # %land.rhs
                                        #   in Loop: Header=BB2_3 Depth=2
	mov %d15, %d5
.LBB2_6:                                # %land.end
                                        #   in Loop: Header=BB2_3 Depth=2
	and %d15, 1
	eq %d15, %d15, 0
	jnz %d15, .LBB2_8
	j .LBB2_7
.LBB2_7:                                # %while.body
                                        #   in Loop: Header=BB2_3 Depth=2
	ld.w %d15, [%a14] -16
	ld.w %d5, [%a14] -4
	sh %d15, %d15, 2
	add %d15, %d5
	mov.a %a15, %d15
	ld.w %d15, [%a15] 0
	st.w [%a14] -20, %d15
	ld.w %d15, [%a14] -16
	ld.w %d5, [%a14] -4
	sh %d15, %d15, 2
	add %d15, %d5
	mov.a %a15, %d15
	ld.w %d5, [%a15] -4
	mov.a %a15, %d15
	st.w [%a15] 0, %d5
	ld.w %d15, [%a14] -20
	ld.w %d5, [%a14] -16
	sh %d5, %d5, 2
	ld.w %d6, [%a14] -4
	add %d6, %d5
	mov.a %a15, %d6
	st.w [%a15] -4, %d15
	ld.w %d15, [%a14] -16
	mov %d5, %d3
	add %d5, %d15
	st.w [%a14] -16, %d5
	j .LBB2_3
.LBB2_8:                                # %for.inc
                                        #   in Loop: Header=BB2_1 Depth=1
	ld.w %d15, [%a14] -12
	mov %d5, %d2
	add %d5, %d15
	st.w [%a14] -12, %d5
	j .LBB2_1
.LBB2_9:                                # %for.end
	ret
.Lfunc_end2:
	.size	insertion_sort, .Lfunc_end2-insertion_sort

	.globl	selection_sort
	.type	selection_sort,@function
selection_sort:                         # @selection_sort
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 24
	st.a [%a14] -4, %a4
	st.w [%a14] -8, %d4
	mov %d15, 0
	st.w [%a14] -12, %d15
	mov %d15, -1
	mov %d2, 1
.LBB3_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_3 Depth 2
	ld.w %d3, [%a14] -12
	ld.w %d4, [%a14] -8
	mov %d5, %d15
	add %d5, %d4
	ge %d3, %d3, %d5
	jnz %d3, .LBB3_10
	j .LBB3_2
.LBB3_2:                                # %for.body
                                        #   in Loop: Header=BB3_1 Depth=1
	ld.w %d3, [%a14] -12
	st.w [%a14] -24, %d3
	ld.w %d3, [%a14] -12
	mov %d4, %d2
	add %d4, %d3
	st.w [%a14] -16, %d4
.LBB3_3:                                # %for.cond.1
                                        #   Parent Loop BB3_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	ld.w %d3, [%a14] -16
	ld.w %d4, [%a14] -8
	ge %d3, %d3, %d4
	jnz %d3, .LBB3_7
	j .LBB3_4
.LBB3_4:                                # %for.body.3
                                        #   in Loop: Header=BB3_3 Depth=2
	ld.w %d3, [%a14] -24
	ld.w %d4, [%a14] -4
	sh %d3, %d3, 2
	add %d3, %d4
	mov.a %a15, %d3
	ld.w %d3, [%a15] 0
	ld.w %d5, [%a14] -16
	sh %d5, %d5, 2
	add %d5, %d4
	mov.a %a15, %d5
	ld.w %d4, [%a15] 0
	ge %d3, %d4, %d3
	jnz %d3, .LBB3_6
	j .LBB3_5
.LBB3_5:                                # %if.then
                                        #   in Loop: Header=BB3_3 Depth=2
	ld.w %d3, [%a14] -16
	st.w [%a14] -24, %d3
.LBB3_6:                                # %for.inc
                                        #   in Loop: Header=BB3_3 Depth=2
	ld.w %d3, [%a14] -16
	mov %d4, %d2
	add %d4, %d3
	st.w [%a14] -16, %d4
	j .LBB3_3
.LBB3_7:                                # %for.end
                                        #   in Loop: Header=BB3_1 Depth=1
	ld.w %d3, [%a14] -24
	ld.w %d4, [%a14] -12
	eq %d3, %d3, %d4
	jnz %d3, .LBB3_9
	j .LBB3_8
.LBB3_8:                                # %if.then.7
                                        #   in Loop: Header=BB3_1 Depth=1
	ld.w %d3, [%a14] -12
	ld.w %d4, [%a14] -4
	sh %d3, %d3, 2
	add %d3, %d4
	mov.a %a15, %d3
	ld.w %d3, [%a15] 0
	st.w [%a14] -20, %d3
	ld.w %d3, [%a14] -24
	ld.w %d4, [%a14] -4
	sh %d3, %d3, 2
	add %d3, %d4
	mov.a %a15, %d3
	ld.w %d3, [%a15] 0
	ld.w %d5, [%a14] -12
	sh %d5, %d5, 2
	add %d5, %d4
	mov.a %a15, %d5
	st.w [%a15] 0, %d3
	ld.w %d3, [%a14] -20
	ld.w %d4, [%a14] -24
	ld.w %d5, [%a14] -4
	sh %d4, %d4, 2
	add %d4, %d5
	mov.a %a15, %d4
	st.w [%a15] 0, %d3
.LBB3_9:                                # %for.inc.13
                                        #   in Loop: Header=BB3_1 Depth=1
	ld.w %d3, [%a14] -12
	mov %d4, %d2
	add %d4, %d3
	st.w [%a14] -12, %d4
	j .LBB3_1
.LBB3_10:                               # %for.end.15
	ret
.Lfunc_end3:
	.size	selection_sort, .Lfunc_end3-selection_sort

	.globl	qsort
	.type	qsort,@function
qsort:                                  # @qsort
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 16
	st.a [%a14] -4, %a4
	st.w [%a14] -8, %d4
	st.w [%a14] -12, %d5
	st.a [%a14] -16, %a5
	ld.w %d15, [%a14] -4
	ld.w %d2, [%a14] -12
	ld.w %d3, [%a14] -8
	mul %d3, %d2
	st.w [%a10] 16, %d3
	mov %d3, 0
	st.w [%a10] 12, %d3
	st.a [%a10] 8, %a5
	st.w [%a10] 4, %d2
	st.w [%a10] 0, %d15
	call sort
	ret
.Lfunc_end4:
	.size	qsort, .Lfunc_end4-qsort

	.type	sort,@function
sort:                                   # @sort
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 40
	st.a [%a14] -4, %a4
	st.w [%a14] -8, %d4
	st.a [%a14] -12, %a5
	st.w [%a14] -16, %d5
	st.w [%a14] -20, %d6
	ld.w %d15, [%a14] -16
	ge %d15, %d15, %d6
	jnz %d15, .LBB5_10
	j .LBB5_1
.LBB5_1:                                # %if.then
	ld.w %d15, [%a14] -4
	ld.w %d2, [%a14] -16
	add %d2, %d15
	st.w [%a14] -24, %d2
	ld.w %d15, [%a14] -16
	ld.w %d2, [%a14] -8
	add %d2, %d15
	st.w [%a14] -28, %d2
	ld.w %d15, [%a14] -20
	st.w [%a14] -32, %d15
	ld.w %d15, [%a14] -28
	st.w [%a14] -36, %d15
	mov.d %d3, %a14
	add %d3, %d3, -37
.LBB5_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	ld.w %d15, [%a14] -28
	ld.w %d2, [%a14] -32
	ge %d15, %d15, %d2
	jnz %d15, .LBB5_9
	j .LBB5_3
.LBB5_3:                                # %while.body
                                        #   in Loop: Header=BB5_2 Depth=1
	ld.w %d15, [%a14] -36
	ld.w %d2, [%a14] -4
	add %d15, %d2
	mov.a %a15, %d15
	ld.b %d15, [%a15] 0
	st.b [%a14] -37, %d15
	ld.w %d15, [%a14] -24
	mov.a %a4, %d3
	mov.a %a5, %d15
	call _cmp
	ge %d15, %d2, 1
	jnz %d15, .LBB5_5
	j .LBB5_4
.LBB5_4:                                # %if.then.4
                                        #   in Loop: Header=BB5_2 Depth=1
	ld.w %d15, [%a14] -8
	ld.w %d2, [%a14] -28
	add %d15, %d2
	st.w [%a14] -28, %d15
	st.w [%a14] -36, %d15
	j .LBB5_2
.LBB5_5:                                # %if.else
                                        #   in Loop: Header=BB5_2 Depth=1
	ld.w %d15, [%a14] -24
	mov.a %a4, %d3
	mov.a %a5, %d15
	call _cmp
	lt %d15, %d2, 1
	jnz %d15, .LBB5_7
	j .LBB5_6
.LBB5_6:                                # %if.then.8
                                        #   in Loop: Header=BB5_2 Depth=1
	ld.w %d15, [%a14] -8
	ld.w %d2, [%a14] -32
	mov.a %a15, %d2
	mov.a %a2, %d15
	sub.a %a15, %a15, %a2
	mov.d %d15, %a15
	st.w [%a14] -32, %d15
	mov.d %d15, %a15
	st.w [%a14] -36, %d15
	j .LBB5_2
.LBB5_7:                                # %if.else.9
                                        #   in Loop: Header=BB5_2 Depth=1
	ld.w %d15, [%a14] -28
	ld.w %d2, [%a14] -32
	ge %d15, %d15, %d2
	jnz %d15, .LBB5_2
	j .LBB5_8
.LBB5_8:                                # %if.then.11
                                        #   in Loop: Header=BB5_2 Depth=1
	ld.w %d15, [%a14] -4
	ld.w %d2, [%a14] -28
	add %d2, %d15
	ld.w %d5, [%a14] -32
	add %d5, %d15
	ld.w %d4, [%a14] -8
	mov.a %a4, %d2
	mov.a %a5, %d5
	call swap
	j .LBB5_2
.LBB5_9:                                # %while.end
	ld.w %d15, [%a14] -8
	ld.w %d2, [%a14] -28
	mov.a %a15, %d2
	mov.a %a2, %d15
	sub.a %a15, %a15, %a2
	mov.d %d15, %a15
	st.w [%a14] -28, %d15
	ld.w %d15, [%a14] -4
	ld.w %d2, [%a14] -16
	add %d2, %d15
	mov.d %d3, %a15
	add %d3, %d15
	ld.w %d4, [%a14] -8
	mov.a %a4, %d2
	mov.a %a5, %d3
	call swap
	ld.w %d15, [%a14] -4
	ld.w %d4, [%a14] -8
	ld.w %d2, [%a14] -12
	ld.w %d5, [%a14] -16
	ld.w %d6, [%a14] -28
	mov.a %a4, %d15
	mov.a %a5, %d2
	call sort
	ld.w %d15, [%a14] -4
	ld.w %d4, [%a14] -8
	ld.w %d2, [%a14] -12
	ld.w %d5, [%a14] -32
	ld.w %d6, [%a14] -20
	mov.a %a4, %d15
	mov.a %a5, %d2
	call sort
.LBB5_10:                               # %if.end.19
	ret
.Lfunc_end5:
	.size	sort, .Lfunc_end5-sort

	.globl	type_cmp
	.type	type_cmp,@function
type_cmp:                               # @type_cmp
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	st.a [%a14] -4, %a4
	st.a [%a14] -8, %a5
	ld.w %d15, [%a14] -4
	mov.a %a15, %d15
	ld.w %d15, [%a15] 0
	ld.w %d2, [%a5] 0
	mov.a %a15, %d15
	mov.a %a2, %d2
	sub.a %a15, %a15, %a2
	mov.d %d2, %a15
	ret
.Lfunc_end6:
	.size	type_cmp, .Lfunc_end6-type_cmp

	.globl	main
	.type	main,@function
main:                                   # @main
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 40
	mov %d2, 0
	st.w [%a14] -4, %d2
	ld.w %d15,  16
	st.w [%a14] -24, %d15
	ld.d %e4,  8
	st.d [%a14] -24, %e4
	ld.d %e4,  0
	st.d [%a14] -24, %e4
	mov %d3, 5
	st.w [%a14] -28, %d3
	movh %d15, hi:.L.str
	addi %d15, %d15, lo:.L.str
	st.w [%a14] -32, %d15
	ld.w %d4, [%a14] -28
	movh %d15, hi:type_cmp
	addi %d15, %d15, lo:type_cmp
	mov.d %d6, %a14
	add %d6, %d6, -24
	mov %d5, 4
	mov.a %a4, %d6
	mov.a %a5, %d15
	call qsort
	mov.a %a4, %d6
	mov %d4, %d3
	call selection_sort
	mov.a %a4, %d6
	mov %d4, %d3
	call insertion_sort
	ret
.Lfunc_end7:
	.size	main, .Lfunc_end7-main

	.type	.Lmain.num_list,@object # @main.num_list
	.section	.rodata,"a",@progbits
	.align	2
.Lmain.num_list:
	.word	5                       # 0x5
	.word	4                       # 0x4
	.word	3                       # 0x3
	.word	2                       # 0x2
	.word	1                       # 0x1
	.size	.Lmain.num_list, 20

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.zero	1
	.size	.L.str, 1


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
