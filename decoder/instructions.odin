
package decoder


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

	// Q1
	C_NOP,
	C_ADDI,
	C_ADDIW,
	C_LI,
	C_ADDI16SP,
	C_LUI,
	C_SRLI,
	C_SRAI,
	C_ANDI,
	C_SUB,
	C_XOR,
	C_OR,
	C_AND,
	C_SUBW,
	C_ADDW,
	C_MUL,
	C_ZEXT_B,
	C_SEXT_B,
	C_ZEXT_H,
	C_SEXT_H,
	C_ZEXT_W,
	C_NOT,
	C_J,
	C_BEQZ,
	C_BNEZ,

	// Q2
	C_SLLI,
	C_FLDSP,
	C_LWSP,
	C_LDSP,
	C_JR,
	C_MV,
	C_EBREAK,
	C_JALR,
	C_ADD,
	C_FSDSP,
	C_SWSP,
	C_SDSP,

	// LOAD
//	LB,
//	LH,
//	LW,
//	LD,
//	LBU,
//	LHU,

	// STORE
//	SB,
//	SH,
//	SW,
//	SD,

	// MADD
//	FMADD_S,
//	FMADD_D,

	// BRANCH
	BEQ,
	BNE,
	BLT,
	BGE,
	BLTU,
	BGEU,

	// LOAD-FP
//	FLW,
//	FLD,

	// STORE-FP
//	FSW,
//	FSD,

	// MSUB
//	FMSUB_S,
//	FMSUB_D,

	// JALR
	JALR,

	// NMSUB
//	FNMSUB_S,
//	FNMSUB_D,

	// MISC-MEM
//	FENCE,
//	FENCE_TSO,
//	PAUSE,
//	FENCE_I,

	// AMO
	AMOADD_W,
	AMOSWAP_W,
	LR_W,
	SC_W,
	AMOXOR_W,
	AMOCAS_W,
	AMOOR_W,
	AMOAND_W,
	AMOMIN_W,
	AMOMAX_W,
	AMOMINU_W,
	AMOMAXU_W,
	AMOADD_D,
	AMOSWAP_D,
	LR_D,
	SC_D,
	AMOXOR_D,
	AMOCAS_D,
	AMOOR_D,
	AMOAND_D,
	AMOMIN_D,
	AMOMAX_D,
	AMOMINU_D,
	AMOMAXU_D,
	AMOCAS_Q,

	// NMADD
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

	// OP-FP
	FADD_S,
	FADD_D,
	FSUB_S,
	FSUB_D,
	FMUL_S,
	FMUL_D,
	FDIV_S,
	FDIV_D,
	FSGNJ_S,
	FSGNJN_S,
	FSGNJX_S,
	FSGNJ_D,
	FSGNJN_D,
	FSGNJX_D,
	FMIN_S,
	FMAX_S,
	FMINM_S,
	FMAXM_S,
	FMIN_D,
	FMAX_D,
	FMINM_D,
	FMAXM_D,
	FCVT_S_D,
	FROUND_S,
	FROUNDNX_S,
	FCVT_D_S,
	FROUND_D,
	FROUNDNX_D,
	FSQRT_S,
	FSQRT_D,
	FLE_S,
	FLT_S,
	FEQ_S,
	FLEQ_S,
	FLTQ_S,
	FLE_D,
	FLT_D,
	FEQ_D,
	FLEQ_D,
	FLTQ_D,
	FCVT_W_S,
	FCVT_WU_S,
	FCVT_L_S,
	FCVT_LU_S,
	FCVT_W_D,
	FCVT_WU_D,
	FCVT_L_D,
	FCVT_LU_D,
	FCVTMOD_W_D,
	FCVT_S_W,
	FCVT_S_WU,
	FCVT_S_L,
	FCVT_S_LU,
	FCVT_D_W,
	FCVT_D_WU,
	FCVT_D_L,
	FCVT_D_LU,
	FMV_X_W,
	FCLASS_S,
	FMV_X_D,
	FCLASS_D,
	FMV_W_X,
	FLI_S,
	FMV_D_X,
	FLI_D,

	// SYSTEM
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

	// OP-IMM-32
