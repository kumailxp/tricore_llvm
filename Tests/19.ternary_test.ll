; ModuleID = '19.ternary_test.bc'
target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-f32:32-f64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define i32 @foo() #0 {
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %d = alloca i32, align 4
  %e = alloca i32, align 4
  %f = alloca i32, align 4
  %g = alloca i32, align 4
  %h = alloca i32, align 4
  store i32 6, i32* %a, align 4
  store i32 3, i32* %b, align 4
  %0 = load i32, i32* %a, align 4
  %1 = load i32, i32* %b, align 4
  %cmp = icmp ne i32 %0, %1
  %conv = zext i1 %cmp to i32
  store i32 %conv, i32* %d, align 4
  %2 = load i32, i32* %a, align 4
  %3 = load i32, i32* %b, align 4
  %cmp1 = icmp sgt i32 %2, %3
  %cond = select i1 %cmp1, i32 22, i32 33
  store i32 %cond, i32* %g, align 4
  %4 = load i32, i32* %a, align 4
  %5 = load i32, i32* %b, align 4
  %cmp3 = icmp sge i32 %4, %5
  %cond5 = select i1 %cmp3, i32 11, i32 44
  store i32 %cond5, i32* %h, align 4
  ret i32 0
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
