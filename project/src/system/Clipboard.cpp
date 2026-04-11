#include <SDL3/SDL.h>
#include <system/Clipboard.h>
#include <system/System.h>


namespace lime {


	char* Clipboard::GetText () {

		System::GCEnterBlocking ();

		char* text = SDL_GetClipboardText ();

		System::GCExitBlocking ();

		return text;

	}


	bool Clipboard::HasText () {

		return SDL_HasClipboardText ();

	}


	bool Clipboard::SetText (const char* text) {

		return SDL_SetClipboardText (text);

	}


}