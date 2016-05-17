	.text
	.file	"final.bc"
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 8
	st.w [%a14] -4, %d4
	mov %d15, 1
	add %d15, %d4, %d15
	st.w [%a14] -4, %d15
	ret
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy

	.globl	main
	.type	main,@function
main:                                   # @main
# BB#0:                                 # %entry
	mov %d4, 2
	call dummy
	mov %d2, 0
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
