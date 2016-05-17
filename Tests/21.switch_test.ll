; ModuleID = '21.switch_test.bc'
target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-f32:32-f64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define i32 @foo() #0 {
entry:
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 20, i32* %b, align 4
  store i32 10, i32* %c, align 4
  store i32 0, i32* %a, align 4
  %0 = load i32, i32* %b, align 4
  %add = add nsw i32 22, %0
  %1 = load i32, i32* %c, align 4
  %add1 = add nsw i32 %add, %1
  store i32 %add1, i32* %a, align 4
  %2 = load i32, i32* %a, align 4
  switch i32 %2, label %sw.default [
    i32 10, label %sw.bb
    i32 23, label %sw.bb.2
  ]

sw.bb:                                            ; preds = %entry
  store i32 34, i32* %b, align 4
  br label %sw.epilog

sw.bb.2:                                          ; preds = %entry
  %3 = load i32, i32* %a, align 4
  %add3 = add nsw i32 %3, 2
  store i32 %add3, i32* %a, align 4
  br label %sw.epilog

sw.default:                                       ; preds = %entry
  store i32 100, i32* %b, align 4
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %sw.bb.2, %sw.bb
  ret i32 1
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
