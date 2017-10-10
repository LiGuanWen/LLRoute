# LLRoute

项目之间的跳转路线  适用于项目之内 和各个模块项目之间的跳转 组件化管理项目

使用方式 通过pod       
 pod 'LLRoute', :git => 'https://github.com/LiGuanWen/LLRoute.git'
导入到工程中


使用是 需要先注册跳转路径文件class 一般再 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 中注册
PS: 已  LLSpeedRoute 为例子
比如：    [[LLRouteManager sharedManager] registerRoute:[LLSpeedRoute class]];

创建工程中独立的 route 参考 （LLSpeedRoute）

////  LLSpeedRoute.h


#import <Foundation/Foundation.h>
#import "LLRoute.h"

#define LLSPEED_SCHEME @"llspeed"

//开始页面
static NSString *const llspeed_routeWithBegin = @"llspeed://game/begin";
//菜单
static NSString *const llspeed_routeWithMenu = @"llspeed://game/menu";
//关于
static NSString *const llspeed_routeWithAbout = @"llspeed://game/about";

@interface LLSpeedRoute : NSObject
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
+ (LLSpeedRoute *)routeWithUrl:(NSURL *)url currentVC:(UIViewController *)currentVC hidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed parameterDict:(NSMutableDictionary *)parameterDict;
@end


//  LLSpeedRoute.m

#import "LLSpeedRoute.h"

#import "LLSpeedAboutViewController.h"  //关于
#import "LLSpeedMenuViewController.h"   //菜单
#import "LLSpeedGameViewController.h"   //开始

@implementation LLSpeedRoute


/**
 跳转前缀
 */
+(NSString *)routeName{
    return LLSPEED_SCHEME;
}

/**
 组件scheme跳转   子类重新 参考！！！！！！
 
 @param schemeUrl scheme参数
 @param dic 其他特殊参数
 */
+ (void)routeToSchemeUrl:(NSURL *)schemeUrl parameter:(NSMutableDictionary *)dic{
    UIViewController *currentVC = [dic objectForKey:CURRENT_VC_KEY];
    NSLog(@"当前页面  currvc class = %@",[currentVC class]);
    NSString *hidesBottomStr = [dic objectForKey:HIDESBOTTOMBARWHENPUSHED_KEY];
    BOOL hidesBottom;
    if ([hidesBottomStr isEqualToString:HIDESBOTTOMBARWHENPUSHED_YES]) {
        hidesBottom = YES;
    }else{
        hidesBottom = NO;
    }
    [LLSpeedRoute routeWithUrl:schemeUrl currentVC:currentVC hidesBottomBarWhenPushed:hidesBottom parameterDict:dic];
}

/**
 路径跳转
 
 @param url 跳转的url
 @param currentVC 当前跳转的UIViewController
 @param hidesBottomBarWhenPushed 是否隐藏tabbar
 @param parameterDict 需要传递的参数
 */
+ (LLSpeedRoute *)routeWithUrl:(NSURL *)url currentVC:(UIViewController *)currentVC hidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed parameterDict:(NSMutableDictionary *)parameterDict{
    LLSpeedRoute *route = [[LLSpeedRoute alloc] initWithUrl:url currentVC:currentVC hidesBottomBarWhenPushed:hidesBottomBarWhenPushed parameterDict:parameterDict];
    return route;
}

- (id)initWithUrl:(NSURL *)url currentVC:(UIViewController *)currentVC hidesBottomBarWhenPushed:(BOOL)yes parameterDict:(NSMutableDictionary *)parameterDict{
    self = [super init];
    if (self) {
        self.currentVC = currentVC;
        self.linkUrl = url;
        self.hidesBottom = yes;
        self.parameterDict = parameterDict;
        [self startParsingWithUrl:url];
    }
    return self;
}

#pragma mark - 开始解析
/**
 *  开始解析
 *
 *  @param url url description
 */
-(void)startParsingWithUrl:(NSURL *)url{
    NSString *scheme = url.scheme;
    if ([scheme hasPrefix:LLSPEED_SCHEME]) {
        [self routeToModule:[LLRoute getModuleInfo:url]];
    }else if ([scheme isEqualToString:@"http"]||[scheme isEqualToString:@"https"]||[scheme isEqualToString:@"ftp"])
    {
        [self parseToOtherLinkWithUrl:url.absoluteString];
    }else if ([scheme isEqualToString:@"tel"])
    {
        [self parseToPhoneCallWithUrl:url.absoluteString];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"链接地址错误" message:url.absoluteString delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - 解析到对应的模块
/**
 *  解析模块  (内部)
 *
 *  @param moduleInfo url description
 */
-(void)routeToModule:(LLModuleInfo*)moduleInfo{
    if ([moduleInfo.moduleName isEqualToString:@"game"]) {
        //
        [self routeToGameWithModule:moduleInfo];
    }
    
}
/**
 *  解析为外部链接
 *
 *  @param url url description
 */
-(void)parseToOtherLinkWithUrl:(NSString*)url{
    
}

/**
 *  拨打电话
 *
 *  @param url url description
 */
-(void)parseToPhoneCallWithUrl:(NSString*)url{
    UIWebView*callWebview =[[UIWebView alloc] init] ;
    NSURL *telURL =[NSURL URLWithString:url];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.currentVC.view addSubview:callWebview];
}


- (void)routeToGameWithModule:(LLModuleInfo*)moduleInfo{
    //开始
    if ([moduleInfo.page isEqualToString:@"/begin"]) {
        [LLSpeedRoute pushToGameBeginWithCurrVC:self.currentVC];
        return;
    }
    //菜单
    if ([moduleInfo.page isEqualToString:@"/menu"]) {
        [LLSpeedRoute pushToGameMenuWithCurrVC:self.currentVC];
        return;
    }
    //关于
    if ([moduleInfo.page isEqualToString:@"/about"]) {
        [LLSpeedRoute pushToGameAboutWithCurrVC:self.currentVC];
        return;
    }
}

//开始
+ (void)pushToGameBeginWithCurrVC:(UIViewController *)currVC{
    LLSpeedGameViewController *vc = [[LLSpeedGameViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [currVC.navigationController pushViewController:vc animated:YES];
}

//菜单
+ (void)pushToGameMenuWithCurrVC:(UIViewController *)currVC{
    LLSpeedMenuViewController *vc = [[LLSpeedMenuViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [currVC.navigationController pushViewController:vc animated:YES];
}

//关于
+ (void)pushToGameAboutWithCurrVC:(UIViewController *)currVC{
    LLSpeedAboutViewController *vc = [[LLSpeedAboutViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [currVC.navigationController pushViewController:vc animated:YES];
}


@end


调用 


//开始游戏
- (IBAction)gameBeginAction:(id)sender {
 //方式一 （）
//    [LLSpeedRoute routeWithUrl:[NSURL URLWithString:llspeed_routeWithBegin] currentVC:self hidesBottomBarWhenPushed:YES parameterDict:nil]; 
 //方式二  （推荐）
    [LLRoute routeWithUrl:[NSURL URLWithString:llspeed_routeWithBegin] currentVC:self hidesBottomBarWhenPushed:YES parameterDict:nil];
}





