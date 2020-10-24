#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SLBDevPageController.h"

@implementation SLBDevPageController

- (NSMutableArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Developer" target:self];
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

- (void)openGitHub
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/quiprr/Altilium"] options:@{} completionHandler:nil];
}

- (void)openTwitter
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/quiprr"] options:@{} completionHandler:nil];
}

- (void)openWebsite
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://quiprr.dev/"] options:@{} completionHandler:nil];
}

- (void)openReddit
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://reddit.com/u/quiprr"] options:@{} completionHandler:nil];
}

- (void)openPayPal
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/quiprr"] options:@{} completionHandler:nil];
}

- (void)openDiscord
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://discord.gg/MA7NQJd"] options:@{} completionHandler:nil];
}

- (void)specialThanks
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Special Thanks"
                           message:@"@CaptInc - help with the tweak\n@kritanta - DragonBuild"
                           preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                               handler:nil];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
}

@end