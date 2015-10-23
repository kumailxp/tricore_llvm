//=-- TriCoreSubtarget.h - Define Subtarget for the TriCore -------*- C++ -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the TriCore specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef TriCoreSUBTARGET_H
#define TriCoreSUBTARGET_H

#include "TriCore.h"
#include "TriCoreFrameLowering.h"
#include "TriCoreISelLowering.h"
#include "TriCoreInstrInfo.h"
#include "TriCoreSelectionDAGInfo.h"
#include "TriCoreSubtarget.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetSubtargetInfo.h"
#include <string>

#define GET_SUBTARGETINFO_HEADER
#include "TriCoreGenSubtargetInfo.inc"

namespace llvm {
class StringRef;

class TriCoreSubtarget : public TriCoreGenSubtargetInfo {
  virtual void anchor();

private:
  const DataLayout DL;       // Calculates type size & alignment.
  TriCoreInstrInfo InstrInfo;
  TriCoreTargetLowering TLInfo;
  TriCoreSelectionDAGInfo TSInfo;
  TriCoreFrameLowering FrameLowering;
  InstrItineraryData InstrItins;

public:
  /// This constructor initializes the data members to match that
  /// of the specified triple.
  ///
  TriCoreSubtarget(const Triple &TT, StringRef CPU,
               StringRef FS, TriCoreTargetMachine &TM);

  /// getInstrItins - Return the instruction itineraries based on subtarget
  /// selection.
  const InstrItineraryData *getInstrItineraryData() const override {
    return &InstrItins;
  }
  const TriCoreInstrInfo *getInstrInfo() const override { return &InstrInfo; }
  const TriCoreRegisterInfo *getRegisterInfo() const override {
    return &InstrInfo.getRegisterInfo();
  }
  const TriCoreTargetLowering *getTargetLowering() const override {
    return &TLInfo;
  }
  const TriCoreFrameLowering *getFrameLowering() const override {
    return &FrameLowering;
  }
  const TriCoreSelectionDAGInfo *getSelectionDAGInfo() const override {
    return &TSInfo;
  }

  /// ParseSubtargetFeatures - Parses features string setting specified
  /// subtarget options.  Definition of function is auto generated by tblgen.
  void ParseSubtargetFeatures(StringRef CPU, StringRef FS);
};
} // End llvm namespace

#endif

