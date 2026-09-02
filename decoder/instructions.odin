
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
	LB,
	LH,
	LW,
	LD,
	LBU,
	LHU,

	// STORE
	SB,
	SH,
	SW,
	SD,

	// MADD
	FMADD_S,
	FMADD_D,

	// BRANCH
	BEQ,
	BNE,
	BLT,
	BGE,
	BLTU,
	BGEU,

	// LOAD-FP
	FLW,
	FLD,

	// STORE-FP
	FSW,
	FSD,

	// MSUB
	FMSUB_S,
	FMSUB_D,

	// JALR
	JALR,

	// NMSUB
	FNMSUB_S,
	FNMSUB_D,

	// MISC-MEM
	FENCE,
	FENCE_TSO,
	PAUSE,
	FENCE_I,

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
	FNMADD_S,
	FNMADD_D,

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
	ECALL,
	EBREAK,
	WRS_NTO,
	WRS_STO,
	CSRRW,
	CSRRS,
	CSRRC,
	CSRRWI,
	CSRRSI,
	CSRRCI,

	// AUIPC
	AUIPC,

	// LUI
	LUI,

	// OP-IMM-32
	ADDIW,
	SLLIW,
	SLLI_UW,
	CLZW,
	CTZW,
	CPOPW,
	SRLIW,
	SRAIW,
	RORIW,

	// OP-32
	ADDW,
	MULW,
	ADD_UW,
	SUBW,
	SLLW,
	ROLW,
	SH1ADD_UW,
	DIVW,
	ZEXT_H,
	SH2ADD_UW,
	SRLW,
	DIVUW,
	SRAW,
	RORW,
	REMW,
	SH3ADD_UW,
	REMUW,
}


/*
 * Decoded Instruction Types
 */

IDec_Empty :: struct {}

IDec_Ir1s :: struct {
	rs1:	IReg
}

IDec_Ird1s :: struct {
	rd:		IReg,
	rs1:	IReg
}

IDec_Ir2s :: struct {
	rs1:	IReg,
	rs2:	IReg
}

IDec_Ird2s :: struct {
	rd:		IReg,
	rs1:	IReg,
	rs2:	IReg
}

IDec_Ird_Uimm :: struct {
	rd:		IReg,
	uimm:	u64le
}

IDec_Ir1s_Uimm :: struct {
	rs1:	IReg,
	uimm:	u64le
}

IDec_Ird1s_Uimm :: struct {
	rd:		IReg,
	rs1:	IReg,
	uimm:	u64le
}

IDec_Ir2s_Uimm :: struct {
	rs1:	IReg,
	rs2:	IReg,
	uimm:	u64le
}

IDec_Ird2s_Uimm :: struct {
	rd:		IReg,
	rs1:	IReg,
	rs2:	IReg,
	uimm:	u64le
}

IDec_Ird_Simm :: struct {
	rd:		IReg,
	simm:	i64le
}

IDec_Ir1s_Simm :: struct {
	rs1:	IReg,
	simm:	i64le
}

IDec_Ird1s_Simm :: struct {
	rd:		IReg,
	rs1:	IReg,
	simm:	i64le
}

IDec_Ir2s_Simm :: struct {
	rs1:	IReg,
	rs2:	IReg,
	simm:	i64le
}

IDec_Simm :: struct {
	simm:	i64le
}

Flags_Rl_Aq :: enum {rl, aq}
Flagbits_Rl_Aq :: distinct bit_set[Flags_Rl_Aq]

IDec_Ird1s_Amo :: struct {
	rd:		IReg,
	rs1:	IReg,
	rl_aq:	Flagbits_Rl_Aq
}

IDec_Ird2s_Amo :: struct {
	rd:		IReg,
	rs1:	IReg,
	rs2:	IReg,
	rl_aq:	Flagbits_Rl_Aq
}

IDec_Ird1s_Csr :: struct {
	rd:		IReg,
	rs1:	IReg,
	csr:	CSReg
}

IDec_Ird_Csr_Uimm :: struct {
	rd:		IReg,
	csr:	CSReg,
	uimm:	u64le
}


