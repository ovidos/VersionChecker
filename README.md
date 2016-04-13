# VersionChecker
VersionChecker is a simple iOS library that you can check your application versions with remote configuration and force or notifies your users to update their apps.

# What does VersionChecker do?

VersionChecker is a simple and ready to use version checker library with just 2 lines. There are pretty good familiar libraries out there however most of it not working remotely. We have created VersionChecker in order to configure your "Update" notification to your users even when your application is on the app store. 

# What doesn't VersionChecker do?

VersionChecker **will not be** working locally. In addition to this your application should have an internet connection. Therefore, the apps that are working without internet connection does not need to use VersionChecker.

# Available Platforms

VersionChecker is now only on iOS but will be on Android and Windows Phone devices soon. 

# Installation

You may download the source code and copy the files in the Source folder and you are ready to go.

We will put VersionChecker to CocoaPods soon.

# Usage

First of all create a json file and put it to remote. There is a default parser working with the json below.

```
{  
    "alertType": 1,
    "title": "Deneme Title",
    "versionNumber": "0.0.50",
    "versionDescription": "Loong loooooong description."
}
```

There are 3 types of alert defined in VersionChecker. The first one forces user to update and does not show skip button. The second one prompts an alert with download now and download later button. And the last one does not show any alert. Why did we put the 3rd one? Because you may want to cancel your alert prompt for update :)

```
typedef NS_ENUM(NSUInteger, VersionCheckerAlertType)
{
    VersionCheckerAlertTypeForce = 1,
    VersionCheckerAlertTypeOption = 2,
    VersionCheckerAlertTypeNone = 3
};
```

Instantiate VersionChecker instance in didFinishLaunchingWithOptions just like below.

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [VersionChecker sharedInstance].remoteUrl = @"remotefileurl";
    [VersionChecker sharedInstance].appId = @"yourapplicationid";
    [[VersionChecker sharedInstance] checkNewVersion];

    // Override point for customization after application launch.
    return YES;
}
```

And voila! You are ready to go.

# Changing the Parser

Sometimes, you may need a different parser for different needs. VersionChecker gives you a flexibility by changing the parser. What you need to do is to create a new interface and implement the 'VersionCheckerParser' 

```

@interface VersionCheckerDifferentParser : NSObject <VersionCheckerParser>

@end


@implementation VersionCheckerDifferentParser

-(VersionCheckerConfiguration *)versionCheckerParser:(NSDictionary *)dictionary{

    VersionCheckerConfiguration *versionCheckerConfiguration = [VersionCheckerConfiguration new];
    versionCheckerConfiguration.alertType = (VersionCheckerAlertType) [dictionary[@"ios"][@"alert"] intValue];
    versionCheckerConfiguration.title = (NSString *) dictionary[@"ios"][@"title"];
    versionCheckerConfiguration.versionDescription = (NSString *) dictionary[@"ios"][@"vDesc"];
    versionCheckerConfiguration.versionNumber = (NSString *) dictionary[@"versionNumber"];

    return versionCheckerConfiguration;
}
@end

```

The parser above is just a sample. The dictionary will contain all of your JSON file provided by remote url.

The last step is to set your parser to VersionChecker. Go back to AppDelegate and add below.

```
 [VersionChecker sharedInstance].parser = [VersionCheckerDifferentParser new];
```

That's all!.


# TO-DO

* Show periodically when the user open the app # times.

