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

//def SDT_TriCoreCmp          : SDTypeProfile<1, 3, [SDTCisSameAs<0, 1>,
//																									 SDTCisSameAs<1, 2>,
//																									 SDTCisVT<3, i32>]>;

def SDT_TriCoreCmp          : SDTypeProfile<1, 3, [SDTCisSameAs<0, 1>,
																									 SDTCisSameAs<0, 2>,
																									 SDTCisInt<0>,
																									 SDTCisVT<3, i32>]>;



def SDT_TriCoreImask        : SDTypeProfile<1, 3, [SDTCisVT<0, i64>,
																									 SDTCisVT<1, i32>,
																									 SDTCisVT<2, i32>,
																									 SDTCisVT<3, i32>]>;

def SDT_TriCoreExtract       : SDTypeProfile<1, 3, [SDTCisVT<0, i32>,
																									 SDTCisVT<1, i32>,
																									 SDTCisVT<2, i32>,
																									 SDTCisVT<3, i32>]>;

//def SDT_TriCoreLCmp         : SDTypeProfile<1, 4, [SDTCisSameAs<0, 1>,
//																									 SDTCisSameAs<1, 2>,
//																									 SDTCisSameAs<2, 3>,
//																									 SDTCisVT<4, i32>]>;


def SDT_TriCoreLCmp         : SDTypeProfile<1, 4, [SDTCisSameAs<0, 1>,
																									 SDTCisSameAs<0, 2>,
																									 SDTCisSameAs<0, 3>,
																									 SDTCisInt<0>,
																									 SDTCisVT<4, i32>]>;

def SDT_TriCoreBrCC         : SDTypeProfile<0, 3, [SDTCisVT<0, OtherVT>,
																									 SDTCisVT<1, i32>,
																									 SDTCisVT<2, i32>]>;

//def SDT_TriCoreSelectCC     : SDTypeProfile<1, 4, [SDTCisSameAs<0, 1>,
//																									 SDTCisSameAs<1, 2>, 
//																									 SDTCisVT<3, i32>,
//																									 SDTCisVT<4, i32>]>;

def SDT_TriCoreSelectCC     : SDTypeProfile<1, 4, [SDTCisSameAs<0, 1>,
																									 SDTCisSameAs<1, 2>, 
																									 SDTCisVT<3, i32>,
																									 SDTCisSameAs<0, 4>,
																									 SDTCisInt<0>
																									 ]>;

def SDT_TriCoreWrapper      : SDTypeProfile<1, 1, [SDTCisSameAs<0, 1>,
																									 SDTCisPtrTy<0>]>;
//def SDT_TriCoreShift        : SDTypeProfile<1, 2, [SDTCisSameAs<0, 1>,
//																									 SDTCisVT<2, i32>]>;
def SDT_TriCoreShift        : SDTypeProfile<1, 2, [SDTCisSameAs<0, 1>, 
																									 SDTCisVT<0, i32>, 
																									 SDTCisVT<2, i32>]>;

def TriCorebrcc    : SDNode<"TriCoreISD::BR_CC", 
														SDT_TriCoreBrCC, [SDNPHasChain, SDNPInGlue]>;
def TriCorecmp     : SDNode<"TriCoreISD::CMP", 
														SDT_TriCoreCmp, [SDNPOutGlue]>;
def TriCorelogiccmp: SDNode<"TriCoreISD::LOGICCMP", 
														SDT_TriCoreLCmp, [SDNPInGlue, SDNPOutGlue]>;
def TriCoreWrapper : SDNode<"TriCoreISD::Wrapper", SDT_TriCoreWrapper>;
//def TriCoreWrapper : SDNode<"TriCoreISD::Wrapper", SDTIntUnaryOp>;
def TriCoreimask   : SDNode<"TriCoreISD::IMASK", SDT_TriCoreImask>;
def TriCoresh      : SDNode<"TriCoreISD::SH",  SDT_TriCoreShift>;
def TriCoresha     : SDNode<"TriCoreISD::SHA", SDT_TriCoreShift>;
def TriCoreextr    : SDNode<"TriCoreISD::EXTR", SDT_TriCoreExtract>;
def TriCoreselectcc: SDNode<"TriCoreISD::SELECT_CC", SDT_TriCoreSelectCC, []>;

def jmptarget : Operand<OtherVT> {
  let PrintMethod = "printPCRelImmOperand";
}

// Operand for printing out a condition code.
def cc : Operand<i32> {
  let PrintMethod = "printCCOperand";
}


def isPointer : Predicate<"isPointer() == true">;
def isnotPointer : Predicate<"isPointer() == false">;

// TriCore Condition Codes
def TriCore_COND_EQ : PatLeaf<(i32 0)>;
def TriCore_COND_NE : PatLeaf<(i32 1)>;
def TriCore_COND_GE : PatLeaf<(i32 2)>;
def TriCore_COND_LT : PatLeaf<(i32 3)>;
// TriCore Logic Codes
def TriCore_LOGIC_AND_EQ : PatLeaf<(i32 0)>;
def TriCore_LOGIC_AND_GE : PatLeaf<(i32 2)>;
def TriCore_LOGIC_AND_LT : PatLeaf<(i32 3)>;
def TriCore_LOGIC_OR_NE :  PatLeaf<(i32 1)>;
def TriCore_LOGIC_OR_GE :  PatLeaf<(i32 12)>;
def TriCore_LOGIC_OR_LT :  PatLeaf<(i32 13)>;


//===----------------------------------------------------------------------===//
// ADD Instructions
//===----------------------------------------------------------------------===//
let Constraints = "$s1 = $d" in
		def ADDsrc : SRC<0xC2, (outs DataRegs:$d), (ins DataRegs:$s1, s4imm:$const4),
		"add $d, $const4",
		[(set DataRegs:$d, (add DataRegs:$s1, immSExt4:$const4) )]>;

let isCommutable = 1 in {
	
	let AddedComplexity = 6 in
	def ADDrr : RR<0x0B, 0x00, (outs DataRegs:$d), 
			(ins DataRegs:$s1, DataRegs:$s2),
			"add $d, $s1, $s2",
			[(set i32:$d, (add i32:$s1, i32:$s2))]>;

	def ADDArr : RR<0x01, 0x01, (outs AddrRegs:$d),
			(ins AddrRegs:$s1, AddrRegs:$s2),
			"add.a $d, $s1, $s2",
			[(set AddrRegs:$d, (add AddrRegs:$s1, AddrRegs:$s2))]>;
	

} // let isCommutable = 1

