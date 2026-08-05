#import <AudioToolbox/AudioToolbox.h>
#include <ui/Haptic.h>

namespace lime
{

void Haptic::Vibrate(int period, int duration)
{
	AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

} // namespace lime