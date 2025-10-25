package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_path_rendering
{
	public var PATH_FORMAT_SVG_NV = 0x9070;
	public var PATH_FORMAT_PS_NV = 0x9071;
	public var STANDARD_FONT_NAME_NV = 0x9072;
	public var SYSTEM_FONT_NAME_NV = 0x9073;
	public var FILE_NAME_NV = 0x9074;
	public var PATH_STROKE_WIDTH_NV = 0x9075;
	public var PATH_END_CAPS_NV = 0x9076;
	public var PATH_INITIAL_END_CAP_NV = 0x9077;
	public var PATH_TERMINAL_END_CAP_NV = 0x9078;
	public var PATH_JOIN_STYLE_NV = 0x9079;
	public var PATH_MITER_LIMIT_NV = 0x907A;
	public var PATH_DASH_CAPS_NV = 0x907B;
	public var PATH_INITIAL_DASH_CAP_NV = 0x907C;
	public var PATH_TERMINAL_DASH_CAP_NV = 0x907D;
	public var PATH_DASH_OFFSET_NV = 0x907E;
	public var PATH_CLIENT_LENGTH_NV = 0x907F;
	public var PATH_FILL_MODE_NV = 0x9080;
	public var PATH_FILL_MASK_NV = 0x9081;
	public var PATH_FILL_COVER_MODE_NV = 0x9082;
	public var PATH_STROKE_COVER_MODE_NV = 0x9083;
	public var PATH_STROKE_MASK_NV = 0x9084;
	public var COUNT_UP_NV = 0x9088;
	public var COUNT_DOWN_NV = 0x9089;
	public var PATH_OBJECT_BOUNDING_BOX_NV = 0x908A;
	public var CONVEX_HULL_NV = 0x908B;
	public var BOUNDING_BOX_NV = 0x908D;
	public var TRANSLATE_X_NV = 0x908E;
	public var TRANSLATE_Y_NV = 0x908F;
	public var TRANSLATE_2D_NV = 0x9090;
	public var TRANSLATE_3D_NV = 0x9091;
	public var AFFINE_2D_NV = 0x9092;
	public var AFFINE_3D_NV = 0x9094;
	public var TRANSPOSE_AFFINE_2D_NV = 0x9096;
	public var TRANSPOSE_AFFINE_3D_NV = 0x9098;
	public var UTF8_NV = 0x909A;
	public var UTF16_NV = 0x909B;
	public var BOUNDING_BOX_OF_BOUNDING_BOXES_NV = 0x909C;
	public var PATH_COMMAND_COUNT_NV = 0x909D;
	public var PATH_COORD_COUNT_NV = 0x909E;
	public var PATH_DASH_ARRAY_COUNT_NV = 0x909F;
	public var PATH_COMPUTED_LENGTH_NV = 0x90A0;
	public var PATH_FILL_BOUNDING_BOX_NV = 0x90A1;
	public var PATH_STROKE_BOUNDING_BOX_NV = 0x90A2;
	public var SQUARE_NV = 0x90A3;
	public var ROUND_NV = 0x90A4;
	public var TRIANGULAR_NV = 0x90A5;
	public var BEVEL_NV = 0x90A6;
	public var MITER_REVERT_NV = 0x90A7;
	public var MITER_TRUNCATE_NV = 0x90A8;
	public var SKIP_MISSING_GLYPH_NV = 0x90A9;
	public var USE_MISSING_GLYPH_NV = 0x90AA;
	public var PATH_ERROR_POSITION_NV = 0x90AB;
	public var ACCUM_ADJACENT_PAIRS_NV = 0x90AD;
	public var ADJACENT_PAIRS_NV = 0x90AE;
	public var FIRST_TO_REST_NV = 0x90AF;
	public var PATH_GEN_MODE_NV = 0x90B0;
	public var PATH_GEN_COEFF_NV = 0x90B1;
	public var PATH_GEN_COMPONENTS_NV = 0x90B3;
	public var PATH_STENCIL_FUNC_NV = 0x90B7;
	public var PATH_STENCIL_REF_NV = 0x90B8;
	public var PATH_STENCIL_VALUE_MASK_NV = 0x90B9;
	public var PATH_STENCIL_DEPTH_OFFSET_FACTOR_NV = 0x90BD;
	public var PATH_STENCIL_DEPTH_OFFSET_UNITS_NV = 0x90BE;
	public var PATH_COVER_DEPTH_FUNC_NV = 0x90BF;
	public var PATH_DASH_OFFSET_RESET_NV = 0x90B4;
	public var MOVE_TO_RESETS_NV = 0x90B5;
	public var MOVE_TO_CONTINUES_NV = 0x90B6;
	public var CLOSE_PATH_NV = 0x00;
	public var MOVE_TO_NV = 0x02;
	public var RELATIVE_MOVE_TO_NV = 0x03;
	public var LINE_TO_NV = 0x04;
	public var RELATIVE_LINE_TO_NV = 0x05;
	public var HORIZONTAL_LINE_TO_NV = 0x06;
	public var RELATIVE_HORIZONTAL_LINE_TO_NV = 0x07;
	public var VERTICAL_LINE_TO_NV = 0x08;
	public var RELATIVE_VERTICAL_LINE_TO_NV = 0x09;
	public var QUADRATIC_CURVE_TO_NV = 0x0A;
	public var RELATIVE_QUADRATIC_CURVE_TO_NV = 0x0B;
	public var CUBIC_CURVE_TO_NV = 0x0C;
	public var RELATIVE_CUBIC_CURVE_TO_NV = 0x0D;
	public var SMOOTH_QUADRATIC_CURVE_TO_NV = 0x0E;
	public var RELATIVE_SMOOTH_QUADRATIC_CURVE_TO_NV = 0x0F;
	public var SMOOTH_CUBIC_CURVE_TO_NV = 0x10;
	public var RELATIVE_SMOOTH_CUBIC_CURVE_TO_NV = 0x11;
	public var SMALL_CCW_ARC_TO_NV = 0x12;
	public var RELATIVE_SMALL_CCW_ARC_TO_NV = 0x13;
	public var SMALL_CW_ARC_TO_NV = 0x14;
	public var RELATIVE_SMALL_CW_ARC_TO_NV = 0x15;
	public var LARGE_CCW_ARC_TO_NV = 0x16;
	public var RELATIVE_LARGE_CCW_ARC_TO_NV = 0x17;
	public var LARGE_CW_ARC_TO_NV = 0x18;
	public var RELATIVE_LARGE_CW_ARC_TO_NV = 0x19;
	public var RESTART_PATH_NV = 0xF0;
	public var DUP_FIRST_CUBIC_CURVE_TO_NV = 0xF2;
	public var DUP_LAST_CUBIC_CURVE_TO_NV = 0xF4;
	public var RECT_NV = 0xF6;
	public var CIRCULAR_CCW_ARC_TO_NV = 0xF8;
	public var CIRCULAR_CW_ARC_TO_NV = 0xFA;
	public var CIRCULAR_TANGENT_ARC_TO_NV = 0xFC;
	public var ARC_TO_NV = 0xFE;
	public var RELATIVE_ARC_TO_NV = 0xFF;
	public var BOLD_BIT_NV = 0x01;
	public var ITALIC_BIT_NV = 0x02;
	public var GLYPH_WIDTH_BIT_NV = 0x01;
	public var GLYPH_HEIGHT_BIT_NV = 0x02;
	public var GLYPH_HORIZONTAL_BEARING_X_BIT_NV = 0x04;
	public var GLYPH_HORIZONTAL_BEARING_Y_BIT_NV = 0x08;
	public var GLYPH_HORIZONTAL_BEARING_ADVANCE_BIT_NV = 0x10;
	public var GLYPH_VERTICAL_BEARING_X_BIT_NV = 0x20;
	public var GLYPH_VERTICAL_BEARING_Y_BIT_NV = 0x40;
	public var GLYPH_VERTICAL_BEARING_ADVANCE_BIT_NV = 0x80;
	public var GLYPH_HAS_KERNING_BIT_NV = 0x100;
	public var FONT_X_MIN_BOUNDS_BIT_NV = 0x00010000;
	public var FONT_Y_MIN_BOUNDS_BIT_NV = 0x00020000;
	public var FONT_X_MAX_BOUNDS_BIT_NV = 0x00040000;
	public var FONT_Y_MAX_BOUNDS_BIT_NV = 0x00080000;
	public var FONT_UNITS_PER_EM_BIT_NV = 0x00100000;
	public var FONT_ASCENDER_BIT_NV = 0x00200000;
	public var FONT_DESCENDER_BIT_NV = 0x00400000;
	public var FONT_HEIGHT_BIT_NV = 0x00800000;
	public var FONT_MAX_ADVANCE_WIDTH_BIT_NV = 0x01000000;
	public var FONT_MAX_ADVANCE_HEIGHT_BIT_NV = 0x02000000;
	public var FONT_UNDERLINE_POSITION_BIT_NV = 0x04000000;
	public var FONT_UNDERLINE_THICKNESS_BIT_NV = 0x08000000;
	public var FONT_HAS_KERNING_BIT_NV = 0x10000000;

	@:noCompletion private function new() {}

	// GLuint glGenPathsNV (GLsizei range)
	// void glDeletePathsNV (GLuint path, GLsizei range)
	// GLboolean glIsPathNV (GLuint path)
	// void glPathCommandsNV (GLuint path, GLsizei numCommands, const GLubyte *commands, GLsizei numCoords, GLenum coordType, const void *coords)
	// void glPathCoordsNV (GLuint path, GLsizei numCoords, GLenum coordType, const void *coords)
	// void glPathSubCommandsNV (GLuint path, GLsizei commandStart, GLsizei commandsToDelete, GLsizei numCommands, const GLubyte *commands, GLsizei numCoords, GLenum coordType, const void *coords)
	// void glPathSubCoordsNV (GLuint path, GLsizei coordStart, GLsizei numCoords, GLenum coordType, const void *coords)
	// void glPathStringNV (GLuint path, GLenum format, GLsizei length, const void *pathString)
	// void glPathGlyphsNV (GLuint firstPathName, GLenum fontTarget, const void *fontName, GLbitfield fontStyle, GLsizei numGlyphs, GLenum type, const void *charcodes, GLenum handleMissingGlyphs, GLuint pathParameterTemplate, GLfloat emScale)
	// void glPathGlyphRangeNV (GLuint firstPathName, GLenum fontTarget, const void *fontName, GLbitfield fontStyle, GLuint firstGlyph, GLsizei numGlyphs, GLenum handleMissingGlyphs, GLuint pathParameterTemplate, GLfloat emScale)
	// void glWeightPathsNV (GLuint resultPath, GLsizei numPaths, const GLuint *paths, const GLfloat *weights)
	// void glCopyPathNV (GLuint resultPath, GLuint srcPath)
	// void glInterpolatePathsNV (GLuint resultPath, GLuint pathA, GLuint pathB, GLfloat weight)
	// void glTransformPathNV (GLuint resultPath, GLuint srcPath, GLenum transformType, const GLfloat *transformValues)
	// void glPathParameterivNV (GLuint path, GLenum pname, const GLint *value)
	// void glPathParameteriNV (GLuint path, GLenum pname, GLint value)
	// void glPathParameterfvNV (GLuint path, GLenum pname, const GLfloat *value)
	// void glPathParameterfNV (GLuint path, GLenum pname, GLfloat value)
	// void glPathDashArrayNV (GLuint path, GLsizei dashCount, const GLfloat *dashArray)
	// void glPathStencilFuncNV (GLenum func, GLint ref, GLuint mask)
	// void glPathStencilDepthOffsetNV (GLfloat factor, GLfloat units)
	// void glStencilFillPathNV (GLuint path, GLenum fillMode, GLuint mask)
	// void glStencilStrokePathNV (GLuint path, GLint reference, GLuint mask)
	// void glStencilFillPathInstancedNV (GLsizei numPaths, GLenum pathNameType, const void *paths, GLuint pathBase, GLenum fillMode, GLuint mask, GLenum transformType, const GLfloat *transformValues)
	// void glStencilStrokePathInstancedNV (GLsizei numPaths, GLenum pathNameType, const void *paths, GLuint pathBase, GLint reference, GLuint mask, GLenum transformType, const GLfloat *transformValues)
	// void glPathCoverDepthFuncNV (GLenum func)
	// void glCoverFillPathNV (GLuint path, GLenum coverMode)
	// void glCoverStrokePathNV (GLuint path, GLenum coverMode)
	// void glCoverFillPathInstancedNV (GLsizei numPaths, GLenum pathNameType, const void *paths, GLuint pathBase, GLenum coverMode, GLenum transformType, const GLfloat *transformValues)
	// void glCoverStrokePathInstancedNV (GLsizei numPaths, GLenum pathNameType, const void *paths, GLuint pathBase, GLenum coverMode, GLenum transformType, const GLfloat *transformValues)
	// void glGetPathParameterivNV (GLuint path, GLenum pname, GLint *value)
	// void glGetPathParameterfvNV (GLuint path, GLenum pname, GLfloat *value)
	// void glGetPathCommandsNV (GLuint path, GLubyte *commands)
	// void glGetPathCoordsNV (GLuint path, GLfloat *coords)
	// void glGetPathDashArrayNV (GLuint path, GLfloat *dashArray)
	// void glGetPathMetricsNV (GLbitfield metricQueryMask, GLsizei numPaths, GLenum pathNameType, const void *paths, GLuint pathBase, GLsizei stride, GLfloat *metrics)
	// void glGetPathMetricRangeNV (GLbitfield metricQueryMask, GLuint firstPathName, GLsizei numPaths, GLsizei stride, GLfloat *metrics)
	// void glGetPathSpacingNV (GLenum pathListMode, GLsizei numPaths, GLenum pathNameType, const void *paths, GLuint pathBase, GLfloat advanceScale, GLfloat kerningScale, GLenum transformType, GLfloat *returnedSpacing)
	// GLboolean glIsPointInFillPathNV (GLuint path, GLuint mask, GLfloat x, GLfloat y)
	// GLboolean glIsPointInStrokePathNV (GLuint path, GLfloat x, GLfloat y)
	// GLfloat glGetPathLengthNV (GLuint path, GLsizei startSegment, GLsizei numSegments)
	// GLboolean glPointAlongPathNV (GLuint path, GLsizei startSegment, GLsizei numSegments, GLfloat distance, GLfloat *x, GLfloat *y, GLfloat *tangentX, GLfloat *tangentY)
}
