#include <utils/File.h>


#include <SDL3/SDL.h>


namespace lime {


	File::File (const char* path, const char* mode) {

		handle = (void *)SDL_IOFromFile (path, mode);

		if (!handle) {

			const char *base = SDL_GetBasePath ();

			if (base) {

				char *fullpath;

				if (SDL_asprintf (&fullpath, "%s%s", base, path) >= 0) {

					handle = (void *)SDL_IOFromFile (fullpath, mode);

					SDL_free (fullpath);

				}

			}

		}

	}


	File::File (Bytes* data) {

		handle = (void *)SDL_IOFromConstMem (data->b, data->length);

	}


	bool File::Close () {

		if (handle) {

			SDL_CloseIO ((SDL_IOStream *)handle);
			handle = NULL;
			return true;

		}

		return false;

	}


	bool File::Flush () {

		return handle ? SDL_FlushIO ((SDL_IOStream *)handle) : false;

	}


	size_t File::Read (void *ptr, size_t size) {

		return handle ? SDL_ReadIO ((SDL_IOStream *)handle, ptr, size) : -1;

	}


	int64_t File::Seek (int64_t offset, int whence) {

		if (!handle) {

			return -1;

		}

		SDL_IOWhence sdlWhence;

		switch (whence) {

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

		return SDL_SeekIO ((SDL_IOStream *)handle, offset, sdlWhence);

	}


	int64_t File::Tell () {

		return handle ? SDL_TellIO ((SDL_IOStream *)handle) : -1;

	}


	size_t File::Write (const void *ptr, size_t size) {

		return handle ? SDL_WriteIO ((SDL_IOStream *)handle, ptr, size) : -1;

	}


}
