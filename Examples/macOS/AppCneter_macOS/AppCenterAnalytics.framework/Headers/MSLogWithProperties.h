#import <Foundation/Foundation.h>

#import "MSAbstractLog.h"

@interface MSLogWithProperties : MSAbstractLog

/**
 * Additional key/value pair parameters. [optional]
 */
@property(nonatomic) NSDictionary<NSString *, NSString *> *properties;

@end
