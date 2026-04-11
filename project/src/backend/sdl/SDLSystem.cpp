#include <graphics/PixelFormat.h>
#include <math/Rectangle.h>
#include <system/Clipboard.h>
#include <system/DisplayMode.h>
#include <system/JNI.h>
#include <system/System.h>

#include <SDL3/SDL.h>

#include <string>
#include <locale>
#include <codecvt>


namespace lime {


	static int id_bounds;
	static int id_currentMode;
	static int id_dpi;
	static int id_height;
	static int id_name;
	static int id_orientation;
	static int id_pixelFormat;
	static int id_refreshRate;
	static int id_supportedModes;
	static int id_width;
	static int id_safeArea;
	static bool init = false;


	char* Clipboard::GetText () {

		System::GCEnterBlocking ();

		char* text = (char*)SDL_GetClipboardText ();

		System::GCExitBlocking ();

		return text;

	}


	bool Clipboard::HasText () {

		return SDL_HasClipboardText ();

	}


	bool Clipboard::SetText (const char* text) {

		return (SDL_SetClipboardText (text));

	}


	void *JNI::GetEnv () {

		#ifdef ANDROID
		return SDL_GetAndroidJNIEnv ();
		#else
		return 0;
		#endif

	}


	bool System::GetAllowScreenTimeout () {

		return SDL_ScreenSaverEnabled ();

	}


	char* System::GetDirectory (SystemDirectory type, const char* company, const char* title) {

		char* result = nullptr;

		System::GCEnterBlocking ();

		switch (type) {

			case APPLICATION: {

				result = SDL_strdup (SDL_GetBasePath ());
				break;

			}

			case APPLICATION_STORAGE: {

				result = SDL_GetPrefPath (company, title);
				break;

			}

			case DESKTOP: {

				result = SDL_strdup (SDL_GetUserFolder (SDL_FOLDER_DESKTOP));
				break;

			}

			case DOCUMENTS: {

				result = SDL_strdup (SDL_GetUserFolder (SDL_FOLDER_DOCUMENTS));
				break;

			}

			case USER: {

				result = SDL_strdup (SDL_GetUserFolder (SDL_FOLDER_HOME));
				break;

			}

		}

		System::GCExitBlocking ();

		return result;

	}


