//==-- TriCoreInstrInfo.td - Target Description for TriCore ---*- tablegen -*-//
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


def SDT_TriCoreCmp          : SDTypeProfile<0, 2, [SDTCisSameAs<0, 1>]>;
//def SDT_TriCoreBrCC       : SDTypeProfile<0, 2, [SDTCisVT<0, OtherVT>,
//                                                 SDTCisVT<1, i32>]>;

//def SDT_TriCoreBrCC       : SDTypeProfile<0, 4, [SDTCisVT<0, i32>,
//                                                 SDTCisVT<1, OtherVT>,
//                                                 SDTCisSameAs<2, 3>,
//                                                 SDTCisInt<2> ]>;

//def SDT_TriCoreBrCC         : SDTypeProfile<0, 2, [SDTCisVT<0, i32>,
//						   SDTCisVT<1, OtherVT> ]>;


def SDT_TriCoreBrCC         : SDTypeProfile<0, 4, [SDTCisVT<0, i32>,
						   SDTCisVT<1, OtherVT>,
						   SDTCisInt<2>,
							 SDTCisInt<3>]>;

def SDT_TriCoreBrCC_new         : SDTypeProfile<0, 4, [SDTCisVT<0, i32>,
						   SDTCisVT<1, OtherVT>,
						   SDTCisInt<2>,
							 SDTCisInt<3>]>;


def TriCorecmp     : SDNode<"TriCoreISD::CMP", SDT_TriCoreCmp, [SDNPOutGlue]>;

def TriCorecmpb    : SDNode<"TriCoreISD::CMPB", SDTIntBinOp, [ ]>;


def TriCorebrcc    : SDNode<"TriCoreISD::BR_CC", SDT_TriCoreBrCC,
                                                 [SDNPHasChain]>;
def TriCorebrcc_new    : SDNode<"TriCoreISD::BR_CC_new", SDT_TriCoreBrCC_new,
                                                 [SDNPHasChain]>;

// Short jump targets have OtherVT type and are printed as pcrel imm values.

//def code : Operand<OtherVT>;


def jmptarget : Operand<OtherVT> {
  let PrintMethod = "printPCRelImmOperand";
}

// Operand for printing out a condition code.
def cc : Operand<i32> {
  let PrintMethod = "printCCOperand";
}

//===----------------------------------------------------------------------===//
// ADD Instructions
//===----------------------------------------------------------------------===//

def ADDrr : RR<0x0B, 0, (outs DataRegs:$d), (ins DataRegs:$s1, DataRegs:$s2),
				  "add $d, $s1, $s2",
    	       [(set DataRegs:$d, (add DataRegs:$s1, DataRegs:$s2) )]>;
def ADDri : RC<0x8B, 0x00, (outs DataRegs:$d), (ins DataRegs:$s1, s9imm:$const9)
               ,"addi $d, $s1, $const9",
               [(set DataRegs:$d, (add DataRegs:$s1, immSExt9:$const9) )]>;

def ADDCrr : RR<0x0B, 0, (outs DataRegs:$d), (ins DataRegs:$s1, DataRegs:$s2),
				  "addc $d, $s1, $s2",
    	       [(set DataRegs:$d, (addc DataRegs:$s1, DataRegs:$s2) ),
							(implicit PSW)]>
{
	//let Uses = [PSW];
	let Defs = [PSW];
}



def SUBrr : RR<0x01, 0x02, (outs AddrRegs:$d), 
               (ins AddrRegs:$src1, AddrRegs:$src2), "sub.a $d, $src1, $src2",
               [(set AddrRegs:$d, (sub AddrRegs:$src1, AddrRegs:$src2) )]>;

def SUBri : SC<0x8B, (outs AddrRegs:$d), (ins DataRegs:$src1, u8imm:$imm),
	       "sub.aa $d, $src1, $imm", 
               [(set AddrRegs:$d, (sub DataRegs:$src1, immZExt8:$imm) )]>;

def SUBria : SC<0x8B, (outs AddrRegs:$d), (ins AddrRegs:$src1, u8imm:$imm),
	        "sub.a $d, $imm",
                [(set AddrRegs:$d, (sub AddrRegs:$src1, immZExt8:$imm) )]> 
{
  let Constraints = "$src1 = $d";
}

