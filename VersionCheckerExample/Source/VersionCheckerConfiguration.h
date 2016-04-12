//
//  VersionCheckerConfiguration.h
//  VersionChecker
//
//  Created by Kemal Kocabiyik on 06/04/16.
//  Copyright © 2016 Ovidos Creative. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, VersionCheckerAlertType)
{
    VersionCheckerAlertTypeForce = 1,
    VersionCheckerAlertTypeOption,
    VersionCheckerAlertTypeNone
};


@interface VersionCheckerConfiguration : NSObject

@property (nonatomic) VersionCheckerAlertType alertType;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *versionNumber;
@property (strong, nonatomic) NSString *versionDescription;

@end
