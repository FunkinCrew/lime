#import <UIKit/UIKit.h>
#import <sys/utsname.h>

#include <SDL3/SDL.h>

#include <system/System.h>


namespace lime {


	char* System::GetDeviceModel () {

		struct utsname systemInfo;
		uname (&systemInfo);
		return SDL_strdup (systemInfo.machine);

	}


	char* System::GetDeviceVendor () {

		return NULL;

	}


	char* System::GetPlatformLabel () {

		return NULL;

	}


	char* System::GetPlatformName () {

		return NULL;

	}


	char* System::GetPlatformVersion () {

		return SDL_strdup([[[UIDevice currentDevice] systemVersion] UTF8String]);

	}


}