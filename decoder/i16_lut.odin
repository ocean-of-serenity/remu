
package decoder


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
			rd		= IReg(ie.rd_r) + IReg.x7,
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
			rd		= FReg(ie.rd_r) + FReg.f7,
			rs1		= IReg(ie.rs1_r) + IReg.x7,
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
			rd		= IReg(ie.rd_r) + IReg.x7,
			rs1		= IReg(ie.rs1_r) + IReg.x7,
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
			rd		= IReg(ie.rd_r) + IReg.x7,
			rs1		= IReg(ie.rs1_r) + IReg.x7,
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
				rd		= IReg(ie.rd_r) + IReg.x7,
				rs1		= IReg(ie.rs1_r) + IReg.x7,
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
					rd		= IReg(ie.rd_r) + IReg.x7,
					rs1		= IReg(ie.rs1_r) + IReg.x7,
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
					rd		= IReg(ie.rd_r) + IReg.x7,
					rs1		= IReg(ie.rs1_r) + IReg.x7,
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
				rs1		= IReg(ie.rs1_r) + IReg.x7,
				rs2		= IReg(ie.rs2_r) + IReg.x7,
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
				rs1		= IReg(ie.rs1_r) + IReg.x7,
				rs2		= IReg(ie.rs2_r) + IReg.x7,
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
			rs1		= IReg(ie.rs1_r) + IReg.x7,
			rs2		= FReg(ie.rs2_r) + FReg.f7,
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
			rs1		= IReg(ie.rs1_r) + IReg.x7,
			rs2		= IReg(ie.rs2_r) + IReg.x7,
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
			rs1		= IReg(ie.rs1_r) + IReg.x7,
			rs2		= IReg(ie.rs2_r) + IReg.x7,
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
			rd	= IReg(ie.rd_rs1),
			rs1	= IReg(ie.rd_rs1),
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
			rd	= IReg(ie.rd_rs1),
			rs1	= IReg(ie.rd_rs1),
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
			rd	= IReg(ie.rd),
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
				rd	= IReg(ie.rd),
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
				rd	= IReg(ie.rd),
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
				rd		= IReg(ie.rd_rs1_r) + IReg.x7,
				rs1		= IReg(ie.rd_rs1_r) + IReg.x7,
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
				rd		= IReg(ie.rd_rs1_r) + IReg.x7,
				rs1		= IReg(ie.rd_rs1_r) + IReg.x7,
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
				rd	= IReg(ie.rd_rs1_r) + IReg.x7,
				rs1	= IReg(ie.rd_rs1_r) + IReg.x7,
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
						rd	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs1	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs2	= IReg(ie.rs2_r) + IReg.x7
					}

				case 0x1:
					return C_XOR{
						rd	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs1	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs2	= IReg(ie.rs2_r) + IReg.x7
					}

				case 0x2:
					return C_OR{
						rd	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs1	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs2	= IReg(ie.rs2_r) + IReg.x7
					}

				case 0x3:
					return C_AND{
						rd	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs1	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs2	= IReg(ie.rs2_r) + IReg.x7
					}

				}

			case 0x1:
				switch ie.funct2_2 {
				case 0x0:
					return C_SUBW{
						rd	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs1	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs2	= IReg(ie.rs2_r) + IReg.x7
					}

				case 0x1:
					return C_ADDW{
						rd	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs1	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs2	= IReg(ie.rs2_r) + IReg.x7
					}

				case 0x2:
					return C_MUL{
						rd	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs1	= IReg(ie.rd_rs1_r) + IReg.x7,
						rs2	= IReg(ie.rs2_r) + IReg.x7
					}

				case 0x3:
					switch ie.rs2_r {
					case 0x0:
						return C_ZEXT_B{
							rd	= IReg(ie.rd_rs1_r) + IReg.x7,
							rs1	= IReg(ie.rd_rs1_r) + IReg.x7
						}

					case 0x1:
						return C_SEXT_B{
							rd	= IReg(ie.rd_rs1_r) + IReg.x7,
							rs1	= IReg(ie.rd_rs1_r) + IReg.x7
						}

					case 0x2:
						return C_ZEXT_H{
							rd	= IReg(ie.rd_rs1_r) + IReg.x7,
							rs1	= IReg(ie.rd_rs1_r) + IReg.x7
						}

					case 0x3:
						return C_SEXT_H{
							rd	= IReg(ie.rd_rs1_r) + IReg.x7,
							rs1	= IReg(ie.rd_rs1_r) + IReg.x7
						}

					case 0x4:
						return C_ZEXT_W{
							rd	= IReg(ie.rd_rs1_r) + IReg.x7,
							rs1	= IReg(ie.rd_rs1_r) + IReg.x7
						}

					case 0x5:
						return C_NOT{
							rd	= IReg(ie.rd_rs1_r) + IReg.x7,
							rs1	= IReg(ie.rd_rs1_r) + IReg.x7
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
			rs1	= IReg(ie.rs1_r) + IReg.x7,
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
			rs1	= IReg(ie.rs1_r) + IReg.x7,
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
			rd		= IReg(ie.rd_rs1),
			rs1		= IReg(ie.rd_rs1),
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
			rd		= FReg(ie.rd),
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
			rd		= IReg(ie.rd),
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
			rd		= IReg(ie.rd),
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
					rd	= IReg(ie.rd_rs1),
					rs1	= IReg(ie.rd_rs1),
					rs2	= IReg(ie.rs2)
				}
			}
			else if ie.rd_rs1 != 0 && ie.rs2 == 0 {
				return C_JR{
					rs1 = IReg(ie.rd_rs1)
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
					rd	= IReg(ie.rd_rs1),
					rs1	= IReg(ie.rd_rs1),
					rs2	= IReg(ie.rs2)
				}
			}
			else if ie.rd_rs1 != 0 && ie.rs2 == 0 {
				return C_JALR {
					rs1 = IReg(ie.rd_rs1)
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
			rs1		= FReg(ie.rs1),
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
			rs1		= IReg(ie.rs1),
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
			rs1		= IReg(ie.rs1),
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


