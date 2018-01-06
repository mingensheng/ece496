; ModuleID = 'point_struct.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.foo = type { i32, i32, i32 (i32, i32)* }

@.str = private unnamed_addr constant [4 x i8] c"foo\00", align 1
@.str1 = private unnamed_addr constant [12 x i8] c"klee_choose\00", align 1
@.str12 = private unnamed_addr constant [22 x i8] c"klee_div_zero_check.c\00", align 1
@.str123 = private unnamed_addr constant [15 x i8] c"divide by zero\00", align 1
@.str2 = private unnamed_addr constant [8 x i8] c"div.err\00", align 1
@.str3 = private unnamed_addr constant [8 x i8] c"IGNORED\00", align 1
@.str14 = private unnamed_addr constant [16 x i8] c"overshift error\00", align 1
@.str25 = private unnamed_addr constant [14 x i8] c"overshift.err\00", align 1
@.str6 = private unnamed_addr constant [13 x i8] c"klee_range.c\00", align 1
@.str17 = private unnamed_addr constant [14 x i8] c"invalid range\00", align 1
@.str28 = private unnamed_addr constant [5 x i8] c"user\00", align 1

; Function Attrs: nounwind uwtable
define i32 @add(i32 %a, i32 %b) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 %a, i32* %1, align 4
  store i32 %b, i32* %2, align 4
  %3 = load i32* %1, align 4, !dbg !146
  %4 = load i32* %2, align 4, !dbg !146
  %5 = add nsw i32 %3, %4, !dbg !146
  ret i32 %5, !dbg !146
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind uwtable
define i32 @bar(i8* %foo_ptr) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i8*, align 8
  %foo_ptr_temp = alloca %struct.foo*, align 8
  %sum = alloca i32, align 4
  store i8* %foo_ptr, i8** %2, align 8
  %3 = load i8** %2, align 8, !dbg !147
  %4 = bitcast i8* %3 to %struct.foo*, !dbg !147
  store %struct.foo* %4, %struct.foo** %foo_ptr_temp, align 8, !dbg !147
  %5 = load %struct.foo** %foo_ptr_temp, align 8, !dbg !148
  %6 = getelementptr inbounds %struct.foo* %5, i32 0, i32 2, !dbg !148
  store i32 (i32, i32)* @add, i32 (i32, i32)** %6, align 8, !dbg !148
  %7 = load %struct.foo** %foo_ptr_temp, align 8, !dbg !149
  %8 = getelementptr inbounds %struct.foo* %7, i32 0, i32 2, !dbg !149
  %9 = load i32 (i32, i32)** %8, align 8, !dbg !149
  %10 = load %struct.foo** %foo_ptr_temp, align 8, !dbg !149
  %11 = getelementptr inbounds %struct.foo* %10, i32 0, i32 0, !dbg !149
  %12 = load i32* %11, align 4, !dbg !149
  %13 = load %struct.foo** %foo_ptr_temp, align 8, !dbg !149
  %14 = getelementptr inbounds %struct.foo* %13, i32 0, i32 1, !dbg !149
  %15 = load i32* %14, align 4, !dbg !149
  %16 = call i32 %9(i32 %12, i32 %15), !dbg !149
  store i32 %16, i32* %sum, align 4, !dbg !149
  %17 = load i32* %sum, align 4, !dbg !150
  %18 = icmp eq i32 %17, 1, !dbg !150
  br i1 %18, label %19, label %20, !dbg !150

; <label>:19                                      ; preds = %0
  store i32 1, i32* %1, !dbg !152
  br label %21, !dbg !152

; <label>:20                                      ; preds = %0
  store i32 2, i32* %1, !dbg !154
  br label %21, !dbg !154

; <label>:21                                      ; preds = %20, %19
  %22 = load i32* %1, !dbg !156
  ret i32 %22, !dbg !156
}

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %foo_ptr = alloca %struct.foo*, align 8
  store i32 0, i32* %1
  %2 = call noalias i8* @malloc(i64 16) #7, !dbg !157
  %3 = bitcast i8* %2 to %struct.foo*, !dbg !157
  store %struct.foo* %3, %struct.foo** %foo_ptr, align 8, !dbg !157
  %4 = load %struct.foo** %foo_ptr, align 8, !dbg !158
  %5 = bitcast %struct.foo* %4 to i8*, !dbg !158
  %6 = load %struct.foo** %foo_ptr, align 8, !dbg !159
  %7 = bitcast %struct.foo* %6 to i8*, !dbg !159
  call void @klee_make_symbolic(i8* %7, i64 8, i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0)), !dbg !159
  %8 = load %struct.foo** %foo_ptr, align 8, !dbg !160
  %9 = bitcast %struct.foo* %8 to i8*, !dbg !160
  %10 = call i32 @bar(i8* %9), !dbg !160
  ret i32 %10, !dbg !160
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #2

declare void @klee_make_symbolic(i8*, i64, i8*) #3

; Function Attrs: nounwind ssp uwtable
define i64 @klee_choose(i64 %n) #4 {
  %x = alloca i64, align 8
  %1 = bitcast i64* %x to i8*, !dbg !161
  call void @klee_make_symbolic(i8* %1, i64 8, i8* getelementptr inbounds ([12 x i8]* @.str1, i64 0, i64 0)) #8, !dbg !161
  %2 = load i64* %x, align 8, !dbg !162, !tbaa !164
  %3 = icmp ult i64 %2, %n, !dbg !162
  br i1 %3, label %5, label %4, !dbg !162

; <label>:4                                       ; preds = %0
  call void @klee_silent_exit(i32 0) #9, !dbg !168
  unreachable, !dbg !168

; <label>:5                                       ; preds = %0
  ret i64 %2, !dbg !169
}

; Function Attrs: noreturn
declare void @klee_silent_exit(i32) #5

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata) #1

; Function Attrs: nounwind ssp uwtable
define void @klee_div_zero_check(i64 %z) #4 {
  %1 = icmp eq i64 %z, 0, !dbg !170
  br i1 %1, label %2, label %3, !dbg !170

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([22 x i8]* @.str12, i64 0, i64 0), i32 14, i8* getelementptr inbounds ([15 x i8]* @.str123, i64 0, i64 0), i8* getelementptr inbounds ([8 x i8]* @.str2, i64 0, i64 0)) #9, !dbg !172
  unreachable, !dbg !172

