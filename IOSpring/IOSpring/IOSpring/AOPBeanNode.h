//
//  AOPBeanNode.h
//  AOPProxy
//
//  Created by 汪亚强 on 15-2-10.
//
//

#import <Foundation/Foundation.h>
#import "AOPNode.h"
@interface AOPBeanNode : AOPNode
@property(nonatomic,strong)NSString *beanNodeID;
@property(nonatomic,strong)NSString *beanNodeClass;
@property(nonatomic,strong)NSString *namespaceStr;

@end