	void* System::GetDisplay (bool useCFFIValue, int id) {

		if (id == 0)
			id = SDL_GetPrimaryDisplay();

		if (useCFFIValue) {

			if (!init) {

				id_bounds = val_id ("bounds");
				id_currentMode = val_id ("currentMode");
				id_dpi = val_id ("dpi");
				id_height = val_id ("height");
				id_name = val_id ("name");
				id_orientation = val_id ("orientation");
				id_pixelFormat = val_id ("pixelFormat");
				id_refreshRate = val_id ("refreshRate");
				id_supportedModes = val_id ("supportedModes");
				id_width = val_id ("width");
				id_safeArea = val_id ("safeArea");
				init = true;

			}

			const char* displayName = SDL_GetDisplayName (id);
			if (displayName == NULL) {

				return alloc_null ();

			}

			value display = alloc_empty_object ();
			alloc_field (display, id_name, alloc_string (displayName));

			SDL_Rect bounds = { 0, 0, 0, 0 };
			SDL_GetDisplayBounds (id, &bounds);
			alloc_field (display, id_bounds, Rectangle (bounds.x, bounds.y, bounds.w, bounds.h).Value ());

			SDL_Rect usable = { 0, 0, 0, 0 };
			SDL_GetDisplayUsableBounds(id, &usable);
			alloc_field(display, id_safeArea, Rectangle (usable.x, usable.y, usable.w, usable.h).Value ());

			const SDL_DisplayMode *displayMode = SDL_GetDesktopDisplayMode (id);

			float dpi = 72.0f;

			#ifndef EMSCRIPTEN

			float pixelDensity = displayMode ? displayMode->pixel_density : 1.0f;

			float contentScale = SDL_GetDisplayContentScale (id);

			if (contentScale == 0.0f) {

				contentScale = 1.0f;

			}

			#if defined (ANDROID) || defined (__IPHONEOS__)
			dpi = pixelDensity * contentScale * 160.0f;
			#else
			dpi = pixelDensity * contentScale * 96.0f;
			#endif

			#endif

			alloc_field (display, id_dpi, alloc_float (dpi));

			alloc_field (display, id_orientation, alloc_int ((int) SDL_GetCurrentDisplayOrientation (id)));

			DisplayMode mode;

			mode.height = displayMode->h;

			switch (displayMode->format) {

				case SDL_PIXELFORMAT_ARGB8888:

					mode.pixelFormat = ARGB32;
					break;

				case SDL_PIXELFORMAT_BGRA8888:
				case SDL_PIXELFORMAT_BGRX8888:

					mode.pixelFormat = BGRA32;
					break;

				default:

					mode.pixelFormat = RGBA32;

			}

			mode.refreshRate = displayMode->refresh_rate;
			mode.width = displayMode->w;

			alloc_field (display, id_currentMode, (value)mode.Value ());

			int numDisplayModes;
			SDL_DisplayMode **displayModes = SDL_GetFullscreenDisplayModes (id, &numDisplayModes);
			value supportedModes = alloc_array (numDisplayModes);

			for (int i = 0; i < numDisplayModes; i++) {

				const SDL_DisplayMode *sdlDisplayMode = displayModes[i];

				mode.height = sdlDisplayMode->h;

				switch (sdlDisplayMode->format) {

					case SDL_PIXELFORMAT_ARGB8888:

						mode.pixelFormat = ARGB32;
						break;

					case SDL_PIXELFORMAT_BGRA8888:
					case SDL_PIXELFORMAT_BGRX8888:

						mode.pixelFormat = BGRA32;
						break;

					default:

						mode.pixelFormat = RGBA32;

				}

				mode.refreshRate = sdlDisplayMode->refresh_rate;
				mode.width = sdlDisplayMode->w;

				val_array_set_i (supportedModes, i, (value)mode.Value ());

			}

			alloc_field (display, id_supportedModes, supportedModes);
			return display;

		} else {

			const int id_bounds = hl_hash_utf8 ("bounds");
			const int id_currentMode = hl_hash_utf8 ("currentMode");
			const int id_dpi = hl_hash_utf8 ("dpi");
			const int id_height = hl_hash_utf8 ("height");
			const int id_name = hl_hash_utf8 ("name");
			const int id_orientation = hl_hash_utf8 ("orientation");
			const int id_pixelFormat = hl_hash_utf8 ("pixelFormat");
			const int id_refreshRate = hl_hash_utf8 ("refreshRate");
			const int id_supportedModes = hl_hash_utf8 ("supportedModes");
			const int id_width = hl_hash_utf8 ("width");
			const int id_safeArea = hl_hash_utf8 ("safeArea");
			const int id_x = hl_hash_utf8 ("x");
			const int id_y = hl_hash_utf8 ("y");

			const char* displayName = SDL_GetDisplayName (id);
			if (displayName == NULL) {

				return 0;

			}

			vdynamic* display = (vdynamic*)hl_alloc_dynobj ();

			char* _displayName = (char*)malloc(strlen(displayName) + 1);
			strcpy (_displayName, displayName);
			hl_dyn_setp (display, id_name, &hlt_bytes, _displayName);

			SDL_Rect bounds = { 0, 0, 0, 0 };
			SDL_GetDisplayBounds (id, &bounds);

			vdynamic* _bounds = (vdynamic*)hl_alloc_dynobj ();
			hl_dyn_seti (_bounds, id_x, &hlt_i32, bounds.x);
			hl_dyn_seti (_bounds, id_y, &hlt_i32, bounds.y);
			hl_dyn_seti (_bounds, id_width, &hlt_i32, bounds.w);
			hl_dyn_seti (_bounds, id_height, &hlt_i32, bounds.h);

			hl_dyn_setp (display, id_bounds, &hlt_dynobj, _bounds);

			SDL_Rect usable = { 0, 0, 0, 0 };
			SDL_GetDisplayUsableBounds(id, &usable);

			vdynamic* _usable = (vdynamic*)hl_alloc_dynobj ();
			hl_dyn_seti (_usable, id_x, &hlt_i32, usable.x);
			hl_dyn_seti (_usable, id_y, &hlt_i32, usable.y);
			hl_dyn_seti (_usable, id_width, &hlt_i32, usable.w);
			hl_dyn_seti (_usable, id_height, &hlt_i32, usable.h);

			hl_dyn_setp (display, id_safeArea, &hlt_dynobj, _usable);

			const SDL_DisplayMode *displayMode = SDL_GetDesktopDisplayMode (id);

			float dpi = 72.0f;

			#ifndef EMSCRIPTEN

			float pixelDensity = displayMode ? displayMode->pixel_density : 1.0f;

			float contentScale = SDL_GetDisplayContentScale (id);

			if (contentScale == 0.0f) {

				contentScale = 1.0f;

			}

			#if defined (ANDROID) || defined (__IPHONEOS__)
			dpi = pixelDensity * contentScale * 160.0f;
			#else
			dpi = pixelDensity * contentScale * 96.0f;
			#endif

			#endif

			hl_dyn_setf (display, id_dpi, dpi);

			hl_dyn_seti (display, id_orientation, &hlt_i32, (int) SDL_GetCurrentDisplayOrientation (id));

			DisplayMode mode;

			mode.height = displayMode->h;

			switch (displayMode->format) {

				case SDL_PIXELFORMAT_ARGB8888:

					mode.pixelFormat = ARGB32;
					break;

				case SDL_PIXELFORMAT_BGRA8888:
				case SDL_PIXELFORMAT_BGRX8888:

					mode.pixelFormat = BGRA32;
					break;

				default:

					mode.pixelFormat = RGBA32;

			}

			mode.refreshRate = displayMode->refresh_rate;
			mode.width = displayMode->w;

			vdynamic* _displayMode = (vdynamic*)hl_alloc_dynobj ();
			hl_dyn_seti (_displayMode, id_height, &hlt_i32, mode.height);
			hl_dyn_seti (_displayMode, id_pixelFormat, &hlt_i32, mode.pixelFormat);
			hl_dyn_seti (_displayMode, id_refreshRate, &hlt_i32, mode.refreshRate);
			hl_dyn_seti (_displayMode, id_width, &hlt_i32, mode.width);
			hl_dyn_setp (display, id_currentMode, &hlt_dynobj, _displayMode);

			int numDisplayModes;
			SDL_DisplayMode **displayModes = SDL_GetFullscreenDisplayModes (id, &numDisplayModes);

			hl_varray* supportedModes = (hl_varray*)hl_alloc_array (&hlt_dynobj, numDisplayModes);
			vdynamic** supportedModesData = hl_aptr (supportedModes, vdynamic*);

			for (int i = 0; i < numDisplayModes; i++) {

				const SDL_DisplayMode *sdlDisplayMode = displayModes[i];

				mode.height = sdlDisplayMode->h;

				switch (sdlDisplayMode->format) {

					case SDL_PIXELFORMAT_ARGB8888:

						mode.pixelFormat = ARGB32;
						break;

					case SDL_PIXELFORMAT_BGRA8888:
					case SDL_PIXELFORMAT_BGRX8888:

						mode.pixelFormat = BGRA32;
						break;

					default:

						mode.pixelFormat = RGBA32;

				}

				mode.refreshRate = sdlDisplayMode->refresh_rate;
				mode.width = sdlDisplayMode->w;

				vdynamic* _displayMode = (vdynamic*)hl_alloc_dynobj ();
				hl_dyn_seti (_displayMode, id_height, &hlt_i32, mode.height);
				hl_dyn_seti (_displayMode, id_pixelFormat, &hlt_i32, mode.pixelFormat);
				hl_dyn_seti (_displayMode, id_refreshRate, &hlt_i32, mode.refreshRate);
				hl_dyn_seti (_displayMode, id_width, &hlt_i32, mode.width);

				*supportedModesData++ = _displayMode;

			}

			hl_dyn_setp (display, id_supportedModes, &hlt_array, supportedModes);
			return display;

		}

	}


