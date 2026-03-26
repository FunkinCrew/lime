#include <ui/FileDialog.h>
#ifdef LIME_SDL
#include "../backend/sdl/SDLWindow.h"
#endif
#include <stdio.h>
#include <vector>
#include <string>
#include <functional>

namespace lime {

	#ifdef LIME_SDL
	struct FileDialogData {
		std::function<void(const char* const*, int, int)> callback;
		std::vector<SDL_DialogFileFilter> filters;
	};


	struct MainThreadCallbackData {
		const char** filelist;
		int filecount;
		int filter;
		FileDialogData* dialogData;
	};


	static void SDLCALL mainThreadCallback (void* userdata) {

		auto* mainData = static_cast<MainThreadCallbackData*> (userdata);

		if (mainData) {

			auto* data = mainData->dialogData;

			if (data) {

				if (data->callback) {

					data->callback (mainData->filelist, mainData->filecount, mainData->filter);

				}

				for (auto& f : data->filters) {

					SDL_free ((void*)f.name);
					SDL_free ((void*)f.pattern);

				}

				if (mainData->filelist) {

					for (int i = 0; i < mainData->filecount; ++i) {

						SDL_free ((void*)mainData->filelist[i]);

					}

					SDL_free ((void*)mainData->filelist);

				}

				delete data;

			}

			delete mainData;

		}

	}


	static void SDLCALL dialogFileCallbackThunk (void* userdata, const char* const* filelist, int filter) {

		auto* data = static_cast<FileDialogData*> (userdata);

		if (data) {

			int filecount = 0;

			if (filelist && (*filelist)) {

				while (filelist[filecount] != nullptr) {

					filecount++;

				}

			}

			auto* mainData = new MainThreadCallbackData;

			mainData->filecount = filecount;
			mainData->filter = filter;
			mainData->dialogData = data;

			if (filecount > 0 && filelist) {

				mainData->filelist = static_cast<const char**>(SDL_malloc ((filecount + 1) * sizeof (const char*)));

				for (int i = 0; i < filecount; ++i) {

					mainData->filelist[i] = SDL_strdup(filelist[i]);

				}

				mainData->filelist[filecount] = nullptr;

			} else {

				mainData->filelist = nullptr;

			}

			SDL_RunOnMainThread (mainThreadCallback, mainData, false);

		}

	}


	static std::vector<SDL_DialogFileFilter> buildFilters (const char** names, const char** patterns, int count) {

		std::vector<SDL_DialogFileFilter> filters;

		filters.reserve (count);

		for (int i = 0; i < count; ++i) {

			SDL_DialogFileFilter f;
			f.name = SDL_strdup(names[i]);
			f.pattern = SDL_strdup(patterns[i]);
			filters.push_back(f);

		}

		return filters;

	}
	#endif


    void FileDialog::OpenDirectory (Window* window, const char* title, std::function<void(const char* const*, int, int)> callback, const char* defaultPath, bool allowMultiple) {

		#ifdef LIME_SDL
		SDL_PropertiesID props = SDL_CreateProperties ();

		SDL_SetPointerProperty (props, SDL_PROP_FILE_DIALOG_WINDOW_POINTER, window ? static_cast<SDLWindow*> (window)->sdlWindow : nullptr);
		SDL_SetStringProperty (props, SDL_PROP_FILE_DIALOG_LOCATION_STRING, defaultPath);
		SDL_SetBooleanProperty (props, SDL_PROP_FILE_DIALOG_MANY_BOOLEAN, allowMultiple);

		if (title) {

			SDL_SetStringProperty (props, SDL_PROP_FILE_DIALOG_TITLE_STRING, title);

		}

		auto* dialogData = new FileDialogData;
		dialogData->callback = std::move (callback);
		SDL_ShowFileDialogWithProperties (SDL_FILEDIALOG_OPENFOLDER, dialogFileCallbackThunk, dialogData, props);

		SDL_DestroyProperties (props);
		#endif

    }


	void FileDialog::OpenFile (Window* window, const char* title, std::function<void(const char* const*, int, int)> callback, const char** names, const char** patterns, int filterCount, const char* defaultPath, bool allowMultiple) {

		#ifdef LIME_SDL
		auto* dialogData = new FileDialogData;
		dialogData->callback = std::move(callback);
		dialogData->filters = buildFilters(names, patterns, filterCount);

		SDL_PropertiesID props = SDL_CreateProperties();

		SDL_SetPointerProperty(props, SDL_PROP_FILE_DIALOG_FILTERS_POINTER, (void*)dialogData->filters.data());
		SDL_SetNumberProperty(props, SDL_PROP_FILE_DIALOG_NFILTERS_NUMBER, static_cast<int>(dialogData->filters.size()));
		SDL_SetPointerProperty(props, SDL_PROP_FILE_DIALOG_WINDOW_POINTER, window ? static_cast<SDLWindow*>(window)->sdlWindow : nullptr);
		SDL_SetStringProperty(props, SDL_PROP_FILE_DIALOG_LOCATION_STRING, defaultPath);
		SDL_SetBooleanProperty(props, SDL_PROP_FILE_DIALOG_MANY_BOOLEAN, allowMultiple);

		if (title) {

			SDL_SetStringProperty(props, SDL_PROP_FILE_DIALOG_TITLE_STRING, title);

		}

		SDL_ShowFileDialogWithProperties(SDL_FILEDIALOG_OPENFILE, dialogFileCallbackThunk, dialogData, props);

		SDL_DestroyProperties(props);

		#endif

	}


	void FileDialog::SaveFile (Window* window, const char* title, std::function<void(const char* const*, int, int)> callback, const char** names, const char** patterns, int filterCount, const char* defaultPath) {

		#ifdef LIME_SDL
		auto* dialogData = new FileDialogData;
		dialogData->callback = std::move(callback);
		dialogData->filters = buildFilters(names, patterns, filterCount);

		SDL_PropertiesID props = SDL_CreateProperties();

		SDL_SetPointerProperty(props, SDL_PROP_FILE_DIALOG_FILTERS_POINTER, (void*)dialogData->filters.data());
		SDL_SetNumberProperty(props, SDL_PROP_FILE_DIALOG_NFILTERS_NUMBER, static_cast<int>(dialogData->filters.size()));
		SDL_SetPointerProperty(props, SDL_PROP_FILE_DIALOG_WINDOW_POINTER, window ? static_cast<SDLWindow*>(window)->sdlWindow : nullptr);
		SDL_SetStringProperty(props, SDL_PROP_FILE_DIALOG_LOCATION_STRING, defaultPath);

		if (title) {

			SDL_SetStringProperty(props, SDL_PROP_FILE_DIALOG_TITLE_STRING, title);

		}

		SDL_ShowFileDialogWithProperties(SDL_FILEDIALOG_SAVEFILE, dialogFileCallbackThunk, dialogData, props);

		SDL_DestroyProperties(props);

		#endif

	}


}
