	.text
	.file	"05.store_test.bc"
	.globl	main
	.type	main,@function
main:                                   # @main
# BB#0:                                 # %entry
	sub.a a10, a10, 8
	mov d15, #0
	str d15, [a10, #4]
	mov d2, #5
	str d2, [a10]
	add.ri a10, a10, 8
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
