//==-- TriCoreInstrFormats.td - TriCore Instruction Formats -*- tablegen -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

//include "llvm/Target/Target.td"  // Include for debuging purpose only

//===----------------------------------------------------------------------===//
//  Describe TriCore instructions format
//
//  CPU INSTRUCTION FORMATS
//
//  op1     - primary operation code.
//  op2     - secondary operation code,
//  s1      - source register 1
//  s2      - source register 2
//  d       - destination register
//  n       - multiplication shift value (0b00 or 0b01)
//  const9  - 9 bits immediate value
//  disp24  - 24 bits displacment value
//
//===----------------------------------------------------------------------===//

class InstTriCore<dag outs, dag ins, string asmstr, list<dag> pattern>
    : Instruction {

  let Namespace = "TriCore";
  /// outs and ins are inherited from the instruction class.
  let OutOperandList = outs;
  let InOperandList = ins;
  //dag OutOperandList = outs;
  //dag InOperandList = ins;
  let AsmString   = asmstr;
  let Pattern = pattern;
}

//===----------------------------------------------------------------------===//
// Generic 32-bit Instruction Format
//===----------------------------------------------------------------------===//
class T32<dag outs, dag ins, string asmstr, list<dag> pattern>
    : InstTriCore<outs, ins, asmstr, pattern> {
  field bits<32> Inst;
  let Size = 4;
}

//===----------------------------------------------------------------------===//
// Generic 16-bit Instruction Format
//===----------------------------------------------------------------------===//
class T16<bits<8> op1, dag outs, dag ins, string asmstr, list<dag> pattern>
    : InstTriCore<outs, ins, asmstr, pattern> {
  field bits<16> Inst;
  let Inst{7-0} = op1;
  let Size = 2;
}

//===----------------------------------------------------------------------===//
// 16-bit SRR Instruction Format: <s2|s1/d|op1>
//===----------------------------------------------------------------------===//
class SRR<bits<8> op1, dag outs, dag ins, string asmstr, list<dag> pattern>
    : T16<op1, outs, ins, asmstr, pattern> {

  bits<4> s2;
  bits<4> d;
  
  let Inst{11-8} = d;
  let Inst{15-12} = s2; 
}

//===----------------------------------------------------------------------===//
// 16-bit SRC Instruction Format: <const4|s1/d|op1>
//===----------------------------------------------------------------------===//
class SRC<bits<8> op1, dag outs, dag ins, string asmstr, list<dag> pattern>
    : T16<op1, outs, ins, asmstr, pattern> {

  bits<4> const4;
  bits<4> d;
  
  let Inst{11-8} = d;
  let Inst{15-12} = const4; 
}

//===----------------------------------------------------------------------===//
// 16-bit SC Instruction Format: <const8|op1>
//===----------------------------------------------------------------------===//
class SC<bits<8> op1, dag outs, dag ins, string asmstr, list<dag> pattern>
    : T16<op1, outs, ins, asmstr, pattern> {

  bits<8> const8;
   
  let Inst{15-8} = const8;
}

//===----------------------------------------------------------------------===//
// 16-bit SB Instruction Format: <disp8|op1>
//===----------------------------------------------------------------------===//
class SB<bits<8> op1, dag outs, dag ins, 
         string asmstr, list<dag> pattern>
        : T16<op1, outs, ins, asmstr, pattern> {

  bits<8> disp8;
  let Inst{15-8} = disp8;
  let Inst{7-0} = op1;
}

//===----------------------------------------------------------------------===//
// 16-bit SBR Instruction Format: <s2|disp4|op1>
//===----------------------------------------------------------------------===//
class SBR<bits<8> op1, dag outs, dag ins, 
         string asmstr, list<dag> pattern>
        : T16<op1, outs, ins, asmstr, pattern> {

  bits<4> s2;
  bits<4> disp4;
  
  let Inst{15-12} = s2;
  let Inst{11-8} = disp4;
  let Inst{7-0} = op1;
}

