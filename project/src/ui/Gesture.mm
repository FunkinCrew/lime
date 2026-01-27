#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#ifdef LIME_SDL
#include "../backend/sdl/SDLWindow.h"
#endif
#include <events/GestureEvent.h>
#include <ui/Gesture.h>
#include <SDL3/SDL.h>


static inline lime::GestureState ToGestureState (NSGestureRecognizerState state) {

	switch (state) {

		case NSGestureRecognizerStateBegan: return lime::GESTURE_START;
		case NSGestureRecognizerStateChanged: return lime::GESTURE_MOVE;
		case NSGestureRecognizerStateEnded: return lime::GESTURE_END;
		case NSGestureRecognizerStateCancelled: return lime::GESTURE_CANCEL;

		case NSGestureRecognizerStatePossible:
		case NSGestureRecognizerStateFailed:
		default: return lime::GESTURE_END;

	}

}

static inline lime::GestureState ToGestureStateFromNSEvent (NSEventPhase state) {

    switch (state) {

        case NSEventPhaseBegan: return lime::GESTURE_START;
        case NSEventPhaseStationary:
        case NSEventPhaseChanged: return lime::GESTURE_MOVE;
        case NSEventPhaseEnded: return lime::GESTURE_END;
        case NSEventPhaseCancelled: return lime::GESTURE_CANCEL;

        case NSEventPhaseMayBegin:
        case NSEventPhaseNone:
        case NSGestureRecognizerStateFailed:
        default: return lime::GESTURE_END;

    }

}


static inline NSPoint ToLimePoint (NSView* view, NSGestureRecognizer* gr) {

	NSPoint p = [gr locationInView:view];
	p.y = view.frame.size.height - p.y;
	return p;

}


@interface GestureHandler : NSResponder <NSGestureRecognizerDelegate>

@property (strong, nonatomic) NSView* view;
@property (strong, nonatomic) NSMagnificationGestureRecognizer* magnificationGestureRecognizer;
@property (strong, nonatomic) NSRotationGestureRecognizer* rotationGestureRecognizer;
@property (strong, nonatomic) NSPanGestureRecognizer* panGestureRecognizer;

+ (instancetype)sharedInstance;
- (void)setupWithView:(NSView *)view;
- (void)handleMagnificationGesture:(NSMagnificationGestureRecognizer *)gr;
- (void)handleRotationGesture:(NSRotationGestureRecognizer *)gr;
- (void)handlePanGesture:(NSPanGestureRecognizer *)gr;

@end


@implementation GestureHandler


+ (instancetype)sharedInstance {

	static GestureHandler* instance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{

		instance = [[GestureHandler alloc] init];

	});

	return instance;

}


- (void)setupWithView:(NSView *)view {

	self.view = view;

	self.rotationGestureRecognizer = [[NSRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
	self.rotationGestureRecognizer.delegate = self;
	[self.view addGestureRecognizer:self.rotationGestureRecognizer];

	self.magnificationGestureRecognizer = [[NSMagnificationGestureRecognizer alloc] initWithTarget:self action:@selector(handleMagnificationGesture:)];
	self.magnificationGestureRecognizer.delegate = self;
	[self.view addGestureRecognizer:self.magnificationGestureRecognizer];

	self.panGestureRecognizer = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	self.panGestureRecognizer.buttonMask = 0x2;
	self.panGestureRecognizer.delegate = self;
	[self.view addGestureRecognizer:self.panGestureRecognizer];

	NSResponder* old = self.view.nextResponder;
    self.view.nextResponder = self;
    self.nextResponder = old;

}


- (void)handleRotationGesture:(NSRotationGestureRecognizer *)gr {

	NSPoint location = ToLimePoint (self.view, gr);

	lime::GestureEvent gestureEvent;
	gestureEvent.x = location.x;
	gestureEvent.y = location.y;
	gestureEvent.state = ToGestureState (gr.state);
	gestureEvent.rotation = gr.rotation;
	lime::GestureEvent::Dispatch (&gestureEvent);

}


- (void)handleMagnificationGesture:(NSMagnificationGestureRecognizer *)gr {

	NSPoint location = ToLimePoint (self.view, gr);

	lime::GestureEvent gestureEvent;
	gestureEvent.x = location.x;
	gestureEvent.y = location.y;
	gestureEvent.state = ToGestureState (gr.state);
	gestureEvent.magnification = gr.magnification;
	lime::GestureEvent::Dispatch (&gestureEvent);

}


- (void)handlePanGesture:(NSPanGestureRecognizer *)gr {

	NSPoint location = ToLimePoint (self.view, gr);
	NSPoint translation = [gr translationInView:self.view];
	NSPoint velocity = [gr velocityInView:self.view];

	translation.y *= -1;
	velocity.y *= -1;

	lime::GestureEvent gestureEvent;
	gestureEvent.x = location.x;
	gestureEvent.y = location.y;
	gestureEvent.state = ToGestureState (gr.state);
	gestureEvent.panTranslationX = translation.x;
	gestureEvent.panTranslationY = translation.y;
	gestureEvent.panVelocityX = velocity.x;
	gestureEvent.panVelocityY = velocity.y;
	lime::GestureEvent::Dispatch (&gestureEvent);

}


- (void)scrollWheel:(NSEvent *)event {

    if (![event hasPreciseScrollingDeltas])
    {
        return;
    }

    if ([event phase] != NSEventPhaseNone)
    {
        lime::GestureState phaseState = ToGestureStateFromNSEvent ([event phase]);
        lime::GestureEvent gestureEvent;
        gestureEvent.scrollX = [event scrollingDeltaX];
        gestureEvent.scrollY = [event scrollingDeltaY];
        gestureEvent.state = phaseState;
        lime::GestureEvent::Dispatch (&gestureEvent);
    }

    if ([event momentumPhase] != NSEventPhaseNone)
    {
        lime::GestureState momentumPhaseState = ToGestureStateFromNSEvent ([event momentumPhase]);
        lime::GestureEvent gestureEvent;
        gestureEvent.momentumScrollX = [event scrollingDeltaX];
        gestureEvent.momentumScrollY = [event scrollingDeltaY];
        gestureEvent.state = momentumPhaseState;
        lime::GestureEvent::Dispatch (&gestureEvent);
    }

}

- (BOOL)gestureRecognizer:(NSGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(NSGestureRecognizer *)otherGestureRecognizer {

	return NO;

}


- (void)dealloc {

	[self.view removeGestureRecognizer:self.rotationGestureRecognizer];
	[self.view removeGestureRecognizer:self.magnificationGestureRecognizer];
	[self.view removeGestureRecognizer:self.panGestureRecognizer];
	self.view.nextResponder = self.nextResponder;
	self.nextResponder = nil;

}


@end


namespace lime {


	void Gesture::Register (Window* window) {

        SDL_Window *sdlWindow = window ? static_cast<SDLWindow*> (window)->sdlWindow : nullptr;

        if (!sdlWindow) {

            return;

        }

		NSWindow *nswindow = (__bridge NSWindow *)SDL_GetPointerProperty (SDL_GetWindowProperties (sdlWindow), SDL_PROP_WINDOW_COCOA_WINDOW_POINTER, NULL);

		if (nswindow) {

			[[GestureHandler sharedInstance] setupWithView:[nswindow contentView]];

		} else {

			NSLog (@"Unable to initialize gestures: wrong sdl window");

		}

	}


}