let Defs=[PSW] in {
  def MULrr : RR2<0x73, 0x00A, (outs DataRegs:$d),
                  (ins DataRegs:$s2, DataRegs:$s1), "mul $d, $s2, $s1",
		  [(set DataRegs:$d, (mul DataRegs:$s1, DataRegs:$s2) )]>;
	
  def MULri : RC<0x53, 0x001, (outs DataRegs:$d),
                (ins DataRegs:$s1, s9imm:$const9),  "mul $d, $s1, $const9",
		[(set DataRegs:$d, (add DataRegs:$s1, immSExt9:$const9) )]>;
}

//===----------------------------------------------------------------------===//
// Logical Instructions
//===----------------------------------------------------------------------===//

multiclass Logical32_0<bits<8> opcode1, string asmstring, 
                    SDNode OpNode, bit isComm=0 > 
{

  def rc: RC<0x8f, opcode1{6-0}, (outs DataRegs:$d), 
            (ins DataRegs:$s1, u9imm:$const9),
            !strconcat(asmstring, " $d, $s1, $const9"),
            [(set DataRegs:$d, (OpNode DataRegs:$s1, immZExt9:$const9))]>; 

  def rr: RR<0x0f, opcode1, (outs DataRegs:$d), 
            (ins DataRegs:$s1, DataRegs:$s2),
            !strconcat(asmstring, " $d, $s1, $s2"),
            [(set DataRegs:$d, (OpNode DataRegs:$s1, DataRegs:$s2))]>; 
}

multiclass Logical32_1<bits<8> opcode1, string asmstring, 
                    SDNode OpNode1, PatFrag OpNode2, bit isComm=0 > 
{

  def rc: RC<0x8f, opcode1{6-0}, (outs DataRegs:$d), 
            (ins DataRegs:$s1, u9imm:$const9),
            !strconcat(asmstring, " $d, $s1, $const9"),
						[(set i32:$d, (OpNode2 (OpNode1 i32:$s1, immZExt9:$const9)))]>;
             

  def rr: RR<0x0f, opcode1, (outs DataRegs:$d), 
            (ins DataRegs:$s1, DataRegs:$s2),
            !strconcat(asmstring, " $d, $s1, $s2"),
						[(set i32:$d, (OpNode2 (OpNode1 i32:$s1, i32:$s2)))]>;
}

multiclass Logical16<bits<8> opcode1_sc, bits<8> opcode1_srr, 
                    string asmstring, SDNode OpNode, bit isComm=0 >
{

  def sc: SC<opcode1_sc, (outs DataRegs:$d), 
            (ins DataRegs:$s1, u8imm:$const8),
            !strconcat(asmstring, " $d, $s1, $const8"),
            [(set DataRegs:$d, (OpNode DataRegs:$s1, immZExt8:$const8))]>; 

  def srr: SRR<opcode1_srr, (outs DataRegs:$d), 
            (ins DataRegs:$s1, DataRegs:$s2),
            !strconcat(asmstring, " $d, $s1, $s2"),
            [(set DataRegs:$d, (OpNode DataRegs:$s1, DataRegs:$s2))]>
  {
        let Constraints = "$s1 = $d";
  }
}




defm AND : Logical32_0<0x08, "and", and>;
defm AND : Logical16<0x16, 0x26, "and", and>;

defm NAND : Logical32_1<0x09, "nand", and, not>;
defm NOR : Logical32_1<0x0B, "nor", or, not>;
defm XNOR : Logical32_1<0x0B, "nxor", xor, not>;

defm OR : Logical32_0<0x0a, "or", or>;
defm OR : Logical16<0x96, 0xA6, "or", or>;

defm XOR : Logical32_0<0x0c, "xor", xor>;
def XORsrr : SRR<0xc6, (outs DataRegs:$d), 
            (ins DataRegs:$s1, DataRegs:$s2), "xor $d, $s1, $s2",
            [(set DataRegs:$d, (xor DataRegs:$s1, DataRegs:$s2))]>
{
        let Constraints = "$s1 = $d";
}

def NOTsr : SR<0x46, 0x0, (outs DataRegs: $d), (ins DataRegs:$s1), 
						"not $d", [(set DataRegs:$d, (not DataRegs:$s1))]> 
{
	 let Constraints = "$s1 = $d";
}


//===----------------------------------------------------------------------===//
// Mov Instructions
//===----------------------------------------------------------------------===//
//def MOVrr  : RR<0x87, 0x99, (outs DataRegs:$d), (ins DataRegs:$s2),
//                     "mov $d, $s2",
//                     [/* No pattern */]> {
//      let n = 0b00;
//      let s1 = 0b0000;
//}


//===----------------------------------------------------------------------===//
// Mov Immediate Instructions
//===----------------------------------------------------------------------===//

