#import <UIKit/UIKit.h>
#import "../../lib/sdl/src/video/uikit/SDL_uikitviewcontroller.h"
#import "../../lib/sdl/src/video/uikit/SDL_uikitwindow.h"
#include "SDL_video.h"
#include "SDL.h"

@interface LimeUIKitViewController : SDL_uikitviewcontroller

+ (void)setViewControllerForWindow:(SDL_Window *)window;
#if !TARGET_OS_TV
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures;
- (BOOL)prefersHomeIndicatorAutoHidden;
#endif

@end
