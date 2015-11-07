//===-- TriCoreInstrInfo.cpp - TriCore Instruction Information ------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the TriCore implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "TriCoreInstrInfo.h"
#include "TriCore.h"
#include "TriCoreMachineFunctionInfo.h"
#include "MCTargetDesc/TriCoreBaseInfo.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/MC/MCContext.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

#define GET_INSTRINFO_CTOR_DTOR
#include "TriCoreGenInstrInfo.inc"

using namespace llvm;

// Pin the vtable to this file.
void TriCoreInstrInfo::anchor() {}

TriCoreInstrInfo::TriCoreInstrInfo()
  : TriCoreGenInstrInfo(TriCore::ADJCALLSTACKDOWN, TriCore::ADJCALLSTACKUP),
    RI() {
}

/// isLoadFromStackSlot - If the specified machine instruction is a direct
/// load from a stack slot, return the virtual or physical register number of
/// the destination along with the FrameIndex of the loaded stack slot.  If
/// not, return 0.  This predicate must return 0 if the instruction has
/// any side effects other than loading from the stack slot.
unsigned
TriCoreInstrInfo::isLoadFromStackSlot(const MachineInstr *MI, int &FrameIndex) const{
  assert(0 && "Unimplemented");
  return 0;
}
  
  /// isStoreToStackSlot - If the specified machine instruction is a direct
  /// store to a stack slot, return the virtual or physical register number of
  /// the source reg along with the FrameIndex of the loaded stack slot.  If
  /// not, return 0.  This predicate must return 0 if the instruction has
  /// any side effects other than storing to the stack slot.
unsigned
TriCoreInstrInfo::isStoreToStackSlot(const MachineInstr *MI,
                                   int &FrameIndex) const {
  assert(0 && "Unimplemented");
  return 0;
}

void TriCoreInstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                                 MachineBasicBlock::iterator I, DebugLoc DL,
                                 unsigned DestReg, unsigned SrcReg,
                                 bool KillSrc) const {
//  BuildMI(MBB, I, I->getDebugLoc(), get(TriCore::MOVrr), DestReg) //MOVrr
//      .addReg(SrcReg, getKillRegState(KillSrc));


	bool DataRegsDest = TriCore::DataRegsRegClass.contains(DestReg);
	bool DataRegsSrc = TriCore::DataRegsRegClass.contains(SrcReg);

	if (DataRegsDest && DataRegsSrc) {
		BuildMI(MBB, I, DL, get(TriCore::MOVrr), DestReg)
									.addReg(SrcReg, getKillRegState(KillSrc));
		return;
	}

	bool AddrDest = TriCore::AddrRegsOthersRegClass.contains(DestReg);
	bool AddrSrc = TriCore::AddrRegsOthersRegClass.contains(SrcReg);

	unsigned Opc = 0;
	if (DataRegsDest && AddrSrc)
		Opc = TriCore::MOVdRR;
	else if (AddrDest && DataRegsSrc)
		Opc = TriCore::MOVaRR;
	else if (AddrDest && AddrSrc)
		Opc = TriCore::MOVaaRR;

	if (Opc) {
		MachineInstrBuilder MIB = BuildMI(MBB, I, DL, get(Opc), DestReg);
		MIB.addReg(SrcReg, getKillRegState(KillSrc));
		return;
	}

}

void TriCoreInstrInfo::storeRegToStackSlot(MachineBasicBlock &MBB,
                                         MachineBasicBlock::iterator I,
                                         unsigned SrcReg, bool isKill,
                                         int FrameIndex,
                                         const TargetRegisterClass *RC,
                                         const TargetRegisterInfo *TRI) const
{
  BuildMI(MBB, I, I->getDebugLoc(), get(TriCore::STR))
    .addReg(SrcReg, getKillRegState(isKill))
    .addFrameIndex(FrameIndex).addImm(0);
}

void TriCoreInstrInfo::loadRegFromStackSlot(MachineBasicBlock &MBB,
                                          MachineBasicBlock::iterator I,
                                          unsigned DestReg, int FrameIndex,
                                          const TargetRegisterClass *RC,
                                          const TargetRegisterInfo *TRI) const
{
  BuildMI(MBB, I, I->getDebugLoc(), get(TriCore::LDR), DestReg)
      .addFrameIndex(FrameIndex).addImm(0);
}

//Branch Analysis

unsigned TriCoreInstrInfo::RemoveBranch(MachineBasicBlock &MBB) const {
  MachineBasicBlock::iterator I = MBB.end();
  unsigned Count = 0;

  while (I != MBB.begin()) {
    --I;
    if (I->isDebugValue())
      continue;
    if (I->getOpcode() != TriCore::JMP &&
        I->getOpcode() != TriCore::JCC)
      break;
    // Remove the branch.
    I->eraseFromParent();
    I = MBB.end();
    ++Count;
  }

  return Count;
}


