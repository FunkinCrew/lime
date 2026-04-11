#pragma once


namespace lime {


	class Clipboard {


		public:

			static char* GetText ();
			static bool HasText ();
			static bool SetText (const char* text);


	};


}