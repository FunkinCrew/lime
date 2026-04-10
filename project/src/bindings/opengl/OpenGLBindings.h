#pragma once


#ifdef LIME_GLAD

#if defined (LIME_OPENGL_GL)
#include <glad/gl.h>
#elif defined (LIME_OPENGL_GLES2)
#include <glad/gles2.h>
#endif

#else

#if defined (IPHONE) || defined(APPLETV)
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#endif

#endif


namespace lime {


	class OpenGLBindings {

		public:

			static bool initialized;
			static bool Init ();

			static int defaultFramebuffer;
			static int defaultRenderbuffer;

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