//===----------------------------------------------------------------------===//
// 16-bit SR Instruction Format: <op2|s1|d|op1>
//===----------------------------------------------------------------------===//
class SR<bits<8> op1, bits<4> op2, dag outs, dag ins, string asmstr, 
			list<dag> pattern> : T16<op1, outs, ins, asmstr, pattern> {

  bits<4> op2;
  bits<4> s1;
  bits<4> d;
  
  let Inst{15-12} = op2;
  let Inst{11-8} = s1;
}

//===----------------------------------------------------------------------===//
// 32-bit RR Instruction Format: <d|op2|-|n|s2|s1|op1>
//===----------------------------------------------------------------------===//
class RR<bits<8> op1, bits<8> op2, dag outs, dag ins, string asmstr,
                 list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
  
  bits<4> s1;
  bits<4> s2;
  bits<4> d;
  bits<2> n;
  
  let Inst{7-0} = op1;
  let Inst{11-8} = s1;
  let Inst{15-12} = s2;
  let Inst{17-16} = n;
  let Inst{27-20} = op2;
  let Inst{31-28} = d;
} 

//===----------------------------------------------------------------------===//
// 32-bit RR2 Instruction Format: <d|op2|s2|s1|op1>
//===----------------------------------------------------------------------===//
class RR2<bits<8> op1, bits<12> op2, dag outs, dag ins, string asmstr,
                 list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
  
  bits<4> s1;
  bits<4> s2;
  bits<4> d;
  bits<2> n;
  
  let Inst{7-0} = op1;
  let Inst{11-8} = s1;
  let Inst{15-12} = s2;
  let Inst{27-16} = op2;
  let Inst{31-28} = d;
} 

//===----------------------------------------------------------------------===//
// 32-bit RLC Instruction Format: <d|const16||s1|op1>
//===----------------------------------------------------------------------===//
class RLC<bits<8> op1, dag outs, dag ins, string asmstr,
                 list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
  
  bits<4> s1;
  bits<16> const16;
  bits<4> d;
  
  let Inst{7-0} = op1;
  let Inst{11-8} = s1;
  let Inst{27-12} = const16;
  let Inst{31-28} = d;
} 

//===----------------------------------------------------------------------===//
// 32-bit RC Instruction Format: <d|op2|const9|s1|op1>
//===----------------------------------------------------------------------===//
class RC<bits<8> op1, bits<7> op2, dag outs, dag ins, string asmstr, 
                  list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
  
  bits<4> s1;
  bits<4> d;
  bits<9> const9;
  
  let Inst{7-0} = op1;
  let Inst{11-8} = s1;
  let Inst{20-12} = const9;
  let Inst{27-21} = op2;
  let Inst{31-28} = d;
} 

//===----------------------------------------------------------------------===//
// 32-bit B Instruction Format: <disp24[15:0]|disp24[23:16]|op1>
//===----------------------------------------------------------------------===//
class B<bits<8> op1, dag outs, dag ins, string asmstr, 
                list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
  bits<24> disp24;
  let Inst{7-0} = op1;
  let Inst{15-8} = disp24{23-16};
  let Inst{31-16} = disp24{15-0};
}

//===----------------------------------------------------------------------===//
// 32-bit BRR Instruction Format: <op2|disp15|s2|s1|op1>
//===----------------------------------------------------------------------===//
class BRR<bit op2, bits<8> op1, dag outs, dag ins, string asmstr, 
                list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
	
	bits<4> s1;
	bits<4> s2;
	bits<15> dip15;
	
	let Inst{7-0} = op1;
	let Inst{11-8} = s1;
	let Inst{15-12} = s1;
	let Inst{30-16} = dip15;
	let Inst{31} = op2;
}

