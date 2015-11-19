//===-- TriCoreRegisterInfo.cpp - LEG Register Information ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the TriCore implementation of the MRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "TriCoreRegisterInfo.h"
#include "TriCore.h"
#include "TriCoreFrameLowering.h"
#include "TriCoreInstrInfo.h"
#include "TriCoreMachineFunctionInfo.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetFrameLowering.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"

#define GET_REGINFO_TARGET_DESC
#include "TriCoreGenRegisterInfo.inc"

using namespace llvm;

TriCoreRegisterInfo::TriCoreRegisterInfo() : TriCoreGenRegisterInfo(TriCore::A11) {}

const uint16_t *
TriCoreRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  static const uint16_t CalleeSavedRegs[] = { 0 };
  return CalleeSavedRegs;
}

BitVector TriCoreRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());

  Reserved.set(TriCore::PC);
  Reserved.set(TriCore::PCXI);
  Reserved.set(TriCore::A10);
  Reserved.set(TriCore::A11);
  Reserved.set(TriCore::PSW);
  return Reserved;
}

const uint32_t *TriCoreRegisterInfo::getCallPreservedMask(const MachineFunction &MF,
                                                      CallingConv::ID) const {
//  return CC_Save_RegMask;
}

bool
TriCoreRegisterInfo::requiresRegisterScavenging(const MachineFunction &MF) const {
  return true;
}

bool
TriCoreRegisterInfo::trackLivenessAfterRegAlloc(const MachineFunction &MF) const {
  return true;
}

//bool TriCoreRegisterInfo::useFPForScavengingIndex(const MachineFunction &MF) const {
//  return false;
//}

void TriCoreRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                          int SPAdj, unsigned FIOperandNum,
                                          RegScavenger *RS) const {
  MachineInstr &MI = *II;
  const MachineFunction &MF = *MI.getParent()->getParent();
  DebugLoc dl = MI.getDebugLoc();
  MachineBasicBlock &MBB = *MI.getParent();
  const MachineFrameInfo *MFI = MF.getFrameInfo();
  MachineOperand &FIOp = MI.getOperand(FIOperandNum);
  unsigned FI = FIOp.getIndex();
  const TargetFrameLowering *TFI = MF.getSubtarget().getFrameLowering();
  unsigned BasePtr = (TFI->hasFP(MF) ? TriCore::A14 : TriCore::A10);
  // Determine if we can eliminate the index from this kind of instruction.
  unsigned ImmOpIdx = 0;




  switch (MI.getOpcode()) {
  default:
    // Not supported yet.
    return;
  case TriCore::ADDri: {
    	//const LEGFrameLowering *TFI = getFrameLowering(MF);
    	int Offset = MFI->getObjectOffset(FI);
 	    Offset += MF.getFrameInfo()->getStackSize();
  	  Offset += MI.getOperand(FIOperandNum + 1).getImm();

  	  Offset = -Offset;
    	outs().changeColor(raw_ostream::GREEN,1)<<"Offset: " << Offset << "\n" ;
    	outs().changeColor(raw_ostream::WHITE,0);
    	const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
    	MI.setDesc(TII.get(TriCore::MOVdRR));
    	MI.getOperand(FIOperandNum).ChangeToRegister(BasePtr, false);

    	if (Offset == 0)
  			return;

  		// We need to materialize the offset via add instruction.
  		unsigned DstReg = MI.getOperand(0).getReg();
  		if (Offset < 0) {
  			BuildMI(MBB, std::next(II), dl, TII.get(TriCore::ADDri), DstReg)
  				.addReg(DstReg).addImm(Offset);
  		}
  		else
  			BuildMI(MBB, std::next(II), dl, TII.get(TriCore::ADDri), DstReg)
  				.addReg(DstReg).addImm(-Offset);


    	return;
    }

  case TriCore::LDR:
  case TriCore::STR:
    ImmOpIdx = FIOperandNum + 1;
    break;
  }

  // FIXME: check the size of offset.
  MachineOperand &ImmOp = MI.getOperand(ImmOpIdx);
  int Offset = MFI->getObjectOffset(FI) + MFI->getStackSize() + ImmOp.getImm();
  FIOp.ChangeToRegister(BasePtr, false);
  ImmOp.setImm(-Offset);
}

unsigned TriCoreRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  //const TargetFrameLowering *TFI = MF.getSubtarget().getFrameLowering();
  //return TFI->hasFP(MF) ? (TriCore::A11) :
  //                        (TriCore::A10);
	return TriCore::A14;
}

