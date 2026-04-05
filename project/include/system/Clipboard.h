#pragma once
#include <string>


namespace lime {


	class Clipboard {


		public:

			static std::wstring* GetText ();
			static bool HasText ();
			static bool SetText (const char* text);


	};


}