#include <graphics/format/SVG.h>
#include <graphics/ImageBuffer.h>
#include <graphics/PixelFormat.h>
#include <SDL3/SDL.h>
#include <SDL3_image/SDL_image.h>
#include <system/System.h>
#include <utils/File.h>

namespace lime
{

	bool SVG::Decode(File *file, ImageBuffer *imageBuffer)
	{
		if (!file->handle)
		{
			return false;
		}

		if (!IMG_isSVG((SDL_IOStream *)file->handle))
		{
			return false;
		}

		SDL_Surface *surface = IMG_LoadSVG_IO((SDL_IOStream *)file->handle);

		if (!surface)
		{
			return false;
		}

		if (surface->format != SDL_PIXELFORMAT_RGBA32)
		{
			SDL_Surface *old_surface = surface;
			surface = SDL_ConvertSurface(old_surface, SDL_PIXELFORMAT_RGBA32);
			SDL_DestroySurface(old_surface);
		}

		if (!surface)
		{
			return false;
		}

		imageBuffer->Resize(surface->w, surface->h, 32);

		memcpy(imageBuffer->data->buffer->b, surface->pixels, surface->h * surface->pitch);

		SDL_DestroySurface(surface);

		return true;
	}

	bool SVG::DecodeSized(File *file, int width, int height, ImageBuffer *imageBuffer)
	{
		if (!file->handle)
		{
			return false;
		}

		if (!IMG_isSVG((SDL_IOStream *)file->handle))
		{
			return false;
		}

		SDL_Surface *surface = IMG_LoadSizedSVG_IO((SDL_IOStream *)file->handle, width, height);

		if (!surface)
		{
			return false;
		}

		if (surface->format != SDL_PIXELFORMAT_RGBA32)
		{
			SDL_Surface *old_surface = surface;
			surface = SDL_ConvertSurface(old_surface, SDL_PIXELFORMAT_RGBA32);
			SDL_DestroySurface(old_surface);
		}

		if (!surface)
		{
			return false;
		}

		imageBuffer->Resize(surface->w, surface->h, 32);

		memcpy(imageBuffer->data->buffer->b, surface->pixels, surface->h * surface->pitch);

		SDL_DestroySurface(surface);

		return true;
	}

} // namespace lime
