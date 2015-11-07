//=== TriCoreInstPrinter.h - Convert TriCore MCInst to assembly syntax ---====//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief This file contains the declaration of the TriCoreInstPrinter class,
/// which is used to print TriCore MCInst to a .s file.
///
//===----------------------------------------------------------------------===//

#ifndef TriCoreINSTPRINTER_H
#define TriCoreINSTPRINTER_H
#include "llvm/MC/MCInstPrinter.h"

namespace llvm {

class TargetMachine;

class TriCoreInstPrinter : public MCInstPrinter {
public:
  TriCoreInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                 const MCRegisterInfo &MRI)
      : MCInstPrinter(MAI, MII, MRI) {}

  // Autogenerated by tblgen.
  void printInstruction(const MCInst *MI, raw_ostream &O);
  static const char *getRegisterName(unsigned RegNo);

  virtual void printRegName(raw_ostream &OS, unsigned RegNo) const override;
  virtual void printInst(const MCInst *MI, raw_ostream &OS, StringRef Annot,
                         const MCSubtargetInfo &STI) override;



private:
  void printCondCode(const MCInst *MI, unsigned OpNum, raw_ostream &O);
  void printAddrModeMemSrc(const MCInst *MI, unsigned OpNum, raw_ostream &O);
  void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printMemOperand(const MCInst *MI, int opNum, raw_ostream &O);
  void printZExt4Imm(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  template <unsigned int bits>
    void printSExtImm(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printZExt8Imm(const MCInst *MI, int OpNo, raw_ostream &O);
  void printPCRelImmOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printCCOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);

};
} // end namespace llvm

#endif
