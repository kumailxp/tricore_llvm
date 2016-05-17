	.text
	.file	"13.loop_test.bc.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	mov %d15, 0
	st.w [%a14] 0, %d15
	st.w [%a14] -4, %d15
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	ld.w %d15, [%a14] -4
	ge %d15, %d15, 10
	jnz %d15, .LBB0_4
	j .LBB0_2
.LBB0_2:                                # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	ld.w %d15, [%a14] 0
	add %d15, 1
	st.w [%a14] 0, %d15
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	ld.w %d15, [%a14] -4
	add %d15, 1
	st.w [%a14] -4, %d15
	j .LBB0_1
.LBB0_4:                                # %for.end
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