// Float-specific types

Frm :: enum {
	rne,
	rtz,
	rdn,
	rup,
	rmm,
	res1,
	res2,
	dyn
}

IDec_Frd_Uimm :: struct {
	rd:		FReg,
	uimm:	u64le
}

IDec_Fr1s_Uimm :: struct {
	rs1:	FReg,
	uimm:	u64le
}

IDec_Frd1s_Rm :: struct {
	rd:		FReg,
	rs1:	FReg,
	rm:		Frm
}

IDec_Frd2s :: struct {
	rd:		FReg,
	rs1:	FReg,
	rs2:	FReg,
	rm:		Frm
}

IDec_Frd2s_Rm :: struct {
	rd:		FReg,
	rs1:	FReg,
	rs2:	FReg,
	rm:		Frm
}

IDec_Frd3s_Rm :: struct {
	rd:		FReg,
	rs1:	FReg,
	rs2:	FReg,
	rs3:	FReg,
	rm:		Frm
}

IDec_Ird_Fr1s :: struct {
	rd:		IReg,
	rs1:	FReg
}

IDec_Ird_Fr1s_Rm :: struct {
	rd:		IReg,
	rs1:	FReg,
	rm:		Frm
}

IDec_Ird_Fr2s :: struct {
	rd:		IReg,
	rs1:	FReg,
	rs2:	FReg
}

IDec_Ir1s_Frd :: struct {
	rd:		FReg,
	rs1:	IReg
}

IDec_Ir1s_Frd_Rm :: struct {
	rd:		FReg,
	rs1:	IReg,
	rm:		Frm
}

IDec_Ir1s_Frd_Uimm :: struct {
	rd:		FReg,
	rs1:	IReg,
	uimm:	u64le
}

IDec_Ir1s_Frd_Simm :: struct {
	rd:		FReg,
	rs1:	IReg,
	simm:	i64le
}

IDec_Ir1s_Fr1s_Uimm :: struct {
	rs1:	IReg,
	rs2:	FReg,
	uimm:	u64le
}

IDec_Ir1s_Fr1s_Simm :: struct {
	rs1:	IReg,
	rs2:	FReg,
	simm:	i64le
}

Flags_MOSet :: enum {w, r, o, i}
Flagbits_MOSet :: distinct bit_set[Flags_MOSet]

IDec_Ird1s_Fence :: struct {
	rd:		IReg,
	rs1:	IReg,
	succ:	Flagbits_MOSet,
	pred:	Flagbits_MOSet
}


/*
 * Decoded Instruction Definitions
 */

// Illegal Instruction
ILLEGAL		:: distinct IDec_Empty

// Compressed Opcode 00 Instructions
C_ADDI4SPN	:: distinct IDec_Ird_Uimm
C_FLD		:: distinct IDec_Ir1s_Frd_Uimm
C_LW		:: distinct IDec_Ird1s_Uimm
C_LD		:: distinct IDec_Ird1s_Uimm
C_LBU		:: distinct IDec_Ird1s_Uimm
C_LHU		:: distinct IDec_Ird1s_Uimm
C_LH		:: distinct IDec_Ird1s_Uimm
C_SB		:: distinct IDec_Ir2s_Uimm
C_SH		:: distinct IDec_Ir2s_Uimm
C_FSD		:: distinct IDec_Ir1s_Fr1s_Uimm
C_SW		:: distinct IDec_Ir2s_Uimm
C_SD		:: distinct IDec_Ir2s_Uimm

