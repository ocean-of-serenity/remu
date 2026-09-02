
package decoder


handle_i32opc_load :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_I :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		funct3:		u8		| 3,
		rs1:		u8		| 5,
		imm0to11:	u16le	| 12
	}

	ie := transmute(I32_FMT_I) ie

	imm := sign_extend_to_i64le(
		u64le(ie.imm0to11),
		12
	)

	switch ie.funct3 {
	case 0x0:
		return LB{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= imm
		}

	case 0x1:
		return LH{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= imm
		}

	case 0x2:
		return LW{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= imm
		}

	case 0x3:
		return LD{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= imm
		}

	case 0x4:
		return LBU{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= imm
		}

	case 0x6:
		return LHU{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= imm
		}

	}

	return // ILLEGAL{}
}


handle_i32opc_store :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_S :: bit_field u32le {
		opc:		u8	| 7,
		imm0to4:	u8	| 5,
		funct3:		u8	| 3,
		rs1:		u8	| 5,
		rs2:		u8	| 5,
		imm5to11:	u8	| 7
	}

	ie := transmute(I32_FMT_S) ie

	IMM_DEC :: bit_field u16le {
		imm0to4:	u8 | 5,
		imm5to11:	u8 | 7,
		imm12to15:	u8 | 4
	}

	imm := sign_extend_to_i64le(
		u64le(IMM_DEC{
			imm0to4		= ie.imm0to4,
			imm5to11	= ie.imm5to11,
			imm12to15	= 0
		}),
		12
	)

	switch ie.funct3 {
	case 0x0:
		return SB{
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}

	case 0x1:
		return SH{
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}

	case 0x2:
		return SW{
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}

	case 0x3:
		return SD{
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_madd :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_R4 :: bit_field u32le {
		opc:		u8	| 7,
		rd:			u8	| 5,
		rm:			u8	| 3,
		rs1:		u8	| 5,
		rs2:		u8	| 5,
		funct2:		u8	| 2,
		rs3:		u8	| 5
	}

	ie := transmute(I32_FMT_R4) ie

	rm := Frm(ie.rm)

	switch ie.funct2 {
	case 0x0:
		return FMADD_S{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rs3	= FReg(ie.rs3),
			rm	= rm
		}

	case 0x1:
		return FMADD_D{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rs3	= FReg(ie.rs3),
			rm	= rm
		}
	}

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

	IMM_DEC :: bit_field u32le {
		imm0:		u8	| 1,
		imm1to4:	u8	| 4,
		imm5to10:	u8	| 6,
		imm11:		u8	| 1,
		imm12:		u8	| 1
	}

	imm := sign_extend_to_i64le(
		u64le(IMM_DEC{
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
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}

	case 0x1:
		return BNE{
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}

	case 0x4:
		return BLT{
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}

	case 0x5:
		return BGE{
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}

	case 0x6:
		return BLTU{
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}

	case 0x7:
		return BGEU{
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			simm	= imm
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_load_fp :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_I :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		funct3:		u8		| 3,
		rs1:		u8		| 5,
		imm0to11:	u16le	| 12
	}

	ie := transmute(I32_FMT_I) ie

	imm := sign_extend_to_i64le(
		u64le(ie.imm0to11),
		12
	)

	switch ie.funct3 {
	case 0x2:
		return FLW{
			rd		= FReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= imm
		}

	case 0x3:
		return FLD{
			rd		= FReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= imm
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_store_fp :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_S :: bit_field u32le {
		opc:		u8	| 7,
		imm0to4:	u8	| 5,
		funct3:		u8	| 3,
		rs1:		u8	| 5,
		rs2:		u8	| 5,
		imm5to11:	u8	| 7
	}

	ie := transmute(I32_FMT_S) ie

	IMM_DEC :: bit_field u16le {
		imm0to4:	u8 | 5,
		imm5to11:	u8 | 7,
		imm12to15:	u8 | 4
	}

	imm := sign_extend_to_i64le(
		u64le(IMM_DEC{
			imm0to4		= ie.imm0to4,
			imm5to11	= ie.imm5to11,
			imm12to15	= 0
		}),
		12
	)

	switch ie.funct3 {
	case 0x2:
		return FSW{
			rs1		= IReg(ie.rs1),
			rs2		= FReg(ie.rs2),
			simm	= imm
		}

	case 0x3:
		return FSD{
			rs1		= IReg(ie.rs1),
			rs2		= FReg(ie.rs2),
			simm	= imm
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_msub :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_R4 :: bit_field u32le {
		opc:		u8	| 7,
		rd:			u8	| 5,
		rm:			u8	| 3,
		rs1:		u8	| 5,
		rs2:		u8	| 5,
		funct2:		u8	| 2,
		rs3:		u8	| 5
	}

	ie := transmute(I32_FMT_R4) ie

	rm := Frm(ie.rm)

	switch ie.funct2 {
	case 0x0:
		return FMSUB_S{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rs3	= FReg(ie.rs3),
			rm	= rm
		}

	case 0x1:
		return FMSUB_D{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rs3	= FReg(ie.rs3),
			rm	= rm
		}
	}

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
		rd		= IReg(ie.rd),
		rs1		= IReg(ie.rs1),
		simm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
	}
}


handle_i32opc_nmsub :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_R4 :: bit_field u32le {
		opc:		u8	| 7,
		rd:			u8	| 5,
		rm:			u8	| 3,
		rs1:		u8	| 5,
		rs2:		u8	| 5,
		funct2:		u8	| 2,
		rs3:		u8	| 5
	}

	ie := transmute(I32_FMT_R4) ie

	rm := Frm(ie.rm)

	switch ie.funct2 {
	case 0x0:
		return FNMSUB_S{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rs3	= FReg(ie.rs3),
			rm	= rm
		}

	case 0x1:
		return FNMSUB_D{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rs3	= FReg(ie.rs3),
			rm	= rm
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_misc_mem :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	switch ie.funct3 {
	case 0x0:
		I32_FMT_I :: bit_field u32le {
			opc:		u8	| 7,
			rd:			u8	| 5,
			funct3:		u8	| 3,
			rs1:		u8	| 5,
			succ:		u8	| 4,
			pred:		u8	| 4,
			fmode:		u8	| 4
		}

		ie := transmute(I32_FMT_I) ie

		FIELDS_DEC :: bit_field u8 {
			w: u8 | 1,
			r: u8 | 1,
			o: u8 | 1,
			i: u8 | 1
		}

		succ_bits := transmute(FIELDS_DEC) ie.succ
		pred_bits := transmute(FIELDS_DEC) ie.pred

		succ := Flagbits_MOSet{}
		if succ_bits.w == 1 do succ += {.w}
		if succ_bits.r == 1 do succ += {.r}
		if succ_bits.o == 1 do succ += {.o}
		if succ_bits.i == 1 do succ += {.i}

		pred := Flagbits_MOSet{}
		if pred_bits.w == 1 do pred += {.w}
		if pred_bits.r == 1 do pred += {.r}
		if pred_bits.o == 1 do pred += {.o}
		if pred_bits.i == 1 do pred += {.i}

		switch ie.fmode {
		case 0x0:
			if ie.rd == 0 && ie.rs1 == 0 && ie.succ == 0 && ie.pred == 0x1 {
				return PAUSE{}
			}
			else {
				return FENCE{
					rd		= IReg(ie.rd),
					rs1		= IReg(ie.rs1),
					succ	= succ,
					pred	= pred
				}
			}

		case 0x8:
			if ie.succ == 0x3 && ie.pred == 0x3 {
				return FENCE_TSO{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}
			}
		}

	case 0x1:
		I32_FMT_I :: bit_field u32le {
			opc:		u8		| 7,
			rd:			u8		| 5,
			funct3:		u8		| 3,
			rs1:		u8		| 5,
			imm0to11:	u16le	| 12,
		}

		ie := transmute(I32_FMT_I) ie

		// rd, rs1 and simm SHOULD always be 0 in software
		// if not, that is likely a compiler/assember bug or defect
		// the RISC-V spec say we should simply ignore these values
		// there might be changes in the spec at some point, so we'll
		// include them in the decoded instruction struct for now
		return FENCE_I{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			uimm	= u64le(ie.imm0to11)
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_amo :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_R :: bit_field u32le {
		opc:		u8	| 7,
		rd:			u8	| 5,
		funct3:		u8	| 3,
		rs1:		u8	| 5,
		rs2:		u8	| 5,
		rl:			u8	| 1,
		aq:			u8	| 1,
		funct5:		u8	| 5
	}

	ie := transmute(I32_FMT_R) ie

	rl_aq := Flagbits_Rl_Aq{}
	if ie.rl == 1 {
		rl_aq += {.rl}
	}
	if ie.aq == 1 {
		rl_aq += {.aq}
	}

	switch ie.funct3 {
	case 0x2:
		switch ie.funct5 {
		case 0x00:
			return AMOADD_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x01:
			return AMOSWAP_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x02:
			if ie.rs2 != 0 {
				return // ILLEGAL{}
			}

			return LR_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rl_aq	= rl_aq
			}

		case 0x03:
			return SC_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x04:
			return AMOXOR_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x05:
			return AMOCAS_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x08:
			return AMOOR_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x0C:
			return AMOAND_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x10:
			return AMOMIN_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x14:
			return AMOMAX_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x18:
			return AMOMINU_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x1C:
			return AMOMAXU_W{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}
		}

	case 0x3:
		switch ie.funct5 {
		case 0x00:
			return AMOADD_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x01:
			return AMOSWAP_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x02:
			if ie.rs2 != 0 {
				return // ILLEGAL{}
			}

			return LR_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rl_aq	= rl_aq
			}

		case 0x03:
			return SC_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x04:
			return AMOXOR_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x05:
			return AMOCAS_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x08:
			return AMOOR_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x0C:
			return AMOAND_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x10:
			return AMOMIN_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x14:
			return AMOMAX_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x18:
			return AMOMINU_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}

		case 0x1C:
			return AMOMAXU_D{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				rs2		= IReg(ie.rs2),
				rl_aq	= rl_aq
			}
		}


	case 0x4:
		return AMOCAS_Q{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			rs2		= IReg(ie.rs2),
			rl_aq	= rl_aq
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_nmadd :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_R4 :: bit_field u32le {
		opc:		u8	| 7,
		rd:			u8	| 5,
		rm:			u8	| 3,
		rs1:		u8	| 5,
		rs2:		u8	| 5,
		funct2:		u8	| 2,
		rs3:		u8	| 5
	}

	ie := transmute(I32_FMT_R4) ie

	rm := Frm(ie.rm)

	switch ie.funct2 {
	case 0x0:
		return FNMADD_S{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rs3	= FReg(ie.rs3),
			rm	= rm
		}

	case 0x1:
		return FNMADD_D{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rs3	= FReg(ie.rs3),
			rm	= rm
		}
	}

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

	IMM_DEC :: bit_field u32le {
		imm0:		u8		| 1,
		imm1to10:	u16le	| 10,
		imm11:		u8		| 1,
		imm12to19:	u8		| 8,
		imm20:		u8		| 1
	}

	return JAL{
		rd		= IReg(ie.rd),
		simm	= sign_extend_to_i64le(
			u64le(IMM_DEC{
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
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				simm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
			}
		}

	case 0x1:
		ie := transmute(I32_FMT_I_IMM6) ie

		switch ie.funct6 {
		case 0x00:
			return SLLI{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x0A:
			return BSETI{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x12:
			return BCLRI{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x18:
			ie := transmute(I32_FMT_I_FUNCT7) ie

			if ie.funct7 & 1 != 0 do return // ILLEGAL{}

			switch ie.funct5 {
			case 0x00:
				return CLZ{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}

			case 0x01:
				return CTZ{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}

			case 0x02:
				return CPOP{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}

			case 0x04:
				return SEXT_B{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}

			case 0x05:
				return SEXT_H{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}
			}
			
		case 0x1A:
			return BINVI{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}
		}

	case 0x2:
		ie := transmute(I32_FMT_I_IMM12) ie

		return SLTI{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
		}

	case 0x3:
		ie := transmute(I32_FMT_I_IMM12) ie

		return SLTIU{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			uimm	= u64le(sign_extend_to_i64le(u64le(ie.imm0to11), 12))
		}

	case 0x4:
		ie := transmute(I32_FMT_I_IMM12) ie

		return XORI{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
		}

	case 0x5:
		ie := transmute(I32_FMT_I_IMM6) ie

		switch ie.funct6 {
		case 0x00:
			return SRLI{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x0A:
			ie := transmute(I32_FMT_I_FUNCT6) ie

			if ie.funct6_2 != 0x07 do return // ILLEGAL{}

			return ORC_B{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1)
			}

		case 0x10:
			return SRAI{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x12:
			return BEXTI{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x18:
			return RORI{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to5)
			}

		case 0x1A:
			ie := transmute(I32_FMT_I_FUNCT6) ie

			switch ie.funct6_2 {
			case 0x07:
				return BREV8{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}

			case 0x38:
				return REV8{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}
			}
		}

	case 0x6:
		ie := transmute(I32_FMT_I_IMM12) ie

		return ORI{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
		}

	case 0x7:
		ie := transmute(I32_FMT_I_IMM12) ie

		return ANDI{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= sign_extend_to_i64le(u64le(ie.imm0to11), 12)
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
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x1:
			return MUL{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x20:
			return SUB{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}
		}

	case 0x1:
		switch ie.funct7 {
		case 0x00:
			return SLL{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x01:
			return MULH{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x05:
			return CLMUL{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x14:
			return BSET{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x24:
			return BCLR{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x30:
			return ROL{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x34:
			return BINV{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}
		}

	case 0x2:
		switch ie.funct7 {
		case 0x00:
			return SLT{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x01:
			return MULHSU{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x05:
			return CLMULR{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x10:
			return SH1ADD{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x14:
			return XPERM_N{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}
		}

	case 0x3:
		switch ie.funct7 {
		case 0x00:
			return SLTU{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x01:
			return MULHU{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x05:
			return CLMULH{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}
		}

	case 0x4:
		switch ie.funct7 {
		case 0x00:
			return XOR{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x01:
			return DIV{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x04:
			return PACK{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x05:
			return MIN{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x10:
			return SH2ADD{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x14:
			return XPERM_B{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x20:
			return XNOR{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}
		}

	case 0x5:
		switch ie.funct7 {
		case 0x00:
			return SRL{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x01:
			return DIVU{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x05:
			return MINU{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x07:
			return CZERO_EQZ{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x20:
			return SRA{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x24:
			return BEXT{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x30:
			return ROR{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}
		}

	case 0x6:
		switch ie.funct7 {
		case 0x00:
			return OR{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x01:
			return REM{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x05:
			return MAX{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x10:
			return SH3ADD{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x20:
			return ORN{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}
		}

	case 0x7:
		switch ie.funct7 {
		case 0x00:
			return AND{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x01:
			return REMU{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x04:
			return PACKH{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x05:
			return MAXU{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x07:
			return CZERO_NEZ{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
			}

		case 0x20:
			return ANDN{
				rd	= IReg(ie.rd),
				rs1 = IReg(ie.rs1),
				rs2 = IReg(ie.rs2)
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

	rm := Frm(ie.funct3)

	switch ie.funct7 {
	case 0x00:
		return FADD_S{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rm	= rm
		}

	case 0x01:
		return FADD_D{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rm	= rm
		}

	case 0x04:
		return FSUB_S{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rm	= rm
		}

	case 0x05:
		return FSUB_D{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rm	= rm
		}

	case 0x08:
		return FMUL_S{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rm	= rm
		}

	case 0x09:
		return FMUL_D{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rm	= rm
		}

	case 0x0B:
		return FDIV_S{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rm	= rm
		}

	case 0x0C:
		return FDIV_D{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rs2	= FReg(ie.rs2),
			rm	= rm
		}

	case 0x10:
		switch ie.funct3 {
		case 0x0:
			return FSGNJ_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x1:
			return FSGNJN_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x2:
			return FSGNJX_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}
		}

	case 0x11:
		switch ie.funct3 {
		case 0x0:
			return FSGNJ_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x1:
			return FSGNJN_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x2:
			return FSGNJX_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}
		}

	case 0x14:
		switch ie.funct3 {
		case 0x0:
			return FMIN_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x1:
			return FMAX_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x2:
			return FMINM_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x3:
			return FMAXM_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}
		}

	case 0x15:
		switch ie.funct3 {
		case 0x0:
			return FMIN_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x1:
			return FMAX_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x2:
			return FMINM_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}

		case 0x3:
			return FMAXM_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs2),
			}
		}

	case 0x20:
		switch ie.rs2 {
		case 0x01:
			return FCVT_S_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}

		case 0x04:
			return FROUND_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}

		case 0x05:
			return FROUNDNX_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}
		}

	case 0x21:
		switch ie.rs2 {
		case 0x00:
			return FCVT_D_S{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}

		case 0x04:
			return FROUND_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}

		case 0x05:
			return FROUNDNX_D{
				rd	= FReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}
		}

	case 0x2B:
		return FSQRT_S{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rm	= rm
		}

	case 0x2C:
		return FSQRT_D{
			rd	= FReg(ie.rd),
			rs1	= FReg(ie.rs1),
			rm	= rm
		}

	case 0x50:
		switch ie.funct3 {
		case 0x0:
			return FLE_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}

		case 0x1:
			return FLT_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}

		case 0x2:
			return FEQ_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}

		case 0x4:
			return FLEQ_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}

		case 0x5:
			return FLTQ_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}
		}

	case 0x51:
		switch ie.funct3 {
		case 0x0:
			return FLE_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}

		case 0x1:
			return FLT_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}

		case 0x2:
			return FEQ_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}

		case 0x4:
			return FLEQ_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}

		case 0x5:
			return FLTQ_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rs2	= FReg(ie.rs1)
			}
		}

	case 0x60:
		switch ie.rs2 {
		case 0x00:
			return FCVT_W_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}

		case 0x01:
			return FCVT_WU_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}


		case 0x02:
			return FCVT_L_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}

		case 0x03:
			return FCVT_LU_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}
		}

	case 0x61:
		switch ie.rs2 {
		case 0x00:
			return FCVT_W_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}

		case 0x01:
			return FCVT_WU_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}


		case 0x02:
			return FCVT_L_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}

		case 0x03:
			return FCVT_LU_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1),
				rm	= rm
			}

		case 0x08:
			if ie.funct3 != 0x1 do return // ILLEGAL{}

			return FCVTMOD_W_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1)
			}
		}

	case 0x68:
		switch ie.rs2 {
		case 0x00:
			return FCVT_S_W{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rm	= rm
			}

		case 0x01:
			return FCVT_S_WU{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rm	= rm
			}


		case 0x02:
			return FCVT_S_L{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rm	= rm
			}


		case 0x03:
			return FCVT_S_LU{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rm	= rm
			}
		}

	case 0x69:
		switch ie.rs2 {
		case 0x00:
			return FCVT_D_W{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rm	= rm
			}

		case 0x01:
			return FCVT_D_WU{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rm	= rm
			}


		case 0x02:
			return FCVT_D_L{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rm	= rm
			}


		case 0x03:
			return FCVT_D_LU{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rm	= rm
			}
		}

	case 0x70:
		switch ie.funct3 {
		case 0x0:
			return FMV_X_W{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1)
			}

		case 0x1:
			return FCLASS_S{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1)
			}
		}

	case 0x71:
		switch ie.funct3 {
		case 0x0:
			return FMV_X_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1)
			}

		case 0x1:
			return FCLASS_D{
				rd	= IReg(ie.rd),
				rs1	= FReg(ie.rs1)
			}
		}

	case 0x78:
		switch ie.rs2 {
		case 0x00:
			return FMV_W_X{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1)
			}

		case 0x01:
			return FLI_S{
				rd		= FReg(ie.rd),
				uimm	= u64le(ie.rs1)
			}
		}

	case 0x79:
		switch ie.rs2 {
		case 0x00:
			return FMV_D_X{
				rd	= FReg(ie.rd),
				rs1	= IReg(ie.rs1)
			}

		case 0x01:
			return FLI_D{
				rd		= FReg(ie.rd),
				uimm	= u64le(ie.rs1)
			}
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_system :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_I :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		funct3:		u8		| 3,
		rs1:		u8		| 5,
		csr:		u16le	| 12
	}

	ie := transmute(I32_FMT_I) ie

	switch ie.funct3 {
	case 0x0:
		switch ie.csr {
		case 0x000:
			if ie.rd == 0 && ie.rs1 == 0 do return ECALL{}
		case 0x001:
			if ie.rd == 0 && ie.rs1 == 0 do return EBREAK{}
		case 0x00D:
			if ie.rd == 0 && ie.rs1 == 0 do return WRS_NTO{}
		case 0x01D:
			if ie.rd == 0 && ie.rs1 == 0 do return WRS_STO{}
		}

	case 0x1:
		return CSRRW{
			rd	= IReg(ie.rd),
			rs1	= IReg(ie.rs1),
			csr	= CSReg(ie.csr)
		}

	case 0x2:
		return CSRRS{
			rd	= IReg(ie.rd),
			rs1	= IReg(ie.rs1),
			csr	= CSReg(ie.csr)
		}

	case 0x3:
		return CSRRC{
			rd	= IReg(ie.rd),
			rs1	= IReg(ie.rs1),
			csr	= CSReg(ie.csr)
		}

	case 0x5:
		return CSRRWI{
			rd		= IReg(ie.rd),
			uimm	= u64le(ie.rs1),
			csr		= CSReg(ie.csr)
		}

	case 0x6:
		return CSRRSI{
			rd		= IReg(ie.rd),
			uimm	= u64le(ie.rs1),
			csr		= CSReg(ie.csr)
		}

	case 0x7:
		return CSRRCI{
			rd		= IReg(ie.rd),
			uimm	= u64le(ie.rs1),
			csr		= CSReg(ie.csr)
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_auipc :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_U :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		imm12to31:	u32le	| 20
	}

	ie := transmute(I32_FMT_U) ie

	IMM_DEC :: bit_field u32le {
		imm0to11:	u16le | 12,
		imm12to31:	u32le | 20
	}

	return AUIPC{
		rd		= IReg(ie.rd),
		simm	= sign_extend_to_i64le(
			u64le(IMM_DEC{
				imm0to11	= 0,
				imm12to31	= ie.imm12to31
			}),
			32
		)
	}
}


handle_i32opc_lui :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_U :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		imm12to31:	u32le	| 20
	}

	ie := transmute(I32_FMT_U) ie

	IMM_DEC :: bit_field u32le {
		imm0to11:	u16le | 12,
		imm12to31:	u32le | 20
	}

	return LUI{
		rd		= IReg(ie.rd),
		simm	= sign_extend_to_i64le(
			u64le(IMM_DEC{
				imm0to11	= 0,
				imm12to31	= ie.imm12to31
			}),
			32
		)
	}
}


handle_i32opc_op_imm_32 :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_I :: bit_field u32le {
		opc:		u8	| 7,
		rd:			u8	| 5,
		funct3:		u8	| 3,
		rs1:		u8	| 5,
		imm0to4:	u8	| 5,
		funct7:		u8	| 7
	}

	ie := transmute(I32_FMT_I) ie

	switch ie.funct3 {
	case 0x0:
		IMM_DEC :: bit_field u16le {
			imm0to4:		u8	| 5,
			imm5to11:		u8	| 7,
			imm12to15:		u8	| 4
		}

		return ADDIW{
			rd		= IReg(ie.rd),
			rs1		= IReg(ie.rs1),
			simm	= sign_extend_to_i64le(
				u64le(IMM_DEC{
					imm0to4		= ie.imm0to4,
					imm5to11	= ie.funct7,
					imm12to15	= 0
				}),
				12
			)
		}

	case 0x1:
		switch ie.funct7 {
		case 0x00:
			return SLLIW{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to4)
			}

		case 0x02:
			return SLLI_UW{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to4)
			}

		case 0x30:
			switch ie.imm0to4 {
			case 0x00:
				return CLZW{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}

			case 0x01:
				return CLZW{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}

			case 0x02:
				return CLZW{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}
			}
		}

	case 0x5:
		switch ie.funct7 {
		case 0x00:
			return SRLIW{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to4)
			}

		case 0x20:
			return SRAIW{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to4)
			}

		case 0x30:
			return RORIW{
				rd		= IReg(ie.rd),
				rs1		= IReg(ie.rs1),
				uimm	= u64le(ie.imm0to4)
			}
		}
	}

	return // ILLEGAL{}
}


handle_i32opc_op_32 :: proc(ie: I32_Base) -> (id: IDec = ILLEGAL{}) {
	I32_FMT_R :: bit_field u32le {
		opc:		u8		| 7,
		rd:			u8		| 5,
		funct3:		u8		| 3,
		rs1:		u8		| 5,
		rs2:		u8		| 5,
		funct7:		u8		| 7
	}

	ie := transmute(I32_FMT_R) ie

	switch ie.funct3 {
	case 0x0:
		switch ie.funct7 {
		case 0x00:
			return ADDW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}

		case 0x01:
			return MULW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}

		case 0x04:
			return ADD_UW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}

		case 0x20:
			return SUBW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}
		}

	case 0x1:
		switch ie.funct7 {
		case 0x00:
			return SLLW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}

		case 0x30:
			return ROLW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}
		}

	case 0x2:
		switch ie.funct7 {
		case 0x10:
			return SH1ADD_UW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}
		}

	case 0x4:
		switch ie.funct7 {
		case 0x01:
			return DIVW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}

		case 0x04:
			if ie.rs2 == 0 {
				return ZEXT_H{
					rd	= IReg(ie.rd),
					rs1	= IReg(ie.rs1)
				}
			}

		case 0x10:
			return SH2ADD_UW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}
		}

	case 0x5:
		switch ie.funct7 {
		case 0x00:
			return SRLW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}

		case 0x01:
			return DIVUW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}

		case 0x20:
			return SRAW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}

		case 0x30:
			return RORW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}
		}

	case 0x6:
		switch ie.funct7 {
		case 0x01:
			return REMW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}

		case 0x10:
			return SH3ADD_UW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}
		}

	case 0x7:
		switch ie.funct7 {
		case 0x01:
			return REMUW{
				rd	= IReg(ie.rd),
				rs1	= IReg(ie.rs1),
				rs2	= IReg(ie.rs2)
			}
		}
	}

	return // ILLEGAL{}
}

