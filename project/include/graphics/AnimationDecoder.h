#pragma once

#include <graphics/ImageBuffer.h>
#include <utils/File.h>

namespace lime
{

	class AnimationDecoder
	{
	  public:
		AnimationDecoder();
		~AnimationDecoder();

		bool Open(File *file, const char *type);
		bool GetFrame(ImageBuffer *imageBuffer, int64_t *duration);
		int GetStatus();
		bool Reset();

	  private:
		File *file;
		void *handle;
	};

} // namespace lime
