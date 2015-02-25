//
//  XMLConfigBuilder.h
//  AOPProxy
//
//  Created by 汪亚强 on 15-2-10.
//
//

#import <Foundation/Foundation.h>
#import "Configuration.h"
@interface XMLConfigBuilder : NSObject
@property(nonatomic,strong)Configuration *configuration;
@property(nonatomic,strong)NSData *inputData;
-(id)initXMLConfigBuilderWithInputData:(NSData *)_inputData configuration:(Configuration *)_configuration;
-(Configuration *)parse;
@end
