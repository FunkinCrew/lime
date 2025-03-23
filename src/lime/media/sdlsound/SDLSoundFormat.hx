package lime.media.sdlsound;

#if (!lime_doc_gen || lime_sdlsound)
enum abstract SDLSoundFormat(Int) from Int to Int
{
	// TODO: Should we care about endianness?
	var UInt8 = 0x0008;
	var SInt8 = 0x8008;
	var UInt16 = 0x0010;
	var SInt16 = 0x8010;
	var SInt32 = 0x8020;
	var Float32 = 0x8120;

	public function toBits():Int
	{
		return this & 0xFF;
	}
}
#end
