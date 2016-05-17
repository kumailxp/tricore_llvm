; ModuleID = '14.pointer_test_leg.bc'
target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-f64:32-a:0:32-n32"
target triple = "leg-unknown-linux-gnu"

; Function Attrs: nounwind
define void @foo() #0 {
entry:
  %a = alloca i32*, align 4
  %b = alloca i32, align 4
  store i32* null, i32** %a, align 4
  store i32 15, i32* %b, align 4
  store i32* %b, i32** %a, align 4
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
