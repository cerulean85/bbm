/* For Qt. */
#include <QtCore>
#include "src/native_app.h"
#include "src/settings.h"

#include "UIKit/UIKit.h"
#import "UserNotifications/UserNotifications.h"
#import "AudioToolBox/AudioToolBox.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <AVFoundation/AVFoundation.h>
#import <netinet/in.h>
#import <sys/utsname.h>

/* Kakao & Facebook SDK. */
#import "KakaoOpenSDK/KakaoOpenSDK.h"
#import <KakaoLink/KakaoLink.h>
#import <KakaoMessageTemplate/KakaoMessageTemplate.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

/* For Security. */
#import "RSA.h"

#define isOSVersionOver10 ([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] integerValue] >= 10)

@interface SDKTask : NSObject
-(void)fetchFacebookUserInfo;
-(void)fetchKakaoUserInfo;
-(bool)isNetworkReachable;
@end

@interface QIOSApplicationDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>
@end

@implementation SDKTask
-(void)fetchFacebookUserInfo
{
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, email, picture"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if(result)
        {
            NSString *accessToken = [FBSDKAccessToken currentAccessToken].tokenString;
            
            NSString *uuid = @"";
            if([result objectForKey:@"id"]) uuid = [result objectForKey:@"id"];
            
            NSString *name = @"";
            if([result objectForKey:@"name"]) name = [result objectForKey:@"name"];
            
            NSString *email = @"";
            if([result objectForKey:@"email"]) email = [result objectForKey:@"email"];
            
            NSString *profileImage = @"";
            id picRst = [result objectForKey:@"picture"];
            if(picRst)
            {
                picRst = [picRst objectForKey:@"data"];
                if(picRst) {
                    picRst = [picRst objectForKey:@"url"];
                    if(picRst)
                        profileImage = (NSString*)picRst;
                }
            }
            
            NSNumber *isLogined = @0; /* 1: ...was logined. */
            if([uuid length] > 0) isLogined = @1;
            
            NSDictionary* info = @{
                                   @"id":uuid,
                                   @"access_token": accessToken,
                                   @"is_logined":isLogined,
                                   @"nickname":name,
                                   @"email":email,
                                   @"profile_image":profileImage,
                                   @"thumbnail_image":profileImage
                                   };
            
            NSData *infoObj = [NSJSONSerialization dataWithJSONObject:info options:0 error:nil];
            NSString *infoStr = [[NSString alloc] initWithData:infoObj encoding:NSUTF8StringEncoding];
            
            const char* qresult = [infoStr UTF8String];
            NativeApp* app = NativeApp::getInstance();
            if(!app) return;
            app->notifyLoginResult(true, qresult); /* Notify the login result to Qt the upper class(NativeApp). */
        }
    }];
    [connection start];
}
-(void)fetchKakaoUserInfo
{
    [KOSessionTask meTaskWithCompletionHandler:^(KOUser* result, NSError *error) {
        
        NSString *accessToken = [KOSession sharedSession].accessToken;
        
        NSString *uuid = [result.ID stringValue];
        
        NSString *name = [result propertyForKey:@"nickname"];
        if(name == nil) name = @"";
        
        NSString *email = result.email;
        if(email == nil) email = @"";
        
        NSString *profileImage = [result propertyForKey:@"profile_image"];
        if(profileImage == nil) profileImage = @"";
        
        NSString *thumbnailImage = [result propertyForKey:@"thumbnail.image"];
        if(thumbnailImage == nil) thumbnailImage = @"";
        
        NSNumber *isLogined = @0; /* 1: ...was logined. */
        if([uuid length] > 0) isLogined = @1;
        
        NSDictionary* info = @{
                               @"id":uuid,
                               @"access_token": accessToken,
                               @"is_logined":isLogined,
                               @"nickname":name,
                               @"email":email,
                               @"profile_image":profileImage,
                               @"thumbnail_image":thumbnailImage
                               };
        
        NSData *infoObj = [NSJSONSerialization dataWithJSONObject:info options:0 error:nil];
        NSString *infoStr = [[NSString alloc] initWithData:infoObj encoding:NSUTF8StringEncoding];
        
        const char* qresult = [infoStr UTF8String];
        NativeApp* app = NativeApp::getInstance();
        if(!app) return;
        app->notifyLoginResult(true, qresult); /* Notify the login result to Qt the upper class(NativeApp). */
    }];
}
@end

