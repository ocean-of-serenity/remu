
package decoder


import "core:fmt"
import "core:reflect"



IReg :: enum {
	x0,  x1,  x2,  x3,  x4,  x5,  x6,  x7,
	x8,  x9,  x10, x11, x12, x13, x14, x15,
	x16, x17, x18, x19, x20, x21, x22, x23,
	x24, x25, x26, x27, x28, x29, x30, x31
}

FReg :: enum {
	f0,  f1,  f2,   f3,  f4,  f5,  f6,  f7,
	f8,  f9,  f10, f11, f12, f13, f14, f15,
	f16, f17, f18, f19, f20, f21, f22, f23,
	f24, f25, f26, f27, f28, f29, f30, f31
}

CSReg :: enum {
	fflags	= 0x001,
	frm		= 0x002,
	fcsr	= 0x003,

	cycle	= 0xC00,
	time	= 0xC01,
	instret	= 0xC02
}

SPReg :: enum {
	pc
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

