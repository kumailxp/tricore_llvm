; ModuleID = '20.global_test_msp.bc'
target datalayout = "e-m:e-p:16:16-i32:16:32-a:16-n8:16"
target triple = "msp430-unknown-linux-gnu"

@v = global [6 x i16] [i16 10, i16 2, i16 3, i16 4, i16 5, i16 6], align 2
@w = global [6 x i16] [i16 10, i16 2, i16 3, i16 4, i16 5, i16 6], align 2
@z = global [6 x i64] [i64 1123213213213133, i64 2, i64 3, i64 4, i64 5, i64 6], align 8

; Function Attrs: nounwind
define void @foo() #0 {
entry:
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
