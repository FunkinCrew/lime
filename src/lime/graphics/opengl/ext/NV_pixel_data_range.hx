package lime.graphics.opengl.ext;

@:keep
@:noCompletion class NV_pixel_data_range
{
	public var WRITE_PIXEL_DATA_RANGE_NV = 0x8878;
	public var READ_PIXEL_DATA_RANGE_NV = 0x8879;
	public var WRITE_PIXEL_DATA_RANGE_LENGTH_NV = 0x887A;
	public var READ_PIXEL_DATA_RANGE_LENGTH_NV = 0x887B;
	public var WRITE_PIXEL_DATA_RANGE_POINTER_NV = 0x887C;
	public var READ_PIXEL_DATA_RANGE_POINTER_NV = 0x887D;

	@:noCompletion private function new() {}

	// void glPixelDataRangeNV (GLenum target, GLsizei length, const void *pointer)
	// void glFlushPixelDataRangeNV (GLenum target)
}