bool TriCoreInstrInfo::AnalyzeBranch(MachineBasicBlock &MBB,
                                    MachineBasicBlock *&TBB,
                                    MachineBasicBlock *&FBB,
                                    SmallVectorImpl<MachineOperand> &Cond,
                                    bool AllowModify) const {
  // Start from the bottom of the block and work up, examining the
  // terminator instructions.
  MachineBasicBlock::iterator I = MBB.end();
  while (I != MBB.begin()) {
    --I;
    if (I->isDebugValue())
      continue;

    // Working from the bottom, when we see a non-terminator
    // instruction, we're done.
    if (!isUnpredicatedTerminator(I))
      break;

    // A terminator that isn't a branch can't easily be handled
    // by this analysis.
    if (!I->isBranch())
      return true;

//    // Cannot handle indirect branches.
//    if (I->getOpcode() == MSP430::Br ||
//        I->getOpcode() == MSP430::Bm)
//      return true;

    // Handle unconditional branches.
    if (I->getOpcode() == TriCore::JMP) {
      if (!AllowModify) {
        TBB = I->getOperand(0).getMBB();
        continue;
      }

      // If the block has any instructions after a JMP, delete them.
      while (std::next(I) != MBB.end())
        std::next(I)->eraseFromParent();
      Cond.clear();
      FBB = nullptr;

      // Delete the JMP if it's equivalent to a fall-through.
      if (MBB.isLayoutSuccessor(I->getOperand(0).getMBB())) {
        TBB = nullptr;
        I->eraseFromParent();
        I = MBB.end();
        continue;
      }

      // TBB is used to indicate the unconditional destination.
      TBB = I->getOperand(0).getMBB();
      continue;
    }

    // Handle conditional branches.
    assert(I->getOpcode() == TriCore::JCC && "Invalid conditional branch");
    TriCoreCC::CondCodes BranchCode =
      static_cast<TriCoreCC::CondCodes>(I->getOperand(1).getImm());
    if (BranchCode == TriCoreCC::COND_INVALID)
      return true;  // Can't handle weird stuff.

    // Working from the bottom, handle the first conditional branch.
    if (Cond.empty()) {
      FBB = TBB;
      TBB = I->getOperand(0).getMBB();
      Cond.push_back(MachineOperand::CreateImm(BranchCode));
      continue;
    }

    // Handle subsequent conditional branches. Only handle the case where all
    // conditional branches branch to the same destination.
    assert(Cond.size() == 1);
    assert(TBB);

    // Only handle the case where all conditional branches branch to
    // the same destination.
    if (TBB != I->getOperand(0).getMBB())
      return true;

    //TriCoreCC::CondCodes OldBranchCode = (TriCoreCC::CondCodes)Cond[0].getImm();
    ISD::CondCode OldBranchCode = (ISD::CondCode)Cond[0].getImm();
    // If the conditions are the same, we can leave them alone.
    if (OldBranchCode == BranchCode)
      continue;

    return true;
  }

  return false;
}

unsigned
TriCoreInstrInfo::InsertBranch(MachineBasicBlock &MBB, MachineBasicBlock *TBB,
                              MachineBasicBlock *FBB,
                              ArrayRef<MachineOperand> Cond,
                              DebugLoc DL) const {
  // Shouldn't be a fall through.
  assert(TBB && "InsertBranch must not be told to insert a fallthrough");
  assert((Cond.size() == 1 || Cond.size() == 0) &&
         "MSP430 branch conditions have one component!");

  if (Cond.empty()) {
    // Unconditional branch?
    assert(!FBB && "Unconditional branch with multiple successors!");
    BuildMI(&MBB, DL, get(TriCore::JMP)).addMBB(TBB);
    return 1;
  }

  // Conditional branch.
  unsigned Count = 0;
  BuildMI(&MBB, DL, get(TriCore::JCC)).addMBB(TBB).addImm(Cond[0].getImm());
  ++Count;

  if (FBB) {
    // Two-way Conditional branch. Insert the second branch.
    BuildMI(&MBB, DL, get(TriCore::JMP)).addMBB(FBB);
    ++Count;
  }
  return Count;
}



bool TriCoreInstrInfo::expandPostRAPseudo(MachineBasicBlock::iterator MI) const
{
  switch (MI->getOpcode())
  {
  default:
    return false;
  case TriCore::MOVi32: {
	  outs() << "expandPostRAPseudo\n";
    DebugLoc DL = MI->getDebugLoc();
    MachineBasicBlock &MBB = *MI->getParent();

    const unsigned DstReg = MI->getOperand(0).getReg();
    const bool DstIsDead = MI->getOperand(0).isDead();

    const MachineOperand &MO = MI->getOperand(1);

    auto LO16 = BuildMI(MBB, MI, DL, get(TriCore::MOVrlc), DstReg); //MOVLOi16
    auto HI16 = BuildMI(MBB, MI, DL, get(TriCore::MOVHIi16))
                    .addReg(DstReg, RegState::Define | getDeadRegState(DstIsDead))
                    .addReg(DstReg);

    if (MO.isImm()) {
      const unsigned Imm = MO.getImm();
      const unsigned Lo16 = Imm & 0xffff;
      const unsigned Hi16 = (Imm >> 16) & 0xffff;
      LO16 = LO16.addImm(Lo16);
      HI16 = HI16.addImm(Hi16);
    } else {
      const GlobalValue *GV = MO.getGlobal();
      const unsigned TF = MO.getTargetFlags();
      LO16 = LO16.addGlobalAddress(GV, MO.getOffset(), TF | TriCoreII::MO_LO16);
      HI16 = HI16.addGlobalAddress(GV, MO.getOffset(), TF | TriCoreII::MO_HI16);
    }

    MBB.erase(MI);
    return true;
  }
  }
}
