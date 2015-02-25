//
//  DefaultBeanFactory.h
//  AOPProxy
//
//  Created by 汪亚强 on 15-2-10.
//
//

#import <Foundation/Foundation.h>
#import "BeanFactory.h"
#import "AOPProxy.h"
#import "Configuration.h"
@interface DefaultBeanFactory : NSObject<BeanFactory>
-(id)initWithConfiguration:(Configuration *)conf;
@property(nonatomic,strong) id   proxy;
@property(nonatomic,strong)Configuration *configuration;
@end
