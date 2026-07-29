#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <app/Application.h>
#include <events/ApplicationEvent.h>
#include <events/ClipboardEvent.h>
#include <events/DropEvent.h>
#include <events/GamepadEvent.h>
#include <events/GestureEvent.h>
#include <events/JoystickEvent.h>
#include <events/KeyEvent.h>
#include <events/MouseEvent.h>
#include <events/OrientationEvent.h>
#include <events/RenderEvent.h>
#include <events/SensorEvent.h>
#include <events/TextEvent.h>
#include <events/TouchEvent.h>
#include <events/WindowEvent.h>
#include <graphics/format/BMP.h>
#include <graphics/format/JPEG.h>
#include <graphics/format/PNG.h>
#include <graphics/format/SVG.h>
#include <graphics/Image.h>
#include <graphics/ImageBuffer.h>
#include <graphics/utils/ImageDataUtil.h>
#ifdef LIME_DR_LIBS
#include <media/decoders/FlacDecoder.h>
#include <media/decoders/MP3Decoder.h>
#include <media/decoders/WavDecoder.h>
#endif
#ifdef LIME_OGG
#include <media/decoders/OggDecoder.h>
#endif
#ifdef LIME_OPUS
#include <media/decoders/OpusDecoder.h>
#endif
#include <hx/CFFIPrime.h>
#include <system/CFFIPointer.h>
#include <system/Clipboard.h>
#include <system/Endian.h>
#include <system/FileWatcher.h>
#include <system/JNI.h>
#include <system/Locale.h>
#include <system/System.h>
#include <text/Font.h>
#include <ui/Cursor.h>
#include <ui/FileDialog.h>
#include <ui/Gamepad.h>
#include <ui/Haptic.h>
#include <ui/Joystick.h>
#include <ui/KeyCode.h>
#include <ui/Window.h>
#include <ui/Touch.h>
#include <utils/compress/LZMA.h>
#include <utils/compress/Zlib.h>

#ifdef HX_WINDOWS
#include <locale>
#include <codecvt>
#endif
#include <memory>

#include <cstdlib>
#include <cstring>


namespace lime {


	void gc_application (value handle) {

		Application* application = (Application*)val_data (handle);
		delete application;

	}


	void gc_file_watcher (value handle) {

		#ifdef LIME_EFSW
		FileWatcher* watcher = (FileWatcher*)val_data (handle);
		delete watcher;
		#endif

	}


	void gc_font (value handle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (handle);
		delete font;
		#endif

	}


	void gc_window (value handle) {

		Window* window = (Window*)val_data (handle);
		delete window;

	}


	void gc_audio_decoder (value handle) {

		AudioDecoder* audioDecoder = (AudioDecoder*)val_data (handle);
		delete audioDecoder;

	}


	value allocInt64 (int64_t val) {

		int32_t low = val;
		int32_t high = (val >> 32);

		value int64Value = alloc_empty_object ();
		alloc_field (int64Value, val_id ("low"), alloc_int (low));
		alloc_field (int64Value, val_id ("high"), alloc_int (high));
		return int64Value;

	}


	std::string wstring_utf8 (const std::wstring& val) {

		std::string out;
		unsigned int codepoint = 0;

		for (const wchar_t chr : val) {

			if (chr >= 0xd800 && chr <= 0xdbff) {

				codepoint = ((chr - 0xd800) << 10) + 0x10000;

			} else {

				if (chr >= 0xdc00 && chr <= 0xdfff) {

					codepoint |= chr - 0xdc00;

				} else {

					codepoint = chr;

				}

				if (codepoint <= 0x7f) {

					out.append (1, static_cast<char> (codepoint));

				} else if (codepoint <= 0x7ff) {

					out.append (1, static_cast<char> (0xc0 | ((codepoint >> 6) & 0x1f)));
					out.append (1, static_cast<char> (0x80 | (codepoint & 0x3f)));

				} else if (codepoint <= 0xffff) {

					out.append (1, static_cast<char> (0xe0 | ((codepoint >> 12) & 0x0f)));
					out.append (1, static_cast<char> (0x80 | ((codepoint >> 6) & 0x3f)));
					out.append (1, static_cast<char> (0x80 | (codepoint & 0x3f)));

				} else {

					out.append (1, static_cast<char> (0xf0 | ((codepoint >> 18) & 0x07)));
					out.append (1, static_cast<char> (0x80 | ((codepoint >> 12) & 0x3f)));
					out.append (1, static_cast<char> (0x80 | ((codepoint >> 6) & 0x3f)));
					out.append (1, static_cast<char> (0x80 | (codepoint & 0x3f)));

				}

				codepoint = 0;

			}

		}

		return out;

	}


	value lime_application_create () {

		Application* application = CreateApplication ();
		return CFFIPointer (application, gc_application);

	}


	void lime_application_event_manager_register (value callback, value eventObject) {

		ApplicationEvent::callback = new ValuePointer (callback);
		ApplicationEvent::eventObject = new ValuePointer (eventObject);

	}


	int lime_application_exec (value application) {

		Application* app = (Application*)val_data (application);
		return app->Exec ();

	}


	void lime_application_init (value application) {

		Application* app = (Application*)val_data (application);
		app->Init ();

	}


	int lime_application_quit (value application) {

		Application* app = (Application*)val_data (application);
		return app->Quit ();

	}


	void lime_application_set_frame_rate (value application, double frameRate) {

		Application* app = (Application*)val_data (application);
		app->SetFrameRate (frameRate);

	}


	bool lime_application_update (value application) {

		Application* app = (Application*)val_data (application);
		return app->Update ();

	}


	value lime_bytes_from_data_pointer (double data, int length, value _bytes) {

		uintptr_t ptr = (uintptr_t)data;
		Bytes bytes (_bytes);
		bytes.Resize (length);

		if (ptr) {

			memcpy (bytes.b, (const void*)ptr, length);

		}

		return bytes.Value (_bytes);

	}


	double lime_bytes_get_data_pointer (value bytes) {

		Bytes data = Bytes (bytes);
		return (uintptr_t)data.b;

	}


	double lime_bytes_get_data_pointer_offset (value bytes, int offset) {

		if (val_is_null (bytes)) return 0;

		Bytes data = Bytes (bytes);
		return (uintptr_t)data.b + offset;

	}


	value lime_bytes_read_file (HxString path, value bytes) {

		Bytes data (bytes);
		data.ReadFile (hxs_utf8 (path, nullptr));
		return data.Value (bytes);

	}

	void lime_bytes_write_file (HxString path, value bytes) {

		Bytes data (bytes);
		data.WriteFile (hxs_utf8 (path, nullptr));

	}


	double lime_cffi_get_native_pointer (value handle) {

		return (uintptr_t)val_data (handle);

	}


	void lime_clipboard_event_manager_register (value callback, value eventObject) {

		ClipboardEvent::callback = new ValuePointer (callback);
		ClipboardEvent::eventObject = new ValuePointer (eventObject);

	}


	value lime_clipboard_get_text () {

		if (Clipboard::HasText ()) {

			char* text = Clipboard::GetText ();

			if (text) {

				value result = alloc_string (text);
				free (text);
				return result;

			}

		}

		return alloc_null ();

	}


	void lime_clipboard_set_text (HxString text) {

		Clipboard::SetText (hxs_utf8 (text, nullptr));

	}


	double lime_data_pointer_offset (double pointer, int offset) {

		return (uintptr_t)pointer + offset;

	}


