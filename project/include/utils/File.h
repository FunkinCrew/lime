#pragma once

#include <SDL3/SDL.h>
#include <utils/Bytes.h>

namespace lime
{

	class File
	{
	  public:
		File(const char *path, const char *mode, bool wantBuffer);
		File(Bytes *bytes, bool copy);

		bool Close();
		bool Flush();
		size_t Read(void *ptr, size_t size);
		int64_t Seek(int64_t offset, int whence);
		int64_t Tell();
		size_t Write(const void *ptr, size_t size);

		void *ownedMemory;
		SDL_IOStream *handle;

	  private:
		bool isBuffered;
		unsigned char *buffer;
		size_t bufferLength;
		int64_t bufferStart;
		int64_t position;
		int64_t fileSize;
	};

} // namespace lime
