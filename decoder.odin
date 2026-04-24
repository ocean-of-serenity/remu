
package decoder


import "core:fmt"
import "core:reflect"


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


C_LD :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	uimm:	u64le
}


C_LBU :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	uimm:	u64le
}


C_LHU :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	uimm:	u64le
}


C_LH :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	uimm:	u64le
}


C_SB :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	uimm:	u64le
}


C_SH :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	uimm:	u64le
}


C_FSD :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	uimm:	u64le
}


C_SW :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	uimm:	u64le
}


C_SD :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	uimm:	u64le
}


BEQ :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	imm:	i64le
}


BNE :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	imm:	i64le
}


BLT :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	imm:	i64le
}


BGE :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	imm:	i64le
}


BLTU :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	imm:	i64le
}


BGEU :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	imm:	i64le
}


JALR :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	imm:	i64le
}


JAL :: struct {
	rd:		Reg64,
	imm:	i64le
}


NOP :: struct{
}


ADDI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	imm:	i64le
}


SLLI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	shamt:	u64le,
}


BSETI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	idx:	u64le,
}


BCLRI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	idx:	u64le,
}


CLZ :: struct{
	rd:		Reg64,
	rs1:	Reg64
}


CTZ :: struct{
	rd:		Reg64,
	rs1:	Reg64
}


CPOP :: struct{
	rd:		Reg64,
	rs1:	Reg64
}


SEXT_B :: struct{
	rd:		Reg64,
	rs1:	Reg64
}


SEXT_H :: struct{
	rd:		Reg64,
	rs1:	Reg64
}


BINVI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	idx:	u64le,
}


SLTI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	imm:	i64le,
}


SLTIU :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	uimm:	u64le,
}


XORI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	imm:	i64le,
}


SRLI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	shamt:	u64le,
}


ORC_B :: struct{
	rd:		Reg64,
	rs1:	Reg64
}


SRAI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	shamt:	u64le,
}


BEXTI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	idx:	u64le,
}


RORI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	shamt:	u64le,
}


BREV8 :: struct{
	rd:		Reg64,
	rs1:	Reg64
}


REV8 :: struct{
	rd:		Reg64,
	rs1:	Reg64
}


ORI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	imm:	i64le,
}


ANDI :: struct{
	rd:		Reg64,
	rs1:	Reg64,
	imm:	i64le,
}


ADD :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


MUL :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


SUB :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


SLL :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


MULH :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


CLMUL :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


BSET :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


BCLR :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


ROL :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


BINV :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


SLT :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


MULHSU :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


CLMULR :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


SH1ADD :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


XPERM_N :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


SLTU :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


MULHU :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


CLMULH :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


XOR :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


DIV :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


PACK :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


MIN :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


SH2ADD :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


XPERM_B :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


XNOR :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


SRL :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


DIVU :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


MINU :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


CZERO_EQZ :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


SRA :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


BEXT :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


ROR :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


OR :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


REM :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


MAX :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


SH3ADD :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


ORN :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


AND :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


REMU :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


PACKH :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


MAXU :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


CZERO_NEZ :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


ANDN :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}


AUIPC :: struct {
	rd:		Reg64,
	imm:	i64le
}


LUI :: struct {
	rd:		Reg64,
	imm:	i64le
}


IDec :: union #no_nil {
	ILLEGAL,

	// Q0
	C_ADDI4SPN,
	C_FLD,
	C_LW,
	C_LD,
	C_LBU,
	C_LHU,
	C_LH,
	C_SB,
	C_SH,
	C_FSD,
	C_SW,
	C_SD,

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

	// BRANCH
	BEQ,
	BNE,
	BLT,
	BGE,
	BLTU,
	BGEU,

