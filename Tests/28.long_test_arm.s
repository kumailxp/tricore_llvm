	.text
	.syntax unified
	.eabi_attribute	67, "2.09"	@ Tag_conformance
	.eabi_attribute	6, 1	@ Tag_CPU_arch
	.eabi_attribute	8, 1	@ Tag_ARM_ISA_use
	.eabi_attribute	17, 1	@ Tag_ABI_PCS_GOT_use
	.eabi_attribute	20, 1	@ Tag_ABI_FP_denormal
	.eabi_attribute	21, 1	@ Tag_ABI_FP_exceptions
	.eabi_attribute	23, 3	@ Tag_ABI_FP_number_model
	.eabi_attribute	34, 0	@ Tag_CPU_unaligned_access
	.eabi_attribute	24, 1	@ Tag_ABI_align_needed
	.eabi_attribute	25, 1	@ Tag_ABI_align_preserved
	.eabi_attribute	38, 1	@ Tag_ABI_FP_16bit_format
	.eabi_attribute	18, 4	@ Tag_ABI_PCS_wchar_t
	.eabi_attribute	26, 2	@ Tag_ABI_enum_size
	.eabi_attribute	14, 0	@ Tag_ABI_PCS_R9_use
	.file	"28.long_test_arm.bc"
	.globl	foo
	.align	2
	.type	foo,%function
foo:                                    @ @foo
	.fnstart
@ BB#0:                                 @ %entry
	push	{r11}
	mov	r11, sp
	sub	sp, sp, #28
	bic	sp, sp, #7
	mov	r0, #4
	mov	r1, #9
	orr	r0, r0, #262144
	orr	r1, r1, #589824
	str	r0, [sp, #20]
	mov	r0, #2
	orr	r0, r0, #131072
	str	r0, [sp, #16]
	str	r0, [sp, #8]
	str	r1, [sp, #12]
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #20]
	adds	r0, r2, r0
	str	r0, [sp]
	adc	r0, r3, r1
	str	r0, [sp, #4]
	mov	sp, r11
	pop	{r11}
	bx	lr
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
	.cantunwind
	.fnend


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack","",%progbits