let Constraints="$d = $fksrc",
		AddedComplexity = 7 in
def ADDsrr: SRR<0x42, (outs DataRegs:$d),
		(ins DataRegs:$fksrc, DataRegs:$s2 ),
		"add $d, $s2",
		[(set DataRegs:$d, (add DataRegs:$s2, DataRegs:$fksrc))]>;

def ADDrc : RC<0x8B, 0x00, (outs DataRegs:$d),
		(ins DataRegs:$s1, i32imm:$const9),
		"add $d, $s1, $const9",
		[(set DataRegs:$d, (add DataRegs:$s1, immSExt9:$const9))]>;

def ADDIrlc : RLC<0x1B, (outs DataRegs:$d),
		(ins DataRegs:$s1, i32imm:$const16), // FIXME: this should be an i32 Operands
																				 // with a predicate condition. Working now
		"addi $d, $s1, $const16",
		[(set DataRegs:$d, (add DataRegs:$s1, immSExt16:$const16))]>;

let Defs = [PSW],	Uses = [PSW] in {
	let isCommutable = 1 in {
		def ADDCrr : RR<0x0B, 0x05, (outs DataRegs:$d), 
				(ins DataRegs:$s1, DataRegs:$s2),
				"addc $d, $s1, $s2",
				[(set DataRegs:$d, (addc DataRegs:$s1, DataRegs:$s2)),
				 (implicit PSW)]>;

		def ADDXrr : RR<0x0B, 0x04, (outs DataRegs:$d), 
				(ins DataRegs:$s1, DataRegs:$s2),
				"addx $d, $s1, $s2",
				[(set DataRegs:$d, (adde DataRegs:$s1, DataRegs:$s2)),
				 (implicit PSW)]>;
	} // let isCommutable = 1

	def ADDCrc : RR<0x8B, 0x05, (outs DataRegs:$d), 
			(ins DataRegs:$s1, s9imm:$const9),
			"addc $d, $s1, $const9",
			[(set DataRegs:$d, (addc DataRegs:$s1, immSExt9:$const9)),
			 (implicit PSW)]>;

	def ADDXrc : RC<0x0B, 0x04, (outs DataRegs:$d), 
			(ins DataRegs:$s1, s9imm:$const9),
			"addx $d, $s1, $const9",
			[(set DataRegs:$d, (adde DataRegs:$s1, immSExt9:$const9)),
			 (implicit PSW)]>;

	def SUBCrr : RR<0x0B, 0x0D, (outs DataRegs:$d), 
			(ins DataRegs:$s1, DataRegs:$s2),
			"subc $d, $s1, $s2",
			[(set DataRegs:$d, (subc DataRegs:$s1, DataRegs:$s2)),
			 (implicit PSW)]>;

	def SUBXrr : RR<0x0B, 0x04, (outs DataRegs:$d), 
			(ins DataRegs:$s1, DataRegs:$s2),
			"subx $d, $s1, $s2",
			[(set DataRegs:$d, (sube DataRegs:$s1, DataRegs:$s2)),
			 (implicit PSW)]>;

} // let Defs = [PSW],	Uses = [PSW]



def ADDFrrr : RRR<0x6B, 0x02, (outs FPRegs:$d), 
		(ins FPRegs:$s1, FPRegs:$s2),
		"add.f $d, $s1, $s2",
		[(set FPRegs:$d, (fadd FPRegs:$s1, FPRegs:$s2))]>;

def imml_32_h_32 : Operand<i64>, PatLeaf<(imm), [{

	int64_t val = N->getSExtValue();
	int32_t lByte = val & 0xffffffff;
	int32_t hByte = (val >> 32) & 0xffffffff;

	return (lByte >=-256 && lByte < 256 && hByte >=-256 && hByte < 256);

}]>;

let Defs = [PSW] in {
def ADDi64C : Pseudo<(outs ExtRegs:$d),
									  (ins ExtRegs:$s1, imml_32_h_32:$const64),
									  "ADDi64C Pseudo",
									  [(set ExtRegs:$d, (add ExtRegs:$s1, imml_32_h_32:$const64)),
										(implicit PSW)]>;

def ADDi64 : Pseudo<(outs ExtRegs:$d),
									  (ins ExtRegs:$s1, ExtRegs:$s2),
									  "ADDi64 Pseudo",
									  [(set ExtRegs:$d, (add ExtRegs:$s1, ExtRegs:$s2)),
										(implicit PSW)]>;

def SUBi64 : Pseudo<(outs ExtRegs:$d),
									  (ins ExtRegs:$s1, ExtRegs:$s2),
									  "SUBi64 Pseudo",
									  [(set ExtRegs:$d, (sub ExtRegs:$s1, ExtRegs:$s2)),
										(implicit PSW)]>;

} //let Defs = [PSW]

let Defs = [A10], Uses = [A10] in
def SUBAsc : SC<0x20, (outs), (ins u8imm:$const8), "sub.a %a10, $const8", []>;

def SUBArr : RR<0x01, 0x02, (outs AddrRegs:$d), 
		(ins AddrRegs:$s1, AddrRegs:$s2), "sub.a $d, $s1, $s2",
		[(set AddrRegs:$d, (sub AddrRegs:$s1, AddrRegs:$s2) )]>;

def RSUBrc : RC<0x8B, 0x08, (outs DataRegs:$d), 
							(ins DataRegs:$s1, s9imm:$const9) ,"rsub $d, $s1, $const9",
							[(set DataRegs:$d, (sub immSExt9:$const9, DataRegs:$s1)) ]>;

let Constraints="$d = $s1" in
		def RSUBsr : SR<0x32, 0x05, (outs DataRegs:$d), (ins DataRegs:$s1),
		"rsub $d", [(set DataRegs:$d, (sub (i32 0), DataRegs:$s1)) ]>;

