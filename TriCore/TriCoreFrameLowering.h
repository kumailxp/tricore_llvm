//==-- TriCoreFrameLowering.h - Frame info for TriCore Target ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains TriCore frame information that doesn't fit anywhere else
// cleanly...
//
//===----------------------------------------------------------------------===//

#ifndef TriCoreFRAMEINFO_H
#define TriCoreFRAMEINFO_H

#include "llvm/Target/TargetFrameLowering.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
class TriCoreSubtarget;

class TriCoreFrameLowering : public TargetFrameLowering {
public:
  TriCoreFrameLowering();

  /// emitProlog/emitEpilog - These methods insert prolog and epilog code into
  /// the function.
  void emitPrologue(MachineFunction &MF,
                    MachineBasicBlock &MBB) const override;

  void emitEpilogue(MachineFunction &MF,
                              MachineBasicBlock &MBB) const override;

  void eliminateCallFramePseudoInstr(MachineFunction &MF,
                                     MachineBasicBlock &MBB,
                                     MachineBasicBlock::iterator I)
                                     const override;

  bool hasFP(const MachineFunction &MF) const;

  //! Stack slot size (4 bytes)
  static int stackSlotSize() { return 8; }

private:
  uint64_t computeStackSize(MachineFunction &MF) const;
};
}

#endif // TriCoreFRAMEINFO_H

