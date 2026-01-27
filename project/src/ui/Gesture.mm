#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include <ui/Gesture.h>
#include <SDL.h>
#include <SDL_syswm.h>

static GestureCallbacks gGestureCallbacksCopy = {};
static GestureCallbacks* gGestureCallbacks = nullptr;

@interface CallbackHandler : NSObject

@property (strong, nonatomic) NSView* view;

+ (instancetype)sharedInstance;
- (void)handleMagGesture:(NSMagnificationGestureRecognizer *)gestureRecognizer;
- (void)handleRotationGesture:(NSRotationGestureRecognizer *)gestureRecognizer;

@end

@implementation CallbackHandler


- (void)handleRotationGesture:(NSRotationGestureRecognizer *)gestureRecognizer
{
        // NSLog(@"csssssdvd");
        NSPoint gestPoint = [gestureRecognizer locationInView:self.view];

// dispatch_sync(dispatch_get_main_queue(), ^
// 		{
    gGestureCallbacks->onRotEvent(gestureRecognizer.rotation, (int)[gestureRecognizer state], gestPoint.x, gestPoint.y);
        // });
}

- (void)handleMagGesture:(NSMagnificationGestureRecognizer *)gestureRecognizer
{
        // NSLog(@"caaaadvd");
        NSPoint gestPoint = [gestureRecognizer locationInView:self.view];

// dispatch_sync(dispatch_get_main_queue(), ^
// 		{
    gGestureCallbacks->onMagEvent(gestureRecognizer.magnification, (int)[gestureRecognizer state], gestPoint.x, gestPoint.y);
    // });
}

+ (instancetype)sharedInstance {
    static CallbackHandler *sharedInstance = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[CallbackHandler alloc] init];
    });

    return sharedInstance;
}

@end

namespace lime
{
    // move all to callbackhandler?
    void RegisterCallback(const GestureCallbacks* callbacks, SDL_Window* window)
    {
       if (callbacks)
           gGestureCallbacksCopy = (*callbacks);

       gGestureCallbacks = &gGestureCallbacksCopy;

        SDL_SysWMinfo wmInfo;

        SDL_VERSION(&wmInfo.version);

        if (SDL_GetWindowWMInfo(window, &wmInfo))
        {
            NSView* view = [wmInfo.info.cocoa.window contentView];
            CallbackHandler* handler = [CallbackHandler sharedInstance];
            handler.view = view;
            [view addGestureRecognizer:[[NSRotationGestureRecognizer alloc] initWithTarget:handler action:@selector(handleRotationGesture:)]];
            [view addGestureRecognizer:[[NSMagnificationGestureRecognizer alloc] initWithTarget:handler action:@selector(handleMagGesture:)]];
        }
        else
        {
            NSLog(@"%p rip", SDL_GL_GetCurrentWindow());
        }

        // NSWindow* keyWindow = [[NSApplication sharedApplication] keyWindow];

        // NSLog(@"%p", keyWindow);

        // if (keyWindow)
        // {
        // NSLog(@"cdvd");

        //     NSView* view = [keyWindow contentView];

        //     CallbackHandler* ch = [CallbackHandler sharedInstance];

        //     NSLog(@"%p", ch);

        //     [view addGestureRecognizer:[[NSRotationGestureRecognizer alloc] initWithTarget:ch action:@selector(handleRotationGesture:)]];

        //     [view addGestureRecognizer:[[NSMagnificationGestureRecognizer alloc] initWithTarget:ch action:@selector(handleMagGesture:)]];
        // }

    }



}
