; ModuleID = 'test.bc'
target datalayout = "e-m:e-p:32:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define i32 @sum_i(i32 %x1) #0 {
entry:
  %x1.addr = alloca i32, align 4
  store i32 %x1, i32* %x1.addr, align 4
  %0 = load i32, i32* %x1.addr, align 4
  ret i32 %0
}

; Function Attrs: nounwind
define i32 @call_sum_i() #0 {
entry:
  %a = alloca i32, align 4
  store i32 1, i32* %a, align 4
  %0 = load i32, i32* %a, align 4
  %call = call i32 @sum_i(i32 %0)
  ret i32 %call
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
