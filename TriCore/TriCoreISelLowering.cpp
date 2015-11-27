//===-- TriCoreISelLowering.cpp - TriCore DAG Lowering Implementation -----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the TriCoreTargetLowering class.
//
//===----------------------------------------------------------------------===//

#include "TriCoreISelLowering.h"
#include "TriCore.h"
#include "TriCoreMachineFunctionInfo.h"
#include "TriCoreSubtarget.h"
#include "TriCoreTargetMachine.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalAlias.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

const char *TriCoreTargetLowering::getTargetNodeName(unsigned Opcode) const {
  switch (Opcode) {
  default:
    return NULL;
  case TriCoreISD::RET_FLAG: return "RetFlag";
  case TriCoreISD::LOAD_SYM: return "LOAD_SYM";
  case TriCoreISD::MOVEi32:  return "MOVEi32";
  case TriCoreISD::CALL:     return "CALL";
  case TriCoreISD::BR_CC:    return "TriCoreISD::BR_CC";
  //case TriCoreISD::BR_CC_new:    return "TriCoreISD::BR_CC_new";
	//case TriCoreISD::CMP:      return "TriCoreISD::CMP";
	case TriCoreISD::CMPB:      return "TriCoreISD::CMPB";
  }
}

TriCoreTargetLowering::TriCoreTargetLowering(TriCoreTargetMachine &TriCoreTM)
    : TargetLowering(TriCoreTM), Subtarget(*TriCoreTM.getSubtargetImpl()) {
  // Set up the register classes.
  addRegisterClass(MVT::i32, &TriCore::DataRegsRegClass);
  addRegisterClass(MVT::i32, &TriCore::AddrRegsRegClass);
  addRegisterClass(MVT::i32, &TriCore::AddrRegsOthersRegClass);


  // Compute derived properties from the register classes
  computeRegisterProperties(Subtarget.getRegisterInfo());

  setStackPointerRegisterToSaveRestore(TriCore::A10);

  setSchedulingPreference(Sched::Source);

  // Nodes that require custom lowering
  setOperationAction(ISD::GlobalAddress, MVT::i32, Custom);
  setOperationAction(ISD::BR_CC,         MVT::i32,   Custom);

}

SDValue TriCoreTargetLowering::LowerOperation(SDValue Op, SelectionDAG &DAG) const {
  switch (Op.getOpcode()) {
  default:								    llvm_unreachable("Unimplemented operand");
  case ISD::GlobalAddress:    return LowerGlobalAddress(Op, DAG);
  case ISD::BR_CC:            return LowerBR_CC(Op, DAG);
  }
}


