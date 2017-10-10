//
//  LLRoute.m
//  Pods
//
//  Created by Lilong on 2017/6/25.
//
//

#import "LLRoute.h"
#import "LLRouteManager.h"

@implementation LLModuleInfo

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.moduleName = url.host;
        self.page = url.path;
        NSString *query = url.query;
        if (query) {
            NSMutableDictionary *param = [@{}mutableCopy];
            NSURLComponents *urlc = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
            NSArray *parameterArray = urlc.queryItems;
            for (NSURLQueryItem *queryItem in parameterArray) {
                [param setObject:queryItem.value forKey:queryItem.name];
            }
            self.parameter = param;
        }
    }
    return self;
}
@end


@implementation LLRoute
/**
 跳转前缀
 */
+(NSString *)routeName
{
    return @"llrout";
}

/**
 组件scheme跳转   子类重新 参考！！！！！！
 
 @param schemeStr scheme参数
 @param dic 其他特殊参数
 */
+ (void)routeToScheme:(NSString *)schemeStr parameter:(NSMutableDictionary *)dic{
    UIViewController *vc = [dic objectForKey:@"currentVC"];
    NSLog(@"currvc class = %@",[vc class]);
    NSString *hidesBottomStr = [dic objectForKey:@"hidesBottom"];
    BOOL hidesBottom;
    if ([hidesBottomStr isEqualToString:@"YES"]) {
        hidesBottom = YES;
    }else{
        hidesBottom = NO;
    }
}

/**
 路径跳转

 @param url 跳转的url
 @param currentVC 当前跳转的UIViewController
 @param hidesBottomBarWhenPushed 是否隐藏tabbar
 @param parameterDict 需要传递的参数
 */
+ (LLRoute *)routeWithUrl:(NSURL *)url currentVC:(UIViewController *)currentVC hidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed parameterDict:(NSMutableDictionary *)parameterDict{
    LLRoute *route = [[LLRoute alloc] initWithUrl:url currentVC:currentVC hidesBottomBarWhenPushed:hidesBottomBarWhenPushed parameterDict:parameterDict];
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

/**
 解析Url
 */
-(LLModuleInfo *)getModuleInfo:(NSURL *)url{
    return  [[LLModuleInfo alloc] initWithURL:url];
}

#pragma mark - 开始解析

/**
 *  开始解析
 *
 *  @param url url description
 */
- (void)startParsingWithUrl:(NSURL *)url{
    NSString *scheme = url.scheme;
    NSMutableDictionary *dict = [LLRouteManager sharedManager].routeDict;
    NSArray *routeKeyArr = [dict allKeys];
    //属于注册路径中的跳转
    for (int i = 0; i < routeKeyArr.count; i++) {
        NSString *routeName = routeKeyArr[i];
        if ([scheme hasPrefix:routeName]) {
            Class routeClass = [dict objectForKey:routeName];
            [self routeToSchemeUrl:url routeName:routeName routeClass:routeClass];
            return;
        }
    }
    //属于网页h5跳转
    if ([scheme isEqualToString:@"http"]||[scheme isEqualToString:@"https"]||[scheme isEqualToString:@"ftp"]) {
        [self parseToOtherLinkWithUrl:url.absoluteString];
    }else if ([scheme isEqualToString:@"tel"]){
    //属于拨打电话
        [self parseToPhoneCallWithUrl:url.absoluteString];
    }else{
    //连接有误
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"链接地址错误" message:url.absoluteString delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - 解析到对应的模块
/**
 *  解析模块  (内部) 解析runtime 跳转
 *
 *  @param schemeUrl url
 */
-(void)routeToSchemeUrl:(NSURL *)schemeUrl routeName:(NSString *)routeName routeClass:(Class)routeClass{
    if ([self canOpenURL:schemeUrl]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL routeSelector = @selector(routeToScheme:parameter:);
        
#pragma clang diagnostic pop
        if(routeClass && [routeClass respondsToSelector:routeSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            if (self.currentVC) {
                [newDict setObject:self.currentVC forKey:@"currVC"];
            }
            if (self.hidesBottom) {
                [newDict setObject:@"YES" forKey:@"hidesBottom"];
            }else{
                [newDict setObject:@"NO" forKey:@"hidesBottom"];
            }
            if (self.parameterDict) {
                [newDict setValuesForKeysWithDictionary:self.parameterDict];
            }
            LLModuleInfo *moduleInfo = [self getModuleInfo:schemeUrl];
            if (moduleInfo.parameter) {
                [newDict setValuesForKeysWithDictionary:self.parameterDict];
            }
            [routeClass performSelector:routeSelector withObject:schemeUrl withObject:newDict];
#pragma clang diagnostic pop
        }
    }else{
        //连接有误
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"链接地址错误" message:schemeUrl.scheme delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
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

- (BOOL)canOpenURL:(NSURL *)URL{
    if (URL) {
        return YES;
    }else
    {
        return NO;
    }
}

@end