; <label>:3                                       ; preds = %0
  ret void, !dbg !173
}

; Function Attrs: noreturn
declare void @klee_report_error(i8*, i32, i8*, i8*) #5

; Function Attrs: nounwind ssp uwtable
define i32 @klee_int(i8* %name) #4 {
  %x = alloca i32, align 4
  %1 = bitcast i32* %x to i8*, !dbg !174
  call void @klee_make_symbolic(i8* %1, i64 4, i8* %name) #8, !dbg !174
  %2 = load i32* %x, align 4, !dbg !175, !tbaa !176
  ret i32 %2, !dbg !175
}

; Function Attrs: nounwind ssp uwtable
define void @klee_overshift_check(i64 %bitWidth, i64 %shift) #4 {
  %1 = icmp ult i64 %shift, %bitWidth, !dbg !178
  br i1 %1, label %3, label %2, !dbg !178

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([8 x i8]* @.str3, i64 0, i64 0), i32 0, i8* getelementptr inbounds ([16 x i8]* @.str14, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8]* @.str25, i64 0, i64 0)) #9, !dbg !180
  unreachable, !dbg !180

; <label>:3                                       ; preds = %0
  ret void, !dbg !182
}

; Function Attrs: nounwind ssp uwtable
define i32 @klee_range(i32 %start, i32 %end, i8* %name) #4 {
  %x = alloca i32, align 4
  %1 = icmp slt i32 %start, %end, !dbg !183
  br i1 %1, label %3, label %2, !dbg !183

; <label>:2                                       ; preds = %0
  call void @klee_report_error(i8* getelementptr inbounds ([13 x i8]* @.str6, i64 0, i64 0), i32 17, i8* getelementptr inbounds ([14 x i8]* @.str17, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str28, i64 0, i64 0)) #9, !dbg !185
  unreachable, !dbg !185

; <label>:3                                       ; preds = %0
  %4 = add nsw i32 %start, 1, !dbg !186
  %5 = icmp eq i32 %4, %end, !dbg !186
  br i1 %5, label %21, label %6, !dbg !186

; <label>:6                                       ; preds = %3
  %7 = bitcast i32* %x to i8*, !dbg !188
  call void @klee_make_symbolic(i8* %7, i64 4, i8* %name) #8, !dbg !188
  %8 = icmp eq i32 %start, 0, !dbg !190
  %9 = load i32* %x, align 4, !dbg !192, !tbaa !176
  br i1 %8, label %10, label %13, !dbg !190

; <label>:10                                      ; preds = %6
  %11 = icmp ult i32 %9, %end, !dbg !192
  %12 = zext i1 %11 to i64, !dbg !192
  call void @klee_assume(i64 %12) #8, !dbg !192
  br label %19, !dbg !194

; <label>:13                                      ; preds = %6
  %14 = icmp sge i32 %9, %start, !dbg !195
  %15 = zext i1 %14 to i64, !dbg !195
  call void @klee_assume(i64 %15) #8, !dbg !195
  %16 = load i32* %x, align 4, !dbg !197, !tbaa !176
  %17 = icmp slt i32 %16, %end, !dbg !197
  %18 = zext i1 %17 to i64, !dbg !197
  call void @klee_assume(i64 %18) #8, !dbg !197
  br label %19

; <label>:19                                      ; preds = %13, %10
  %20 = load i32* %x, align 4, !dbg !198, !tbaa !176
  br label %21, !dbg !198

; <label>:21                                      ; preds = %19, %3
  %.0 = phi i32 [ %20, %19 ], [ %start, %3 ]
  ret i32 %.0, !dbg !199
}

declare void @klee_assume(i64) #6

; Function Attrs: nounwind ssp uwtable
define weak i8* @memcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #4 {
  %1 = icmp eq i64 %len, 0, !dbg !200
  br i1 %1, label %._crit_edge, label %.lr.ph.preheader, !dbg !200

.lr.ph.preheader:                                 ; preds = %0
  %n.vec = and i64 %len, -32
  %cmp.zero = icmp eq i64 %n.vec, 0
  %2 = add i64 %len, -1
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %.lr.ph.preheader
  %scevgep4 = getelementptr i8* %srcaddr, i64 %2
  %scevgep = getelementptr i8* %destaddr, i64 %2
  %bound1 = icmp uge i8* %scevgep, %srcaddr
  %bound0 = icmp uge i8* %scevgep4, %destaddr
  %memcheck.conflict = and i1 %bound0, %bound1
  %ptr.ind.end = getelementptr i8* %srcaddr, i64 %n.vec
  %ptr.ind.end6 = getelementptr i8* %destaddr, i64 %n.vec
  %rev.ind.end = sub i64 %len, %n.vec
  br i1 %memcheck.conflict, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.memcheck
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.memcheck ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep103 = getelementptr i8* %destaddr, i64 %index
  %3 = bitcast i8* %next.gep to <16 x i8>*, !dbg !201
  %wide.load = load <16 x i8>* %3, align 1, !dbg !201
  %next.gep.sum279 = or i64 %index, 16, !dbg !201
  %4 = getelementptr i8* %srcaddr, i64 %next.gep.sum279, !dbg !201
  %5 = bitcast i8* %4 to <16 x i8>*, !dbg !201
  %wide.load200 = load <16 x i8>* %5, align 1, !dbg !201
  %6 = bitcast i8* %next.gep103 to <16 x i8>*, !dbg !201
  store <16 x i8> %wide.load, <16 x i8>* %6, align 1, !dbg !201
  %7 = getelementptr i8* %destaddr, i64 %next.gep.sum279, !dbg !201
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !201
  store <16 x i8> %wide.load200, <16 x i8>* %8, align 1, !dbg !201
  %index.next = add i64 %index, 32
  %9 = icmp eq i64 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !202

