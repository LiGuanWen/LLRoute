//
//  LLRoute.h
//  Pods
//
//  Created by Lilong on 2017/6/25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LLROUTE_SCHEME @"llroute"
//开始页面
static NSString *const llgb_routeWithBegin = @"llroute://game/begin";


@interface LLRoute : NSObject
@property (nonatomic,strong) UIViewController *currentVC; //跳转的VC
@property (nonatomic,strong) NSURL *linkUrl; //链接地址
@property (nonatomic,assign) BOOL isPush; //是否跳转页面
@property (nonatomic,assign) BOOL hidesBottom; //是否跳转页面
@property (nonatomic,strong) NSMutableDictionary *parameterDict; //对象参数

/**
 路径跳转
 
 @param url 跳转的url
 @param currentVC 当前跳转的UIViewController
 @param hidesBottomBarWhenPushed 是否隐藏tabbar
 @param parameterDict 需要传递的参数
 */
+ (LLRoute *)routeWithUrl:(NSURL *)url currentVC:(UIViewController *)currentVC hidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed parameterDict:(NSMutableDictionary *)parameterDict;

@end

//
///**
// 跳转前缀
// */
//+(NSString *)routeName
//{
//    return @"llrout";
//}
//
///**
// 组件scheme跳转   子类重新 参考！！！！！！
//
// @param schemeStr scheme参数
// @param dic 其他特殊参数
// */
//+ (void)routeToScheme:(NSString *)schemeStr parameter:(NSMutableDictionary *)dic{
//    UIViewController *vc = [dic objectForKey:@"currentVC"];
//    NSLog(@"currvc class = %@",[vc class]);
//    NSString *hidesBottomStr = [dic objectForKey:@"hidesBottom"];
//    BOOL hidesBottom;
//    if ([hidesBottomStr isEqualToString:@"YES"]) {
//        hidesBottom = YES;
//    }else{
//        hidesBottom = NO;
//    }
//}