//===----------------------------------------------------------------------===//
// 32-bit BRC Instruction Format: <op2|disp15|const4|s1|op1>
//===----------------------------------------------------------------------===//
class BRC<bit op2, bits<8> op1, dag outs, dag ins, string asmstr, 
                list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
	
	bits<4> s1;
	bits<4> const4;
	bits<15> dip15;
	
	let Inst{7-0} = op1;
	let Inst{11-8} = s1;
	let Inst{15-12} = const4;
	let Inst{30-16} = dip15;
	let Inst{31} = op2;
}

//===----------------------------------------------------------------------===//
// 32-bit RCPW Instruction Format: <op1|s1|const4|width|op2|pos|d>
//===----------------------------------------------------------------------===//
class RCPW<bits<8> op1, bits<2> op2 , dag outs, dag ins, string asmstr, 
                list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
	
	bits<4> s1;
	bits<4> const4;
	bits<4> d;
	bits<5> width;
	bits<5> pos;
	
	let Inst{7-0} = op1;
	let Inst{11-8} = s1;
	let Inst{15-12} = const4;
	let Inst{20-16} = width;
	let Inst{22-21} = op2;
	let Inst{27-23} = pos;
	let Inst{31-28} = d;
}

//===----------------------------------------------------------------------===//
// 32-bit RRPW Instruction Format: <op1|s1|s2|width|op2|pos|d>
//===----------------------------------------------------------------------===//
class RRPW<bits<8> op1, bits<2> op2 , dag outs, dag ins, string asmstr, 
                list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
	
	bits<4> s1;
	bits<4> s2;
	bits<4> d;
	bits<5> width;
	bits<5> pos;
	
	let Inst{7-0} = op1;
	let Inst{11-8} = s1;
	let Inst{15-12} = s2;
	let Inst{20-16} = width;
	let Inst{22-21} = op2;
	let Inst{27-23} = pos;
	let Inst{31-28} = d;
}
//===----------------------------------------------------------------------===//
// 32-bit BOL Instr Format: <off16[9:6]|off16[15:10]|off16[5:0]|s2|s1/d|op1>
//===----------------------------------------------------------------------===//
class BOL<bits<8> op1, dag outs, dag ins, string asmstr, 
                list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
  bits<20> memri;
  bits<4> d;
  let Inst{7-0} = op1;
  let Inst{11-8} = d;
  let Inst{15-12} = memri{3-0};
  let Inst{21-16} = memri{9-4};
  let Inst{27-22} = memri{19-14};
  let Inst{31-28} = memri{13-10};
}

//===----------------------------------------------------------------------===//
// 32-bit BO Instr Format: <off10[9:6]|op2|off10[5:0]|d|s1|op1>
//===----------------------------------------------------------------------===//
class BO<bits<8> op1, bits<6> op2, dag outs, dag ins, string asmstr, 
                list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
  bits<14> memri;
  bits<4> d;
  let Inst{7-0} = op1;
  let Inst{11-8} = d;
  let Inst{15-12} = memri{3-0};
  let Inst{21-16} = memri{9-4};
  let Inst{27-22} = op2;
  let Inst{31-28} = memri{13-10};
}

//===----------------------------------------------------------------------===//
// 32-bit RRR Instr Format: <d|s3|op2|-|n|s2|s1|op1>
//===----------------------------------------------------------------------===//
class RRR<bits<8> op1, bits<4> op2, dag outs, dag ins, string asmstr, 
                list<dag> pattern> : T32<outs, ins, asmstr, pattern> {
  bits<4> s1;
  bits<4> s2;
  bits<4> s3;
  bits<4> d;
  bits<2> n;
  let Inst{7-0} = op1;
  let Inst{11-8} = s1;
  let Inst{15-12} = s2;
  let Inst{17-16} = n;
  // let Inst{19-18} = don't care;
  let Inst{23-20} = op2;
  let Inst{27-24} = s3;
  let Inst{31-28} = d;
}



// TriCore pseudo instructions format
class Pseudo<dag outs, dag ins, string asmstr, list<dag> pattern>
    : InstTriCore<outs, ins, asmstr, pattern> {
  let isPseudo = 1;
}