middle.block:                                     ; preds = %vector.body, %vector.memcheck, %.lr.ph.preheader
  %resume.val = phi i8* [ %srcaddr, %.lr.ph.preheader ], [ %srcaddr, %vector.memcheck ], [ %ptr.ind.end, %vector.body ]
  %resume.val5 = phi i8* [ %destaddr, %.lr.ph.preheader ], [ %destaddr, %vector.memcheck ], [ %ptr.ind.end6, %vector.body ]
  %resume.val7 = phi i64 [ %len, %.lr.ph.preheader ], [ %len, %vector.memcheck ], [ %rev.ind.end, %vector.body ]
  %new.indc.resume.val = phi i64 [ 0, %.lr.ph.preheader ], [ 0, %vector.memcheck ], [ %n.vec, %vector.body ]
  %cmp.n = icmp eq i64 %new.indc.resume.val, %len
  br i1 %cmp.n, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph, %middle.block
  %src.03 = phi i8* [ %11, %.lr.ph ], [ %resume.val, %middle.block ]
  %dest.02 = phi i8* [ %13, %.lr.ph ], [ %resume.val5, %middle.block ]
  %.01 = phi i64 [ %10, %.lr.ph ], [ %resume.val7, %middle.block ]
  %10 = add i64 %.01, -1, !dbg !200
  %11 = getelementptr inbounds i8* %src.03, i64 1, !dbg !201
  %12 = load i8* %src.03, align 1, !dbg !201, !tbaa !205
  %13 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !201
  store i8 %12, i8* %dest.02, align 1, !dbg !201, !tbaa !205
  %14 = icmp eq i64 %10, 0, !dbg !200
  br i1 %14, label %._crit_edge, label %.lr.ph, !dbg !200, !llvm.loop !206

._crit_edge:                                      ; preds = %.lr.ph, %middle.block, %0
  ret i8* %destaddr, !dbg !207
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memmove(i8* %dst, i8* %src, i64 %count) #4 {
  %1 = icmp eq i8* %src, %dst, !dbg !208
  br i1 %1, label %.loopexit, label %2, !dbg !208

; <label>:2                                       ; preds = %0
  %3 = icmp ugt i8* %src, %dst, !dbg !210
  br i1 %3, label %.preheader, label %18, !dbg !210

.preheader:                                       ; preds = %2
  %4 = icmp eq i64 %count, 0, !dbg !212
  br i1 %4, label %.loopexit, label %.lr.ph.preheader, !dbg !212

.lr.ph.preheader:                                 ; preds = %.preheader
  %n.vec = and i64 %count, -32
  %cmp.zero = icmp eq i64 %n.vec, 0
  %5 = add i64 %count, -1
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %.lr.ph.preheader
  %scevgep11 = getelementptr i8* %src, i64 %5
  %scevgep = getelementptr i8* %dst, i64 %5
  %bound1 = icmp uge i8* %scevgep, %src
  %bound0 = icmp uge i8* %scevgep11, %dst
  %memcheck.conflict = and i1 %bound0, %bound1
  %ptr.ind.end = getelementptr i8* %src, i64 %n.vec
  %ptr.ind.end13 = getelementptr i8* %dst, i64 %n.vec
  %rev.ind.end = sub i64 %count, %n.vec
  br i1 %memcheck.conflict, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.memcheck
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.memcheck ]
  %next.gep = getelementptr i8* %src, i64 %index
  %next.gep110 = getelementptr i8* %dst, i64 %index
  %6 = bitcast i8* %next.gep to <16 x i8>*, !dbg !212
  %wide.load = load <16 x i8>* %6, align 1, !dbg !212
  %next.gep.sum586 = or i64 %index, 16, !dbg !212
  %7 = getelementptr i8* %src, i64 %next.gep.sum586, !dbg !212
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !212
  %wide.load207 = load <16 x i8>* %8, align 1, !dbg !212
  %9 = bitcast i8* %next.gep110 to <16 x i8>*, !dbg !212
  store <16 x i8> %wide.load, <16 x i8>* %9, align 1, !dbg !212
  %10 = getelementptr i8* %dst, i64 %next.gep.sum586, !dbg !212
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !212
  store <16 x i8> %wide.load207, <16 x i8>* %11, align 1, !dbg !212
  %index.next = add i64 %index, 32
  %12 = icmp eq i64 %index.next, %n.vec
  br i1 %12, label %middle.block, label %vector.body, !llvm.loop !214

middle.block:                                     ; preds = %vector.body, %vector.memcheck, %.lr.ph.preheader
  %resume.val = phi i8* [ %src, %.lr.ph.preheader ], [ %src, %vector.memcheck ], [ %ptr.ind.end, %vector.body ]
  %resume.val12 = phi i8* [ %dst, %.lr.ph.preheader ], [ %dst, %vector.memcheck ], [ %ptr.ind.end13, %vector.body ]
  %resume.val14 = phi i64 [ %count, %.lr.ph.preheader ], [ %count, %vector.memcheck ], [ %rev.ind.end, %vector.body ]
  %new.indc.resume.val = phi i64 [ 0, %.lr.ph.preheader ], [ 0, %vector.memcheck ], [ %n.vec, %vector.body ]
  %cmp.n = icmp eq i64 %new.indc.resume.val, %count
  br i1 %cmp.n, label %.loopexit, label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph, %middle.block
  %b.04 = phi i8* [ %14, %.lr.ph ], [ %resume.val, %middle.block ]
  %a.03 = phi i8* [ %16, %.lr.ph ], [ %resume.val12, %middle.block ]
  %.02 = phi i64 [ %13, %.lr.ph ], [ %resume.val14, %middle.block ]
  %13 = add i64 %.02, -1, !dbg !212
  %14 = getelementptr inbounds i8* %b.04, i64 1, !dbg !212
  %15 = load i8* %b.04, align 1, !dbg !212, !tbaa !205
  %16 = getelementptr inbounds i8* %a.03, i64 1, !dbg !212
  store i8 %15, i8* %a.03, align 1, !dbg !212, !tbaa !205
  %17 = icmp eq i64 %13, 0, !dbg !212
  br i1 %17, label %.loopexit, label %.lr.ph, !dbg !212, !llvm.loop !215

; <label>:18                                      ; preds = %2
  %19 = add i64 %count, -1, !dbg !216
  %20 = icmp eq i64 %count, 0, !dbg !218
  br i1 %20, label %.loopexit, label %.lr.ph9, !dbg !218

