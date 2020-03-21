#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

@interface  AneTriominos : NSObject <UIApplicationDelegate> {
    FREContext _context;
}


+ (AneTriominos*)instance;
+ (NSString*)convertToJSonString:(NSDictionary*)dict;

- (BOOL)isInitialized;
- (void)sendEvent:(NSString*)code;
- (void)sendLog:(NSString*)log;
- (void)sendEvent:(NSString*)code level:(NSString*)level;

@end

void AneTriominosContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void AneTriominosContextFinalizer(FREContext ctx);
void AneTriominosInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void AneTriominosFinalizer(void *extData);

