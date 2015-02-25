//
//  AspectTarget.m
//  IOSpring
//
//  Created by 汪亚强 on 15-2-25.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "AspectTarget.h"

@implementation AspectTarget
-(void)customerAspectBeforMethodA
{
    NSLog(@"customerAspectBeforMethodA");
}
-(void)customerAspectAfterMethodA
{
    NSLog(@"customerAspectAfterMethodA");
}
@end