//	ADDIW,
//	SLLIW,
//	SLLI_UW,
//	CLZW,
//	CTZW,
//	CPOPW,
//	SRLIW,
//	SRAIW,
//	RORIW,

	// OP-32
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


/*
 * Decoded Instruction Types
 */

IDec_Empty :: struct {}

IDec_Rd :: struct {
	rd:		Reg64
}

IDec_R1s :: struct {
	rs1:	Reg64
}

IDec_Rd1s :: struct {
	rd:		Reg64,
	rs1:	Reg64
}

IDec_R2s :: struct {
	rs1:	Reg64,
	rs2:	Reg64
}

IDec_Rd2s :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64
}

IDec_Rd_Uimm :: struct {
	rd:		Reg64,
	uimm:	u64le
}

IDec_R1s_Uimm :: struct {
	rs1:	Reg64,
	uimm:	u64le
}

IDec_Rd1s_Uimm :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	uimm:	u64le
}

IDec_R2s_Uimm :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	uimm:	u64le
}

IDec_Rd2s_Uimm :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64,
	uimm:	u64le
}

IDec_Rd_Imm :: struct {
	rd:		Reg64,
	imm:	i64le
}

IDec_R1s_Imm :: struct {
	rs1:	Reg64,
	imm:	i64le
}

IDec_Rd1s_Imm :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	imm:	i64le
}

IDec_R2s_Imm :: struct {
	rs1:	Reg64,
	rs2:	Reg64,
	imm:	i64le
}

IDec_Imm :: struct {
	imm:	i64le
}

Flags_Rl_Aq :: enum {rl, aq}
Flagbits_Rl_Aq :: distinct bit_set[Flags_Rl_Aq]

IDec_Rd1s_Amo :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rl_aq:	Flagbits_Rl_Aq
}

IDec_Rd2s_Amo :: struct {
	rd:		Reg64,
	rs1:	Reg64,
	rs2:	Reg64,
	rl_aq:	Flagbits_Rl_Aq
}


/*
 * Decoded Instruction Definitions
 */

// Illegal Instruction
ILLEGAL		:: distinct IDec_Empty

// Compressed Opcode 00 Instructions
C_ADDI4SPN	:: distinct IDec_Rd_Uimm
C_FLD		:: distinct IDec_Rd1s_Uimm
C_LW		:: distinct IDec_Rd1s_Uimm
C_LD		:: distinct IDec_Rd1s_Uimm
C_LBU		:: distinct IDec_Rd1s_Uimm
C_LHU		:: distinct IDec_Rd1s_Uimm
C_LH		:: distinct IDec_Rd1s_Uimm
C_SB		:: distinct IDec_R2s_Uimm
C_SH		:: distinct IDec_R2s_Uimm
C_FSD		:: distinct IDec_R2s_Uimm
C_SW		:: distinct IDec_R2s_Uimm
C_SD		:: distinct IDec_R2s_Uimm

// Compressed Opcode 01 Instructions
C_NOP		:: distinct IDec_Empty
C_ADDI		:: distinct IDec_Rd1s_Imm
C_ADDIW		:: distinct IDec_Rd1s_Imm
C_LI		:: distinct IDec_Rd_Imm
C_ADDI16SP	:: distinct IDec_Rd_Imm
C_LUI		:: distinct IDec_Rd_Imm
C_SRLI		:: distinct IDec_Rd1s_Uimm
C_SRAI		:: distinct IDec_Rd1s_Uimm
C_ANDI		:: distinct IDec_Rd1s_Imm
C_SUB		:: distinct IDec_Rd2s
C_XOR		:: distinct IDec_Rd2s
C_OR		:: distinct IDec_Rd2s
C_AND		:: distinct IDec_Rd2s
C_SUBW		:: distinct IDec_Rd2s
C_ADDW		:: distinct IDec_Rd2s
C_MUL		:: distinct IDec_Rd2s
C_ZEXT_B	:: distinct IDec_Rd1s
C_SEXT_B	:: distinct IDec_Rd1s
C_ZEXT_H	:: distinct IDec_Rd1s
C_SEXT_H	:: distinct IDec_Rd1s
C_ZEXT_W	:: distinct IDec_Rd1s
C_NOT		:: distinct IDec_Rd1s
C_J			:: distinct IDec_Imm
C_BEQZ		:: distinct IDec_R1s_Imm
C_BNEZ		:: distinct IDec_R1s_Imm

