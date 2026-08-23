#pragma once

#include <graphics/ImageBuffer.h>
#include <utils/File.h>
#include <utils/Resource.h>

namespace lime
{

	class AnimationDecoder
	{
	  public:
		~AnimationDecoder();

		bool Open(Resource *resource, const char *type);
		bool GetFrame(ImageBuffer *imageBuffer, int64_t *duration);
		int GetStatus();
		bool Reset();

	  private:
		File *file;
		void *handle;
	};

} // namespace lime
