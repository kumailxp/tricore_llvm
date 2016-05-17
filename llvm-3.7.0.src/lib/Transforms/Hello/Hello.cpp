//===- Hello.cpp - Example code from "Writing an LLVM Pass" ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements two versions of the LLVM "Hello World" pass described
// in docs/WritingAnLLVMPass.html
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/Statistic.h"
#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include <llvm/Analysis/LoopInfo.h>
using namespace llvm;

#define DEBUG_TYPE "hello"

STATISTIC(HelloCounter, "Counts number of functions greeted");

namespace {
/*
  struct Hello : public FunctionPass {
    static char ID;
    Hello() : FunctionPass(ID) {}
    
    void getAnalysisUsage(AnalysisUsage &AU) const override {
      AU.setPreservesCFG();
      AU.addRequired<LoopInfoWrapperPass>();
    }
    
    bool runOnFunction(Function& F) override {
      LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
      for (LoopInfo::iterator LIT = LI.begin(); LIT != LI.end(); ++LIT) {
        Loop* ll = *LIT;  
        ll->dump();
      }
      return false;
    }

    bool runOnLoop(Loop *L, LPPassManager &LPM) override {
      if (PHINode* ph = L->getCanonicalInductionVariable())
        errs() << *ph << '\n' ;

      return false;
    }
    
  };
*/
  // Hello - The first implementation, without getAnalysisUsage.
  struct Hello : public FunctionPass {
    static char ID; // Pass identification, replacement for typeid
    Hello() : FunctionPass(ID) {}

    bool runOnFunction(Function &F) override {
      ++HelloCounter;
//      errs() << "Hello: ";
//      errs().write_escaped(F.getName()) << '\n';
      SmallVector<StringRef, 8> names;
      Module* md = F.getParent();
      md->getMDKindNames(names);
      for( auto &X : names)
        errs() << X << '\n';
      for (Instruction& I : inst_range(F) ) {
        if (I.isTerminator()) {
          if ( strcmp(I.getOperand(0)->getName().str().c_str(), "cmp") == 0 )
              if ( CmpInst *cp = dyn_cast<CmpInst>(I.getPrevNode()) )
                  errs() << cp->getPredicate() << '\n';
        }
      }
      return false;
    }
  };
  
}

char Hello::ID = 0;
static RegisterPass<Hello> X("hello", "Hello World Pass");

namespace {
  // Hello2 - The second implementation with getAnalysisUsage implemented.
  struct Hello2 : public FunctionPass {
    static char ID; // Pass identification, replacement for typeid
    Hello2() : FunctionPass(ID) {}

    bool runOnFunction(Function &F) override {
      ++HelloCounter;
      errs() << "Hello: ";
      errs().write_escaped(F.getName()) << '\n';
      return false;
    }

    // We don't modify the program, so we preserve all analyses.
    void getAnalysisUsage(AnalysisUsage &AU) const override {
      AU.setPreservesAll();
    }
  };
}

char Hello2::ID = 0;
static RegisterPass<Hello2>
Y("hello2", "Hello World Pass (with getAnalysisUsage implemented)");
