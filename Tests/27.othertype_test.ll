; ModuleID = '27.othertype_test.bc'
target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:8-i16:16:16-i64:32-f32:32-f64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define void @foo() #0 {
entry:
  %c = alloca i8, align 1
  %s1 = alloca i16, align 2
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %z = alloca i32, align 4
  store i8 120, i8* %c, align 1
  store i16 11, i16* %s1, align 2
  %0 = load i16, i16* %s1, align 2
  %conv = trunc i16 %0 to i8
  %conv1 = zext i8 %conv to i32
  store i32 %conv1, i32* %x, align 4
  %1 = load i8, i8* %c, align 1
  %conv2 = sext i8 %1 to i32
  store i32 %conv2, i32* %y, align 4
  %2 = load i16, i16* %s1, align 2
  %conv3 = zext i16 %2 to i32
  store i32 %conv3, i32* %z, align 4
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
