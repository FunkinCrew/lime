#include <graphics/PixelFormat.h>
#include <math/Rectangle.h>
#include <system/Clipboard.h>
#include <system/DisplayMode.h>
#include <system/JNI.h>
#include <system/System.h>

#ifdef HX_MACOS
#include <CoreFoundation/CoreFoundation.h>
#endif

#ifdef HX_WINDOWS
#include <shlobj.h>
#include <stdio.h>
//#include <io.h>
//#include <fcntl.h>
#ifdef __MINGW32__
#ifndef CSIDL_MYDOCUMENTS
#define CSIDL_MYDOCUMENTS CSIDL_PERSONAL
#endif
#ifndef SHGFP_TYPE_CURRENT
#define SHGFP_TYPE_CURRENT 0
#endif
#endif
#if UNICODE
#define WIN_StringToUTF8(S) SDL_iconv_string("UTF-8", "UTF-16LE", (char *)(S), (SDL_wcslen(S)+1)*sizeof(WCHAR))
#define WIN_UTF8ToString(S) (WCHAR *)SDL_iconv_string("UTF-16LE", "UTF-8", (char *)(S), SDL_strlen(S)+1)
#else
#define WIN_StringToUTF8(S) SDL_iconv_string("UTF-8", "ASCII", (char *)(S), (SDL_strlen(S)+1))
#define WIN_UTF8ToString(S) SDL_iconv_string("ASCII", "UTF-8", (char *)(S), SDL_strlen(S)+1)
#endif
#endif

#ifdef ANDROID
#include <android/asset_manager_jni.h>
#endif

#include <SDL3/SDL.h>
#include <string>

#ifdef HX_WINDOWS
#include <locale>
#include <codecvt>
#endif


namespace lime {


	static int id_bounds;
	static int id_currentMode;
	static int id_dpi;
	static int id_height;
	static int id_name;
	static int id_pixelFormat;
	static int id_refreshRate;
	static int id_supportedModes;
	static int id_width;
	static bool init = false;


