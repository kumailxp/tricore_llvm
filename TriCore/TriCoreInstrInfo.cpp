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
TriCoreInstrInfo::isLoadFromStackSlot(const MachineInstr *MI, int &FrameIndex)
                                          const{

	if ((MI->getOperand(1).isFI()) && (MI->getOperand(2).isImm())
			&& (MI->getOperand(2).getImm() == 0)) {
		FrameIndex = MI->getOperand(1).getIndex();
		return MI->getOperand(0).getReg();
	}

	return 0;
}
  
  /// isStoreToStackSlot - If the specified machine instruction is a direct
  /// store to a stack slot, return the virtual or physical register number of
  /// the source reg along with the FrameIndex of the loaded stack slot.  If
  /// not, return 0.  This predicate must return 0 if the instruction has
  /// any side effects other than storing to the stack slot.
unsigned TriCoreInstrInfo::isStoreToStackSlot(const MachineInstr *MI,
		int &FrameIndex) const {

	if ((MI->getOperand(0).isFI()) && (MI->getOperand(1).isImm())
			&& (MI->getOperand(1).getImm() == 0)) {
		FrameIndex = MI->getOperand(0).getIndex();
		return MI->getOperand(2).getReg();
	}

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

//TriCoreCC::CondCodes
//						TriCoreInstrInfo::getCondFromBranchOpc(unsigned Opc) const {
//  switch (Opc) {
//  default:
//    return TriCoreCC::COND_INVALID;
//  case TriCore::JEQbrc:
//  case TriCore::JEQbrr:
//    return TriCoreCC::COND_EQ;
//  case TriCore::JNEbrc:
//	case TriCore::JNEbrr:
//    return TriCoreCC::COND_NE;
//	case TriCore::JGEbrc:
//	case TriCore::JGEbrr:
//    return TriCoreCC::COND_GE;
//	case TriCore::JLTbrc:
//	case TriCore::JLTbrr:
//    return TriCoreCC::COND_LT;
//  }
//}
//
//TriCoreCC::CondCodes
//		TriCoreInstrInfo::getOppositeCondition(TriCoreCC::CondCodes CC) const {
//  switch (CC) {
//  default:
//    llvm_unreachable("Invalid condition!");
//  case TriCoreCC::COND_EQ:
//    return TriCoreCC::COND_NE;
//  case TriCoreCC::COND_NE:
//    return TriCoreCC::COND_EQ;
//  case TriCoreCC::COND_GE:
//    return TriCoreCC::COND_LT;
//  case TriCoreCC::COND_LT:
//    return TriCoreCC::COND_GE;
//  }
//}
//
//const MCInstrDesc &TriCoreInstrInfo::getBrCond(TriCoreCC::CondCodes CC) const {
//  switch (CC) {
//  default:
//    llvm_unreachable("Unknown condition code!");
//  case TriCoreCC::COND_EQ:
//    return get(TriCore::JEQbrr);
//  case TriCoreCC::COND_NE:
//    return get(TriCore::JNEbrr);
//  case TriCoreCC::COND_GE:
//    return get(TriCore::JGEbrr);
//  case TriCoreCC::COND_LT:
//    return get(TriCore::JLTbrr);
//  }
//}
//
////Branch Analysis
//bool
//TriCoreInstrInfo::AnalyzeBranch(MachineBasicBlock &MBB,
//		MachineBasicBlock *&TBB, MachineBasicBlock *&FBB,
//		SmallVectorImpl<MachineOperand> &Cond, std::vector<unsigned> &s1,
//		std::vector<unsigned> &s2, bool AllowModify) const {
//
//	// Start from the bottom of the block and work up, examining the
//	// terminator instructions.
//	MachineBasicBlock::iterator I = MBB.end();
//	MachineBasicBlock::iterator UnCondBrIter = MBB.end();
//
//	while (I != MBB.begin()) {
//		--I;
//		if (I->isDebugValue()) {
//			continue;
//		}
//
//		// Working from the bottom, when we see a non-terminator
//		// instruction, we're done.
//		if (!isUnpredicatedTerminator(I)) {
//			break;
//		}
//
//		// A terminator that isn't a branch can't easily be handled
//		// by this analysis.
//		if (!I->getDesc().isBranch()) {
//			return true;
//		}
//
//		// Handle unconditional branches.
//		//:TODO: add here jmp
//		if (I->getOpcode() == TriCore::JMP) {
//			UnCondBrIter = I;
//
//			if (!AllowModify) {
//				TBB = I->getOperand(0).getMBB();
//				continue;
//			}
//
//			// If the block has any instructions after a JMP, delete them.
//			while (std::next(I) != MBB.end()) {
//				std::next(I)->eraseFromParent();
//			}
//
//			Cond.clear();
//			FBB = 0;
//
//			// Delete the JMP if it's equivalent to a fall-through.
//			if (MBB.isLayoutSuccessor(I->getOperand(0).getMBB())) {
//				TBB = 0;
//				I->eraseFromParent();
//				I = MBB.end();
//				UnCondBrIter = MBB.end();
//				continue;
//			}
//
//			// TBB is used to indicate the unconditinal destination.
//			TBB = I->getOperand(0).getMBB();
//			continue;
//		}
//
//		// Handle conditional branches.
//		TriCoreCC::CondCodes BranchCode = getCondFromBranchOpc(I->getOpcode());
//		if (BranchCode == TriCoreCC::COND_INVALID) {
//			return true; // Can't handle indirect branch.
//		}
//
//		// Working from the bottom, handle the first conditional branch.
//		if (Cond.empty()) {
//			MachineBasicBlock *TargetBB = I->getOperand(0).getMBB();
//			if (AllowModify && UnCondBrIter != MBB.end()
//					&& MBB.isLayoutSuccessor(TargetBB)) {
//				// If we can modify the code and it ends in something like:
//				//
//				//     jCC L1
//				//     jmp L2
//				//   L1:
//				//     ...
//				//   L2:
//				//
//				// Then we can change this to:
//				//
//				//     jnCC L2
//				//   L1:
//				//     ...
//				//   L2:
//				//
//				// Which is a bit more efficient.
//				// We conditionally jump to the fall-through block.
//				BranchCode = getOppositeCondition(BranchCode);
//				unsigned JNCC = getBrCond(BranchCode).getOpcode();
//				MachineBasicBlock::iterator OldInst = I;
//
//				BuildMI(MBB, UnCondBrIter, MBB.findDebugLoc(I), get(JNCC)).addMBB(
//						UnCondBrIter->getOperand(0).getMBB())
//						.addReg(UnCondBrIter->getOperand(1).getReg())
//						.addReg(UnCondBrIter->getOperand(2).getReg());
//				BuildMI(MBB, UnCondBrIter, MBB.findDebugLoc(I), get(TriCore::JMP)).addMBB(
//						TargetBB);
//
//				OldInst->eraseFromParent();
//				UnCondBrIter->eraseFromParent();
//
//				// Restart the analysis.
//				UnCondBrIter = MBB.end();
//				I = MBB.end();
//				continue;
//			}
//
//			FBB = TBB;
//			TBB = I->getOperand(0).getMBB();
//			Cond.push_back(MachineOperand::CreateImm(BranchCode));
//			s1.push_back(I->getOperand(1).getReg());
//			s2.push_back(I->getOperand(2).getReg());
//			continue;
//		}
//
//		// Handle subsequent conditional branches. Only handle the case where all
//		// conditional branches branch to the same destination.
//		assert(Cond.size() == 1);
//		assert(TBB);
//
//		// Only handle the case where all conditional branches branch to
//		// the same destination.
//		if (TBB != I->getOperand(0).getMBB()) {
//			return true;
//		}
//
//		TriCoreCC::CondCodes OldBranchCode = (TriCoreCC::CondCodes) Cond[0].getImm();
//		// If the conditions are the same, we can leave them alone.
//		if (OldBranchCode == BranchCode) {
//			continue;
//		}
//
//		return true;
//	}
//
//	return false;
//}
//
///// RemoveBranch - Remove the branching code at the end of the specific MBB.
///// This is only invoked in cases where AnalyzeBranch returns success. It
///// returns the number of instructions that were removed.
//unsigned
//TriCoreInstrInfo::RemoveBranch(MachineBasicBlock &MBB) const {
//	MachineBasicBlock::iterator I = MBB.end();
//	unsigned Count = 0;
//
//	while (I != MBB.begin()) {
//		--I;
//		if (I->isDebugValue()) {
//			continue;
//		}
//		//:TODO: add here the missing jmp instructions once they are implemented
//		// like jmp, {e}ijmp, and other cond branches, ...
//		if (I->getOpcode() != TriCore::JMP &&
//				getCondFromBranchOpc(I->getOpcode()) == TriCoreCC::COND_INVALID) {
//			break;
//		}
//
//		// Remove the branch.
//		I->eraseFromParent();
//		I = MBB.end();
//		++Count;
//	}
//
//	return Count;
//}
////
/////// InsertBranch - Insert branch code into the end of the specified
/////// MachineBasicBlock.  The operands to this method are the same as those
/////// returned by AnalyzeBranch.  This is only invoked in cases where
/////// AnalyzeBranch returns success. It returns the number of instructions
/////// inserted.
///////
/////// It is also invoked by tail merging to add unconditional branches in
/////// cases where AnalyzeBranch doesn't apply because there was no original
/////// branch to analyze.  At least this much must be implemented, else tail
/////// merging needs to be disabled.
//unsigned TriCoreInstrInfo::InsertBranch(MachineBasicBlock &MBB,
//                                    MachineBasicBlock *TBB,
//                                    MachineBasicBlock *FBB,
//                                    ArrayRef<MachineOperand> Cond,
//																		std::vector<unsigned> &s1,
//																		std::vector<unsigned> &s2,
//                                    DebugLoc DL) const {
//  // Shouldn't be a fall through.
//  assert(TBB && "InsertBranch must not be told to insert a fallthrough");
//  assert((Cond.size() == 1 || Cond.size() == 0) &&
//         "AVR branch conditions have one component!");
//
//  if (Cond.empty()) {
//    // Unconditional branch?
//    assert(!FBB && "Unconditional branch with multiple successors!");
//    BuildMI(&MBB, DL, get(TriCore::JMP)).addMBB(TBB);
//    return 1;
//  }
//
//  // Conditional branch.
//  unsigned Count = 0;
//  TriCoreCC::CondCodes CC = (TriCoreCC::CondCodes)Cond[0].getImm();
//  BuildMI(&MBB, DL, getBrCond(CC)).addMBB(TBB).addReg(s1[0]).addReg(s2[0]);
//  ++Count;
//
//  if (FBB) {
//    // Two-way Conditional branch. Insert the second branch.
//    BuildMI(&MBB, DL, get(TriCore::JMP)).addMBB(FBB);
//    ++Count;
//  }
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
			HI16 = HI16.addGlobalAddress(GV, MO.getOffset() , TriCoreII::MO_HI_OFFSET);
			ADDIrlc = ADDIrlc.addGlobalAddress(GV,MO.getOffset() , TriCoreII::MO_LO_OFFSET);
		}

		MBB.erase(MI);
		return true;
	}
	}
}
