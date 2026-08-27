
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
			return // ILLEGAL{}
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

			if ie.funct1 == 1 do return // ILLEGAL{}

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

	return // ILLEGAL{}
}


handle_i16opc_q1 :: proc(ie: I16_Base) -> (id: IDec = ILLEGAL{}) {
	switch ie.funct3 {
	case 0x0:
		C_ADDI_ENC :: bit_field u16le {
			opc:		u8 | 2,
			imm0to4:	u8 | 5,
			rd_rs1:		u8 | 5,
			imm5:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_ADDI_ENC) ie

		if ie.rd_rs1 == 0 {
			return C_NOP{}
		}
		else if ie.imm0to4 == 0 && ie.imm5 == 0 {
			return
			// return HINT{} TODO handle hints
		}

		UIMM_DEC :: bit_field u8 {
			imm0to4:	u8 | 5,
			imm5:		u8 | 1
		}

		return C_ADDI{
			rd	= Reg64(ie.rd_rs1),
			rs1	= Reg64(ie.rd_rs1),
			imm	= sign_extend_to_i64le(
				u64le(UIMM_DEC{
					imm0to4	= ie.imm0to4,
					imm5	= ie.imm5
				}),
				6
			)
		}

	case 0x1:
		C_ADDIW_ENC :: bit_field u16le {
			opc:		u8 | 2,
			imm0to4:	u8 | 5,
			rd_rs1:		u8 | 5,
			imm5:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_ADDIW_ENC) ie

		UIMM_DEC :: bit_field u8 {
			imm0to4:	u8 | 5,
			imm5:		u8 | 1
		}

		return C_ADDIW{
			rd	= Reg64(ie.rd_rs1),
			rs1	= Reg64(ie.rd_rs1),
			imm	= sign_extend_to_i64le(
				u64le(UIMM_DEC{
					imm0to4	= ie.imm0to4,
					imm5	= ie.imm5
				}),
				6
			)
		}

	case 0x2:
		C_LI_ENC :: bit_field u16le {
			opc:		u8 | 2,
			imm0to4:	u8 | 5,
			rd:			u8 | 5,
			imm5:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_LI_ENC) ie

		if ie.rd == 0 {
			return
			// return HINT{} TODO handle hints
		}

		UIMM_DEC :: bit_field u8 {
			imm0to4:	u8 | 5,
			imm5:		u8 | 1
		}

		return C_LI{
			rd	= Reg64(ie.rd),
			imm	= sign_extend_to_i64le(
				u64le(UIMM_DEC{
					imm0to4	= ie.imm0to4,
					imm5	= ie.imm5
				}),
				6
			)
		}

	case 0x3:
		I16_Base_Rd :: bit_field u16le {
			opc:		u8 | 2,
			pad1:		u8 | 5,
			rd:			u8 | 5,
			pad2:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(I16_Base_Rd) ie

		if ie.pad1 == 0 && ie.pad2 == 0 {
			return // ILLEGAL{}
		}

		if ie.rd == 0 {
			return
			// return HINT{} TODO handle hints
		}
		else if ie.rd == 2 {
			C_ADDI16SP_ENC :: bit_field u16le {
				opc:		u8 | 2,
				imm5:		u8 | 1,
				imm7to8:	u8 | 2,
				imm6:		u8 | 1,
				imm4:		u8 | 1,
				rd:			u8 | 5,
				imm9:		u8 | 1,
				funct3:		u8 | 3
			}

			ie := transmute(C_ADDI16SP_ENC) ie

			UIMM_DEC :: bit_field u32le {
				imm0to3:	u8		| 4,
				imm4:		u8		| 1,
				imm5:		u8		| 1,
				imm6:		u8		| 1,
				imm7to8:	u8		| 2,
				imm9:		u8		| 1,
				imm10to31:	u32le	| 22
			}

			return C_ADDI16SP{
				rd	= Reg64(ie.rd),
				imm	= sign_extend_to_i64le(
					u64le(UIMM_DEC{
						imm0to3		= 0,
						imm4		= ie.imm4,
						imm5		= ie.imm5,
						imm6		= ie.imm6,
						imm7to8		= ie.imm7to8,
						imm9		= ie.imm9,
						imm10to31	= 0
					}),
					10
				)
			}
		}
		else {
			C_LUI_ENC :: bit_field u16le {
				opc:		u8 | 2,
				imm12to16:	u8 | 5,
				rd:			u8 | 5,
				imm17:		u8 | 1,
				funct3:		u8 | 3
			}

			ie := transmute(C_LUI_ENC) ie

			UIMM_DEC :: bit_field u32le {
				imm0to11:	u16le	| 12,
				imm12to16:	u8		| 5,
				imm17:		u8		| 1,
				imm18to31:	u16le	| 14
			}

			return C_LUI{
				rd	= Reg64(ie.rd),
				imm	= sign_extend_to_i64le(
					u64le(UIMM_DEC{
						imm0to11	= 0,
						imm12to16	= ie.imm12to16,
						imm17		= ie.imm17,
						imm18to31	= 0
					}),
					18
				)
			}
		}

	case 0x4:
		I16_Base_Funct2 :: bit_field u16le {
			opc:		u8 | 2,
			uimm0to4:	u8 | 5,
			rd_rs1_r:	u8 | 3,
			funct2:		u8 | 2,
			uimm5:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(I16_Base_Funct2) ie

		UIMM_DEC :: bit_field u8 {
			uimm0to4:	u8	| 5,
			uimm5:		u8	| 1,
		}

		switch ie.funct2 {
		case 0x0:
			if ie.uimm0to4 == 0 && ie.uimm5 == 0 {
				return
				// return HINT{} TODO handle hints
			}

			return C_SRLI{
				rd		= Reg64(ie.rd_rs1_r) + Reg64.x7,
				rs1		= Reg64(ie.rd_rs1_r) + Reg64.x7,
				uimm	= u64le(UIMM_DEC{
					uimm0to4	= ie.uimm0to4,
					uimm5		= ie.uimm5
				}),
			}

		case 0x1:
			if ie.uimm0to4 == 0 && ie.uimm5 == 0 {
				return
				// return HINT{} TODO handle hints
			}

			return C_SRAI{
				rd		= Reg64(ie.rd_rs1_r) + Reg64.x7,
				rs1		= Reg64(ie.rd_rs1_r) + Reg64.x7,
				uimm	= u64le(UIMM_DEC{
					uimm0to4	= ie.uimm0to4,
					uimm5		= ie.uimm5
				}),
			}

		case 0x2:
			if ie.uimm0to4 == 0 && ie.uimm5 == 0 {
				return
				// return HINT{} TODO handle hints
			}

			return C_ANDI{
				rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
				rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7,
				imm	= sign_extend_to_i64le(
					u64le(UIMM_DEC{
						uimm0to4	= ie.uimm0to4,
						uimm5		= ie.uimm5
					}),
					6
				)
			}

		case 0x3:
			I16_Base_Funct1 :: bit_field u16le {
				opc:		u8 | 2,
				rs2_r:		u8 | 3,
				funct2_2:	u8 | 2,
				rd_rs1_r:	u8 | 3,
				funct2_1:	u8 | 2,
				funct1:		u8 | 1,
				funct3:		u8 | 3
			}

			ie := transmute(I16_Base_Funct1) ie

			switch ie.funct1 {
			case 0x0:
				switch ie.funct2_2 {
				case 0x0:
					return C_SUB{
						rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs2	= Reg64(ie.rs2_r) + Reg64.x7
					}

				case 0x1:
					return C_XOR{
						rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs2	= Reg64(ie.rs2_r) + Reg64.x7
					}

				case 0x2:
					return C_OR{
						rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs2	= Reg64(ie.rs2_r) + Reg64.x7
					}

				case 0x3:
					return C_AND{
						rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs2	= Reg64(ie.rs2_r) + Reg64.x7
					}

				}

			case 0x1:
				switch ie.funct2_2 {
				case 0x0:
					return C_SUBW{
						rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs2	= Reg64(ie.rs2_r) + Reg64.x7
					}

				case 0x1:
					return C_ADDW{
						rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs2	= Reg64(ie.rs2_r) + Reg64.x7
					}

				case 0x2:
					return C_MUL{
						rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7,
						rs2	= Reg64(ie.rs2_r) + Reg64.x7
					}

				case 0x3:
					switch ie.rs2_r {
					case 0x0:
						return C_ZEXT_B{
							rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
							rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7
						}

					case 0x1:
						return C_SEXT_B{
							rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
							rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7
						}

					case 0x2:
						return C_ZEXT_H{
							rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
							rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7
						}

					case 0x3:
						return C_SEXT_H{
							rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
							rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7
						}

					case 0x4:
						return C_ZEXT_W{
							rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
							rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7
						}

					case 0x5:
						return C_NOT{
							rd	= Reg64(ie.rd_rs1_r) + Reg64.x7,
							rs1	= Reg64(ie.rd_rs1_r) + Reg64.x7
						}
					// case 0x6, 0x7 => ILLEGAL{}
					}
				}
			}
		}

	case 0x5:
		C_J_ENC :: bit_field u16le {
			opc:		u8 | 2,
			imm5:		u8 | 1,
			imm1to3:	u8 | 3,
			imm7:		u8 | 1,
			imm6:		u8 | 1,
			imm10:		u8 | 1,
			imm8to9:	u8 | 2,
			imm4:		u8 | 1,
			imm11:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_J_ENC) ie

		UIMM_DEC :: bit_field u16le {
			imm0:		u8 | 1,
			imm1to3:	u8 | 3,
			imm4:		u8 | 1,
			imm5:		u8 | 1,
			imm6:		u8 | 1,
			imm7:		u8 | 1,
			imm8to9:	u8 | 2,
			imm10:		u8 | 1,
			imm11:		u8 | 1,
		}

		return C_J{
			imm = sign_extend_to_i64le(
				u64le(UIMM_DEC{
					imm0	= 0,
					imm1to3	= ie.imm1to3,
					imm4	= ie.imm4,
					imm5	= ie.imm5,
					imm6	= ie.imm6,
					imm7	= ie.imm7,
					imm8to9	= ie.imm8to9,
					imm10	= ie.imm10,
					imm11	= ie.imm11
				}),
				12
			)
		}

	case 0x6:
		C_BEQZ_ENC :: bit_field u16le {
			opc:		u8 | 2,
			imm5:		u8 | 1,
			imm1to2:	u8 | 2,
			imm6to7:	u8 | 2,
			rs1_r:		u8 | 3,
			imm3to4:	u8 | 2,
			imm8:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_BEQZ_ENC) ie

		UIMM_DEC :: bit_field u16le {
			imm0:		u8 | 1,
			imm1to2:	u8 | 2,
			imm3to4:	u8 | 2,
			imm5:		u8 | 1,
			imm6to7:	u8 | 2,
			imm8:		u8 | 1,
			imm9to15:	u8 | 7
		}

		return C_BEQZ{
			rs1	= Reg64(ie.rs1_r) + Reg64.x7,
			imm = sign_extend_to_i64le(
				u64le(UIMM_DEC{
					imm0		= 0,
					imm1to2		= ie.imm1to2,
					imm3to4		= ie.imm3to4,
					imm5		= ie.imm5,
					imm6to7		= ie.imm6to7,
					imm8		= ie.imm8,
					imm9to15	= 0
				}),
				9
			)
		}

	case 0x7:
		C_BNEZ_ENC :: bit_field u16le {
			opc:		u8 | 2,
			imm5:		u8 | 1,
			imm1to2:	u8 | 2,
			imm6to7:	u8 | 2,
			rs1_r:		u8 | 3,
			imm3to4:	u8 | 2,
			imm8:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_BNEZ_ENC) ie

		UIMM_DEC :: bit_field u16le {
			imm0:		u8 | 1,
			imm1to2:	u8 | 2,
			imm3to4:	u8 | 2,
			imm5:		u8 | 1,
			imm6to7:	u8 | 2,
			imm8:		u8 | 1,
			imm9to15:	u8 | 7
		}

		return C_BNEZ{
			rs1	= Reg64(ie.rs1_r) + Reg64.x7,
			imm = sign_extend_to_i64le(
				u64le(UIMM_DEC{
					imm0		= 0,
					imm1to2		= ie.imm1to2,
					imm3to4		= ie.imm3to4,
					imm5		= ie.imm5,
					imm6to7		= ie.imm6to7,
					imm8		= ie.imm8,
					imm9to15	= 0
				}),
				9
			)
		}
	}

	return // ILLEGAL{}
}


handle_i16opc_q2 :: proc(ie: I16_Base) -> (id: IDec = ILLEGAL{}) {
	switch ie.funct3 {
	case 0x0:
		C_SLLI_ENC :: bit_field u16le {
			opc:		u8 | 2,
			uimm0to4:	u8 | 5,
			rd_rs1:		u8 | 5,
			uimm5:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_SLLI_ENC) ie

		if ie.rd_rs1 == 0 || (ie.uimm0to4 == 0 && ie.uimm5 == 0) {
			return
			// HINT{} TODO handle hints
		}

		UIMM_DEC :: bit_field u8 {
			uimm0to4:	u8 | 5,
			uimm5:		u8 | 1
		}

		return C_SLLI{
			rd		= Reg64(ie.rd_rs1),
			rs1		= Reg64(ie.rd_rs1),
			uimm	= u64le(UIMM_DEC{
				uimm0to4	= ie.uimm0to4,
				uimm5		= ie.uimm5
			})
		}

	case 0x1:
		C_FLDSP_ENC :: bit_field u16le {
			opc:		u8 | 2,
			uimm6to8:	u8 | 3,
			uimm3to4:	u8 | 2,
			rd:			u8 | 5,
			uimm5:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_FLDSP_ENC) ie

		UIMM_DEC :: bit_field u16le {
			uimm0to2:	u8 | 3,
			uimm3to4:	u8 | 2,
			uimm5:		u8 | 1,
			uimm6to8:	u8 | 3,
			uimm9to15:	u8 | 7
		}

		return C_FLDSP{
			rd		= Reg64(ie.rd),
			uimm	= u64le(UIMM_DEC{
				uimm0to2	= 0,
				uimm3to4	= ie.uimm3to4,
				uimm5		= ie.uimm5,
				uimm6to8	= ie.uimm6to8,
				uimm9to15	= 0
			})
		}

	case 0x2:
		C_LWSP_ENC :: bit_field u16le {
			opc:		u8 | 2,
			uimm6to7:	u8 | 2,
			uimm2to4:	u8 | 3,
			rd:			u8 | 5,
			uimm5:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_LWSP_ENC) ie

		if ie.rd == 0 {
			return // ILLEGAL{}
		}

		UIMM_DEC :: bit_field u8 {
			uimm0to1:	u8 | 2,
			uimm2to4:	u8 | 3,
			uimm5:		u8 | 1,
			uimm6to7:	u8 | 2
		}

		return C_LWSP{
			rd		= Reg64(ie.rd),
			uimm	= u64le(UIMM_DEC{
				uimm0to1	= 0,
				uimm2to4	= ie.uimm2to4,
				uimm5		= ie.uimm5,
				uimm6to7	= ie.uimm6to7
			})
		}

	case 0x3:
		C_LDSP_ENC :: bit_field u16le {
			opc:		u8 | 2,
			uimm6to8:	u8 | 3,
			uimm3to4:	u8 | 2,
			rd:			u8 | 5,
			uimm5:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(C_LDSP_ENC) ie

		if ie.rd == 0 {
			return // ILLEGAL{}
		}

		UIMM_DEC :: bit_field u16le {
			uimm0to2:	u8 | 3,
			uimm3to4:	u8 | 2,
			uimm5:		u8 | 1,
			uimm6to8:	u8 | 3,
			uimm9to15:	u8 | 7
		}

		return C_LDSP{
			rd		= Reg64(ie.rd),
			uimm	= u64le(UIMM_DEC{
				uimm0to2	= 0,
				uimm3to4	= ie.uimm3to4,
				uimm5		= ie.uimm5,
				uimm6to8	= ie.uimm6to8,
				uimm9to15	= 0
			})
		}

	case 0x4:
		I16_FMT_CR :: bit_field u16le {
			opc:		u8 | 2,
			rs2:		u8 | 5,
			rd_rs1:		u8 | 5,
			funct1:		u8 | 1,
			funct3:		u8 | 3
		}

		ie := transmute(I16_FMT_CR) ie

		switch ie.funct1 {
		case 0x0:
			if ie.rd_rs1 == 0 && ie.rs2 == 0 {
				return
				// HINT{} TODO handle hints
			}
			else if ie.rd_rs1 != 0 && ie.rs2 != 0 {
				return C_MV{
					rd	= Reg64(ie.rd_rs1),
					rs1	= Reg64(ie.rd_rs1),
					rs2	= Reg64(ie.rs2)
				}
			}
			else if ie.rd_rs1 != 0 && ie.rs2 == 0 {
				return C_JR{
					rs1 = Reg64(ie.rd_rs1)
				}
			}
			else {
				return // ILLEGAL{}
			}

		case 0x1:
			if ie.rd_rs1 == 0 && ie.rs2 == 0 {
				return C_EBREAK{}
			}
			else if ie.rd_rs1 != 0 && ie.rs2 != 0 {
				return C_ADD{
					rd	= Reg64(ie.rd_rs1),
					rs1	= Reg64(ie.rd_rs1),
					rs2	= Reg64(ie.rs2)
				}
			}
			else if ie.rd_rs1 != 0 && ie.rs2 == 0 {
				return C_JALR {
					rs1 = Reg64(ie.rd_rs1)
				}
			}
			else {
				return
				// HINT{} TODO handle hints
			}
		}

	case 0x5:
		C_FSDSP_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rs1:		u8 | 5,
			uimm6to8:	u8 | 3,
			uimm3to5:	u8 | 3,
			funct3:		u8 | 3
		}

		ie := transmute(C_FSDSP_ENC) ie

		UIMM_DEC :: bit_field u16le {
			uimm0to2:	u8 | 3,
			uimm3to5:	u8 | 3,
			uimm6to8:	u8 | 3,
			uimm9to15:	u8 | 7
		}

		return C_FSDSP{
			rs1		= Reg64(ie.rs1),
			uimm	= u64le(UIMM_DEC{
				uimm0to2	= 0,
				uimm3to5	= ie.uimm3to5,
				uimm6to8	= ie.uimm6to8,
				uimm9to15	= 0
			})
		}

	case 0x6:
		C_SWSP_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rs1:		u8 | 5,
			uimm6to7:	u8 | 2,
			uimm2to5:	u8 | 4,
			funct3:		u8 | 3
		}

		ie := transmute(C_SWSP_ENC) ie

		UIMM_DEC :: bit_field u8 {
			uimm0to1:	u8 | 2,
			uimm2to5:	u8 | 4,
			uimm6to7:	u8 | 2
		}

		return C_SWSP{
			rs1		= Reg64(ie.rs1),
			uimm	= u64le(UIMM_DEC{
				uimm0to1	= 0,
				uimm2to5	= ie.uimm2to5,
				uimm6to7	= ie.uimm6to7,
			})
		}

	case 0x7:
		C_SDSP_ENC :: bit_field u16le {
			opc:		u8 | 2,
			rs1:		u8 | 5,
			uimm6to8:	u8 | 3,
			uimm3to5:	u8 | 3,
			funct3:		u8 | 3
		}

		ie := transmute(C_SDSP_ENC) ie

		UIMM_DEC :: bit_field u16le {
			uimm0to2:	u8 | 3,
			uimm3to5:	u8 | 3,
			uimm6to8:	u8 | 3,
			uimm9to15:	u8 | 7
		}

		return C_SDSP{
			rs1		= Reg64(ie.rs1),
			uimm	= u64le(UIMM_DEC{
				uimm0to2	= 0,
				uimm3to5	= ie.uimm3to5,
				uimm6to8	= ie.uimm6to8,
				uimm9to15	= 0
			})
		}


	}

	return // ILLEGAL{}
}


handle_i32opc_load :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
}


