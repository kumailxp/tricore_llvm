//=-- TriCoreFrameLowering.cpp - Frame info for TriCore Target ------------===//
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

#include "TriCoreFrameLowering.h"
#include "TriCore.h"
#include "TriCoreInstrInfo.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Target/TargetLowering.h"
#include "llvm/Target/TargetOptions.h"
#include <algorithm> // std::sort

using namespace llvm;

//===----------------------------------------------------------------------===//
// TriCoreFrameLowering:
//===----------------------------------------------------------------------===//
TriCoreFrameLowering::TriCoreFrameLowering()
    : TargetFrameLowering(TargetFrameLowering::StackGrowsDown, 4, 0) {
  // Do nothing
}


bool TriCoreFrameLowering::hasFP(const MachineFunction &MF) const {

	const MachineFrameInfo *MFI = MF.getFrameInfo();

  return MF.getTarget().Options.DisableFramePointerElim(MF) ||
         MF.getFrameInfo()->hasVarSizedObjects() ||
				 MFI->isFrameAddressTaken();
}


uint64_t TriCoreFrameLowering::computeStackSize(MachineFunction &MF) const {
  MachineFrameInfo *MFI = MF.getFrameInfo();
  uint64_t StackSize = MFI->getStackSize();
  unsigned StackAlign = getStackAlignment();
  if (StackAlign > 0) {
    StackSize = RoundUpToAlignment(StackSize, StackAlign);
  }
  return StackSize;
}

// Materialize an offset for a ADD/SUB stack operation.
// Return zero if the offset fits into the instruction as an immediate,
// or the number of the register where the offset is materialized.
static unsigned materializeOffset(MachineFunction &MF, MachineBasicBlock &MBB,
                                  MachineBasicBlock::iterator MBBI,
                                  unsigned Offset) {
  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
  DebugLoc dl = MBBI != MBB.end() ? MBBI->getDebugLoc() : DebugLoc();
  const uint64_t MaxSubImm = 0xfff;
  const TargetFrameLowering *TFI = MF.getSubtarget().getFrameLowering();

  if (TFI->hasFP(MF))
  	outs()<<"Frame Taken!!\n";



  if (Offset <= MaxSubImm) {
    // The stack offset fits in the ADD/SUB instruction.
    return 0;
  } else {
    // The stack offset does not fit in the ADD/SUB instruction.
    // Materialize the offset using MOVLO/MOVHI.
    unsigned OffsetReg = TriCore::A14;
    unsigned OffsetLo = (unsigned)(Offset & 0xffff);
    unsigned OffsetHi = (unsigned)((Offset & 0xffff0000) >> 16);
    BuildMI(MBB, MBBI, dl, TII.get(TriCore::MOVrlc), OffsetReg) //MOVLOi16
        .addImm(OffsetLo)
        .setMIFlag(MachineInstr::FrameSetup);
    if (OffsetHi) {
      BuildMI(MBB, MBBI, dl, TII.get(TriCore::MOVHIi16), OffsetReg)
          .addReg(OffsetReg)
          .addImm(OffsetHi)
          .setMIFlag(MachineInstr::FrameSetup);
    }
    return OffsetReg;
  }
}

//////////////////////////////////////////////////////////

//- Must have, hasFP() is pure virtual of parent
// hasFP - Return true if the specified function should have a dedicated frame
// pointer register.  This is true if the function has variable sized allocas or
// if frame pointer elimination is disabled.
//bool TriCoreFrameLowering::hasFP(const MachineFunction &MF) const {
//  const MachineFrameInfo *MFI = MF.getFrameInfo();
//  return MF.getTarget().Options.DisableFramePointerElim(MF) ||
//      MFI->hasVarSizedObjects() || MFI->isFrameAddressTaken();
//}
/////////////////////////////////////////////////////////



