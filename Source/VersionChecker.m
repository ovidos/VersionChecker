//
//  VersionChecker.m
//  VersionChecker
//
//  Created by Kemal Kocabiyik on 06/04/16.
//  Copyright © 2016 Ovidos Creative. All rights reserved.
//

#import "VersionChecker.h"

NSString * const VersionCheckerDefaultStoredVersionCheckDate = @"VersionCheckerDefaultStoredVersionCheckDate";

@implementation VersionChecker
{

    VersionCheckerAlertType _alertType;
    NSDictionary *_fetchedData;
    VersionCheckerConfiguration *_configuration;
    UIAlertController *_alertController;
}


+ (VersionChecker *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _parser = [[VersionCheckerDefaultParser alloc] init];
    }
    return self;
}

//private methods

-(void) updateLastPerformCheck{

    self.lastVersionCheckPerformedOnDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastVersionCheckPerformedOnDate forKey:VersionCheckerDefaultStoredVersionCheckDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(bool) shouldShowPopupForVersion:(NSString *) version{

    [self updateLastPerformCheck];

    NSString *currentVersion = [self currentVersion];
    if ([currentVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
}

-(void) presentAlertController:(UIAlertController *) alertController{

   UIWindow *window = [[UIApplication sharedApplication] keyWindow];

    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(UIAlertController *) createAlertControllerForAlertType:(VersionCheckerAlertType) alertType{

    if(alertType != VersionCheckerAlertTypeNone){

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_configuration.title message:_configuration.versionDescription preferredStyle:UIAlertControllerStyleAlert];
        if(alertType == VersionCheckerAlertTypeForce){

            [alertController addAction:[self createDownloadNowButton]];
            return alertController;
        }

        if(alertType == VersionCheckerAlertTypeOption){

            [alertController addAction:[self createDownloadLaterButton]];
            [alertController addAction:[self createDownloadNowButton]];
        }

        return alertController;
    }

    return nil;

}

-(NSString *) currentVersion{

    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

}

-(void) promptVersionAlertForConfiguration:(VersionCheckerConfiguration *) configuration {

    if([self shouldShowPopupForVersion:configuration.versionNumber]){
        _alertController = [self createAlertControllerForAlertType:_alertType];

        if(_alertController){
            [self presentAlertController:_alertController];
        }
    }

}

#pragma mark - Buttons

-(UIAlertAction *) createDownloadNowButton{

    UIAlertAction *downloadNowButton = [UIAlertAction actionWithTitle:@"Şimdi Yükle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self launchAppStore];
    }];

    return downloadNowButton;

}

-(UIAlertAction *) createDownloadLaterButton{

    UIAlertAction *downloadLaterButton = [UIAlertAction actionWithTitle:@"Daha Sonra Yükle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if( self.delegate && [self.delegate respondsToSelector:@selector(versionCheckerDidLaunchAppStore)]){
            [self.delegate versionCheckerDidClickDownloadLater];
        }

        [_alertController dismissViewControllerAnimated:YES completion:nil];
    }];

    return downloadLaterButton;
    
}


#pragma mark - Events

-(void) launchAppStore{

    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", self.appId];
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
    [[UIApplication sharedApplication] openURL:iTunesURL];

    if( self.delegate && [self.delegate respondsToSelector:@selector(versionCheckerDidLaunchAppStore)]){
        [self.delegate versionCheckerDidLaunchAppStore];
    }

}
//public methods
-(void) checkNewVersion{

    if(!self.appId || [self.appId isEqualToString:@""]){
        @throw [[NSException alloc] initWithName:@"Enter App Id" reason:@"You should enter App Id" userInfo:nil];
    }

    if(!self.remoteUrl || [self.remoteUrl isEqualToString:@""]){
        @throw [[NSException alloc] initWithName:@"Enter Remote Url" reason:@"You should enter Remote Url" userInfo:nil];
    }

    if(!_parser){
        @throw [[NSException alloc] initWithName:@"Parser can't be null" reason:@"Parser shouldn't be null" userInfo:nil];
    }

    NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:self.remoteUrl]];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if ([data length] > 0 && !error) {

                                                    NSError *error;
                                                    _fetchedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

                                                    if(error){

                                                    }
                                                    _configuration = [self.parser versionCheckerParser:_fetchedData];

                                                    _alertType = _configuration.alertType > 3 || _configuration.alertType < 1 ? VersionCheckerAlertTypeNone : _configuration.alertType;

                                                    dispatch_async(dispatch_get_main_queue(), ^{

                                                        [self promptVersionAlertForConfiguration:_configuration];
                                                        
                                                    });
                                                }else{
                                                    NSLog(@"%@" , error);
                                                }
                                            }];
    [task resume];
}



@end
