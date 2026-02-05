#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include <ui/Gesture.h>
#include <SDL.h>
#include <SDL_syswm.h>

static GestureCallbacks gGestureCallbacksCopy = {};
static GestureCallbacks* gGestureCallbacks = nullptr;

@interface CallbackHandler : NSObject

@property (strong, nonatomic) NSView* view;
@property (strong, nonatomic) NSMagnificationGestureRecognizer* magnificationGestureRecognizer;
@property (strong, nonatomic) NSRotationGestureRecognizer* rotationGestureRecognizer;
@property (strong, nonatomic) NSPanGestureRecognizer* panGestureRecognizer;

+ (instancetype)sharedInstance;
+ (ObjcPoint)toCPoint:(CGPoint)objcPoint;
- (void)initCallbacks:(NSView *)view;
- (void)handleMagnificationGesture:(NSMagnificationGestureRecognizer *)gestureRecognizer;
- (void)handleRotationGesture:(NSRotationGestureRecognizer *)gestureRecognizer;
- (void)handlePanGesture:(NSPanGestureRecognizer *)gestureRecognizer;

@end

@implementation CallbackHandler

+ (ObjcPoint)toCPoint:(CGPoint)objcPoint
{
    ObjcPoint cPoint = { objcPoint.x, objcPoint.y };
    return cPoint;
}

- (void)handleRotationGesture:(NSRotationGestureRecognizer *)gestureRecognizer
{
    NSPoint gestPoint = [gestureRecognizer locationInView:self.view];
    gestPoint.y = self.view.frame.size.height - gestPoint.y;

    gGestureCallbacks->onRotationEvent((GestureRecognizerState)[gestureRecognizer state],
                                       gestureRecognizer.rotation,
                                       [CallbackHandler toCPoint:gestPoint]);
}

- (void)handleMagnificationGesture:(NSMagnificationGestureRecognizer *)gestureRecognizer
{
    NSPoint gestPoint = [gestureRecognizer locationInView:self.view];
    gestPoint.y = self.view.frame.size.height - gestPoint.y;

    gGestureCallbacks->onMagnificationEvent((GestureRecognizerState)[gestureRecognizer state],
                                            gestureRecognizer.magnification,
                                            [CallbackHandler toCPoint:gestPoint]);
}

- (void)handlePanGesture:(NSPanGestureRecognizer *)gestureRecognizer
{
    NSPoint gestPoint = [gestureRecognizer locationInView:self.view];
    gestPoint.y = self.view.frame.size.height - gestPoint.y;

    ObjcPoint translationInView = [CallbackHandler toCPoint:[gestureRecognizer translationInView:self.view]];
    ObjcPoint velocityInView = [CallbackHandler toCPoint:[gestureRecognizer velocityInView:self.view]];

    translationInView.y *= -1;

    gGestureCallbacks->onPanEvent((GestureRecognizerState)[gestureRecognizer state],
                                  translationInView,
                                  velocityInView,
                                  [CallbackHandler toCPoint:gestPoint]);
}

- (void)initCallbacks:(NSView *)view
{
    self.view = view;

    self.rotationGestureRecognizer = [[NSRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    [self.view addGestureRecognizer:self.rotationGestureRecognizer];

    self.magnificationGestureRecognizer = [[NSMagnificationGestureRecognizer alloc] initWithTarget:self action:@selector(handleMagnificationGesture:)];
    [self.view addGestureRecognizer:self.magnificationGestureRecognizer];

    self.panGestureRecognizer = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)dealloc
{
    [self.view removeGestureRecognizer:self.rotationGestureRecognizer];
    [self.view removeGestureRecognizer:self.magnificationGestureRecognizer];
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
    [super dealloc];
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
    void Gesture::RegisterCallback(const GestureCallbacks* callbacks, SDL_Window* window)
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
            [handler initCallbacks:view];
        }
        else
        {
            NSLog(@"Unable to initialize gestures: wrong sdl window");
        }

    }
}
