#include <graphics/AnimationDecoderFrame.h>

namespace lime
{

	AnimationDecoderFrame::AnimationDecoderFrame(value frame)
	{
		object = frame;
		buffer = new ImageBuffer(val_field(frame, val_id("buffer")));
		duration = 0;
	}

	AnimationDecoderFrame::~AnimationDecoderFrame()
	{
		alloc_field(object, val_id("duration"), alloc_int(duration));

		delete buffer;
	}

} // namespace lime