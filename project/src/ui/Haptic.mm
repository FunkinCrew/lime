#include <ui/Haptic.h>

#import <CoreHaptics/CoreHaptics.h>
#import <AudioToolbox/AudioToolbox.h>

namespace lime {
	static CHHapticEngine* hapticEngine = nullptr;

	void InitializeHapticEngine() {
		if (@available(iOS 13.0, *)) {
			if (!hapticEngine) {
				NSError* error = nil;

				hapticEngine = [[CHHapticEngine alloc] initAndReturnError:&error];

				if (error) {
					NSLog(@"Error creating haptic engine: %@", error);
					hapticEngine = nullptr;
				} else {
					if (![hapticEngine startAndReturnError:&error]) {
						NSLog(@"Error starting haptic engine: %@", error);
						hapticEngine = nullptr;
					}
				}
			}
		}
	}

	void Haptic::Vibrate (int period, int duration, double amplitude) {
		if (@available(iOS 13.0, *)) {
			InitializeHapticEngine();

			if (hapticEngine) {
				NSError* error = nil;

				CHHapticEventParameter* intensityParam = 
					[[CHHapticEventParameter alloc] initWithParameterID:CHHapticEventParameterIDHapticIntensity value:(float)amplitude];
				CHHapticEventParameter* sharpnessParam = 
					[[CHHapticEventParameter alloc] initWithParameterID:CHHapticEventParameterIDHapticSharpness value:0.5];

				CHHapticEvent* hapticEvent = 
					[[CHHapticEvent alloc] initWithEventType:CHHapticEventTypeHapticContinuous 
												   parameters:@[intensityParam, sharpnessParam] 
												  relativeTime:0 
													   duration:(float)duration / 1000];


				CHHapticPattern* pattern = [[CHHapticPattern alloc] initWithEvents:@[hapticEvent] 
																	 parameterCurves:@[] 
																			 error:&error];
				if (error) {
					NSLog(@"Error creating haptic pattern: %@", error);
					return;
				}

				id<CHHapticPatternPlayer> player = [hapticEngine createPlayerWithPattern:pattern error:&error];
				if (error) {
					NSLog(@"Error creating haptic pattern player: %@", error);
					return;
				}

				[player startAtTime:0 error:&error];
				if (error) {
					NSLog(@"Error starting haptic pattern player: %@", error);
				}
			}
		} else {
			AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
		}
	}
}
