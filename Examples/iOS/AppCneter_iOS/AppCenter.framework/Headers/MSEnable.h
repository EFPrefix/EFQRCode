#import <Foundation/Foundation.h>

/**
 * Protocol to define an instance that can be enabled/disabled.
 */
@protocol MSEnable <NSObject>

@required

/**
 * Enable/disable this instance and delete data on disabled state.
 *
 * @param isEnabled  A boolean value set to YES to enable the instance or NO to disable it.
 * @param deleteData A boolean value set to YES to delete data or NO to keep it.
 */
- (void)setEnabled:(BOOL)isEnabled andDeleteDataOnDisabled:(BOOL)deleteData;

@end