//	FLW,
//	FLD,
//	FSW,
//	FSD,
//	FMSUB_S,
//	FMSUB_D,

	// JALR
	JALR,

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

	// JAL
	JAL,

	// OP-IMM
	NOP,
	ADDI,
	SLLI,
	BSETI,
	BCLRI,
	CLZ,
	CTZ,
	CPOP,
	SEXT_B,
	SEXT_H,
	BINVI,
	SLTI,
	SLTIU,
	XORI,
	SRLI,
	ORC_B,
	SRAI,
	BEXTI,
	RORI,
	BREV8,
	REV8,
	ORI,
	ANDI,

	// OP
	ADD,
	MUL,
	SUB,
	SLL,
	MULH,
	CLMUL,
	BSET,
	BCLR,
	ROL,
	BINV,
	SLT,
	MULHSU,
	CLMULR,
	SH1ADD,
	XPERM_N,
	SLTU,
	MULHU,
	CLMULH,
	XOR,
	DIV,
	PACK,
	MIN,
	SH2ADD,
	XPERM_B,
	XNOR,
	SRL,
	DIVU,
	MINU,
	CZERO_EQZ,
	SRA,
	BEXT,
	ROR,
	OR,
	REM,
	MAX,
	SH3ADD,
	ORN,
	AND,
	REMU,
	PACKH,
	MAXU,
	CZERO_NEZ,
	ANDN,

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

	// AUIPC
	AUIPC,

	// LUI
	LUI,

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


IType :: enum u8 {
	I16_Q0	= 0b00,
	I16_Q1	= 0b01,
	I16_Q2	= 0b10,
	I32		= 0b11
}


