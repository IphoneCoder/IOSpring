//
//  AOPAfterNode.h
//  IOSpring
//
//  Created by 汪亚强 on 15-2-10.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AOPBeforeOrAfterNode.h"
@interface AOPAfterNode : AOPBeforeOrAfterNode
@property(nonatomic,strong)NSString *afterNodeMethod;
@property(nonatomic,strong)NSString *afterNodePointcut_ref;
@end
