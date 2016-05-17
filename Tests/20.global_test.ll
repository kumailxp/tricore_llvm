; ModuleID = '20.global_test.bc'
target datalayout = "e-m:e-p:32:32-i64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

@z = global [6 x i64] [i64 1123213213213133, i64 2, i64 3, i64 4, i64 5, i64 6], align 8

; Function Attrs: nounwind
define void @foo(i32 %l) #0 {
entry:
  %l.addr = alloca i32, align 4
  store i32 %l, i32* %l.addr, align 4
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