I32_Opcode :: enum u8 {
	LOAD		= 0b0000011,
	STORE		= 0b0100011,
	MADD		= 0b1000011,
	BRANCH		= 0b1100011,
	LOAD_FP		= 0b0000111,
	STORE_FP	= 0b0100111,
	MSUB		= 0b1000111,
	JALR		= 0b1100111,
	NMSUB		= 0b1001011,
	MISC_MEM	= 0b0001111,
	AMO			= 0b0101111,
	NMADD		= 0b1001111,
	JAL			= 0b1101111,
	OP_IMM		= 0b0010011,
	OP			= 0b0110011,
	OP_FP		= 0b1010011,
	SYSTEM		= 0b1110011,
	AUIPC		= 0b0010111,
	LUI			= 0b0110111,
	OP_IMM_32	= 0b0011011,
	OP_32		= 0b0111011
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


sign_extend_to_i64le :: proc(bits: u64le, size: uint, shift: uint = 0) -> i64le {
	if size == 0 {
		panic("dword immediates cannot have less than 1 bit")
	}
	else if size > 64 {
		panic("dword immediates cannot have more than 64 bits")
	}
	else if size + shift > 64 {
		panic("dword immediates cannot be scaled to more than 64 bits")
	}

	// a size of 64 implies that `shift` is 0, meaning the whole bit range can
	// just be given back reinterpreted as an `i64le`
	//
	// and if the `bits` 0, then it can also just be reinterpreted as an
	// `i64le`
	if size == 64 || bits == 0 {
		return transmute(i64le) bits
	}

	// ignore the upper 64 - `size` bits in the range as they are irrelevant
	bits := ~(~u64le(0) << size) & bits

	// ==> if the most significant bit within the range is set, it is a
	// negative number and the rest of the leading bits in the extended signed
	// `i64le` need to be set
	//
	// ==> if the most significant bit within the range is not set, then no
	// bits need to be set because numbers are zero-initialized in odin
	if bits & (1 << (size - 1)) != 0 {
		return transmute(i64le) ((~u64le(0) << size | bits) << shift)
	}
	else {
		return transmute(i64le) (bits << shift)
	}
}


handle_i16opc_q0 :: proc(ie: I16_Base) -> (id: IDec = ILLEGAL{}) {
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

		if	ie.rd_r		== 0 || ie.uimm2		== 0 ||
			ie.uimm3	== 0 || ie.uimm6to9		== 0 || ie.uimm4to5 == 0 {
			return
		}

		UIMM_DEC :: bit_field u16le {
			uimm0to1:	u8 | 2,
			uimm2:		u8 | 1,
			uimm3:		u8 | 1,
			uimm4to5:	u8 | 2,
			uimm6to9:	u8 | 4
		}

		return C_ADDI4SPN{
			rd		= Reg64(ie.rd_r) + Reg64.x7,
			uimm	= u64le(UIMM_DEC{
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

	case 0x3:
		C_LD_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rd_r:		u8 | 3,
			uimm6to7:	u8 | 2,
			rs1_r:		u8 | 3,
			uimm3to5:	u8 | 3,
			funct3:		u8 | 3
		}

		ie := transmute(C_LD_ENC) ie

		UIMM_DEC :: bit_field u8 {
			uimm0to2:	u8 | 3,
			uimm3to5:	u8 | 3,
			uimm6to7:	u8 | 2
		}

		return C_LD{
			rd		= Reg64(ie.rd_r) + Reg64.x7,
			rs1		= Reg64(ie.rs1_r) + Reg64.x7,
			uimm	= u64le(UIMM_DEC{
				uimm0to2	= 0,
				uimm3to5	= ie.uimm3to5,
				uimm6to7	= ie.uimm6to7
			})
		}

	case 0x4:
		I16_Base_2Funct3 :: bit_field u16le {
			opc:		u8 | 2,
			pad1:		u8 | 4,
			funct1:		u8 | 1,
			pad2:		u8 | 3,
			funct3_2:	u8 | 3,
			funct3_1:	u8 | 3
		}

		ie := transmute(I16_Base_2Funct3) ie

		switch ie.funct3_2 {
		case 0x0:
			C_LBU_ENC :: bit_field u16le {
				opc:		u8 | 2,
				rd_r:		u8 | 3,
				uimm1:		u8 | 1,
				uimm0:		u8 | 1,
				rs1_r:		u8 | 3,
				funct3_2:	u8 | 3,
				funct3_1:	u8 | 3
			}

			ie := transmute(C_LBU_ENC) ie

			UIMM_DEC :: bit_field u8 {
				uimm0:	u8 | 1,
				uimm1:	u8 | 1
			}

			return C_LBU{
				rd		= Reg64(ie.rd_r) + Reg64.x7,
				rs1		= Reg64(ie.rs1_r) + Reg64.x7,
				uimm	= u64le(UIMM_DEC{
					uimm0	= ie.uimm0,
					uimm1	= ie.uimm1
				})
			}

		case 0x1:
			switch ie.funct1 {
			case 0:
				C_LHU_ENC :: bit_field u16le {
					opc:		u8 | 2,
					rd_r:		u8 | 3,
					uimm1:		u8 | 1,
					funct1:		u8 | 1,
					rs1_r:		u8 | 3,
					funct3_2:	u8 | 3,
					funct3_1:	u8 | 3
				}

				ie := transmute(C_LHU_ENC) ie

				UIMM_DEC :: bit_field u8 {
					uimm0:	u8 | 1,
					uimm1:	u8 | 1
				}

				return C_LHU{
					rd		= Reg64(ie.rd_r) + Reg64.x7,
					rs1		= Reg64(ie.rs1_r) + Reg64.x7,
					uimm	= u64le(UIMM_DEC{
						uimm0	= 0,
						uimm1	= ie.uimm1
					})
				}

			case 1:
				C_LH_ENC :: bit_field u16le {
					opc:		u8 | 2,
					rd_r:		u8 | 3,
					uimm1:		u8 | 1,
					funct1:		u8 | 1,
					rs1_r:		u8 | 3,
					funct3_2:	u8 | 3,
					funct3_1:	u8 | 3
				}

				ie := transmute(C_LH_ENC) ie

				UIMM_DEC :: bit_field u8 {
					uimm0:	u8 | 1,
					uimm1:	u8 | 1
				}

				return C_LH{
					rd		= Reg64(ie.rd_r) + Reg64.x7,
					rs1		= Reg64(ie.rs1_r) + Reg64.x7,
					uimm	= u64le(UIMM_DEC{
						uimm0	= 0,
						uimm1	= ie.uimm1
					})
				}
			}

		case 0x2:
			C_SB_ENC :: bit_field u16le {
				opc:		u8 | 2,
				rs2_r:		u8 | 3,
				uimm1:		u8 | 1,
				uimm0:		u8 | 1,
				rs1_r:		u8 | 3,
				funct3_2:	u8 | 3,
				funct3_1:	u8 | 3
			}

			ie := transmute(C_SB_ENC) ie

			UIMM_DEC :: bit_field u8 {
				uimm0:	u8 | 1,
				uimm1:	u8 | 1
			}

			return C_SB{
				rs1		= Reg64(ie.rs1_r) + Reg64.x7,
				rs2		= Reg64(ie.rs2_r) + Reg64.x7,
				uimm	= u64le(UIMM_DEC{
					uimm0	= ie.uimm0,
					uimm1	= ie.uimm1
				})
			}

		case 0x3:
			C_SH_ENC :: bit_field u16le {
				opc:		u8 | 2,
				rs2_r:		u8 | 3,
				uimm1:		u8 | 1,
				funct1:		u8 | 1,
				rs1_r:		u8 | 3,
				funct3_2:	u8 | 3,
				funct3_1:	u8 | 3
			}

			ie := transmute(C_SH_ENC) ie

			if ie.funct1 == 1 do return

			UIMM_DEC :: bit_field u8 {
				uimm0:	u8 | 1,
				uimm1:	u8 | 1
			}

			return C_SH{
				rs1		= Reg64(ie.rs1_r) + Reg64.x7,
				rs2		= Reg64(ie.rs2_r) + Reg64.x7,
				uimm	= u64le(UIMM_DEC{
					uimm0	= 0,
					uimm1	= ie.uimm1
				})
			}
		}

	case 0x5:
		C_FSD_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rs2_r:		u8 | 3,
			uimm6to7:	u8 | 2,
			rs1_r:		u8 | 3,
			uimm3to5:	u8 | 3,
			funct3:		u8 | 3
		}

		ie := transmute(C_FSD_ENC) ie

		UIMM_DEC :: bit_field u8 {
			uimm0to2:	u8 | 3,
			uimm3to5:	u8 | 3,
			uimm6to7:	u8 | 2
		}

		return C_FSD{
			rs1		= Reg64(ie.rs1_r) + Reg64.x7,
			rs2		= Reg64(ie.rs2_r) + Reg64.x7,
			uimm	= u64le(UIMM_DEC{
				uimm0to2	= 0,
				uimm3to5	= ie.uimm3to5,
				uimm6to7	= ie.uimm6to7
			})
		}

	case 0x6:
		C_SW_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rs2_r:		u8 | 3,
			uimm6:		u8 | 1,
			uimm2:		u8 | 1,
			rs1_r:		u8 | 3,
			uimm3to5:	u8 | 3,
			funct3:		u8 | 3
		}

		ie := transmute(C_SW_ENC) ie

		UIMM_DEC :: bit_field u8 {
			uimm0to1:	u8 | 2,
			uimm2:		u8 | 1,
			uimm3to5:	u8 | 3,
			uimm6:		u8 | 1
		}

		return C_SW{
			rs1		= Reg64(ie.rs1_r) + Reg64.x7,
			rs2		= Reg64(ie.rs2_r) + Reg64.x7,
			uimm	= u64le(UIMM_DEC{
				uimm0to1	= 0,
				uimm2		= ie.uimm2,
				uimm3to5	= ie.uimm3to5,
				uimm6		= ie.uimm6
			})
		}

	case 0x7:
		C_SD_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rs2_r:		u8 | 3,
			uimm6to7:	u8 | 2,
			rs1_r:		u8 | 3,
			uimm3to5:	u8 | 3,
			funct3:		u8 | 3
		}

		ie := transmute(C_SD_ENC) ie

		UIMM_DEC :: bit_field u8 {
			uimm0to2:	u8 | 3,
			uimm3to5:	u8 | 3,
			uimm6to7:	u8 | 2
		}

		return C_SD{
			rs1		= Reg64(ie.rs1_r) + Reg64.x7,
			rs2		= Reg64(ie.rs2_r) + Reg64.x7,
			uimm	= u64le(UIMM_DEC{
				uimm0to2	= 0,
				uimm3to5	= ie.uimm3to5,
				uimm6to7	= ie.uimm6to7
			})
		}
	}

	return
}


