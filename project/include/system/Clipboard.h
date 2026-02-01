#ifndef LIME_SYSTEM_CLIPBOARD_H
#define LIME_SYSTEM_CLIPBOARD_H

#include <string>


namespace lime {


	class Clipboard {


		public:

			static std::wstring* GetText ();
			static bool HasText ();
			static bool SetText (const char* text);


	};


}


#endif