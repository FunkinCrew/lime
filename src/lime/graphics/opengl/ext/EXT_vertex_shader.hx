package lime.graphics.opengl.ext;

@:keep
@:noCompletion class EXT_vertex_shader
{
	public var VERTEX_SHADER_EXT = 0x8780;
	public var VERTEX_SHADER_BINDING_EXT = 0x8781;
	public var OP_INDEX_EXT = 0x8782;
	public var OP_NEGATE_EXT = 0x8783;
	public var OP_DOT3_EXT = 0x8784;
	public var OP_DOT4_EXT = 0x8785;
	public var OP_MUL_EXT = 0x8786;
	public var OP_ADD_EXT = 0x8787;
	public var OP_MADD_EXT = 0x8788;
	public var OP_FRAC_EXT = 0x8789;
	public var OP_MAX_EXT = 0x878A;
	public var OP_MIN_EXT = 0x878B;
	public var OP_SET_GE_EXT = 0x878C;
	public var OP_SET_LT_EXT = 0x878D;
	public var OP_CLAMP_EXT = 0x878E;
	public var OP_FLOOR_EXT = 0x878F;
	public var OP_ROUND_EXT = 0x8790;
	public var OP_EXP_BASE_2_EXT = 0x8791;
	public var OP_LOG_BASE_2_EXT = 0x8792;
	public var OP_POWER_EXT = 0x8793;
	public var OP_RECIP_EXT = 0x8794;
	public var OP_RECIP_SQRT_EXT = 0x8795;
	public var OP_SUB_EXT = 0x8796;
	public var OP_CROSS_PRODUCT_EXT = 0x8797;
	public var OP_MULTIPLY_MATRIX_EXT = 0x8798;
	public var OP_MOV_EXT = 0x8799;
	public var OUTPUT_VERTEX_EXT = 0x879A;
	public var OUTPUT_COLOR0_EXT = 0x879B;
	public var OUTPUT_COLOR1_EXT = 0x879C;
	public var OUTPUT_TEXTURE_COORD0_EXT = 0x879D;
	public var OUTPUT_TEXTURE_COORD1_EXT = 0x879E;
	public var OUTPUT_TEXTURE_COORD2_EXT = 0x879F;
	public var OUTPUT_TEXTURE_COORD3_EXT = 0x87A0;
	public var OUTPUT_TEXTURE_COORD4_EXT = 0x87A1;
	public var OUTPUT_TEXTURE_COORD5_EXT = 0x87A2;
	public var OUTPUT_TEXTURE_COORD6_EXT = 0x87A3;
	public var OUTPUT_TEXTURE_COORD7_EXT = 0x87A4;
	public var OUTPUT_TEXTURE_COORD8_EXT = 0x87A5;
	public var OUTPUT_TEXTURE_COORD9_EXT = 0x87A6;
	public var OUTPUT_TEXTURE_COORD10_EXT = 0x87A7;
	public var OUTPUT_TEXTURE_COORD11_EXT = 0x87A8;
	public var OUTPUT_TEXTURE_COORD12_EXT = 0x87A9;
	public var OUTPUT_TEXTURE_COORD13_EXT = 0x87AA;
	public var OUTPUT_TEXTURE_COORD14_EXT = 0x87AB;
	public var OUTPUT_TEXTURE_COORD15_EXT = 0x87AC;
	public var OUTPUT_TEXTURE_COORD16_EXT = 0x87AD;
	public var OUTPUT_TEXTURE_COORD17_EXT = 0x87AE;
	public var OUTPUT_TEXTURE_COORD18_EXT = 0x87AF;
	public var OUTPUT_TEXTURE_COORD19_EXT = 0x87B0;
	public var OUTPUT_TEXTURE_COORD20_EXT = 0x87B1;
	public var OUTPUT_TEXTURE_COORD21_EXT = 0x87B2;
	public var OUTPUT_TEXTURE_COORD22_EXT = 0x87B3;
	public var OUTPUT_TEXTURE_COORD23_EXT = 0x87B4;
	public var OUTPUT_TEXTURE_COORD24_EXT = 0x87B5;
	public var OUTPUT_TEXTURE_COORD25_EXT = 0x87B6;
	public var OUTPUT_TEXTURE_COORD26_EXT = 0x87B7;
	public var OUTPUT_TEXTURE_COORD27_EXT = 0x87B8;
	public var OUTPUT_TEXTURE_COORD28_EXT = 0x87B9;
	public var OUTPUT_TEXTURE_COORD29_EXT = 0x87BA;
	public var OUTPUT_TEXTURE_COORD30_EXT = 0x87BB;
	public var OUTPUT_TEXTURE_COORD31_EXT = 0x87BC;
	public var OUTPUT_FOG_EXT = 0x87BD;
	public var SCALAR_EXT = 0x87BE;
	public var VECTOR_EXT = 0x87BF;
	public var MATRIX_EXT = 0x87C0;
	public var VARIANT_EXT = 0x87C1;
	public var INVARIANT_EXT = 0x87C2;
	public var LOCAL_CONSTANT_EXT = 0x87C3;
	public var LOCAL_EXT = 0x87C4;
	public var MAX_VERTEX_SHADER_INSTRUCTIONS_EXT = 0x87C5;
	public var MAX_VERTEX_SHADER_VARIANTS_EXT = 0x87C6;
	public var MAX_VERTEX_SHADER_INVARIANTS_EXT = 0x87C7;
	public var MAX_VERTEX_SHADER_LOCAL_CONSTANTS_EXT = 0x87C8;
	public var MAX_VERTEX_SHADER_LOCALS_EXT = 0x87C9;
	public var MAX_OPTIMIZED_VERTEX_SHADER_INSTRUCTIONS_EXT = 0x87CA;
	public var MAX_OPTIMIZED_VERTEX_SHADER_VARIANTS_EXT = 0x87CB;
	public var MAX_OPTIMIZED_VERTEX_SHADER_LOCAL_CONSTANTS_EXT = 0x87CC;
	public var MAX_OPTIMIZED_VERTEX_SHADER_INVARIANTS_EXT = 0x87CD;
	public var MAX_OPTIMIZED_VERTEX_SHADER_LOCALS_EXT = 0x87CE;
	public var VERTEX_SHADER_INSTRUCTIONS_EXT = 0x87CF;
	public var VERTEX_SHADER_VARIANTS_EXT = 0x87D0;
	public var VERTEX_SHADER_INVARIANTS_EXT = 0x87D1;
	public var VERTEX_SHADER_LOCAL_CONSTANTS_EXT = 0x87D2;
	public var VERTEX_SHADER_LOCALS_EXT = 0x87D3;
	public var VERTEX_SHADER_OPTIMIZED_EXT = 0x87D4;
	public var X_EXT = 0x87D5;
	public var Y_EXT = 0x87D6;
	public var Z_EXT = 0x87D7;
	public var W_EXT = 0x87D8;
	public var NEGATIVE_X_EXT = 0x87D9;
	public var NEGATIVE_Y_EXT = 0x87DA;
	public var NEGATIVE_Z_EXT = 0x87DB;
	public var NEGATIVE_W_EXT = 0x87DC;
	public var ZERO_EXT = 0x87DD;
	public var ONE_EXT = 0x87DE;
	public var NEGATIVE_ONE_EXT = 0x87DF;
	public var NORMALIZED_RANGE_EXT = 0x87E0;
	public var FULL_RANGE_EXT = 0x87E1;
	public var CURRENT_VERTEX_EXT = 0x87E2;
	public var MVP_MATRIX_EXT = 0x87E3;
	public var VARIANT_VALUE_EXT = 0x87E4;
	public var VARIANT_DATATYPE_EXT = 0x87E5;
	public var VARIANT_ARRAY_STRIDE_EXT = 0x87E6;
	public var VARIANT_ARRAY_TYPE_EXT = 0x87E7;
	public var VARIANT_ARRAY_EXT = 0x87E8;
	public var VARIANT_ARRAY_POINTER_EXT = 0x87E9;
	public var INVARIANT_VALUE_EXT = 0x87EA;
	public var INVARIANT_DATATYPE_EXT = 0x87EB;
	public var LOCAL_CONSTANT_VALUE_EXT = 0x87EC;
	public var LOCAL_CONSTANT_DATATYPE_EXT = 0x87ED;

	@:noCompletion private function new() {}

	// void glBeginVertexShaderEXT ()
	// void glEndVertexShaderEXT ()
	// void glBindVertexShaderEXT (GLuint id)
	// GLuint glGenVertexShadersEXT (GLuint range)
	// void glDeleteVertexShaderEXT (GLuint id)
	// void glShaderOp1EXT (GLenum op, GLuint res, GLuint arg1)
	// void glShaderOp2EXT (GLenum op, GLuint res, GLuint arg1, GLuint arg2)
	// void glShaderOp3EXT (GLenum op, GLuint res, GLuint arg1, GLuint arg2, GLuint arg3)
	// void glSwizzleEXT (GLuint res, GLuint in, GLenum outX, GLenum outY, GLenum outZ, GLenum outW)
	// void glWriteMaskEXT (GLuint res, GLuint in, GLenum outX, GLenum outY, GLenum outZ, GLenum outW)
	// void glInsertComponentEXT (GLuint res, GLuint src, GLuint num)
	// void glExtractComponentEXT (GLuint res, GLuint src, GLuint num)
	// GLuint glGenSymbolsEXT (GLenum datatype, GLenum storagetype, GLenum range, GLuint components)
	// void glSetInvariantEXT (GLuint id, GLenum type, const void *addr)
	// void glSetLocalConstantEXT (GLuint id, GLenum type, const void *addr)
	// void glVariantbvEXT (GLuint id, const GLbyte *addr)
	// void glVariantsvEXT (GLuint id, const GLshort *addr)
	// void glVariantivEXT (GLuint id, const GLint *addr)
	// void glVariantfvEXT (GLuint id, const GLfloat *addr)
	// void glVariantdvEXT (GLuint id, const GLdouble *addr)
	// void glVariantubvEXT (GLuint id, const GLubyte *addr)
	// void glVariantusvEXT (GLuint id, const GLushort *addr)
	// void glVariantuivEXT (GLuint id, const GLuint *addr)
	// void glVariantPointerEXT (GLuint id, GLenum type, GLuint stride, const void *addr)
	// void glEnableVariantClientStateEXT (GLuint id)
	// void glDisableVariantClientStateEXT (GLuint id)
	// GLuint glBindLightParameterEXT (GLenum light, GLenum value)
	// GLuint glBindMaterialParameterEXT (GLenum face, GLenum value)
	// GLuint glBindTexGenParameterEXT (GLenum unit, GLenum coord, GLenum value)
	// GLuint glBindTextureUnitParameterEXT (GLenum unit, GLenum value)
	// GLuint glBindParameterEXT (GLenum value)
	// GLboolean glIsVariantEnabledEXT (GLuint id, GLenum cap)
	// void glGetVariantBooleanvEXT (GLuint id, GLenum value, GLboolean *data)
	// void glGetVariantIntegervEXT (GLuint id, GLenum value, GLint *data)
	// void glGetVariantFloatvEXT (GLuint id, GLenum value, GLfloat *data)
	// void glGetVariantPointervEXT (GLuint id, GLenum value, void **data)
	// void glGetInvariantBooleanvEXT (GLuint id, GLenum value, GLboolean *data)
	// void glGetInvariantIntegervEXT (GLuint id, GLenum value, GLint *data)
	// void glGetInvariantFloatvEXT (GLuint id, GLenum value, GLfloat *data)
	// void glGetLocalConstantBooleanvEXT (GLuint id, GLenum value, GLboolean *data)
	// void glGetLocalConstantIntegervEXT (GLuint id, GLenum value, GLint *data)
	// void glGetLocalConstantFloatvEXT (GLuint id, GLenum value, GLfloat *data)
}
