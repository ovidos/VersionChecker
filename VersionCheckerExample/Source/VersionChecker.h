//
//  VersionChecker.h
//  VersionChecker
//
//  Created by Kemal Kocabiyik on 06/04/16.
//  Copyright © 2016 Ovidos Creative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionCheckerParser.h"
#import "VersionCheckerConfiguration.h"
#import "VersionCheckerDefaultParser.h"

@class VersionChecker;
@protocol VersionCheckerDelegate <NSObject>

@optional
-(void) versionCheckerDidLaunchAppStore;
-(void) versionCheckerDidClickDownloadLater;
@end

@interface VersionChecker : NSObject

@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *remoteUrl;
@property (strong, nonatomic) id<VersionCheckerParser> parser;
@property (strong, nonatomic) id<VersionCheckerDelegate> delegate;
@property (strong, nonatomic) NSDate *lastVersionCheckPerformedOnDate;

+ (VersionChecker *)sharedInstance;

-(void) checkNewVersion;
@end
