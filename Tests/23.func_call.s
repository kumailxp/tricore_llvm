	.text
	.file	"23.func_call.ll"
	.globl	charfoo
	.type	charfoo,@function
charfoo:                                # @charfoo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 24
	ld.d %e2, [%a14] 0
	st.d [%a14] -8, %e4
	st.d [%a14] -16, %e6
	st.d [%a14] -24, %e2
	ld.d %e2, [%a14] -8
	ld.d %e4, [%a14] -16
	addx %d2, %d2, %d4
	addc %d3, %d3, %d5
	st.d [%a14] -8, %e2
	ld.d %e4, [%a14] -24
	addx %d2, %d2, %d4
	addc %d3, %d3, %d5
	st.d [%a14] -8, %e2
	ret
.Lfunc_end0:
	.size	charfoo, .Lfunc_end0-charfoo

	.globl	ptrfunc
	.type	ptrfunc,@function
ptrfunc:                                # @ptrfunc
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 24
	ld.w %d15, [%a14] 16
	st.a [%a14] -4, %a4
	st.a [%a14] -8, %a5
	st.a [%a14] -12, %a6
	st.a [%a14] -16, %a7
	st.w [%a14] -20, %d15
	ld.w %d2, [%a14] -4
	mov.a %a15, %d2
	ld.w %d2, [%a15] 0
	ld.w %d3, [%a14] -8
	mov.a %a15, %d3
	ld.w %d3, [%a15] 0
	add %d3, %d2
	ld.w %d2, [%a14] -12
	mov.a %a15, %d2
	ld.w %d2, [%a15] 0
	add %d2, %d3
	ld.w %d3, [%a14] -16
	mov.a %a15, %d3
	ld.w %d3, [%a15] 0
	add %d3, %d2
	mov.a %a15, %d15
	ld.w %d15, [%a15] 0
	add %d15, %d3
	st.w [%a14] -24, %d15
	ret
.Lfunc_end1:
	.size	ptrfunc, .Lfunc_end1-ptrfunc

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	mov %d15, 8
	st.w [%a14] -4, %d15
	mov.d %d15, %a14
	add %d15, %d15, -4
	st.w [%a10] 16, %d15
	mov.a %a4, %d15
	mov.a %a5, %d15
	mov.a %a6, %d15
	mov.a %a7, %d15
	call ptrfunc
	imask %e2, 0, 0, 0
	ret
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
