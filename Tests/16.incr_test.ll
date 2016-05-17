; ModuleID = '16.incr_test.bc'
target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-f32:32-f64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define i32 @foo() #0 {
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  store i32 10, i32* %a, align 4
  store i32 4, i32* %b, align 4
  store i32 54, i32* %c, align 4
  %0 = load i32, i32* %a, align 4
  %1 = load i32, i32* %b, align 4
  %mul = mul nsw i32 %0, %1
  store i32 %mul, i32* %a, align 4
  %2 = load i32, i32* %a, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* %a, align 4
  %3 = load i32, i32* %a, align 4
  %inc1 = add nsw i32 %3, 1
  store i32 %inc1, i32* %a, align 4
  %4 = load i32, i32* %a, align 4
  %inc2 = add nsw i32 %4, 1
  store i32 %inc2, i32* %a, align 4
  %5 = load i32, i32* %a, align 4
  %inc3 = add nsw i32 %5, 1
  store i32 %inc3, i32* %a, align 4
  ret i32 %inc3
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
