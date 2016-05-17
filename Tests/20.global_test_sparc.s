	.text
	.file	"20.global_test_sparc.bc"
	.globl	foo
	.align	4
	.type	foo,@function
foo:                                    ! @foo
! BB#0:                                 ! %entry
	save %sp, -96, %sp
	ret
	restore
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.type	v,@object               ! @v
	.data
	.globl	v
	.align	4
v:
	.word	10                      ! 0xa
	.word	2                       ! 0x2
	.word	3                       ! 0x3
	.word	4                       ! 0x4
	.word	5                       ! 0x5
	.word	6                       ! 0x6
	.size	v, 24

	.type	w,@object               ! @w
	.globl	w
	.align	2
w:
	.half	10                      ! 0xa
	.half	2                       ! 0x2
	.half	3                       ! 0x3
	.half	4                       ! 0x4
	.half	5                       ! 0x5
	.half	6                       ! 0x6
	.size	w, 12

	.type	z,@object               ! @z
	.globl	z
	.align	8
z:
	.word	261518                  ! 0x3fd8e7494a1cd
	.word	1955897805
	.word	0                       ! 0x2
	.word	2
	.word	0                       ! 0x3
	.word	3
	.word	0                       ! 0x4
	.word	4
	.word	0                       ! 0x5
	.word	5
	.word	0                       ! 0x6
	.word	6
	.size	z, 48


	.ident	"clang version 3.7.0 (tags/RELEASE_370/final)"
	.section	".note.GNU-stack"
