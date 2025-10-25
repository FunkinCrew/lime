package lime.graphics.opengl.ext;

@:keep
@:noCompletion class PGI_vertex_hints
{
	public var VERTEX_DATA_HINT_PGI = 0x1A22A;
	public var VERTEX_CONSISTENT_HINT_PGI = 0x1A22B;
	public var MATERIAL_SIDE_HINT_PGI = 0x1A22C;
	public var MAX_VERTEX_HINT_PGI = 0x1A22D;
	public var COLOR3_BIT_PGI = 0x00010000;
	public var COLOR4_BIT_PGI = 0x00020000;
	public var EDGEFLAG_BIT_PGI = 0x00040000;
	public var INDEX_BIT_PGI = 0x00080000;
	public var MAT_AMBIENT_BIT_PGI = 0x00100000;
	public var MAT_AMBIENT_AND_DIFFUSE_BIT_PGI = 0x00200000;
	public var MAT_DIFFUSE_BIT_PGI = 0x00400000;
	public var MAT_EMISSION_BIT_PGI = 0x00800000;
	public var MAT_COLOR_INDEXES_BIT_PGI = 0x01000000;
	public var MAT_SHININESS_BIT_PGI = 0x02000000;
	public var MAT_SPECULAR_BIT_PGI = 0x04000000;
	public var NORMAL_BIT_PGI = 0x08000000;
	public var TEXCOORD1_BIT_PGI = 0x10000000;
	public var TEXCOORD2_BIT_PGI = 0x20000000;
	public var TEXCOORD3_BIT_PGI = 0x40000000;
	public var TEXCOORD4_BIT_PGI = 0x80000000;
	public var VERTEX23_BIT_PGI = 0x00000004;
	public var VERTEX4_BIT_PGI = 0x00000008;

	@:noCompletion private function new() {}
}
