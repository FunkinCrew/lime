#include <utils/File.h>

namespace lime
{

	static const size_t BUFFER_SIZE = 256 * 1024;

	File::File(const char *path, const char *mode, bool wantBuffer)
	{
		ownedMemory = NULL;
		isBuffered = false;
		buffer = NULL;
		bufferLength = 0;
		bufferStart = 0;
		position = 0;
		fileSize = -1;

#if defined(ANDROID) || defined(IPHONE)
		handle = NULL;

#ifdef ANDROID
		const bool uri = SDL_strstr(path, "://");
#else
		const bool uri = false;
#endif

		if ((*path) != '/' && !uri)
		{
			char *cwd = SDL_GetCurrentDirectory();

			const char *dirs[2] = {SDL_GetBasePath(), cwd};

			for (int i = 0; i < 2 && !handle; i++)
			{
				char *fullpath;

				if (dirs[i] && SDL_asprintf(&fullpath, "%s%s", dirs[i], path) >= 0)
				{
					handle = SDL_IOFromFile(fullpath, mode);

					SDL_free(fullpath);
				}
			}

			SDL_free(cwd);
		}
		else
		{
			handle = SDL_IOFromFile(path, mode);
		}
#else
		handle = SDL_IOFromFile(path, mode);
#endif

		if (wantBuffer && handle && mode[0] == 'r' && !SDL_strchr(mode, '+'))
		{
			SDL_SeekIO(handle, 0, SDL_IO_SEEK_END);

			fileSize = SDL_TellIO(handle);

			SDL_SeekIO(handle, 0, SDL_IO_SEEK_SET);

			if (fileSize > 0)
			{
				buffer = (unsigned char *)SDL_malloc(BUFFER_SIZE);

				isBuffered = buffer != NULL;
			}
		}
	}

	File::File(Bytes *bytes, bool copy)
	{
		ownedMemory = NULL;
		isBuffered = false;
		buffer = NULL;
		bufferLength = 0;
		bufferStart = 0;
		position = 0;
		fileSize = -1;

		if (!bytes || !bytes->b || bytes->length == 0)
		{
			handle = NULL;
			return;
		}

		if (copy)
		{
			ownedMemory = SDL_malloc(bytes->length);

			SDL_memcpy(ownedMemory, bytes->b, bytes->length);

			handle = SDL_IOFromMem(ownedMemory, bytes->length);
		}
		else
		{
			handle = SDL_IOFromConstMem(bytes->b, bytes->length);
		}
	}

	bool File::Close()
	{
		bool result = false;

		if (handle)
		{
			result = SDL_CloseIO(handle);
			handle = NULL;
		}

		if (ownedMemory)
		{
			SDL_free(ownedMemory);
			ownedMemory = NULL;
		}

		if (buffer)
		{
			SDL_free(buffer);
			buffer = NULL;
		}

		isBuffered = false;

		return result;
	}

	bool File::Flush()
	{
		return handle ? SDL_FlushIO(handle) : false;
	}

	size_t File::Read(void *ptr, size_t size)
	{
		if (handle)
		{
			if (isBuffered)
			{
				unsigned char *out = (unsigned char *)ptr;

				size_t totalRead = 0;

				while (totalRead < size && position < fileSize)
				{
					bool inBuffer = position >= bufferStart && position < bufferStart + (int64_t)bufferLength;

					if (!inBuffer)
					{
						if (SDL_SeekIO(handle, position, SDL_IO_SEEK_SET) < 0)
						{
							break;
						}

						bufferStart = position;

						bufferLength = SDL_ReadIO(handle, buffer, BUFFER_SIZE);

						if (bufferLength == 0)
						{
							break;
						}
					}

					size_t offset = (size_t)(position - bufferStart);
					size_t available = bufferLength - offset;
					size_t count = (size - totalRead < available) ? (size - totalRead) : available;

					SDL_memcpy(out + totalRead, buffer + offset, count);

					totalRead += count;

					position += (int64_t)count;
				}

				return totalRead;
			}

			return SDL_ReadIO(handle, ptr, size);
		}

		return 0;
	}

	int64_t File::Seek(int64_t offset, int whence)
	{
		if (handle)
		{
			if (isBuffered)
			{
				int64_t target;

				switch (whence)
				{
					case SEEK_SET:
						target = offset;
						break;
					case SEEK_CUR:
						target = position + offset;
						break;
					case SEEK_END:
						target = fileSize + offset;
						break;
				}

				if (target < 0)
				{
					return -1;
				}

				position = target;

				return position;
			}

			SDL_IOWhence sdlWhence;

			switch (whence)
			{
				case SEEK_SET:
					sdlWhence = SDL_IO_SEEK_SET;
					break;
				case SEEK_CUR:
					sdlWhence = SDL_IO_SEEK_CUR;
					break;
				case SEEK_END:
					sdlWhence = SDL_IO_SEEK_END;
					break;
			}

			return SDL_SeekIO(handle, offset, sdlWhence);
		}

		return -1;
	}

	int64_t File::Tell()
	{
		return handle ? (isBuffered ? position : SDL_TellIO(handle)) : -1;
	}

	size_t File::Write(const void *ptr, size_t size)
	{
		return handle ? SDL_WriteIO(handle, ptr, size) : 0;
	}

} // namespace lime
