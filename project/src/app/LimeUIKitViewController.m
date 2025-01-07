#import "app/LimeUIKitViewController.h"

@implementation LimeUIKitViewController

+ (void)setViewControllerForWindow:(SDL_Window *)window {
    #if !TARGET_OS_TV
    if (!window || !window->driverdata) {
      return;
    }

    SDL_WindowData *data = (__bridge SDL_WindowData *)window->driverdata;
    data.viewcontroller = [[LimeUIKitViewController alloc] init];
    #endif
}

#if !TARGET_OS_TV
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    if (self.homeIndicatorHidden == 3)
    {
      return UIRectEdgeBottom;
    }

    return [super preferredScreenEdgesDeferringSystemGestures];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    if (self.homeIndicatorHidden == 3)
    {
      return YES;
    }

    return [super prefersHomeIndicatorAutoHidden];
};
#endif

@end
