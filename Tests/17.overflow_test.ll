; ModuleID = '17.overflow_test.bc'
target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-f32:32-f64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define i32 @add32carry(i32 %sum, i32 %x) #0 {
entry:
  %sum.addr = alloca i32, align 4
  %x.addr = alloca i32, align 4
  %z = alloca i32, align 4
  store i32 %sum, i32* %sum.addr, align 4
  store i32 %x, i32* %x.addr, align 4
  %0 = load i32, i32* %sum.addr, align 4
  %1 = load i32, i32* %x.addr, align 4
  %add = add nsw i32 %0, %1
  store i32 %add, i32* %z, align 4
  %2 = load i32, i32* %sum.addr, align 4
  %3 = load i32, i32* %x.addr, align 4
  %add1 = add nsw i32 %2, %3
  %4 = load i32, i32* %x.addr, align 4
  %cmp = icmp sgt i32 %add1, %4
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %5 = load i32, i32* %z, align 4
  %inc = add nsw i32 %5, 1
  store i32 %inc, i32* %z, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %6 = load i32, i32* %z, align 4
  ret i32 %6
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
