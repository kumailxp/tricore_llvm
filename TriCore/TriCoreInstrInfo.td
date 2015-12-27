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

def SDT_TriCoreCmp          : SDTypeProfile<1, 3, [SDTCisSameAs<0, 1>,
																									 SDTCisSameAs<1, 2>,
																									 SDTCisVT<3, i32>]>;

def SDT_TriCoreBrCC         : SDTypeProfile<0, 3, [SDTCisVT<0, OtherVT>,
                                                  SDTCisVT<1, i32>,
																									SDTCisVT<2, i32>]>;

def SDT_TriCoreSelectCC     : SDTypeProfile<1, 4, [SDTCisSameAs<0, 1>,
                                                  SDTCisSameAs<1, 2>, 
																									SDTCisVT<3, i32>,
																									SDTCisVT<4, i32>]>;


def SDT_TriCoreWrapper      : SDTypeProfile<1, 1, [SDTCisSameAs<0, 1>,
                                                  SDTCisPtrTy<0>]>;

def SDT_TriCoreShift        : SDTypeProfile<1, 2, [SDTCisSameAs<0, 1>,
                                                  SDTCisVT<2, i32>]>;

def TriCorebrcc    : SDNode<"TriCoreISD::BR_CC", SDT_TriCoreBrCC, [SDNPHasChain]>;
def TriCorecmp     : SDNode<"TriCoreISD::CMP", SDT_TriCoreCmp, []>;
def TriCoreWrapper : SDNode<"TriCoreISD::Wrapper", SDT_TriCoreWrapper>;
def TriCoresh      : SDNode<"TriCoreISD::SH", SDT_TriCoreShift, []>;
def TriCoreselectcc: SDNode<"TriCoreISD::SELECT_CC", SDT_TriCoreSelectCC, []>;

def jmptarget : Operand<OtherVT> {
  let PrintMethod = "printPCRelImmOperand";
}

// Operand for printing out a condition code.
def cc : Operand<i32> {
  let PrintMethod = "printCCOperand";
}

//def isPointer_1  : PatLeaf<(imm), [{ return N->getOperand(1)->getArgType() == (int64_t)MVT::iPTR; }]>;
def isPointer : Predicate<"isPointer() == true">;
def isnotPointer : Predicate<"isPointer() == false">;
//def isInteger : Predicate<"isInteger() == true">;
//def isnotInteger : Predicate<"N->getOperand(1)">;

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
	        "sub.a %a10, $imm", []> 
{
	let Defs = [A10];
	let Uses = [A10];
	
}
//let Predicates = [isnotInteger] in 
def SUBArr : RR<0x0B, 0x08, (outs AddrRegs:$d), 
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
                    string asmstring, SDNode OpNode, bit isComm=1 >
{

  def sc: SC<opcode1_sc, (outs DataRegs:$d), 
            (ins DataRegs:$s1, u8imm:$const8),
            !strconcat(asmstring, " $d, $s1, $const8"),
            [(set DataRegs:$d, (OpNode DataRegs:$s1, immZExt8:$const8))]>; 

  def srr: SRR<opcode1_srr, (outs DataRegs:$d), 
            (ins DataRegs:$s1, DataRegs:$s2),
            !strconcat(asmstring, " $d, $s2"),
            [(set DataRegs:$d, (OpNode DataRegs:$s1, DataRegs:$s2))]>
  {
        let Constraints = "$s1 = $d";
  }
}


defm AND : Logical16<0x16, 0x26, "and", and>;
defm AND : Logical32_0<0x08, "and", and>;


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

class MOV_RR<bits<8> op1, bits<8> op2, string opstr, 
										RegisterClass outregClass, RegisterClass inregClass>:
										RR <op1, op2,
										(outs outregClass:$d),
										(ins inregClass:$s2),
										!strconcat(opstr, " $d, $s2"), []>;

class MOV_CONST<bits<8> opcode, string opstr, dag ins, list<dag> pattern>
    : RLC<opcode, (outs DataRegs:$d), ins,
      !strconcat(opstr, " $d, $const16"), pattern>;

def MOVrr   : MOV_RR<0x0B, 0x1F, "mov", DataRegs, DataRegs>;
def MOVDrr  : MOV_RR<0x01, 0x4C, "mov.d", DataRegs, AddrRegs>;
def MOVArr  : MOV_RR<0x01, 0x63, "mov.a", AddrRegs, DataRegs>;
def MOVAArr : MOV_RR<0x01, 0x00, "mov.aa", AddrRegs, AddrRegs>;
def MOVrlc  : MOV_CONST<0x3B,"mov", (ins s16imm:$const16) ,
              [(set DataRegs:$d, immSExt16:$const16)]>;
