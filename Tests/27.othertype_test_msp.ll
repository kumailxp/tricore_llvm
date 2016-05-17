; ModuleID = '27.othertype_test_msp.bc'
target datalayout = "e-m:e-p:16:16-i32:16:32-a:16-n8:16"
target triple = "msp430-unknown-linux-gnu"

; Function Attrs: nounwind
define void @foo() #0 {
entry:
  %c = alloca i8, align 1
  %s1 = alloca i16, align 2
  %x = alloca i16, align 2
  store i8 120, i8* %c, align 1
  store i16 11, i16* %s1, align 2
  %0 = load i16, i16* %s1, align 2
  %conv = trunc i16 %0 to i8
  %conv1 = sext i8 %conv to i16
  %1 = load i8, i8* %c, align 1
  %conv2 = zext i8 %1 to i16
  %add = add nsw i16 %conv1, %conv2
  store i16 %add, i16* %x, align 2
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