.lr.ph9:                                          ; preds = %18
  %21 = getelementptr inbounds i8* %src, i64 %19, !dbg !219
  %22 = getelementptr inbounds i8* %dst, i64 %19, !dbg !216
  %n.vec215 = and i64 %count, -32
  %cmp.zero217 = icmp eq i64 %n.vec215, 0
  br i1 %cmp.zero217, label %middle.block210, label %vector.memcheck224

vector.memcheck224:                               ; preds = %.lr.ph9
  %bound1221 = icmp ule i8* %21, %dst
  %bound0220 = icmp ule i8* %22, %src
  %memcheck.conflict223 = and i1 %bound0220, %bound1221
  %.sum = sub i64 %19, %n.vec215
  %rev.ptr.ind.end = getelementptr i8* %src, i64 %.sum
  %rev.ptr.ind.end229 = getelementptr i8* %dst, i64 %.sum
  %rev.ind.end231 = sub i64 %count, %n.vec215
  br i1 %memcheck.conflict223, label %middle.block210, label %vector.body209

vector.body209:                                   ; preds = %vector.body209, %vector.memcheck224
  %index212 = phi i64 [ %index.next234, %vector.body209 ], [ 0, %vector.memcheck224 ]
  %.sum440 = sub i64 %19, %index212
  %next.gep236.sum = add i64 %.sum440, -15, !dbg !218
  %23 = getelementptr i8* %src, i64 %next.gep236.sum, !dbg !218
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !218
  %wide.load434 = load <16 x i8>* %24, align 1, !dbg !218
  %reverse = shufflevector <16 x i8> %wide.load434, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, !dbg !218
  %.sum505 = add i64 %.sum440, -31, !dbg !218
  %25 = getelementptr i8* %src, i64 %.sum505, !dbg !218
  %26 = bitcast i8* %25 to <16 x i8>*, !dbg !218
  %wide.load435 = load <16 x i8>* %26, align 1, !dbg !218
  %reverse436 = shufflevector <16 x i8> %wide.load435, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, !dbg !218
  %reverse437 = shufflevector <16 x i8> %reverse, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, !dbg !218
  %27 = getelementptr i8* %dst, i64 %next.gep236.sum, !dbg !218
  %28 = bitcast i8* %27 to <16 x i8>*, !dbg !218
  store <16 x i8> %reverse437, <16 x i8>* %28, align 1, !dbg !218
  %reverse438 = shufflevector <16 x i8> %reverse436, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>, !dbg !218
  %29 = getelementptr i8* %dst, i64 %.sum505, !dbg !218
  %30 = bitcast i8* %29 to <16 x i8>*, !dbg !218
  store <16 x i8> %reverse438, <16 x i8>* %30, align 1, !dbg !218
  %index.next234 = add i64 %index212, 32
  %31 = icmp eq i64 %index.next234, %n.vec215
  br i1 %31, label %middle.block210, label %vector.body209, !llvm.loop !220

middle.block210:                                  ; preds = %vector.body209, %vector.memcheck224, %.lr.ph9
  %resume.val225 = phi i8* [ %21, %.lr.ph9 ], [ %21, %vector.memcheck224 ], [ %rev.ptr.ind.end, %vector.body209 ]
  %resume.val227 = phi i8* [ %22, %.lr.ph9 ], [ %22, %vector.memcheck224 ], [ %rev.ptr.ind.end229, %vector.body209 ]
  %resume.val230 = phi i64 [ %count, %.lr.ph9 ], [ %count, %vector.memcheck224 ], [ %rev.ind.end231, %vector.body209 ]
  %new.indc.resume.val232 = phi i64 [ 0, %.lr.ph9 ], [ 0, %vector.memcheck224 ], [ %n.vec215, %vector.body209 ]
  %cmp.n233 = icmp eq i64 %new.indc.resume.val232, %count
  br i1 %cmp.n233, label %.loopexit, label %scalar.ph211

scalar.ph211:                                     ; preds = %scalar.ph211, %middle.block210
  %b.18 = phi i8* [ %33, %scalar.ph211 ], [ %resume.val225, %middle.block210 ]
  %a.17 = phi i8* [ %35, %scalar.ph211 ], [ %resume.val227, %middle.block210 ]
  %.16 = phi i64 [ %32, %scalar.ph211 ], [ %resume.val230, %middle.block210 ]
  %32 = add i64 %.16, -1, !dbg !218
  %33 = getelementptr inbounds i8* %b.18, i64 -1, !dbg !218
  %34 = load i8* %b.18, align 1, !dbg !218, !tbaa !205
  %35 = getelementptr inbounds i8* %a.17, i64 -1, !dbg !218
  store i8 %34, i8* %a.17, align 1, !dbg !218, !tbaa !205
  %36 = icmp eq i64 %32, 0, !dbg !218
  br i1 %36, label %.loopexit, label %scalar.ph211, !dbg !218, !llvm.loop !221

.loopexit:                                        ; preds = %scalar.ph211, %middle.block210, %18, %.lr.ph, %middle.block, %.preheader, %0
  ret i8* %dst, !dbg !222
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @mempcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #4 {
  %1 = icmp eq i64 %len, 0, !dbg !223
  br i1 %1, label %15, label %.lr.ph.preheader, !dbg !223

.lr.ph.preheader:                                 ; preds = %0
  %n.vec = and i64 %len, -32
  %cmp.zero = icmp eq i64 %n.vec, 0
  %2 = add i64 %len, -1
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %.lr.ph.preheader
  %scevgep5 = getelementptr i8* %srcaddr, i64 %2
  %scevgep4 = getelementptr i8* %destaddr, i64 %2
  %bound1 = icmp uge i8* %scevgep4, %srcaddr
  %bound0 = icmp uge i8* %scevgep5, %destaddr
  %memcheck.conflict = and i1 %bound0, %bound1
  %ptr.ind.end = getelementptr i8* %srcaddr, i64 %n.vec
  %ptr.ind.end7 = getelementptr i8* %destaddr, i64 %n.vec
  %rev.ind.end = sub i64 %len, %n.vec
  br i1 %memcheck.conflict, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.memcheck
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.memcheck ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep104 = getelementptr i8* %destaddr, i64 %index
  %3 = bitcast i8* %next.gep to <16 x i8>*, !dbg !224
  %wide.load = load <16 x i8>* %3, align 1, !dbg !224
  %next.gep.sum280 = or i64 %index, 16, !dbg !224
  %4 = getelementptr i8* %srcaddr, i64 %next.gep.sum280, !dbg !224
  %5 = bitcast i8* %4 to <16 x i8>*, !dbg !224
  %wide.load201 = load <16 x i8>* %5, align 1, !dbg !224
  %6 = bitcast i8* %next.gep104 to <16 x i8>*, !dbg !224
  store <16 x i8> %wide.load, <16 x i8>* %6, align 1, !dbg !224
  %7 = getelementptr i8* %destaddr, i64 %next.gep.sum280, !dbg !224
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !224
  store <16 x i8> %wide.load201, <16 x i8>* %8, align 1, !dbg !224
  %index.next = add i64 %index, 32
  %9 = icmp eq i64 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !225