	int System::GetFirstGyroscopeSensorId () {

		int count = 0;

		SDL_SensorID *sensors = SDL_GetSensors (&count);

		if (!sensors)
			return -1;

		for (int i = 0; i < count; i++)
		{
			if (SDL_GetSensorTypeForID (sensors[i]) == SDL_SENSOR_GYRO) {

				SDL_free (sensors);
				return sensors[i];

			}

		}

		SDL_free (sensors);
		return -1;

	}


	int System::GetFirstAccelerometerSensorId () {

		int count = 0;

		SDL_SensorID *sensors = SDL_GetSensors(&count);

		if (!sensors)
			return -1;

		for (int i = 0; i < count; i++) {

			if (SDL_GetSensorTypeForID(sensors[i]) == SDL_SENSOR_ACCEL) {

				SDL_free(sensors);
				return sensors[i];

			}

		}

		SDL_free (sensors);
		return -1;

	}


	int System::GetNumDisplays () {
		int numDisplays;
		SDL_DisplayID * displays = SDL_GetDisplays(&numDisplays);
		SDL_free(displays);
		return numDisplays;

	}


	double System::GetTimer () {

		return SDL_GetTicksNS ();

	}


	bool System::SetAllowScreenTimeout (bool allow) {

		if (allow) {

			SDL_EnableScreenSaver ();

		} else {

			SDL_DisableScreenSaver ();

		}

		return allow;

	}


