package lime.graphics.opengl.ext;

@:keep
@:noCompletion class SGIX_instruments
{
	public var INSTRUMENT_BUFFER_POINTER_SGIX = 0x8180;
	public var INSTRUMENT_MEASUREMENTS_SGIX = 0x8181;

	@:noCompletion private function new() {}

	// GLint glGetInstrumentsSGIX ()
	// void glInstrumentsBufferSGIX (GLsizei size, GLint *buffer)
	// GLint glPollInstrumentsSGIX (GLint *marker_p)
	// void glReadInstrumentsSGIX (GLint marker)
	// void glStartInstrumentsSGIX ()
	// void glStopInstrumentsSGIX (GLint marker)
}
