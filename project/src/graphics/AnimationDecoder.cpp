#include <graphics/AnimationDecoder.h>
#include <graphics/ImageBuffer.h>
#include <SDL3/SDL.h>
#include <SDL3_image/SDL_image.h>

namespace lime
{
	AnimationDecoder::AnimationDecoder()
	{
		file = nullptr;
		handle = nullptr;
	}

	AnimationDecoder::~AnimationDecoder()
	{
		if (handle)
		{
			IMG_CloseAnimationDecoder((IMG_AnimationDecoder *)handle);
			handle = nullptr;
		}

		if (file)
		{
			file->Close();

			delete file;
		}
	}

	bool AnimationDecoder::Open(File *file, const char *type)
	{
		if (!file || !file->handle)
		{
			return false;
		}

		IMG_AnimationDecoder *decoder = IMG_CreateAnimationDecoder_IO((SDL_IOStream *)file->handle, false, type);

		if (!decoder)
		{
			file->Close();

			delete file;

			return false;
		}

		this->file = file;

		this->handle = decoder;

		return true;
	}

	bool AnimationDecoder::GetFrame(ImageBuffer *imageBuffer, int *duration)
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
			(*duration) = (int)frameDuration;
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
