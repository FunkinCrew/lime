#import <UIKit/UIKit.h>
#import "../../lib/sdl/src/video/uikit/SDL_uikitviewcontroller.h"
#include "SDL_video.h"

@interface LimeUIKitViewController : SDL_uikitviewcontroller

+ (void)setViewControllerForWindow:(SDL_Window *)window;
#if !TARGET_OS_TV
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures;
- (BOOL)prefersHomeIndicatorAutoHidden;
#endif

@end
