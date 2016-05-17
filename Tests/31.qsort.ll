; ModuleID = '31.qsort.bc'
target datalayout = "e-m:e-p:32:32-i64:32-a:0:32-n32"
target triple = "tricore-unknown-linux-gnu"

@main.num_list = private unnamed_addr constant [5 x i32] [i32 5, i32 4, i32 3, i32 2, i32 1], align 4
@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: nounwind
define void @swap(i8* %x, i8* %y, i32 %l) #0 {
entry:
  %x.addr = alloca i8*, align 4
  %y.addr = alloca i8*, align 4
  %l.addr = alloca i32, align 4
  %a = alloca i8*, align 4
  %b = alloca i8*, align 4
  %c = alloca i8, align 1
  store i8* %x, i8** %x.addr, align 4
  store i8* %y, i8** %y.addr, align 4
  store i32 %l, i32* %l.addr, align 4
  %0 = load i8*, i8** %x.addr, align 4
  store i8* %0, i8** %a, align 4
  %1 = load i8*, i8** %y.addr, align 4
  store i8* %1, i8** %b, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %2 = load i32, i32* %l.addr, align 4
  %dec = add nsw i32 %2, -1
  store i32 %dec, i32* %l.addr, align 4
  %tobool = icmp ne i32 %2, 0
  br i1 %tobool, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %3 = load i8*, i8** %a, align 4
  %4 = load i8, i8* %3, align 1
  store i8 %4, i8* %c, align 1
  %5 = load i8*, i8** %b, align 4
  %6 = load i8, i8* %5, align 1
  %7 = load i8*, i8** %a, align 4
  %incdec.ptr = getelementptr inbounds i8, i8* %7, i32 1
  store i8* %incdec.ptr, i8** %a, align 4
  store i8 %6, i8* %7, align 1
  %8 = load i8, i8* %c, align 1
  %9 = load i8*, i8** %b, align 4
  %incdec.ptr1 = getelementptr inbounds i8, i8* %9, i32 1
  store i8* %incdec.ptr1, i8** %b, align 4
  store i8 %8, i8* %9, align 1
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: nounwind
define i32 @_cmp(i8* %a, i8* %b) #0 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i8*, align 4
  %b.addr = alloca i8*, align 4
  %c = alloca i32, align 4
  store i8* %a, i8** %a.addr, align 4
  store i8* %b, i8** %b.addr, align 4
  store i32 0, i32* %c, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %0 = load i32, i32* %c, align 4
  %1 = load i8*, i8** %a.addr, align 4
  %arrayidx = getelementptr inbounds i8, i8* %1, i32 %0
  %2 = load i8, i8* %arrayidx, align 1
  %conv = sext i8 %2 to i32
  %3 = load i32, i32* %c, align 4
  %4 = load i8*, i8** %b.addr, align 4
  %arrayidx1 = getelementptr inbounds i8, i8* %4, i32 %3
  %5 = load i8, i8* %arrayidx1, align 1
  %conv2 = sext i8 %5 to i32
  %cmp = icmp eq i32 %conv, %conv2
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %6 = load i32, i32* %c, align 4
  %7 = load i8*, i8** %a.addr, align 4
  %arrayidx4 = getelementptr inbounds i8, i8* %7, i32 %6
  %8 = load i8, i8* %arrayidx4, align 1
  %conv5 = sext i8 %8 to i32
  %cmp6 = icmp eq i32 %conv5, 0
  br i1 %cmp6, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %while.body
  %9 = load i32, i32* %c, align 4
  %10 = load i8*, i8** %b.addr, align 4
  %arrayidx8 = getelementptr inbounds i8, i8* %10, i32 %9
  %11 = load i8, i8* %arrayidx8, align 1
  %conv9 = sext i8 %11 to i32
  %cmp10 = icmp eq i32 %conv9, 0
  br i1 %cmp10, label %if.then, label %if.end

if.then:                                          ; preds = %lor.lhs.false, %while.body
  br label %while.end

if.end:                                           ; preds = %lor.lhs.false
  %12 = load i32, i32* %c, align 4
  %inc = add nsw i32 %12, 1
  store i32 %inc, i32* %c, align 4
  br label %while.cond

while.end:                                        ; preds = %if.then, %while.cond
  %13 = load i32, i32* %c, align 4
  %14 = load i8*, i8** %a.addr, align 4
  %arrayidx12 = getelementptr inbounds i8, i8* %14, i32 %13
  %15 = load i8, i8* %arrayidx12, align 1
  %conv13 = sext i8 %15 to i32
  %cmp14 = icmp eq i32 %conv13, 0
  br i1 %cmp14, label %land.lhs.true, label %if.else