//static StringRef printCondCode(ISD::CondCode e) {
//
//	switch(e){
//	default: return "unknown";
//	case ISD::SETEQ: return "SETEQ";
//	case ISD::SETGT: return "SETGT";
//	case ISD::SETGE: return "SETGE";
//	case ISD::SETLT: return "SETLT";
//	case ISD::SETLE: return "SETLE";
//	case ISD::SETNE: return "SETNE";
//	case ISD::SETTRUE2: return "SETTRUE2";
//	}
//}
//
static SDValue EmitCMP(SDValue &Chain, SDValue &LHS, SDValue &RHS, SDValue &TargetCC,
                       ISD::CondCode CC,
                       SDLoc dl, SelectionDAG &DAG) {
  // FIXME: Handle bittests someday
  assert(!LHS.getValueType().isFloatingPoint() && "We don't handle FP yet");
//
//  TriCoreCC::CondCodes TCC = TriCoreCC::COND_INVALID;
//  outs()<<printCondCode(CC)<<"\n";

  //ISD::CondCode TCC = ISD::SETCC_INVALID;
////	outs()<<printCondCode(CC)<<"\n";
//  switch (CC) {
//  default: llvm_unreachable("Invalid integer condition!");
//  case ISD::SETLT:
//  	TCC =  ISD::SETLT;
//  	break;
//  case ISD::SETLE:
////  	if (const ConstantSDNode * C = dyn_cast<ConstantSDNode>(LHS)) {
////				LHS = RHS;
////				RHS = DAG.getConstant(C->getSExtValue() + 1, dl, C->getValueType(0));
////				TCC =  ISD::SETGE;
////				break;
////			}
//			TCC = ISD::SETGE;
//			break;
//  case ISD::SETGE:
//    // Turn lhs >= rhs with lhs constant into rhs < lhs+1, this allows us to
//    // fold constant into instruction.
////    if (const ConstantSDNode * C = dyn_cast<ConstantSDNode>(LHS)) {
////      LHS = RHS;
////      RHS = DAG.getConstant(C->getSExtValue() + 1, dl, C->getValueType(0));
////      TCC =  ISD::SETGE;
////      break;
////    }
//    TCC = ISD::SETGE;
//    break;
//  case ISD::SETGT:
//    //std::swap(LHS, RHS);        // FALLTHROUGH#
//    TCC = ISD::SETGT;
//		break;
//
//  }
//  SDValue CompareOps[] = {LHS, RHS, Chain};
//  EVT CompareTys[] = { MVT::Other, MVT::Glue };
//    //EVT CompareTys[] = { MVT::Other };
//    SDVTList CompareVT = DAG.getVTList(CompareTys);
  TargetCC = DAG.getConstant(CC, dl, MVT::i32);
  //TargetCC = DAG.getCondCode(TCC);
//  return DAG.getNode(TriCoreISD::CMP, dl, CompareVT, CompareOps);

 // SDValue tmp = DAG.getNode(TriCoreISD::CMPB, dl, MVT::Other, LHS, RHS);
//  outs()<< "Result No:" << tmp.getResNo() << "\n";

 // tmp.dump();

  //return DAG.getNode(TriCoreISD::CMPB, dl,MVT::Other, LHS, RHS);
}
//
//
SDValue TriCoreTargetLowering::LowerBR_CC(SDValue Op, SelectionDAG &DAG) const {
  SDValue Chain = Op.getOperand(0);
  ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(1))->get();
  SDValue LHS   = Op.getOperand(2);
  SDValue RHS   = Op.getOperand(3);
  SDValue Dest  = Op.getOperand(4);
  SDLoc dl  (Op);

  SDValue TargetCC;
  Op.getOperand(1).dump();



  SDValue Flag = EmitCMP(Chain, LHS, RHS, TargetCC, CC, dl, DAG);


  SDValue Zero = DAG.getConstant(0, dl, MVT::i32);

  outs()<<"TriCoreTargetLowering::LowerBR_CC\n";

  //RHS = DAG.getConstant(43, dl, MVT::i32);
  //LHS = DAG.getConstant(43, dl, MVT::i32);

  outs()<< "Chain Node 0 Type:" << Chain.getValueType().getEVTString()<< "\n";
  outs()<< "CondCode Node 1 Type:" << Op.getOperand(1).getValueType().getEVTString()<< "\n";

  outs()<< "LHS Type:" << LHS.getValueType().getEVTString() << "\n";
  outs()<< "RHS Type:" << RHS.getValueType().getEVTString() << "\n";
  outs()<< "Dest Node 0 Type:" << Dest.getValueType().getEVTString()<< "\n";
//    SDValue CompareOps[] = {Chain, TargetCC, Dest, LHS, RHS};
    SDValue CompareOps[] = {Chain, TargetCC, Dest, LHS, RHS};
    EVT CompareTys[] = { MVT::Other };
    SDVTList CompareVT = DAG.getVTList(CompareTys);


  return DAG.getNode(TriCoreISD::BR_CC, dl, CompareVT,
  		CompareOps);
//  return DAG.getNode(TriCoreISD::BR_CC, dl, Op.getValueType(),
//                     Chain, Dest, TargetCC, Flag);
}

