//==-- TriCoreRegisterInfo.td - TriCore Register defs ------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

//include "llvm/Target/Target.td"  // Include for debuging purpose only
//===----------------------------------------------------------------------===//
//  Declarations that describe the TriCore register file
//===----------------------------------------------------------------------===//

class TriCoreReg<string n> : Register<n> {
	field bits<4> Num;
	let Namespace = "TriCore";
}

// General Purpose Data Registers
class TriCoreDataReg<bits<4> num, string n> : TriCoreReg<n> {
	let Num = num;
}

// General Purpose Address Registers
class TriCoreAdrReg<bits<4> num, string n> : TriCoreReg<n> {
	let Num = num;
}

// Program Status Register
class TriCorePSReg<bits<4> num, string n> : TriCoreReg<n> {
	let Num = num;
}

class TriCoreRegWithSubregs<bits<4> num, string n, list<Register> subregs>
: RegisterWithSubRegs<n, subregs> {
	field bits<4> Num = num;
	let Namespace = "TriCore";
}

//===----------------------------------------------------------------------===//
//@Registers
//===----------------------------------------------------------------------===//
// The register string, such as "D0" or "D13" will show on "llvm-objdump -d"


//16 Registers from the D Register banks
//16 Registers from the A Register banks
foreach i = 0-15 in {
  def D#i : TriCoreDataReg<i, "D"#i>, DwarfRegNum<[#i]>;
  def A#i : TriCoreDataReg<i, "A"#i>;
}


def subreg_lo : SubRegIndex<16> {let Namespace = "TriCore";}
def subreg_hi : SubRegIndex<16> {let Namespace = "TriCore";}

//Extended 64-bit registers
//let SubRegIndices = [subreg_lo, subreg_hi] in {
//	def E0 : TriCoreRegWithSubregs<0, "e2", [D0,D1] >, DwarfRegNum<[32]>;
//	def E2 : TriCoreRegWithSubregs<2, "e3", [D2,D3] >, DwarfRegNum<[33]>;
//	def E4 : TriCoreRegWithSubregs<4, "e4", [D4,D5] >, DwarfRegNum<[34]>;
//	def E6 : TriCoreRegWithSubregs<6, "e6", [D6,D7] >, DwarfRegNum<[35]>;
//	def E8 : TriCoreRegWithSubregs<8, "e8", [D8,D9] >, DwarfRegNum<[36]>;
//	def E10 : TriCoreRegWithSubregs<10, "e10", [D10,D11] >, DwarfRegNum<[37]>;
//	def E12 : TriCoreRegWithSubregs<12, "e12", [D12,D13] >, DwarfRegNum<[38]>;
//	def E14 : TriCoreRegWithSubregs<14, "e14", [D14,D15] >, DwarfRegNum<[39]>;
//
//}


//Program Status Information Registers
def PSW : TriCorePSReg<0, "PSW">, DwarfRegNum<[40]>;
def PCXI : TriCorePSReg<1, "PCXI">, DwarfRegNum<[41]>;
def PC : TriCorePSReg<2, "PC">, DwarfRegNum<[42]>;



//===----------------------------------------------------------------------===//
//@Register Classes
//===----------------------------------------------------------------------===//

def DataRegs : RegisterClass<"TriCore", [i32], 32, (add
		// Implict Data
		D15,
		// Others
		D0, D1, D2, D3,
		D4, D5, D6, D7,
		D8, D9, D10, D11,
		D12, D13, D14)>;

def AddrRegs : RegisterClass<"TriCore", [i32], 32, (add
		// Global Address
		A0, A1, A8, A9,
		// Stack Pointer
		A10,
		// Return Address
		A11,
		// Implicit Address
		A15,
		// Others
		A2, A3, A4, A5, A6,
		A7, A12, A13, A14)>;

def AddrRegsOthers : RegisterClass<"TriCore", [i32], 32, (add
		// Others
		A2, A3, A4, A5, A6,
		A7, A12, A13, A14)>;

//def ExtRegs : RegisterClass<"TriCore", [i64], 64, (add
//		E0, E2, E4,
//		E6, E8, E10,
//		E12, E14)>;

def PSRegs : RegisterClass<"TriCore", [i32], 32, (add
		PSW, PCXI, PC)>;