	value lime_deflate_compress (value buffer, value bytes) {

		#ifdef LIME_ZLIB
		Bytes data (buffer);
		Bytes result (bytes);

		Zlib::Compress (DEFLATE, &data, &result);

		return result.Value (bytes);
		#else
		return alloc_null();
		#endif

	}


	value lime_deflate_decompress (value buffer, value bytes) {

		#ifdef LIME_ZLIB
		Bytes data (buffer);
		Bytes result (bytes);

		Zlib::Decompress (DEFLATE, &data, &result);

		return result.Value (bytes);
		#else
		return alloc_null ();
		#endif

	}


	void lime_drop_event_manager_register (value callback, value eventObject) {

		DropEvent::callback = new ValuePointer (callback);
		DropEvent::eventObject = new ValuePointer (eventObject);

	}


	void lime_file_dialog_open_directory (value window, HxString title, value callback, HxString defaultPath, bool allowMultiple) {

		#ifdef LIME_SDL
		Window* targetWindow = window ? (Window*)val_data (window) : nullptr;
		const char* targetTitle = hxs_utf8 (title, nullptr);
		ValuePointer* targetCallback = new ValuePointer (callback);
		const char* targetDefaultPath = hxs_utf8 (defaultPath, nullptr);

		FileDialog::OpenDirectory (targetWindow, targetTitle, [targetCallback](const char* const* filelist, int filecount, int filter)
		{
			if (targetCallback) {

				value files = alloc_array (filecount);

				for (int i = 0; i < filecount; i++) {

					val_array_set_i (files, i, alloc_string (filelist[i]));

				}

				targetCallback->Call (files);

				delete targetCallback;
			}
		}, targetDefaultPath, allowMultiple);
		#endif

	}


	void lime_file_dialog_open_file (value window, HxString title, value callback, value names, value patterns, int filterCount, HxString defaultPath, bool allowMultiple) {

		#ifdef LIME_SDL
		Window* targetWindow = window ? (Window*)val_data (window) : nullptr;
		const char* targetTitle = hxs_utf8 (title, nullptr);
		ValuePointer* targetCallback = new ValuePointer (callback);
		const char* targetDefaultPath = hxs_utf8 (defaultPath, nullptr);

		int targetCount = 0;

		std::vector<const char*> targetNames;

		std::vector<const char*> targetPatterns;

		if (names && patterns) {

			targetNames.reserve (filterCount);
			targetPatterns.reserve (filterCount);

			for (int i = 0; i < filterCount; i++) {

				targetNames.push_back (val_string (val_array_i (names, i)));
				targetPatterns.push_back (val_string (val_array_i (patterns, i)));
				targetCount++;

			}

		}

		FileDialog::OpenFile (targetWindow, targetTitle, [targetCallback](const char* const* filelist, int filecount, int filter)
		{
			if (targetCallback) {

				value files = alloc_array (filecount);

				for (int i = 0; i < filecount; i++) {

					val_array_set_i (files, i, alloc_string (filelist[i]));

				}

				targetCallback->Call (files, alloc_int (filter));

				delete targetCallback;

			}
		}, targetNames.data(), targetPatterns.data(), targetCount, targetDefaultPath, allowMultiple);
		#endif

	}


	void lime_file_dialog_save_file (value window, HxString title, value callback, value names, value patterns, int filterCount, HxString defaultPath) {

		#ifdef LIME_SDL
		Window* targetWindow = window ? (Window*)val_data (window) : nullptr;
		const char* targetTitle = hxs_utf8 (title, nullptr);
		ValuePointer* targetCallback = new ValuePointer (callback);
		const char* targetDefaultPath = hxs_utf8 (defaultPath, nullptr);

		int targetCount = 0;

		std::vector<const char*> targetNames;

		std::vector<const char*> targetPatterns;

		if (names && patterns) {

			targetNames.reserve (filterCount);
			targetPatterns.reserve (filterCount);

			for (int i = 0; i < filterCount; i++) {

				targetNames.push_back (val_string (val_array_i (names, i)));
				targetPatterns.push_back (val_string (val_array_i (patterns, i)));
				targetCount++;

			}

		}

		FileDialog::SaveFile (targetWindow, targetTitle, [targetCallback](const char* const* filelist, int filecount, int filter)
		{
			if (targetCallback) {

				targetCallback->Call ((filelist && filelist[0]) ? alloc_string(filelist[0]) : alloc_null(), alloc_int (filter));

				delete targetCallback;

			}
		}, targetNames.data(), targetPatterns.data(), targetCount, targetDefaultPath);
		#endif

	}


	value lime_file_watcher_create (value callback) {

		#ifdef LIME_EFSW
		FileWatcher* watcher = new FileWatcher (callback);
		return CFFIPointer (watcher, gc_file_watcher);
		#else
		return alloc_null ();
		#endif

	}


	value lime_file_watcher_add_directory (value handle, value path, bool recursive) {

		#ifdef LIME_EFSW
		FileWatcher* watcher = (FileWatcher*)val_data (handle);
		return alloc_int (watcher->AddDirectory (val_string (path), recursive));
		#else
		return alloc_int (0);
		#endif

	}


	void lime_file_watcher_remove_directory (value handle, value watchID) {

		#ifdef LIME_EFSW
		FileWatcher* watcher = (FileWatcher*)val_data (handle);
		watcher->RemoveDirectory (val_int (watchID));
		#endif

	}


	void lime_file_watcher_update (value handle) {

		#ifdef LIME_EFSW
		FileWatcher* watcher = (FileWatcher*)val_data (handle);
		watcher->Update ();
		#endif

	}


	int lime_font_get_ascender (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetAscender ();
		#else
		return 0;
		#endif

	}


	int lime_font_get_descender (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetDescender ();
		#else
		return 0;
		#endif

	}


	value lime_font_get_family_name (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		wchar_t *name = font->GetFamilyName ();
		value result = alloc_wstring (name);
		delete name;
		return result;
		#else
		return alloc_null ();
		#endif

	}


