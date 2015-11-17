//==-- TriCoreInstPrinter.cpp - Convert TriCore MCInst to assembly syntax -===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This class prints an TriCore MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "asm-printer"
#include "TriCoreInstPrinter.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "../TriCore.h"
using namespace llvm;

#include "TriCoreGenAsmWriter.inc"

void TriCoreInstPrinter::printRegName(raw_ostream &OS, unsigned RegNo) const {
  OS << StringRef(getRegisterName(RegNo)).lower();

  //outs() <<"printRegName: " <<  StringRef(getRegisterName(RegNo)).lower() << "\n";
}

void TriCoreInstPrinter::printInst(const MCInst *MI, raw_ostream &O,
                               StringRef Annot, const MCSubtargetInfo &STI) {
  printInstruction(MI, O);
  printAnnotation(O, Annot);
}

static void printExpr(const MCExpr *Expr, raw_ostream &OS) {
  int Offset = 0;
  const MCSymbolRefExpr *SRE;

  if (const MCBinaryExpr *BE = dyn_cast<MCBinaryExpr>(Expr)) {
    SRE = dyn_cast<MCSymbolRefExpr>(BE->getLHS());
    const MCConstantExpr *CE = dyn_cast<MCConstantExpr>(BE->getRHS());
    assert(SRE && CE && "Binary expression must be sym+const.");
    Offset = CE->getValue();
  } else {
    SRE = dyn_cast<MCSymbolRefExpr>(Expr);
    assert(SRE && "Unexpected MCExpr type.");
  }
  const MCSymbolRefExpr::VariantKind Kind = SRE->getKind();
  assert(Kind == MCSymbolRefExpr::VK_None ||
         Kind == MCSymbolRefExpr::VK_TRICORE_LO ||
         Kind == MCSymbolRefExpr::VK_TRICORE_HI);

  OS << SRE->getSymbol();

  if (Offset) {
    if (Offset > 0) {
      OS << '+';
    }
    OS << Offset;
  }
}

void TriCoreInstPrinter::printPCRelImmOperand(const MCInst *MI, unsigned OpNo,
                                             raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNo);
  if (Op.isImm())
    O << Op.getImm();
  else {
    assert(Op.isExpr() && "unknown pcrel immediate operand");
    Op.getExpr()->print(O, &MAI);
  }
}



const char * _condCodeToString(ISD::CondCode CC) {
  switch (CC) {
  default:
  case ISD::SETCC_INVALID:
  case ISD::SETFALSE:      //    0 0 0 0       Always false (always folded)
  case ISD::SETFALSE2:     //  1 X 0 0 0       Always false (always folded)
  case ISD::SETOEQ:        //    0 0 0 1       True if ordered and equal
  case ISD::SETOGT:        //    0 0 1 0       True if ordered and greater than
  case ISD::SETOGE:        //    0 0 1 1       True if ordered and greater than or equal
  case ISD::SETOLT:        //    0 1 0 0       True if ordered and less than
  case ISD::SETOLE:        //    0 1 0 1       True if ordered and less than or equal
  case ISD::SETONE:        //    0 1 1 0       True if ordered and operands are unequal
  case ISD::SETO:          //    0 1 1 1       True if ordered (no nans)
  case ISD::SETUO:         //    1 0 0 0       True if unordered: isnan(X) | isnan(Y)
  case ISD::SETUEQ:        //    1 0 0 1       True if unordered or equal
  case ISD::SETUGT:        //    1 0 1 0       True if unordered or greater than
  case ISD::SETUGE:        //    1 0 1 1       True if unordered, greater than, or equal
  case ISD::SETULT:        //    1 1 0 0       True if unordered or less than
  case ISD::SETULE:        //    1 1 0 1       True if unordered, less than, or equal
  case ISD::SETUNE:        //    1 1 1 0       True if unordered or not equal
    llvm_unreachable("Invalid or unsupported condition code");
    return nullptr;

  case ISD::SETTRUE:       //    1 1 1 1       Always true (always folded)
  case ISD::SETTRUE2:      //  1 X 1 1 1       Always true (always folded)
    return "";

  // Don't care operations: undefined if the input is a nan.
  case ISD::SETEQ:         //  1 X 0 0 1       True if equal
    return "eq";
  case ISD::SETGT:         //  1 X 0 1 0       True if greater than
    return "gt";
  case ISD::SETGE:         //  1 X 0 1 1       True if greater than or equal
    return "ge";
  case ISD::SETLT:         //  1 X 1 0 0       True if less than
    return "lt";
  case ISD::SETLE:         //  1 X 1 0 1       True if less than or equal
    return "le";
  case ISD::SETNE:         //  1 X 1 1 0       True if not equal
    return "ne";
  }
}


