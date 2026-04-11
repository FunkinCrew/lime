#include <SDL3/SDL.h>
#include <ui/Cursor.h>
#include <map>


namespace lime {


	std::map<SystemCursor, SDL_Cursor*> cursors;


	void* Cursor::GetSystemCursor (SystemCursor type) {

		auto it = cursors.find (type);

		if (it != cursors.end ()) {

			return it->second;

		}

		SDL_SystemCursor systemCursor;

		switch (type) {

			case CROSSHAIR:
				systemCursor = SDL_SYSTEM_CURSOR_CROSSHAIR;
				break;

			case MOVE:
				systemCursor = SDL_SYSTEM_CURSOR_MOVE;
				break;

			case POINTER:
				systemCursor = SDL_SYSTEM_CURSOR_POINTER;
				break;

			case RESIZE_NESW:
				systemCursor = SDL_SYSTEM_CURSOR_NESW_RESIZE;
				break;

			case RESIZE_NS:
				systemCursor = SDL_SYSTEM_CURSOR_NS_RESIZE;
				break;

			case RESIZE_NWSE:
				systemCursor = SDL_SYSTEM_CURSOR_NWSE_RESIZE;
				break;

			case RESIZE_WE:
				systemCursor = SDL_SYSTEM_CURSOR_EW_RESIZE;
				break;

			case TEXT:
				systemCursor = SDL_SYSTEM_CURSOR_TEXT;
				break;

			case WAIT:
				systemCursor = SDL_SYSTEM_CURSOR_WAIT;
				break;

			case WAIT_ARROW:
				systemCursor = SDL_SYSTEM_CURSOR_PROGRESS;
				break;

			default:
				systemCursor = SDL_SYSTEM_CURSOR_DEFAULT;
				break;

		}

		SDL_Cursor* cursor = SDL_CreateSystemCursor(systemCursor);

		if (!cursor) {

			return nullptr;

		}

		cursors[type] = cursor;

		return cursor;

	}


}