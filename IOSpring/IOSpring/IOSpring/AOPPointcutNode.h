//
//  AOPPointcutNode.h
//  IOSpring
//
//  Created by 汪亚强 on 15-2-10.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AOPNode.h"
@interface AOPPointcutNode : AOPNode
@property(nonatomic,strong)NSMutableDictionary *beforePointcutDic;
@property(nonatomic,strong)NSMutableDictionary *afterPointcutDic;
@property(nonatomic,strong)NSMutableArray *pointCutArray;//为了以后支持表达式
@property(nonatomic,strong)NSString *pointCutStr;
@end