@implementation QIOSApplicationDelegate

NSString* appState = @"foreground";
QString NativeApp::getDeviceId()
{
    NSString *idForVendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return QString::fromNSString(idForVendor);
}
QString NativeApp::getDeviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];//[UIDevice currentDevice].model;
    
    NSDictionary* deviceNamesByCode = @{@"i386"      : @"Simulator",
                                        @"x86_64"    : @"Simulator",
                                        @"iPod1,1"   : @"iPod Touch",        // (Original)
                                        @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                                        @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                                        @"iPod4,1"   : @"iPod Touch",        //     (Fourth Generation)
                                        @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                                        @"iPhone1,1" : @"iPhone",            // (Original)
                                        @"iPhone1,2" : @"iPhone",            // (3G)
                                        @"iPhone2,1" : @"iPhone",            // (3GS)
                                        @"iPad1,1"   : @"iPad",              // (Original)
                                        @"iPad2,1"   : @"iPad 2",            //
                                        @"iPad3,1"   : @"iPad",              // (3rd Generation)
                                        @"iPhone3,1" : @"iPhone 4",          // (GSM)
                                        @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                                        @"iPhone4,1" : @"iPhone 4S",         //
                                        @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                                        @"iPhone5,2" : @"iPhone 5",          // (model A1429, every
                                        @"iPad2,5"   : @"iPad Mini",         // (Original)
                                        @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                                        @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                                        @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                                        @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                                        @"iPhone7,1" : @"iPhone 6 Plus",     //
                                        @"iPhone7,2" : @"iPhone 6",          //
                                        @"iPhone8,1" : @"iPhone 6S",         //
                                        @"iPhone8,2" : @"iPhone 6S Plus",    //
                                        @"iPhone8,4" : @"iPhone SE",         //
                                        @"iPhone9,1" : @"iPhone 7",          //
                                        @"iPhone9,3" : @"iPhone 7",          //
                                        @"iPhone9,2" : @"iPhone 7 Plus",     //
                                        @"iPhone9,4" : @"iPhone 7 Plus",     //
                                        @"iPhone10,1": @"iPhone 8",          // CDMA
                                        @"iPhone10,4": @"iPhone 8",          // GSM
                                        @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                                        @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                                        @"iPhone10,3": @"iPhone X",          // CDMA
                                        @"iPhone10,6": @"iPhone X",          // GSM
                                        @"iPhone11,2": @"iPhone XS",
                                        @"iPhone11,6": @"iPhone XS Max",
                                        @"iPhone11,8": @"iPhone XR",

                                        
                                        @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                                        @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                                        @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                                        @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                                        @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                                        @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                                        @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                                        @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                                        @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                                        };
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    if (!deviceName) {
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    return QString::fromNSString(deviceName);
}

void NativeApp::joinKakao() { loginKakao(); }
void NativeApp::loginKakao()
{
    [[KOSession sharedSession] close];
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error1) {
        
        
        if([[KOSession sharedSession] isOpen]) {
            [KOSessionTask signupTaskWithProperties:nil
                                  completionHandler:^(BOOL success, NSError *error2) {
                                      if (success) {
                                          SDKTask *sdk = [SDKTask alloc];
                                          [sdk fetchKakaoUserInfo];
                                      } else {
                                          if(error2.code == KOServerErrorAlreadySignedUpUser)
                                          {
                                              SDKTask *sdk = [SDKTask alloc];
                                              [sdk fetchKakaoUserInfo];
                                          }
                                      }
                                  }];
            
        } else {
            notifyLogoutResult(true);
        }
    } authType:(KOAuthType)KOAuthTypeTalk, nil];
}
void NativeApp::withdrawKakao()
{
    [KOSessionTask unlinkTaskWithCompletionHandler:^(BOOL success, NSError *error) {
        if(success) {
            notifyWithdrawResult(true);
        }
    }];
}
void NativeApp::logoutKakao()
{
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            notifyLogoutResult(true);
        }
    }];
}
void NativeApp::loginFacebook()
{
    SDKTask *sdk = [SDKTask alloc];
    if([FBSDKAccessToken currentAccessToken] != nil)
    {
        [sdk fetchFacebookUserInfo];
        return;
    }
    
    UIViewController *qCtrl = [[[UIApplication sharedApplication] keyWindow]rootViewController];
    
    FBSDKLoginManager* login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:qCtrl
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                
                                NSMutableDictionary *info = [NSMutableDictionary dictionary];
                                [info setObject:@0 forKey:@"is_logined"];
                                
                                if(error || result.isCancelled) {
                                    
                                    if(error)
                                    {
                                        [info setObject:error.localizedDescription forKey:@"error_message"];
                                        NSString *infoStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:info options:0 error:nil]
                                                                                  encoding:NSUTF8StringEncoding];
                                        notifyLoginResult(false, [infoStr UTF8String]);
                                    }
                                    if(result.isCancelled)
                                        notifyLoginResult(false, "cancelled");
                                    
                                    
                                    
                                    
                                } else {
                                    [sdk fetchFacebookUserInfo];
                                }
                            }];
}
void NativeApp::logoutFacebook()
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    notifyLogoutResult(true);
}
void NativeApp::withdrawFacebook()
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions"
                                       parameters:nil
                                       HTTPMethod:@"DELETE"]
     
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if(result)
         {
             notifyWithdrawResult(true);
         }
     }];
}
void NativeApp::exitApp()
{
    exit(0);
}