let Defs=[PSW] in {
	
	let Constraints="$d = $fksrc" in
	def MULsrr : SRR<0xE2, (outs DataRegs:$d),
				(ins DataRegs:$fksrc, DataRegs:$s2), "mul $d, $s2",
				[(set DataRegs:$d, (mul DataRegs:$fksrc, DataRegs:$s2) )]>;
	
	def MULrr2 : RR2<0x73, 0x00A, (outs DataRegs:$d),
			(ins DataRegs:$s1, DataRegs:$s2), "mul $d, $s1, $s2",
			[(set DataRegs:$d, (mul DataRegs:$s1, DataRegs:$s2) )]>;

	def MULrc : RC<0x53, 0x001, (outs DataRegs:$d),
			(ins DataRegs:$s1, s9imm:$const9),  "mul $d, $s1, $const9",
			[(set DataRegs:$d, (mul DataRegs:$s1, immSExt9:$const9) )]>;
	
	def MULrc2 : RC<0x53, 0x03, (outs ExtRegs:$d),
				(ins ExtRegs:$s1, DataRegs:$s2),  "mul $d, $s1, $s2",
				[(set ExtRegs:$d, (mul ExtRegs:$s1, (sext DataRegs:$s2)) )]>;
	
		
}
//===----------------------------------------------------------------------===//
// Logical Instructions
//===----------------------------------------------------------------------===//

multiclass Logical32_0<bits<8> opcode1, string asmstring, 
SDNode OpNode> 
{
	def rc: RC<0x8f, opcode1{6-0}, (outs DataRegs:$d), 
			(ins DataRegs:$s1, u9imm:$const9),
			!strconcat(asmstring, " $d, $s1, $const9"),
			[(set DataRegs:$d, (OpNode DataRegs:$s1, immZExt9:$const9))]>; 

	let isCommutable = 1 in
			def rr: RR<0x0f, opcode1, (outs DataRegs:$d), 
			(ins DataRegs:$s1, DataRegs:$s2),
			!strconcat(asmstring, " $d, $s1, $s2"),
			[(set DataRegs:$d, (OpNode DataRegs:$s1, DataRegs:$s2))]>; 
}

multiclass Logical32_1<bits<8> opcode1, string asmstring, 
SDNode OpNode1, PatFrag OpNode2> 
{
	def rc: RC<0x8f, opcode1{6-0}, (outs DataRegs:$d), 
			(ins DataRegs:$s1, u9imm:$const9),
			!strconcat(asmstring, " $d, $s1, $const9"),
			[(set DataRegs:$d, (OpNode2 (OpNode1 DataRegs:$s1, immZExt9:$const9)))]>;

	let isCommutable = 1 in
			def rr: RR<0x0f, opcode1, (outs DataRegs:$d), 
			(ins DataRegs:$s1, DataRegs:$s2),
			!strconcat(asmstring, " $d, $s1, $s2"),
			[(set DataRegs:$d, (OpNode2 (OpNode1 DataRegs:$s1, DataRegs:$s2)))]>;
}

multiclass Logical16<bits<8> opcode1_sc, bits<8> opcode1_srr, 
string asmstring, SDNode OpNode>
{

	let Uses=[D15], Defs=[D15] in
			def sc: SC<opcode1_sc, (outs), 
					(ins u8imm:$const8),
					!strconcat(asmstring, " %d15, $const8"),
					[(set D15, (OpNode D15, immZExt8:$const8))]>; 

	let Constraints = "$s1 = $d" in
			def srr: SRR<opcode1_srr, (outs DataRegs:$d), 
			(ins DataRegs:$s1, DataRegs:$s2),
			!strconcat(asmstring, " $d, $s2"),
			[(set DataRegs:$d, (OpNode DataRegs:$s1, DataRegs:$s2))]>;
}

def imml_32_h_32_const9 : Operand<i64>, PatLeaf<(imm), [{

	int64_t val = N->getSExtValue();
	int32_t lByte = val & 0xffffffff;
	int32_t hByte = (val >> 32) & 0xffffffff;

	return (lByte >=0 && lByte < 512 && hByte >=0 && hByte < 512);

}]>;

def imml_neg_32_h_32_const64 : Operand<i64>, PatLeaf<(imm), [{
	
	int64_t val = N->getSExtValue();
	int32_t lByte = val & 0xffffffff;
	int32_t hByte = (val >> 32) & 0xffffffff;
	
	return (lByte >=-512 && lByte < 0 && hByte >=-512 && hByte < 0);
			
}]>;

multiclass Logical64_Pseudo<SDNode OpNode>
{
	def rc64: Pseudo<(outs ExtRegs:$d), 
			(ins ExtRegs:$s1, imml_32_h_32_const9:$const64),
			"##NAME## Pseudo",
			[(set ExtRegs:$d, (OpNode ExtRegs:$s1, imml_32_h_32_const9:$const64))]>;

	let Constraints = "$s1 = $d", isCommutable = 1 in
			def srr64: Pseudo<(outs ExtRegs:$d), 
			(ins ExtRegs:$s1, ExtRegs:$s2),
			"##NAME## Pseudo",
			[(set ExtRegs:$d, (OpNode ExtRegs:$s1, ExtRegs:$s2))]>;
}

defm AND : Logical64_Pseudo<and>;
defm OR  : Logical64_Pseudo<or>;
defm XOR : Logical64_Pseudo<xor>;

defm AND : Logical16<0x16, 0x26, "and", and>;
defm AND : Logical32_0<0x08, "and", and>;

defm NAND : Logical32_1<0x09, "nand", and, not>;
defm NOR  : Logical32_1<0x0B, "nor", or, not>;
//defm XNOR : Logical32_1<0x0B, "nxor", xor, not>;

defm OR : Logical32_0<0x0a, "or", or>;
defm OR : Logical16<0x96, 0xA6, "or", or>;

defm XOR : Logical32_0<0x0c, "xor", xor>;

let Constraints = "$s1 = $d", isCommutable = 1 in
		def XORsrr : SRR<0xc6, (outs DataRegs:$d), 
		(ins DataRegs:$s1, DataRegs:$s2), "xor $d, $s1, $s2",
		[(set DataRegs:$d, (xor DataRegs:$s1, DataRegs:$s2))]>;

def imm_from_0_to_neg512 : Operand<i32>, PatLeaf<(imm), [{
	int64_t val = N->getSExtValue();
	return (val >=-512 && val <= 0);
}]>;

