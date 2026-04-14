#ifndef LIME_GRAPHICS_OPENGL_OPENGL_BINDINGS_H
#define LIME_GRAPHICS_OPENGL_OPENGL_BINDINGS_H


#ifdef LIME_GLAD

#include <glad/gles2.h>

#else

#if defined (IPHONE) || defined(APPLETV)
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#endif

#endif


namespace lime {


	class OpenGLBindings {

		public:

			static bool Init ();

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