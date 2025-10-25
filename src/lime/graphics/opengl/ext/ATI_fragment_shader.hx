package lime.graphics.opengl.ext;

@:keep
@:noCompletion class ATI_fragment_shader
{
	public var FRAGMENT_SHADER_ATI = 0x8920;
	public var REG_0_ATI = 0x8921;
	public var REG_1_ATI = 0x8922;
	public var REG_2_ATI = 0x8923;
	public var REG_3_ATI = 0x8924;
	public var REG_4_ATI = 0x8925;
	public var REG_5_ATI = 0x8926;
	public var REG_6_ATI = 0x8927;
	public var REG_7_ATI = 0x8928;
	public var REG_8_ATI = 0x8929;
	public var REG_9_ATI = 0x892A;
	public var REG_10_ATI = 0x892B;
	public var REG_11_ATI = 0x892C;
	public var REG_12_ATI = 0x892D;
	public var REG_13_ATI = 0x892E;
	public var REG_14_ATI = 0x892F;
	public var REG_15_ATI = 0x8930;
	public var REG_16_ATI = 0x8931;
	public var REG_17_ATI = 0x8932;
	public var REG_18_ATI = 0x8933;
	public var REG_19_ATI = 0x8934;
	public var REG_20_ATI = 0x8935;
	public var REG_21_ATI = 0x8936;
	public var REG_22_ATI = 0x8937;
	public var REG_23_ATI = 0x8938;
	public var REG_24_ATI = 0x8939;
	public var REG_25_ATI = 0x893A;
	public var REG_26_ATI = 0x893B;
	public var REG_27_ATI = 0x893C;
	public var REG_28_ATI = 0x893D;
	public var REG_29_ATI = 0x893E;
	public var REG_30_ATI = 0x893F;
	public var REG_31_ATI = 0x8940;
	public var CON_0_ATI = 0x8941;
	public var CON_1_ATI = 0x8942;
	public var CON_2_ATI = 0x8943;
	public var CON_3_ATI = 0x8944;
	public var CON_4_ATI = 0x8945;
	public var CON_5_ATI = 0x8946;
	public var CON_6_ATI = 0x8947;
	public var CON_7_ATI = 0x8948;
	public var CON_8_ATI = 0x8949;
	public var CON_9_ATI = 0x894A;
	public var CON_10_ATI = 0x894B;
	public var CON_11_ATI = 0x894C;
	public var CON_12_ATI = 0x894D;
	public var CON_13_ATI = 0x894E;
	public var CON_14_ATI = 0x894F;
	public var CON_15_ATI = 0x8950;
	public var CON_16_ATI = 0x8951;
	public var CON_17_ATI = 0x8952;
	public var CON_18_ATI = 0x8953;
	public var CON_19_ATI = 0x8954;
	public var CON_20_ATI = 0x8955;
	public var CON_21_ATI = 0x8956;
	public var CON_22_ATI = 0x8957;
	public var CON_23_ATI = 0x8958;
	public var CON_24_ATI = 0x8959;
	public var CON_25_ATI = 0x895A;
	public var CON_26_ATI = 0x895B;
	public var CON_27_ATI = 0x895C;
	public var CON_28_ATI = 0x895D;
	public var CON_29_ATI = 0x895E;
	public var CON_30_ATI = 0x895F;
	public var CON_31_ATI = 0x8960;
	public var MOV_ATI = 0x8961;
	public var ADD_ATI = 0x8963;
	public var MUL_ATI = 0x8964;
	public var SUB_ATI = 0x8965;
	public var DOT3_ATI = 0x8966;
	public var DOT4_ATI = 0x8967;
	public var MAD_ATI = 0x8968;
	public var LERP_ATI = 0x8969;
	public var CND_ATI = 0x896A;
	public var CND0_ATI = 0x896B;
	public var DOT2_ADD_ATI = 0x896C;
	public var SECONDARY_INTERPOLATOR_ATI = 0x896D;
	public var NUM_FRAGMENT_REGISTERS_ATI = 0x896E;
	public var NUM_FRAGMENT_CONSTANTS_ATI = 0x896F;
	public var NUM_PASSES_ATI = 0x8970;
	public var NUM_INSTRUCTIONS_PER_PASS_ATI = 0x8971;
	public var NUM_INSTRUCTIONS_TOTAL_ATI = 0x8972;
	public var NUM_INPUT_INTERPOLATOR_COMPONENTS_ATI = 0x8973;
	public var NUM_LOOPBACK_COMPONENTS_ATI = 0x8974;
	public var COLOR_ALPHA_PAIRING_ATI = 0x8975;
	public var SWIZZLE_STR_ATI = 0x8976;
	public var SWIZZLE_STQ_ATI = 0x8977;
	public var SWIZZLE_STR_DR_ATI = 0x8978;
	public var SWIZZLE_STQ_DQ_ATI = 0x8979;
	public var SWIZZLE_STRQ_ATI = 0x897A;
	public var SWIZZLE_STRQ_DQ_ATI = 0x897B;
	public var RED_BIT_ATI = 0x00000001;
	public var GREEN_BIT_ATI = 0x00000002;
	public var BLUE_BIT_ATI = 0x00000004;
	public var _2X_BIT_ATI = 0x00000001;
	public var _4X_BIT_ATI = 0x00000002;
	public var _8X_BIT_ATI = 0x00000004;
	public var HALF_BIT_ATI = 0x00000008;
	public var QUARTER_BIT_ATI = 0x00000010;
	public var EIGHTH_BIT_ATI = 0x00000020;
	public var SATURATE_BIT_ATI = 0x00000040;
	public var COMP_BIT_ATI = 0x00000002;
	public var NEGATE_BIT_ATI = 0x00000004;
	public var BIAS_BIT_ATI = 0x00000008;

	@:noCompletion private function new() {}

	// GLuint glGenFragmentShadersATI (GLuint range)
	// void glBindFragmentShaderATI (GLuint id)
	// void glDeleteFragmentShaderATI (GLuint id)
	// void glBeginFragmentShaderATI ()
	// void glEndFragmentShaderATI ()
	// void glPassTexCoordATI (GLuint dst, GLuint coord, GLenum swizzle)
	// void glSampleMapATI (GLuint dst, GLuint interp, GLenum swizzle)
	// void glColorFragmentOp1ATI (GLenum op, GLuint dst, GLuint dstMask, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod)
	// void glColorFragmentOp2ATI (GLenum op, GLuint dst, GLuint dstMask, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod)
	// void glColorFragmentOp3ATI (GLenum op, GLuint dst, GLuint dstMask, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod, GLuint arg3, GLuint arg3Rep, GLuint arg3Mod)
	// void glAlphaFragmentOp1ATI (GLenum op, GLuint dst, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod)
	// void glAlphaFragmentOp2ATI (GLenum op, GLuint dst, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod)
	// void glAlphaFragmentOp3ATI (GLenum op, GLuint dst, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod, GLuint arg3, GLuint arg3Rep, GLuint arg3Mod)
	// void glSetFragmentShaderConstantATI (GLuint dst, const GLfloat *value)
}
