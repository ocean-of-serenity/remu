
package decoder


import "core:fmt"


IntReg :: enum u8 {
	x0,  x1,  x2,  x3,  x4,  x5,  x6,  x7,
	x8,  x9,  x10, x11, x12, x13, x14, x15,
	x16, x17, x18, x19, x20, x21, x22, x23,
	x24, x25, x26, x27, x28, x29, x30, x31,
	pc,
}


FloatReg :: enum u8 {
	f0,  f1,  f2,   f3,  f4,  f5,  f6,  f7,
	f8,  f9,  f10, f11, f12, f13, f14, f15,
	f16, f17, f18, f19, f20, f21, f22, f23,
	f24, f25, f26, f27, f28, f29, f30, f31,
}


InsnType :: enum {
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
	C_SLLI,
	C_FLDSP,
	C_LDSP,
	C_JR,
	C_MV,
	C_EBREAK,
	C_JALR,
	C_ADD,
	C_FSDSP,
	C_SWSP,
	C_SDSP,
	LB,
	LH,
	LW,
	LD,
	LBU,
	LHU,
	SB,
	SH,
	SW,
	SD,
	FMADD_S,
	FMADD_D,
	BEQ,
	BNE,
	BLT,
	BGE,
	BLTU,
	BGEU,
	FLW,
	FLD,
	FSW,
	FSD,
	FMSUB_S,
	FMSUB_D,
	JALR,
	FNMSUB_S,
	FNMSUB_D,
	FENCE,
	FENCE_TSO,
	PAUSE,
	FENCE_I,
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
	FNMADD_S,
	FNMADD_D,
	JAL,
	NOP,
	ADDI,
	SLLI,
	BSETI,
	BCLRI,
	BINVI,
	CLZ,
	CTZ,
	CPOP,
	SEXT_B,
	SEXT_H,
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
	AUIPC,
	LUI,
	ADDIW,
	SLLIW,
	SLLI_UW,
	CLZW,
	CTZW,
	CPOPW,
	SRLIW,
	SRAIW,
	RORIW,
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
	ILLEGAL
}


InsnDecoded :: struct {
	type: InsnType,
	ird, irs1, irs2, irs3: IntReg,
	frd, frs1, frs2, frs3: FloatReg,
	uimm: u64le,
	imm:  i64le,
	csr:  u64le
}


Insn16BaseEnc :: bit_field u16le {
	opc:	u8 | 2,
	pad0:	u8 | 8,
	pad1:	u8 | 3,
	funct3:	u8 | 3
}


Insn16FmtCIW :: bit_field u16le {
	opc:	u8 | 2,
	uimm:	u8 | 8,
	rd:		u8 | 3,
	funct3:	u8 | 3
}


decode_insn :: proc(id: ^InsnDecoded, memory: [^]u8) {
	id^ = InsnDecoded{type = InsnType.ILLEGAL}

	switch memory[0] & 0b11 {
		case 0b00:
			fmt.println("got 16 bit C extension Quadrant 0 Type Instruction")

			insn := transmute(Insn16BaseEnc) (cast(^u16le) &memory[0])^

			if	insn.opc == 0	&& insn.funct3 == 0 &&
				insn.pad0 == 0	&& insn.pad1 == 0 {
				return 
			}

			switch insn.funct3 {
				case 0b000:
					insn := transmute(Insn16FmtCIW) insn

					if insn.rd == 0 || insn.uimm == 0 {
						return 
					}

					id.type = InsnType.C_ADDI4SPN
					id.uimm =u64le(
						(insn.uimm & 0b00000010) |
						(insn.uimm & 0b00000001) << 2 |
						(insn.uimm & 0b11000000) >> 3 |
						(insn.uimm & 0b00111100) << 2
					) 
					id.ird = IntReg(insn.rd + 8)
					return

				case 0b001:
				case 0b010:
				case 0b011:
				case 0b100:
				case 0b101:
				case 0b110:
				case 0b111:
			}

		case 0b01:
			fmt.println("got 16 bit C extension Quadrant 0 Type Instruction")
		case 0b10:
			fmt.println("got 16 bit C extension Quadrant 0 Type Instruction")
		case 0b11:
			fmt.println("got 32 bit Type Instruction")
	}
}


main :: proc() {
	memory: [128]u8 = 0
	w16: ^u16le
	w32: ^u32le
	id: InsnDecoded


	w16 = cast(^u16le)&memory[0]
	w16^ = 0b010_000_001_01_001_00					// 'C.LW x8 2(x7)'
	w32 = cast(^u32le)&memory[2]
	w32^ = 0b0000001_00011_00101_000_00011_0110011	// 'MUL x3 x5 x3'
	w32 = cast(^u32le)&memory[6]
	w32^ = 0b0000001_00011_00101_000_00011_0110011	// 'MUL x3 x5 x3'


	decode_insn(&id, raw_data(memory[0:]))
	fmt.println(id)
	decode_insn(&id, raw_data(memory[2:]))
	fmt.println(id)
	decode_insn(&id, raw_data(memory[6:]))
	fmt.println(id)
}

