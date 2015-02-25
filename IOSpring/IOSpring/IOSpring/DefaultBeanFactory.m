//
//  DefaultBeanFactory.m
//  AOPProxy
//
//  Created by 汪亚强 on 15-2-10.
//
//

#import "DefaultBeanFactory.h"
#import "AOPAspectNode.h"
#import "AOPConfiguratonNode.h"
#import "AOPBeforeNode.h"
#import "AOPAfterNode.h"
#import "AOPPointcutNode.h"
#import "AOPBeanNode.h"
@implementation DefaultBeanFactory
@synthesize configuration;
-(void)initializeWithClass:(Class)class
{
    self.proxy=[AOPProxy proxyWithClass:class];
    
}
-(id)initWithConfiguration:(Configuration *)conf
{
    self=[super init];
    if (self) {
        self.configuration=conf;
    }
    return self;
}
-(id)getBean: (NSString *)beanIdentify
{
    if (beanIdentify==nil) {
        return nil;
    }
    AOPBeanNode *beanNode=[self.configuration.beansDic objectForKey:beanIdentify];
    //id  classStr=[self.configuration.beansDic objectForKey:beanIdentify];
    id classStr=beanNode.beanNodeClass;
    if (classStr==nil) {
        return nil;
    }
    Class class=NSClassFromString(classStr);
    if (class==nil) {
        NSString *reason=[NSString stringWithFormat:@"class=%@ can not find",classStr];
        NSException *exception=[NSException exceptionWithName:@"DefaultBeanFactory" reason:reason userInfo:nil];
        @throw exception;
    }
    [self initializeWithClass:class];
    for (AOPConfiguratonNode *node in self.configuration.aopConfigsArray) {
        [node.aopAspectNodeDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (![obj isKindOfClass:[AOPAspectNode class]]) {
                *stop=YES;
                return;
            }
            AOPAspectNode *aspectNode=(AOPAspectNode *)obj;

                [aspectNode.pointcutDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    AOPPointcutNode *pointNode=(AOPPointcutNode *)obj;
                    NSString *expression=pointNode.pointCutStr;
                    NSArray *splitArray=[expression componentsSeparatedByString:@"|"];
                    NSMutableString *appendStr=[NSMutableString stringWithCapacity:0];
                    for(int i=0;i<splitArray.count;i++)
                    {
                        NSString *str=[splitArray objectAtIndex:i];
                        if (i==0||i==1) {
                            [appendStr appendString:str];
                            [appendStr appendString:@"."];
                        }
                    }
                    NSString *pointCutMethodName=[splitArray lastObject];
                    NSString *match =[appendStr substringToIndex:appendStr.length-1];
                    
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[cd] %@", match];
                    
                    NSString *aaa=[NSString stringWithFormat:@"%@.%@",beanNode.namespaceStr,beanNode.beanNodeID];
                     BOOL  results = [predicate evaluateWithObject:aaa];
                    if (results==YES) {
                        NSString *ref= [aspectNode.attributeInfoDic objectForKey:@"ref"];
                        if (ref!=nil) {
                            AOPBeanNode *tempNode=[self.configuration.beansDic objectForKey:ref];
                            id tempClassStr=tempNode.beanNodeClass;
                            Class tempClass=NSClassFromString(tempClassStr);
                            if (tempClass!=nil) {
                                id target=[[tempClass alloc]init];
                                if (pointNode.beforePointcutDic!=nil) {
                                    [pointNode.beforePointcutDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                        if (![obj isKindOfClass:[AOPBeforeOrAfterNode class]]) {
                                            *stop=YES;
                                            return;
                                        }
                                        AOPBeforeOrAfterNode *bfNode=(AOPBeforeOrAfterNode *)obj;
                                        SEL sel=NSSelectorFromString(bfNode.nodeMethod);
                                        SEL ori=NSSelectorFromString(pointCutMethodName);
                                        [self.proxy interceptMethodStartForSelector:ori withInterceptorTarget:target interceptorSelector:sel];
                                    }];
                                    
                                }
                                if (pointNode.afterPointcutDic!=nil) {
                                    [pointNode.afterPointcutDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                        if (![obj isKindOfClass:[AOPBeforeOrAfterNode class]]) {
                                            *stop=YES;
                                            return;
                                        }
                                        AOPBeforeOrAfterNode *bfNode=(AOPBeforeOrAfterNode *)obj;
                                        SEL sel=NSSelectorFromString(bfNode.nodeMethod);
                                        SEL ori=NSSelectorFromString(pointCutMethodName);
                                        [self.proxy interceptMethodEndForSelector:ori withInterceptorTarget:target interceptorSelector:sel];
                                    }];
                                    
                                }
                            }
                        }

                    }

                }];

        }];
    }
    return self.proxy;
}
@end
