//==-- TriCoreISelLowering.h - TriCore DAG Lowering Interface -----*- C++ -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the interfaces that TriCore uses to lower LLVM code into a
// selection DAG.
//
//===----------------------------------------------------------------------===//

#ifndef TriCoreISELLOWERING_H
#define TriCoreISELLOWERING_H

#include "TriCore.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/Target/TargetLowering.h"

namespace llvm {

// Forward delcarations
class TriCoreSubtarget;
class TriCoreTargetMachine;

namespace TriCoreISD {
enum NodeType {
  // Start the numbering where the builtin ops and target ops leave off.
  FIRST_NUMBER = ISD::BUILTIN_OP_END,
  RET_FLAG,
  // This loads the symbol (e.g. global address) into a register.
  LOAD_SYM,
  // This loads a 32-bit immediate into a register.
  MOVEi32,
  CALL,
	CMP,
	CMPB,
	BR_CC,
	BR_CC_new,
	Wrapper
};
}

//===--------------------------------------------------------------------===//
// TargetLowering Implementation
//===--------------------------------------------------------------------===//
class TriCoreTargetLowering : public TargetLowering {
public:
  explicit TriCoreTargetLowering(TriCoreTargetMachine &TM);

  /// LowerOperation - Provide custom lowering hooks for some operations.
  virtual SDValue LowerOperation(SDValue Op, SelectionDAG &DAG) const;

  /// getTargetNodeName - This method returns the name of a target specific
  //  DAG node.
  virtual const char *getTargetNodeName(unsigned Opcode) const;

private:
  const TriCoreSubtarget &Subtarget;

  SDValue LowerFormalArguments(SDValue Chain, CallingConv::ID CallConv,
                               bool isVarArg,
                               const SmallVectorImpl<ISD::InputArg> &Ins,
                               SDLoc dl, SelectionDAG &DAG,
                               SmallVectorImpl<SDValue> &InVals) const override;

  SDValue LowerCall(TargetLowering::CallLoweringInfo &CLI,
                    SmallVectorImpl<SDValue> &InVals) const override;

  SDValue LowerReturn(SDValue Chain, CallingConv::ID CallConv, bool isVarArg,
                      const SmallVectorImpl<ISD::OutputArg> &Outs,
                      const SmallVectorImpl<SDValue> &OutVals, SDLoc dl,
                      SelectionDAG &DAG) const override;

  SDValue LowerCallResult(SDValue Chain, SDValue InGlue,
                          CallingConv::ID CallConv, bool isVarArg,
                          const SmallVectorImpl<ISD::InputArg> &Ins, SDLoc dl,
                          SelectionDAG &DAG,
                          SmallVectorImpl<SDValue> &InVals) const;

  bool CanLowerReturn(CallingConv::ID CallConv, MachineFunction &MF,
                      bool isVarArg,
                      const SmallVectorImpl<ISD::OutputArg> &ArgsFlags,
                      LLVMContext &Context) const;

  // LowerGlobalAddress - Emit a constant load to the global address.
  SDValue LowerGlobalAddress(SDValue Op, SelectionDAG &DAG) const;


  //Lower Branch
  SDValue LowerBR_CC(SDValue Op, SelectionDAG &DAG) const;
};
}

#endif // TriCoreISELLOWERING_H

