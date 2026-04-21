
package decoder


import "core:fmt"


Reg64 :: enum {
	x0,  x1,  x2,  x3,  x4,  x5,  x6,  x7,
	x8,  x9,  x10, x11, x12, x13, x14, x15,
	x16, x17, x18, x19, x20, x21, x22, x23,
	x24, x25, x26, x27, x28, x29, x30, x31,
	f0,  f1,  f2,   f3,  f4,  f5,  f6,  f7,
	f8,  f9,  f10, f11, f12, f13, f14, f15,
	f16, f17, f18, f19, f20, f21, f22, f23,
	f24, f25, f26, f27, f28, f29, f30, f31,
	pc,
}


ILLEGAL :: struct {
}


C_ADDI4SPN :: struct {
	rd:		Reg64,
	uimm:	u64le
}


C_FLD :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	uimm:	u64le
}


C_LW :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	uimm:	u64le
}


IDec :: union {
	ILLEGAL,
	C_ADDI4SPN,
	C_FLD,
	C_LW,
//	C_LD,
//	C_LBU,
//	C_LHU,
//	C_LH,
//	C_SB,
//	C_SH,
//	C_FSD,
//	C_SW,
//	C_SD,
//	C_NOP,
//	C_ADDI,
//	C_ADDIW,
//	C_LI,
//	C_ADDI16SP,
//	C_LUI,
//	C_SRLI,
//	C_SRAI,
//	C_ANDI,
//	C_SUB,
//	C_XOR,
//	C_OR,
//	C_AND,
//	C_SUBW,
//	C_ADDW,
//	C_MUL,
//	C_ZEXT_B,
//	C_SEXT_B,
//	C_ZEXT_H,
//	C_SEXT_H,
//	C_ZEXT_W,
//	C_NOT,
//	C_J,
//	C_BEQZ,
//	C_BNEZ,
//	C_SLLI,
//	C_FLDSP,
//	C_LDSP,
//	C_JR,
//	C_MV,
//	C_EBREAK,
//	C_JALR,
//	C_ADD,
//	C_FSDSP,
//	C_SWSP,
//	C_SDSP,
//	LB,
//	LH,
//	LW,
//	LD,
//	LBU,
//	LHU,
//	SB,
//	SH,
//	SW,
//	SD,
//	FMADD_S,
//	FMADD_D,
//	BEQ,
//	BNE,
//	BLT,
//	BGE,
//	BLTU,
//	BGEU,
//	FLW,
//	FLD,
//	FSW,
//	FSD,
//	FMSUB_S,
//	FMSUB_D,
//	JALR,
//	FNMSUB_S,
//	FNMSUB_D,
//	FENCE,
//	FENCE_TSO,
//	PAUSE,
//	FENCE_I,
//	AMOADD_W,
//	AMOSWAP_W,
//	LR_W,
//	SC_W,
//	AMOXOR_W,
//	AMOCAS_W,
//	AMOOR_W,
//	AMOAND_W,
//	AMOMIN_W,
//	AMOMAX_W,
//	AMOMINU_W,
//	AMOMAXU_W,
//	AMOADD_D,
//	AMOSWAP_D,
//	LR_D,
//	SC_D,
//	AMOXOR_D,
//	AMOCAS_D,
//	AMOOR_D,
//	AMOAND_D,
//	AMOMIN_D,
//	AMOMAX_D,
//	AMOMINU_D,
//	AMOMAXU_D,
//	AMOCAS_Q,
//	FNMADD_S,
//	FNMADD_D,
//	JAL,
//	NOP,
//	ADDI,
//	SLLI,
//	BSETI,
//	BCLRI,
//	BINVI,
//	CLZ,
//	CTZ,
//	CPOP,
//	SEXT_B,
//	SEXT_H,
//	SLTI,
//	SLTIU,
//	XORI,
//	SRLI,
//	ORC_B,
//	SRAI,
//	BEXTI,
//	RORI,
//	BREV8,
//	REV8,
//	ORI,
//	ANDI,
//	ADD,
//	MUL,
//	SUB,
//	SLL,
//	MULH,
//	CLMUL,
//	BSET,
//	BCLR,
//	ROL,
//	BINV,
//	SLT,
//	MULHSU,
//	CLMULR,
//	SH1ADD,
//	XPERM_N,
//	SLTU,
//	MULHU,
//	CLMULH,
//	XOR,
//	DIV,
//	PACK,
//	MIN,
//	SH2ADD,
//	XPERM_B,
//	XNOR,
//	SRL,
//	DIVU,
//	MINU,
//	CZERO_EQZ,
//	SRA,
//	BEXT,
//	ROR,
//	OR,
//	REM,
//	MAX,
//	SH3ADD,
//	ORN,
//	AND,
//	REMU,
//	PACKH,
//	MAXU,
//	CZERO_NEZ,
//	ANDN,
//	FADD_S,
//	FADD_D,
//	FSUB_S,
//	FSUB_D,
//	FMUL_S,
//	FMUL_D,
//	FDIV_S,
//	FDIV_D,
//	FSGNJ_S,
//	FSGNJN_S,
//	FSGNJX_S,
//	FSGNJ_D,
//	FSGNJN_D,
//	FSGNJX_D,
//	FMIN_S,
//	FMAX_S,
//	FMINM_S,
//	FMAXM_S,
//	FMIN_D,
//	FMAX_D,
//	FMINM_D,
//	FMAXM_D,
//	FCVT_S_D,
//	FROUND_S,
//	FROUNDNX_S,
//	FCVT_D_S,
//	FROUND_D,
//	FROUNDNX_D,
//	FSQRT_S,
//	FSQRT_D,
//	FLE_S,
//	FLT_S,
//	FEQ_S,
//	FLEQ_S,
//	FLTQ_S,
//	FLE_D,
//	FLT_D,
//	FEQ_D,
//	FLEQ_D,
//	FLTQ_D,
//	FCVT_W_S,
//	FCVT_WU_S,
//	FCVT_L_S,
//	FCVT_LU_S,
//	FCVT_W_D,
//	FCVT_WU_D,
//	FCVT_L_D,
//	FCVT_LU_D,
//	FCVTMOD_W_D,
//	FCVT_S_W,
//	FCVT_S_WU,
//	FCVT_S_L,
//	FCVT_S_LU,
//	FCVT_D_W,
//	FCVT_D_WU,
//	FCVT_D_L,
//	FCVT_D_LU,
//	FMV_X_W,
//	FCLASS_S,
//	FMV_X_D,
//	FCLASS_D,
//	FMV_W_X,
//	FLI_S,
//	FMV_D_X,
//	FLI_D,
//	ECALL,
//	EBREAK,
//	WRS_NTO,
//	WRS_STO,
//	CSRRW,
//	CSRRS,
//	CSRRC,
//	CSRRWI,
//	CSRRSI,
//	CSRRCI,
//	AUIPC,
//	LUI,
//	ADDIW,
//	SLLIW,
//	SLLI_UW,
//	CLZW,
//	CTZW,
//	CPOPW,
//	SRLIW,
//	SRAIW,
//	RORIW,
//	ADDW,
//	MULW,
//	ADD_UW,
//	SUBW,
//	SLLW,
//	ROLW,
//	SH1ADD_UW,
//	DIVW,
//	ZEXT_H,
//	SH2ADD_UW,
//	SRLW,
//	DIVUW,
//	SRAW,
//	RORW,
//	REMW,
//	SH3ADD_UW,
//	REMUW,
}


