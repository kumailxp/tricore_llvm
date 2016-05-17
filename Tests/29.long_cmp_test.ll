; ModuleID = '29.long_cmp_test.bc'
target datalayout = "e-m:e-p:32:32-i8:8:8-i16:16:16-i64:32-f32:32-f64:32-a:0:32-n32:64"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define void @foo() #0 {
entry:
  %b = alloca i64, align 8
  %i = alloca i8, align 1
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %0 = load i64, i64* %b, align 8
  %add = add nsw i64 %0, 3
  %conv = trunc i64 %add to i8
  store i8 %conv, i8* %i, align 1
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
