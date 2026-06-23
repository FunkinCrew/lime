#pragma once


#include <string>
#include <vector>


namespace lime {


	class ValuePointer;

	class HaxeResource {


		public:

			static void Init (ValuePointer* listNamesMethod, ValuePointer* getBytesMethod);
			static bool GetBytes (const char* name, std::vector<unsigned char>& outData);
			static bool GetString (const char* name, std::string& outString);
			static std::vector<std::string> ListNames ();


	};


}
