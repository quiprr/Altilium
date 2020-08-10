#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SBIconController : UIViewController
- (void)batteryLevelChanged;
@end

NSDictionary *rootDict;

%hook SBIconController

- (void)viewDidLoad {
    %orig;

    rootDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/dev.quiprr.Altilium.plist"];
    BOOL shouldEnableSLB = [[rootDict objectForKey:@"enableTweak"] boolValue];
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;

    if (shouldEnableSLB) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(batteryLevelChanged)
                                                     name:UIDeviceBatteryLevelDidChangeNotification
                                                   object:nil];
    }
}

%new

- (void)batteryLevelChanged {
    float batteryLevel = [UIDevice currentDevice].batteryLevel * 100;
    NSInteger btryLvl = batteryLevel;

    NSNumber *notiPercent = [rootDict objectForKey:@"notiPercent"];
    double putIntoIfStatement = [notiPercent doubleValue];
    NSString *message = [NSString stringWithFormat:@"%d%% battery remaining.", btryLvl];

    if (btryLvl == putIntoIfStatement) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Low Battery"
                            message:message
                            preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                            handler:nil];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

%end