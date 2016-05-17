	.text
	.file	"header.c"
	.globl	dummy
	.type	dummy,@function
dummy:
	mov.aa %a14, %a10
	sub.a %a10, 8
	mov.a %a15, %d4
	st.w [%a14] -4, %d4
	add %d4, 1
	st.w [%a14] -4, %d4
	st.w [%a14] -8, %a15
	ret
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",@progbits