I16_Base :: bit_field u16le {
	opc:	u8		| 2,
	pad:	u16le	| 11,
	funct3:	u8		| 3
}


I32_Base :: bit_field u32le {
	opc:	u8		| 7,
	pad1:	u8		| 5,
	funct3:	u8		| 3,
	pad2:	u16le	| 10,
	funct7:	u8		| 7
}


handle_cq0 :: proc(ie: I16_Base) -> IDec {
	switch ie.funct3 {
	case 0x0:
		ADDI4SPN_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rd_r:		u8 | 3,
			uimm3:		u8 | 1,
			uimm2:		u8 | 1,
			uimm6to9:	u8 | 4,
			uimm4to5:	u8 | 2,
			funct3:		u8 | 3
		}

		ie := transmute(ADDI4SPN_ENC) ie

		if	ie.rd_r  == 0 || ie.uimm2    == 0 ||
			ie.uimm3 == 0 || ie.uimm6to9 == 0 || ie.uimm4to5 == 0 {
			return ILLEGAL{}
		}

		UIMM_DEC :: bit_field u16le {
			uimm0to1:	u8 | 2,
			uimm2:		u8 | 1,
			uimm3:		u8 | 1,
			uimm4to5:	u8 | 2,
			uimm6to9:	u8 | 4
		}

		return C_ADDI4SPN{
			rd = Reg64(ie.rd_r) + Reg64.x7,
			uimm = u64le(UIMM_DEC{
				uimm0to1	= 0,
				uimm2		= ie.uimm2,
				uimm3		= ie.uimm3,
				uimm4to5	= ie.uimm4to5,
				uimm6to9	= ie.uimm6to9
			})
		}

	case 0x1:
		C_FLD_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rd_r:		u8 | 3,
			uimm6to7:	u8 | 2,
			rs1_r:		u8 | 3,
			uimm3to5:	u8 | 3,
			funct3:		u8 | 3
		}

		ie := transmute(C_FLD_ENC) ie

		UIMM_DEC :: bit_field u8 {
			uimm0to2:	u8 | 3,
			uimm3to5:	u8 | 3,
			uimm6to7:	u8 | 2
		}

		return C_FLD{
			rd		= Reg64(ie.rd_r) + Reg64.f7,
			rs1		= Reg64(ie.rs1_r) + Reg64.f7,
			uimm	= u64le(UIMM_DEC{
				uimm0to2	= 0,
				uimm3to5	= ie.uimm3to5,
				uimm6to7	= ie.uimm6to7
			})
		}

	case 0x2:
		C_LW_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rd_r:		u8 | 3,
			uimm6:		u8 | 1,
			uimm2:		u8 | 1,
			rs1_r:		u8 | 3,
			uimm3to5:	u8 | 3,
			funct3:		u8 | 3
		}

		ie := transmute(C_LW_ENC) ie

		UIMM_DEC :: bit_field u8 {
			uimm0to1:	u8 | 2,
			uimm2:		u8 | 1,
			uimm3to5:	u8 | 3,
			uimm6:		u8 | 1
		}

		return C_LW{
			rd		= Reg64(ie.rd_r) + Reg64.x7,
			rs1		= Reg64(ie.rs1_r) + Reg64.x7,
			uimm	= u64le(UIMM_DEC{
				uimm0to1	= 0,
				uimm2		= ie.uimm2,
				uimm3to5	= ie.uimm3to5,
				uimm6		= ie.uimm6
			})
		}

