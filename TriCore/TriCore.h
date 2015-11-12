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

namespace llvm {
class TargetMachine;
class TriCoreTargetMachine;

FunctionPass *createTriCoreISelDag(TriCoreTargetMachine &TM,
                               CodeGenOpt::Level OptLevel);
} // end namespace llvm;

#endif
