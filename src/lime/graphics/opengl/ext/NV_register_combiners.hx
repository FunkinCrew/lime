package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_register_combiners
{
	public var REGISTER_COMBINERS_NV = 0x8522;
	public var VARIABLE_A_NV = 0x8523;
	public var VARIABLE_B_NV = 0x8524;
	public var VARIABLE_C_NV = 0x8525;
	public var VARIABLE_D_NV = 0x8526;
	public var VARIABLE_E_NV = 0x8527;
	public var VARIABLE_F_NV = 0x8528;
	public var VARIABLE_G_NV = 0x8529;
	public var CONSTANT_COLOR0_NV = 0x852A;
	public var CONSTANT_COLOR1_NV = 0x852B;
	public var PRIMARY_COLOR_NV = 0x852C;
	public var SECONDARY_COLOR_NV = 0x852D;
	public var SPARE0_NV = 0x852E;
	public var SPARE1_NV = 0x852F;
	public var DISCARD_NV = 0x8530;
	public var E_TIMES_F_NV = 0x8531;
	public var SPARE0_PLUS_SECONDARY_COLOR_NV = 0x8532;
	public var UNSIGNED_IDENTITY_NV = 0x8536;
	public var UNSIGNED_INVERT_NV = 0x8537;
	public var EXPAND_NORMAL_NV = 0x8538;
	public var EXPAND_NEGATE_NV = 0x8539;
	public var HALF_BIAS_NORMAL_NV = 0x853A;
	public var HALF_BIAS_NEGATE_NV = 0x853B;
	public var SIGNED_IDENTITY_NV = 0x853C;
	public var SIGNED_NEGATE_NV = 0x853D;
	public var SCALE_BY_TWO_NV = 0x853E;
	public var SCALE_BY_FOUR_NV = 0x853F;
	public var SCALE_BY_ONE_HALF_NV = 0x8540;
	public var BIAS_BY_NEGATIVE_ONE_HALF_NV = 0x8541;
	public var COMBINER_INPUT_NV = 0x8542;
	public var COMBINER_MAPPING_NV = 0x8543;
	public var COMBINER_COMPONENT_USAGE_NV = 0x8544;
	public var COMBINER_AB_DOT_PRODUCT_NV = 0x8545;
	public var COMBINER_CD_DOT_PRODUCT_NV = 0x8546;
	public var COMBINER_MUX_SUM_NV = 0x8547;
	public var COMBINER_SCALE_NV = 0x8548;
	public var COMBINER_BIAS_NV = 0x8549;
	public var COMBINER_AB_OUTPUT_NV = 0x854A;
	public var COMBINER_CD_OUTPUT_NV = 0x854B;
	public var COMBINER_SUM_OUTPUT_NV = 0x854C;
	public var MAX_GENERAL_COMBINERS_NV = 0x854D;
	public var NUM_GENERAL_COMBINERS_NV = 0x854E;
	public var COLOR_SUM_CLAMP_NV = 0x854F;
	public var COMBINER0_NV = 0x8550;
	public var COMBINER1_NV = 0x8551;
	public var COMBINER2_NV = 0x8552;
	public var COMBINER3_NV = 0x8553;
	public var COMBINER4_NV = 0x8554;
	public var COMBINER5_NV = 0x8555;
	public var COMBINER6_NV = 0x8556;
	public var COMBINER7_NV = 0x8557;
	public var TEXTURE0_ARB = 0x84C0;
	public var TEXTURE1_ARB = 0x84C1;
	public var ZERO = 0;
	public var NONE = 0;
	public var FOG = 0x0B60;

	@:noCompletion private function new() {}

	// void glCombinerParameterfvNV (GLenum pname, const GLfloat *params)
	// void glCombinerParameterfNV (GLenum pname, GLfloat param)
	// void glCombinerParameterivNV (GLenum pname, const GLint *params)
	// void glCombinerParameteriNV (GLenum pname, GLint param)
	// void glCombinerInputNV (GLenum stage, GLenum portion, GLenum variable, GLenum input, GLenum mapping, GLenum componentUsage)
	// void glCombinerOutputNV (GLenum stage, GLenum portion, GLenum abOutput, GLenum cdOutput, GLenum sumOutput, GLenum scale, GLenum bias, GLboolean abDotProduct, GLboolean cdDotProduct, GLboolean muxSum)
	// void glFinalCombinerInputNV (GLenum variable, GLenum input, GLenum mapping, GLenum componentUsage)
	// void glGetCombinerInputParameterfvNV (GLenum stage, GLenum portion, GLenum variable, GLenum pname, GLfloat *params)
	// void glGetCombinerInputParameterivNV (GLenum stage, GLenum portion, GLenum variable, GLenum pname, GLint *params)
	// void glGetCombinerOutputParameterfvNV (GLenum stage, GLenum portion, GLenum pname, GLfloat *params)
	// void glGetCombinerOutputParameterivNV (GLenum stage, GLenum portion, GLenum pname, GLint *params)
	// void glGetFinalCombinerInputParameterfvNV (GLenum variable, GLenum pname, GLfloat *params)
	// void glGetFinalCombinerInputParameterivNV (GLenum variable, GLenum pname, GLint *params)
}