void TriCoreFrameLowering::emitPrologue(MachineFunction &MF,
                                       MachineBasicBlock &MBB) const {
  assert(&MF.front() == &MBB && "Shrink-wrapping not yet supported");
  MachineFrameInfo *MFI = MF.getFrameInfo();
  const TriCoreInstrInfo &TII =
      *static_cast<const TriCoreInstrInfo *>(MF.getSubtarget().getInstrInfo());

  MachineBasicBlock::iterator MBBI = MBB.begin();
  DebugLoc DL = MBBI != MBB.end() ? MBBI->getDebugLoc() : DebugLoc();

  // Get the number of bytes to allocate from the FrameInfo.
  uint64_t StackSize = MFI->getStackSize();

  uint64_t NumBytes = 0;
  if (hasFP(MF)) {
    // Calculate required stack adjustment
//    uint64_t FrameSize = StackSize - 2;
//    NumBytes = FrameSize - MSP430FI->getCalleeSavedFrameSize();

    uint64_t FrameSize = StackSize;
		NumBytes = FrameSize;

    // Get the offset of the stack slot for the EBP register... which is
    // guaranteed to be the last slot by processFunctionBeforeFrameFinalized.
    // Update the frame offset adjustment.
    MFI->setOffsetAdjustment(-NumBytes);


    // Update FP with the new base value...
    BuildMI(MBB, MBBI, DL, TII.get(TriCore::MOVAArr), TriCore::A14)
      .addReg(TriCore::A10);

    // Mark the FramePtr as live-in in every block except the entry.
    for (MachineFunction::iterator I = std::next(MF.begin()), E = MF.end();
         I != E; ++I)
      I->addLiveIn(TriCore::A14);

  } else
  	 NumBytes = StackSize;
//    NumBytes = StackSize - MSP430FI->getCalleeSavedFrameSize();

  // Skip the callee-saved push instructions.
//  while (MBBI != MBB.end() && (MBBI->getOpcode() == MSP430::PUSH16r))
//    ++MBBI;

  if (MBBI != MBB.end())
    DL = MBBI->getDebugLoc();

  if (NumBytes) { // adjust stack pointer: SP -= numbytes
    // If there is an SUB16ri of SP immediately before this instruction, merge
    // the two.
    //NumBytes -= mergeSPUpdates(MBB, MBBI, true);
    // If there is an ADD16ri or SUB16ri of SP immediately after this
    // instruction, merge the two instructions.
    // mergeSPUpdatesDown(MBB, MBBI, &NumBytes);

    if (NumBytes) {
       BuildMI(MBB, MBBI, DL, TII.get(TriCore::SUBAsc)).addImm(NumBytes);

    }
  }
}

void TriCoreFrameLowering::emitEpilogue(MachineFunction &MF,
                                    MachineBasicBlock &MBB) const {
  // Compute the stack size, to determine if we need an epilogue at all.
//  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
//  MachineBasicBlock::iterator MBBI = MBB.getLastNonDebugInstr();
//  DebugLoc dl = MBBI->getDebugLoc();
//  uint64_t StackSize = computeStackSize(MF);
//  outs() << "emitEpilogue start\n";
//  if (!StackSize) {
//    return;
//  }
//
//  outs() << "emitEpilogue start\n";
//
//  // Restore the stack pointer to what it was at the beginning of the function.
//  unsigned StackReg = TriCore::A10;
//  unsigned OffsetReg = materializeOffset(MF, MBB, MBBI, (unsigned)StackSize);
//  if (OffsetReg) {
//    BuildMI(MBB, MBBI, dl, TII.get(TriCore::ADDrr), StackReg)
//        .addReg(StackReg)
//        .addReg(OffsetReg)
//        .setMIFlag(MachineInstr::FrameSetup);
//  } else {
//    BuildMI(MBB, MBBI, dl, TII.get(TriCore::ADDri), StackReg)
//        .addReg(StackReg)
//        .addImm(StackSize)
//        .setMIFlag(MachineInstr::FrameSetup);
//  }
//
//  outs() << "emitEpilogue ends\n";

}

// This function eliminates ADJCALLSTACKDOWN, ADJCALLSTACKUP pseudo
// instructions
void TriCoreFrameLowering::eliminateCallFramePseudoInstr(
    MachineFunction &MF, MachineBasicBlock &MBB,
    MachineBasicBlock::iterator I) const {
  if (I->getOpcode() == TriCore::ADJCALLSTACKUP ||
      I->getOpcode() == TriCore::ADJCALLSTACKDOWN) {
    MBB.erase(I);
  }
  return;
}
