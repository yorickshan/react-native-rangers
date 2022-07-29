#import "RangersAppLogModule.h"
#if __has_include(<React/RCTLog.h>)
#import <React/RCTLog.h>
#else
#import "RCTLog.h"
#endif
#import <RangersAppLog/RangersAppLog.h>

@implementation RangersAppLogModule

RCT_EXPORT_MODULE(RangersAppLogModule)

RCT_REMAP_METHOD(init,
                 initWithAppID: (NSString *)appID
                 channel: (NSString *)channel
                 enableAb: (nonnull NSNumber *)enableAb
                 autoStart: (nonnull NSNumber *)autoStart
                 enableEncrypt: (nonnull NSNumber *)enableEncrypt
                 host: (NSString*)host
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    BDAutoTrackConfig *config;
    if ([BDAutoTrackConfig respondsToSelector:@selector(configWithAppID:launchOptions:)]) {
        config = [BDAutoTrackConfig configWithAppID:appID launchOptions:nil];
    } else {
        config = [BDAutoTrackConfig configWithAppID:appID];
    }
    if ([channel isKindOfClass:[NSNumber class]]) {
        config.channel = channel;
    }
    if ([enableAb isKindOfClass:[NSNumber class]]) {
        config.abEnable = [enableAb boolValue];
    }
    if ([enableEncrypt isKindOfClass:[NSNumber class]]) {
        config.logNeedEncrypt = [enableEncrypt boolValue];
    }
    
    [BDAutoTrack sharedTrackWithConfig:config];
    if (host && host.length) {
        [[BDAutoTrack sharedTrack] setRequestHostBlock:^NSString * _Nullable(BDAutoTrackServiceVendor  _Nonnull vendor, BDAutoTrackRequestURLType requestURLType) {
            return host;
        }];
    }
    if (autoStart) {
        [[BDAutoTrack sharedTrack] startTrack];
    }
}

RCT_EXPORT_METHOD(start)
{
    RCTLogInfo(@"%s", __func__);
    [[BDAutoTrack sharedTrack] startTrack];
}

RCT_EXPORT_METHOD(onEventV3:(NSString *)event params:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  RCTLogInfo(@"%s", __func__);
  [[BDAutoTrack sharedTrack] eventV3:event params:params];
}

/* header info */
RCT_EXPORT_METHOD(setHeaderInfo:(NSDictionary *)customHeader resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  for (NSString *key in customHeader) {
      if ([key isKindOfClass:NSString.class]) {
          NSObject *val = customHeader[key];
          [[BDAutoTrack sharedTrack] setCustomHeaderValue:val forKey:key];
      }
  }
}

RCT_EXPORT_METHOD(removeHeaderInfo:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] removeCustomHeaderValueForKey:key];
}

/* user unique id */
RCT_EXPORT_METHOD(setUserUniqueId:(NSString *)userUniqueID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  [[BDAutoTrack sharedTrack] setCurrentUserUniqueID:userUniqueID];
  resolve(userUniqueID);
}

/* AB */
RCT_REMAP_METHOD(getAbSdkVersion, getAbSdkVersionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString *allAbVids = [[BDAutoTrack sharedTrack] allAbVids];
  resolve(allAbVids);
}

RCT_REMAP_METHOD(getABTestConfigValueForKey, getABTestConfigValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  id ret = [[BDAutoTrack sharedTrack] ABTestConfigValueForKey:key defaultValue:defaultValue];
  resolve(ret);
}

RCT_REMAP_METHOD(getAllAbTestConfigs, getAllAbTestConfigsWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSDictionary *result;
    result = [[BDAutoTrack sharedTrack] allABTestConfigs];
    resolve(result);
}

RCT_REMAP_METHOD(getAllAbTestConfigs2, getAllAbTestConfigs2Withresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSDictionary *result;
    
    // new format result
    // should use iOS SDK v6.3.0+
    if ([[BDAutoTrack sharedTrack] respondsToSelector:@selector(allABTestConfigs2)]) {
        result = [[BDAutoTrack sharedTrack] performSelector:@selector(allABTestConfigs2)];
    }
    
    resolve(result);
}

/* ID */

RCT_REMAP_METHOD(getDeviceID, getDeviceIDWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  // RCTLogInfo(@"[Native]: %s", __func__);
  NSString *did = [[BDAutoTrack sharedTrack] rangersDeviceID];
  // RCTLogInfo(@"[Native]: %@", did);
  resolve(did);
}

/* Profile */
RCT_EXPORT_METHOD(profileSet:(NSDictionary *)profileDict
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileSet:profileDict];
}

RCT_EXPORT_METHOD(profileSetOnce:(NSDictionary *)profileDict
                 withResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileSetOnce:profileDict];
}

RCT_EXPORT_METHOD(profileUnset:(NSString *)profileName
                 withResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileUnset:profileName];
}

RCT_EXPORT_METHOD(profileIncrement:(NSDictionary *)profileDict
                 withResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileIncrement:profileDict];
}

RCT_EXPORT_METHOD(profileAppend:(NSDictionary *)profileDict
                 withResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[BDAutoTrack sharedTrack] profileAppend:profileDict];
}

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  NSNumber *result = @([a floatValue] * [b floatValue]);

  resolve(result);
}

@end
