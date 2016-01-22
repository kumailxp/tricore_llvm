//==-- TriCoreSubtarget.cpp - TriCore Subtarget Information ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the TriCore specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "TriCoreSubtarget.h"
#include "TriCore.h"
#include "llvm/Support/TargetRegistry.h"

#define DEBUG_TYPE "leg-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "TriCoreGenSubtargetInfo.inc"

using namespace llvm;

void TriCoreSubtarget::anchor() {}

static cl::opt<bool> UseSmallSectionOpt
                ("tricore-use-small-section", cl::Hidden, cl::init(false),
                 cl::desc("Use small section. Only work when -relocation-model="
                 "static. pic always not use small section."));

TriCoreSubtarget::TriCoreSubtarget(const Triple &TT, StringRef CPU, StringRef FS,
                           TriCoreTargetMachine &TM)
    : TriCoreGenSubtargetInfo(TT, CPU, FS),
      DL("e-m:e-p:32:32-i64:32-a:0:32-n32"),
      InstrInfo(), TLInfo(TM), TSInfo(), FrameLowering() {

	 UseSmallSection = UseSmallSectionOpt;

}
