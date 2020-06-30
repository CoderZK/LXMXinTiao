//
//  LxmNetworking.m
//  ShareGo
//
//  Created by 李晓满 on 16/4/23.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import "LxmNetworking.h"
#import <MJExtension/MJExtension.h>
#import "BaseNavigationController.h"
#import "LxmLoginVC.h"

@implementation LxmNetworking

+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/json",@"text/javascript",@"text/x-chdr", nil];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    return manager;
}

+ (NSURLSessionDataTask *)networkingPOST:(NSString *)urlStr parameters:(id)parameters returnClass:(Class)returnClass success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager *manager = [self manager];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *device = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    [mDict setValue:device forKey:@"device_id"];
    [mDict setValue:@1 forKey:@"channel"];
    NSString *version = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mDict setValue:version forKey:@"version"];
    NSString *mdSignature = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@%@%@",device,@1,version,[device substringFromIndex:device.length-5]]];
    [mDict setValue:[NSString stringWithFormat:@"%@1",mdSignature] forKey:@"signature"];
    
    NSLog(@"%@",mDict);
    
    return [manager POST:urlStr parameters:mDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"key"] integerValue] == 7) {
            //用户未登录
            [LxmTool ShareTool].pushToken = @"";
            [[LxmTool ShareTool] uploadDeviceToken];
            
            [LxmTool ShareTool].userModel = nil;
            [LxmTool ShareTool].isLogin = NO;
            [LxmTool ShareTool].session_token = nil;
            BaseNavigationController * nav  = [[BaseNavigationController alloc] initWithRootViewController:[[LxmLoginVC alloc] init]];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        }
        if (success) {
            id obj = responseObject;
            if (returnClass) {
                obj = [returnClass mj_objectWithKeyValues:responseObject];
            }
            success(task,obj);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (error.code != -999) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            }
            failure(task,error);
        }
    }];
}

+ (NSURLSessionDataTask *)networkingGET:(NSString *)urlStr parameters:(id)parameters returnClass:(Class)returnClass success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager * manager = [self manager];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *device = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    [mDict setValue:device forKey:@"device_id"];
    [mDict setValue:@1 forKey:@"channel"];
    NSString *version = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mDict setValue:version forKey:@"version"];
    NSString *mdSignature = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@%@%@",device,@1,version,[device substringFromIndex:device.length-5]]];
    [mDict setValue:[NSString stringWithFormat:@"%@1",mdSignature] forKey:@"signature"];
    
    return [manager GET:urlStr parameters:mDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            id obj = responseObject;
            if (returnClass) {
                obj = [returnClass mj_objectWithKeyValues:responseObject];
            }
            success(task,obj);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (error.code != -999) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            }
            failure(task,error);
        }
    }];
    
}

/**
 上传图片
 */
+ (void)NetWorkingUpLoad:(NSString *)urlStr image:(UIImage *)image parameters:(id)parameters name:(NSString *)name success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager * manager = [self manager];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *device = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    [mDict setValue:device forKey:@"device_id"];
    [mDict setValue:@1 forKey:@"channel"];
    NSString *version = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mDict setValue:version forKey:@"version"];
    NSString *mdSignature = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@%@%@",device,@1,version,[device substringFromIndex:device.length-5]]];
    [mDict setValue:[NSString stringWithFormat:@"%@1",mdSignature] forKey:@"signature"];
    
    [manager POST:urlStr parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
             [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:name fileName:@"123.jpg" mimeType:@"image/jpeg"];
        }

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success)
        {
            success(task,responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failure)
        {
            if (error.code != -999) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            }
            failure(task,error);
        }

    }];
    
}

/**
 多张单个上传图片_json
 */
+(void)NetWorkingUpLoad:(NSString *)urlStr image1:(UIImage *)image1 image2:(UIImage *)image2 image3:(UIImage *)image3 parameters:(id)parameters name1:(NSString *)name1 name2:(NSString *)name2 name3:(NSString *)name3  success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager * manager = [self manager];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *device = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    [mDict setValue:device forKey:@"device_id"];
    [mDict setValue:@1 forKey:@"channel"];
    NSString *version = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mDict setValue:version forKey:@"version"];
    NSString *mdSignature = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@%@%@",device,@1,version,[device substringFromIndex:device.length-5]]];
    [mDict setValue:[NSString stringWithFormat:@"%@1",mdSignature] forKey:@"signature"];
    
    [manager POST:urlStr parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image1) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image1, 0.5) name:name1 fileName:@"123.jpg" mimeType:@"image/jpeg"];
        }
        if (image2) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image2, 0.5) name:name2 fileName:@"123.jpg" mimeType:@"image/jpeg"];
        }
        if (image3) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image3, 0.5) name:name3 fileName:@"123.jpg" mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure)
        {
            if (error.code != -999) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            }
            failure(task,error);
        }
        
    }];
}



/**
 多张上传图片
 */
+(void)NetWorkingUpLoad:(NSString *)urlStr images:(NSArray<UIImage *> *)images parameters:(id)parameters name:(NSString *)name success:(SuccessBlock)success failure:(FailureBlock)failure
{
    AFHTTPSessionManager * manager = [self manager];

    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *device = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    [mDict setValue:device forKey:@"device_id"];
    [mDict setValue:@1 forKey:@"channel"];
    NSString *version = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [mDict setValue:version forKey:@"version"];
    NSString *mdSignature = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@%@%@",device,@1,version,[device substringFromIndex:device.length-5]]];
    [mDict setValue:[NSString stringWithFormat:@"%@1",mdSignature] forKey:@"signature"];
    
    [manager POST:urlStr parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (images) {
            for (UIImage * image in images)
            {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:name fileName:@"teswwt1.jpg" mimeType:@"image/jpeg"];
            }
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            if (error.code != -999) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            }
            failure(task,error);
        }
    }];
}

/**
 两个数组上传图片
 */
+(void)NetWorkingUpLoad:(NSString *)urlStr imagesFirst:(NSArray<UIImage *> *)imagesFirst imagesSecond:(NSArray<UIImage *> *)imagesSecond parameters:(id)parameters name1:(NSString *)name1 name2:(NSString *)name2 success:(SuccessBlock)success failure:(FailureBlock)failure
{

    
    AFHTTPSessionManager * manager = [self manager];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (UIImage * image in imagesFirst)
        {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:name1 fileName:@"teswwt11111.jpg" mimeType:@"image/jpeg"];
        }
        for (UIImage * image in imagesSecond)
        {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:name2 fileName:@"teswwt222222.jpg" mimeType:@"image/jpeg"];
        }
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            if (error.code != -999) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，获取失败"];
            }
            failure(task,error);
        }
    }];
}

@end