middle.block:                                     ; preds = %vector.body, %vector.memcheck, %.lr.ph.preheader
  %resume.val = phi i8* [ %srcaddr, %.lr.ph.preheader ], [ %srcaddr, %vector.memcheck ], [ %ptr.ind.end, %vector.body ]
  %resume.val6 = phi i8* [ %destaddr, %.lr.ph.preheader ], [ %destaddr, %vector.memcheck ], [ %ptr.ind.end7, %vector.body ]
  %resume.val8 = phi i64 [ %len, %.lr.ph.preheader ], [ %len, %vector.memcheck ], [ %rev.ind.end, %vector.body ]
  %new.indc.resume.val = phi i64 [ 0, %.lr.ph.preheader ], [ 0, %vector.memcheck ], [ %n.vec, %vector.body ]
  %cmp.n = icmp eq i64 %new.indc.resume.val, %len
  br i1 %cmp.n, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph, %middle.block
  %src.03 = phi i8* [ %11, %.lr.ph ], [ %resume.val, %middle.block ]
  %dest.02 = phi i8* [ %13, %.lr.ph ], [ %resume.val6, %middle.block ]
  %.01 = phi i64 [ %10, %.lr.ph ], [ %resume.val8, %middle.block ]
  %10 = add i64 %.01, -1, !dbg !223
  %11 = getelementptr inbounds i8* %src.03, i64 1, !dbg !224
  %12 = load i8* %src.03, align 1, !dbg !224, !tbaa !205
  %13 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !224
  store i8 %12, i8* %dest.02, align 1, !dbg !224, !tbaa !205
  %14 = icmp eq i64 %10, 0, !dbg !223
  br i1 %14, label %._crit_edge, label %.lr.ph, !dbg !223, !llvm.loop !226

._crit_edge:                                      ; preds = %.lr.ph, %middle.block
  %scevgep = getelementptr i8* %destaddr, i64 %len
  br label %15, !dbg !223

; <label>:15                                      ; preds = %._crit_edge, %0
  %dest.0.lcssa = phi i8* [ %scevgep, %._crit_edge ], [ %destaddr, %0 ]
  ret i8* %dest.0.lcssa, !dbg !227
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memset(i8* %dst, i32 %s, i64 %count) #4 {
  %1 = icmp eq i64 %count, 0, !dbg !228
  br i1 %1, label %._crit_edge, label %.lr.ph, !dbg !228

.lr.ph:                                           ; preds = %0
  %2 = trunc i32 %s to i8, !dbg !229
  br label %3, !dbg !228

; <label>:3                                       ; preds = %3, %.lr.ph
  %a.02 = phi i8* [ %dst, %.lr.ph ], [ %5, %3 ]
  %.01 = phi i64 [ %count, %.lr.ph ], [ %4, %3 ]
  %4 = add i64 %.01, -1, !dbg !228
  %5 = getelementptr inbounds i8* %a.02, i64 1, !dbg !229
  store volatile i8 %2, i8* %a.02, align 1, !dbg !229, !tbaa !205
  %6 = icmp eq i64 %4, 0, !dbg !228
  br i1 %6, label %._crit_edge, label %3, !dbg !228

._crit_edge:                                      ; preds = %3, %0
  ret i8* %dst, !dbg !230
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false
attributes #3 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="4" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="4" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="4" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind }
attributes #8 = { nobuiltin nounwind }
attributes #9 = { nobuiltin noreturn nounwind }

