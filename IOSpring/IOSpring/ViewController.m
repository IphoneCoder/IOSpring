//
//  ViewController.m
//  IOSpring
//
//  Created by 汪亚强 on 15-2-10.
//  Copyright (c) 2015年 bitcar. All rights reserved.
//

#import "ViewController.h"
#import "XMLConfigBuilder.h"
#import "Configuration.h"
#import "DefaultBeanFactory.h"
#import "CustomerAspectTest.h"
#import "CustomerTest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testXMLParse];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)testXMLParse {
    Configuration *config=[[Configuration alloc]init];
    NSBundle *bundle=[NSBundle bundleForClass:[self class]];
    NSString *resource=[bundle pathForResource:@"conf" ofType:@"xml"];
    XMLConfigBuilder *bulider=[[XMLConfigBuilder alloc]initXMLConfigBuilderWithInputData:[NSData dataWithContentsOfFile:resource] configuration:config];
    [bulider parse];
    NSLog(@"%@",config);
    DefaultBeanFactory *defaultBeanFactory=[[DefaultBeanFactory alloc]initWithConfiguration:config];
    CustomerAspectTest * bean=[defaultBeanFactory getBean:@"com.customer.customerAspect"];
    [bean execute];
    
    CustomerTest *customerTest=[defaultBeanFactory getBean:@"com.customer.customerTest"];
    [customerTest testA];
    
    [customerTest execute];
    
}
@end