// Compressed Opcode 10 Instructions
C_SLLI		:: distinct IDec_Rd1s_Uimm
C_FLDSP		:: distinct IDec_Rd_Uimm
C_LWSP		:: distinct IDec_Rd_Uimm
C_LDSP		:: distinct IDec_Rd_Uimm
C_JR		:: distinct IDec_R1s
C_MV		:: distinct IDec_Rd2s
C_EBREAK	:: distinct IDec_Empty
C_JALR		:: distinct IDec_R1s
C_ADD		:: distinct IDec_Rd2s
C_FSDSP		:: distinct IDec_R1s_Uimm
C_SWSP		:: distinct IDec_R1s_Uimm
C_SDSP		:: distinct IDec_R1s_Uimm

// BRANCH Opcode Instructions
BEQ			:: distinct IDec_R2s_Imm
BNE			:: distinct IDec_R2s_Imm
BLT			:: distinct IDec_R2s_Imm
BGE			:: distinct IDec_R2s_Imm
BLTU		:: distinct IDec_R2s_Imm
BGEU		:: distinct IDec_R2s_Imm

// JALR Opcode Instructions
JALR		:: distinct IDec_Rd1s_Imm

// AMO Opcode Instructions
AMOADD_W	:: distinct IDec_Rd2s_Amo
AMOSWAP_W	:: distinct IDec_Rd2s_Amo
LR_W		:: distinct IDec_Rd1s_Amo
SC_W		:: distinct IDec_Rd2s_Amo
AMOXOR_W	:: distinct IDec_Rd2s_Amo
AMOCAS_W	:: distinct IDec_Rd2s_Amo
AMOOR_W		:: distinct IDec_Rd2s_Amo
AMOAND_W	:: distinct IDec_Rd2s_Amo
AMOMIN_W	:: distinct IDec_Rd2s_Amo
AMOMAX_W	:: distinct IDec_Rd2s_Amo
AMOMINU_W	:: distinct IDec_Rd2s_Amo
AMOMAXU_W	:: distinct IDec_Rd2s_Amo
AMOADD_D	:: distinct IDec_Rd2s_Amo
AMOSWAP_D	:: distinct IDec_Rd2s_Amo
LR_D		:: distinct IDec_Rd1s_Amo
SC_D		:: distinct IDec_Rd2s_Amo
AMOXOR_D	:: distinct IDec_Rd2s_Amo
AMOCAS_D	:: distinct IDec_Rd2s_Amo
AMOOR_D		:: distinct IDec_Rd2s_Amo
AMOAND_D	:: distinct IDec_Rd2s_Amo
AMOMIN_D	:: distinct IDec_Rd2s_Amo
AMOMAX_D	:: distinct IDec_Rd2s_Amo
AMOMINU_D	:: distinct IDec_Rd2s_Amo
AMOMAXU_D	:: distinct IDec_Rd2s_Amo
AMOCAS_Q	:: distinct IDec_Rd2s_Amo

// JAL Opcode Instructions
JAL			:: distinct IDec_Rd_Imm

