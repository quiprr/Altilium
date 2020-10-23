#import "Altilium.h"

// Reusable way to read preferences in one line
id readPreferenceValue(id key, id fallback)
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/dev.quiprr.Altilium.plist"];
    id value = [dict valueForKey:key] ? [dict valueForKey:key] : fallback; // This allows for a fallback value if the plist doesn't exist/doesn't have the value it's looking for
    NSLog(@"Altilium: readPreferenceValue: key: %@ value: %@", key, value);
    return value;
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)args
{
    %orig;
    NSLog(@"Altilium: viewDidLoad");

    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    id enabled = readPreferenceValue(@"enableTweak", @"YES");

    if (enabled)
    {
        NSLog(@"Altilium: enabled");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChanged) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    }
}

%new

- (void)batteryLevelChanged
{
    NSLog(@"Altilium: batteryLevelChanged");

    float batteryLevel = [UIDevice currentDevice].batteryLevel * 100;
    NSInteger btryLvl = batteryLevel;

    // NSNumber *notiPercent = [[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/dev.quiprr.Altilium.plist"] objectForKey:@"notiPercent"];
    id notiPercent = readPreferenceValue(@"notiPercent", @"5");
    double putIntoIfStatement = [notiPercent doubleValue];

    if (btryLvl == putIntoIfStatement)
    {
        if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged)
        {
            NSLog(@"Altilium: UIDeviceBatteryStateUnplugged");

            id alertText = readPreferenceValue(@"alertText", @"battery remaining.");
            id putPercentAtEnd = readPreferenceValue(@"putPercentAtEnd", @"NO");
            BOOL putPercentAtEndd = [putPercentAtEnd boolValue];
            NSString *message = (putPercentAtEndd) ? [NSString stringWithFormat:@"%@ %ld%%.", alertText, btryLvl] : [NSString stringWithFormat:@"%ld%% %@", btryLvl, alertText];

            NSLog(@"Altilium: btrylvl: %ld, putIntoIfStatement: %f", btryLvl, putIntoIfStatement);
            NSLog(@"Altilium: alert");

            UIWindow *keyWindow = nil;
            for (UIWindow *window in [[UIApplication sharedApplication] windows])
            {
                if (window.isKeyWindow)
                {
                    keyWindow = window;
                    break;
                }
            }

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Low Battery"
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                handler:nil];

            [alert addAction:defaultAction];
            [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
}

%end