SDValue TriCoreTargetLowering::LowerGlobalAddress(SDValue Op, SelectionDAG& DAG) const
{

//	const GlobalValue *GV = cast<GlobalAddressSDNode>(Op)->getGlobal();
//	int64_t Offset = cast<GlobalAddressSDNode>(Op)->getOffset();
//	auto PtrVT = getPointerTy(DAG.getDataLayout());
//
//	// Create the TargetGlobalAddress node, folding in the constant offset.
//	SDValue Result = DAG.getTargetGlobalAddress(GV, SDLoc(Op), PtrVT, Offset);
//	return DAG.getNode(TriCoreISD::Wrapper, SDLoc(Op), PtrVT, Result);



	EVT VT = Op.getValueType();
  GlobalAddressSDNode *GlobalAddr = cast<GlobalAddressSDNode>(Op.getNode());
  int64_t Offset = cast<GlobalAddressSDNode>(Op)->getOffset();
  outs().changeColor(raw_ostream::RED,1)<< "Offset:Isel "<< Offset;
 	Op.dump();
  SDValue TargetAddr =
      DAG.getTargetGlobalAddress(GlobalAddr->getGlobal(), Op, MVT::i32, Offset);
  TargetAddr.dump();
  outs().changeColor(raw_ostream::WHITE,0);
  return DAG.getNode(TriCoreISD::LOAD_SYM, Op, VT, TargetAddr);
}

//===----------------------------------------------------------------------===//
//                      Calling Convention Implementation
//===----------------------------------------------------------------------===//

#include "TriCoreGenCallingConv.inc"

//===----------------------------------------------------------------------===//
//                  Call Calling Convention Implementation
//===----------------------------------------------------------------------===//

/// TriCore call implementation
SDValue TriCoreTargetLowering::LowerCall(TargetLowering::CallLoweringInfo &CLI,
                                     SmallVectorImpl<SDValue> &InVals) const {
  SelectionDAG &DAG = CLI.DAG;
  SDLoc &Loc = CLI.DL;
  SmallVectorImpl<ISD::OutputArg> &Outs = CLI.Outs;
  SmallVectorImpl<SDValue> &OutVals = CLI.OutVals;
  SmallVectorImpl<ISD::InputArg> &Ins = CLI.Ins;
  SDValue Chain = CLI.Chain;
  SDValue Callee = CLI.Callee;
  CallingConv::ID CallConv = CLI.CallConv;
  const bool isVarArg = CLI.IsVarArg;

  CLI.IsTailCall = false;

  if (isVarArg) {
    llvm_unreachable("Unimplemented");
  }

  // Analyze operands of the call, assigning locations to each operand.
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, isVarArg, DAG.getMachineFunction(), ArgLocs,
                 *DAG.getContext());
  CCInfo.AnalyzeCallOperands(Outs, CC_TriCore);

  // Get the size of the outgoing arguments stack space requirement.
  const unsigned NumBytes = CCInfo.getNextStackOffset();

  Chain =
      DAG.getCALLSEQ_START(Chain, DAG.getIntPtrConstant(NumBytes, Loc, true),
                           Loc);

  SmallVector<std::pair<unsigned, SDValue>, 8> RegsToPass;
  SmallVector<SDValue, 8> MemOpChains;

  // Walk the register/memloc assignments, inserting copies/loads.
  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    CCValAssign &VA = ArgLocs[i];
    SDValue Arg = OutVals[i];

    // We only handle fully promoted arguments.
    assert(VA.getLocInfo() == CCValAssign::Full && "Unhandled loc info");

    if (VA.isRegLoc()) {
      RegsToPass.push_back(std::make_pair(VA.getLocReg(), Arg));
      continue;
    }

    assert(VA.isMemLoc() &&
           "Only support passing arguments through registers or via the stack");

    SDValue StackPtr = DAG.getRegister(TriCore::A10, MVT::i32);
    SDValue PtrOff = DAG.getIntPtrConstant(VA.getLocMemOffset(), Loc);
    PtrOff = DAG.getNode(ISD::ADD, Loc, MVT::i32, StackPtr, PtrOff);
    MemOpChains.push_back(DAG.getStore(Chain, Loc, Arg, PtrOff,
                                       MachinePointerInfo(), false, false, 0));
  }

  // Emit all stores, make sure they occur before the call.
  if (!MemOpChains.empty()) {
    Chain = DAG.getNode(ISD::TokenFactor, Loc, MVT::Other, MemOpChains);
  }

  // Build a sequence of copy-to-reg nodes chained together with token chain
  // and flag operands which copy the outgoing args into the appropriate regs.
  SDValue InFlag;
  for (auto &Reg : RegsToPass) {
    Chain = DAG.getCopyToReg(Chain, Loc, Reg.first, Reg.second, InFlag);
    InFlag = Chain.getValue(1);
  }

  // We only support calling global addresses.
  GlobalAddressSDNode *G = dyn_cast<GlobalAddressSDNode>(Callee);
  assert(G && "We only support the calling of global addresses");

  EVT PtrVT = getPointerTy(DAG.getDataLayout());
  Callee = DAG.getGlobalAddress(G->getGlobal(), Loc, PtrVT, 0);

  std::vector<SDValue> Ops;
  Ops.push_back(Chain);
  Ops.push_back(Callee);

  // Add argument registers to the end of the list so that they are known live
  // into the call.
  for (auto &Reg : RegsToPass) {
    Ops.push_back(DAG.getRegister(Reg.first, Reg.second.getValueType()));
  }

  // Add a register mask operand representing the call-preserved registers.
  const uint32_t *Mask;
  const TargetRegisterInfo *TRI = DAG.getSubtarget().getRegisterInfo();
  Mask = TRI->getCallPreservedMask(DAG.getMachineFunction(), CallConv);

  assert(Mask && "Missing call preserved mask for calling convention");
  Ops.push_back(DAG.getRegisterMask(Mask));

  if (InFlag.getNode()) {
    Ops.push_back(InFlag);
  }

  SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);

  // Returns a chain and a flag for retval copy to use.
  Chain = DAG.getNode(TriCoreISD::CALL, Loc, NodeTys, Ops);
  InFlag = Chain.getValue(1);

  Chain = DAG.getCALLSEQ_END(Chain, DAG.getIntPtrConstant(NumBytes, Loc, true),
                             DAG.getIntPtrConstant(0, Loc, true), InFlag, Loc);
  if (!Ins.empty()) {
    InFlag = Chain.getValue(1);
  }

  // Handle result values, copying them out of physregs into vregs that we
  // return.
  return LowerCallResult(Chain, InFlag, CallConv, isVarArg, Ins, Loc, DAG,
                         InVals);
}

