; ModuleID = '14.pointer_test_msp.bc'
target datalayout = "e-m:e-p:16:16-i32:16:32-a:16-n8:16"
target triple = "msp430-unknown-linux-gnu"

; Function Attrs: nounwind
define void @foo() #0 {
entry:
  %a = alloca i16*, align 2
  %b = alloca i16, align 2
  store i16 15, i16* %b, align 2
  store i16* %b, i16** %a, align 2
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
