	.text
	.file	"16.incr_test.bc"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	mov.aa %a14, %a10
	sub.a %a10, 12
	movw %d15, 10
	str [%a14] -8, %d15
	movw %d15, 4
	str [%a14] -4, %d15
	movw %d15, 54
	str [%a14], %d15
	ldr %d15, [%a14] -8
	ldr %d0, [%a14] -4
	mul %d15, %d0, %d15
	str [%a14] -8, %d15
	add %d0, %d15, 1
	str [%a14] -8, %d0
	add %d0, %d15, 2
	str [%a14] -8, %d0
	add %d0, %d15, 3
	str [%a14] -8, %d0
	add %d2, %d15, 4
	str [%a14] -8, %d2
	ret
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