// Compressed Opcode 01 Instructions
C_NOP		:: distinct IDec_Empty
C_ADDI		:: distinct IDec_Ird1s_Simm
C_ADDIW		:: distinct IDec_Ird1s_Simm
C_LI		:: distinct IDec_Ird_Simm
C_ADDI16SP	:: distinct IDec_Ird_Simm
C_LUI		:: distinct IDec_Ird_Simm
C_SRLI		:: distinct IDec_Ird1s_Uimm
C_SRAI		:: distinct IDec_Ird1s_Uimm
C_ANDI		:: distinct IDec_Ird1s_Simm
C_SUB		:: distinct IDec_Ird2s
C_XOR		:: distinct IDec_Ird2s
C_OR		:: distinct IDec_Ird2s
C_AND		:: distinct IDec_Ird2s
C_SUBW		:: distinct IDec_Ird2s
C_ADDW		:: distinct IDec_Ird2s
C_MUL		:: distinct IDec_Ird2s
C_ZEXT_B	:: distinct IDec_Ird1s
C_SEXT_B	:: distinct IDec_Ird1s
C_ZEXT_H	:: distinct IDec_Ird1s
C_SEXT_H	:: distinct IDec_Ird1s
C_ZEXT_W	:: distinct IDec_Ird1s
C_NOT		:: distinct IDec_Ird1s
C_J			:: distinct IDec_Simm
C_BEQZ		:: distinct IDec_Ir1s_Simm
C_BNEZ		:: distinct IDec_Ir1s_Simm

// Compressed Opcode 10 Instructions
C_SLLI		:: distinct IDec_Ird1s_Uimm
C_FLDSP		:: distinct IDec_Frd_Uimm
C_LWSP		:: distinct IDec_Ird_Uimm
C_LDSP		:: distinct IDec_Ird_Uimm
C_JR		:: distinct IDec_Ir1s
C_MV		:: distinct IDec_Ird2s
C_EBREAK	:: distinct IDec_Empty
C_JALR		:: distinct IDec_Ir1s
C_ADD		:: distinct IDec_Ird2s
C_FSDSP		:: distinct IDec_Fr1s_Uimm
C_SWSP		:: distinct IDec_Ir1s_Uimm
C_SDSP		:: distinct IDec_Ir1s_Uimm

// LOAD Opcode Instructions
LB			:: distinct IDec_Ird1s_Simm
LH			:: distinct IDec_Ird1s_Simm
LW			:: distinct IDec_Ird1s_Simm
LD			:: distinct IDec_Ird1s_Simm
LBU			:: distinct IDec_Ird1s_Simm
LHU			:: distinct IDec_Ird1s_Simm

// STORE Opcode Instructions
SB			:: distinct IDec_Ir2s_Simm
SH			:: distinct IDec_Ir2s_Simm
SW			:: distinct IDec_Ir2s_Simm
SD			:: distinct IDec_Ir2s_Simm

// MADD Opcode Instructions
FMADD_S		:: distinct IDec_Frd3s_Rm
FMADD_D		:: distinct IDec_Frd3s_Rm

// BRANCH Opcode Instructions
BEQ			:: distinct IDec_Ir2s_Simm
BNE			:: distinct IDec_Ir2s_Simm
BLT			:: distinct IDec_Ir2s_Simm
BGE			:: distinct IDec_Ir2s_Simm
BLTU		:: distinct IDec_Ir2s_Simm
BGEU		:: distinct IDec_Ir2s_Simm

// LOAD-FP Opcode Instructions
FLW			:: distinct IDec_Ir1s_Frd_Simm
FLD			:: distinct IDec_Ir1s_Frd_Simm

// STORE-FP Opcode Instructions
FSW			:: distinct IDec_Ir1s_Fr1s_Simm
FSD			:: distinct IDec_Ir1s_Fr1s_Simm

// MSUB Opcode Instructions
FMSUB_S		:: distinct IDec_Frd3s_Rm
FMSUB_D		:: distinct IDec_Frd3s_Rm

// JALR Opcode Instructions
JALR		:: distinct IDec_Ird1s_Simm

// NMSUB Opcode Instructions
FNMSUB_S	:: distinct IDec_Frd3s_Rm
FNMSUB_D	:: distinct IDec_Frd3s_Rm

// MISC-MEM Opcode Instructions
FENCE		:: distinct IDec_Ird1s_Fence
FENCE_TSO	:: distinct IDec_Ird1s
PAUSE		:: distinct IDec_Empty
FENCE_I		:: distinct IDec_Ird1s_Uimm