handle_i16opc_q1 :: proc(ie: I16_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i16opc_q2 :: proc(ie: I16_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_load :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_store :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_madd :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_branch :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_B :: bit_field u32le {
		opc:		u8	| 7,
		imm11:		u8	| 1,
		imm1to4:	u8	| 4,
		funct3:		u8	| 3,
		rs1:		u8	| 5,
		rs2:		u8	| 5,
		imm5to10:	u8	| 6,
		imm12:		u8	| 1
	}

	ie := transmute(I32_FMT_B) ie

	UIMM_DEC :: bit_field u32le {
		imm0:		u8	| 1,
		imm1to4:	u8	| 4,
		imm5to10:	u8	| 6,
		imm11:		u8	| 1,
		imm12:		u8	| 1
	}

	imm := sign_extend_to_i64le(
		u64le(UIMM_DEC{
			imm0		= 0,
			imm1to4		= ie.imm1to4,
			imm5to10	= ie.imm5to10,
			imm11		= ie.imm11,
			imm12		= ie.imm12
		}),
		13
	)

	switch ie.funct3 {
	case 0x0:
		return BEQ{
			rs1	= Reg64(ie.rs1),
			rs2	= Reg64(ie.rs2),
			imm	= imm
		}

	case 0x1:
		return BNE{
			rs1	= Reg64(ie.rs1),
			rs2	= Reg64(ie.rs2),
			imm	= imm
		}

	case 0x4:
		return BLT{
			rs1	= Reg64(ie.rs1),
			rs2	= Reg64(ie.rs2),
			imm	= imm
		}

	case 0x5:
		return BGE{
			rs1	= Reg64(ie.rs1),
			rs2	= Reg64(ie.rs2),
			imm	= imm
		}

	case 0x6:
		return BLTU{
			rs1	= Reg64(ie.rs1),
			rs2	= Reg64(ie.rs2),
			imm	= imm
		}

	case 0x7:
		return BGEU{
			rs1	= Reg64(ie.rs1),
			rs2	= Reg64(ie.rs2),
			imm	= imm
		}
	}

	return
}


handle_i32opc_load_fp :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_store_fp :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_msub :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_jalr :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_I :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		funct3:		u8		| 3,
		rs1:		u8		| 5,
		imm0to11:	u16le	| 12,
	}

	ie := transmute(I32_FMT_I) ie

	if ie.funct3 != 0 do return

	return JALR{
		rd	= Reg64(ie.rd),
		rs1	= Reg64(ie.rs1),
		imm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
	}
}