SDValue TriCoreTargetLowering::LowerCallResult(
    SDValue Chain, SDValue InGlue, CallingConv::ID CallConv, bool isVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, SDLoc dl, SelectionDAG &DAG,
    SmallVectorImpl<SDValue> &InVals) const {
  assert(!isVarArg && "Unsupported");

  // Assign locations to each value returned by this call.
  SmallVector<CCValAssign, 16> RVLocs;
  CCState CCInfo(CallConv, isVarArg, DAG.getMachineFunction(), RVLocs,
                 *DAG.getContext());

  CCInfo.AnalyzeCallResult(Ins, RetCC_TriCore);

  // Copy all of the result registers out of their specified physreg.
  for (auto &Loc : RVLocs) {
    Chain = DAG.getCopyFromReg(Chain, dl, Loc.getLocReg(), Loc.getValVT(),
                               InGlue).getValue(1);
    InGlue = Chain.getValue(2);
    InVals.push_back(Chain.getValue(0));
  }

  return Chain;
}

//===----------------------------------------------------------------------===//
//             Formal Arguments Calling Convention Implementation
//===----------------------------------------------------------------------===//

/// TriCore formal arguments implementation
SDValue TriCoreTargetLowering::LowerFormalArguments(
    SDValue Chain, CallingConv::ID CallConv, bool isVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, SDLoc dl, SelectionDAG &DAG,
    SmallVectorImpl<SDValue> &InVals) const {
  MachineFunction &MF = DAG.getMachineFunction();
  MachineRegisterInfo &RegInfo = MF.getRegInfo();

  assert(!isVarArg && "VarArg not supported");

  // Assign locations to all of the incoming arguments.
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, isVarArg, DAG.getMachineFunction(), ArgLocs,
                 *DAG.getContext());

  CCInfo.AnalyzeFormalArguments(Ins, CC_TriCore);

  for (auto &VA : ArgLocs) {
    if (VA.isRegLoc()) {
      // Arguments passed in registers
      EVT RegVT = VA.getLocVT();
      assert(RegVT.getSimpleVT().SimpleTy == MVT::i32 &&
             "Only support MVT::i32 register passing");
      const unsigned VReg = RegInfo.createVirtualRegister(&TriCore::DataRegsRegClass);
      RegInfo.addLiveIn(VA.getLocReg(), VReg);
      SDValue ArgIn = DAG.getCopyFromReg(Chain, dl, VReg, RegVT);

      InVals.push_back(ArgIn);
      continue;
    }

    assert(VA.isMemLoc() &&
           "Can only pass arguments as either registers or via the stack");

    const unsigned Offset = VA.getLocMemOffset();

    const int FI = MF.getFrameInfo()->CreateFixedObject(4, Offset, true);
    EVT PtrTy = getPointerTy(DAG.getDataLayout());
    SDValue FIPtr = DAG.getFrameIndex(FI, PtrTy);

    assert(VA.getValVT() == MVT::i32 &&
           "Only support passing arguments as i32");
    SDValue Load = DAG.getLoad(VA.getValVT(), dl, Chain, FIPtr,
                               MachinePointerInfo(), false, false, false, 0);

    InVals.push_back(Load);
  }

  return Chain;
}