// AMO Opcode Instructions
AMOADD_W	:: distinct IDec_Ird2s_Amo
AMOSWAP_W	:: distinct IDec_Ird2s_Amo
LR_W		:: distinct IDec_Ird1s_Amo
SC_W		:: distinct IDec_Ird2s_Amo
AMOXOR_W	:: distinct IDec_Ird2s_Amo
AMOCAS_W	:: distinct IDec_Ird2s_Amo
AMOOR_W		:: distinct IDec_Ird2s_Amo
AMOAND_W	:: distinct IDec_Ird2s_Amo
AMOMIN_W	:: distinct IDec_Ird2s_Amo
AMOMAX_W	:: distinct IDec_Ird2s_Amo
AMOMINU_W	:: distinct IDec_Ird2s_Amo
AMOMAXU_W	:: distinct IDec_Ird2s_Amo
AMOADD_D	:: distinct IDec_Ird2s_Amo
AMOSWAP_D	:: distinct IDec_Ird2s_Amo
LR_D		:: distinct IDec_Ird1s_Amo
SC_D		:: distinct IDec_Ird2s_Amo
AMOXOR_D	:: distinct IDec_Ird2s_Amo
AMOCAS_D	:: distinct IDec_Ird2s_Amo
AMOOR_D		:: distinct IDec_Ird2s_Amo
AMOAND_D	:: distinct IDec_Ird2s_Amo
AMOMIN_D	:: distinct IDec_Ird2s_Amo
AMOMAX_D	:: distinct IDec_Ird2s_Amo
AMOMINU_D	:: distinct IDec_Ird2s_Amo
AMOMAXU_D	:: distinct IDec_Ird2s_Amo
AMOCAS_Q	:: distinct IDec_Ird2s_Amo

// NMADD Opcode Instructions
FNMADD_S	:: distinct IDec_Frd3s_Rm
FNMADD_D	:: distinct IDec_Frd3s_Rm

// JAL Opcode Instructions
JAL			:: distinct IDec_Ird_Simm

// OP-IMM Opcode Instructions
NOP			:: distinct IDec_Empty
ADDI		:: distinct IDec_Ird1s_Simm
SLLI		:: distinct IDec_Ird1s_Uimm
BSETI		:: distinct IDec_Ird1s_Uimm
BCLRI		:: distinct IDec_Ird1s_Uimm
CLZ			:: distinct IDec_Ird1s
CTZ			:: distinct IDec_Ird1s
CPOP		:: distinct IDec_Ird1s
SEXT_B		:: distinct IDec_Ird1s
SEXT_H		:: distinct IDec_Ird1s
BINVI		:: distinct IDec_Ird1s_Uimm
SLTI		:: distinct IDec_Ird1s_Simm
SLTIU		:: distinct IDec_Ird1s_Uimm
XORI		:: distinct IDec_Ird1s_Simm
SRLI		:: distinct IDec_Ird1s_Uimm
ORC_B		:: distinct IDec_Ird1s
SRAI		:: distinct IDec_Ird1s_Uimm
BEXTI		:: distinct IDec_Ird1s_Uimm
RORI		:: distinct IDec_Ird1s_Uimm
BREV8		:: distinct IDec_Ird1s
REV8		:: distinct IDec_Ird1s
ORI			:: distinct IDec_Ird1s_Simm
ANDI		:: distinct IDec_Ird1s_Simm

