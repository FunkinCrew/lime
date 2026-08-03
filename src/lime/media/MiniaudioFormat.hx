package lime.media;

// this is a direct map to ma_format (with ma_format_unknown excluded)
enum abstract MiniaudioFormat(Int) from Int to Int
{
	var U8 = 1;
    var S16 = 2;
    var S24 = 3;
    var S32 = 4;
    var F32 = 5;

    public function getBytesPerFrame():Int
    {
        var bytesPerFrame = 0;

        switch (this) {
			case U8: bytesPerFrame = 1;
			case S16: bytesPerFrame = 2;
			case S24: bytesPerFrame = 3;
			case S32: bytesPerFrame = 4;
			case F32: bytesPerFrame = 4;
		}

        return bytesPerFrame;
    }
}