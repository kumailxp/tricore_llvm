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
//unsigned
//TriCoreInstrInfo::isLoadFromStackSlot(const MachineInstr *MI, int &FrameIndex) const{
//  assert(0 && "Unimplemented");
//  return 0;
//}
  
  /// isStoreToStackSlot - If the specified machine instruction is a direct
  /// store to a stack slot, return the virtual or physical register number of
  /// the source reg along with the FrameIndex of the loaded stack slot.  If
  /// not, return 0.  This predicate must return 0 if the instruction has
  /// any side effects other than storing to the stack slot.
//unsigned
//TriCoreInstrInfo::isStoreToStackSlot(const MachineInstr *MI,
//                                   int &FrameIndex) const {
//  assert(0 && "Unimplemented");
//  return 0;
//}

void TriCoreInstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                                 MachineBasicBlock::iterator I, DebugLoc DL,
                                 unsigned DestReg, unsigned SrcReg,
                                 bool KillSrc) const {
//  BuildMI(MBB, I, I->getDebugLoc(), get(TriCore::MOVrr), DestReg) //MOVrr
//      .addReg(SrcReg, getKillRegState(KillSrc));


	bool DataRegsDest = TriCore::DataRegsRegClass.contains(DestReg);
	bool DataRegsSrc = TriCore::DataRegsRegClass.contains(SrcReg);

	if (DataRegsDest && DataRegsSrc) {
		outs()<<"==DataRegsDest && DataRegsSrc==\n";
		BuildMI(MBB, I, DL, get(TriCore::MOVrr), DestReg)
									.addReg(SrcReg, getKillRegState(KillSrc));
		return;
	}

	bool AddrDest = TriCore::AddrRegsRegClass.contains(DestReg);
	bool AddrSrc = TriCore::AddrRegsRegClass.contains(SrcReg);

	unsigned Opc = 0;
	if (DataRegsDest && AddrSrc)
		Opc = TriCore::MOVDrr;
	else if (AddrDest && DataRegsSrc)
		Opc = TriCore::MOVArr;
	else if (AddrDest && AddrSrc)
		Opc = TriCore::MOVAArr;

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
	outs()<<"==TriCoreInstrInfo::storeRegToStackSlot==\n";
	DebugLoc DL;
	if (I != MBB.end()) DL = I->getDebugLoc();
	MachineFunction &MF = *MBB.getParent();
	MachineFrameInfo &MFI = *MF.getFrameInfo();

	MachineMemOperand *MMO =
			MF.getMachineMemOperand(MachinePointerInfo::getFixedStack(FrameIndex),
					MachineMemOperand::MOStore,
					MFI.getObjectSize(FrameIndex),
					MFI.getObjectAlignment(FrameIndex));


	BuildMI(MBB, I, I->getDebugLoc(), get(TriCore::STR))
	.addReg(SrcReg, getKillRegState(isKill))
	.addFrameIndex(FrameIndex).addImm(0).addMemOperand(MMO);
}

void TriCoreInstrInfo::loadRegFromStackSlot(MachineBasicBlock &MBB,
                                          MachineBasicBlock::iterator I,
                                          unsigned DestReg, int FrameIndex,
                                          const TargetRegisterClass *RC,
                                          const TargetRegisterInfo *TRI) const
{
	outs().changeColor(raw_ostream::BLUE,1);
	outs()<<"loadRegFromStackSlot\n";
	outs().changeColor(raw_ostream::WHITE,0);
	DebugLoc DL;
	if (I != MBB.end()) DL = I->getDebugLoc();
	MachineFunction &MF = *MBB.getParent();
	MachineFrameInfo &MFI = *MF.getFrameInfo();

	// issues the machine instruction “ld $r, offset($sp)”
	// to load incoming arguments from stack frame offset
	MachineMemOperand *MMO =
			MF.getMachineMemOperand(MachinePointerInfo::getFixedStack(FrameIndex),
					MachineMemOperand::MOLoad,
					MFI.getObjectSize(FrameIndex),
					MFI.getObjectAlignment(FrameIndex));


	BuildMI(MBB, I, I->getDebugLoc(), get(TriCore::LDR), DestReg)
      .addFrameIndex(FrameIndex).addImm(0).addMemOperand(MMO);
}

