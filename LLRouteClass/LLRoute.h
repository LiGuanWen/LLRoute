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

#define CURRENT_VC_KEY @"currentVC"
#define HIDESBOTTOMBARWHENPUSHED_KEY @"hidesBottomBarWhenPushed"
#define HIDESBOTTOMBARWHENPUSHED_YES @"YES"
#define HIDESBOTTOMBARWHENPUSHED_NO @"NO"



//开始页面
static NSString *const llgb_routeWithHomeBegin = @"llroute://home/begin";


@interface LLModuleInfo : NSObject
@property (nonatomic,strong) NSString *moduleName; //模块名称
@property (nonatomic,strong) NSString *page; //跳转的页面
@property (nonatomic,strong) NSDictionary *parameter; //参数字典

- (instancetype)initWithURL:(NSURL *)url;
@end


@interface LLRoute : NSObject
@property (nonatomic,strong) UIViewController *currentVC; //跳转的VC
@property (nonatomic,strong) NSURL *linkUrl; //链接地址
@property (nonatomic,assign) BOOL isPush; //是否跳转页面
@property (nonatomic,assign) BOOL hidesBottomBarWhenPushed; //是否跳转页面
@property (nonatomic,strong) NSMutableDictionary *parameterDict; //对象参数

/**
 路径跳转
 
 @param url 跳转的url
 @param currentVC 当前跳转的UIViewController
 @param hidesBottomBarWhenPushed 是否隐藏tabbar
 @param parameterDict 需要传递的参数
 */
+ (LLRoute *)routeWithUrl:(NSURL *)url currentVC:(UIViewController *)currentVC hidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed parameterDict:(NSMutableDictionary *)parameterDict;


/**
 解析Url
 */
+ (LLModuleInfo *)getModuleInfo:(NSURL *)url;

@end

///**
// 跳转前缀
// */
//+(NSString *)routeName
//{
//    return LLROUTE_SCHEME;
//}
//
///**
// 组件scheme跳转   子类重新 参考！！！！！！
//
// @param schemeUrl schemeUrl参数
// @param dic 其他特殊参数
// */
//+ (void)routeToSchemeUrl:(NSURL *)schemeUrl parameter:(NSMutableDictionary *)dic{
//    UIViewController *vc = [dic objectForKey:CURRENT_VC_KEY];
//    NSLog(@"currvc class = %@",[vc class]);
//    NSString *hidesBottomStr = [dic objectForKey:HIDESBOTTOMBARWHENPUSHED_KEY];
//    BOOL hidesBottom;
//    if ([hidesBottomStr isEqualToString:HIDESBOTTOMBARWHENPUSHED_YES]) {
//        hidesBottom = YES;
//    }else{
//        hidesBottom = NO;
//    }
//}



