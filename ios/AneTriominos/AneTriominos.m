/**
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AneTriominos.h"
#import <UIKit/UIApplication.h>
#import <UIKit/UIAlertView.h>
#import <UserNotifications/UserNotifications.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }



@implementation AneTriominos

#pragma mark - init

+ (AneTriominos*)instance {
    
    static AneTriominos* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AneTriominos alloc] init];
    });
    
    return _sharedInstance;
}

- (BOOL)isInitialized {
    return (_context != nil);
}

- (void)setupWithContext:(FREContext)extensionContext {
    _context = extensionContext;
}

#pragma mark - helpers

- (void)sendLog:(NSString*)log {
    [self sendEvent:@"LOGGING" level:log];
}

- (void)sendEvent:(NSString*)code {
    [self sendEvent:code level:@""];
}

- (void)sendEvent:(NSString*)code level:(NSString*)level {
    FREDispatchStatusEventAsync(_context, (const uint8_t*)[code UTF8String], (const uint8_t*)[level UTF8String]);
}

+ (NSString*)convertToJSonString:(NSDictionary*)dict {
    
    if (!dict)
        return @"{}";
    
    NSError* jsonError = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&jsonError];
    
    if (jsonError != nil) {
        
        NSLog(@"[AneTriominos] JSON stringify error: %@", jsonError.localizedDescription);
        return @"{}";
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end


void AneTriominosContextInitializer(void* extData,
                                           const uint8_t* ctxType,
                                           FREContext ctx,
                                           uint32_t* numFunctionsToTest,
                                           const FRENamedFunction** functionsToSet) {
    
    [[AneTriominos instance] setupWithContext:ctx];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    Class objectClass = object_getClass(delegate);
    
    NSString* newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class modDelegate = NSClassFromString(newClassName);
    
    if (modDelegate == nil) {
        
        // this class doesn't exist; create it
        // allocate a new class
        modDelegate = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        
        SEL selectorToOverride1 = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
        SEL selectorToOverride2 = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
        SEL selectorToOverride3 = @selector(application:didReceiveRemoteNotification:);
        
        
        // get the info on the method we're going to override
        Method m1 = class_getInstanceMethod(objectClass, selectorToOverride1);
        Method m2 = class_getInstanceMethod(objectClass, selectorToOverride2);
        Method m3 = class_getInstanceMethod(objectClass, selectorToOverride3);
        
        // register the new class with the runtime
        objc_registerClassPair(modDelegate);
    }
    
    // change the class of the object
    object_setClass(delegate, modDelegate);
    
    static FRENamedFunction functions[] = {
        /* MAP_FUNCTION(registerPush, NULL),
        MAP_FUNCTION(setBadgeNb, NULL),
        MAP_FUNCTION(sendLocalNotification, NULL),
        MAP_FUNCTION(setIsAppInForeground, NULL),
        MAP_FUNCTION(fetchStarterNotification, NULL),
        MAP_FUNCTION(cancelLocalNotification, NULL),
        MAP_FUNCTION(cancelAllLocalNotifications, NULL),
        MAP_FUNCTION(getCanSendUserToSettings, NULL),
        MAP_FUNCTION(getNotificationsEnabled, NULL),
        MAP_FUNCTION(openDeviceNotificationSettings, NULL),
        MAP_FUNCTION(storeNotifTrackingInfo, NULL),
        MAP_FUNCTION(checkAppNotificationSettingsRequest, NULL) */
    };
    
    *numFunctionsToTest = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
    
}

void AneTriominosContextFinalizer(FREContext ctx) {
    
    // nothing
}

void AneTriominosInitializer(void** extDataToSet,
                                    FREContextInitializer* ctxInitializerToSet,
                                    FREContextFinalizer* ctxFinalizerToSet) {
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AneTriominosContextInitializer;
    *ctxFinalizerToSet = &AneTriominosContextFinalizer;
}

void AneTriominosFinalizer(void *extData) {
    
    // nothing
}


