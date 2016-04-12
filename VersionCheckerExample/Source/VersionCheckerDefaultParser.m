//
//  VersionCheckerDefaultParser.m
//  VersionChecker
//
//  Created by Kemal Kocabiyik on 06/04/16.
//  Copyright © 2016 Ovidos Creative. All rights reserved.
//

#import "VersionCheckerDefaultParser.h"

@implementation VersionCheckerDefaultParser

-(VersionCheckerConfiguration *)versionCheckerParser:(NSDictionary *)dictionary{

    VersionCheckerConfiguration *versionCheckerConfiguration = [VersionCheckerConfiguration new];
    versionCheckerConfiguration.alertType = (VersionCheckerAlertType) [dictionary[@"alertType"] intValue];
    versionCheckerConfiguration.title = (NSString *) dictionary[@"title"];
    versionCheckerConfiguration.versionDescription = (NSString *) dictionary[@"versionDescription"];
    versionCheckerConfiguration.versionNumber = (NSString *) dictionary[@"versionNumber"];

    return versionCheckerConfiguration;
}
@end
