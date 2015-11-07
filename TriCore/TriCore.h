//=-- TriCore.h - Top-level interface for TriCore representation --*- C++ -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the entry points for global functions defined in the LLVM
// TriCore back-end.
//
//===----------------------------------------------------------------------===//

#ifndef TARGET_TriCore_H
#define TARGET_TriCore_H

#include "MCTargetDesc/TriCoreMCTargetDesc.h"
#include "llvm/Target/TargetMachine.h"


namespace TriCoreCC {
  // TriCore specific condition code.
  enum CondCodes {
    COND_E  = 0,  // aka COND_Z
    COND_NE = 1,  // aka COND_NZ
    COND_HS = 2,  // aka COND_C
    COND_LO = 3,  // aka COND_NC
    COND_GE = 4,
    COND_L  = 5,

    COND_INVALID = -1
  };

}


namespace llvm {
class TargetMachine;
class TriCoreTargetMachine;

FunctionPass *createTriCoreISelDag(TriCoreTargetMachine &TM,
                               CodeGenOpt::Level OptLevel);
} // end namespace llvm;

#endif