	int lime_font_get_glyph_index (value fontHandle, HxString character) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetGlyphIndex (hxs_utf8 (character, nullptr));
		#else
		return -1;
		#endif

	}


	value lime_font_get_glyph_indices (value fontHandle, HxString characters) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return (value)font->GetGlyphIndices (hxs_utf8 (characters, nullptr));
		#else
		return alloc_null ();
		#endif

	}


	value lime_font_get_glyph_metrics (value fontHandle, int index) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return (value)font->GetGlyphMetrics (index);
		#else
		return alloc_null ();
		#endif

	}


	int lime_font_get_height (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetHeight ();
		#else
		return 0;
		#endif

	}


	int lime_font_get_num_glyphs (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetNumGlyphs ();
		#else
		return 0;
		#endif

	}


	int lime_font_get_underline_position (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetUnderlinePosition ();
		#else
		return 0;
		#endif

	}


	int lime_font_get_underline_thickness (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetUnderlineThickness ();
		#else
		return 0;
		#endif

	}


	int lime_font_get_strikethrough_position (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetStrikethroughPosition ();
		#else
		return 0;
		#endif

	}


	int lime_font_get_strikethrough_thickness (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetStrikethroughThickness ();
		#else
		return 0;
		#endif

	}


	int lime_font_get_units_per_em (value fontHandle) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return font->GetUnitsPerEM ();
		#else
		return 0;
		#endif

	}


	value lime_font_load_bytes (value data) {

		#ifdef LIME_FREETYPE
		Resource resource;
		Bytes bytes;

		bytes.Set (data);
		resource = Resource (&bytes);

		Font *font = new Font (&resource, 0);

		if (font) {

			if (font->face) {

				return CFFIPointer (font, gc_font);

			} else {

				delete font;

			}

		}
		#endif

		return alloc_null ();

	}


	value lime_font_load_file (value data) {

		#ifdef LIME_FREETYPE
		Resource resource = Resource (val_string (data));

		Font *font = new Font (&resource, 0);

		if (font) {

			if (font->face) {

				return CFFIPointer (font, gc_font);

			} else {

				delete font;

			}

		}
		#endif

		return alloc_null ();

	}


	value lime_font_outline_decompose (value fontHandle, int size, bool forceAutoHint) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		return (value)font->Decompose (size, forceAutoHint);
		#else
		return alloc_null ();
		#endif

	}


	value lime_font_render_glyph (value fontHandle, int index, value data, int flags) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		Bytes bytes (data);

		if (font->RenderGlyph (index, &bytes, 0, flags)) {

			return bytes.Value (data);

		}
		#endif

		return alloc_null ();

	}


	value lime_font_render_glyphs (value fontHandle, value indices, value data, int flags) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		Bytes bytes (data);
		std::vector<int> _indices;

		for (int i = 0; i < val_array_size (indices); i++) {

			_indices.push_back (val_int (val_array_i (indices, i)));

		}

		if (font->RenderGlyphs (_indices.data (), _indices.size (), &bytes, flags)) {

			return bytes.Value (data);

		}
		#endif

		return alloc_null ();

	}


	void lime_font_set_size (value fontHandle, int fontSize, int dpi) {

		#ifdef LIME_FREETYPE
		Font *font = (Font*)val_data (fontHandle);
		font->SetSize (fontSize, dpi);
		#endif

	}


	void lime_font_initialize_library () {

		#ifdef LIME_FREETYPE
		Font::InitializeLibrary();
		#endif

	}


	void lime_font_shutdown_library () {

		#ifdef LIME_FREETYPE
		Font::ShutdownLibrary();
		#endif

	}


	void lime_gamepad_add_mappings (value mappings) {

		int length = val_array_size (mappings);

		for (int i = 0; i < length; i++) {

			Gamepad::AddMapping (val_string (val_array_i (mappings, i)));

		}

	}


	void lime_gamepad_event_manager_register (value callback, value eventObject) {

		GamepadEvent::callback = new ValuePointer (callback);
		GamepadEvent::eventObject = new ValuePointer (eventObject);

	}


	value lime_gamepad_get_device_guid (int id) {

		char* guid = Gamepad::GetDeviceGUID (id);

		if (guid) {

			value result = alloc_string (guid);
			delete guid;
			return result;

		} else {

			return alloc_null ();

		}

	}


	value lime_gamepad_get_device_name (int id) {

		const char* name = Gamepad::GetDeviceName (id);
		return name ? alloc_string (name) : alloc_null ();

	}


	void lime_gamepad_rumble (int id, double lowFrequencyRumble, double highFrequencyRumble, int duration) {

		Gamepad::Rumble (id, lowFrequencyRumble, highFrequencyRumble, duration);

	}


	void lime_gamepad_set_led (int id, int red, int green, int blue) {

		Gamepad::SetLED (id, red, green, blue);

	}


	value lime_gzip_compress (value buffer, value bytes) {

		#ifdef LIME_ZLIB
		Bytes data (buffer);
		Bytes result (bytes);

		Zlib::Compress (GZIP, &data, &result);

		return result.Value (bytes);
		#else
		return alloc_null ();
		#endif

	}


	value lime_gzip_decompress (value buffer, value bytes) {

		#ifdef LIME_ZLIB
		Bytes data (buffer);
		Bytes result (bytes);

		Zlib::Decompress (GZIP, &data, &result);

		return result.Value (bytes);
		#else
		return alloc_null ();
		#endif

	}


	void lime_haptic_vibrate (int period, int duration) {

		#ifdef IPHONE
		Haptic::Vibrate (period, duration);
		#endif

	}


	value lime_image_encode (value buffer, int type, int quality, value bytes) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer = ImageBuffer (buffer);
		Bytes data = Bytes (bytes);

		switch (type) {

			case 0:

				if (PNG::Encode (&imageBuffer, &data)) {

					return data.Value (bytes);

				}
				break;

			case 1:

				if (JPEG::Encode (&imageBuffer, &data, quality)) {

					return data.Value (bytes);

				}
				break;

			case 2:

				if (BMP::Encode (&imageBuffer, &data)) {

					return data.Value (bytes);

				}
				break;

			default: break;

		}
		#endif

		return alloc_null ();

	}


	value lime_image_load_bytes (value data, value buffer) {

		#ifdef LIME_SDL_IMAGE
		Bytes bytes = Bytes (data);
		ImageBuffer imageBuffer = ImageBuffer (buffer);
		Resource resource = Resource (&bytes);

		if (PNG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}

		if (JPEG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}

		if (BMP::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}

		if (SVG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	value lime_image_load_file (value data, value buffer) {

		#ifdef LIME_SDL_IMAGE
		Resource resource = Resource (val_string (data));

		ImageBuffer imageBuffer = ImageBuffer (buffer);

		if (PNG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}

		if (JPEG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}

		if (BMP::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}

		if (SVG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	void lime_image_data_util_color_transform (value image, value rect, value colorMatrix) {

		Image _image = Image (image);
		Rectangle _rect = Rectangle (rect);
		ColorMatrix _colorMatrix = ColorMatrix (colorMatrix);
		ImageDataUtil::ColorTransform (&_image, &_rect, &_colorMatrix);

	}


	void lime_image_data_util_copy_channel (value image, value sourceImage, value sourceRect, value destPoint, int srcChannel, int destChannel) {

		Image _image = Image (image);
		Image _sourceImage = Image (sourceImage);
		Rectangle _sourceRect = Rectangle (sourceRect);
		Vector2 _destPoint = Vector2 (destPoint);
		ImageDataUtil::CopyChannel (&_image, &_sourceImage, &_sourceRect, &_destPoint, srcChannel, destChannel);

	}


	void lime_image_data_util_copy_pixels (value image, value sourceImage, value sourceRect, value destPoint, value alphaImage, value alphaPoint, bool mergeAlpha) {

		Image _image = Image (image);
		Image _sourceImage = Image (sourceImage);
		Rectangle _sourceRect = Rectangle (sourceRect);
		Vector2 _destPoint = Vector2 (destPoint);

		if (val_is_null (alphaImage)) {

			ImageDataUtil::CopyPixels (&_image, &_sourceImage, &_sourceRect, &_destPoint, 0, 0, mergeAlpha);

		} else {

			Image _alphaImage = Image (alphaImage);
			Vector2 _alphaPoint = Vector2 (alphaPoint);

			ImageDataUtil::CopyPixels (&_image, &_sourceImage, &_sourceRect, &_destPoint, &_alphaImage, &_alphaPoint, mergeAlpha);

		}

	}


	void lime_image_data_util_fill_rect (value image, value rect, int rg, int ba) {

		Image _image = Image (image);
		Rectangle _rect = Rectangle (rect);
		int32_t color = (rg << 16) | ba;
		ImageDataUtil::FillRect (&_image, &_rect, color);

	}


	void lime_image_data_util_flood_fill (value image, int x, int y, int rg, int ba) {

		Image _image = Image (image);
		int32_t color = (rg << 16) | ba;
		ImageDataUtil::FloodFill (&_image, x, y, color);

	}


	void lime_image_data_util_get_pixels (value image, value rect, int format, value bytes) {

		Image _image = Image (image);
		Rectangle _rect = Rectangle (rect);
		PixelFormat _format = (PixelFormat)format;
		Bytes pixels = Bytes (bytes);
		ImageDataUtil::GetPixels (&_image, &_rect, _format, &pixels);

	}


	void lime_image_data_util_merge (value image, value sourceImage, value sourceRect, value destPoint, int redMultiplier, int greenMultiplier, int blueMultiplier, int alphaMultiplier) {

		Image _image = Image (image);
		Image _sourceImage = Image (sourceImage);
		Rectangle _sourceRect = Rectangle (sourceRect);
		Vector2 _destPoint = Vector2 (destPoint);
		ImageDataUtil::Merge (&_image, &_sourceImage, &_sourceRect, &_destPoint, redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);

	}


	void lime_image_data_util_multiply_alpha (value image) {

		Image _image = Image (image);
		ImageDataUtil::MultiplyAlpha (&_image);

	}


	void lime_image_data_util_resize (value image, value buffer, int width, int height) {

		Image _image = Image (image);
		ImageBuffer _buffer = ImageBuffer (buffer);
		ImageDataUtil::Resize (&_image, &_buffer, width, height);

	}


	void lime_image_data_util_set_format (value image, int format) {

		Image _image = Image (image);
		PixelFormat _format = (PixelFormat)format;
		ImageDataUtil::SetFormat (&_image, _format);

	}


	void lime_image_data_util_set_pixels (value image, value rect, value bytes, int offset, int format, int endian) {

		Image _image = Image (image);
		Rectangle _rect = Rectangle (rect);
		Bytes _bytes (bytes);
		PixelFormat _format = (PixelFormat)format;
		Endian _endian = (Endian)endian;
		ImageDataUtil::SetPixels (&_image, &_rect, &_bytes, offset, _format, _endian);

	}


	int lime_image_data_util_threshold (value image, value sourceImage, value sourceRect, value destPoint, int operation, int thresholdRG, int thresholdBA, int colorRG, int colorBA, int maskRG, int maskBA, bool copySource) {

		Image _image = Image (image);
		Image _sourceImage = Image (sourceImage);
		Rectangle _sourceRect = Rectangle (sourceRect);
		Vector2 _destPoint = Vector2 (destPoint);
		int32_t threshold = (thresholdRG << 16) | thresholdBA;
		int32_t color = (colorRG << 16) | colorBA;
		int32_t mask = (maskRG << 16) | maskBA;
		return ImageDataUtil::Threshold (&_image, &_sourceImage, &_sourceRect, &_destPoint, operation, threshold, color, mask, copySource);

	}


	void lime_image_data_util_unmultiply_alpha (value image) {

		Image _image = Image (image);
		ImageDataUtil::UnmultiplyAlpha (&_image);

	}


	double lime_jni_getenv () {

		#ifdef ANDROID
		return (uintptr_t)JNI::GetEnv ();
		#else
		return 0;
		#endif

	}


	void lime_joystick_event_manager_register (value callback, value eventObject) {

		JoystickEvent::callback = new ValuePointer (callback);
		JoystickEvent::eventObject = new ValuePointer (eventObject);

	}


	value lime_joystick_get_device_guid (int id) {

		char* guid = Joystick::GetDeviceGUID (id);

		if (guid) {

			value result = alloc_string (guid);
			delete guid;
			return result;

		} else {

			return alloc_null ();

		}

	}


	value lime_joystick_get_device_name (int id) {

		const char* name = Joystick::GetDeviceName (id);
		return name ? alloc_string (name) : alloc_null ();

	}


	int lime_joystick_get_num_axes (int id) {

		return Joystick::GetNumAxes (id);

	}


	int lime_joystick_get_num_buttons (int id) {

		return Joystick::GetNumButtons (id);

	}


	int lime_joystick_get_num_hats (int id) {

		return Joystick::GetNumHats (id);

	}


	void lime_joystick_rumble (int id, double lowFrequencyRumble, double highFrequencyRumble, int duration) {

		Joystick::Rumble (id, lowFrequencyRumble, highFrequencyRumble, duration);

	}


	void lime_joystick_set_led (int id, int red, int green, int blue) {

		Joystick::SetLED (id, red, green, blue);

	}


	int lime_key_code_from_scan_code (int scanCode) {

		return KeyCode::FromScanCode (scanCode);

	}


	int lime_key_code_to_scan_code (int keyCode) {

		return KeyCode::ToScanCode (keyCode);

	}


	void lime_key_event_manager_register (value callback, value eventObject) {

		KeyEvent::callback = new ValuePointer (callback);
		KeyEvent::eventObject = new ValuePointer (eventObject);

	}


	value lime_locale_get_system_locale () {

		std::string* locale = Locale::GetSystemLocale ();

		if (!locale) {

			return alloc_null ();

		} else {

			value result = alloc_string (locale->c_str ());
			delete locale;
			return result;

		}

	}


	value lime_lzma_compress (value buffer, value bytes) {

		#ifdef LIME_LZMA
		Bytes data (buffer);
		Bytes result (bytes);

		LZMA::Compress (&data, &result);

		return result.Value (bytes);
		#else
		return alloc_null ();
		#endif

	}


	value lime_lzma_decompress (value buffer, value bytes) {

		#ifdef LIME_LZMA
		Bytes data (buffer);
		Bytes result (bytes);

		LZMA::Decompress (&data, &result);

		return result.Value (bytes);
		#else
		return alloc_null ();
		#endif

	}


	void lime_mouse_event_manager_register (value callback, value eventObject) {

		MouseEvent::callback = new ValuePointer (callback);
		MouseEvent::eventObject = new ValuePointer (eventObject);

	}


	void lime_orientation_event_manager_register (value callback, value eventObject) {

		OrientationEvent::callback = new ValuePointer (callback);
		OrientationEvent::eventObject = new ValuePointer (eventObject);

	}


	value lime_png_decode_bytes (value data, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Bytes bytes (data);
		Resource resource = Resource (&bytes);

		if (PNG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	value lime_png_decode_file (HxString path, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Resource resource = Resource (hxs_utf8 (path, nullptr));

		if (PNG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	value lime_jpeg_decode_bytes (value data, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Bytes bytes (data);
		Resource resource = Resource (&bytes);

		if (JPEG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	value lime_jpeg_decode_file (HxString path, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Resource resource = Resource (hxs_utf8 (path, nullptr));

		if (JPEG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}

	value lime_bmp_decode_bytes (value data, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Bytes bytes (data);
		Resource resource = Resource (&bytes);

		if (BMP::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	value lime_bmp_decode_file (HxString path, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Resource resource = Resource (hxs_utf8 (path, nullptr));

		if (BMP::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	value lime_svg_decode_bytes (value data, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Bytes bytes (data);
		Resource resource = Resource (&bytes);

		if (SVG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	value lime_svg_decode_file (HxString path, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Resource resource = Resource (hxs_utf8 (path, nullptr));

		if (SVG::Decode (&resource, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	value lime_svg_decode_sized_bytes (value data, int width, int height, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Bytes bytes (data);
		Resource resource = Resource (&bytes);

		if (SVG::DecodeSized (&resource, width, height, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	value lime_svg_decode_sized_file (HxString path, int width, int height, value buffer) {

		#ifdef LIME_SDL_IMAGE
		ImageBuffer imageBuffer (buffer);
		Resource resource = Resource (hxs_utf8 (path, nullptr));

		if (SVG::DecodeSized (&resource, width, height, &imageBuffer)) {

			return imageBuffer.Value (buffer);

		}
		#endif

		return alloc_null ();

	}


	void lime_render_event_manager_register (value callback, value eventObject) {

		RenderEvent::callback = new ValuePointer (callback);
		RenderEvent::eventObject = new ValuePointer (eventObject);

	}


	void lime_sensor_event_manager_register (value callback, value eventObject) {

		SensorEvent::callback = new ValuePointer (callback);
		SensorEvent::eventObject = new ValuePointer (eventObject);

	}


	bool lime_system_get_allow_screen_timeout () {

		return System::GetAllowScreenTimeout ();

	}


	value lime_system_get_device_model () {

		#if defined(HX_WINDOWS) || defined(IPHONE)
		char* model = System::GetDeviceModel ();

		if (model) {

			value result = alloc_string (model);
			free (model);
			return result;

		}
		#endif

		return alloc_null ();

	}


	value lime_system_get_device_vendor () {

		#if defined(HX_WINDOWS) || defined(IPHONE)
		char* vendor = System::GetDeviceVendor ();

		if (vendor) {

			value result = alloc_string (vendor);
			free (vendor);
			return result;

		}
		#endif

		return alloc_null ();

	}

	value lime_system_get_directory (int type, HxString company, HxString title) {

		char* path = System::GetDirectory ((SystemDirectory)type, hxs_utf8 (company, nullptr), hxs_utf8 (title, nullptr));

		if (path) {

			value result = alloc_string (path);
			free (path);
			return result;

		} else {

			return alloc_null ();

		}

	}


	value lime_system_get_display (int id) {

		return (value)System::GetDisplay (id);

	}


	int lime_system_get_num_displays () {

		return System::GetNumDisplays ();

	}


	int lime_system_get_first_gyroscope_sensor_id () {

		return System::GetFirstGyroscopeSensorId ();

	}


	int lime_system_get_first_accelerometer_sensor_id () {

		return System::GetFirstAccelerometerSensorId ();

	}


	value lime_system_get_platform_label () {

		#if defined(HX_WINDOWS) || defined(IPHONE)
		char* label = System::GetPlatformLabel ();

		if (label) {

			value result = alloc_string (label);
			free (label);
			return result;

		}
		#endif

		return alloc_null ();

	}


	value lime_system_get_platform_name () {

		#if defined(HX_WINDOWS) || defined(IPHONE)
		char* name = System::GetPlatformName ();

		if (name) {

			value result = alloc_string (name);
			free (name);
			return result;

		}
		#endif

		return alloc_null ();

	}


	value lime_system_get_platform_version () {

		#if defined(HX_WINDOWS) || defined(IPHONE)
		char* version = System::GetPlatformVersion ();

		if (version) {

			value result = alloc_string (version);
			free (version);
			return result;

		}
		#endif

		return alloc_null ();

	}


	double lime_system_get_timer () {

		return System::GetTimer ();

	}


	int lime_system_get_theme () {

		return System::GetTheme ();

	}


	int lime_system_get_windows_console_mode (int handleType) {

		#if defined (HX_WINDOWS)
		return System::GetWindowsConsoleMode (handleType);
		#else
		return 0;
		#endif

	}


	void lime_system_open_file (HxString path) {

		System::OpenFile (path.c_str ());

	}


	void lime_system_open_url (HxString url, HxString target) {

		System::OpenURL (url.c_str (), target.c_str ());

	}


	bool lime_system_set_allow_screen_timeout (bool allow) {

		return System::SetAllowScreenTimeout (allow);

	}


	value lime_system_get_hint (HxString hintKey) {

		const char* hint = System::GetHint (hxs_utf8 (hintKey, nullptr));

		if (hint) {

			return alloc_string (hint);

		} else {

			return alloc_null ();

		}

	}


	void lime_system_set_hint (HxString hintKey, HxString hintValue) {

		System::SetHint (hxs_utf8 (hintKey, nullptr), hxs_utf8 (hintValue, nullptr));

	}


	bool lime_system_set_windows_console_mode (int handleType, int mode) {

		#if defined (HX_WINDOWS)
		return System::SetWindowsConsoleMode (handleType, mode);
		#else
		return false;
		#endif

	}


	void lime_text_event_manager_register (value callback, value eventObject) {

		TextEvent::callback = new ValuePointer (callback);
		TextEvent::eventObject = new ValuePointer (eventObject);

	}


	void lime_touch_event_manager_register (value callback, value eventObject) {

		TouchEvent::callback = new ValuePointer (callback);
		TouchEvent::eventObject = new ValuePointer (eventObject);

	}


	void lime_gesture_event_manager_register (value callback, value eventObject) {

		GestureEvent::callback = new ValuePointer (callback);
		GestureEvent::eventObject = new ValuePointer (eventObject);

	}


	int lime_window_alert (value window, int type, HxString message, HxString title, value buttons) {

		Window* targetWindow = (Window*)val_data (window);

		std::vector<const char*> targetButtons;

		if (buttons) {

			int buttonCount = val_array_size (buttons);

			targetButtons.reserve (buttonCount);

			for (int i = 0; i < buttonCount; i++) {

				targetButtons.push_back (val_string (val_array_i (buttons, i)));

			}

		}

		return targetWindow->Alert (type, hxs_utf8 (message, nullptr), hxs_utf8 (title, nullptr), targetButtons.data (), targetButtons.size ());

	}


	bool lime_window_set_vsync_mode (value window, int mode) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->SetVSyncMode (mode);

	}


	void lime_window_close (value window) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->Close ();

	}


	void lime_window_context_flip (value window) {

		((Window*)val_data (window))->ContextFlip ();

	}


	void lime_window_context_make_current (value window) {

		((Window*)val_data (window))->ContextMakeCurrent ();

	}


	value lime_window_create (value application, int width, int height, int flags, HxString title) {

		Window* window = MakeWindow ((Application*)val_data (application), width, height, flags, hxs_utf8 (title, nullptr));
		return CFFIPointer (window, gc_window);

	}


	void lime_window_event_manager_register (value callback, value eventObject) {

		WindowEvent::callback = new ValuePointer (callback);
		WindowEvent::eventObject = new ValuePointer (eventObject);

	}


	void lime_window_focus (value window) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->Focus ();

	}


	double lime_window_get_handle (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return (uintptr_t)targetWindow->GetHandle ();

	}


	double lime_window_get_context (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return (uintptr_t)targetWindow->GetContext ();

	}


	int lime_window_get_display (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->GetDisplay ();

	}


	value lime_window_get_display_mode (value window) {

		Window* targetWindow = (Window*)val_data (window);
		DisplayMode displayMode;
		targetWindow->GetDisplayMode (&displayMode);
		return (value)displayMode.Value ();

	}


	int lime_window_get_height (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->GetHeight ();

	}


	int32_t lime_window_get_id (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return (int32_t)targetWindow->GetID ();

	}


	bool lime_window_get_mouse_lock (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->GetMouseLock ();

	}


	double lime_window_get_opacity (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return (float)targetWindow->GetOpacity ();

	}


	double lime_window_get_scale (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->GetScale ();

	}


	bool lime_window_get_text_input_enabled (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->GetTextInputEnabled ();

	}


	int lime_window_get_width (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->GetWidth ();

	}


	int lime_window_get_x (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->GetX ();

	}


	int lime_window_get_y (value window) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->GetY ();

	}


	void lime_window_move (value window, int x, int y) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->Move (x, y);

	}


	value lime_window_read_pixels (value window, value rect, value imageBuffer) {

		Window* targetWindow = (Window*)val_data (window);
		ImageBuffer buffer (imageBuffer);

		if (!val_is_null (rect)) {

			Rectangle _rect = Rectangle (rect);
			targetWindow->ReadPixels (&buffer, &_rect);

		} else {

			targetWindow->ReadPixels (&buffer, NULL);

		}

		return buffer.Value (imageBuffer);

	}


	void lime_window_resize (value window, int width, int height) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->Resize (width, height);

	}


	void lime_window_set_minimum_size (value window, int width, int height) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->SetMinimumSize (width, height);

	}


	void lime_window_set_maximum_size (value window, int width, int height) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->SetMaximumSize (width, height);

	}


	bool lime_window_set_borderless (value window, bool borderless) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->SetBorderless (borderless);

	}


	void lime_window_set_cursor (value window, int cursor) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->SetCursor ((SystemCursor)cursor);

	}


	value lime_window_set_display_mode (value window, value displayMode) {

		Window* targetWindow = (Window*)val_data (window);
		DisplayMode _displayMode (displayMode);
		targetWindow->SetDisplayMode (&_displayMode);
		targetWindow->GetDisplayMode (&_displayMode);
		return (value)_displayMode.Value ();

	}


	bool lime_window_set_fullscreen (value window, bool fullscreen) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->SetFullscreen (fullscreen);

	}


	void lime_window_set_icon (value window, value buffer) {

		Window* targetWindow = (Window*)val_data (window);
		ImageBuffer imageBuffer = ImageBuffer (buffer);
		targetWindow->SetIcon (&imageBuffer);

	}


	bool lime_window_set_maximized (value window, bool maximized) {

		Window* targetWindow = (Window*)val_data(window);
		return targetWindow->SetMaximized (maximized);

	}


	bool lime_window_set_minimized (value window, bool minimized) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->SetMinimized (minimized);

	}


	void lime_window_set_mouse_lock (value window, bool mouseLock) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->SetMouseLock (mouseLock);

	}


	void lime_window_set_opacity (value window, double opacity) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->SetOpacity ((float)opacity);

	}


	bool lime_window_set_resizable (value window, bool resizable) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->SetResizable (resizable);

	}


	void lime_window_set_text_input_enabled (value window, bool enabled) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->SetTextInputEnabled (enabled);

	}


	void lime_window_set_text_input_rect (value window, value rect) {

		Window* targetWindow = (Window*)val_data (window);
		Rectangle _rect = Rectangle (rect);
		targetWindow->SetTextInputRect (&_rect);

	}


	value lime_window_set_title (value window, HxString title) {

		Window* targetWindow = (Window*)val_data (window);
		const char* titleUtf8 = hxs_utf8 (title, nullptr);
		const char* result = targetWindow->SetTitle (titleUtf8);

		if (result) {

			value _result = alloc_string (result);

			if (result != titleUtf8) {

				free ((char*) result);

			}

			return _result;

		} else {

			return alloc_null ();

		}

	}


	bool lime_window_set_visible (value window, bool visible) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->SetVisible (visible);

	}


	bool lime_window_set_always_on_top (value window, bool alwaysOnTop) {

		Window* targetWindow = (Window*)val_data (window);
		return targetWindow->SetAlwaysOnTop(alwaysOnTop);

	}


	void lime_window_warp_mouse (value window, int x, int y) {

		Window* targetWindow = (Window*)val_data (window);
		targetWindow->WarpMouse (x, y);

	}


	value lime_audio_decoder_open_file (value data, int codec) {

		AudioDecoder* decoder;

		switch (codec) {

			#ifdef LIME_OGG
			case 0:
				decoder = new OggDecoder ();
				break;
			#endif

			#ifdef LIME_OPUS
			case 1:
				decoder = new OpusDecoder ();
				break;
			#endif

			#ifdef LIME_DR_LIBS
			case 2:
				decoder = new FlacDecoder ();
				break;

			case 3:
				decoder = new MP3Decoder ();
				break;

			case 4:
				decoder = new WavDecoder ();
				break;
			#endif

			default:
				return alloc_null ();

		}

		Resource resource = Resource (val_string (data));

		if (decoder->Open (&resource)) {

			return CFFIPointer (decoder, gc_audio_decoder);

		}

		delete decoder;

		return alloc_null ();

	}


	value lime_audio_decoder_open_bytes (value data, int codec) {

		AudioDecoder* decoder;

		switch (codec) {

			#ifdef LIME_OGG
			case 0:
				decoder = new OggDecoder ();
				break;
			#endif

			#ifdef LIME_OPUS
			case 1:
				decoder = new OpusDecoder ();
				break;
			#endif

			#ifdef LIME_DR_LIBS
			case 2:
				decoder = new FlacDecoder ();
				break;

			case 3:
				decoder = new MP3Decoder ();
				break;

			case 4:
				decoder = new WavDecoder ();
				break;
			#endif

			default:
				return alloc_null ();

		}

		Bytes bytes (data);

		Resource resource = Resource (&bytes);

		if (decoder->Open (&resource)) {

			return CFFIPointer (decoder, gc_audio_decoder);

		}

		delete decoder;

		return alloc_null ();

	}


	value lime_audio_decoder_info (value audio_decoder) {

		AudioDecoder* targetAudioDecoder = (AudioDecoder*)val_data (audio_decoder);

		value info = alloc_empty_object ();
		alloc_field (info, val_id ("channels"), alloc_int (targetAudioDecoder->channels));
		alloc_field (info, val_id ("sampleRate"), alloc_int (targetAudioDecoder->sampleRate));
		return info;

	}


	value lime_audio_decoder_decode (value audio_decoder, value bytes, int frames, int format) {

		AudioDecoder* targetAudioDecoder = (AudioDecoder*)val_data (audio_decoder);

		Bytes data = Bytes (bytes);

		AudioFormat targetAudioFormat = (AudioFormat) format;

		int framesDecoded = targetAudioDecoder->Decode (data.b, frames, targetAudioFormat);

		switch (targetAudioFormat) {

			case AudioFormat::S16:

				data.Resize(framesDecoded * targetAudioDecoder->channels * 2);
				break;

			case AudioFormat::F32:

				data.Resize(framesDecoded * targetAudioDecoder->channels * 4);
				break;

		}

		return data.Value (bytes);

	}


	bool lime_audio_decoder_rewind (value audio_decoder) {

		AudioDecoder* targetAudioDecoder = (AudioDecoder*)val_data (audio_decoder);
		return targetAudioDecoder->Rewind ();

	}


	bool lime_audio_decoder_seek (value audio_decoder, int frameLow, int frameHigh) {

		AudioDecoder* targetAudioDecoder = (AudioDecoder*)val_data (audio_decoder);
		int64_t frame = ((int64_t)frameHigh << 32) | (int64_t)frameLow;
		return targetAudioDecoder->Seek (frame);

	}


	bool lime_audio_decoder_can_seek (value audio_decoder) {

		AudioDecoder* targetAudioDecoder = (AudioDecoder*)val_data (audio_decoder);
		return targetAudioDecoder->CanSeek ();

	}


	value lime_audio_decoder_tell (value audio_decoder) {

		AudioDecoder* targetAudioDecoder = (AudioDecoder*)val_data (audio_decoder);
		return allocInt64 (targetAudioDecoder->Tell ());

	}


	value lime_audio_decoder_total (value audio_decoder) {

		AudioDecoder* targetAudioDecoder = (AudioDecoder*)val_data (audio_decoder);
		return allocInt64 (targetAudioDecoder->Total ());

	}


	value lime_zlib_compress (value buffer, value bytes) {

		#ifdef LIME_ZLIB
		Bytes data (buffer);
		Bytes result (bytes);

		Zlib::Compress (ZLIB, &data, &result);

		return result.Value (bytes);
		#else
		return alloc_null ();
		#endif

	}


	value lime_zlib_decompress (value buffer, value bytes) {

		#ifdef LIME_ZLIB
		Bytes data (buffer);
		Bytes result (bytes);

		Zlib::Decompress (ZLIB, &data, &result);

		return result.Value (bytes);
		#else
		return alloc_null ();
		#endif

	}

	value lime_touch_get_devices () {

		return Touch::GetDevices ();

	}

	value lime_touch_get_device_name (int id) {

		const char* name = Touch::GetDeviceName (id);

		return name ? alloc_string (name) : alloc_null ();

	}

	int lime_touch_get_device_type (int id) {

		return Touch::GetDeviceType (id);

	}


	DEFINE_PRIME0 (lime_application_create);
	DEFINE_PRIME2v (lime_application_event_manager_register);
	DEFINE_PRIME1 (lime_application_exec);
	DEFINE_PRIME1v (lime_application_init);
	DEFINE_PRIME1 (lime_application_quit);
	DEFINE_PRIME2v (lime_application_set_frame_rate);
	DEFINE_PRIME1 (lime_application_update);
	DEFINE_PRIME3 (lime_bytes_from_data_pointer);
	DEFINE_PRIME1 (lime_bytes_get_data_pointer);
	DEFINE_PRIME2 (lime_bytes_get_data_pointer_offset);
	DEFINE_PRIME2 (lime_bytes_read_file);
	DEFINE_PRIME2v (lime_bytes_write_file);
	DEFINE_PRIME1 (lime_cffi_get_native_pointer);
	DEFINE_PRIME2v (lime_clipboard_event_manager_register);
	DEFINE_PRIME0 (lime_clipboard_get_text);
	DEFINE_PRIME1v (lime_clipboard_set_text);
	DEFINE_PRIME2 (lime_data_pointer_offset);
	DEFINE_PRIME2 (lime_deflate_compress);
	DEFINE_PRIME2 (lime_deflate_decompress);
	DEFINE_PRIME2v (lime_drop_event_manager_register);
	DEFINE_PRIME5v (lime_file_dialog_open_directory);
	DEFINE_PRIME8v (lime_file_dialog_open_file);
	DEFINE_PRIME7v (lime_file_dialog_save_file);
	DEFINE_PRIME1 (lime_file_watcher_create);
	DEFINE_PRIME3 (lime_file_watcher_add_directory);
	DEFINE_PRIME2v (lime_file_watcher_remove_directory);
	DEFINE_PRIME1v (lime_file_watcher_update);
	DEFINE_PRIME1 (lime_font_get_ascender);
	DEFINE_PRIME1 (lime_font_get_descender);
	DEFINE_PRIME1 (lime_font_get_family_name);
	DEFINE_PRIME2 (lime_font_get_glyph_index);
	DEFINE_PRIME2 (lime_font_get_glyph_indices);
	DEFINE_PRIME2 (lime_font_get_glyph_metrics);
	DEFINE_PRIME1 (lime_font_get_height);
	DEFINE_PRIME1 (lime_font_get_num_glyphs);
	DEFINE_PRIME1 (lime_font_get_underline_position);
	DEFINE_PRIME1 (lime_font_get_underline_thickness);
	DEFINE_PRIME1 (lime_font_get_strikethrough_position);
	DEFINE_PRIME1 (lime_font_get_strikethrough_thickness);
	DEFINE_PRIME1 (lime_font_get_units_per_em);
	DEFINE_PRIME1 (lime_font_load_bytes);
	DEFINE_PRIME1 (lime_font_load_file);
	DEFINE_PRIME3 (lime_font_outline_decompose);
	DEFINE_PRIME4 (lime_font_render_glyph);
	DEFINE_PRIME4 (lime_font_render_glyphs);
	DEFINE_PRIME3v (lime_font_set_size);
	DEFINE_PRIME0v (lime_font_initialize_library);
	DEFINE_PRIME0v (lime_font_shutdown_library);
	DEFINE_PRIME1v (lime_gamepad_add_mappings);
	DEFINE_PRIME2v (lime_gamepad_event_manager_register);
	DEFINE_PRIME1 (lime_gamepad_get_device_guid);
	DEFINE_PRIME1 (lime_gamepad_get_device_name);
	DEFINE_PRIME4v (lime_gamepad_rumble);
	DEFINE_PRIME4v (lime_gamepad_set_led);
	DEFINE_PRIME2 (lime_gzip_compress);
	DEFINE_PRIME2 (lime_gzip_decompress);
	DEFINE_PRIME2v (lime_haptic_vibrate);
	DEFINE_PRIME3v (lime_image_data_util_color_transform);
	DEFINE_PRIME6v (lime_image_data_util_copy_channel);
	DEFINE_PRIME7v (lime_image_data_util_copy_pixels);
	DEFINE_PRIME4v (lime_image_data_util_fill_rect);
	DEFINE_PRIME5v (lime_image_data_util_flood_fill);
	DEFINE_PRIME4v (lime_image_data_util_get_pixels);
	DEFINE_PRIME8v (lime_image_data_util_merge);
	DEFINE_PRIME1v (lime_image_data_util_multiply_alpha);
	DEFINE_PRIME4v (lime_image_data_util_resize);
	DEFINE_PRIME2v (lime_image_data_util_set_format);
	DEFINE_PRIME6v (lime_image_data_util_set_pixels);
	DEFINE_PRIME12 (lime_image_data_util_threshold);
	DEFINE_PRIME1v (lime_image_data_util_unmultiply_alpha);
	DEFINE_PRIME4 (lime_image_encode);
	DEFINE_PRIME2 (lime_image_load_bytes);
	DEFINE_PRIME2 (lime_image_load_file);
	DEFINE_PRIME0 (lime_jni_getenv);
	DEFINE_PRIME2v (lime_joystick_event_manager_register);
	DEFINE_PRIME1 (lime_joystick_get_device_guid);
	DEFINE_PRIME1 (lime_joystick_get_device_name);
	DEFINE_PRIME1 (lime_joystick_get_num_axes);
	DEFINE_PRIME1 (lime_joystick_get_num_buttons);
	DEFINE_PRIME1 (lime_joystick_get_num_hats);
	DEFINE_PRIME4v (lime_joystick_rumble);
	DEFINE_PRIME4v (lime_joystick_set_led);
	DEFINE_PRIME1 (lime_key_code_from_scan_code);
	DEFINE_PRIME1 (lime_key_code_to_scan_code);
	DEFINE_PRIME2v (lime_key_event_manager_register);
	DEFINE_PRIME0 (lime_locale_get_system_locale);
	DEFINE_PRIME2 (lime_lzma_compress);
	DEFINE_PRIME2 (lime_lzma_decompress);
	DEFINE_PRIME2v (lime_mouse_event_manager_register);
	DEFINE_PRIME2v (lime_orientation_event_manager_register);
	DEFINE_PRIME2 (lime_png_decode_bytes);
	DEFINE_PRIME2 (lime_png_decode_file);
	DEFINE_PRIME2 (lime_jpeg_decode_bytes);
	DEFINE_PRIME2 (lime_jpeg_decode_file);
	DEFINE_PRIME2 (lime_bmp_decode_bytes);
	DEFINE_PRIME2 (lime_bmp_decode_file);
	DEFINE_PRIME2 (lime_svg_decode_bytes);
	DEFINE_PRIME2 (lime_svg_decode_file);
	DEFINE_PRIME4 (lime_svg_decode_sized_bytes);
	DEFINE_PRIME4 (lime_svg_decode_sized_file);
	DEFINE_PRIME2v (lime_render_event_manager_register);
	DEFINE_PRIME2v (lime_sensor_event_manager_register);
	DEFINE_PRIME0 (lime_system_get_allow_screen_timeout);
	DEFINE_PRIME0 (lime_system_get_device_model);
	DEFINE_PRIME0 (lime_system_get_device_vendor);
	DEFINE_PRIME3 (lime_system_get_directory);
	DEFINE_PRIME1 (lime_system_get_display);
	DEFINE_PRIME0 (lime_system_get_num_displays);
	DEFINE_PRIME0 (lime_system_get_first_gyroscope_sensor_id);
	DEFINE_PRIME0 (lime_system_get_first_accelerometer_sensor_id);
	DEFINE_PRIME0 (lime_system_get_platform_label);
	DEFINE_PRIME0 (lime_system_get_platform_name);
	DEFINE_PRIME0 (lime_system_get_platform_version);
	DEFINE_PRIME0 (lime_system_get_timer);
	DEFINE_PRIME0 (lime_system_get_theme);
	DEFINE_PRIME1 (lime_system_get_windows_console_mode);
	DEFINE_PRIME1v (lime_system_open_file);
	DEFINE_PRIME2v (lime_system_open_url);
	DEFINE_PRIME1 (lime_system_set_allow_screen_timeout);
	DEFINE_PRIME1 (lime_system_get_hint);
	DEFINE_PRIME2v (lime_system_set_hint);
	DEFINE_PRIME2 (lime_system_set_windows_console_mode);
	DEFINE_PRIME2v (lime_text_event_manager_register);
	DEFINE_PRIME2v (lime_touch_event_manager_register);
	DEFINE_PRIME5 (lime_window_alert);
	DEFINE_PRIME2v (lime_gesture_event_manager_register);
	DEFINE_PRIME2 (lime_window_set_vsync_mode);
	DEFINE_PRIME1v (lime_window_close);
	DEFINE_PRIME1v (lime_window_context_flip);
	DEFINE_PRIME1v (lime_window_context_make_current);
	DEFINE_PRIME5 (lime_window_create);
	DEFINE_PRIME2v (lime_window_event_manager_register);
	DEFINE_PRIME1v (lime_window_focus);
	DEFINE_PRIME1 (lime_window_get_handle);
	DEFINE_PRIME1 (lime_window_get_context);
	DEFINE_PRIME1 (lime_window_get_display);
	DEFINE_PRIME1 (lime_window_get_display_mode);
	DEFINE_PRIME1 (lime_window_get_height);
	DEFINE_PRIME1 (lime_window_get_id);
	DEFINE_PRIME1 (lime_window_get_mouse_lock);
	DEFINE_PRIME1 (lime_window_get_scale);
	DEFINE_PRIME1 (lime_window_get_text_input_enabled);
	DEFINE_PRIME1 (lime_window_get_width);
	DEFINE_PRIME1 (lime_window_get_x);
	DEFINE_PRIME1 (lime_window_get_y);
	DEFINE_PRIME3v (lime_window_move);
	DEFINE_PRIME3 (lime_window_read_pixels);
	DEFINE_PRIME3v (lime_window_resize);
	DEFINE_PRIME3v (lime_window_set_minimum_size);
	DEFINE_PRIME3v (lime_window_set_maximum_size);
	DEFINE_PRIME2 (lime_window_set_borderless);
	DEFINE_PRIME2v (lime_window_set_cursor);
	DEFINE_PRIME2 (lime_window_set_display_mode);
	DEFINE_PRIME2 (lime_window_set_fullscreen);
	DEFINE_PRIME2v (lime_window_set_icon);
	DEFINE_PRIME2 (lime_window_set_maximized);
	DEFINE_PRIME2 (lime_window_set_minimized);
	DEFINE_PRIME2v (lime_window_set_mouse_lock);
	DEFINE_PRIME2 (lime_window_set_resizable);
	DEFINE_PRIME2v (lime_window_set_text_input_enabled);
	DEFINE_PRIME2v (lime_window_set_text_input_rect);
	DEFINE_PRIME2 (lime_window_set_title);
	DEFINE_PRIME2 (lime_window_set_visible);
	DEFINE_PRIME2 (lime_window_set_always_on_top);
	DEFINE_PRIME3v (lime_window_warp_mouse);
	DEFINE_PRIME1 (lime_window_get_opacity);
	DEFINE_PRIME2v (lime_window_set_opacity);
	DEFINE_PRIME2 (lime_audio_decoder_open_file);
	DEFINE_PRIME2 (lime_audio_decoder_open_bytes);
	DEFINE_PRIME1 (lime_audio_decoder_info);
	DEFINE_PRIME4 (lime_audio_decoder_decode);
	DEFINE_PRIME1 (lime_audio_decoder_rewind);
	DEFINE_PRIME3 (lime_audio_decoder_seek);
	DEFINE_PRIME1 (lime_audio_decoder_can_seek);
	DEFINE_PRIME1 (lime_audio_decoder_tell);
	DEFINE_PRIME1 (lime_audio_decoder_total);
	DEFINE_PRIME2 (lime_zlib_compress);
	DEFINE_PRIME2 (lime_zlib_decompress);
	DEFINE_PRIME0 (lime_touch_get_devices);
	DEFINE_PRIME1 (lime_touch_get_device_name);
	DEFINE_PRIME1 (lime_touch_get_device_type);


}


#ifdef LIME_CAIRO
extern "C" int lime_cairo_register_prims ();
#else
extern "C" int lime_cairo_register_prims () { return 0; }
#endif

#ifdef LIME_HARFBUZZ
extern "C" int lime_harfbuzz_register_prims ();
#else
extern "C" int lime_harfbuzz_register_prims () { return 0; }
#endif

#ifdef LIME_OPENAL
extern "C" int lime_openal_register_prims ();
#else
extern "C" int lime_openal_register_prims () { return 0; }
#endif

#ifdef LIME_OPENGL
extern "C" int lime_opengl_register_prims ();
#else
extern "C" int lime_opengl_register_prims () { return 0; }
#endif


extern "C" int lime_register_prims () {

	lime_cairo_register_prims ();
	lime_harfbuzz_register_prims ();
	lime_openal_register_prims ();
	lime_opengl_register_prims ();

	return 0;

}
