//===-- TriCoreOperators.td - TriCore-specific operators ------*- tblgen-*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Type profiles
//===----------------------------------------------------------------------===//

def MoveImm32Ty : SDTypeProfile<1, 1, [
  SDTCisSameAs<0, 1>, SDTCisInt<0>
]>;

def SDT_TriCoreCallSeqStart : SDCallSeqStart<[ SDTCisVT<0, i32> ]>;

def SDT_TriCoreCallSeqEnd   : SDCallSeqEnd<[
  SDTCisVT<0, i32>, SDTCisVT<1, i32>
]>;

def TriCoreRetFlag    : SDNode<"TriCoreISD::RET_FLAG", SDTNone,
                           [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;
def callseq_start : SDNode<"ISD::CALLSEQ_START", SDT_TriCoreCallSeqStart,
                           [SDNPHasChain, SDNPOutGlue]>;
def callseq_end   : SDNode<"ISD::CALLSEQ_END",   SDT_TriCoreCallSeqEnd,
                           [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

def SDT_TriCoreCall    : SDTypeProfile<0, -1, [SDTCisPtrTy<0>]>;

//===----------------------------------------------------------------------===//
// Custom SDNodes.
//===----------------------------------------------------------------------===//

def load_sym : SDNode<"TriCoreISD::LOAD_SYM", SDTIntUnaryOp>;

def movei32 : SDNode<"TriCoreISD::MOVEi32", MoveImm32Ty>;

def tricore_call
    : SDNode<"TriCoreISD::CALL", SDT_TriCoreCall,
             [ SDNPHasChain, SDNPOptInGlue, SDNPOutGlue, SDNPVariadic ]>;

//===----------------------------------------------------------------------===//
// Operand Definitions.
//===----------------------------------------------------------------------===//

def bl_target : Operand<i32>;

def b_target : Operand<OtherVT>;

def cc_val : Operand<i32> {
  let PrintMethod = "printCondCode";
}

def memsrc : Operand<i32> {
  let MIOperandInfo = (ops DataRegs, i32imm);
  let PrintMethod = "printAddrModeMemSrc";
  let EncoderMethod = "getMemSrcValue";
}

def i32imm_lo : Operand<i32>, ImmLeaf<i32, [{
  return Imm >= 0 && Imm < 65536;
}]>;

def TriCoreimm8 : Operand<i32>, ImmLeaf<i32, [{
  return Imm >= 0 && Imm < 256;
}]>;

//===----------------------------------------------------------------------===//
// Custom Operand Definitions.
//===----------------------------------------------------------------------===//

//Operand
def s9imm      : Operand<i32> { let PrintMethod = "printSExtImm<9>";  }
def s4imm      : Operand<i32> { let PrintMethod = "printSExtImm<4>";  }
def s16imm     : Operand<i32> { let PrintMethod = "printSExtImm<16>"; }
def u8imm      : Operand<i32> { let PrintMethod = "printZExtImm<8>";  }
def u4imm      : Operand<i32> { let PrintMethod = "printZExtImm<4>";  }
def u9imm      : Operand<i32> { let PrintMethod = "printZExtImm<9>";  }

//Node
//def immSExt9 : ImmLeaf<i32, [{
//  return Imm >= -256 && Imm < 256;
//}]>;


def immSExt4  : PatLeaf<(imm), [{ return isInt<4>(N->getSExtValue()); }]>;
def immSExt9  : PatLeaf<(imm), [{ return isInt<9>(N->getSExtValue()); }]>;
def immSExt16  : PatLeaf<(imm), [{ return isInt<16>(N->getSExtValue()); }]>;

def immZExt8 : ImmLeaf<i32, [{return Imm == (Imm & 0xff);}]>;
def immZExt4 : ImmLeaf<i32, [{return Imm == (Imm & 0x0f);}]>;
def immZExt9 : ImmLeaf<i32, [{return Imm == (Imm & 0x1ff);}]>;

//===----------------------------------------------------------------------===//
// Complex Pattern Definitions.
//===----------------------------------------------------------------------===//

def addr : ComplexPattern<iPTR, 2, "SelectAddr", [], []>;

