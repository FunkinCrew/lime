#include <system/System.h>
#include <graphics/ImageBuffer.h>
#include <graphics/PixelFormat.h>
#include <graphics/format/BMP.h>
#include <utils/File.h>

#include <SDL3/SDL.h>
#include <SDL3_image/SDL_image.h>
#include <climits>

namespace lime {


	bool BMP::Decode (Resource *resource, ImageBuffer *imageBuffer) {

		File file = resource->path ? File (resource->path, "rb") : File (resource->data);

		if (!file.handle) {

			return false;

		}

		if (!IMG_isBMP ((SDL_IOStream *)file.handle)) {

			file.Close ();

			return false;

		}

		SDL_Surface *surface = IMG_LoadBMP_IO ((SDL_IOStream *)file.handle);

		if (!surface) {

			file.Close ();

			return false;

		}

		if (surface->format != SDL_PIXELFORMAT_RGBA32) {

			SDL_Surface *old_surface = surface;
			surface = SDL_ConvertSurface (old_surface, SDL_PIXELFORMAT_RGBA32);
			SDL_DestroySurface (old_surface);

		}

		if (!surface) {

			file.Close ();

			return false;

		}

		imageBuffer->Resize (surface->w, surface->h, 32);

		memcpy (imageBuffer->data->buffer->b, surface->pixels, surface->h * surface->pitch);

		SDL_DestroySurface (surface);

		file.Close ();

		return true;

	}


	bool BMP::Encode (ImageBuffer *imageBuffer, Bytes* bytes) {

		SDL_Surface *surface = SDL_CreateSurfaceFrom(imageBuffer->width, imageBuffer->height, SDL_PIXELFORMAT_RGBA32, imageBuffer->data->buffer->b, imageBuffer->Stride ());

		if (!surface) {

			return false;

		}

		SDL_IOStream *dst = SDL_IOFromDynamicMem ();

		if (!dst) {

			SDL_DestroySurface (surface);

			return false;

		}

		bool success;

		if (bytes) {

			success = IMG_SaveBMP_IO (surface, dst, false);

			if (success) {

				int64_t size = SDL_TellIO(dst);

				if (size <= 0 || size > INT_MAX) {

					success = false;

				} else {

					SDL_SeekIO (dst, 0, SDL_IO_SEEK_SET);
					bytes->Resize ((int)size);
					SDL_ReadIO (dst, bytes->b, (size_t)size);

				}

			}

		} else {

			success = false;

		}

		SDL_CloseIO(dst);
		SDL_DestroySurface (surface);

		return success;

	}


}