class LOGICALN_RC <bits<7> op2, string asmstring, SDNode OpNode>
	: RC<0x8f, op2, (outs DataRegs:$d), 
    (ins DataRegs:$s1, imm_from_0_to_neg512:$const9),
		!strconcat(asmstring," $d, $s1, ~($const9)"),
		[(set i32:$d, (OpNode i32:$s1, imm_from_0_to_neg512:$const9 ))]>;

def ANDNrc : LOGICALN_RC<0x0e, "andn", and>;
def ORNrc  : LOGICALN_RC<0x0f, "orn", or>;
def XNORrc : LOGICALN_RC<0x0d, "xnor", xor>;

let Constraints = "$s1 = $d" in {
def NOTsr : SR<0x46, 0x0, (outs DataRegs: $d), (ins DataRegs:$s1), 
						"not $d", [(set DataRegs:$d, (not DataRegs:$s1))]>;

def NOTrr64: Pseudo<(outs ExtRegs:$d), (ins ExtRegs:$s1), 
		"##NAME## Pseudo", [(set ExtRegs:$d, (not ExtRegs:$s1))]>;
} // let Constraints = "$s1 = $d" in

def ANDNrc64: Pseudo<(outs ExtRegs:$d), 
		(ins ExtRegs:$s1, imml_neg_32_h_32_const64:$const64), 
		"##NAME## Pseudo", 
		[(set ExtRegs:$d, (and ExtRegs:$s1, imml_neg_32_h_32_const64:$const64))]>;

def ORNrc64: Pseudo<(outs ExtRegs:$d), 
		(ins ExtRegs:$s1, imml_neg_32_h_32_const64:$const64), 
		"##NAME## Pseudo", 
		[(set ExtRegs:$d, (or ExtRegs:$s1, imml_neg_32_h_32_const64:$const64))]>;

def XORrcneg64: Pseudo<(outs ExtRegs:$d), 
		(ins ExtRegs:$s1, imml_neg_32_h_32_const64:$const64), 
		"##NAME## Pseudo",
		[(set ExtRegs:$d, (xor ExtRegs:$s1, imml_neg_32_h_32_const64:$const64))]>;


//===----------------------------------------------------------------------===//
// Mov Immediate Instructions
//===----------------------------------------------------------------------===//

class MOV_RR<bits<8> op1, bits<8> op2, string opstr, 
RegisterClass outregClass, RegisterClass inregClass>
: RR<op1, op2,
	(outs outregClass:$d),
	(ins inregClass:$s2),
	!strconcat(opstr, " $d, $s2"), [/* No Pattern*/]>;

class MOV_CONST<bits<8> opcode, string opstr, dag ins, list<dag> pattern>
: RLC<opcode, (outs DataRegs:$d), ins,
	!strconcat(opstr, " $d, $const16"), pattern>;

def MOVrr   : MOV_RR<0x0B, 0x1F, "mov", DataRegs, DataRegs>;
def MOVDrr  : MOV_RR<0x01, 0x4C, "mov.d", DataRegs, AddrRegs>;
def MOVArr  : MOV_RR<0x01, 0x63, "mov.a", AddrRegs, DataRegs>;

def MOVAAsrr : SRR<0x40, (outs AddrRegs:$d),
												(ins AddrRegs:$s2),
												"mov.aa $d, $s2", [] >;

def MOVAArr : MOV_RR<0x01, 0x00, "mov.aa", AddrRegs, AddrRegs>;


def MOVsrc : SRC<0x82, (outs DataRegs:$d), 
								(ins s4imm:$const4),
								"mov $d, $const4",
								 [(set DataRegs:$d, immSExt4:$const4)]>;

def MOVrlc  : MOV_CONST<0x3B,"mov", (ins s16imm:$const16) ,
              [(set DataRegs:$d, immSExt16:$const16)]>;
def MOVUrlc : MOV_CONST<0xBB,"mov.u", (ins u16imm:$const16) ,
              [(set DataRegs:$d, immZExt16:$const16)]>;

def MOVHrlc : MOV_CONST<0x7B, "movh", (ins i32imm:$const16), [/* No Pattern*/]>;

//let isReMaterializable = 1, isAsCheapAsAMove = 1 in 
def MOVi32 : Pseudo<(outs DataRegs:$d), (ins i32imm:$const32), "##NAME## Pseudo",
                     [(set DataRegs:$d, (movei32 imm:$const32))]>;

def IMASKrcpw :  RCPW<0xB7, 0b01, (outs ExtRegs:$d),
		(ins u4imm:$const4, i32imm:$pos, i32imm:$width),
		"imask $d, $const4, $pos, $width",
		[(set ExtRegs:$d, (TriCoreimask immZExt4:$const4, imm:$pos, imm:$width))]>;

def DEXTRrrpw :  RRPW<0x77, 0b00, (outs DataRegs:$d),
		(ins DataRegs:$s1, DataRegs:$s2, i32imm:$pos),
		"dextr $d, $s1, $s2, $pos",
		[(set DataRegs:$d, (TriCoreextr DataRegs:$s1, DataRegs:$s2, immZExt4:$pos))]>;

def EXTRrrpw :  RRPW<0x37, 0b10, (outs DataRegs:$d),
		(ins DataRegs:$s1, i32imm:$pos, i32imm:$width),
		"extr $d, $s1, $pos, $width",
		[(set DataRegs:$d, (TriCoreextr DataRegs:$s1, immZExt4:$pos, immZExt4:$width))]>;
//===----------------------------------------------------------------------===//
// Load/Store Instructions
//===----------------------------------------------------------------------===//

class AlignedLoad<bits<6> op2, string opstr, PatFrag PF, 
									RegisterClass RC = DataRegs, ValueType intType = i32>
								: BO<0x09, op2, (outs RC:$d),
								 (ins memsrc:$memri),
								 !strconcat(opstr, " $d, $memri"),
								 [(set RC:$d, (intType (PF addr:$memri)))]>{ let mayLoad = 1; }

def LDBbo  : AlignedLoad<0x20, "ld.b"  , sextloadi8>;
def LDBUbo : AlignedLoad<0x21, "ld.bu" , zextloadi8>;
def LDHbo  : AlignedLoad<0x22, "ld.h"  , sextloadi16>;
def LDHUbo : AlignedLoad<0x23, "ld.hu" , zextloadi16>;
//def LDWbo  : AlignedLoad<0x24, "ld.w"  , load>;
def LDDbo  : AlignedLoad<0x25, "ld.d"  , load, ExtRegs, i64>;

