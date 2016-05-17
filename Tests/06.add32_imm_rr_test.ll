; ModuleID = '06.add32_imm_rr_test.bc'
target datalayout = "e-m:e-p:32:32-a:8:16-n32"
target triple = "tricore-unknown-linux-gnu"

%struct.Date = type { i8, i16 }

@d = global %struct.Date { i8 2, i16 2 }, align 2

; Function Attrs: nounwind
define void @foo() #0 {
entry:
  %x = alloca i32, align 4
  %b = alloca i32, align 4
  store i32 65544, i32* %x, align 4
  store i32 -7775588, i32* %b, align 4
  %0 = load i32, i32* %x, align 4
  %1 = load i32, i32* %b, align 4
  %add = add nsw i32 %0, %1
  %conv = trunc i32 %add to i16
  store i16 %conv, i16* getelementptr inbounds (%struct.Date, %struct.Date* @d, i32 0, i32 1), align 2
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
