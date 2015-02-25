//
//  Configuration.h
//  AOPProxy
//
//  Created by 汪亚强 on 15-2-10.
//
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject
@property(nonatomic,strong)NSMutableArray *aopConfigsArray;//存放所有配置的aop:config结点
@property(nonatomic,strong)NSMutableArray *beansArray;//存放所有配置的bean结点
@property(nonatomic,strong)NSMutableDictionary *beansDic;//存放所有配置的bean结点
@property(nonatomic,strong)NSMutableDictionary *aopConfigsDic;//存放所有配置的aop:config结点
@property(nonatomic,strong)NSMutableDictionary *namespaceBeanDic;
@end
