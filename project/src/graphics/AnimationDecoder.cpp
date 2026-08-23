#include <graphics/AnimationDecoder.h>
#include <graphics/ImageBuffer.h>
#include <SDL3/SDL.h>
#include <SDL3_image/SDL_image.h>

namespace lime
{
	AnimationDecoder::~AnimationDecoder()
	{
		if (handle)
		{
			IMG_CloseAnimationDecoder((IMG_AnimationDecoder *)handle);
			handle = nullptr;
		}

		if (file->handle)
		{
			file->Close();
		}
	}

	bool AnimationDecoder::Open(Resource *resource, const char *type)
	{
		file = resource->path ? new File(resource->path, "rb") : new File(resource->data, true);

		if (!file->handle)
		{
			return false;
		}

		IMG_AnimationDecoder *decoder = IMG_CreateAnimationDecoder_IO((SDL_IOStream *)file->handle, false, type);

		if (!decoder)
		{
			file->Close();

			return false;
		}

		this->handle = decoder;

		return true;
	}

	bool AnimationDecoder::GetFrame(ImageBuffer *imageBuffer, int64_t *duration)
	{
		if (!handle || !imageBuffer)
		{
			return false;
		}

		SDL_Surface *frame = nullptr;

		Uint64 frameDuration = 0;

		bool success = IMG_GetAnimationDecoderFrame((IMG_AnimationDecoder *)handle, &frame, &frameDuration);

		if (!success || !frame)
		{
			return false;
		}

		if (frame->format != SDL_PIXELFORMAT_RGBA32)
		{
			SDL_Surface *old_frame = frame;
			frame = SDL_ConvertSurface(old_frame, SDL_PIXELFORMAT_RGBA32);
			SDL_DestroySurface(old_frame);
		}

		if (!frame)
		{
			return false;
		}

		imageBuffer->Resize(frame->w, frame->h, 32);

		memcpy(imageBuffer->data->buffer->b, frame->pixels, frame->h * frame->pitch);

		if (duration)
		{
			(*duration) = frameDuration;
		}

		SDL_DestroySurface(frame);

		return true;
	}

	int AnimationDecoder::GetStatus()
	{
		return handle ? IMG_GetAnimationDecoderStatus((IMG_AnimationDecoder *)handle) : IMG_DECODER_STATUS_INVALID;
	}

	bool AnimationDecoder::Reset()
	{
		if (!handle)
		{
			return false;
		}

		return IMG_ResetAnimationDecoder((IMG_AnimationDecoder *)handle);
	}
} // namespace lime
