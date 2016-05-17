; ModuleID = '28.long_test_arm.bc'
target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv4t-unknown-inux-gnu"

; Function Attrs: nounwind
define arm_aapcscc void @foo() #0 {
entry:
  %a = alloca i64, align 8
  %b = alloca i64, align 8
  %w = alloca i64, align 8
  store i64 1125917086842882, i64* %a, align 8
  store i64 2533313445232642, i64* %b, align 8
  %0 = load i64, i64* %a, align 8
  %1 = load i64, i64* %b, align 8
  %add = add nsw i64 %0, %1
  store i64 %add, i64* %w, align 8
  ret void
}

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="arm7tdmi" "target-features"="+soft-float,-crypto,-neon" "unsafe-fp-math"="false" "use-soft-float"="true" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
