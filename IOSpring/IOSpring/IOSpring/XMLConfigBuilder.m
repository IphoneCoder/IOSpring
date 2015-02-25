//
//  XMLConfigBuilder.m
//  AOPProxy
//
//  Created by 汪亚强 on 15-2-10.
//
//

#import "XMLConfigBuilder.h"
#import "TBXML.h"
#import "AOPBeanNode.h"
#import "AOPConfiguratonNode.h"
#import "AOPAspectNode.h"
#import "AOPBeforeNode.h"
#import "AOPAfterNode.h"
#import "AOPPointcutNode.h"
@implementation XMLConfigBuilder
@synthesize configuration;
@synthesize inputData;
-(id)initXMLConfigBuilderWithInputData:(NSData *)_inputData configuration:(Configuration *)_configuration
{
    self=[super init];
    if (self) {
        self.configuration=_configuration;
        self.inputData=_inputData;
    }
    return self;
    
}
-(Configuration *)parse
{
    if (self.inputData==nil) {
        NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:@"inputData cont not nil" userInfo:nil];
        @throw exception;
    }
    
  
    NSError *error=nil;
    TBXML *tbxml=[TBXML newTBXMLWithXMLData:self.inputData error:&error];
    if (error!=nil) {
        NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:[NSString stringWithFormat:@"%@",error] userInfo:nil];
        @throw exception;
    }
    [self parseConfiguration:tbxml.rootXMLElement];
    return nil;
}
-(void)parseConfiguration:(TBXMLElement *)rootElement
{
    [self beanNodeElement:rootElement];
    [self beanNodeElementWithNameSpace:rootElement];
    [self configurationNodeElement:[TBXML childElementNamed:@"config" parentElement:rootElement]];
    //[self dataSourceElement:];
}
-(void)beanNodeElementWithNameSpace:(TBXMLElement *)parent
{
    if (self.configuration.namespaceBeanDic==nil) {
        self.configuration.namespaceBeanDic=[NSMutableDictionary dictionaryWithCapacity:0];
    }
    [TBXML iterateElementsForQuery:@"namesapce" fromElement:parent withBlock:^(TBXMLElement *element) {
        [TBXML iterateAttributesOfElement:element withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue) {
            if ([attributeName caseInsensitiveCompare:@"id"]==NSOrderedSame) {
                NSMutableDictionary *oriDic=[self.configuration.namespaceBeanDic objectForKey:attributeValue];
                NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithCapacity:0];
                if (oriDic!=nil) {
                    [mutDic setValuesForKeysWithDictionary:oriDic];
                }
                [TBXML iterateElementsForQuery:@"bean" fromElement:element withBlock:^(TBXMLElement *element) {
                     AOPBeanNode *beanNode=[[AOPBeanNode alloc]init];
                    beanNode.namespaceStr=attributeValue;
                    
                    beanNode.attributeInfoDic=[NSMutableDictionary dictionaryWithCapacity:0];
                    [TBXML iterateAttributesOfElement:element withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue) {
                        if (attributeName==nil||![attributeName isKindOfClass:[NSString class]]||attributeName.length<=0) {
                            NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:@"Attribute Name can not ben null" userInfo:nil];
                            @throw exception;
                        }
                        [beanNode.attributeInfoDic setObject:attributeValue forKey:attributeName];
                        
                    }];
                    id attributeID=[beanNode.attributeInfoDic objectForKey:@"id"];
                    if (attributeID==nil) {
                        NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:@"bean ID  can not ben null" userInfo:nil];
                        @throw exception;
                    }
                    if ([mutDic objectForKey:attributeID]!=nil) {
                        NSString *reason=[NSString stringWithFormat:@"bean id=%@ must be unique",attributeID];
                        NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:reason userInfo:nil];
                        @throw exception;
                    }
                    id beanClass=[beanNode.attributeInfoDic objectForKey:@"class"];
                    if (beanClass!=nil) {
                        beanNode.beanNodeClass=beanClass;
                        beanNode.beanNodeID=attributeID;
                        [mutDic setObject:beanNode forKey:[NSString stringWithFormat:@"%@.%@",beanNode.namespaceStr,attributeID]];
                        [self.configuration.namespaceBeanDic setObject:mutDic forKey:beanNode.namespaceStr];
                        if(self.configuration.beansDic==nil)
                        {
                            self.configuration.beansDic=[NSMutableDictionary dictionaryWithCapacity:0];
                        }
                        [self.configuration.beansDic setObject:beanNode forKey:[NSString stringWithFormat:@"%@.%@",beanNode.namespaceStr,attributeID]];
                    }

                    
                }];
            }
            
        }];
    }];
}
-(void)beanNodeElement:(TBXMLElement *)parent
{
    [TBXML iterateElementsForQuery:@"bean" fromElement:parent withBlock:^(TBXMLElement *element) {
        AOPBeanNode *beanNode=[[AOPBeanNode alloc]init];
        if (self.configuration.beansArray==nil) {
            self.configuration.beansArray=[NSMutableArray arrayWithCapacity:0];
        }
        [self.configuration.beansArray addObject:beanNode];
        beanNode.attributeInfoDic=[NSMutableDictionary dictionaryWithCapacity:0];
        [TBXML iterateAttributesOfElement:element withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue) {
            if (attributeName==nil||![attributeName isKindOfClass:[NSString class]]||attributeName.length<=0) {
                NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:@"Attribute Name can not ben null" userInfo:nil];
                @throw exception;
            }
            [beanNode.attributeInfoDic setObject:attributeValue forKey:attributeName];
            
        }];
        if (self.configuration.beansDic==nil) {
            self.configuration.beansDic=[NSMutableDictionary dictionaryWithCapacity:0];
        }
        id attributeID=[beanNode.attributeInfoDic objectForKey:@"id"];
        if (attributeID==nil) {
            NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:@"bean ID  can not ben null" userInfo:nil];
            @throw exception;
        }
        if ([self.configuration.beansDic objectForKey:attributeID]!=nil) {
            NSString *reason=[NSString stringWithFormat:@"bean id=%@ must be unique",attributeID];
            NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:reason userInfo:nil];
            @throw exception;
        }
        id beanClass=[beanNode.attributeInfoDic objectForKey:@"class"];
        if (beanClass!=nil) {
            beanNode.beanNodeID=attributeID;
            beanNode.beanNodeClass=beanClass;
            [self.configuration.beansDic setObject:beanNode forKey:attributeID];
        }
        
    }];
}
-(void)configurationNodeElement:(TBXMLElement *)parent
{
    AOPConfiguratonNode *aopConfigNode=[[AOPConfiguratonNode alloc]init];
    if (self.configuration.aopConfigsArray==nil) {
        self.configuration.aopConfigsArray=[NSMutableArray arrayWithCapacity:0];
    }
    [self.configuration.aopConfigsArray addObject:aopConfigNode];
    aopConfigNode.aopAspectNodeDic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [TBXML iterateElementsForQuery:@"aspect" fromElement:parent withBlock:^(TBXMLElement *element) {
        AOPAspectNode  *aspectNode=[[AOPAspectNode alloc]init];
        aspectNode.attributeInfoDic=[[NSMutableDictionary alloc]initWithCapacity:0];
        
        [TBXML iterateAttributesOfElement:element withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue) {
            if (attributeName==nil||![attributeName isKindOfClass:[NSString class]]||attributeName.length<=0) {
                NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:@"Attribute Name can not ben null" userInfo:nil];
                @throw exception;
            }
            [aspectNode.attributeInfoDic setObject:attributeValue forKey:attributeName];
           
            if ([attributeName caseInsensitiveCompare:@"id"]==NSOrderedSame) {
                if([aopConfigNode.aopAspectNodeDic objectForKey:attributeValue]!=nil)
                {
                    NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:[NSString stringWithFormat:@"%@ must be unique",attributeValue] userInfo:nil];
                    @throw exception;
                }
                [aopConfigNode.aopAspectNodeDic setObject:aspectNode forKey:attributeValue];
            }
            if ([attributeName caseInsensitiveCompare:@"ref"]==NSOrderedSame) {
                if ([self.configuration.beansDic objectForKey:attributeValue]==nil) {
                    NSString *reason=[NSString stringWithFormat:@"ref=%@ can not found the bean",attributeValue];
                    NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:reason userInfo:nil];
                    @throw exception;
                }
            }
        }];
         AOPPointcutNode *publicNode=nil;
        [self recurrence:element aspectNode:aspectNode pointCutNode:publicNode];
    }];

}
- (void)recurrence:(TBXMLElement *)element aspectNode:(AOPAspectNode *)aspectNode pointCutNode:(AOPPointcutNode *)publicNode {
   
    do {
        TBXMLElement *parentElement=element->parentElement;
        
        
        if (parentElement!=nil&&([[TBXML elementName:parentElement] isEqualToString:@"aspect"]||[[TBXML elementName:parentElement] isEqualToString:@"pointcut"])) {
            if ([[TBXML elementName:element] caseInsensitiveCompare:@"pointcut"]==NSOrderedSame) {
                AOPPointcutNode *aopPointCutNode=[[AOPPointcutNode alloc]init];
                
                publicNode=aopPointCutNode;
                aopPointCutNode.attributeInfoDic=[NSMutableDictionary dictionaryWithCapacity:0];
                [TBXML iterateAttributesOfElement:element withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue) {
                    [aopPointCutNode.attributeInfoDic setObject:attributeValue forKey:attributeName];
                    if ([attributeName caseInsensitiveCompare:@"id"]==NSOrderedSame) {
                        if([aspectNode.pointcutDic objectForKey:attributeValue]!=nil)
                        {
                            NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:[NSString stringWithFormat:@"%@ must be unique",attributeValue] userInfo:nil];
                            @throw exception;
                        }else
                        {
                            if (aspectNode.pointcutDic==nil) {
                                aspectNode.pointcutDic=[NSMutableDictionary dictionaryWithCapacity:0];
                            }
                            [aspectNode.pointcutDic setObject:aopPointCutNode forKey:attributeValue];
                        }
                    }
                    //这里可以对表达式进行进一步处理
                    if ([attributeName caseInsensitiveCompare:@"expression"]==NSOrderedSame) {
                        publicNode.pointCutStr=attributeValue;
                    }
                }];
            }
            if ([[TBXML elementName:element] caseInsensitiveCompare:@"before"]==NSOrderedSame||[[TBXML elementName:element] caseInsensitiveCompare:@"after"]==NSOrderedSame) {
                int temp=-1;
                if ([[TBXML elementName:element] caseInsensitiveCompare:@"before"]==NSOrderedSame) {
                   
                    temp=0;
                }else
                {
                    temp=1;
                }
                AOPBeforeOrAfterNode *beforeNode=[[AOPBeforeOrAfterNode alloc]init];
                beforeNode.attributeInfoDic=[NSMutableDictionary dictionaryWithCapacity:0];
                [TBXML iterateAttributesOfElement:element withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue) {
                    [beforeNode.attributeInfoDic setObject:attributeValue forKey:attributeName];
                    if ([attributeName caseInsensitiveCompare:@"method"]==NSOrderedSame) {
                        
                        beforeNode.nodeMethod=attributeValue;
                        if (temp==0) {
                            if (publicNode.beforePointcutDic==nil) {
                                publicNode.beforePointcutDic=[NSMutableDictionary dictionaryWithCapacity:0];
                              
                            }
                              [publicNode.beforePointcutDic setObject:beforeNode forKey:attributeValue];
                        }else
                        {
                            if (publicNode.afterPointcutDic==nil) {
                                publicNode.afterPointcutDic=[NSMutableDictionary dictionaryWithCapacity:0];
                                
                            }
                            [publicNode.afterPointcutDic setObject:beforeNode forKey:attributeValue];
                        }
                    }
                    if ([attributeName caseInsensitiveCompare:@"pointcut-ref"]==NSOrderedSame) {
                        beforeNode.nodePointcut_ref=attributeValue;
                        if ([aspectNode.pointcutDic objectForKey:attributeValue]==nil) {
                            NSException *exception=[NSException exceptionWithName:@"XMLConfigBuilder" reason:[NSString stringWithFormat:@"%@ can not find",attributeValue] userInfo:nil];
                            @throw exception;
                        }
                    }
                }];
              
            }
           
        }
        
        //迭代处理所有属性
        TBXMLAttribute * attribute = element->firstAttribute;
        while (attribute) {
            attribute = attribute->next;
        }
        
        //递归处理子树
        if (element->firstChild) {
            [self recurrence:element->firstChild aspectNode:aspectNode pointCutNode:publicNode];
        }
        
        //迭代处理兄弟树
    } while ((element = element->nextSibling));
   
}
@end