// OP-IMM Opcode Instructions
NOP			:: distinct IDec_Empty
ADDI		:: distinct IDec_Rd1s_Imm
SLLI		:: distinct IDec_Rd1s_Uimm
BSETI		:: distinct IDec_Rd1s_Uimm
BCLRI		:: distinct IDec_Rd1s_Uimm
CLZ			:: distinct IDec_Rd1s
CTZ			:: distinct IDec_Rd1s
CPOP		:: distinct IDec_Rd1s
SEXT_B		:: distinct IDec_Rd1s
SEXT_H		:: distinct IDec_Rd1s
BINVI		:: distinct IDec_Rd1s_Uimm
SLTI		:: distinct IDec_Rd1s_Imm
SLTIU		:: distinct IDec_Rd1s_Uimm
XORI		:: distinct IDec_Rd1s_Imm
SRLI		:: distinct IDec_Rd1s_Uimm
ORC_B		:: distinct IDec_Rd1s
SRAI		:: distinct IDec_Rd1s_Uimm
BEXTI		:: distinct IDec_Rd1s_Uimm
RORI		:: distinct IDec_Rd1s_Uimm
BREV8		:: distinct IDec_Rd1s
REV8		:: distinct IDec_Rd1s
ORI			:: distinct IDec_Rd1s_Imm
ANDI		:: distinct IDec_Rd1s_Imm

// OP Opcode Instructions
ADD			:: distinct IDec_Rd2s
MUL			:: distinct IDec_Rd2s
SUB			:: distinct IDec_Rd2s
SLL			:: distinct IDec_Rd2s
MULH		:: distinct IDec_Rd2s
CLMUL		:: distinct IDec_Rd2s
BSET		:: distinct IDec_Rd2s
BCLR		:: distinct IDec_Rd2s
ROL			:: distinct IDec_Rd2s
BINV		:: distinct IDec_Rd2s
SLT			:: distinct IDec_Rd2s
MULHSU		:: distinct IDec_Rd2s
CLMULR		:: distinct IDec_Rd2s
SH1ADD		:: distinct IDec_Rd2s
XPERM_N		:: distinct IDec_Rd2s
SLTU		:: distinct IDec_Rd2s
MULHU		:: distinct IDec_Rd2s
CLMULH		:: distinct IDec_Rd2s
XOR			:: distinct IDec_Rd2s
DIV			:: distinct IDec_Rd2s
PACK		:: distinct IDec_Rd2s
MIN			:: distinct IDec_Rd2s
SH2ADD		:: distinct IDec_Rd2s
XPERM_B		:: distinct IDec_Rd2s
XNOR		:: distinct IDec_Rd2s
SRL			:: distinct IDec_Rd2s
DIVU		:: distinct IDec_Rd2s
MINU		:: distinct IDec_Rd2s
CZERO_EQZ	:: distinct IDec_Rd2s
SRA			:: distinct IDec_Rd2s
BEXT		:: distinct IDec_Rd2s
ROR			:: distinct IDec_Rd2s
OR			:: distinct IDec_Rd2s
REM			:: distinct IDec_Rd2s
MAX			:: distinct IDec_Rd2s
SH3ADD		:: distinct IDec_Rd2s
ORN			:: distinct IDec_Rd2s
AND			:: distinct IDec_Rd2s
REMU		:: distinct IDec_Rd2s
PACKH		:: distinct IDec_Rd2s
MAXU		:: distinct IDec_Rd2s
CZERO_NEZ	:: distinct IDec_Rd2s
ANDN		:: distinct IDec_Rd2s