def LDWbo : BOL<0x19, (outs DataRegs:$d),
		 (ins memsrc:$memri),
		 "ld.w $d, $memri",
		 [(set DataRegs:$d, (load addr:$memri))]>{ let mayLoad = 1; }


def LDWbo_f : BOL<0x19, (outs FPRegs:$d),
		 (ins memsrc:$memri),
		 "ld.w $d, $memri",
		 [(set FPRegs:$d, (load addr:$memri))]>{ let mayLoad = 1; }
//def LDAbo : BOL<0x99, (outs AddrRegs:$d),
//		 (ins memsrc:$memri),
//		 "ld.a $d, $memri",
//		 [(set AddrRegs:$d, (load addr:$memri))]>{ let mayLoad = 1; }

//def : Pat<(extloadi8 addr:$src), (LDBbo addr:$src)>;
//def : Pat<(extloadi16 addr:$src), (LDHbo addr:$src)>;



def : Pat<(extloadi8 addr:$src), (i32 (LDBbo  addr:$src))>;
def : Pat<(extloadi16 addr:$src), (i32 (LDHbo  addr:$src))>;

let Predicates = [isnotPointer] in {
	def STBbo : BO<0x89, 0x20,(outs), (ins DataRegs:$d, memsrc:$memri),
			"st.b $memri, $d",
			[(truncstorei8 DataRegs:$d, addr:$memri)]>;

	def STHbo : BO<0x89, 0x22,(outs), (ins DataRegs:$d, memsrc:$memri),
			"st.h $memri, $d",
			[(truncstorei16 DataRegs:$d, addr:$memri)]>;

	def STWbo : BO<0x89, 0x24, (outs), (ins DataRegs:$d, memsrc:$memri),
			"st.w $memri, $d",
			[(store DataRegs:$d, addr:$memri)]>;

	def STDbo : BO<0x89, 0x25, (outs), (ins ExtRegs:$d, memsrc:$memri),
			"st.d $memri, $d",
			[(store ExtRegs:$d, addr:$memri)]>;	
	
	def : Pat<(truncstorei32 ExtRegs:$d, addr:$memri), 
			 (STWbo (EXTRACT_SUBREG ExtRegs:$d, subreg_even), addr:$memri)>;
	
	def : Pat<(store FPRegs:$d, addr:$memri), 
				 (STWbo (EXTRACT_SUBREG FPRegs:$d, subreg_even), addr:$memri)>;
	
	def : Pat<(truncstorei8 ExtRegs:$d, addr:$memri), 
				 (STWbo (ANDrc (EXTRACT_SUBREG ExtRegs:$d, subreg_even), (i32 255)), addr:$memri)>;	
	
	
} // let Predicates = [isnotPointer]


let Predicates = [isPointer] in 
		def STAbo : BO<0x89, 0x26, (outs), (ins AddrRegs:$d, memsrc:$memri),
		"st.a $memri, $d",
		[(store i32:$d, addr:$memri)]>;

//===----------------------------------------------------------------------===//
// Shift Instructions
//===----------------------------------------------------------------------===//

// only const9[5:0] is of importance
def SHrc : RC<0x8F,0x00, (outs DataRegs:$d), (ins DataRegs:$s1, s9imm:$const9),
		"sh $d, $s1, $const9",
		[(set DataRegs:$d, (TriCoresh DataRegs:$s1, immSExt6:$const9))]>;	

def SHrr : RR<0x0F, 0x00, (outs DataRegs:$d), (ins DataRegs:$s1, DataRegs:$s2),
		"sh $d, $s1, $s2", [(set DataRegs:$d, (TriCoresh DataRegs:$s1, DataRegs:$s2))]>;

def SHArc : RC<0x8F,0x01, (outs DataRegs:$d), (ins DataRegs:$s1, s9imm:$const9),
		"sha $d, $s1, $const9",
		[(set DataRegs:$d, (TriCoresha DataRegs:$s1, immSExt6:$const9))]>;	

def SHArr : RR<0x0F, 0x01, (outs DataRegs:$d), (ins DataRegs:$s1, DataRegs:$s2),
		"sha $d, $s1, $s2", [(set DataRegs:$d, (TriCoresha DataRegs:$s1, DataRegs:$s2))]>;



//===----------------------------------------------------------------------===//
// Return Instructions
//===----------------------------------------------------------------------===//

let isTerminator = 1, isReturn = 1, 
		isBarrier = 1, Uses =[PCXI, PSW, FCX],
		Defs= [PSW, PCXI, PC, FCX] in 
  def RETsr : T16<0x00, (outs), (ins variable_ops), "ret",  [(TriCoreRetFlag)]> {
  	let Inst{15-12} = 0x9; 
  }

//let isTerminator = 1, isReturn = 1, 
//		isBarrier = 1, Uses = [A11] in 
//	def RETsr : T16<0x00, (outs), (ins variable_ops), "ret",  [(TriCoreRetFlag)]> {
//		let Inst{15-12} = 0x9; 
//	}

  
  
//===----------------------------------------------------------------------===//
// Call Instructions
//===----------------------------------------------------------------------===//

// The target of a 24-bit call instruction.
def call_target : Operand<i32>
{
		let EncoderMethod = "encodeCallTarget";
}  
  
  
let isCall = 1, Defs = [A11], Uses = [A10] in 
	def CALLb : B<0x6D, (outs), (ins i32imm:$disp24),
	"call $disp24",  [(tricore_call imm:$disp24)]>;

def : Pat<(tricore_call (i32 tglobaladdr:$dst)),
					(CALLb tglobaladdr:$dst)>;
def : Pat<(i32 (TriCoreWrapper tglobaladdr:$dst)), 
		 (MOVi32 tglobaladdr:$dst)>;


//===----------------------------------------------------------------------===//
// Tentative Call Instructions
//===----------------------------------------------------------------------===//