//===----------------------------------------------------------------------===//
//               Return Value Calling Convention Implementation
//===----------------------------------------------------------------------===//

bool TriCoreTargetLowering::CanLowerReturn(
    CallingConv::ID CallConv, MachineFunction &MF, bool isVarArg,
    const SmallVectorImpl<ISD::OutputArg> &Outs, LLVMContext &Context) const {
  SmallVector<CCValAssign, 16> RVLocs;
  CCState CCInfo(CallConv, isVarArg, MF, RVLocs, Context);
  if (!CCInfo.CheckReturn(Outs, RetCC_TriCore)) {
    return false;
  }
  if (CCInfo.getNextStackOffset() != 0 && isVarArg) {
    return false;
  }
  return true;
}

SDValue
TriCoreTargetLowering::LowerReturn(SDValue Chain, CallingConv::ID CallConv,
                               bool isVarArg,
                               const SmallVectorImpl<ISD::OutputArg> &Outs,
                               const SmallVectorImpl<SDValue> &OutVals,
                               SDLoc dl, SelectionDAG &DAG) const {
  if (isVarArg) {
    report_fatal_error("VarArg not supported");
  }

  // CCValAssign - represent the assignment of
  // the return value to a location
  SmallVector<CCValAssign, 16> RVLocs;

  // CCState - Info about the registers and stack slot.
  CCState CCInfo(CallConv, isVarArg, DAG.getMachineFunction(), RVLocs,
                 *DAG.getContext());

  CCInfo.AnalyzeReturn(Outs, RetCC_TriCore);

  SDValue Flag;
  SmallVector<SDValue, 4> RetOps(1, Chain);

  // Copy the result values into the output registers.
  for (unsigned i = 0, e = RVLocs.size(); i < e; ++i) {
    CCValAssign &VA = RVLocs[i];
    assert(VA.isRegLoc() && "Can only return in registers!");

    Chain = DAG.getCopyToReg(Chain, dl, VA.getLocReg(), OutVals[i], Flag);

    Flag = Chain.getValue(1);
    RetOps.push_back(DAG.getRegister(VA.getLocReg(), VA.getLocVT()));
  }

  RetOps[0] = Chain; // Update chain.

  // Add the flag if we have it.
  if (Flag.getNode()) {
    RetOps.push_back(Flag);
  }

  return DAG.getNode(TriCoreISD::RET_FLAG, dl, MVT::Other, RetOps);
}