// OP-FP Opcode distinct
FADD_S		:: distinct IDec_Rd2s_Uimm
FADD_D		:: distinct IDec_Rd2s_Uimm
FSUB_S		:: distinct IDec_Rd2s_Uimm
FSUB_D		:: distinct IDec_Rd2s_Uimm
FMUL_S		:: distinct IDec_Rd2s_Uimm
FMUL_D		:: distinct IDec_Rd2s_Uimm
FDIV_S		:: distinct IDec_Rd2s_Uimm
FDIV_D		:: distinct IDec_Rd2s_Uimm
FSGNJ_S		:: distinct IDec_Rd2s
FSGNJN_S	:: distinct IDec_Rd2s
FSGNJX_S	:: distinct IDec_Rd2s
FSGNJ_D		:: distinct IDec_Rd2s
FSGNJN_D	:: distinct IDec_Rd2s
FSGNJX_D	:: distinct IDec_Rd2s
FMIN_S		:: distinct IDec_Rd2s
FMAX_S		:: distinct IDec_Rd2s
FMINM_S		:: distinct IDec_Rd2s
FMAXM_S		:: distinct IDec_Rd2s
FMIN_D		:: distinct IDec_Rd2s
FMAX_D		:: distinct IDec_Rd2s
FMINM_D		:: distinct IDec_Rd2s
FMAXM_D		:: distinct IDec_Rd2s
FCVT_S_D	:: distinct IDec_Rd1s_Uimm
FROUND_S	:: distinct IDec_Rd1s_Uimm
FROUNDNX_S	:: distinct IDec_Rd1s_Uimm
FCVT_D_S	:: distinct IDec_Rd1s_Uimm
FROUND_D	:: distinct IDec_Rd1s_Uimm
FROUNDNX_D	:: distinct IDec_Rd1s_Uimm
FSQRT_S		:: distinct IDec_Rd1s_Uimm
FSQRT_D		:: distinct IDec_Rd1s_Uimm
FLE_S		:: distinct IDec_Rd2s
FLT_S		:: distinct IDec_Rd2s
FEQ_S		:: distinct IDec_Rd2s
FLEQ_S		:: distinct IDec_Rd2s
FLTQ_S		:: distinct IDec_Rd2s
FLE_D		:: distinct IDec_Rd2s
FLT_D		:: distinct IDec_Rd2s
FEQ_D		:: distinct IDec_Rd2s
FLEQ_D		:: distinct IDec_Rd2s
FLTQ_D		:: distinct IDec_Rd2s
FCVT_W_S	:: distinct IDec_Rd1s_Uimm
FCVT_WU_S	:: distinct IDec_Rd1s_Uimm
FCVT_L_S	:: distinct IDec_Rd1s_Uimm
FCVT_LU_S	:: distinct IDec_Rd1s_Uimm
FCVT_W_D	:: distinct IDec_Rd1s_Uimm
FCVT_WU_D	:: distinct IDec_Rd1s_Uimm
FCVT_L_D	:: distinct IDec_Rd1s_Uimm
FCVT_LU_D	:: distinct IDec_Rd1s_Uimm
FCVTMOD_W_D	:: distinct IDec_Rd1s
FCVT_S_W	:: distinct IDec_Rd1s_Uimm
FCVT_S_WU	:: distinct IDec_Rd1s_Uimm
FCVT_S_L	:: distinct IDec_Rd1s_Uimm
FCVT_S_LU	:: distinct IDec_Rd1s_Uimm
FCVT_D_W	:: distinct IDec_Rd1s_Uimm
FCVT_D_WU	:: distinct IDec_Rd1s_Uimm
FCVT_D_L	:: distinct IDec_Rd1s_Uimm
FCVT_D_LU	:: distinct IDec_Rd1s_Uimm
FMV_X_W		:: distinct IDec_Rd1s
FCLASS_S	:: distinct IDec_Rd1s
FMV_X_D		:: distinct IDec_Rd1s
FCLASS_D	:: distinct IDec_Rd1s
FMV_W_X		:: distinct IDec_Rd1s
FLI_S		:: distinct IDec_Rd_Uimm
FMV_D_X		:: distinct IDec_Rd1s
FLI_D		:: distinct IDec_Rd_Uimm

// AUIPC Opcode Instructions
AUIPC		:: distinct IDec_Rd_Imm

// LUI Opcode Instructions
LUI			:: distinct IDec_Rd_Imm