//def SDT_LEGCall    : SDTypeProfile<0, -1, [SDTCisPtrTy<0>]>;  
// 
//def load_sym : SDNode<"TriCoreISD::LOAD_SYM", SDT_TriCoreWrapper>;
//
//def leg_call
//		: SDNode<"TriCoreISD::CALL", SDT_LEGCall,
//						 [ SDNPHasChain, SDNPOptInGlue, SDNPOutGlue, SDNPVariadic ]>;
//
//let isCall = 1, Defs = [A11], Uses = [A10] in 
//	def CALLb : B<0x6D, (outs), (ins call_target:$disp24),
//	"call $disp24",  [(leg_call imm:$disp24)]>;
//		
//def : Pattern<(i32 (load_sym tglobaladdr:$addr)),  [(MOVi32 $addr)]>;
//
//let isCall = 1, Defs = [A11], Uses = [A10] in 
//	def CALLb : B<0x6D, (outs), (ins DataRegs:$addr),
//	"call $addr",  [(leg_call DataRegs:$addr)]>;

//def : Pattern<(i32 (load_sym tglobaladdr:$addr)),  [(MOVi32 $addr)]>;

//def : Pat<(add DataRegs:$src, (TriCoreWrapper tglobaladdr :$src2)),
//					(ADDrc DataRegs:$src, tglobaladdr:$src2)>;  

//def : Pattern<(i32 (load_sym tglobaladdr:$addr)),  [(MOVi32 $addr)]>;
	
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
// 64 bit Compare Instructions
//===----------------------------------------------------------------------===//

multiclass LOGIC_COMPARE<bits<7> op_s, bits<7> op_u, 
									string asmstring,  PatLeaf PF>
{
	let Constraints="$d = $fsrc" in {
		
		def Urc : RC<0x8B, op_u,
		(outs DataRegs:$d),
		(ins DataRegs:$fsrc, DataRegs:$s1, u9imm:$const9),
		!strconcat(asmstring, ".u $d, $s1, $const9"),
		[( set DataRegs:$d, 
				(TriCorelogiccmp DataRegs:$fsrc, DataRegs:$s1, immZExt9:$const9, PF))]>;

		def rc : RC<0x8B, op_s,
		(outs DataRegs:$d),
		(ins DataRegs:$fsrc, DataRegs:$s1, s9imm:$const9),
		!strconcat(asmstring, " $d, $s1, $const9"),
		[( set DataRegs:$d, 
				(TriCorelogiccmp DataRegs:$fsrc, DataRegs:$s1, immSExt9:$const9, PF))]>;

	}
}

//class LC_RR <bits<8> op2, string asmstring, PatLeaf PF> 
//			:RR<0x0B, op2,
//			 (outs DataRegs:$d),
//			 (ins DataRegs:$fsrc, DataRegs:$s1, DataRegs:$s2),
//			 !strconcat(asmstring, " $d, $s1, $s2"),
//			 [(set DataRegs:$d, (TriCorelogiccmp DataRegs:$fsrc, 
//				 DataRegs:$s1, DataRegs:$s2, PF))]> {
//	
//	let Constraints="$d = $fsrc";
//	
//}
//
//class LC_RC <bits<7> op2, string asmstring, PatLeaf PF> 
//			:RC<0x8B, op2,
//				(outs DataRegs:$d),
//				(ins DataRegs:$fsrc, DataRegs:$s1, s9imm:$const9),
//				!strconcat(asmstring, " $d, $s1, $const9"),
//				[( set DataRegs:$d, 
//				(TriCorelogiccmp DataRegs:$fsrc, DataRegs:$s1, immSExt9:$const9, PF))]>
//{
//	
//	let Constraints="$d = $fsrc";
//	
//}
//

defm AND_LT : LOGIC_COMPARE<0x22, 0x23, "and.lt", TriCore_LOGIC_AND_LT>;
defm AND_GE : LOGIC_COMPARE<0x24, 0x25, "and.ge", TriCore_LOGIC_AND_GE>;
defm OR_LT  : LOGIC_COMPARE<0x29, 0x2A, "or.lt",  TriCore_LOGIC_OR_LT>;
defm OR_GE  : LOGIC_COMPARE<0x2B, 0x2C, "or.ge",  TriCore_LOGIC_OR_GE>;
//
//def AND_GE_Urr : LC_RR<0x25, "and.ge.u", TriCore_LOGIC_AND_GE>;
//def AND_LT_Urr : LC_RR<0x23, "and.lt.u", TriCore_LOGIC_AND_LT>;
//def AND_EQrr   : LC_RR<0x20, "and.eq"  , TriCore_LOGIC_AND_EQ>;
//def AND_EQrc   : LC_RC<0x20, "and.eq"  , TriCore_LOGIC_AND_EQ>;
//def OR_LTrr 	 : LC_RR<0x29, "or.lt"   , TriCore_LOGIC_OR_LT>;
//def OR_GErr 	 : LC_RR<0x2B, "or.ge"   , TriCore_LOGIC_OR_GE>;
//def OR_NErr 	 : LC_RR<0x28, "or.ne"   , TriCore_LOGIC_OR_NE>;
//def OR_NErc 	 : LC_RC<0x28, "or.ne"   , TriCore_LOGIC_OR_NE>;

