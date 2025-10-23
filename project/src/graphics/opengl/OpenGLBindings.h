#ifndef LIME_GRAPHICS_OPENGL_OPENGL_BINDINGS_H
#define LIME_GRAPHICS_OPENGL_OPENGL_BINDINGS_H

#ifdef LIME_GL
#include <glad/gl.h>
#endif

#ifdef LIME_GLES2
#include <glad/gles2.h>
#endif

#ifdef LIME_EGL
#include <glad/egl.h>
#endif

namespace lime {


	class OpenGLBindings {

		public:

			static void Init ();

			static int defaultFramebuffer;
			static int defaultRenderbuffer;
		private:

			static bool initialized;


	};


	enum GLObjectType {

		TYPE_UNKNOWN,
		TYPE_PROGRAM,
		TYPE_SHADER,
		TYPE_BUFFER,
		TYPE_TEXTURE,
		TYPE_FRAMEBUFFER,
		TYPE_RENDERBUFFER,
		TYPE_VERTEX_ARRAY_OBJECT,
		TYPE_QUERY,
		TYPE_SAMPLER,
		TYPE_SYNC,
		TYPE_TRANSFORM_FEEDBACK

	};


}


#endif