//	case 0x3:
//		ie := transmute(I16_CL_CS) ie
//
//		id.type	= IType.C_LD
//		id.uimm	= u64le(ie.uimm2 << 3 | ie.uimm1 << 6)
//		id.rd	= Reg64(ie.reg1) + Reg64.x7
//		id.rs1	= Reg64(ie.reg2) + Reg64.x7
//
//		return
//
//	case 0x4:
//		ie := transmute(I16_CL_CS) ie
//
//		switch ie.uimm2 {
//		case 0b000:
//			id.type	= IType.C_LBU
//			id.uimm	= u64le(
//				(ie.uimm1 & 0b10) >> 1 |
//				(ie.uimm1 & 0b01) << 1
//			)
//			id.rd	= Reg64(ie.reg1) + Reg64.x7
//			id.rs1	= Reg64(ie.reg2) + Reg64.x7
//
//			return
//
//		case 0b001:
//			switch (ie.uimm1 & 0b10) >> 1 {
//			case 0:
//				id.type	= IType.C_LHU
//				id.uimm	= u64le((ie.uimm1 & 0b01) << 1)
//				id.rd	= Reg64(ie.reg1) + Reg64.x7
//				id.rs1	= Reg64(ie.reg2) + Reg64.x7
//
//				return
//				
//			case 1:
//				id.type	= IType.C_LH
//				id.uimm	= u64le((ie.uimm1 & 0b01) << 1)
//				id.rd	= Reg64(ie.reg1) + Reg64.x7
//				id.rs1	= Reg64(ie.reg2) + Reg64.x7
//
//				return
//			}
//
//		case 0b010:
//			id.type	= IType.C_SB
//			id.uimm	= u64le(
//				(ie.uimm1 & 0b10) >> 1 |
//				(ie.uimm1 & 0b01) << 1
//			)
//			id.rs2	= Reg64(ie.reg1) + Reg64.x7
//			id.rs1	= Reg64(ie.reg2) + Reg64.x7
//
//			return
//			
//		case 0b011:
//			if (ie.uimm1 & 0b10) != 0 do return
//
//			id.type	= IType.C_SH
//			id.uimm	= u64le((ie.uimm1 & 0b01) << 1)
//			id.rs2	= Reg64(ie.reg1) + Reg64.x7
//			id.rs1	= Reg64(ie.reg2) + Reg64.x7
//
//			return
//		}
//	case 0x5:
//	case 0x6:
//	case 0x7:
	}

	return ILLEGAL{}
}