let Constraints="$d = $fsrc" in {
def AND_GE_Urr : RR<0x0B, 0x25,
								 (outs DataRegs:$d),
								 (ins DataRegs:$fsrc, DataRegs:$s1, DataRegs:$s2),
								 "and.ge.u $d, $s1, $s2",
								 [( set DataRegs:$d, (TriCorelogiccmp DataRegs:$fsrc, 
										 DataRegs:$s1, DataRegs:$s2, (i32 TriCore_LOGIC_AND_GE)))]>;

def AND_LT_Urr : RR<0x0B, 0x23,
								 (outs DataRegs:$d),
								 (ins DataRegs:$fsrc, DataRegs:$s1, DataRegs:$s2),
								 "and.lt.u $d, $s1, $s2",
								 [( set DataRegs:$d, (TriCorelogiccmp DataRegs:$fsrc, 
										 DataRegs:$s1, DataRegs:$s2, (i32 TriCore_LOGIC_AND_LT)))]>;

def AND_EQrr : RR<0x0B, 0x20,
								 (outs DataRegs:$d),
								 (ins DataRegs:$fsrc, DataRegs:$s1, DataRegs:$s2),
								 "and.eq $d, $s1, $s2",
								 [( set DataRegs:$d, (TriCorelogiccmp DataRegs:$fsrc, 
										 DataRegs:$s1, DataRegs:$s2, (i32 TriCore_LOGIC_AND_EQ)))]>;

def AND_EQrc : RC<0x8B, 0x20,
								 (outs DataRegs:$d),
								 (ins DataRegs:$fsrc, DataRegs:$s1, s9imm:$const9),
								 "and.eq $d, $s1, $const9",
								 [( set DataRegs:$d, (TriCorelogiccmp DataRegs:$fsrc, 
										 DataRegs:$s1, immSExt9:$const9, (i32 TriCore_LOGIC_AND_EQ)))]>;

def OR_LTrr : RR<0x0B, 0x29,
								 (outs DataRegs:$d),
								 (ins DataRegs:$fsrc, DataRegs:$s1, DataRegs:$s2),
								 "or.lt $d, $s1, $s2",
								 [( set DataRegs:$d, (TriCorelogiccmp DataRegs:$fsrc, 
										 DataRegs:$s1, DataRegs:$s2, (i32 TriCore_LOGIC_OR_LT)))]>;

def OR_GErr : RR<0x0B, 0x2B,
								 (outs DataRegs:$d),
								 (ins DataRegs:$fsrc, DataRegs:$s1, DataRegs:$s2),
								 "or.ge $d, $s1, $s2",
								 [( set DataRegs:$d, (TriCorelogiccmp DataRegs:$fsrc, 
										 DataRegs:$s1, DataRegs:$s2, (i32 TriCore_LOGIC_OR_GE)))]>;

def OR_NErr : RR<0x0B, 0x28,
								 (outs DataRegs:$d),
								 (ins DataRegs:$fsrc, DataRegs:$s1, DataRegs:$s2),
								 "or.ne $d, $s1, $s2",
								 [( set DataRegs:$d, (TriCorelogiccmp DataRegs:$fsrc, 
										 DataRegs:$s1, DataRegs:$s2, (i32 TriCore_LOGIC_OR_NE)))]>;

def OR_NErc : RC<0x8B, 0x28,
								 (outs DataRegs:$d),
								 (ins DataRegs:$fsrc, DataRegs:$s1, s9imm:$const9),
								 "or.ne $d, $s1, $const9",
								 [( set DataRegs:$d, (TriCorelogiccmp DataRegs:$fsrc, 
										 DataRegs:$s1, immSExt9:$const9, (i32 TriCore_LOGIC_OR_NE)))]>;
} // let Constraints="$d = $fsrc"


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
  def Select8  : Pseudo<(outs DataRegs:$dst),
											  (ins DataRegs:$src, DataRegs:$src2, i32imm:$cc, DataRegs:$src1 ),
											  "# Select8 PSEUDO",
											 [(set DataRegs:$dst,
											 (TriCoreselectcc DataRegs:$src, DataRegs:$src2, imm:$cc, DataRegs:$src1))]>;
}

//===----------------------------------------------------------------------===//
// Pseudo Instructions
//===----------------------------------------------------------------------===//

let Defs = [A10], Uses = [A10] in {
def ADJCALLSTACKDOWN : Pseudo<(outs), (ins i32imm:$amt),
                                    "# ADJCALLSTACKDOWN $amt",
                                    [(callseq_start timm:$amt)]>;
def ADJCALLSTACKUP   : Pseudo<(outs), (ins i32imm:$amt1, i32imm:$amt2),
                                    "# ADJCALLSTACKUP $amt1",
                                    [(callseq_end timm:$amt1, timm:$amt2)]>;
}

//===----------------------------------------------------------------------===//
// Patterns
//===----------------------------------------------------------------------===//
// Lower 32 bits of a 64-bit word 
def LO32 : SDNodeXForm<imm, [{
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

def INVERT_VAL : SDNodeXForm<imm, [{
	return CurDAG->getTargetConstant(-N->getZExtValue(), SDLoc(N), MVT::i32);
}]>;


def SHIFTAMT : SDNodeXForm<imm, [{
	return CurDAG->getTargetConstant(N->getZExtValue() - 32, SDLoc(N), MVT::i32);
}]>;

def SHIFTAMT_POS : SDNodeXForm<imm, [{
	return CurDAG->getTargetConstant((32 - N->getZExtValue()), SDLoc(N), MVT::i32);
}]>;

def SHIFTAMT_NEG : SDNodeXForm<imm, [{
	return CurDAG->getTargetConstant(-(N->getZExtValue() - 32), SDLoc(N), MVT::i32);
}]>;

def imm32_64 : PatLeaf<(imm),
[{
  uint64_t val = N->getZExtValue();
  return val >= 32 && val < 64;
}]>;

def imm0_31 : PatLeaf<(imm),
[{
  uint64_t val = N->getZExtValue();
  return val > 0 && val < 32;
}]>;

// TODO: Also write a pattern when we have a zero shift
def : Pat<(shl ExtRegs:$src, (i32 imm32_64:$amt)),
          (INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
          		           (SHrc (EXTRACT_SUBREG ExtRegs:$src, subreg_even), 
          		          		 (SHIFTAMT (imm32_64:$amt))), subreg_odd)),
          		           (MOVrlc (i32 0)), subreg_even)>;

def : Pat<(shl ExtRegs:$src, (i32 imm0_31:$amt)),
          (INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
          		           (DEXTRrrpw (EXTRACT_SUBREG ExtRegs:$src, subreg_odd), 
          		          		 (EXTRACT_SUBREG ExtRegs:$src, subreg_even), 
														 	 (i32 imm0_31:$amt)), subreg_odd)),
          									(SHrc (EXTRACT_SUBREG ExtRegs:$src, subreg_even), 
																 ( i32 imm0_31:$amt)), subreg_even)>;

def : Pat<(srl ExtRegs:$src, (i32 imm0_31:$amt)),
          (INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
          		           (DEXTRrrpw (EXTRACT_SUBREG ExtRegs:$src, subreg_odd), 
          		          		 (EXTRACT_SUBREG ExtRegs:$src, subreg_even), 
														 	 (SHIFTAMT_POS (imm0_31:$amt))), subreg_even)),
          									(SHrc (EXTRACT_SUBREG ExtRegs:$src, subreg_odd), 
																 (INVERT_VAL imm0_31:$amt)), subreg_odd)>;

def : Pat<(srl ExtRegs:$src, (i32 imm32_64:$amt)),
          (INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
          		           (SHrc (EXTRACT_SUBREG ExtRegs:$src, subreg_odd), 
          		          		 (SHIFTAMT_NEG (imm32_64:$amt))), subreg_even)),
          		           (MOVrlc (i32 0)), subreg_odd)>;