float NativeApp::versionOS()
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

bool NativeApp::isInstalledApp(QString nameOrScheme) { return false; }
int NativeApp::isOnline()
{
    struct sockaddr_in zeroAddr;
    bzero(&zeroAddr, sizeof(zeroAddr));
    zeroAddr.sin_len = sizeof(zeroAddr);
    zeroAddr.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if(!didRetrieveFlags)
    {
        return false;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    
    if(isReachable && !needsConnection && !nonWiFi) return 1;
    else if(isReachable && !needsConnection && nonWiFi) return 2;
    return 0;
}

bool NativeApp::isRunning()
{
    if([appState isEqualToString:@"background"] || [appState isEqualToString:@"foreground"])
    {
        return true;
    }
    return false;
}

bool NativeApp::needUpdate()
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1){
        
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        
        if (![appStoreVersion isEqualToString:currentVersion]){
            return YES;
        }
    }
    return NO;
}
QString NativeApp::appVersionName()
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
    NSString* currentVersion = infoDictionary[@"CFBundleVersion"];
    return QString::fromNSString(currentVersion);
}

void NativeApp::openMarket()
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = @"1412494874"; //infoDictionary[@"CFBundleIdentifier"];
    NSString* prefix = @"http://itunes.apple.com/app/id";
    
//        NSLog(@"CFBundleIdentifier:: %@", appID);
    NSString *form = [NSString stringWithFormat:@"%@%@", prefix, appID];
    UIApplication *application = [UIApplication sharedApplication];
    
    if(isOSVersionOver10)
    {
        form = [form stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:form];
        [application openURL:url options:@{} completionHandler:^(BOOL success) {
            if(success) NSLog(@"Succeeded to open market."	);
            else NSLog(@"Failed to open market.");
        }];
    } else {
        [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, appID]]];
    }
}
void NativeApp::sendMail(QString destination, QString title, QString contents) {
    
    NSString *form = [NSString stringWithFormat:@"mailto://%@?subject=%@&body=%@", destination.toNSString(), title.toNSString(), contents.toNSString()];
    UIApplication *application = [UIApplication sharedApplication];
    
    if(isOSVersionOver10)
    {
        form = [form stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:form];
        [application openURL:url options:@{} completionHandler:^(BOOL success) {
            if(success) NSLog(@"Succeeded to open mail.");
            else NSLog(@"Failed to open mail.");
        }];
    }
    else
    {
        form = [form stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [application openURL:[NSURL URLWithString:form]];
    }
}
QString NativeApp::getPhoneNumber()
{
    return "";
}

void NativeApp::inviteKakao(QString senderId, QString image, QString title, QString desc, QString link)
{
    KMTTemplate *_template = [KMTFeedTemplate feedTemplateWithBuilderBlock:^(KMTFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
        
        feedTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = title.toNSString();
            contentBuilder.desc = desc.toNSString(); //@"아메리카노, 빵, 케익";
            contentBuilder.imageURL = [NSURL URLWithString: image.toNSString()];//[NSURL URLWithString:@"http://mud-kage.kakao.co.kr/dn/NTmhS/btqfEUdFAUf/FjKzkZsnoeE4o19klTOVI1/openlink_640x640s.jpg"];
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = [NSURL URLWithString: link.toNSString()];//@"https://developers.kakao.com"];
            }];
        }];
    }];
    
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:_template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

