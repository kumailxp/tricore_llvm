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

def SDT_TriCoreCmp          : SDTypeProfile<1, 2, [SDTCisSameAs<0, 1>,
																									 SDTCisSameAs<1, 2>]>;

def TriCorecmp     : SDNode<"TriCoreISD::CMP", SDT_TriCoreCmp, []>;

//def SDT_TriCoreBrCC         : SDTypeProfile<0, 3, [SDTCisVT<0, OtherVT>,
//																									 SDTCisInt<1>,
//																									 SDTCisInt<2>]>;

def SDT_TriCoreBrCC         : SDTypeProfile<0, 3, [SDTCisVT<0, OtherVT>,
                                                  SDTCisVT<1, i32>,
																									SDTCisVT<2, i32>]>;

def SDT_TriCoreWrapper      : SDTypeProfile<1, 1, [SDTCisSameAs<0, 1>,
                                                  SDTCisPtrTy<0>]>;

def SDT_TriCoreShift        : SDTypeProfile<1, 2, [SDTCisSameAs<0, 1>,
                                                  SDTCisInt<2>]>;

//def TriCorebrcc    : SDNode<"TriCoreISD::BR_CC", SDT_TriCoreBrCC,
//                                                 [SDNPHasChain]>;

def TriCorebrcc    : SDNode<"TriCoreISD::BR_CC", SDT_TriCoreBrCC,
                            [SDNPHasChain]>;

def TriCoreWrapper : SDNode<"TriCoreISD::Wrapper", SDT_TriCoreWrapper>;
def TriCoresh      : SDNode<"TriCoreISD::SH", SDT_TriCoreShift, []>;
def TriCoresub    : SDNode<"TriCoreISD::SUB", SDTIntBinOp, [ ]>;


def jmptarget : Operand<OtherVT> {
  let PrintMethod = "printPCRelImmOperand";
}

// Operand for printing out a condition code.
def cc : Operand<i32> {
  let PrintMethod = "printCCOperand";
}

def isPointer : Predicate<"isPointer() == true">;
def isnotPointer : Predicate<"isPointer() == false">;
def isInteger : Predicate<"isInteger() == true">;
def isnotInteger : Predicate<"isInteger() == false">;

// TriCore Condition Codes
def TriCore_COND_EQ : PatLeaf<(i32 0)>;
def TriCore_COND_NE : PatLeaf<(i32 1)>;
def TriCore_COND_GE : PatLeaf<(i32 2)>;
def TriCore_COND_LT : PatLeaf<(i32 3)>;

//===----------------------------------------------------------------------===//
// ADD Instructions
//===----------------------------------------------------------------------===//
def ADDsrc : SRC<0xC2, (outs DataRegs:$d), (ins DataRegs:$s1, s4imm:$const4)
               ,"add $d, $const4",
               [(set DataRegs:$d, (add DataRegs:$s1, immSExt4:$const4) )]>
{
	let Constraints = "$s1 = $d";
}

let isCommutable = 1 in {
	def ADDrr : RR<0x0B, 0, (outs DataRegs:$d), (ins DataRegs:$s1, DataRegs:$s2),
						"add $d, $s1, $s2",
							 [(set DataRegs:$d, (add DataRegs:$s1, DataRegs:$s2) )]>;
	
	def ADDrc : RC<0x8B, 0, (outs DataRegs:$d), (ins DataRegs:$s1, i32imm:$const9)
								 ,"add $d, $s1, $const9",
								 [(set DataRegs:$d, (add DataRegs:$s1, immSExt9:$const9) )]>;
	
	def ADDIrlc : RLC<0x1B, (outs DataRegs:$d), (ins DataRegs:$s1, i32imm:$const16)
								 ,"addi $d, $s1, $const16",
								 [(set DataRegs:$d, (add DataRegs:$s1, immSExt16:$const16) )]>;
	
	def ADDArc : RC<0x8B, 0x00, (outs AddrRegs:$d), (ins AddrRegs:$s1, i32imm:$const9)
								 ,"addi $d, $s1, $const9",
								 [(set AddrRegs:$d, (add AddrRegs:$s1, immSExt9:$const9) )]>;

}

def SUBAsc : SC<0x20, (outs), (ins u8imm:$imm),
	        "sub.a_ %a10, $imm",
                []> 
{
  //let Constraints = "$src1 = $d";
	let Defs = [A10];
	let Uses = [A10];
	
}
//let Predicates = [isnotInteger] in 
def SUBrr : RR<0x0B, 0x08, (outs AddrRegs:$d), 
               (ins AddrRegs:$src1, AddrRegs:$src2), "sub.a $d, $src1, $src2",
               [(set AddrRegs:$d, (sub AddrRegs:$src1, AddrRegs:$src2) )]>;

//let Predicates = [isInteger] in 
def RSUBrc : RC<0x8B, 0x08, (outs DataRegs:$d), (ins DataRegs:$s1, s9imm:$const9)
                   ,"rsub $d, $s1, $const9",
                   [(set DataRegs:$d, (sub immSExt9:$const9, DataRegs:$s1)) ]>;