def MOVrr : RR<0x0B, 0x1F, (outs DataRegs:$d), (ins DataRegs:$s2),
				"mov $d, $s2", [ ]>;

//def MOVrr : RR<0x0B, 0x1F, (outs DataRegs:$d), (ins DataRegs:$s2),
//				"movxx $d, $s2", [  ]>;
//def MOVaRR : RR<0x01, 0x63, (outs AddrRegsOthers:$d), (ins DataRegs:$s2),
//				"mov.a $d, $s2", [ ]>;
def MOVdRR : RR<0x01, 0x4C, (outs DataRegs:$d), (ins AddrRegs:$s2),
				"mov.d $d, $s2", [  ]>;
////def MOVaaRR : RR<0x01, 0x63, (outs AddrRegs:$d), (ins AddrRegs:$s2),
////				"mov.aa $d, $s2", [(set i32:$d, i32:$s2)]>;
//
def MOVaaRR : RR<0x01, 0x63, (outs AddrRegs:$d), (ins AddrRegs:$s2),
				"mov.aa $d, $s2", [ ]>;
//def MOVaSRC : SRC<0xA0, (outs AddrRegsOthers:$dst), (ins u4imm:$src1),
//				"mov.a $dst, $src1", [(set AddrRegsOthers:$dst, immZExt4:$src1)]>;
//
//def MOVaSRR : SRC<0x60, (outs AddrRegsOthers:$dst), (ins DataRegs:$src1),
//				"mov.a $dst, $src1", [(set AddrRegsOthers:$dst, DataRegs:$src1)]>;


//def MOVLOi16 : MOV<0x81, "mov", (ins i32imm:$const16),
//                  [(set i32:$d, i32imm_lo:$const16)]>;
//def MOVHIi16 : MOV<0b1010, "movt", (ins GRRegs:$src1, i32imm:$imm),
//                  [/* No Pattern */]>;


class MOV<bits<8> opcode, string opstr, dag ins, list<dag>pattern>
    : RLC<opcode, (outs DataRegs:$dst), ins,
              !strconcat(opstr, " $dst, $imm"), pattern> {
  
  bits<4> dst;
  bits<16> imm;
  let Inst{15-12} = dst;
  let Inst{11-0}  = imm{11-0};
  let Inst{19-16} = imm{15-12};
  let Inst{20} = 0;
  let Inst{25} = 1;

  //let const16 = const16;
}

def MOVrlc : MOV<0x3B,"movw", (ins i32imm:$imm) ,
              [(set i32:$dst, i32imm_lo:$imm)]>;
//def MOVHIi16 : MOV<0x7B, "movh", (ins i32imm:$imm), [/* No Pattern */]>;

def MOVHIi16 : MOV<0x7B, "movh", (ins DataRegs:$fakesrc, i32imm:$imm), 
               [/* No Pattern */]>
{
	let Constraints = "$fakesrc = $dst";
}


//def MOVrlc : RLC<0x3B, (outs DataRegs:$dst), (ins i32imm:$const16),
//				"mov $dst, $const16", [(set i32:$dst, i32imm_lo:$const16)]>;
//def MOVHIi16 : RLC<0x7B, (outs DataRegs:$dst), (ins DataRegs:$s1, i32imm:$const16),
//					"movh $dst, $const16" ,
//                  [/* No Pattern */]>;
def MOVi32 : InstTriCore<(outs DataRegs:$dst), (ins i32imm:$src), "",
                     [(set i32:$dst, (movei32 imm:$src))]> {
  let isPseudo = 1;
}

//===----------------------------------------------------------------------===//
// Load/Store Instructions
//===----------------------------------------------------------------------===//

let mayLoad = 1 in {
def LDR  : BOL<0x62,(outs DataRegs:$s1_d), (ins memsrc:$off16),
                   "ldr $s1_d, $off16",
                   [(set DataRegs:$s1_d, (load addr:$off16))]> {
}
}