land.lhs.true:                                    ; preds = %while.end
  %16 = load i32, i32* %c, align 4
  %17 = load i8*, i8** %b.addr, align 4
  %arrayidx16 = getelementptr inbounds i8, i8* %17, i32 %16
  %18 = load i8, i8* %arrayidx16, align 1
  %conv17 = sext i8 %18 to i32
  %cmp18 = icmp eq i32 %conv17, 0
  br i1 %cmp18, label %if.then.20, label %if.else

if.then.20:                                       ; preds = %land.lhs.true
  store i32 0, i32* %retval
  br label %return

if.else:                                          ; preds = %land.lhs.true, %while.end
  store i32 -1, i32* %retval
  br label %return

return:                                           ; preds = %if.else, %if.then.20
  %19 = load i32, i32* %retval
  ret i32 %19
}

; Function Attrs: nounwind
define void @qsort(i8* %array, i32 %nitems, i32 %size, i32 (i8*, i8*)* %cmp) #0 {
entry:
  %array.addr = alloca i8*, align 4
  %nitems.addr = alloca i32, align 4
  %size.addr = alloca i32, align 4
  %cmp.addr = alloca i32 (i8*, i8*)*, align 4
  store i8* %array, i8** %array.addr, align 4
  store i32 %nitems, i32* %nitems.addr, align 4
  store i32 %size, i32* %size.addr, align 4
  store i32 (i8*, i8*)* %cmp, i32 (i8*, i8*)** %cmp.addr, align 4
  %0 = load i8*, i8** %array.addr, align 4
  %1 = load i32, i32* %size.addr, align 4
  %2 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %cmp.addr, align 4
  %3 = load i32, i32* %nitems.addr, align 4
  %4 = load i32, i32* %size.addr, align 4
  %mul = mul nsw i32 %3, %4
  call void @sort(i8* %0, i32 %1, i32 (i8*, i8*)* %2, i32 0, i32 %mul)
  ret void
}

; Function Attrs: nounwind
define internal void @sort(i8* %array, i32 %size, i32 (i8*, i8*)* %cmp, i32 %begin, i32 %end) #0 {
entry:
  %array.addr = alloca i8*, align 4
  %size.addr = alloca i32, align 4
  %cmp.addr = alloca i32 (i8*, i8*)*, align 4
  %begin.addr = alloca i32, align 4
  %end.addr = alloca i32, align 4
  %pivot = alloca i8*, align 4
  %l = alloca i32, align 4
  %r = alloca i32, align 4
  %index = alloca i32, align 4
  %g = alloca i8, align 1
  store i8* %array, i8** %array.addr, align 4
  store i32 %size, i32* %size.addr, align 4
  store i32 (i8*, i8*)* %cmp, i32 (i8*, i8*)** %cmp.addr, align 4
  store i32 %begin, i32* %begin.addr, align 4
  store i32 %end, i32* %end.addr, align 4
  %0 = load i32, i32* %end.addr, align 4
  %1 = load i32, i32* %begin.addr, align 4
  %cmp1 = icmp sgt i32 %0, %1
  br i1 %cmp1, label %if.then, label %if.end.19

if.then:                                          ; preds = %entry
  %2 = load i8*, i8** %array.addr, align 4
  %3 = load i32, i32* %begin.addr, align 4
  %add.ptr = getelementptr inbounds i8, i8* %2, i32 %3
  store i8* %add.ptr, i8** %pivot, align 4
  %4 = load i32, i32* %begin.addr, align 4
  %5 = load i32, i32* %size.addr, align 4
  %add = add nsw i32 %4, %5
  store i32 %add, i32* %l, align 4
  %6 = load i32, i32* %end.addr, align 4
  store i32 %6, i32* %r, align 4
  %7 = load i32, i32* %l, align 4
  store i32 %7, i32* %index, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end.15, %if.then
  %8 = load i32, i32* %l, align 4
  %9 = load i32, i32* %r, align 4
  %cmp2 = icmp slt i32 %8, %9
  br i1 %cmp2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %10 = load i32, i32* %index, align 4
  %11 = load i8*, i8** %array.addr, align 4
  %arrayidx = getelementptr inbounds i8, i8* %11, i32 %10
  %12 = load i8, i8* %arrayidx, align 1
  store i8 %12, i8* %g, align 1
  %13 = load i8*, i8** %pivot, align 4
  %call = call i32 @_cmp(i8* %g, i8* %13)
  %cmp3 = icmp sle i32 %call, 0
  br i1 %cmp3, label %if.then.4, label %if.else

if.then.4:                                        ; preds = %while.body
  %14 = load i32, i32* %size.addr, align 4
  %15 = load i32, i32* %l, align 4
  %add5 = add nsw i32 %15, %14
  store i32 %add5, i32* %l, align 4
  %16 = load i32, i32* %l, align 4
  store i32 %16, i32* %index, align 4
  br label %if.end.15

if.else:                                          ; preds = %while.body
  %17 = load i8*, i8** %pivot, align 4
  %call6 = call i32 @_cmp(i8* %g, i8* %17)
  %cmp7 = icmp sgt i32 %call6, 0
  br i1 %cmp7, label %if.then.8, label %if.else.9

