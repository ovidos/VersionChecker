//
//  VersionCheckerParser.h
//  VersionChecker
//
//  Created by Kemal Kocabiyik on 06/04/16.
//  Copyright © 2016 Ovidos Creative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionCheckerConfiguration.h"

@protocol VersionCheckerParser <NSObject>

@required
-(VersionCheckerConfiguration *) versionCheckerParser:(NSDictionary *) dictionary;
@end
