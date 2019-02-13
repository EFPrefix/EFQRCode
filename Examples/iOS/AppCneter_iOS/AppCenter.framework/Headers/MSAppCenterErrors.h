#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Domain

extern NSString *const kMSACErrorDomain;

#pragma mark - Log

// Error codes
NS_ENUM(NSInteger){kMSACLogInvalidContainerErrorCode = 1};

// Error descriptions
extern NSString const *kMSACLogInvalidContainerErrorDesc;

#pragma mark - Connection

// Error codes
NS_ENUM(NSInteger){kMSACConnectionPausedErrorCode = 100, kMSACConnectionHttpErrorCode = 101};

// Error descriptions
extern NSString const *kMSACConnectionHttpErrorDesc;
extern NSString const *kMSACConnectionPausedErrorDesc;

// Error user info keys
extern NSString const *kMSACConnectionHttpCodeErrorKey;

NS_ASSUME_NONNULL_END
