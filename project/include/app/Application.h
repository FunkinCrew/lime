#pragma once


#include <system/CFFI.h>


namespace lime {


	class Application {


		public:

			virtual ~Application () {};

			virtual int Exec () = 0;
			virtual void Init () = 0;
			virtual int Quit () = 0;
			virtual void SetFrameRate (double frameRate) = 0;
			virtual bool Update () = 0;


	};


	Application* CreateApplication ();


}
