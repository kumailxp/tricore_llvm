//===-- TriCoreInstrInfo.td - Target Description for TriCore ---*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the TriCore instructions in TableGen format.
//
//===----------------------------------------------------------------------===//

include "TriCoreInstrFormats.td"
include "TriCoreOperators.td"

//===----------------------------------------------------------------------===//
// Mov Instructions
//===----------------------------------------------------------------------===//
def MOVrr  : RR<0x87, 0x99, (outs DataRegs:$d), (ins DataRegs:$s2),
                     "mov $d, $s2",
                     [/* No pattern */]> {
      let n = 0b00;
      let s1 = 0b0000;
}

//===----------------------------------------------------------------------===//
// Mov Immediate Instructions
//===----------------------------------------------------------------------===//

class MOV<bits<8> opcode, string opstr, dag ins, list<dag>pattern>
    : RLC<opcode, (outs DataRegs:$d), ins,
              !strconcat(opstr, " $d, $const16"), pattern> {
  
  bits<16> const16;
  //bits<16> imm;
  //let Inst{15-12} = dst;
  //let Inst{11-0}  = imm{11-0};
  //let Inst{19-16} = imm{15-12};
  //let Inst{20} = 0;
  //let Inst{25} = 1;

  let const16 = const16;
}

def MOVLOi16 : MOV<0x81, "mov", (ins i32imm:$const16),
                  [(set i32:$d, i32imm_lo:$const16)]>;
def MOVHIi16 : MOV<0x82, "mov.h", (ins DataRegs:$s1, i32imm:$const16),
                  [/* No Pattern */]>;

def MOVi32 : InstTriCore<(outs DataRegs:$dst), (ins i32imm:$src), "",
                     [(set i32:$dst, (movei32 imm:$src))]> {
  let isPseudo = 1;
}

//===----------------------------------------------------------------------===//
// Load/Store Instructions
//===----------------------------------------------------------------------===//

def LDR  : BOL<0x62,(outs DataRegs:$s1_d), (ins memsrc:$off16),
                   "ldr $s1_d, $off16",
                   [(set i32:$s1_d, (load addr:$off16))]> {
}

def STR : BOL<0x63,(outs), (ins DataRegs:$s1_d, memsrc:$off16),
                  "str $s1_d, $off16",
                  [(store i32:$s1_d, addr:$off16)]> {
}

//===----------------------------------------------------------------------===//
// Return Instructions
//===----------------------------------------------------------------------===//

let isTerminator = 1, isReturn = 1, isBarrier = 1, Uses = [A11] in {
  def RET : T32<(outs), (ins variable_ops),
                    "ret",  [(TriCoreRetFlag)]> {
    let Inst{27-0}  = 0b0001001011111111111100011110;
  }
}


//===----------------------------------------------------------------------===//
// Call Instructions
//===----------------------------------------------------------------------===//

let isCall = 1, Defs = [A11], Uses = [A10] in {
  def BL : B<0x65, (outs), (ins i32imm:$disp24),
                      "bl $disp24",
                      [(tricore_call i32:$disp24)]> {
    bits<4> addr;
    let Inst{31-28} = 0b1110;
    let Inst{3-0} = addr;
  }
}

def : Pattern<(i32 (load_sym tglobaladdr:$addr)),  [(MOVi32 $addr)]>;

//===----------------------------------------------------------------------===//
// Pseudo Instructions
//===----------------------------------------------------------------------===//

let Defs = [A10], Uses = [A10] in {
def ADJCALLSTACKDOWN : TriCorePseudoInst<(outs), (ins i32imm:$amt),
                                    "# ADJCALLSTACKDOWN $amt",
                                    [(callseq_start timm:$amt)]>;
def ADJCALLSTACKUP   : TriCorePseudoInst<(outs), (ins i32imm:$amt1, i32imm:$amt2),
                                    "# ADJCALLSTACKUP $amt1",
                                    [(callseq_end timm:$amt1, timm:$amt2)]>;
}