let Constraints="$d = $s1" in
def RSUBsr : SR<0x32, 0x05, (outs DataRegs: $d), (ins DataRegs:$s1, s4imm:$const4), 
		"rsub $d", [(set DataRegs:$d, (sub immSExt4:$const4, DataRegs:$s1))]>; 

let Defs=[PSW] in {
  def MULrr : RR2<0x73, 0x00A, (outs DataRegs:$d),
                  (ins DataRegs:$s2, DataRegs:$s1), "mul $d, $s2, $s1",
		  [(set DataRegs:$d, (mul DataRegs:$s1, DataRegs:$s2) )]>;
	
  def MULrc : RC<0x53, 0x001, (outs DataRegs:$d),
                (ins DataRegs:$s1, s9imm:$const9),  "mul $d, $s1, $const9",
		[(set DataRegs:$d, (mul DataRegs:$s1, immSExt9:$const9) )]>;
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
// Mov Immediate Instructions
//===----------------------------------------------------------------------===//

def MOVrr : RR<0x0B, 0x1F, (outs DataRegs:$d), (ins DataRegs:$s2),
				"mov $d, $s2", [ ]>;


def MOVDrr : RR<0x01, 0x4C, (outs DataRegs:$d), (ins AddrRegs:$s2),
				"mov.d $d, $s2", [ ]>;

def MOVArr : RR<0x01, 0x63, (outs AddrRegs:$d), (ins DataRegs:$s2),
				"mov.a $d, $s2", [ ]>;

def MOVAArr : RR<0x01, 0x00, (outs AddrRegs:$d), (ins AddrRegs:$s2),
				"mov.aa $d, $s2", [ ]>;

class MOV<bits<8> opcode, string opstr, dag ins, list<dag>pattern>
    : RLC<opcode, (outs DataRegs:$d), ins,
              !strconcat(opstr, " $d, $const16"), pattern>;

def MOVrlc : MOV<0x3B,"mov", (ins s16imm:$const16) ,
              [(set i32:$d, immSExt16:$const16)]>;

def MOVUrlc : MOV<0xBB,"mov.u", (ins u16imm:$const16) ,
              [(set i32:$d, immZExt16:$const16)]>;

def MOVHIi16 : MOV<0x7B, "movh", (ins DataRegs:$fakesrc, i32imm:$const16), 
               []>
{
	let Constraints = "$fakesrc = $d";
}

let isReMaterializable = 1, isAsCheapAsAMove = 1 in
def MOVi32 : TriCorePseudoInst<(outs DataRegs:$d), (ins i32imm:$const16), "MOV32 Pseudo",
                     [(set i32:$d, (movei32 imm:$const16))]> {
  let isPseudo = 1;
}

//===----------------------------------------------------------------------===//
// Load/Store Instructions
//===----------------------------------------------------------------------===//

let mayLoad = 1 in
	def LDR  : BOL<0x62,(outs DataRegs:$s1_d), (ins memsrc:$off16),
										 "ld.w $s1_d, $off16",
										 [(set DataRegs:$s1_d, (load addr:$off16))]>;

let Predicates = [isnotPointer] in 
def STR : BOL<0x63,(outs), (ins DataRegs:$s1_d, memsrc:$off16),
                  "st.w $off16, $s1_d",
                  [(store DataRegs:$s1_d, addr:$off16)]>;

let Predicates = [isPointer] in 
def STAbol : BOL<0x63,(outs), (ins AddrRegs:$s1_d, memsrc:$off16),
                  "st.a $off16, $s1_d",
                  [(store i32:$s1_d, addr:$off16)]>;

//===----------------------------------------------------------------------===//
// Shift Instructions
//===----------------------------------------------------------------------===//

def SHrc : RC<0x8F,0x00, (outs DataRegs:$d), (ins DataRegs:$s1, s9imm:$const9),
    "sh $d, $s1, $const9",
    [(set DataRegs:$d, (TriCoresh DataRegs:$s1, immSExt9:$const9))]>;	

def SHrr : RR<0x01, 0x00, (outs DataRegs:$d), (ins DataRegs:$s1, DataRegs:$s2),
				"sh $d, $s1, $s2", [(set DataRegs:$d, (TriCoresh DataRegs:$s1, DataRegs:$s2))]>;


//===----------------------------------------------------------------------===//
// Return Instructions
//===----------------------------------------------------------------------===//

let isTerminator = 1, isReturn = 1, isBarrier = 1 in {
  def RET : T32<(outs), (ins variable_ops),
                    "ret",  [(TriCoreRetFlag)]> {
    //let Inst{27-0}  = 0b0001001011111111111100011110;
  }
}

//===----------------------------------------------------------------------===//
// Call Instructions
//===----------------------------------------------------------------------===//

let isCall = 1, Defs = [A11], Uses = [A10] in {
  def BL : B<0x6D, (outs), (ins i32imm:$disp),
                      "call $disp ",  [(tricore_call imm:$disp)]>;
}

//===----------------------------------------------------------------------===//
// Compare Instructions
//===----------------------------------------------------------------------===//

//multiclass COMPARE_32<bits<8> op2, string asmstring, PatLeaf PF> {
//	
//	def rc : RC<0x8B, op2{6-0},
//					 (outs DataRegs:$d),
//					 (ins DataRegs:$s1, s9imm:$const9),
//					 !strconcat(asmstring, " $d, $s1, $const9"),
//					 [( set DataRegs:$d, (TriCorecmp DataRegs:$s1, immSExt9:$const9, PF))]>;
//	
//	def rr : RR<0x0B, op2,
//						 (outs DataRegs:$d),
//						 (ins DataRegs:$s1, DataRegs:$s2),
//						 !strconcat(asmstring, " $d, $s1, $s2"),
//						 [( set DataRegs:$d, (TriCorecmp DataRegs:$s1, DataRegs:$s2, PF))]>;
//}

//defm NE : COMPARE_32<0x11, "ne", TriCore_COND_NE>;
//defm EQ : COMPARE_32<0x10, "eq", TriCore_COND_EQ>;
//defm GE : COMPARE_32<0x14, "ge", TriCore_COND_GE>;
//defm LT : COMPARE_32<0x12, "lt", TriCore_COND_LT>;


def CMPrr  : T32<(outs DataRegs:$d), (ins DataRegs:$src, DataRegs:$src2),
                   "cmp.b\t{$src2, $src, $d}",
                   [( set DataRegs:$d, (TriCorecmp DataRegs:$src, DataRegs:$src2) )]>;

def CMPri  : T32<(outs DataRegs:$d), (ins DataRegs:$src, i32imm:$src2),
                   "cmp.b\t{$src2, $src, $d}",
                   [(set DataRegs:$d, (TriCorecmp DataRegs:$src, imm:$src2))]>;

//===----------------------------------------------------------------------===//
// Branch Instructions
//===----------------------------------------------------------------------===//


let isBranch = 1, isTerminator = 1 in {
// Direct branch
let isBarrier = 1 in {
  def JMP : T32<   (outs), (ins jmptarget:$dst),
                   "jmp\t$dst", 
									 [(br bb:$dst)]>;
}

// Conditional branches

  def JCC : T32<   (outs), (ins jmptarget:$dst, cc:$cc, DataRegs:$s2),
                   "j$cc\t$dst\t$s2",
                   [(TriCorebrcc bb:$dst, imm:$cc, DataRegs:$s2)]>;
} // isBranch, isTerminator


//multiclass BRANCH_SIGNED<bits<8> op1_brc, bits<8> op1_brr, 
//												bit op2, string asmstring>
//{
//
//		def brc: BRC<op2, op1_brc, (outs), 
//					(ins jmptarget:$disp15, DataRegs:$s1, s4imm:$const4),
//					!strconcat(asmstring, " $s1, $const4, $disp15"),
//					[(TriCorebrcc  bb:$disp15, i32:$s1, immSExt4:$const4)]>;
//			
//		def brr: BRR<op2, op1_brr, (outs), 
//					(ins jmptarget:$disp15, DataRegs:$s1, DataRegs:$s2),
//					!strconcat(asmstring, " $s1, $s2, $disp15"),
//					[(TriCorebrcc  bb:$disp15, i32:$s1, i32:$s2)]>;
//}
//
//let isBranch =1, isTerminator = 1 in {
//	
//	defm JNE : BRANCH_SIGNED<0xdf, 0x5f, 0b1, "jne">;
//	defm JEQ : BRANCH_SIGNED<0xdf, 0x5f, 0b0, "jeq">;
//	defm JGE : BRANCH_SIGNED<0xff, 0x7f, 0b0, "jge">;
//	defm JLT : BRANCH_SIGNED<0xbf, 0x3f, 0b0, "jlt">;
//	
//
//	let isBarrier = 1 in {
//			// Short branch
//			def JMP : B<0x1D, (outs), (ins jmptarget:$dst),
//							"j $dst",	[(br bb:$dst)]>;
//	}
//
//}// isBranch, isTerminator
		

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

//===----------------------------------------------------------------------===//
// Patterns
//===----------------------------------------------------------------------===//


def : Pat<(tricore_call (i32 tglobaladdr:$dst)),
          (BL tglobaladdr:$dst)>;

def : Pat<(i32 immSExt16:$src),
					(MOVrlc immSExt16:$src)>;

def : Pat<(i32 immZExt16:$src),
					(MOVUrlc immZExt16:$src)>;

def : Pat<(i32 imm:$src),
					(MOVi32 imm:$src)>;

def : Pat<(i32 (TriCoreWrapper tglobaladdr:$dst)), 
		 (MOVi32 tglobaladdr:$dst)>;
