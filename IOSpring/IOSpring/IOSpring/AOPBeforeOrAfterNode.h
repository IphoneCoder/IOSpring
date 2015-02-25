//
//  AOPBeforeOrAfterNode.h
//  IOSpring
//
//  Created by 汪亚强 on 15-2-10.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "AOPNode.h"

@interface AOPBeforeOrAfterNode : AOPNode
@property(nonatomic,strong)NSString *nodeMethod;
@property(nonatomic,strong)NSString *nodePointcut_ref;
@end