// OP Opcode Instructions
ADD			:: distinct IDec_Ird2s
MUL			:: distinct IDec_Ird2s
SUB			:: distinct IDec_Ird2s
SLL			:: distinct IDec_Ird2s
MULH		:: distinct IDec_Ird2s
CLMUL		:: distinct IDec_Ird2s
BSET		:: distinct IDec_Ird2s
BCLR		:: distinct IDec_Ird2s
ROL			:: distinct IDec_Ird2s
BINV		:: distinct IDec_Ird2s
SLT			:: distinct IDec_Ird2s
MULHSU		:: distinct IDec_Ird2s
CLMULR		:: distinct IDec_Ird2s
SH1ADD		:: distinct IDec_Ird2s
XPERM_N		:: distinct IDec_Ird2s
SLTU		:: distinct IDec_Ird2s
MULHU		:: distinct IDec_Ird2s
CLMULH		:: distinct IDec_Ird2s
XOR			:: distinct IDec_Ird2s
DIV			:: distinct IDec_Ird2s
PACK		:: distinct IDec_Ird2s
MIN			:: distinct IDec_Ird2s
SH2ADD		:: distinct IDec_Ird2s
XPERM_B		:: distinct IDec_Ird2s
XNOR		:: distinct IDec_Ird2s
SRL			:: distinct IDec_Ird2s
DIVU		:: distinct IDec_Ird2s
MINU		:: distinct IDec_Ird2s
CZERO_EQZ	:: distinct IDec_Ird2s
SRA			:: distinct IDec_Ird2s
BEXT		:: distinct IDec_Ird2s
ROR			:: distinct IDec_Ird2s
OR			:: distinct IDec_Ird2s
REM			:: distinct IDec_Ird2s
MAX			:: distinct IDec_Ird2s
SH3ADD		:: distinct IDec_Ird2s
ORN			:: distinct IDec_Ird2s
AND			:: distinct IDec_Ird2s
REMU		:: distinct IDec_Ird2s
PACKH		:: distinct IDec_Ird2s
MAXU		:: distinct IDec_Ird2s
CZERO_NEZ	:: distinct IDec_Ird2s
ANDN		:: distinct IDec_Ird2s

// OP-FP Opcode distinct
FADD_S		:: distinct IDec_Frd2s_Rm
FADD_D		:: distinct IDec_Frd2s_Rm
FSUB_S		:: distinct IDec_Frd2s_Rm
FSUB_D		:: distinct IDec_Frd2s_Rm
FMUL_S		:: distinct IDec_Frd2s_Rm
FMUL_D		:: distinct IDec_Frd2s_Rm
FDIV_S		:: distinct IDec_Frd2s_Rm
FDIV_D		:: distinct IDec_Frd2s_Rm
FSGNJ_S		:: distinct IDec_Frd2s
FSGNJN_S	:: distinct IDec_Frd2s
FSGNJX_S	:: distinct IDec_Frd2s
FSGNJ_D		:: distinct IDec_Frd2s
FSGNJN_D	:: distinct IDec_Frd2s
FSGNJX_D	:: distinct IDec_Frd2s
FMIN_S		:: distinct IDec_Frd2s
FMAX_S		:: distinct IDec_Frd2s
FMINM_S		:: distinct IDec_Frd2s
FMAXM_S		:: distinct IDec_Frd2s
FMIN_D		:: distinct IDec_Frd2s
FMAX_D		:: distinct IDec_Frd2s
FMINM_D		:: distinct IDec_Frd2s
FMAXM_D		:: distinct IDec_Frd2s
FCVT_S_D	:: distinct IDec_Frd1s_Rm
FROUND_S	:: distinct IDec_Frd1s_Rm
FROUNDNX_S	:: distinct IDec_Frd1s_Rm
FCVT_D_S	:: distinct IDec_Frd1s_Rm
FROUND_D	:: distinct IDec_Frd1s_Rm
FROUNDNX_D	:: distinct IDec_Frd1s_Rm
FSQRT_S		:: distinct IDec_Frd1s_Rm
FSQRT_D		:: distinct IDec_Frd1s_Rm
FLE_S		:: distinct IDec_Ird_Fr2s
FLT_S		:: distinct IDec_Ird_Fr2s
FEQ_S		:: distinct IDec_Ird_Fr2s
FLEQ_S		:: distinct IDec_Ird_Fr2s
FLTQ_S		:: distinct IDec_Ird_Fr2s
FLE_D		:: distinct IDec_Ird_Fr2s
FLT_D		:: distinct IDec_Ird_Fr2s
FEQ_D		:: distinct IDec_Ird_Fr2s
FLEQ_D		:: distinct IDec_Ird_Fr2s
FLTQ_D		:: distinct IDec_Ird_Fr2s
FCVT_W_S	:: distinct IDec_Ird_Fr1s_Rm
FCVT_WU_S	:: distinct IDec_Ird_Fr1s_Rm
FCVT_L_S	:: distinct IDec_Ird_Fr1s_Rm
FCVT_LU_S	:: distinct IDec_Ird_Fr1s_Rm
FCVT_W_D	:: distinct IDec_Ird_Fr1s_Rm
FCVT_WU_D	:: distinct IDec_Ird_Fr1s_Rm
FCVT_L_D	:: distinct IDec_Ird_Fr1s_Rm
FCVT_LU_D	:: distinct IDec_Ird_Fr1s_Rm
FCVTMOD_W_D	:: distinct IDec_Ird_Fr1s_Rm
FCVT_S_W	:: distinct IDec_Ir1s_Frd_Rm
FCVT_S_WU	:: distinct IDec_Ir1s_Frd_Rm
FCVT_S_L	:: distinct IDec_Ir1s_Frd_Rm
FCVT_S_LU	:: distinct IDec_Ir1s_Frd_Rm
FCVT_D_W	:: distinct IDec_Ir1s_Frd_Rm
FCVT_D_WU	:: distinct IDec_Ir1s_Frd_Rm
FCVT_D_L	:: distinct IDec_Ir1s_Frd_Rm
FCVT_D_LU	:: distinct IDec_Ir1s_Frd_Rm
FMV_X_W		:: distinct IDec_Ird_Fr1s
FCLASS_S	:: distinct IDec_Ird_Fr1s
FMV_X_D		:: distinct IDec_Ird_Fr1s
FCLASS_D	:: distinct IDec_Ird_Fr1s
FMV_W_X		:: distinct IDec_Ir1s_Frd
FLI_S		:: distinct IDec_Frd_Uimm
FMV_D_X		:: distinct IDec_Ir1s_Frd
FLI_D		:: distinct IDec_Frd_Uimm

