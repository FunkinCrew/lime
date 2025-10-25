package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIX_fragment_lighting
{
	public var FRAGMENT_LIGHTING_SGIX = 0x8400;
	public var FRAGMENT_COLOR_MATERIAL_SGIX = 0x8401;
	public var FRAGMENT_COLOR_MATERIAL_FACE_SGIX = 0x8402;
	public var FRAGMENT_COLOR_MATERIAL_PARAMETER_SGIX = 0x8403;
	public var MAX_FRAGMENT_LIGHTS_SGIX = 0x8404;
	public var MAX_ACTIVE_LIGHTS_SGIX = 0x8405;
	public var CURRENT_RASTER_NORMAL_SGIX = 0x8406;
	public var LIGHT_ENV_MODE_SGIX = 0x8407;
	public var FRAGMENT_LIGHT_MODEL_LOCAL_VIEWER_SGIX = 0x8408;
	public var FRAGMENT_LIGHT_MODEL_TWO_SIDE_SGIX = 0x8409;
	public var FRAGMENT_LIGHT_MODEL_AMBIENT_SGIX = 0x840A;
	public var FRAGMENT_LIGHT_MODEL_NORMAL_INTERPOLATION_SGIX = 0x840B;
	public var FRAGMENT_LIGHT0_SGIX = 0x840C;
	public var FRAGMENT_LIGHT1_SGIX = 0x840D;
	public var FRAGMENT_LIGHT2_SGIX = 0x840E;
	public var FRAGMENT_LIGHT3_SGIX = 0x840F;
	public var FRAGMENT_LIGHT4_SGIX = 0x8410;
	public var FRAGMENT_LIGHT5_SGIX = 0x8411;
	public var FRAGMENT_LIGHT6_SGIX = 0x8412;
	public var FRAGMENT_LIGHT7_SGIX = 0x8413;

	@:noCompletion private function new() {}

	// void glFragmentColorMaterialSGIX (GLenum face, GLenum mode)
	// void glFragmentLightfSGIX (GLenum light, GLenum pname, GLfloat param)
	// void glFragmentLightfvSGIX (GLenum light, GLenum pname, const GLfloat *params)
	// void glFragmentLightiSGIX (GLenum light, GLenum pname, GLint param)
	// void glFragmentLightivSGIX (GLenum light, GLenum pname, const GLint *params)
	// void glFragmentLightModelfSGIX (GLenum pname, GLfloat param)
	// void glFragmentLightModelfvSGIX (GLenum pname, const GLfloat *params)
	// void glFragmentLightModeliSGIX (GLenum pname, GLint param)
	// void glFragmentLightModelivSGIX (GLenum pname, const GLint *params)
	// void glFragmentMaterialfSGIX (GLenum face, GLenum pname, GLfloat param)
	// void glFragmentMaterialfvSGIX (GLenum face, GLenum pname, const GLfloat *params)
	// void glFragmentMaterialiSGIX (GLenum face, GLenum pname, GLint param)
	// void glFragmentMaterialivSGIX (GLenum face, GLenum pname, const GLint *params)
	// void glGetFragmentLightfvSGIX (GLenum light, GLenum pname, GLfloat *params)
	// void glGetFragmentLightivSGIX (GLenum light, GLenum pname, GLint *params)
	// void glGetFragmentMaterialfvSGIX (GLenum face, GLenum pname, GLfloat *params)
	// void glGetFragmentMaterialivSGIX (GLenum face, GLenum pname, GLint *params)
	// void glLightEnviSGIX (GLenum pname, GLint param)
}
