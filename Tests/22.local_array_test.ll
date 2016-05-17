; ModuleID = '22.local_array_test.bc'
target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-f32:32-f64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

@foo.a = private unnamed_addr constant [3 x i32] [i32 45, i32 56, i32 99], align 4

; Function Attrs: nounwind
define void @foo() #0 {
entry:
  %b = alloca i32, align 4
  %d = alloca i32, align 4
  %e = alloca i32, align 4
  %f = alloca i32, align 4
  %g = alloca i32, align 4
  %a = alloca [3 x i32], align 4
  store i32 99, i32* %e, align 4
  %0 = bitcast [3 x i32]* %a to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %0, i8* bitcast ([3 x i32]* @foo.a to i8*), i32 12, i32 4, i1 false)
  %arrayidx = getelementptr inbounds [3 x i32], [3 x i32]* %a, i32 0, i32 1
  %1 = load i32, i32* %arrayidx, align 4
  store i32 %1, i32* %e, align 4
  store i32 129, i32* %e, align 4
  ret void
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture readonly, i32, i32, i1) #1

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