//static StringRef _printCondCode(unsigned e) {
//
//	switch(e){
//	default: return "unknown";
//	case TriCoreCC::COND_E: return "COND_E";
//	case TriCoreCC::COND_NE: return "COND_NE";
//	case TriCoreCC::COND_HS: return "COND_HS";
//	case TriCoreCC::COND_LO: return "COND_LO";
//	case TriCoreCC::COND_GE: return "COND_GE";
//	case TriCoreCC::COND_L: return "COND_L";
//	}
//}
//
void TriCoreInstPrinter::printCCOperand(const MCInst *MI, unsigned OpNo,
                                       raw_ostream &O) {



	const MCOperand &Op = MI->getOperand(OpNo);
	ISD::CondCode CC = (ISD::CondCode)Op.getImm();
	const char *Str = _condCodeToString(CC);

	outs() <<"Cond code: " << Str << "\n";

	O << Str;


//  unsigned CC = MI->getOperand(OpNo).getImm();
//  outs()<<_printCondCode(CC)<<"\n";
//  switch (CC) {
//  default:
//   llvm_unreachable("Unsupported CC code");
//  case TriCoreCC::COND_E:
//   O << "eq";
//   break;
//  case TriCoreCC::COND_NE:
//   O << "ne";
//   break;
//  case TriCoreCC::COND_HS:
//   O << "hs";
//   break;
//  case TriCoreCC::COND_LO:
//   O << "lo";
//   break;
//  case TriCoreCC::COND_GE:
//   O << "ge";
//   break;
//  case TriCoreCC::COND_L:
//   O << 'l';
//   break;
//  }
}



//===----------------------------------------------------------------------===//
// PrintSExtImm<unsigned bits>
//===----------------------------------------------------------------------===//
template <unsigned int bits>
void TriCoreInstPrinter::printSExtImm(const MCInst *MI, unsigned OpNo,
                                       raw_ostream &O) {
  int Value = MI->getOperand(OpNo).getImm();
  Value = SignExtend32<bits>(Value);
  O << (int)Value;
}


void TriCoreInstPrinter::printZExt8Imm(const MCInst *MI, int OpNo,
                                       raw_ostream &O) {
  unsigned int Value = MI->getOperand(OpNo).getImm();
  assert(Value <= 255 && "Invalid u8imm argument!");
  //Value =  (unsigned char)(Value);
  O << (unsigned int)Value;
}


void TriCoreInstPrinter::printZExt4Imm(const MCInst *MI, unsigned OpNo,
											raw_ostream &O) {
  unsigned int Value = MI->getOperand(OpNo).getImm();
  assert(Value <= 15 && "Invalid u4imm argument!");
  O << (unsigned int)Value;
}


/*
//Print unsigned operand
void TriCoreInstPrinter::printUnsignedImm(const MCInst *MI, int opNum,
                                       raw_ostream &O) {
  const MCOperand &MO = MI->getOperand(opNum);
  if (MO.isImm())
    O << MO.getImm();
  else
    printOperand(MI, opNum, O);
}
*/

// Print a condition code (e.g. for predication).
void TriCoreInstPrinter::printCondCode(const MCInst *MI, unsigned OpNum,
                                   raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNum);
  ISD::CondCode CC = (ISD::CondCode)Op.getImm();
  const char *Str = _condCodeToString(CC);
  O << Str;
}

// Print a 'memsrc' operand which is a (Register, Offset) pair.
void TriCoreInstPrinter::printAddrModeMemSrc(const MCInst *MI, unsigned OpNum,
                                         raw_ostream &O) {
//  const MCOperand &Op1 = MI->getOperand(OpNum);
//  const MCOperand &Op2 = MI->getOperand(OpNum + 1);
//  O << "[";
//  printRegName(O, Op1.getReg());
//
//  unsigned Offset = Op2.getImm();
//  if (Offset) {
//    O << ", #" << Offset;
//  }
//  O << "]";

  const MCOperand &Base = MI->getOperand(OpNum);
	const MCOperand &Disp = MI->getOperand(OpNum+1);

  if (!Base.getReg())
      O << '&';

    if (Disp.isExpr())
      Disp.getExpr()->print(O, &MAI);
    else {
      assert(Disp.isImm() && "Expected immediate in displacement field");
      O << Disp.getImm();
    }

    // Print register base field
    if (Base.getReg())
      O << '(' << getRegisterName(Base.getReg()) << ')';

}

void TriCoreInstPrinter::printOperand(const MCInst *MI, unsigned OpNo,
                                  raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNo);
  if (Op.isReg()) {
    printRegName(O, Op.getReg());
    return;
  }

  if (Op.isImm()) {
    O << "#" << Op.getImm();
    return;
  }

  assert(Op.isExpr() && "unknown operand kind in printOperand");
  printExpr(Op.getExpr(), O);
}
