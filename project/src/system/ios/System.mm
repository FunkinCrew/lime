#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#include <system/System.h>


namespace lime {


	char* System::GetDeviceModel () {

		struct utsname systemInfo;
		uname (&systemInfo);
		return systemInfo.machine;

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

		return [[[UIDevice currentDevice] systemVersion] UTF8String];

	}


}