////Branch Analysis
//
//
//bool
//TriCoreInstrInfo::AnalyzeBranch(MachineBasicBlock &MBB, MachineBasicBlock *&TBB,
//                            MachineBasicBlock *&FBB,
//                            SmallVectorImpl<MachineOperand> &Cond,
//														std::vector<unsigned> &s1,
//													  std::vector<unsigned> &s2,
//                            bool AllowModify) const {
//  bool HasCondBranch = false;
//  TBB = nullptr;
//  FBB = nullptr;
//  for (MachineInstr &MI : MBB) {
//    if (MI.getOpcode() == TriCore::JMP) {
//    	//outs() << "MI.getOpcode() == LEG::B\n";
//    	//MI.getOperand(0).getMBB()->dump();
//      MachineBasicBlock *TargetBB = MI.getOperand(0).getMBB();
//      if (HasCondBranch) {
//        FBB = TargetBB;
//      } else {
//        TBB = TargetBB;
//      }
//    } else if (MI.getOpcode() == TriCore::JCC) {
//    	//outs()<< "MI.getOpcode() == LEG::Bcc\n";
//    	//MI.getOperand(1).getMBB()->dump();
//      MachineBasicBlock *TargetBB = MI.getOperand(1).getMBB();
//      s1.push_back(MI.getOperand(2).getReg());
//      s2.push_back(MI.getOperand(2).getReg());
//      TBB = TargetBB;
//      Cond.push_back(MI.getOperand(0));
//      HasCondBranch = true;
//    }
//  }
//  return false;
//}
///// RemoveBranch - Remove the branching code at the end of the specific MBB.
///// This is only invoked in cases where AnalyzeBranch returns success. It
///// returns the number of instructions that were removed.
//unsigned
//TriCoreInstrInfo::RemoveBranch(MachineBasicBlock &MBB) const {
//  if (MBB.empty())
//    return 0;
//
//  outs()<< "RemoveBranch\n";
//  unsigned NumRemoved = 0;
//  auto I = MBB.end();
//  do {
//    --I;
//    unsigned Opc = I->getOpcode();
//    if ((Opc == TriCore::JMP) || (Opc == TriCore::JCC)) {
//      auto ToDelete = I;
//      //(*I).dump();
//      ++I;
//      MBB.erase(ToDelete);
//      NumRemoved++;
//    }
//  } while (I != MBB.begin());
//
//  outs()<<"NumRemoved: " << NumRemoved <<"\n";
//  return NumRemoved;
//}
//
///// InsertBranch - Insert branch code into the end of the specified
///// MachineBasicBlock.  The operands to this method are the same as those
///// returned by AnalyzeBranch.  This is only invoked in cases where
///// AnalyzeBranch returns success. It returns the number of instructions
///// inserted.
/////
///// It is also invoked by tail merging to add unconditional branches in
///// cases where AnalyzeBranch doesn't apply because there was no original
///// branch to analyze.  At least this much must be implemented, else tail
///// merging needs to be disabled.
//unsigned TriCoreInstrInfo::InsertBranch(MachineBasicBlock &MBB,
//                                    MachineBasicBlock *TBB,
//                                    MachineBasicBlock *FBB,
//                                    ArrayRef<MachineOperand> Cond,
//																		std::vector<unsigned> &s1,
//																		std::vector<unsigned> &s2,
//                                    DebugLoc DL) const {
//  unsigned NumInserted = 0;
//
//
//  outs()<< "InsertBranch\n";
//  // Insert any conditional branch.
//  if (Cond.size() > 0) {
////    BuildMI(MBB, MBB.end(), DL, get(TriCore::JCC)).addOperand(Cond[0]).addMBB(TBB)
////    																							.addReg(s1[0]).addReg(s2[0]);
//  	BuildMI(MBB, MBB.end(), DL, get(TriCore::JCC)).addOperand(Cond[0]).addMBB(TBB)
//  	    																							.addReg(s1[0]);
//    NumInserted++;
//  }
//
//  // Insert any unconditional branch.
//  if (Cond.empty() || FBB) {
//    BuildMI(MBB, MBB.end(), DL, get(TriCore::JMP)).addMBB(Cond.empty() ? TBB : FBB);
//    NumInserted++;
//  }
//  outs()<<"NumInserted: " << NumInserted <<"\n";
//  return NumInserted;
//}


///////////////////////////////////////////

//
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
		auto HI16 = BuildMI(MBB, MI, DL, get(TriCore::MOVHIi16))
                    						.addReg(DstReg, RegState::Define | getDeadRegState(DstIsDead))
																.addReg(DstReg);

		auto ADDIrlc = BuildMI(MBB, MI, DL, get(TriCore::ADDIrlc))
                        						.addReg(DstReg, RegState::Define | getDeadRegState(DstIsDead))
																		.addReg(DstReg);
		if (MO.isImm()) {
			const unsigned Imm = MO.getImm();
			const unsigned Lo16 = Imm & 0xffff;
			const unsigned Hi16 = (Imm >> 16) & 0xffff;
			HI16 = HI16.addImm(Hi16);
			if(!(Imm==0))
				ADDIrlc = ADDIrlc.addImm(Lo16);
		} else {
			//outs()<<"MO.getGlobal()\n";
			const GlobalValue *GV = MO.getGlobal();
			const unsigned TF = MO.getTargetFlags();
			HI16 = HI16.addGlobalAddress(GV, MO.getOffset() , TriCoreII::MO_HI_OFFSET);
			ADDIrlc = ADDIrlc.addGlobalAddress(GV,MO.getOffset() , TriCoreII::MO_LO_OFFSET);
		}

		MBB.erase(MI);
		return true;
	}
	}
}
