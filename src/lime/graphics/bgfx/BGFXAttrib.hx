package lime.graphics.bgfx;

enum abstract BGFXAttrib(Int) from Int to Int
{
	var POSITION = 0; //!< a_position
	var NORMAL = 1; //!< a_normal
	var TANGENT = 2; //!< a_tangent
	var BITANGENT = 3; //!< a_bitangent
	var COLOR0 = 4; //!< a_color0
	var COLOR1 = 5; //!< a_color1
	var COLOR2 = 6; //!< a_color2
	var COLOR3 = 7; //!< a_color3
	var INDICES = 8; //!< a_indices
	var WEIGHT = 9; //!< a_weight
	var TEXCOORD0 = 10; //!< a_texcoord0
	var TEXCOORD1 = 11; //!< a_texcoord1
	var TEXCOORD2 = 12; //!< a_texcoord2
	var TEXCOORD3 = 13; //!< a_texcoord3
	var TEXCOORD4 = 14; //!< a_texcoord4
	var TEXCOORD5 = 15; //!< a_texcoord5
	var TEXCOORD6 = 16; //!< a_texcoord6
	var TEXCOORD7 = 17; //!< a_texcoord7
}