void NativeApp::shareKakao(QString senderId, QString image, QString title, QString desc, QString link)
{
    NSString *templateId = @"10611";
    NSDictionary *templateArgs = @{@"IMAGE": image.toNSString(),
                                   @"TITLE": title.toNSString(),
                                   @"DESCRIPTION": link.toNSString()};
    
    [[KLKTalkLinkCenter sharedCenter] sendCustomWithTemplateId:templateId templateArgs:templateArgs success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

void NativeApp::inviteFacebook(QString senderId, QString image, QString title, QString desc, QString link)
{
    UIViewController *qCtrl = [[[UIApplication sharedApplication] keyWindow]rootViewController];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:link.toNSString()];
    content.quote = desc.toNSString();
    [FBSDKShareDialog showFromViewController:qCtrl
                                 withContent:content
                                    delegate:nil];
}
void NativeApp::shareFacebook(QString senderId, QString image, QString title, QString desc, QString link)
{
    UIViewController *qCtrl = [[[UIApplication sharedApplication] keyWindow]rootViewController];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:link.toNSString()];
    content.quote = desc.toNSString();
    [FBSDKShareDialog showFromViewController:qCtrl
                                 withContent:content
                                    delegate:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([KOSession isKakaoAccountLoginCallback:url]) {
        return [KOSession handleOpenURL:url];
    }
    
    return NO;
}

/*** UI Methods Section ***/
int NativeApp::getStatusBarHeight() { return 20; }
int NativeApp::getTimerSec() { return 0; }
void NativeApp::removeBadge()
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options {
    
    if([[FBSDKApplicationDelegate sharedInstance] application:application
                                                      openURL:url
                                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]])
        return NO;
    
    if ([KOSession isKakaoAccountLoginCallback:url]) {
        return [KOSession handleOpenURL:url];
    }
    return NO;
}

void NativeApp::showStatusBar(bool isShow)
{
    UIApplication.sharedApplication.statusBarHidden = !isShow;
}

void NativeApp::setOrientation(int type)
{
    if(type==1)
    {
        NativeApp::getInstance()->forcePortrait(false);
        NSNumber *v = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:v forKey:@"orientation"];
    }
    else
    {
        NativeApp::getInstance()->forcePortrait(true);
        NSNumber *v = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:v forKey:@"orientation"];
    }
}

- (void) orientationChanged:(NSNotification *)note
{
    
    if(NativeApp::getInstance()->forcedPortrait())
    {
        NSNumber *v = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:v forKey:@"orientation"];
    }
    else
    {
        NSNumber *v = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:v forKey:@"orientation"];
    }
}

