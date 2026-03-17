#include <ui/FileDialog.h>
#ifdef LIME_SDL
#include "../backend/sdl/SDLWindow.h"
#include <SDL3/SDL_properties.h>
#include <SDL3/SDL_dialog.h>
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
		SDL_PropertiesID props;
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
			SDL_DestroyProperties (data->props);

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
		auto* dialogData = new FileDialogData;
		dialogData->callback = std::move(callback);
		dialogData->props = SDL_CreateProperties();

		SDL_FileDialogType dialogType = SDL_FILEDIALOG_OPENFOLDER;
		SDL_SetStringProperty(dialogData->props, "SDL.filedialog.title", title);
		SDL_SetStringProperty(dialogData->props, "SDL.filedialog.location", defaultPath);
		SDL_SetBooleanProperty(dialogData->props, "SDL.filedialog.many", allowMultiple);
		SDL_SetPointerProperty(dialogData->props, "SDL.filedialog.window", window ? static_cast<SDLWindow*>(window)->sdlWindow : nullptr);

		SDL_ShowFileDialogWithProperties(dialogType, dialogFileCallbackThunk, dialogData, dialogData->props);
		// SDL_ShowOpenFolderDialog(dialogFileCallbackThunk, dialogData, window ? static_cast<SDLWindow*>(window)->sdlWindow : nullptr, defaultPath, allowMultiple);
		#endif

    }


	void FileDialog::OpenFile (Window* window, const char* title, std::function<void(const char* const*, int, int)> callback, const char** names, const char** patterns, int filterCount, const char* defaultPath, bool allowMultiple) {

		#ifdef LIME_SDL
		auto* dialogData = new FileDialogData;
		dialogData->callback = std::move(callback);
		dialogData->filters = buildFilters(names, patterns, filterCount);
		dialogData->props = SDL_CreateProperties();

		SDL_FileDialogType dialogType = SDL_FILEDIALOG_OPENFILE;
		SDL_SetStringProperty(dialogData->props, "SDL.filedialog.title", title);
		SDL_SetStringProperty(dialogData->props, "SDL.filedialog.location", defaultPath);
		SDL_SetBooleanProperty(dialogData->props, "SDL.filedialog.many", allowMultiple);
		SDL_SetPointerProperty(dialogData->props, "SDL.filedialog.filters", dialogData->filters.data());
		SDL_SetNumberProperty(dialogData->props, "SDL.filedialog.nfilters", static_cast<int>(dialogData->filters.size()));
		SDL_SetPointerProperty(dialogData->props, "SDL.filedialog.window", window ? static_cast<SDLWindow*>(window)->sdlWindow : nullptr);

		SDL_ShowFileDialogWithProperties(dialogType, dialogFileCallbackThunk, dialogData, dialogData->props);
		// SDL_ShowOpenFileDialog(dialogFileCallbackThunk, dialogData, window ? static_cast<SDLWindow*>(window)->sdlWindow : nullptr, dialogData->filters.data(), static_cast<int>(dialogData->filters.size()), defaultPath, allowMultiple);
		#endif

	}


	void FileDialog::SaveFile (Window* window, const char* title, std::function<void(const char* const*, int, int)> callback, const char** names, const char** patterns, int filterCount, const char* defaultPath) {

		#ifdef LIME_SDL
		auto* dialogData = new FileDialogData;
		dialogData->callback = std::move(callback);
		dialogData->filters = buildFilters(names, patterns, filterCount);
		dialogData->props = SDL_CreateProperties();

		SDL_FileDialogType dialogType = SDL_FILEDIALOG_SAVEFILE;
		SDL_SetStringProperty(dialogData->props, "SDL.filedialog.title", title);
		SDL_SetStringProperty(dialogData->props, "SDL.filedialog.location", defaultPath);
		SDL_SetPointerProperty(dialogData->props, "SDL.filedialog.filters", dialogData->filters.data());
		SDL_SetNumberProperty(dialogData->props, "SDL.filedialog.nfilters", static_cast<int>(dialogData->filters.size()));
		SDL_SetPointerProperty(dialogData->props, "SDL.filedialog.window", window ? static_cast<SDLWindow*>(window)->sdlWindow : nullptr);

		SDL_ShowFileDialogWithProperties(dialogType, dialogFileCallbackThunk, dialogData, dialogData->props);
		// SDL_ShowSaveFileDialog(dialogFileCallbackThunk, dialogData, window ? static_cast<SDLWindow*>(window)->sdlWindow : nullptr, dialogData->filters.data(), static_cast<int>(dialogData->filters.size()), defaultPath);
		#endif

	}


}
