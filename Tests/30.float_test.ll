; ModuleID = '30.float_test.bc'
target datalayout = "e-m:e-p:32:32-i64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define void @foo() #0 {
entry:
  %i = alloca float, align 4
  %j = alloca float, align 4
  %z = alloca float, align 4
  store float 0x3FF024DD20000000, float* %i, align 4
  store float 0x4000CCCCC0000000, float* %j, align 4
  %0 = load float, float* %i, align 4
  %1 = load float, float* %j, align 4
  %add = fadd float %0, %1
  store float %add, float* %z, align 4
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