	const char* System::GetHint (const char* key) {

		std::string hintKey (key);

		if (hintKey.rfind ("SDL_", 0) != 0) {

			hintKey = "SDL_" + hintKey;

		}

		const char* hint = SDL_GetHint (hintKey.c_str ());

		if (!hint) {

			return nullptr;

		}

		return hint;

	}

	void System::SetHint (const char* key, const char* value) {

		std::string hintKey (key);

		if (hintKey.rfind ("SDL_", 0) != 0) {

			hintKey = "SDL_" + hintKey;

		}

		SDL_SetHint (hintKey.c_str (), value);

	}


	void System::OpenFile (const char* path) {

		OpenURL (path, NULL);

	}


	void System::OpenURL (const char* url, const char* target) {

		SDL_OpenURL (url);

	}


	int fclose (FILE_HANDLE *stream) {

		if (stream) {

			System::GCEnterBlocking ();

			int code = SDL_CloseIO ((SDL_IOStream*)stream->handle);

			delete stream;

			System::GCExitBlocking ();

			return code;

		}

		return 0;

	}


	FILE_HANDLE *fopen (const char *filename, const char *mode) {

		System::GCEnterBlocking ();

		SDL_IOStream *result = SDL_IOFromFile (filename, mode);

		if (!result) {

			const char *base = SDL_GetBasePath ();

			if (base) {

				char *fullpath;

				if (SDL_asprintf (&fullpath, "%s%s", base, filename) >= 0) {

					result = SDL_IOFromFile (fullpath, mode);

					SDL_free (fullpath);

				}

			}

		}

		System::GCExitBlocking ();

		if (result) {

			return new FILE_HANDLE (result);

		}

		return NULL;

	}


	size_t fread (void *ptr, size_t size, size_t count, FILE_HANDLE *stream) {

		System::GCEnterBlocking ();

	  	size_t nmem = size > 0 && count > 0 ? SDL_ReadIO (stream ? (SDL_IOStream*)stream->handle : NULL, ptr, size * count) / size : 0;

		System::GCExitBlocking ();

		return nmem;

	}


	int fseek (FILE_HANDLE *stream, long int offset, int origin) {

		System::GCEnterBlocking ();

		int success = SDL_SeekIO (stream ? (SDL_IOStream*)stream->handle : NULL, offset, (SDL_IOWhence)origin);

		System::GCExitBlocking ();

		return success;

	}


	long int ftell (FILE_HANDLE *stream) {

		System::GCEnterBlocking ();

		long int pos = SDL_TellIO (stream ? (SDL_IOStream*)stream->handle : NULL);

		System::GCExitBlocking ();

		return pos;

	}


	size_t fwrite (const void *ptr, size_t size, size_t count, FILE_HANDLE *stream) {

		System::GCEnterBlocking ();

        size_t nmem = size > 0 && count > 0 ? SDL_WriteIO (stream ? (SDL_IOStream*)stream->handle : NULL, ptr, size * count) / size : 0;

		System::GCExitBlocking ();

		return nmem;

	}


}
