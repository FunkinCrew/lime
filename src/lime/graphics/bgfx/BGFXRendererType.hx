package lime.graphics.bgfx;

enum abstract BGFXRendererType(Int) from Int to Int
{
	var NOOP = 0; 		//!< No rendering.
	var AGC = 1; 		//!< AGC
	var DIRECT3D11 = 2; //!< Direct3D 11.0
	var DIRECT3D12 = 3; //!< Direct3D 12.0
	var GNM = 4; 		//!< GNM
	var METAL = 5; 		//!< Metal
	var NVN = 6; 		//!< NVN
	var OPENGLES = 7; 	//!< OpenGL ES 2.0+
	var OPENGL = 8; 	//!< OpenGL 2.1+
	var VULKAN = 9; 	//!< Vulkan
	var WEBGPU = 10; 	//!< WebGPU
}