	std::wstring* Clipboard::GetText () {

		std::wstring* result = 0;
		System::GCEnterBlocking ();

		char* text = (char*)SDL_GetClipboardText ();

		#ifdef HX_WINDOWS
		std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
		result = new std::wstring (converter.from_bytes(text));
		#else
		result = new std::wstring (text, text + strlen (text));
		#endif

		SDL_free (text);

		System::GCExitBlocking ();
		return result;

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


	std::wstring* System::GetDirectory (SystemDirectory type, const char* company, const char* title) {

		std::wstring* result = 0;
		System::GCEnterBlocking ();

		switch (type) {

			case APPLICATION: {

				char* path = (char*)SDL_GetBasePath ();
				#ifdef HX_WINDOWS
				std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
				result = new std::wstring (converter.from_bytes(path));
				#else
				result = new std::wstring (path, path + strlen (path));
				#endif
				SDL_free (path);
				break;

			}

			case APPLICATION_STORAGE: {

				char* path = SDL_GetPrefPath (company, title);
				#ifdef HX_WINDOWS
				std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
				result = new std::wstring (converter.from_bytes(path));
				#else
				result = new std::wstring (path, path + strlen (path));
				#endif
				SDL_free (path);
				break;

			}

			case DESKTOP: {

				#if defined (HX_WINRT)

				Windows::Storage::StorageFolder^ folder = Windows::Storage::KnownFolders::HomeGroup;
				result = new std::wstring (folder->Path->Data ());

				#elif defined (HX_WINDOWS)

				char folderPath[MAX_PATH] = "";
				SHGetFolderPath (NULL, CSIDL_DESKTOPDIRECTORY, NULL, SHGFP_TYPE_CURRENT, folderPath);
				//WIN_StringToUTF8 (folderPath);
				std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
				result = new std::wstring (converter.from_bytes (folderPath));

				#elif defined (IPHONE)

				result = System::GetIOSDirectory (type);

				#elif !defined (ANDROID)

				char const* home = getenv ("HOME");

				if (home == NULL) {

					return 0;

				}

				std::string path = std::string (home) + std::string ("/Desktop");
				result = new std::wstring (path.begin (), path.end ());

				#endif
				break;

			}

			case DOCUMENTS: {

				#if defined (HX_WINRT)

				Windows::Storage::StorageFolder^ folder = Windows::Storage::KnownFolders::DocumentsLibrary;
				result = new std::wstring (folder->Path->Data ());

				#elif defined (HX_WINDOWS)

				char folderPath[MAX_PATH] = "";
				SHGetFolderPath (NULL, CSIDL_MYDOCUMENTS, NULL, SHGFP_TYPE_CURRENT, folderPath);
				//WIN_StringToUTF8 (folderPath);
				std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
				result = new std::wstring (converter.from_bytes (folderPath));

				#elif defined (IPHONE)

				result = System::GetIOSDirectory (type);

				#elif defined (ANDROID)

				result = new std::wstring (L"/mnt/sdcard/Documents");

				#else

				char const* home = getenv ("HOME");

				if (home != NULL) {

					std::string path = std::string (home) + std::string ("/Documents");
					result = new std::wstring (path.begin (), path.end ());

				}

				#endif
				break;

			}

			case FONTS: {

				#if defined (HX_WINRT)

				// TODO

				#elif defined (HX_WINDOWS)

				char folderPath[MAX_PATH] = "";
				SHGetFolderPath (NULL, CSIDL_FONTS, NULL, SHGFP_TYPE_CURRENT, folderPath);
				//WIN_StringToUTF8 (folderPath);
				std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
				result = new std::wstring (converter.from_bytes (folderPath));

				#elif defined (HX_MACOS)

				result = new std::wstring (L"/Library/Fonts");

				#elif defined (IPHONE)

				result = new std::wstring (L"/System/Library/Fonts");

				#elif defined (ANDROID)

				result = new std::wstring (L"/system/fonts");

				#elif defined (BLACKBERRY)

				result = new std::wstring (L"/usr/fonts/font_repository/monotype");

				#else

				result = new std::wstring (L"/usr/share/fonts/truetype");

				#endif
				break;

			}

			case USER: {

				#if defined (HX_WINRT)

				Windows::Storage::StorageFolder^ folder = Windows::Storage::ApplicationData::Current->RoamingFolder;
				result = new std::wstring (folder->Path->Data ());

				#elif defined (HX_WINDOWS)

				char folderPath[MAX_PATH] = "";
				SHGetFolderPath (NULL, CSIDL_PROFILE, NULL, SHGFP_TYPE_CURRENT, folderPath);
				//WIN_StringToUTF8 (folderPath);
				std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
				result = new std::wstring (converter.from_bytes (folderPath));

				#elif defined (IPHONE)

				result = System::GetIOSDirectory (type);

				#elif defined (ANDROID)

				result = new std::wstring (L"/mnt/sdcard");

				#else

				char const* home = getenv ("HOME");

				if (home != NULL) {

					std::string path = std::string (home);
					result = new std::wstring (path.begin (), path.end ());

				}

				#endif
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
				id_pixelFormat = val_id ("pixelFormat");
				id_refreshRate = val_id ("refreshRate");
				id_supportedModes = val_id ("supportedModes");
				id_width = val_id ("width");
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


	int System::GetDisplayOrientation(int displayIndex) {
		int orientation = 0;
		switch(SDL_GetCurrentDisplayOrientation(displayIndex)) {
			case SDL_ORIENTATION_UNKNOWN:
				orientation = 0;
				break;
			case SDL_ORIENTATION_LANDSCAPE:
				orientation = 1;
				break;
			case SDL_ORIENTATION_LANDSCAPE_FLIPPED:
				orientation = 2;
				break;
			case SDL_ORIENTATION_PORTRAIT:
				orientation = 3;
				break;
			case SDL_ORIENTATION_PORTRAIT_FLIPPED:
				orientation = 4;
				break;
		}

		return orientation;
	}

	std::wstring* System::GetHint (const char* key) {

		std::string hintKey (key);

		if (hintKey.rfind ("SDL_", 0) != 0) {

			hintKey = "SDL_" + hintKey;

		}

		const char* raw = SDL_GetHint (hintKey.c_str ());

		if (!raw) {

			return nullptr;

		}

		std::string hint = std::string (raw);
		std::wstring* _hint = new std::wstring (hint.begin (), hint.end ());
		return _hint;

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


	FILE* FILE_HANDLE::getFile () {

		#ifndef HX_WINDOWS

		SDL_PropertiesID properties = SDL_GetIOProperties((SDL_IOStream*)handle);

		FILE* filePointer = (FILE*)SDL_GetPointerProperty(properties, SDL_PROP_IOSTREAM_STDIO_FILE_POINTER, NULL);

		if(filePointer != NULL)
			return filePointer;

		#ifdef ANDROID
			System::GCEnterBlocking ();
			int fd;
			off_t outStart;
			off_t outLength;
			fd = AAsset_openFileDescriptor ((AAsset*)SDL_GetPointerProperty(properties, SDL_PROP_IOSTREAM_ANDROID_AASSET_POINTER, NULL), &outStart, &outLength);
			FILE* file = ::fdopen (fd, "rb");
			::fseek (file, outStart, 0);
			System::GCExitBlocking ();
			return file;
		#endif

		return NULL;

		#else

		return (FILE*)handle;

		#endif
	}


	int FILE_HANDLE::getLength () {

		#ifndef HX_WINDOWS

		System::GCEnterBlocking ();
		int size = SDL_GetIOSize (((SDL_IOStream*)handle));
		System::GCExitBlocking ();
		return size;

		#else

		return 0;

		#endif

	}


	bool FILE_HANDLE::isFile () {

		return true;

	}


	int fclose (FILE_HANDLE *stream) {

		#ifndef HX_WINDOWS

		if (stream) {

			System::GCEnterBlocking ();
			int code = SDL_CloseIO ((SDL_IOStream*)stream->handle);
			delete stream;
			System::GCExitBlocking ();
			return code;

		}

		return 0;

		#else

		if (stream) {

			System::GCEnterBlocking ();
			int code = ::fclose ((FILE*)stream->handle);
			delete stream;
			System::GCExitBlocking ();
			return code;

		}

		return 0;

		#endif

	}


	FILE_HANDLE *fopen (const char *filename, const char *mode) {

		#ifndef HX_WINDOWS

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

		#else

		std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
		std::wstring* wfilename = new std::wstring (converter.from_bytes (filename));
		std::wstring* wmode = new std::wstring (converter.from_bytes (mode));

		System::GCEnterBlocking ();

		FILE* result = ::_wfopen (wfilename->c_str(), wmode->c_str());

		System::GCExitBlocking ();

		delete wfilename;
		delete wmode;

		if (result) {

			return new FILE_HANDLE (result);

		}

		return NULL;

		#endif

	}


	size_t fread (void *ptr, size_t size, size_t count, FILE_HANDLE *stream) {

		size_t nmem;
		System::GCEnterBlocking ();

		#ifndef HX_WINDOWS

        if(size > 0 && count > 0)
	  	    nmem = SDL_ReadIO (stream ? (SDL_IOStream*)stream->handle : NULL, ptr, size * count) / size;
        else
		    nmem = 0;

		#else

		nmem = ::fread (ptr, size, count, (FILE*)stream->handle);

		#endif

		System::GCExitBlocking ();
		return nmem;

	}


	int fseek (FILE_HANDLE *stream, long int offset, int origin) {

		int success;
		System::GCEnterBlocking ();

		#ifndef HX_WINDOWS

		success = SDL_SeekIO (stream ? (SDL_IOStream*)stream->handle : NULL, offset, (SDL_IOWhence)origin);

		#else

		success = ::fseek ((FILE*)stream->handle, offset, origin);

		#endif

		System::GCExitBlocking ();
		return success;

	}


	long int ftell (FILE_HANDLE *stream) {

		long int pos;
		System::GCEnterBlocking ();

		#ifndef HX_WINDOWS

		pos = SDL_TellIO (stream ? (SDL_IOStream*)stream->handle : NULL);

		#else

		pos = ::ftell ((FILE*)stream->handle);

		#endif

		System::GCExitBlocking ();
		return pos;

	}


	size_t fwrite (const void *ptr, size_t size, size_t count, FILE_HANDLE *stream) {

		size_t nmem;
		System::GCEnterBlocking ();

		#ifndef HX_WINDOWS

  		if(size > 0 && count > 0)
            nmem = SDL_WriteIO (stream ? (SDL_IOStream*)stream->handle : NULL, ptr, size * count) / size;
        else
		    nmem = 0;

		#else

		nmem = ::fwrite (ptr, size, count, (FILE*)stream->handle);

		#endif

		System::GCExitBlocking ();
		return nmem;

	}


}