if.then.8:                                        ; preds = %if.else
  %18 = load i32, i32* %size.addr, align 4
  %19 = load i32, i32* %r, align 4
  %sub = sub nsw i32 %19, %18
  store i32 %sub, i32* %r, align 4
  %20 = load i32, i32* %r, align 4
  store i32 %20, i32* %index, align 4
  br label %if.end.14

if.else.9:                                        ; preds = %if.else
  %21 = load i32, i32* %l, align 4
  %22 = load i32, i32* %r, align 4
  %cmp10 = icmp slt i32 %21, %22
  br i1 %cmp10, label %if.then.11, label %if.end

if.then.11:                                       ; preds = %if.else.9
  %23 = load i8*, i8** %array.addr, align 4
  %24 = load i32, i32* %l, align 4
  %add.ptr12 = getelementptr inbounds i8, i8* %23, i32 %24
  %25 = load i8*, i8** %array.addr, align 4
  %26 = load i32, i32* %r, align 4
  %add.ptr13 = getelementptr inbounds i8, i8* %25, i32 %26
  %27 = load i32, i32* %size.addr, align 4
  call void @swap(i8* %add.ptr12, i8* %add.ptr13, i32 %27)
  br label %if.end

if.end:                                           ; preds = %if.then.11, %if.else.9
  br label %if.end.14

if.end.14:                                        ; preds = %if.end, %if.then.8
  br label %if.end.15

if.end.15:                                        ; preds = %if.end.14, %if.then.4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %28 = load i32, i32* %size.addr, align 4
  %29 = load i32, i32* %l, align 4
  %sub16 = sub nsw i32 %29, %28
  store i32 %sub16, i32* %l, align 4
  %30 = load i8*, i8** %array.addr, align 4
  %31 = load i32, i32* %begin.addr, align 4
  %add.ptr17 = getelementptr inbounds i8, i8* %30, i32 %31
  %32 = load i8*, i8** %array.addr, align 4
  %33 = load i32, i32* %l, align 4
  %add.ptr18 = getelementptr inbounds i8, i8* %32, i32 %33
  %34 = load i32, i32* %size.addr, align 4
  call void @swap(i8* %add.ptr17, i8* %add.ptr18, i32 %34)
  %35 = load i8*, i8** %array.addr, align 4
  %36 = load i32, i32* %size.addr, align 4
  %37 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %cmp.addr, align 4
  %38 = load i32, i32* %begin.addr, align 4
  %39 = load i32, i32* %l, align 4
  call void @sort(i8* %35, i32 %36, i32 (i8*, i8*)* %37, i32 %38, i32 %39)
  %40 = load i8*, i8** %array.addr, align 4
  %41 = load i32, i32* %size.addr, align 4
  %42 = load i32 (i8*, i8*)*, i32 (i8*, i8*)** %cmp.addr, align 4
  %43 = load i32, i32* %r, align 4
  %44 = load i32, i32* %end.addr, align 4
  call void @sort(i8* %40, i32 %41, i32 (i8*, i8*)* %42, i32 %43, i32 %44)
  br label %if.end.19

if.end.19:                                        ; preds = %while.end, %entry
  ret void
}

; Function Attrs: nounwind
define i32 @type_cmp(i8* %a, i8* %b) #0 {
entry:
  %a.addr = alloca i8*, align 4
  %b.addr = alloca i8*, align 4
  store i8* %a, i8** %a.addr, align 4
  store i8* %b, i8** %b.addr, align 4
  %0 = load i8*, i8** %a.addr, align 4
  %1 = bitcast i8* %0 to i32*
  %2 = load i32, i32* %1, align 4
  %3 = load i8*, i8** %b.addr, align 4
  %4 = bitcast i8* %3 to i32*
  %5 = load i32, i32* %4, align 4
  %sub = sub nsw i32 %2, %5
  ret i32 %sub
}

; Function Attrs: nounwind
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %num_list = alloca [5 x i32], align 4
  %len = alloca i32, align 4
  %sep = alloca i8*, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval
  %0 = bitcast [5 x i32]* %num_list to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %0, i8* bitcast ([5 x i32]* @main.num_list to i8*), i32 20, i32 4, i1 false)
  store i32 15, i32* %len, align 4
  store i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str, i32 0, i32 0), i8** %sep, align 4
  %arraydecay = getelementptr inbounds [5 x i32], [5 x i32]* %num_list, i32 0, i32 0
  %1 = bitcast i32* %arraydecay to i8*
  %2 = load i32, i32* %len, align 4
  call void @qsort(i8* %1, i32 %2, i32 4, i32 (i8*, i8*)* @type_cmp)
  ret i32 0
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture readonly, i32, i32, i1) #1

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (tags/RELEASE_370/final)"}
