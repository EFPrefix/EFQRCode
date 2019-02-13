#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, MSFlags) {
  MSFlagsNone = (0 << 0),                // => 00000000
  MSFlagsPersistenceNormal = (1 << 0),   // => 00000001
  MSFlagsPersistenceCritical = (1 << 1), // => 00000010
  MSFlagsDefault = MSFlagsPersistenceNormal
};
