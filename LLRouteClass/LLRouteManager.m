//
//  LLRouteManager.m
//  LLRoute
//
//  Created by Lilong on 2017/10/10.
//

#import "LLRouteManager.h"

@implementation LLRouteManager


+ (instancetype)sharedManager{
    static LLRouteManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[LLRouteManager alloc] init];
        
    });
    return _manager;
}

- (NSMutableDictionary *)routeDict{
    if (!_routeDict) {
        _routeDict = [[NSMutableDictionary alloc] init];
    }
    return _routeDict;
}


/**
 路线注册  存在在字典中
 
 注意 注册的路径需要存在这个方法
 +(NSString *)routeName
 {
 return ROUTE_NAME;
 }

 @param routeClass 路径文件类型
 */
- (void)registerRoute:(Class)routeClass{
    if (routeClass) {
        NSString *routeName = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL routeNameSelector = @selector(routeName);
#pragma clang diagnostic pop
        if(routeClass && [routeClass respondsToSelector:routeNameSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            routeName = [routeClass performSelector:routeNameSelector];//获取组件名
#pragma clang diagnostic pop
        }
        if (routeName) {
            [self.routeDict setObject:routeClass forKey:routeName];
        }
        NSLog(@"注册的路径名称为 =%@  路径文件为 = %@",routeName,routeClass);
    }
}
@end
