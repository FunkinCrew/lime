#ifdef IPHONE
#import <UIKit/UIKit.h>
#endif

#import <sys/utsname.h>
#include <system/System.h>
#include <events/OrientationEvent.h>


#ifdef IPHONE
@interface OrientationObserver: NSObject
- (id) init;
- (void) dealloc;
- (void) dispatchEventForDevice:(UIDevice *) device;
- (void) orientationChanged:(NSNotification *) notification;
@end

@implementation OrientationObserver {

}

- (void) dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (id) init {

	self = [super init];

	if (!self)
	{
		return nil;
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];

	return self;

}

- (void) dispatchEventForCurrentDevice {

	[self dispatchEventForDevice:[UIDevice currentDevice]];

}

- (void) dispatchEventForDevice:(UIDevice *) device {

	int orientation = 0; // SDL_ORIENTATION_UNKNOWN

	switch (device.orientation) {

		case UIDeviceOrientationLandscapeLeft:

			orientation = 1; // SDL_ORIENTATION_LANDSCAPE
			break;

		case UIDeviceOrientationLandscapeRight:

			orientation = 2; // SDL_ORIENTATION_LANDSCAPE_FLIPPED
			break;

		case UIDeviceOrientationPortrait:

			orientation = 3; // SDL_ORIENTATION_PORTRAIT
			break;

		case UIDeviceOrientationPortraitUpsideDown:

			orientation = 4; // SDL_ORIENTATION_PORTRAIT_FLIPPED
			break;

		default:

			break;
	};

	lime::OrientationEvent event;
	event.orientation = orientation;
	event.display = -1;
	event.type = lime::DEVICE_ORIENTATION_CHANGE;
	lime::OrientationEvent::Dispatch(&event);

}

- (void) orientationChanged:(NSNotification *) notification {

	[self dispatchEventForDevice:notification.object];

}
@end
#endif

namespace lime {

	OrientationObserver* orientationObserver;

	void System::GCEnterBlocking () {

		// if (!_isHL) {

			gc_enter_blocking ();

		// }

	}


	void System::GCExitBlocking () {

		// if (!_isHL) {

			gc_exit_blocking ();

		// }

	}


	int System::GetDeviceOrientation () {

		UIDevice * device = [UIDevice currentDevice];

		int orientation = 0; // SDL_ORIENTATION_UNKNOWN
		switch (device.orientation)
		{

			case UIDeviceOrientationLandscapeLeft:

				orientation = 1; // SDL_ORIENTATION_LANDSCAPE
				break;

			case UIDeviceOrientationLandscapeRight:

				orientation = 2; // SDL_ORIENTATION_LANDSCAPE_FLIPPED
				break;

			case UIDeviceOrientationPortrait:

				orientation = 3; // SDL_ORIENTATION_PORTRAIT
				break;

			case UIDeviceOrientationPortraitUpsideDown:

				orientation = 4; // SDL_ORIENTATION_PORTRAIT_FLIPPED
				break;

			default:

				break;
		};

		return orientation;

	}


	char* System::GetDeviceModel () {

		#ifdef IPHONE
		struct utsname systemInfo;
		uname (&systemInfo);
		return systemInfo.machine;
		#else
		return NULL;
		#endif

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

		#ifdef IPHONE
		return [[[UIDevice currentDevice] systemVersion] UTF8String];
		#else
		return NULL;
		#endif

	}


	void System::EnableDeviceOrientationChange (bool enable) {

		#ifdef IPHONE
		if (enable && !orientationObserver)
		{

			orientationObserver = [[OrientationObserver alloc] init];
			// SDL forces dispatch of a display orientation event immediately.
			// for consistency, we should dispatch one for device orientation.
			[orientationObserver dispatchEventForCurrentDevice];

		}
		else if (!enable && orientationObserver)
		{

			orientationObserver = nil;

		}
		#endif

	}


}