// SYSTEM
ECALL		:: distinct IDec_Empty
EBREAK		:: distinct IDec_Empty
WRS_NTO		:: distinct IDec_Empty
WRS_STO		:: distinct IDec_Empty
CSRRW		:: distinct IDec_Ird1s_Csr
CSRRS		:: distinct IDec_Ird1s_Csr
CSRRC		:: distinct IDec_Ird1s_Csr
CSRRWI		:: distinct IDec_Ird_Csr_Uimm
CSRRSI		:: distinct IDec_Ird_Csr_Uimm
CSRRCI		:: distinct IDec_Ird_Csr_Uimm

// AUIPC Opcode Instructions
AUIPC		:: distinct IDec_Ird_Simm

// LUI Opcode Instructions
LUI			:: distinct IDec_Ird_Simm

// OP-IMM-32 Opcode Instructions
ADDIW		:: distinct IDec_Ird1s_Simm
SLLIW		:: distinct IDec_Ird1s_Uimm
SLLI_UW		:: distinct IDec_Ird1s_Uimm
CLZW		:: distinct IDec_Ird1s
CTZW		:: distinct IDec_Ird1s
CPOPW		:: distinct IDec_Ird1s
SRLIW		:: distinct IDec_Ird1s_Uimm
SRAIW		:: distinct IDec_Ird1s_Uimm
RORIW		:: distinct IDec_Ird1s_Uimm

// OP-32 Opcode Instructions
ADDW		:: distinct IDec_Ird2s
MULW		:: distinct IDec_Ird2s
ADD_UW		:: distinct IDec_Ird2s
SUBW		:: distinct IDec_Ird2s
SLLW		:: distinct IDec_Ird2s
ROLW		:: distinct IDec_Ird2s
SH1ADD_UW	:: distinct IDec_Ird2s
DIVW		:: distinct IDec_Ird2s
ZEXT_H		:: distinct IDec_Ird1s
SH2ADD_UW	:: distinct IDec_Ird2s
SRLW		:: distinct IDec_Ird2s
DIVUW		:: distinct IDec_Ird2s
SRAW		:: distinct IDec_Ird2s
RORW		:: distinct IDec_Ird2s
REMW		:: distinct IDec_Ird2s
SH3ADD_UW	:: distinct IDec_Ird2s
REMUW		:: distinct IDec_Ird2s

