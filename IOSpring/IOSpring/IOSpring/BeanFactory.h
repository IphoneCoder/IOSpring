//
//  BeanFactory.h
//  AOPProxy
//
//  Created by 汪亚强 on 15-2-10.
//
//

#import <Foundation/Foundation.h>
#import "Configuration.h"
@protocol BeanFactory <NSObject>
-(id)getBean:(NSString *)beanIdentify;
@end