def MOVUrlc : MOV_CONST<0xBB,"mov.u", (ins u16imm:$const16) ,
              [(set DataRegs:$d, immZExt16:$const16)]>;

let Constraints = "$fakesrc = $d" in
def MOVHrlc : MOV_CONST<0x7B, "movh", (ins DataRegs:$fakesrc, i32imm:$const16), []>;

let isReMaterializable = 1, isAsCheapAsAMove = 1 in 
def MOVi32 : TriCorePseudoInst<(outs DataRegs:$d), (ins i32imm:$const32), "MOV32 Pseudo",
                     [(set DataRegs:$d, (movei32 imm:$const32))]>;
//===----------------------------------------------------------------------===//
// Load/Store Instructions
//===----------------------------------------------------------------------===//

class AlignedLoad<bits<6> op2, string opstr, 
								PatFrag PF, RegisterClass RC = DataRegs, ValueType intType = i32> : 
			BO<0x09, op2, (outs RC:$d),
			   (ins memsrc:$off10),
			 	 !strconcat(opstr, " $d, $off10"),
				 [(set RC:$d, (intType (PF addr:$off10)))]> 
{
	let mayLoad = 1;
}

def LDBbo  : AlignedLoad<0x20, "ld.b"  , sextloadi8>;
def LDBUbo : AlignedLoad<0x21, "ld.bu" , zextloadi8>;
def LDHbo  : AlignedLoad<0x22, "ld.h"  , sextloadi16>;
def LDHUbo : AlignedLoad<0x23, "ld.hu" , zextloadi16>;
def LDWbo  : AlignedLoad<0x24, "ld.w"  , load>;
def LDDbo  : AlignedLoad<0x25, "ld.d"  , load, ExtRegs, i64>;


def : Pat<(extloadi8 addr:$src), (LDBbo addr:$src)>;
def : Pat<(extloadi16 addr:$src), (LDHbo addr:$src)>;

let Predicates = [isnotPointer] in 
def STBbo : BO<0x89, 0x20,(outs), (ins DataRegs:$d, memsrc:$off10),
							"st.b $off10, $d",
							[(truncstorei8 DataRegs:$d, addr:$off10)]>;

let Predicates = [isnotPointer] in 
def STHbo : BO<0x89, 0x22,(outs), (ins DataRegs:$d, memsrc:$off10),
							"st.h $off10, $d",
							[(truncstorei16 DataRegs:$d, addr:$off10)]>;

let Predicates = [isnotPointer] in 
def STWbo : BO<0x89, 0x24, (outs), (ins DataRegs:$d, memsrc:$off10),
                  "st.w $off10, $d",
                  [(store DataRegs:$d, addr:$off10)]>;

let Predicates = [isnotPointer] in 
def STDbo : BO<0x89, 0x25, (outs), (ins ExtRegs:$d, memsrc:$off10),
                  "st.d $off10, $d",
                  [(store ExtRegs:$d, addr:$off10)]>;

let Predicates = [isPointer] in 
def STAbo : BO<0x89, 0x26, (outs), (ins AddrRegs:$d, memsrc:$off10),
                  "st.a $off10, $d",
                  [(store i32:$d, addr:$off10)]>;

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
// Extension Instructions
//===----------------------------------------------------------------------===//
def zext8  : PatFrag<(ops node:$src), (and node:$src, 0xff)>;
def zext16 : PatFrag<(ops node:$src), (and node:$src, 0xffff)>;

def ZEXT16r : T32<  (outs DataRegs:$dst), (ins DataRegs:$src),
                    "zxt16\t$dst",
                    [(set DataRegs:$dst, (zext16 DataRegs:$src))]>;

def ZEXT8r : T32<  (outs DataRegs:$dst), (ins DataRegs:$src),
                    "zxt8\t$dst",
                    [(set DataRegs:$dst, (zext8 DataRegs:$src))]>;

def sext8  : PatFrag<(ops node:$src), (sext_inreg node:$src, i8)>;
def sext16 : PatFrag<(ops node:$src), (sext_inreg node:$src, i16)>;

def SEXT16r : T32<  (outs DataRegs:$dst), (ins DataRegs:$src),
                    "sxt16\t$dst",
                    [(set DataRegs:$dst, (sext16 DataRegs:$src))]>;

def SEXT8r : T32<  (outs DataRegs:$dst), (ins DataRegs:$src),
                    "sxt8\t$dst",
                    [(set DataRegs:$dst, (sext8 DataRegs:$src))]>;

