; ModuleID = '04.add16rr_test.bc'
target datalayout = "e-m:e-p:32:32-i8:8:8-i16:16:16-i32:32:32-i64:32-f32:32-f64:32-a:0:32-n32:64"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define void @foo(i32 %d) #0 {
entry:
  %d.addr = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  store i32 %d, i32* %d.addr, align 4
  store i32 230, i32* %a, align 4
  store i32 210, i32* %b, align 4
  %0 = load i32, i32* %a, align 4
  %1 = load i32, i32* %d.addr, align 4
  %add = add nsw i32 %0, %1
  store i32 %add, i32* %c, align 4
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