handle_i32opc_nmsub :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_misc_mem :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_amo :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_nmadd :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_jal :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_J :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		imm12to19:	u8		| 8,
		imm11:		u8		| 1,
		imm1to10:	u16le	| 10,
		imm20:		u8		| 1
	}

	ie := transmute(I32_FMT_J) ie

	UIMM_DEC :: bit_field u32le {
		imm0:		u8		| 1,
		imm1to10:	u16le	| 10,
		imm11:		u8		| 1,
		imm12to19:	u8		| 8,
		imm20:		u8		| 1
	}

	return JAL{
		rd	= Reg64(ie.rd),
		imm	= sign_extend_to_i64le(
			u64le(UIMM_DEC{
				imm0		= 0,
				imm1to10	= ie.imm1to10,
				imm11		= ie.imm11,
				imm12to19	= ie.imm12to19,
				imm20		= ie.imm20
			}),
			21
		)
	}
}


handle_i32opc_op_imm :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_I_IMM12 :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		funct3:		u8		| 3,
		rs1:		u8		| 5,
		imm0to11:	u16le	| 12
	}

	I32_FMT_I_IMM6 :: bit_field u32le {
		opc:		u8 | 7,
		rd:			u8 | 5,
		funct3:		u8 | 3,
		rs1:		u8 | 5,
		imm0to5:	u8 | 6,
		funct6:		u8 | 6
	}

	I32_FMT_I_FUNCT6 :: bit_field u32le {
		opc:		u8 | 7,
		rd:			u8 | 5,
		funct3:		u8 | 3,
		rs1:		u8 | 5,
		funct6_2:	u8 | 6,
		funct6_1:	u8 | 6
	}

	I32_FMT_I_FUNCT7 :: bit_field u32le {
		opc:	u8 | 7,
		rd:		u8 | 5,
		funct3:	u8 | 3,
		rs1:	u8 | 5,
		funct5:	u8 | 5,
		funct7:	u8 | 7
	}

	switch ie.funct3 {
	case 0x0:
		ie := transmute(I32_FMT_I_IMM12) ie

		if ie.rd == 0 && ie.rs1 == 0 && ie.imm0to11 == 0 {
			return NOP{}
		}
		else {
			return ADDI{
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1),
				imm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
			}
		}

	case 0x1:
		ie := transmute(I32_FMT_I_IMM6) ie

		switch ie.funct6 {
		case 0x00:
			return SLLI{
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				shamt	= u64le(ie.imm0to5)
			}

		case 0x0A:
			return BSETI{
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1),
				idx	= u64le(ie.imm0to5)
			}

		case 0x12:
			return BCLRI{
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1),
				idx	= u64le(ie.imm0to5)
			}

		case 0x18:
			ie := transmute(I32_FMT_I_FUNCT7) ie

			if ie.funct7 & 1 != 0 do return

			switch ie.funct5 {
			case 0x00:
				return CLZ{
					rd	= Reg64(ie.rd),
					rs1	= Reg64(ie.rs1)
				}

			case 0x01:
				return CTZ{
					rd	= Reg64(ie.rd),
					rs1	= Reg64(ie.rs1)
				}

			case 0x02:
				return CPOP{
					rd	= Reg64(ie.rd),
					rs1	= Reg64(ie.rs1)
				}

			case 0x04:
				return SEXT_B{
					rd	= Reg64(ie.rd),
					rs1	= Reg64(ie.rs1)
				}

			case 0x05:
				return SEXT_H{
					rd	= Reg64(ie.rd),
					rs1	= Reg64(ie.rs1)
				}
			}
			
		case 0x1A:
			return BINVI{
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1),
				idx	= u64le(ie.imm0to5)
			}
		}

	case 0x2:
		ie := transmute(I32_FMT_I_IMM12) ie

		return SLTI{
			rd	= Reg64(ie.rd),
			rs1	= Reg64(ie.rs1),
			imm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
		}

	case 0x3:
		ie := transmute(I32_FMT_I_IMM12) ie

		return SLTIU{
			rd		= Reg64(ie.rd),
			rs1		= Reg64(ie.rs1),
			uimm	= u64le(sign_extend_to_i64le(u64le(ie.imm0to11), 12))
		}

	case 0x4:
		ie := transmute(I32_FMT_I_IMM12) ie

		return XORI{
			rd	= Reg64(ie.rd),
			rs1	= Reg64(ie.rs1),
			imm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
		}

	case 0x5:
		ie := transmute(I32_FMT_I_IMM6) ie

		switch ie.funct6 {
		case 0x00:
			return SRLI{
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				shamt	= u64le(ie.imm0to5)
			}

		case 0x0A:
			ie := transmute(I32_FMT_I_FUNCT6) ie

			if ie.funct6_2 != 0x07 do return

			return ORC_B{
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1)
			}

		case 0x10:
			return SRAI{
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				shamt	= u64le(ie.imm0to5)
			}

		case 0x12:
			return BEXTI{
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1),
				idx	= u64le(ie.imm0to5)
			}

		case 0x18:
			return RORI{
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				shamt	= u64le(ie.imm0to5)
			}

		case 0x1A:
			ie := transmute(I32_FMT_I_FUNCT6) ie

			switch ie.funct6_2 {
			case 0x07:
				return BREV8{
					rd	= Reg64(ie.rd),
					rs1	= Reg64(ie.rs1)
				}

			case 0x38:
				return REV8{
					rd	= Reg64(ie.rd),
					rs1	= Reg64(ie.rs1)
				}
			}
		}

	case 0x6:
		ie := transmute(I32_FMT_I_IMM12) ie

		return ORI{
			rd	= Reg64(ie.rd),
			rs1	= Reg64(ie.rs1),
			imm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
		}

	case 0x7:
		ie := transmute(I32_FMT_I_IMM12) ie

		return ANDI{
			rd	= Reg64(ie.rd),
			rs1	= Reg64(ie.rs1),
			imm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
		}
	}

	return
}


