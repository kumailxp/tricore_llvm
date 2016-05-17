; ModuleID = '23.func_call.bc'
target datalayout = "e-m:e-p:32:32-i64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

; Function Attrs: nounwind
define i64 @charfoo(i64 %a, i64 %b, i64 %c) #0 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %c.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i64 %c, i64* %c.addr, align 8
  %0 = load i64, i64* %a.addr, align 8
  %1 = load i64, i64* %b.addr, align 8
  %add = add nsw i64 %0, %1
  store i64 %add, i64* %a.addr, align 8
  %2 = load i64, i64* %a.addr, align 8
  %3 = load i64, i64* %c.addr, align 8
  %add1 = add nsw i64 %2, %3
  store i64 %add1, i64* %a.addr, align 8
  %4 = load i64, i64* %a.addr, align 8
  ret i64 %4
}

; Function Attrs: nounwind
define void @ptrfunc(i32* %a, i32* %b, i32* %c, i32* %d, i32* %e) #0 {
entry:
  %a.addr = alloca i32*, align 4
  %b.addr = alloca i32*, align 4
  %c.addr = alloca i32*, align 4
  %d.addr = alloca i32*, align 4
  %e.addr = alloca i32*, align 4
  %f = alloca i32, align 4
  store i32* %a, i32** %a.addr, align 4
  store i32* %b, i32** %b.addr, align 4
  store i32* %c, i32** %c.addr, align 4
  store i32* %d, i32** %d.addr, align 4
  store i32* %e, i32** %e.addr, align 4
  %0 = load i32*, i32** %a.addr, align 4
  %1 = load i32, i32* %0, align 4
  %2 = load i32*, i32** %b.addr, align 4
  %3 = load i32, i32* %2, align 4
  %add = add nsw i32 %1, %3
  %4 = load i32*, i32** %c.addr, align 4
  %5 = load i32, i32* %4, align 4
  %add1 = add nsw i32 %add, %5
  %6 = load i32*, i32** %d.addr, align 4
  %7 = load i32, i32* %6, align 4
  %add2 = add nsw i32 %add1, %7
  %8 = load i32*, i32** %e.addr, align 4
  %9 = load i32, i32* %8, align 4
  %add3 = add nsw i32 %add2, %9
  store i32 %add3, i32* %f, align 4
  ret void
}

; Function Attrs: nounwind
define i64 @foo() #0 {
entry:
  %a = alloca i32, align 4
  store i32 8, i32* %a, align 4
  call void @ptrfunc(i32* %a, i32* %a, i32* %a, i32* %a, i32* %a)
  ret i64 0
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