def : Pat<(sra ExtRegs:$src, (i32 imm32_64:$amt)),
          (INSERT_SUBREG (i64 (IMPLICIT_DEF)),  
           (SHArc ( EXTRACT_SUBREG (INSERT_SUBREG (i64 (IMPLICIT_DEF)) ,
          		 (SHArc (EXTRACT_SUBREG ExtRegs:$src, subreg_odd), 
          				 (SHIFTAMT_NEG (imm32_64:$amt))), subreg_even), subreg_even) 
           , (i32 -31)), subreg_odd)>;

def : Pat<(sra ExtRegs:$src, (i32 imm0_31:$amt)),
          (INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
          		           (DEXTRrrpw (EXTRACT_SUBREG ExtRegs:$src, subreg_odd), 
          		          		 (EXTRACT_SUBREG ExtRegs:$src, subreg_even), 
														 	 (SHIFTAMT_POS (imm0_31:$amt))), subreg_even)),
          									(SHArc (EXTRACT_SUBREG ExtRegs:$src, subreg_odd), 
																 (INVERT_VAL imm0_31:$amt)), subreg_odd)>;

def : Pat<(shl DataRegs:$src, (i32 0)),
					(MOVrr DataRegs:$src)>;

// This extracts the even register from an extended register
def : Pat<(i32 (trunc ExtRegs:$src)), 
					(EXTRACT_SUBREG ExtRegs:$src, subreg_even)>;

// sext
def : Pat<(sext DataRegs:$src),
					(INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
							 (i32 DataRegs:$src), subreg_even)),
							 (SHArc (i32 DataRegs:$src), (i32 -31)), subreg_odd)>;

// sext_inreg for i16
def : Pat<(sext_inreg DataRegs:$src, i16),
          (MOVrr (i32 DataRegs:$src))>;

// sext_inreg for i8
def : Pat<(sext_inreg DataRegs:$src, i8),
          (MOVrr (i32 DataRegs:$src))>;

// sext_inreg from i8 to i64
def : Pat<(sext_inreg ExtRegs:$src, i8),
		(INSERT_SUBREG (i64 (IMPLICIT_DEF)),  
				(SHArc ( EXTRACT_SUBREG (INSERT_SUBREG (i64 (IMPLICIT_DEF)) ,
						( EXTRrrpw (EXTRACT_SUBREG ExtRegs:$src, subreg_even), 
								(i32 0), (i32 8) ), subreg_even), subreg_even) 
						, (i32 -31)), subreg_odd)>;	

// sext_inreg from i16 to i64
def : Pat<(sext_inreg ExtRegs:$src, i16),
		(INSERT_SUBREG (i64 (IMPLICIT_DEF)),  
				(SHArc ( EXTRACT_SUBREG (INSERT_SUBREG (i64 (IMPLICIT_DEF)) ,
						( EXTRrrpw (EXTRACT_SUBREG ExtRegs:$src, subreg_even), 
								(i32 0), (i32 16) ), subreg_even), subreg_even) 
						, (i32 -31)), subreg_odd)>;	

// anyext
def : Pat<(anyext DataRegs:$src),
		(INSERT_SUBREG (i64 (IMPLICIT_DEF)),  
				(SHArc ( EXTRACT_SUBREG (INSERT_SUBREG (i64 (IMPLICIT_DEF)) ,
						(i32 DataRegs:$src), subreg_even), subreg_even) 
						, (i32 -31)), subreg_odd)>;

// zext
def : Pat<(zext DataRegs:$src),
		(INSERT_SUBREG (i64 (IMPLICIT_DEF)),  
				(SHArc ( EXTRACT_SUBREG (INSERT_SUBREG (i64 (IMPLICIT_DEF)) ,
						(i32 DataRegs:$src), subreg_even), subreg_even) 
						, (i32 -31)), subreg_odd)>;		

// This extracts the odd register from an extended register
// odd_reg = (Extended Register >> 32)
def : Pat<(i32 (trunc (srl ExtRegs:$src, (i32 32)))), 
					(EXTRACT_SUBREG ExtRegs:$src, subreg_odd)>;

def : Pat<(i64 (sextloadi32 addr:$offset)),
		(INSERT_SUBREG (i64 (IMPLICIT_DEF)),  
		           (SHArc ( EXTRACT_SUBREG (INSERT_SUBREG (i64 (IMPLICIT_DEF)) ,
		          		 (LDWbo addr:$offset), subreg_even), subreg_even) 
		           , (i32 -31)), subreg_odd)>;	

def : Pat<(i64 (zextloadi32 addr:$offset)),
		(INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
		          		           (LDWbo addr:$offset), subreg_even)),
		          		           (MOVrlc 0), subreg_odd)>;

def : Pat<(i64 (sextloadi16 addr:$offset)),
		(INSERT_SUBREG (i64 (IMPLICIT_DEF)),  
		           (SHArc ( EXTRACT_SUBREG (INSERT_SUBREG (i64 (IMPLICIT_DEF)) ,
		          		 ( EXTRrrpw (LDHbo addr:$offset), 
		          				 (i32 0), (i32 16) ), subreg_even), subreg_even) 
		           , (i32 -31)), subreg_odd)>;	

def : Pat<(i64 (zextloadi16 addr:$offset)),
		(INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
		          		           (LDWbo addr:$offset), subreg_even)),
		          		           (MOVrlc 0), subreg_odd)>;


def : Pat<(i64 (sextloadi8 addr:$offset)),
		(INSERT_SUBREG (i64 (IMPLICIT_DEF)),  
		           (SHArc ( EXTRACT_SUBREG (INSERT_SUBREG (i64 (IMPLICIT_DEF)) ,
		          		 ( EXTRrrpw (LDBbo addr:$offset), 
		          				 (i32 0), (i32 8) ), subreg_even), subreg_even) 
		           , (i32 -31)), subreg_odd)>;	

def : Pat<(i64 (zextloadi8 addr:$offset)),
		(INSERT_SUBREG( i64 (INSERT_SUBREG (i64 (IMPLICIT_DEF)), 
		          		           (LDBUbo addr:$offset), subreg_even)),
		          		           (MOVrlc 0), subreg_odd)>;

		