//===-- LEGRegisterInfo.cpp - LEG Register Information ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the LEG implementation of the MRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "LEGRegisterInfo.h"
#include "LEG.h"
#include "LEGFrameLowering.h"
#include "LEGInstrInfo.h"
#include "LEGMachineFunctionInfo.h"
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
#include <stdint.h>
#define GET_REGINFO_TARGET_DESC
#include "LEGGenRegisterInfo.inc"

using namespace llvm;

LEGRegisterInfo::LEGRegisterInfo() : LEGGenRegisterInfo(LEG::LR) {}

const uint16_t *LEGRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  static const uint16_t CalleeSavedRegs[] = { LEG::R4, LEG::R5, LEG::R6,
                                              LEG::R7, LEG::R8, LEG::R9,
                                              0 };
  return CalleeSavedRegs;
}

BitVector LEGRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());

  Reserved.set(LEG::SP);
  Reserved.set(LEG::LR);
  return Reserved;
}

const uint32_t *LEGRegisterInfo::getCallPreservedMask(const MachineFunction &MF,
                                                      CallingConv::ID) const {
  return CC_Save_RegMask;
}

bool
LEGRegisterInfo::requiresRegisterScavenging(const MachineFunction &MF) const {
  return true;
}

bool
LEGRegisterInfo::trackLivenessAfterRegAlloc(const MachineFunction &MF) const {
  return true;
}

bool LEGRegisterInfo::useFPForScavengingIndex(const MachineFunction &MF) const {
  return false;
}

const TargetRegisterClass *
LEGRegisterInfo::getPointerRegClass(const MachineFunction &MF, unsigned Kind)
                                                                         const {
  return &LEG::GRRegsRegClass;
}


void LEGRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                          int SPAdj, unsigned FIOperandNum,
                                          RegScavenger *RS) const {

  outs()<<"eliminateFrameIndex\n";
  MachineInstr &MI = *II;
//  outs()<<"Machine Instr: " << MI<< "\n";
  DebugLoc dl = MI.getDebugLoc();
  const MachineFunction &MF = *MI.getParent()->getParent();
   MachineBasicBlock &MBB = *MI.getParent();
  //outs()<<"Machine Function:\n" << MF;
  const MachineFrameInfo *MFI = MF.getFrameInfo();
  //outs()<<"Machine Frame Info:\n" << *MFI;
  MachineOperand &FIOp = MI.getOperand(FIOperandNum);
  //outs()<<"FIOp.getSymbolName(): " << FIOp.getSymbolName() << ".\n";
  unsigned FI = FIOp.getIndex();
//  outs()<<"FIOperandNum: " << FIOperandNum << "\n" ;
  // Determine if we can eliminate the index from this kind of instruction.
  unsigned ImmOpIdx = 0;
  switch (MI.getOpcode()) {
  default:
  	outs()<<"Not supported yet.\n";
    return;
  case LEG::ADDri: {
  	const LEGFrameLowering *TFI = getFrameLowering(MF);
  	int Offset = MFI->getObjectOffset(FI);
	  //if (!TFI->hasFP(MF)) {
	  	//outs()<<"hasFP!!!\n";
	    Offset += MF.getFrameInfo()->getStackSize();
	  //}
	  //else
	  //  Offset += 4; // Skip the saved FP

	  // Skip the saved PC
	  //Offset += 4;

	  Offset += MI.getOperand(FIOperandNum + 1).getImm();

//  	outs().changeColor(raw_ostream::GREEN,1)<<"Offset: " << Offset << "\n" ;
//  	outs().changeColor(raw_ostream::WHITE,0);
  	const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
  	outs()<<"TII name: " << TII.getNumOpcodes() << "\n";
  	//outs()<<"TII name: " << TII.getName(TII.getNumOpcodes()) << "\n";
  	MI.setDesc(TII.get(LEG::MOVrr));
  	MI.getOperand(FIOperandNum).ChangeToRegister(LEG::SP, false);
		if (Offset == 0)
			return;

		// We need to materialize the offset via add instruction.
		unsigned DstReg = MI.getOperand(0).getReg();
		if (Offset < 0)
			BuildMI(MBB, std::next(II), dl, TII.get(LEG::SUBri), DstReg)
				.addReg(DstReg).addImm(-Offset);
		else
			BuildMI(MBB, std::next(II), dl, TII.get(LEG::ADDri), DstReg)
				.addReg(DstReg).addImm(Offset);


  	return;
  }
  case LEG::LDR:
  case LEG::STR:
//	outs()<<"Machine Opcode: " << MI.getOpcode()<< ".\n";
    ImmOpIdx = FIOperandNum + 1;

//    outs()<<"ImmOpIdx: " << ImmOpIdx << "\n" ;
    break;
  }

  // FIXME: check the size of offset.
  MachineOperand &ImmOp = MI.getOperand(ImmOpIdx);
  //outs()<<"ImmOp.getSymbolName(): " << ImmOp.getSymbolName() << ".\n";
  int Offset = MFI->getObjectOffset(FI) + MFI->getStackSize() + ImmOp.getImm();
//  outs()<<"ImmOp.getImm(): " << ImmOp.getImm() << ".\n";
//  outs()<<"MFI->getStackSize(): " << MFI->getStackSize() << ".\n";
//  outs()<<"MFI->getObjectOffset(FI): " << MFI->getObjectOffset(FI) << ".\n";
//  outs()<<"Offset value: " << Offset << ".\n";
  FIOp.ChangeToRegister(LEG::SP, false);
  ImmOp.setImm(Offset);

//  outs()<< "Final MI:"  << MI << "\n";
  //outs()<<"=====================================================\n";

}

unsigned LEGRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
//  return LEG::SP;
	 const LEGFrameLowering *TFI = getFrameLowering(MF);
	  return TFI->hasFP(MF) ? LEG::R6 : LEG::SP;
}
