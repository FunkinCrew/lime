#include <system/System.h>
#include <graphics/ImageBuffer.h>
#include <graphics/PixelFormat.h>
#include <graphics/format/SVG.h>
#include <utils/File.h>

#include <SDL3/SDL.h>
#include <SDL3_image/SDL_image.h>

namespace lime {


	bool SVG::Decode (Resource *resource, ImageBuffer *imageBuffer) {

		File file = resource->path ? File (resource->path, "rb") : File (resource->data);

		if (!file.handle) {

			return false;

		}

		if (!IMG_isSVG ((SDL_IOStream *)file.handle)) {

			file.Close ();

			return false;

		}

		SDL_Surface *surface = IMG_LoadSVG_IO ((SDL_IOStream *)file.handle);

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


	bool SVG::DecodeSized (Resource *resource, int width, int height, ImageBuffer *imageBuffer) {

		File file = resource->path ? File (resource->path, "rb") : File (resource->data);

		if (!file.handle) {

			return false;

		}

		if (!IMG_isSVG ((SDL_IOStream *)file.handle)) {

			file.Close ();

			return false;

		}

		SDL_Surface *surface = IMG_LoadSizedSVG_IO ((SDL_IOStream *)file.handle, width, height);

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


}