def STR : BOL<0x63,(outs), (ins DataRegs:$s1_d, memsrc:$off16),
                  "str $off16, $s1_d",
                  [(store DataRegs:$s1_d, addr:$off16)]> {
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
// Compare Instructions
//===----------------------------------------------------------------------===//



//def CMPrr  : T32<(outs), (DataRegs:$lhs, DataRegs:$rhs),
//                   "cmp $lhs, $rhs",
//                   []> {
//	
//	bits<4> lhs;
//	bits<4> rhs;
//
//	let Defs = [D9];
//	
//}

//def CMPri  : RC<0x0B, 0x14 ,
//                   (outs), (ins DataRegs:$s1, s9imm:$const9),
//                   "cmp $s1, $const9",
//                   [(TriCorecmp DataRegs:$s1, immSExt9:$const9)]> {
//	
//	
//	let Defs = [D9];
//}

def CMPri  : RC<0x0B, 0x14 ,
                   (outs DataRegs:$d), (ins DataRegs:$s1, s9imm:$const9),
                   "cmp $d, $s1, $const9",
                   [(set i32:$d, (TriCorecmpb i32:$s1, immSExt9:$const9))]> {
	
	

}
//

def CMPrr  : RR<0x0, 0x14,
                   (outs DataRegs:$d), (ins DataRegs:$s1, DataRegs:$s2),
                   "cmp $d, $s1, $s2",
                   [(set i32:$d, (TriCorecmpb DataRegs:$s1, DataRegs:$s2))]> {

	
}

//===----------------------------------------------------------------------===//
// Jump Instructions
//===----------------------------------------------------------------------===//



	
	
	multiclass BRANCH_SIGNED<bits<8> op1_brc, bits<8> op1_brr, bit op2, string asmstring>
		{

			def brc: BRC<op2, op1_brc, (outs), 
					(ins cc:$cc1, jmptarget:$disp15, DataRegs:$s1, s4imm:$const4),
					!strconcat(asmstring, " $s1, $const4, $disp15"),
					[(TriCorebrcc  imm:$cc1, bb:$disp15, i32:$s1, immSExt4:$const4)]>;
			
			def brr: BRR<op2, op1_brr, (outs), 
					(ins cc:$cc1, jmptarget:$disp15, DataRegs:$s1, DataRegs:$s2),
					!strconcat(asmstring, " $s1, $s2, $disp15"),
					[(TriCorebrcc  imm:$cc1, bb:$disp15, i32:$s1, i32:$s2)]>;
		}

let isBranch =1, isTerminator = 1 in {
	
	defm JNE : BRANCH_SIGNED<0xdf, 0x5f, 0b1, "jne">;
	defm JEQ : BRANCH_SIGNED<0xdf, 0x5f, 0b0, "jeq">;
	defm JGE : BRANCH_SIGNED<0xff, 0x7f, 0b0, "jge">;
	defm JLT : BRANCH_SIGNED<0xbf, 0x3f, 0b0, "jlt">;
	
	
	let isBarrier = 1 in {
			// Short branch
			def JMP : B<0x1D, (outs), (ins jmptarget:$dst),
							"j $dst",
							[(br bb:$dst)]>;
	}
	
	
	
	
	
	
	
	
	
//	// Conditional branches
//	let Uses = [D9] in {
		
//		def JCC : BRR<0, (outs), (ins cc:$cc1, jmptarget:$disp15, DataRegs:$s1, DataRegs:$s2 ),
//											"j$cc1 $s1, $s2, $disp15",
//											[(TriCorebrcc  imm:$cc1, bb:$disp15, i32:$s1, i32:$s2)]> { 
//def JCC : BRR<0, 0, (outs), (ins cc:$cc1, jmptarget:$disp15, DataRegs:$s1 ),
//											"j$cc1 , $disp15",
//											[(TriCorebrcc  imm:$cc1, bb:$disp15, i32:$s1)]> { 
////				bits<4> s2;
////				bits<4> s1;
//			
//			}


//def JCC2 : BRR<0, 0, (outs), (ins cc:$cc1, jmptarget:$disp15, DataRegs:$s1 ),
//											"jhgjgjgj , $disp15",
//											[(TriCorebrcc  imm:$cc1, bb:$disp15, i32:$s1)]> { 
////				bits<4> s2;
////				bits<4> s1;
//			
//			}



//		} 
	}// isBranch, isTerminator
		


//let isTerminator = 1, isBranch = 1, isBarrier = 1 in {
//  def JMP : T32<(outs), (ins b_target:$dst),
//                  "b $dst", [(br bb:$dst)]> {
//    bits<24> dst;
//    let Inst{31-28} = 0b0000;
//    let Inst{27-24} = 0b1010;
//    let Inst{23-0} = dst;
//  }
//}
//
//let isTerminator = 1, isBranch = 1, Uses = [D9] in {
//  def JCC : T32<(outs), (ins cc_val:$cc, b_target:$dst),
//                    "b$cc $dst",  []> {
//  }
//}


//===----------------------------------------------------------------------===//
// Call Instructions
//===----------------------------------------------------------------------===//

//def : Pattern<(i32 (load_sym tglobaladdr:$addr)),  [(MOVi32 $addr)]>;

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