!llvm.dbg.cu = !{!0, !16, !29, !40, !54, !66, !79, !97, !112, !127}
!llvm.module.flags = !{!143, !144}
!llvm.ident = !{!145, !145, !145, !145, !145, !145, !145, !145, !145, !145}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG
!1 = metadata !{metadata !"point_struct.c", metadata !"/home/ubuntu/function_pointer"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !9, metadata !13}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"add", metadata !"add", metadata !"", i32 5, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i32)* @add, null, null, metadata !2, i32 6} ; [ DW_TAG_subprogra
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/ubuntu/function_pointer/point_struct.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8, metadata !8, metadata !8}
!8 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!9 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"bar", metadata !"bar", metadata !"", i32 16, metadata !10, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i8*)* @bar, null, null, metadata !2, i32 16} ; [ DW_TAG_subprogram 
!10 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !11, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!11 = metadata !{metadata !8, metadata !12}
!12 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!13 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 30, metadata !14, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @main, null, null, metadata !2, i32 30} ; [ DW_TAG_subprogram ]
!14 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !15, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!15 = metadata !{metadata !8}
!16 = metadata !{i32 786449, metadata !17, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !18, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!17 = metadata !{metadata !"/home/ubuntu/klee/runtime/Intrinsic/klee_choose.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!18 = metadata !{metadata !19}
!19 = metadata !{i32 786478, metadata !20, metadata !21, metadata !"klee_choose", metadata !"klee_choose", metadata !"", i32 12, metadata !22, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i64 (i64)* @klee_choose, null, null, metadata !26, i32
!20 = metadata !{metadata !"klee_choose.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!21 = metadata !{i32 786473, metadata !20}        ; [ DW_TAG_file_type ] [/home/ubuntu/klee/runtime/Intrinsic/klee_choose.c]
!22 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !23, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!23 = metadata !{metadata !24, metadata !24}
!24 = metadata !{i32 786454, metadata !20, null, metadata !"uintptr_t", i32 122, i64 0, i64 0, i64 0, i32 0, metadata !25} ; [ DW_TAG_typedef ] [uintptr_t] [line 122, size 0, align 0, offset 0] [from long unsigned int]
!25 = metadata !{i32 786468, null, null, metadata !"long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!26 = metadata !{metadata !27, metadata !28}
!27 = metadata !{i32 786689, metadata !19, metadata !"n", metadata !21, i32 16777228, metadata !24, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n] [line 12]
!28 = metadata !{i32 786688, metadata !19, metadata !"x", metadata !21, i32 13, metadata !24, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 13]
!29 = metadata !{i32 786449, metadata !30, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !31, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!30 = metadata !{metadata !"/home/ubuntu/klee/runtime/Intrinsic/klee_div_zero_check.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!31 = metadata !{metadata !32}
!32 = metadata !{i32 786478, metadata !33, metadata !34, metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !"", i32 12, metadata !35, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64)* @klee_div_zero_check, null
!33 = metadata !{metadata !"klee_div_zero_check.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!34 = metadata !{i32 786473, metadata !33}        ; [ DW_TAG_file_type ] [/home/ubuntu/klee/runtime/Intrinsic/klee_div_zero_check.c]
!35 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !36, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!36 = metadata !{null, metadata !37}
!37 = metadata !{i32 786468, null, null, metadata !"long long int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [long long int] [line 0, size 64, align 64, offset 0, enc DW_ATE_signed]
!38 = metadata !{metadata !39}
!39 = metadata !{i32 786689, metadata !32, metadata !"z", metadata !34, i32 16777228, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [z] [line 12]
!40 = metadata !{i32 786449, metadata !41, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !42, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!41 = metadata !{metadata !"/home/ubuntu/klee/runtime/Intrinsic/klee_int.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!42 = metadata !{metadata !43}
!43 = metadata !{i32 786478, metadata !44, metadata !45, metadata !"klee_int", metadata !"klee_int", metadata !"", i32 13, metadata !46, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @klee_int, null, null, metadata !51, i32 13} ; [ 
!44 = metadata !{metadata !"klee_int.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!45 = metadata !{i32 786473, metadata !44}        ; [ DW_TAG_file_type ] [/home/ubuntu/klee/runtime/Intrinsic/klee_int.c]
!46 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !47, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!47 = metadata !{metadata !8, metadata !48}
!48 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !49} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!49 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !50} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!50 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!51 = metadata !{metadata !52, metadata !53}
!52 = metadata !{i32 786689, metadata !43, metadata !"name", metadata !45, i32 16777229, metadata !48, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [name] [line 13]
!53 = metadata !{i32 786688, metadata !43, metadata !"x", metadata !45, i32 14, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 14]
!54 = metadata !{i32 786449, metadata !55, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !56, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!55 = metadata !{metadata !"/home/ubuntu/klee/runtime/Intrinsic/klee_overshift_check.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!56 = metadata !{metadata !57}
!57 = metadata !{i32 786478, metadata !58, metadata !59, metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !"", i32 20, metadata !60, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64, i64)* @klee_overshift_che
!58 = metadata !{metadata !"klee_overshift_check.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!59 = metadata !{i32 786473, metadata !58}        ; [ DW_TAG_file_type ] [/home/ubuntu/klee/runtime/Intrinsic/klee_overshift_check.c]
!60 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !61, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!61 = metadata !{null, metadata !62, metadata !62}
!62 = metadata !{i32 786468, null, null, metadata !"long long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!63 = metadata !{metadata !64, metadata !65}
!64 = metadata !{i32 786689, metadata !57, metadata !"bitWidth", metadata !59, i32 16777236, metadata !62, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [bitWidth] [line 20]
!65 = metadata !{i32 786689, metadata !57, metadata !"shift", metadata !59, i32 33554452, metadata !62, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [shift] [line 20]
!66 = metadata !{i32 786449, metadata !67, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !68, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!67 = metadata !{metadata !"/home/ubuntu/klee/runtime/Intrinsic/klee_range.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!68 = metadata !{metadata !69}
!69 = metadata !{i32 786478, metadata !70, metadata !71, metadata !"klee_range", metadata !"klee_range", metadata !"", i32 13, metadata !72, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, i8*)* @klee_range, null, null, metadata !
!70 = metadata !{metadata !"klee_range.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!71 = metadata !{i32 786473, metadata !70}        ; [ DW_TAG_file_type ] [/home/ubuntu/klee/runtime/Intrinsic/klee_range.c]
!72 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !73, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!73 = metadata !{metadata !8, metadata !8, metadata !8, metadata !48}
!74 = metadata !{metadata !75, metadata !76, metadata !77, metadata !78}
!75 = metadata !{i32 786689, metadata !69, metadata !"start", metadata !71, i32 16777229, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [start] [line 13]
!76 = metadata !{i32 786689, metadata !69, metadata !"end", metadata !71, i32 33554445, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [end] [line 13]
!77 = metadata !{i32 786689, metadata !69, metadata !"name", metadata !71, i32 50331661, metadata !48, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [name] [line 13]
!78 = metadata !{i32 786688, metadata !69, metadata !"x", metadata !71, i32 14, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 14]
!79 = metadata !{i32 786449, metadata !80, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !81, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!80 = metadata !{metadata !"/home/ubuntu/klee/runtime/Intrinsic/memcpy.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!81 = metadata !{metadata !82}
!82 = metadata !{i32 786478, metadata !83, metadata !84, metadata !"memcpy", metadata !"memcpy", metadata !"", i32 12, metadata !85, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @memcpy, null, null, metadata !90, i32 12} 
!83 = metadata !{metadata !"memcpy.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!84 = metadata !{i32 786473, metadata !83}        ; [ DW_TAG_file_type ] [/home/ubuntu/klee/runtime/Intrinsic/memcpy.c]
!85 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !86, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!86 = metadata !{metadata !12, metadata !12, metadata !87, metadata !89}
!87 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !88} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!88 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!89 = metadata !{i32 786454, metadata !83, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !25} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from long unsigned int]
!90 = metadata !{metadata !91, metadata !92, metadata !93, metadata !94, metadata !96}
!91 = metadata !{i32 786689, metadata !82, metadata !"destaddr", metadata !84, i32 16777228, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [destaddr] [line 12]
!92 = metadata !{i32 786689, metadata !82, metadata !"srcaddr", metadata !84, i32 33554444, metadata !87, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcaddr] [line 12]
!93 = metadata !{i32 786689, metadata !82, metadata !"len", metadata !84, i32 50331660, metadata !89, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [len] [line 12]
!94 = metadata !{i32 786688, metadata !82, metadata !"dest", metadata !84, i32 13, metadata !95, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dest] [line 13]
!95 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !50} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!96 = metadata !{i32 786688, metadata !82, metadata !"src", metadata !84, i32 14, metadata !48, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 14]
!97 = metadata !{i32 786449, metadata !98, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !99, metadata !2, metadata !2, metadata !""} ; [ DW_TA
!98 = metadata !{metadata !"/home/ubuntu/klee/runtime/Intrinsic/memmove.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!99 = metadata !{metadata !100}
!100 = metadata !{i32 786478, metadata !101, metadata !102, metadata !"memmove", metadata !"memmove", metadata !"", i32 12, metadata !103, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @memmove, null, null, metadata !106, 
!101 = metadata !{metadata !"memmove.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!102 = metadata !{i32 786473, metadata !101}      ; [ DW_TAG_file_type ] [/home/ubuntu/klee/runtime/Intrinsic/memmove.c]
!103 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !104, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!104 = metadata !{metadata !12, metadata !12, metadata !87, metadata !105}
!105 = metadata !{i32 786454, metadata !101, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !25} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from long unsigned int]
!106 = metadata !{metadata !107, metadata !108, metadata !109, metadata !110, metadata !111}
!107 = metadata !{i32 786689, metadata !100, metadata !"dst", metadata !102, i32 16777228, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dst] [line 12]
!108 = metadata !{i32 786689, metadata !100, metadata !"src", metadata !102, i32 33554444, metadata !87, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [src] [line 12]
!109 = metadata !{i32 786689, metadata !100, metadata !"count", metadata !102, i32 50331660, metadata !105, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 12]
!110 = metadata !{i32 786688, metadata !100, metadata !"a", metadata !102, i32 13, metadata !95, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 13]
!111 = metadata !{i32 786688, metadata !100, metadata !"b", metadata !102, i32 14, metadata !48, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [b] [line 14]
!112 = metadata !{i32 786449, metadata !113, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !114, metadata !2, metadata !2, metadata !""} ; [ DW
!113 = metadata !{metadata !"/home/ubuntu/klee/runtime/Intrinsic/mempcpy.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!114 = metadata !{metadata !115}
!115 = metadata !{i32 786478, metadata !116, metadata !117, metadata !"mempcpy", metadata !"mempcpy", metadata !"", i32 11, metadata !118, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @mempcpy, null, null, metadata !121, 
!116 = metadata !{metadata !"mempcpy.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!117 = metadata !{i32 786473, metadata !116}      ; [ DW_TAG_file_type ] [/home/ubuntu/klee/runtime/Intrinsic/mempcpy.c]
!118 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !119, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!119 = metadata !{metadata !12, metadata !12, metadata !87, metadata !120}
!120 = metadata !{i32 786454, metadata !116, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !25} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from long unsigned int]
!121 = metadata !{metadata !122, metadata !123, metadata !124, metadata !125, metadata !126}
!122 = metadata !{i32 786689, metadata !115, metadata !"destaddr", metadata !117, i32 16777227, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [destaddr] [line 11]
!123 = metadata !{i32 786689, metadata !115, metadata !"srcaddr", metadata !117, i32 33554443, metadata !87, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcaddr] [line 11]
!124 = metadata !{i32 786689, metadata !115, metadata !"len", metadata !117, i32 50331659, metadata !120, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [len] [line 11]
!125 = metadata !{i32 786688, metadata !115, metadata !"dest", metadata !117, i32 12, metadata !95, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dest] [line 12]
!126 = metadata !{i32 786688, metadata !115, metadata !"src", metadata !117, i32 13, metadata !48, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 13]
!127 = metadata !{i32 786449, metadata !128, i32 1, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !129, metadata !2, metadata !2, metadata !""} ; [ DW
!128 = metadata !{metadata !"/home/ubuntu/klee/runtime/Intrinsic/memset.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!129 = metadata !{metadata !130}
!130 = metadata !{i32 786478, metadata !131, metadata !132, metadata !"memset", metadata !"memset", metadata !"", i32 11, metadata !133, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i32, i64)* @memset, null, null, metadata !136, i32
!131 = metadata !{metadata !"memset.c", metadata !"/home/ubuntu/klee/runtime/Intrinsic"}
!132 = metadata !{i32 786473, metadata !131}      ; [ DW_TAG_file_type ] [/home/ubuntu/klee/runtime/Intrinsic/memset.c]
!133 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !134, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!134 = metadata !{metadata !12, metadata !12, metadata !8, metadata !135}
!135 = metadata !{i32 786454, metadata !131, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !25} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from long unsigned int]
!136 = metadata !{metadata !137, metadata !138, metadata !139, metadata !140}
!137 = metadata !{i32 786689, metadata !130, metadata !"dst", metadata !132, i32 16777227, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dst] [line 11]
!138 = metadata !{i32 786689, metadata !130, metadata !"s", metadata !132, i32 33554443, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [s] [line 11]
!139 = metadata !{i32 786689, metadata !130, metadata !"count", metadata !132, i32 50331659, metadata !135, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 11]
!140 = metadata !{i32 786688, metadata !130, metadata !"a", metadata !132, i32 12, metadata !141, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 12]
!141 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !142} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!142 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !50} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from char]
!143 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!144 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!145 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!146 = metadata !{i32 7, i32 0, metadata !4, null}
!147 = metadata !{i32 17, i32 0, metadata !9, null}
!148 = metadata !{i32 18, i32 0, metadata !9, null}
!149 = metadata !{i32 19, i32 0, metadata !9, null}
!150 = metadata !{i32 21, i32 0, metadata !151, null}
!151 = metadata !{i32 786443, metadata !1, metadata !9, i32 21, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/ubuntu/function_pointer/point_struct.c]
!152 = metadata !{i32 22, i32 0, metadata !153, null}
!153 = metadata !{i32 786443, metadata !1, metadata !151, i32 21, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/ubuntu/function_pointer/point_struct.c]
!154 = metadata !{i32 25, i32 0, metadata !155, null}
!155 = metadata !{i32 786443, metadata !1, metadata !151, i32 24, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/ubuntu/function_pointer/point_struct.c]
!156 = metadata !{i32 27, i32 0, metadata !9, null}
!157 = metadata !{i32 31, i32 0, metadata !13, null}
!158 = metadata !{i32 32, i32 0, metadata !13, null}
!159 = metadata !{i32 33, i32 0, metadata !13, null}
!160 = metadata !{i32 34, i32 0, metadata !13, null}
!161 = metadata !{i32 14, i32 0, metadata !19, null}
!162 = metadata !{i32 17, i32 0, metadata !163, null}
!163 = metadata !{i32 786443, metadata !20, metadata !19, i32 17, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_choose.c]
!164 = metadata !{metadata !165, metadata !165, i64 0}
!165 = metadata !{metadata !"long", metadata !166, i64 0}
!166 = metadata !{metadata !"omnipotent char", metadata !167, i64 0}
!167 = metadata !{metadata !"Simple C/C++ TBAA"}
!168 = metadata !{i32 18, i32 0, metadata !163, null}
!169 = metadata !{i32 19, i32 0, metadata !19, null}
!170 = metadata !{i32 13, i32 0, metadata !171, null}
!171 = metadata !{i32 786443, metadata !33, metadata !32, i32 13, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_div_zero_check.c]
!172 = metadata !{i32 14, i32 0, metadata !171, null}
!173 = metadata !{i32 15, i32 0, metadata !32, null}
!174 = metadata !{i32 15, i32 0, metadata !43, null}
!175 = metadata !{i32 16, i32 0, metadata !43, null}
!176 = metadata !{metadata !177, metadata !177, i64 0}
!177 = metadata !{metadata !"int", metadata !166, i64 0}
!178 = metadata !{i32 21, i32 0, metadata !179, null}
!179 = metadata !{i32 786443, metadata !58, metadata !57, i32 21, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_overshift_check.c]
!180 = metadata !{i32 27, i32 0, metadata !181, null}
!181 = metadata !{i32 786443, metadata !58, metadata !179, i32 21, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_overshift_check.c]
!182 = metadata !{i32 29, i32 0, metadata !57, null}
!183 = metadata !{i32 16, i32 0, metadata !184, null}
!184 = metadata !{i32 786443, metadata !70, metadata !69, i32 16, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_range.c]
!185 = metadata !{i32 17, i32 0, metadata !184, null}
!186 = metadata !{i32 19, i32 0, metadata !187, null}
!187 = metadata !{i32 786443, metadata !70, metadata !69, i32 19, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_range.c]
!188 = metadata !{i32 22, i32 0, metadata !189, null}
!189 = metadata !{i32 786443, metadata !70, metadata !187, i32 21, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_range.c]
!190 = metadata !{i32 25, i32 0, metadata !191, null}
!191 = metadata !{i32 786443, metadata !70, metadata !189, i32 25, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_range.c]
!192 = metadata !{i32 26, i32 0, metadata !193, null}
!193 = metadata !{i32 786443, metadata !70, metadata !191, i32 25, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_range.c]
!194 = metadata !{i32 27, i32 0, metadata !193, null}
!195 = metadata !{i32 28, i32 0, metadata !196, null}
!196 = metadata !{i32 786443, metadata !70, metadata !191, i32 27, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/klee_range.c]
!197 = metadata !{i32 29, i32 0, metadata !196, null}
!198 = metadata !{i32 32, i32 0, metadata !189, null}
!199 = metadata !{i32 34, i32 0, metadata !69, null}
!200 = metadata !{i32 16, i32 0, metadata !82, null}
!201 = metadata !{i32 17, i32 0, metadata !82, null}
!202 = metadata !{metadata !202, metadata !203, metadata !204}
!203 = metadata !{metadata !"llvm.vectorizer.width", i32 1}
!204 = metadata !{metadata !"llvm.vectorizer.unroll", i32 1}
!205 = metadata !{metadata !166, metadata !166, i64 0}
!206 = metadata !{metadata !206, metadata !203, metadata !204}
!207 = metadata !{i32 18, i32 0, metadata !82, null}
!208 = metadata !{i32 16, i32 0, metadata !209, null}
!209 = metadata !{i32 786443, metadata !101, metadata !100, i32 16, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/memmove.c]
!210 = metadata !{i32 19, i32 0, metadata !211, null}
!211 = metadata !{i32 786443, metadata !101, metadata !100, i32 19, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/memmove.c]
!212 = metadata !{i32 20, i32 0, metadata !213, null}
!213 = metadata !{i32 786443, metadata !101, metadata !211, i32 19, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/memmove.c]
!214 = metadata !{metadata !214, metadata !203, metadata !204}
!215 = metadata !{metadata !215, metadata !203, metadata !204}
!216 = metadata !{i32 22, i32 0, metadata !217, null}
!217 = metadata !{i32 786443, metadata !101, metadata !211, i32 21, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/ubuntu/klee/runtime/Intrinsic/memmove.c]
!218 = metadata !{i32 24, i32 0, metadata !217, null}
!219 = metadata !{i32 23, i32 0, metadata !217, null}
!220 = metadata !{metadata !220, metadata !203, metadata !204}
!221 = metadata !{metadata !221, metadata !203, metadata !204}
!222 = metadata !{i32 28, i32 0, metadata !100, null}
!223 = metadata !{i32 15, i32 0, metadata !115, null}
!224 = metadata !{i32 16, i32 0, metadata !115, null}
!225 = metadata !{metadata !225, metadata !203, metadata !204}
!226 = metadata !{metadata !226, metadata !203, metadata !204}
!227 = metadata !{i32 17, i32 0, metadata !115, null}
!228 = metadata !{i32 13, i32 0, metadata !130, null}
!229 = metadata !{i32 14, i32 0, metadata !130, null}
!230 = metadata !{i32 15, i32 0, metadata !130, null}
