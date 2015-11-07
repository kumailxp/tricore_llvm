//===-- TriCoreISelDAGToDAG.cpp - A dag to dag inst selector for TriCore --===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the TriCore target.
//
//===----------------------------------------------------------------------===//

#include "TriCore.h"
#include "TriCoreTargetMachine.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

#include "TriCoreInstrInfo.h"

using namespace llvm;

/// TriCoreDAGToDAGISel - TriCore specific code to select TriCore machine
/// instructions for SelectionDAG operations.
///
namespace {
class TriCoreDAGToDAGISel : public SelectionDAGISel {
  const TriCoreSubtarget &Subtarget;

public:
  explicit TriCoreDAGToDAGISel(TriCoreTargetMachine &TM, CodeGenOpt::Level OptLevel)
      : SelectionDAGISel(TM, OptLevel), Subtarget(*TM.getSubtargetImpl()) {}

  SDNode *Select(SDNode *N);

  bool SelectAddr(SDValue Addr, SDValue &Base, SDValue &Offset);

  virtual const char *getPassName() const {
    return "TriCore DAG->DAG Pattern Instruction Selection";
  }

private:
  SDNode *SelectMoveImmediate(SDNode *N);
  SDNode *SelectConditionalBranch(SDNode *N);

// Include the pieces autogenerated from the target description.
#include "TriCoreGenDAGISel.inc"
};
} // end anonymous namespace

bool TriCoreDAGToDAGISel::SelectAddr(SDValue Addr, SDValue &Base, SDValue &Offset) {
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    EVT PtrVT = getTargetLowering()->getPointerTy(*TM.getDataLayout());
    Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), PtrVT);
    Offset = CurDAG->getTargetConstant(0, Addr, MVT::i32);
    return true;
  }
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress ||
      Addr.getOpcode() == ISD::TargetGlobalTLSAddress) {
    return false; // direct calls.
  }

  Base = Addr;
  Offset = CurDAG->getTargetConstant(0, Addr, MVT::i32);
  return true;
}

SDNode *TriCoreDAGToDAGISel::SelectMoveImmediate(SDNode *N) {
  // Make sure the immediate size is supported.
  ConstantSDNode *ConstVal = cast<ConstantSDNode>(N);
  uint64_t ImmVal = ConstVal->getZExtValue();
  outs() <<"ImmVal: "<<  ImmVal << "\n";
  uint64_t SupportedMask = 0xfffffffff;
  if ((ImmVal & SupportedMask) != ImmVal) {
  	outs() <<" Immediate size not supported!\n";
    return SelectCode(N);
  }

  // Select the low part of the immediate move.
  uint64_t LoMask = 0xffff;
  uint64_t HiMask = 0xffff0000;
  uint64_t ImmLo = (ImmVal & LoMask);
  uint64_t ImmHi = (ImmVal & HiMask);
  SDValue ConstLo = CurDAG->getTargetConstant(ImmLo, N, MVT::i32);
  MachineSDNode *Move;
  if(ImmVal < 65535) {
  	Move =
  			CurDAG->getMachineNode(TriCore::MOVrlc, N, MVT::i32, ConstLo); //MOVLOi16
  }
  // Select the high part of the immediate move, if needed.
  if (ImmHi) {
	outs() <<"Select the high part\n";
//	SDValue *x = new SDValue(Move, 0);
//
//	outs()<< "operands: " << x->getNumOperands() <<"\n";
//	outs()<< "operands: " << x->getNode() <<"\n";
    SDValue ConstHi = CurDAG->getTargetConstant(ImmHi >> 16, N, MVT::i32);
    outs()<< "ImmHi: " << ImmHi <<"\n";
    outs()<< "ImmHi >> 16: " << (ImmHi >> 16) <<"\n";
    outs()<< "ImmLo: " << ImmLo <<"\n";
    MachineSDNode *MoveHi;
    MoveHi = CurDAG->getMachineNode(TriCore::MOVHIi16, N, MVT::i32, ConstHi);
		Move = CurDAG->getMachineNode(TriCore::ADDi, N, MVT::i32, SDValue(MoveHi, 0),
																		ConstLo);

    outs()<< Move <<"\n";
  }

  	return Move;
}

SDNode *TriCoreDAGToDAGISel::SelectConditionalBranch(SDNode *N) {

	SDValue Chain = N->getOperand(0);
	SDValue Cond = N->getOperand(1);
	SDValue LHS = N->getOperand(2);
	SDValue RHS = N->getOperand(3);
	SDValue Target = N->getOperand(4);

	// Generate a comparison instruction.
	EVT CompareTys[] = { MVT::Other, MVT::Glue };
	//EVT CompareTys[] = { MVT::Other };
	SDVTList CompareVT = CurDAG->getVTList(CompareTys);

	SDValue CompareOps[] = {LHS, RHS, Chain};
	SDNode *Compare = CurDAG->getMachineNode(TriCore::CMPrr, N, CompareVT, CompareOps);

	CondCodeSDNode *CC = cast<CondCodeSDNode>(Cond.getNode());
	SDValue CCVal = CurDAG->getTargetConstant(CC->get(), N, MVT::i32);
	SDValue BranchOps[] = {CCVal, Target, SDValue(Compare, 0),
			SDValue(Compare, 1)};

	MachineSDNode *branchInst = CurDAG->getMachineNode(TriCore::JCC, N, MVT::Other, BranchOps);
	branchInst->dump();

	return branchInst;



}

SDNode *TriCoreDAGToDAGISel::Select(SDNode *N) {
  switch (N->getOpcode()) {
  case ISD::Constant:
    return SelectMoveImmediate(N);
  case ISD::BR_CC:
    return SelectConditionalBranch(N);
  }

  return SelectCode(N);
}
/// createTriCoreISelDag - This pass converts a legalized DAG into a
/// TriCore-specific DAG, ready for instruction scheduling.
///
FunctionPass *llvm::createTriCoreISelDag(TriCoreTargetMachine &TM,
                                     CodeGenOpt::Level OptLevel) {
  return new TriCoreDAGToDAGISel(TM, OptLevel);
}
