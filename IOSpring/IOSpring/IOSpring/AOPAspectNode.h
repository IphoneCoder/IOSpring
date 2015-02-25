//
//  AOPConfigurationNode.h
//  AOPProxy
//
//  Created by 汪亚强 on 15-2-10.
//
//

#import <Foundation/Foundation.h>
#import "AOPNode.h"
@interface AOPAspectNode : AOPNode
@property(nonatomic,strong)NSString * aspectNodeID;
@property(nonatomic,strong)NSString * aspectNodeRef;
@property(nonatomic,strong)NSMutableDictionary *pointcutDic;
@property(nonatomic,strong)NSMutableDictionary *beforePointcutDic;
@property(nonatomic,strong)NSMutableDictionary *afterPointcutDic;
@end
