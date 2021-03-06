//===-- Cpu0Subtarget.h - Define Subtarget for the Cpu0 ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the Cpu0 specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef CPU0SUBTARGET_H
#define CPU0SUBTARGET_H

#include "Cpu0Config.h"
#if CH >= CH3_1

#include "Cpu0FrameLowering.h"
#include "Cpu0ISelLowering.h"
#include "Cpu0InstrInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/MC/MCInstrItineraries.h"
#include "llvm/Target/TargetSelectionDAGInfo.h"
#include "llvm/Target/TargetSubtargetInfo.h"
#include <string>

#define GET_SUBTARGETINFO_HEADER
#include "Cpu0GenSubtargetInfo.inc"

#if CH >= CH6_1 //1
extern bool Cpu0ReserveGP;
extern bool Cpu0NoCpload;
#endif

//@1
namespace llvm {
class StringRef;

class Cpu0TargetMachine;

class Cpu0Subtarget : public Cpu0GenSubtargetInfo {
  virtual void anchor();

public:

  bool HasChapterDummy;
  bool HasChapterAll;

  bool hasChapter3_1() const {
#if CH >= CH3_1
    return true;
#else
    return false;
#endif
  }

  bool hasChapter3_2() const {
#if CH >= CH3_2
    return true;
#else
    return false;
#endif
  }

  bool hasChapter3_3() const {
#if CH >= CH3_3
    return true;
#else
    return false;
#endif
  }

  bool hasChapter3_4() const {
#if CH >= CH3_4
    return true;
#else
    return false;
#endif
  }

  bool hasChapter3_5() const {
#if CH >= CH3_5
    return true;
#else
    return false;
#endif
  }

  bool hasChapter4_1() const {
#if CH >= CH4_1
    return true;
#else
    return false;
#endif
  }

  bool hasChapter4_2() const {
#if CH >= CH4_2
    return true;
#else
    return false;
#endif
  }

  bool hasChapter5_1() const {
#if CH >= CH5_1
    return true;
#else
    return false;
#endif
  }

  bool hasChapter6_1() const {
#if CH >= CH6_1
    return true;
#else
    return false;
#endif
  }

  bool hasChapter7_1() const {
#if CH >= CH7_1
    return true;
#else
    return false;
#endif
  }

  bool hasChapter8_1() const {
#if CH >= CH8_1
    return true;
#else
    return false;
#endif
  }

  bool hasChapter8_2() const {
#if CH >= CH8_2
    return true;
#else
    return false;
#endif
  }
  
  bool hasChapter9_1() const {
#if CH >= CH9_1
    return true;
#else
    return false;
#endif
  }

  bool hasChapter9_2() const {
#if CH >= CH9_2
    return true;
#else
    return false;
#endif
  }

  bool hasChapter9_3() const {
#if CH >= CH9_3
    return true;
#else
    return false;
#endif
  }

  bool hasChapter10_1() const {
#if CH >= CH10_1
    return true;
#else
    return false;
#endif
  }

  bool hasChapter11_1() const {
#if CH >= CH11_1
    return true;
#else
    return false;
#endif
  }

  bool hasChapter11_2() const {
#if CH >= CH11_2
    return true;
#else
    return false;
#endif
  }

  bool hasChapter12_1() const {
#if CH >= CH12_1
    return true;
#else
    return false;
#endif
  }

protected:
  enum Cpu0ArchEnum {
    Cpu032I,
    Cpu032II
  };

  // Cpu0 architecture version
  Cpu0ArchEnum Cpu0ArchVersion;

  // IsLittle - The target is Little Endian
  bool IsLittle;

  bool EnableOverflow;

  // HasCmp - cmp instructions.
  bool HasCmp;

  // HasSlt - slt instructions.
  bool HasSlt;

  InstrItineraryData InstrItins;

#if CH >= CH6_1 //RM
  // UseSmallSection - Small section is used.
  bool UseSmallSection;
#endif //TM

  const Cpu0TargetMachine &TM;

  Triple TargetTriple;

  const TargetSelectionDAGInfo TSInfo;

  std::unique_ptr<const Cpu0InstrInfo> InstrInfo;
  std::unique_ptr<const Cpu0FrameLowering> FrameLowering;
  std::unique_ptr<const Cpu0TargetLowering> TLInfo;

public:
  /// This constructor initializes the data members to match that
  /// of the specified triple.
  Cpu0Subtarget(const Triple &TT, const std::string &CPU, const std::string &FS,
                bool little, const Cpu0TargetMachine &_TM);

//- Vitual function, must have
  /// ParseSubtargetFeatures - Parses features string setting specified
  /// subtarget options.  Definition of function is auto generated by tblgen.
  void ParseSubtargetFeatures(StringRef CPU, StringRef FS);

  bool isLittle() const { return IsLittle; }
  bool hasCpu032I() const { return Cpu0ArchVersion >= Cpu032I; }
  bool isCpu032I() const { return Cpu0ArchVersion == Cpu032I; }
  bool hasCpu032II() const { return Cpu0ArchVersion >= Cpu032II; }
  bool isCpu032II() const { return Cpu0ArchVersion == Cpu032II; }

  /// Features related to the presence of specific instructions.
  bool enableOverflow() const { return EnableOverflow; }
  bool disableOverflow() const { return !EnableOverflow; }
  bool hasCmp()   const { return HasCmp; }
  bool hasSlt()   const { return HasSlt; }

#if CH >= CH6_1 //hasSlt
  bool useSmallSection() const { return UseSmallSection; }
#endif //abiUsesSoftFloat

  bool abiUsesSoftFloat() const;

  const InstrItineraryData *getInstrItineraryData() const { return &InstrItins; }

  unsigned stackAlignment() const { return 8; }

  Cpu0Subtarget &initializeSubtargetDependencies(StringRef CPU, StringRef FS,
                                                 const TargetMachine &TM);

  const Cpu0InstrInfo *getInstrInfo() const { return InstrInfo.get(); }
  const TargetFrameLowering *getFrameLowering() const {
    return FrameLowering.get();
  }
  const Cpu0RegisterInfo *getRegisterInfo() const {
    return &InstrInfo->getRegisterInfo();
  }
  const Cpu0TargetLowering *getTargetLowering() const { return TLInfo.get(); }
};
} // End llvm namespace


#endif
#endif // #if CH >= CH3_1
