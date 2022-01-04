#import "CDVHeartBeat.h"
#import "BodyVitalsViewController.h"

@interface CDVHeartBeat()<HeartRateDetectionModelDelegate>
@property (copy, nonatomic) NSString *mainCallbackId;
@property (nonatomic, assign) bool detecting;
@property (nonatomic, assign) int bpms;
@property (nonatomic, assign) int so2;
@property (nonatomic, assign) int rr;
@property (nonatomic, getter=isModalInPresentation) BOOL modalInPresentation;
@property (nonatomic, strong) NSString *ppgdata;
@property (nonatomic, strong) NSString *ecgdata;
@end

@implementation CDVHeartBeat


- (void)getVitals:(CDVInvokedUrlCommand*)command
{
    //    [[self lib] setMeasureTime:[[command argumentAtIndex:0] intValue]];
    NSError *error;
    NSDictionary *jsonData = [NSJSONSerialization dataWithJSONObject:[command argumentAtIndex:0]
                                                             options:NSJSONWritingPrettyPrinted error:&error];
    NSString *api_key = [command argumentAtIndex:0][@"api_key"];
    NSString *scan_token = [command argumentAtIndex:0][@"scan_token"];
    NSString *color_code = [command argumentAtIndex:0][@"color_code"];
    NSString *employee_id = [command argumentAtIndex:0][@"employee_id"];
    NSString *measured_height= [command argumentAtIndex:0][@"measured_height"];
    NSString *measured_weight= [command argumentAtIndex:0][@"measured_weight"];
    NSString *posture =[command argumentAtIndex:0][@"posture"];
    NSDictionary *postDict = @{@"api_key":api_key, @"scan_token":scan_token,@"employee_id":employee_id,@"measured_height": measured_height, @"measured_weight":measured_weight,@"posture": posture };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"bodyvitals" bundle:nil];
        BodyVitalsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"BodyVitalsViewController"];
        vc.api_details = postDict;
        if (@available(iOS 13.0, *)) {
            [vc setModalInPresentation:YES];
        } else {
            // Fallback on earlier versions
        }
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self setMainCallbackId:[command callbackId]];
        [self.viewController presentViewController:nav animated:YES completion:^{
            vc.delegate = self;
        }];
        
        
    });
}

- (void)heartRateStart{
    self.bpms = 0;
    self.so2 = 0;
    self.rr = 0;
}

- (void)heartRateUpdate:(int)bpm{
    self.bpms = bpm;
}
- (void)apiResponseUpdate:(NSString *)apiResponse{
    self.apiResponse = apiResponse;
}

- (void)Spo2Update:(int)so2{
    self.so2 = so2;
}

- (void)RespirationUpdate:(int)rr{
    self.rr = rr;
}

- (void)setPPGData:(NSString *)ppgData{
    self.ppgdata = ppgData;
}

- (void)setECGData:(NSString *)ecgData{
    self.ecgdata = ecgData;
}

- (void)setHeartDataArray:(NSString *)heartDataArray{
    self.heartdataArray = heartDataArray;
}

- (void)heartRateEnd{
    self.detecting = false;
    
    NSString* myHeartRate = [NSString stringWithFormat:@"%i", self.bpms];
    NSString* myso2 = [NSString stringWithFormat:@"%i", self.so2];
    NSString* myRespirationRate = [NSString stringWithFormat:@"%i", self.rr];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:myHeartRate forKey:@"bpm"];
    [dict setValue:myso2 forKey:@"O2R"];
    [dict setValue:myRespirationRate forKey:@"breath"];
    [dict setValue:self.ppgdata forKey:@"ppgdata"];
    [dict setValue:self.ecgdata forKey:@"ecgdata"];
    [dict setValue:self.heartdataArray forKey:@"heartDataArray"];
    [dict setValue:self.apiResponse forKey:@"apiResponse"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString: jsonString];
    [[self commandDelegate] sendPluginResult:result callbackId:_mainCallbackId];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)heartRateMeasurementFailed:(NSString *)message{
    self.detecting = false;
    __callbackResult([@"" stringByAppendingString:message]);
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
