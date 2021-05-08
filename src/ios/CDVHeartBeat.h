#import <Cordova/CDV.h>

@interface CDVHeartBeat : CDVPlugin

- (void)getVitals:(CDVInvokedUrlCommand*)command;

@end