handle_i32opc_store :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
}


handle_i32opc_madd :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
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

	return // ILLEGAL{}
}


handle_i32opc_load_fp :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
}


handle_i32opc_store_fp :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
}


handle_i32opc_msub :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
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

	if ie.funct3 != 0 do return // ILLEGAL{}

	return JALR{
		rd	= Reg64(ie.rd),
		rs1	= Reg64(ie.rs1),
		imm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
	}
}


handle_i32opc_nmsub :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
}


handle_i32opc_misc_mem :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
}


handle_i32opc_amo :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
}


handle_i32opc_nmadd :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
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
				uimm	= u64le(ie.imm0to5)
			}

		case 0x0A:
			return BSETI{
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x12:
			return BCLRI{
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x18:
			ie := transmute(I32_FMT_I_FUNCT7) ie

			if ie.funct7 & 1 != 0 do return // ILLEGAL{}

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
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.imm0to5)
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
				uimm	= u64le(ie.imm0to5)
			}

		case 0x0A:
			ie := transmute(I32_FMT_I_FUNCT6) ie

			if ie.funct6_2 != 0x07 do return // ILLEGAL{}

			return ORC_B{
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1)
			}

		case 0x10:
			return SRAI{
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x12:
			return BEXTI{
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x18:
			return RORI{
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.imm0to5)
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

	return // ILLEGAL{}
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

	return // ILLEGAL{}
}


handle_i32opc_op_fp :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_R :: bit_field u32le {
		opc:	u8 | 7,
		rd:		u8 | 5,
		funct3:	u8 | 3,
		rs1:	u8 | 5,
		rs2:	u8 | 5,
		funct7:	u8 | 7
	}

	ie := transmute(I32_FMT_R) ie

	switch ie.funct7 {
	case 0x00:
		return FADD_S {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			rs2		= Reg64(ie.rs2 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x01:
		return FADD_D {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			rs2		= Reg64(ie.rs2 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x04:
		return FSUB_S {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			rs2		= Reg64(ie.rs2 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x05:
		return FSUB_D {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			rs2		= Reg64(ie.rs2 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x08:
		return FMUL_S {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			rs2		= Reg64(ie.rs2 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x09:
		return FMUL_D {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			rs2		= Reg64(ie.rs2 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x0B:
		return FDIV_S {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			rs2		= Reg64(ie.rs2 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x0C:
		return FDIV_D {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			rs2		= Reg64(ie.rs2 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x10:
		switch ie.funct3 {
		case 0x0:
			return FSGNJ_S {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x1:
			return FSGNJN_S {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x2:
			return FSGNJX_S {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}
		}

	case 0x11:
		switch ie.funct3 {
		case 0x0:
			return FSGNJ_D {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x1:
			return FSGNJN_D {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x2:
			return FSGNJX_D {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}
		}

	case 0x14:
		switch ie.funct3 {
		case 0x0:
			return FMIN_S {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x1:
			return FMAX_S {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x2:
			return FMINM_S {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x3:
			return FMAXM_S {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}
		}

	case 0x15:
		switch ie.funct3 {
		case 0x0:
			return FMIN_D {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x1:
			return FMAX_D {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x2:
			return FMINM_D {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}

		case 0x3:
			return FMAXM_D {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs2 + 32),
			}
		}

	case 0x20:
		switch ie.rs2 {
		case 0x01:
			return FCVT_S_D {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}

		case 0x04:
			return FROUND_S {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}

		case 0x05:
			return FROUNDNX_S {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}
		}

	case 0x21:
		switch ie.rs2 {
		case 0x00:
			return FCVT_D_S {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}

		case 0x04:
			return FROUND_D {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}

		case 0x05:
			return FROUNDNX_D {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}
		}

	case 0x2B:
		return FSQRT_S {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x2C:
		return FSQRT_D {
			rd		= Reg64(ie.rd + 32),
			rs1		= Reg64(ie.rs1 + 32),
			uimm	= u64le(ie.funct3)
		}

	case 0x50:
		switch ie.funct3 {
		case 0x0:
			return FLE_S {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}

		case 0x1:
			return FLT_S {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}

		case 0x2:
			return FEQ_S {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}

		case 0x4:
			return FLEQ_S {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}

		case 0x5:
			return FLTQ_S {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}
		}

	case 0x51:
		switch ie.funct3 {
		case 0x0:
			return FLE_D {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}

		case 0x1:
			return FLT_D {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}

		case 0x2:
			return FEQ_D {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}

		case 0x4:
			return FLEQ_D {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}

		case 0x5:
			return FLTQ_D {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32),
				rs2	= Reg64(ie.rs1 + 32)
			}
		}

	case 0x60:
		switch ie.rs2 {
		case 0x00:
			return FCVT_W_S {
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}

		case 0x01:
			return FCVT_WU_S {
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}


		case 0x02:
			return FCVT_L_S {
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}


		case 0x03:
			return FCVT_LU_S {
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}


		}

	case 0x61:
		switch ie.rs2 {
		case 0x00:
			return FCVT_W_D {
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}

		case 0x01:
			return FCVT_WU_D {
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}


		case 0x02:
			return FCVT_L_D {
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}

		case 0x03:
			return FCVT_LU_D {
				rd		= Reg64(ie.rd),
				rs1		= Reg64(ie.rs1 + 32),
				uimm	= u64le(ie.funct3)
			}

		case 0x08:
			if ie.funct3 != 0x1 do return // ILLEGAL{}

			return FCVTMOD_W_D {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32)
			}
		}

	case 0x68:
		switch ie.rs2 {
		case 0x00:
			return FCVT_S_W {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.funct3)
			}

		case 0x01:
			return FCVT_S_WU {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.funct3)
			}


		case 0x02:
			return FCVT_S_L {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.funct3)
			}


		case 0x03:
			return FCVT_S_LU {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.funct3)
			}
		}

	case 0x69:
		switch ie.rs2 {
		case 0x00:
			return FCVT_D_W {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.funct3)
			}

		case 0x01:
			return FCVT_D_WU {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.funct3)
			}


		case 0x02:
			return FCVT_D_L {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.funct3)
			}


		case 0x03:
			return FCVT_D_LU {
				rd		= Reg64(ie.rd + 32),
				rs1		= Reg64(ie.rs1),
				uimm	= u64le(ie.funct3)
			}
		}

	case 0x70:
		switch ie.funct3 {
		case 0x0:
			return FMV_X_W {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32)
			}

		case 0x1:
			return FCLASS_S {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32)
			}
		}

	case 0x71:
		switch ie.funct3 {
		case 0x0:
			return FMV_X_D {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32)
			}
		case 0x1:
			return FCLASS_D {
				rd	= Reg64(ie.rd),
				rs1	= Reg64(ie.rs1 + 32)
			}
		}

	case 0x78:
		switch ie.rs2 {
		case 0x00:
			return FMV_W_X {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1)
			}
		case 0x01:
			return FLI_S {
				rd		= Reg64(ie.rd + 32),
				uimm	= u64le(ie.rs1)
			}
		}

	case 0x79:
		switch ie.rs2 {
		case 0x00:
			return FMV_D_X {
				rd	= Reg64(ie.rd + 32),
				rs1	= Reg64(ie.rs1)
			}
		case 0x01:
			return FLI_D {
				rd		= Reg64(ie.rd + 32),
				uimm	= u64le(ie.rs1)
			}
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_system :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
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
	return // ILLEGAL{}
}


handle_i32opc_op_32 :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	return // ILLEGAL{}
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

		if ie.opc == 0 && ie.funct3 == 0 && ie.pad == 0 do return // ILLEGAL{}

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
			return // ILLEGAL{}
		}

		i32opc := I32_Opcode(ie.opc)

		if reflect.enum_value_has_name(i32opc) == false do return // ILLEGAL{}

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

	return // ILLEGAL{}
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

