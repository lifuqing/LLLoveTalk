//
//  UIDevice+LLTools.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/7.
//

#import "UIDevice+LLTools.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <AdSupport/AdSupport.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>


#import <SystemConfiguration/SystemConfiguration.h>

#import <arpa/inet.h>
#import <netdb.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <unistd.h>
#import <dlfcn.h>



@implementation UIDevice (LLTools)
- (NSString *)machine {
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *machine = [NSString stringWithUTF8String:name];
    
    // Done with this
    free(name);
    
    return machine;
}

- (NSString *)carrier {
    if(NSClassFromString(@"CTTelephonyNetworkInfo")){
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [networkInfo subscriberCellularProvider];
        if ([[carrier carrierName] length] > 0) {
            return [NSString stringWithFormat:@"%@_%@%@", [carrier carrierName], [carrier mobileCountryCode], [carrier mobileNetworkCode]];
        }else{
            return @"";
        }
    }
    return @"";
}


- (NSNumber *)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

- (NSString *)UUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


- (NSString *)appName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}
- (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)defaultUserAgent
{
    static NSString *userAgent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //应用程序名称
        NSString *appName = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"LoveTalk" : @"LoveTalk HD";
        //软件版本
        NSString *appVersion = [[UIDevice currentDevice] appVersion];
        //系统名称
        NSString *systemName = [[UIDevice currentDevice] systemName];
        //系统版本
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        //硬件标识
        NSString *machine = [[UIDevice currentDevice] machine];
        userAgent = [@[appName, appVersion, systemName, systemVersion, machine] componentsJoinedByString:@";"];
    });
    return userAgent;
}

- (NSString *) hostname
{
    char baseHostName[256]; // Thanks, Gunnar Larisch
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '\0';
    
#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", baseHostName];
#else
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}


- (NSString *) localIPAddress
{
    struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

@end
