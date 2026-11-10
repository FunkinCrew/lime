#pragma once

#include <graphics/ImageBuffer.h>
#include <hx/CFFIPrime.h>

namespace lime
{

	struct AnimationDecoderFrame
	{
		value object;
		ImageBuffer *buffer;
		int duration;

		AnimationDecoderFrame(value frame);
		~AnimationDecoderFrame();
	};

} // namespace lime