- (void)initializeRemoteNotification {
    if(isOSVersionOver10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(!error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    } else {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert |UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
}

/*** Change the string to the uncode characters. ***/
QString NativeApp::convertToUnicode(QString contents)
{
    NSData *data = [contents.toNSString() dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *converted = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return QString::fromNSString(converted);
}

/*** Change the uncode characters to the string. ***/
QString NativeApp::convertFromUnicode(QString contents)
{
    NSData *data = [contents.toNSString() dataUsingEncoding:NSUTF8StringEncoding];
    NSString *converted = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    return QString::fromNSString(converted);
}

/*** Security Section ***/
//RSA* rsa;
bool m_systemSecured = false;
QString pvKey;
QString pbKey;
QString NativeApp::encrypted(QString str)
{
//    NSString *encrypted = @"untitled";
//    if(m_systemSecured)
//        encrypted = [RSA encryptString:str.toNSString() publicKey:pbKey.toNSString()];
//    return QString::fromNSString(encrypted);
    return str;
}

QString NativeApp::decrypted(QString str)
{
//    NSString *decrypted = @"untitled";
//    if(m_systemSecured)
//        decrypted = [RSA decryptString:str.toNSString() privateKey:pvKey.toNSString()];
//    return QString::fromNSString(decrypted);
    return str;
}

bool NativeApp::isSystemSecured()
{
    return m_systemSecured;
}

- (void) getSecurityInfo
{
//    NSString *noteDataString = [NSString stringWithFormat:@"os_type=%@", @"1"];
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//    NSURL *url = [NSURL URLWithString:@"https://mobile01.e-koreatech.ac.kr/getSecurityInfo"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPMethod = @"POST";
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if(error == nil && [(NSHTTPURLResponse*)response statusCode] == 200)
//        {
//            if(data != NULL)
//            {
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//                pbKey = QString::fromNSString([dict objectForKey:@"rsa_public_key"]).replace("\\n", "\n");
//                pvKey = QString::fromNSString([dict objectForKey:@"rsa_private_key"]).replace("\\n", "\n");
//                if(pbKey.isEmpty() || pvKey.isEmpty()) exit(0);
                m_systemSecured = true;
//            }
//        }
//    }];
//    [postDataTask resume];
}

//check jail
-(BOOL)isJailbroken {
#if!(TARGET_IPHONE_SIMULATOR)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:@"/Applications/Cydia.app"]
       || [fileManager fileExistsAtPath:@"Library/MobileSubstrate/MobileSubstrate.dylib"]
       || [fileManager fileExistsAtPath:@"/usr/sbin/sshd"]
       || [fileManager fileExistsAtPath:@"/etc/apt"]
       || [fileManager fileExistsAtPath:@"/private/var/lib/apt/"]) {
        return YES;
    }
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.codymonster.ibeobom"]])
    {
        return YES;
    }
#endif
    return NO;
}

//// [END Security Section] ////

/* GET THE DEVICE TOKEN. */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    
    NSMutableString *tokenHex = [NSMutableString stringWithString:[deviceToken description]];
    [tokenHex replaceOccurrencesOfString:@"<" withString:@"" options:0 range:NSMakeRange(0, [tokenHex length])];
    [tokenHex replaceOccurrencesOfString:@">" withString:@"" options:0 range:NSMakeRange(0, [tokenHex length])];
    [tokenHex replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, [tokenHex length])];
//    NSLog(@"Token origin : %@", deviceToken);
//    NSLog(@"Token : %@", tokenHex);
    
    Settings* settings = Settings::getInstance();
    settings->setNativePushkey(QString::fromNSString(tokenHex));
    
}

/*** PUSH Service Methdos ****/
/* iOS <= 9.0 : PUSH DELEGATE */
#pragma mark - Remote Notification Delegate <= iOS 9.x
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}



/* iOS >= 10 : PUSH DELEGATE */
#pragma mark - UNUserNotificationCenter Delegate for >= iOS 10
/* WHEN EXECUTING THE APP, PROCESS PUSH DATA */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler {

    NSDictionary* userDiction = notification.request.content.userInfo;
    int type = [[userDiction objectForKey:@"type"] intValue];
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
}

/* WHEN EXECUTING THE APP BEHIND BACKGROUND OR QUITTED, PROCESS PUSH DATA */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary* userDiction = response.notification.request.content.userInfo;
    NSDictionary* apsDiction = [userDiction objectForKey:@"aps"];
    
    int type = [[userDiction objectForKey:@"type"] intValue];
    int no1 = [[userDiction objectForKey:@"course_no"] intValue];
    int no2 = [[userDiction objectForKey:@"lesson_subitem_no"] intValue];
    NSString* contents = [apsDiction objectForKey:@"alert"];
    
    NativeApp* app = NativeApp::getInstance();
    app->removeBadge();
    if(type == 3) return;
    app->notifyNotificated(type, QString::fromNSString(contents), no1, no2, true);
    completionHandler();
}
////////////////////////////////////////////////////////////////////////////////////

/*** App Life cycle. ***/
- (void)applicationWillResignActive:(UIApplication *)application {
    NativeApp::getInstance()->setVideoStatus(0);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [KOSession handleDidEnterBackground];
    appState = @"background";
    NativeApp* app = NativeApp::getInstance();
    app->requestShrinkVideo(true);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    appState = @"foreground";
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    [KOSession handleDidBecomeActive];
}
//////////////////////////////////////////

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Jail check.
    if([self isJailbroken]) exit(0);
    
    //Device Orientation Control.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    //To use the Facebook SDK.
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //To use push.
    [self initializeRemoteNotification];
    
    //To control audio.
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: nil];
    
    //To get the security info(keys...)
    [self getSecurityInfo];
    return YES;
}



///NO USE

/* PROCESSING PUSH DATA */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Silent Notification. UserInfo : %@", userInfo);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"Error : %@", error);
}


@end

