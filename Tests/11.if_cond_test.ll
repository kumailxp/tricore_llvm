; ModuleID = '11.if_cond_test.bc'
target datalayout = "e-m:e-p:32:32-i64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define i32 @foo(i32 %d, i32 %e) #0 {
entry:
  %d.addr = alloca i32, align 4
  %e.addr = alloca i32, align 4
  store i32 %d, i32* %d.addr, align 4
  store i32 %e, i32* %e.addr, align 4
  %0 = load i32, i32* %d.addr, align 4
  %1 = load i32, i32* %e.addr, align 4
  %cmp = icmp sgt i32 %0, %1
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %2 = load i32, i32* %d.addr, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* %d.addr, align 4
  br label %if.end

if.else:                                          ; preds = %entry
  %3 = load i32, i32* %d.addr, align 4
  %dec = add nsw i32 %3, -1
  store i32 %dec, i32* %d.addr, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret i32 1
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
