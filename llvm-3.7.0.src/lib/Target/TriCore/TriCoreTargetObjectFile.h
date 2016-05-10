//-- TriCoreTargetObjectFile.h - Define TargetObjectFile for Tricore-*- C++-*-//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the TriCore specific subclass of TargetMachine.
//
//===----------------------------------------------------------------------===//

#ifndef TRICORETARGETOBJECTFILE_H
#define TRICORETARGETOBJECTFILE_H

#include "TriCoreTargetMachine.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"

namespace llvm {
class TriCoreTargetMachine;
  class TriCoreTargetObjectFile : public TargetLoweringObjectFileELF {
    MCSection *SmallDataSection;
    MCSection *SmallBSSSection;
    const TriCoreTargetMachine *TM;
  public:

    void Initialize(MCContext &Ctx, const TargetMachine &TM) override;

    /// IsGlobalInSmallSection - Return true if this global address should be
    /// placed into small data/bss section.
    bool IsGlobalInSmallSection(const GlobalValue *GV,
                                const TargetMachine &TM, SectionKind Kind) const;
    bool IsGlobalInSmallSection(const GlobalValue *GV,
                                const TargetMachine &TM) const;
    bool IsGlobalInSmallSectionImpl(const GlobalValue *GV,
                                    const TargetMachine &TM) const;

    MCSection *SelectSectionForGlobal(const GlobalValue *GV, SectionKind Kind,
                                      Mangler &Mang,
                                      const TargetMachine &TM) const override;
  };
} // end namespace llvm

#endif