handle_i32opc_op :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_R :: bit_field u32le {
		opc:	u8 | 7,
		rd:		u8 | 5,
		funct3:	u8 | 3,
		rs1:	u8 | 5,
		rs2:	u8 | 5,
		funct7:	u8 | 7
	}

	ie := transmute(I32_FMT_R) ie

	switch ie.funct3 {
	case 0x0:
		switch ie.funct7 {
		case 0x0:
			return ADD{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x1:
			return MUL{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x20:
			return SUB{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}
		}

	case 0x1:
		switch ie.funct7 {
		case 0x00:
			return SLL{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x01:
			return MULH{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x05:
			return CLMUL{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x14:
			return BSET{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x24:
			return BCLR{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x30:
			return ROL{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x34:
			return BINV{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}
		}

	case 0x2:
		switch ie.funct7 {
		case 0x00:
			return SLT{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x01:
			return MULHSU{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x05:
			return CLMULR{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x10:
			return SH1ADD{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x14:
			return XPERM_N{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}
		}

	case 0x3:
		switch ie.funct7 {
		case 0x00:
			return SLTU{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x01:
			return MULHU{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x05:
			return CLMULH{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}
		}

	case 0x4:
		switch ie.funct7 {
		case 0x00:
			return XOR{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x01:
			return DIV{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x04:
			return PACK{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x05:
			return MIN{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x10:
			return SH2ADD{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x14:
			return XPERM_B{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x20:
			return XNOR{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}
		}

	case 0x5:
		switch ie.funct7 {
		case 0x00:
			return SRL{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x01:
			return DIVU{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x05:
			return MINU{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x07:
			return CZERO_EQZ{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x20:
			return SRA{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x24:
			return BEXT{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x30:
			return ROR{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}
		}

	case 0x6:
		switch ie.funct7 {
		case 0x00:
			return OR{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x01:
			return REM{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x05:
			return MAX{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x10:
			return SH3ADD{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x20:
			return ORN{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}
		}

	case 0x7:
		switch ie.funct7 {
		case 0x00:
			return AND{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x01:
			return REMU{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x04:
			return PACKH{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x05:
			return MAXU{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x07:
			return CZERO_NEZ{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}

		case 0x20:
			return ANDN{
				rd	= Reg64(ie.rd),
				rs1 = Reg64(ie.rs1),
				rs2 = Reg64(ie.rs2)
			}
		}
	}

	return
}


handle_i32opc_op_fp :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_system :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_auipc :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_U :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		uimm12to31:	u32le	| 20
	}

	ie := transmute(I32_FMT_U) ie

	UIMM_DEC :: bit_field u32le {
		uimm0to11:	u16le | 12,
		uimm12to31:	u32le | 20
	}

	return AUIPC{
		rd	= Reg64(ie.rd),
		imm	= sign_extend_to_i64le(
			u64le(UIMM_DEC{
				uimm0to11	= 0,
				uimm12to31	= ie.uimm12to31
			}),
			32
		)
	}
}


handle_i32opc_lui :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_U :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		uimm12to31:	u32le	| 20
	}

	ie := transmute(I32_FMT_U) ie

	UIMM_DEC :: bit_field u32le {
		uimm0to11:	u16le | 12,
		uimm12to31:	u32le | 20
	}

	return LUI{
		rd	= Reg64(ie.rd),
		imm	= sign_extend_to_i64le(
			u64le(UIMM_DEC{
				uimm0to11	= 0,
				uimm12to31	= ie.uimm12to31
			}),
			32
		)
	}
}


handle_i32opc_op_imm_32 :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


handle_i32opc_op_32 :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return
}


decode_instruction :: proc(mem: []u8) -> (id: IDec = ILLEGAL{}) {
	// Without checking the opcode it is impossible to determine whether a
	// given instruction is 2 bytes long or 4 bytes long unless the memory
	// buffer only has 2 bytes left.
	//
	// As such, the 2 byte case should only occur when when there is not enough
	// space left in the backing buffer to create a slice of 4 bytes
	if ilen := len(mem); ilen != 4 && ilen != 2 {
		panic("instructions must be either 2 or 4 bytes long")
	}


	type := IType(mem[0] & 0b11)


	switch type {
	case .I16_Q0:
		ie := transmute(I16_Base) (cast(^u16le) raw_data(mem))^

		if ie.opc == 0 && ie.funct3 == 0 && ie.pad == 0 do return

		return handle_i16opc_q0(ie)

	case .I16_Q1:
		ie := transmute(I16_Base) (cast(^u16le) raw_data(mem))^

		return handle_i16opc_q1(ie)

	case .I16_Q2:
		ie := transmute(I16_Base) (cast(^u16le) raw_data(mem))^

		return handle_i16opc_q2(ie)

	case .I32:
		ie := transmute(I32_Base) (cast(^u32le) raw_data(mem))^

		if	ie.opc		== 0 && ie.funct7	== 0 &&
			ie.funct3	== 0 && ie.pad1		== 0 && ie.pad2 == 0 {
			return
		}

		i32opc := I32_Opcode(ie.opc)

		if reflect.enum_value_has_name(i32opc) == false do return

		switch i32opc {
		case .LOAD:
			return handle_i32opc_load(ie)

		case .STORE:
			return handle_i32opc_store(ie)

		case .MADD:
			return handle_i32opc_madd(ie)

		case .BRANCH:
			return handle_i32opc_branch(ie)

		case .LOAD_FP:
			return handle_i32opc_load_fp(ie)

		case .STORE_FP:
			return handle_i32opc_store_fp(ie)

		case .MSUB:
			return handle_i32opc_msub(ie)

		case .JALR:
			return handle_i32opc_jalr(ie)

		case .NMSUB:
			return handle_i32opc_nmsub(ie)

		case .MISC_MEM:
			return handle_i32opc_misc_mem(ie)

		case .AMO:
			return handle_i32opc_amo(ie)

		case .NMADD:
			return handle_i32opc_nmadd(ie)

		case .JAL:
			return handle_i32opc_jal(ie)

		case .OP_IMM:
			return handle_i32opc_op_imm(ie)

		case .OP:
			return handle_i32opc_op(ie)

		case .OP_FP:
			return handle_i32opc_op_fp(ie)

		case .SYSTEM:
			return handle_i32opc_system(ie)

		case .AUIPC:
			return handle_i32opc_auipc(ie)

		case .LUI:
			return handle_i32opc_lui(ie)

		case .OP_IMM_32:
			return handle_i32opc_op_imm_32(ie)

		case .OP_32:
			return handle_i32opc_op_32(ie)
		}
	}

	return
}


main :: proc() {
	memory:	[128]u8	= 0
	maxpc:	u64le	= 0
	pc:		u64le	= 0
	w16:	^u16le
	w32:	^u32le


	fmt.println("encoding c.lw x8 8(x9)")
	w16		= cast(^u16le) &memory[maxpc]
	w16^	= 0b010_001_010_00_001_00
	maxpc += 2

	fmt.println("encoding mul x3 x5 x3")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b0000001_00011_00101_000_00011_0110011
	maxpc += 4

	fmt.println("encoding andn x31 x5 x11")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b0100000_01011_00101_111_11111_0110011
	maxpc += 4

	fmt.println("encoding slti x7 x19 192")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b000011000000_10011_010_00111_0010011
	maxpc += 4

	fmt.println("encoding auipc x9 -2144337920")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b1000_0000_0011_0000_0000_01001_0010111
	maxpc += 4

	fmt.println("encoding auipc x32 786432")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b0000_0000_0000_1100_0000_10111_0010111
	maxpc += 4

	fmt.println("encoding lui x18 -1086574592")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b1011_1111_0011_1100_0011_10010_0110111
	maxpc += 4

	fmt.println("encoding lui x30 12779520")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b0000_0000_1100_0011_0000_11110_0110111
	maxpc += 4

	fmt.println("encoding jal x1 -429978")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b1_0000110011_0_10010111_00001_1101111
	maxpc += 4

	fmt.println("encoding jal x1 3206")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b0_1001000011_1_00000000_00001_1101111
	maxpc += 4

	fmt.println("encoding jalr x1 -1622(x16)")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b100110101010_10000_000_00001_1100111
	maxpc += 4

	fmt.println("encoding jalr x1 1166(x17)")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b010010001110_10001_000_00001_1100111
	maxpc += 4

	fmt.println("encoding bge x27 x28 -328")
	w32		= cast(^u32le) &memory[maxpc]
	w32^	= 0b1_110101_11100_11011_101_1100_1_1100011
	maxpc += 4


	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 2

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4

	fmt.println(decode_instruction(memory[pc:pc + 4]))
	pc += 4
}