handle_cq1 :: proc(ie: I16_Base) -> IDec {
	return ILLEGAL{}
}


handle_cq2 :: proc(ie: I16_Base) -> IDec {
	return ILLEGAL{}
}


handle_i :: proc(ie: I32_Base) -> IDec {
	return ILLEGAL{}
}


decode_insn :: proc(memory: [^]u8) -> IDec {
	switch memory[0] & 0b11 {
	case 0b00:
		fmt.println("OP: Q0")

		ie := transmute(I16_Base) (cast(^u16le) &memory[0])^

		if	ie.opc == 0 && ie.funct3 == 0 && ie.pad == 0 {
			return ILLEGAL{}
		}

		return handle_cq0(ie)

	case 0b01:
		fmt.println("OP: 16b Q1")

		ie := transmute(I16_Base) (cast(^u16le) &memory[0])^

		return handle_cq1(ie)

	case 0b10:
		fmt.println("OP: 16b Q2")

		ie := transmute(I16_Base) (cast(^u16le) &memory[0])^

		return handle_cq2(ie)

	case 0b11:
		fmt.println("OP: 32b I")

		ie := transmute(I32_Base) (cast(^u32le) &memory[0])^

		return handle_i(ie)
	}

	return ILLEGAL{}
}


main :: proc() {
	memory: [128]u8 = 0
	w16: ^u16le
	w32: ^u32le


	w16 = cast(^u16le)&memory[0]
	w16^ = 0b010_000_001_01_001_00					// 'C.LW x8 2(x7)'
	w32 = cast(^u32le)&memory[2]
	w32^ = 0b0000001_00011_00101_000_00011_0110011	// 'MUL x3 x5 x3'
	w32 = cast(^u32le)&memory[6]
	w32^ = 0b0000001_00011_00101_000_00011_0110011	// 'MUL x3 x5 x3'


	fmt.println(decode_insn(raw_data(memory[0:])))
	fmt.println(decode_insn(raw_data(memory[2:])))
	fmt.println(decode_insn(raw_data(memory[6:])))
}