//===----------------------------------------------------------------------===//
// Compare Instructions
//===----------------------------------------------------------------------===//

multiclass COMPARE_32<bits<8> op2, string asmstring, PatLeaf PF> {
	
	def rc : RC<0x8B, op2{6-0},
					 (outs DataRegs:$d),
					 (ins DataRegs:$s1, s9imm:$const9),
					 !strconcat(asmstring, " $d, $s1, $const9"),
					 [( set DataRegs:$d, (TriCorecmp DataRegs:$s1, immSExt9:$const9, PF))]>;
	
	def rr : RR<0x0B, op2,
						 (outs DataRegs:$d),
						 (ins DataRegs:$s1, DataRegs:$s2),
						 !strconcat(asmstring, " $d, $s1, $s2"),
						 [( set DataRegs:$d, (TriCorecmp DataRegs:$s1, DataRegs:$s2, PF))]>;
}

defm NE : COMPARE_32<0x11, "ne", TriCore_COND_NE>;
defm EQ : COMPARE_32<0x10, "eq", TriCore_COND_EQ>;
defm GE : COMPARE_32<0x14, "ge", TriCore_COND_GE>;
defm LT : COMPARE_32<0x12, "lt", TriCore_COND_LT>;

//===----------------------------------------------------------------------===//
// Branch Instructions
//===----------------------------------------------------------------------===//

multiclass JUMP_16<bits<8> op1_sb, bits<8> op1_sbr, 
									string asmstring, PatLeaf PF>
{

//		let Uses = [D15] in
//		def sb: SB<op1_sb, (outs), 
//					(ins jmptarget:$disp4),
//					!strconcat(asmstring, " %d15, $disp4"),
//					[(TriCorebrcc  bb:$disp4)]>;
			
		def sbr: SBR<op1_sbr, (outs), 
					(ins jmptarget:$disp4, DataRegs:$s1),
					!strconcat(asmstring, " $s1, $disp4"),
					[(TriCorebrcc  bb:$disp4, DataRegs:$s1, PF)]>;
}


let isBranch = 1, isTerminator = 1 in {
// Direct branch
let isBarrier = 1 in {
  def Jb : B<0x1D, (outs), (ins jmptarget:$dst),
                "j $dst", 
								[(br bb:$dst)]>;
}

// Conditional branches

	defm JNZ : JUMP_16<0xEE, 0xF6, "jnz", TriCore_COND_NE>;
	defm JZ : JUMP_16<0x6E, 0x76, "jz", TriCore_COND_EQ>;

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
//}// isBranch, isTerminator
		

let usesCustomInserter = 1 in {
  def Select8  : TriCorePseudoInst<(outs DataRegs:$dst),
  		                             (ins DataRegs:$src, DataRegs:$src2, i32imm:$cc, DataRegs:$src1 ),
																	 "# Select8 PSEUDO",
																	 [(set DataRegs:$dst,
                                   (TriCoreselectcc DataRegs:$src, DataRegs:$src2, imm:$cc, DataRegs:$src1))]>;
}

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

//def : Pat<(i64 imm:$src),
//          (INSERT_SUBREG (i64 (IMPLICIT_DEF)), (MOVi64 imm:$src), subreg_even)>;

// Lower 32 bits of a 64-bit word 
def LO32 : SDNodeXForm<imm, [{
//	uint64_t x = N->getZExtValue();
//	outs() << "Const: " << N->getZExtValue() << "\n";
//	outs() << "Const: " << (uint32_t)N->getZExtValue() << "\n";
//	outs() << "Const: " << (x>>32) << "\n";
	return CurDAG->getTargetConstant((uint32_t) N->getZExtValue(), SDLoc(N), MVT::i32);
}]>; 

// Higher 32 bits of a 64-bit word 
def HI32 : SDNodeXForm<imm, [{
	return CurDAG->getTargetConstant((uint32_t) (N->getZExtValue()>>32), SDLoc(N), MVT::i32);
}]>; 


def : Pat<(i64 imm:$src),
          (INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
          		           (MOVi32( LO32 imm:$src)), subreg_even)),
          		           (MOVi32( HI32 imm:$src)), subreg_odd)>;

//def : Pat<(i64 imm:$imm), 
//          (INSERT_SUBREG (i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
//          								(MOVi64 imm:$src), sub_even)), 
//                           (MOVi64 imm:$src), sub_odd)>;

//def : Pat<(i64 imm:$src),
//					(MOVi64 imm:$src)>;

def : Pat<(i32 (TriCoreWrapper tglobaladdr:$dst)), 
		 (MOVi32 tglobaladdr:$dst)>;

