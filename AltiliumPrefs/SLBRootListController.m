#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SLBRootListController.h"
#import "NSTask.h"

@implementation SLBRootListController

- (NSMutableArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/dev.quiprr.Altilium.plist"];
    id object = [dict objectForKey:[specifier propertyForKey:@"key"]];
    if (!object) {
        object = [specifier propertyForKey:@"default"];
    }
    return object;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/dev.quiprr.Altilium.plist"];
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    [dict setObject:value forKey:[specifier propertyForKey:@"key"]];
    [dict writeToFile:@"/var/mobile/Library/Preferences/dev.quiprr.Altilium.plist" atomically:YES];
}

-(void)sbreload
{
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Altilium"
							message:@"Your settings have been applied.\n Would you like to respring now?"
							preferredStyle:UIAlertControllerStyleActionSheet];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction * action) {}];
		UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive
		handler:^(UIAlertAction * action) {
			NSTask *t = [[NSTask alloc] init];
			[t setLaunchPath:@"usr/bin/sbreload"];
			[t launch];
		}];

		[alert addAction:defaultAction];
		[alert addAction:yes];
		[self presentViewController:alert animated:YES completion:nil];

}

@end