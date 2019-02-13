#import <Foundation/Foundation.h>

/**
 *  Log Levels
 */
typedef NS_ENUM(NSUInteger, MSLogLevel) {

  /**
   *  Logging will be very chatty
   */
  MSLogLevelVerbose = 2,

  /**
   *  Debug information will be logged
   */
  MSLogLevelDebug = 3,

  /**
   *  Information will be logged
   */
  MSLogLevelInfo = 4,

  /**
   *  Errors and warnings will be logged
   */
  MSLogLevelWarning = 5,

  /**
   *  Errors will be logged
   */
  MSLogLevelError = 6,

  /**
   * Only critical errors will be logged
   */
  MSLogLevelAssert = 7,

  /**
   *  Logging is disabled
   */
  MSLogLevelNone = 99
};

typedef NSString * (^MSLogMessageProvider)(void);
typedef void (^MSLogHandler)(MSLogMessageProvider messageProvider, MSLogLevel logLevel, NSString *tag, const char *file,
                             const char *function, uint line);

/**
 * Channel priorities, check the kMSPriorityCount if you add a new value.
 * The order matters here! Values NEED to range from low priority to high priority.
 */
typedef NS_ENUM(NSInteger, MSPriority) { MSPriorityBackground, MSPriorityDefault, MSPriorityHigh };
static short const kMSPriorityCount = MSPriorityHigh + 1;

/**
 * The priority by which the modules are initialized.
 * MSPriorityMax is reserved for only 1 module and this needs to be Crashes.
 * Crashes needs to be initialized first to catch crashes in our other SDK Modules (which will hopefully never happen) and to avoid losing
 * any log at crash time.
 */
typedef NS_ENUM(NSInteger, MSInitializationPriority) {
  MSInitializationPriorityDefault = 500,
  MSInitializationPriorityHigh = 750,
  MSInitializationPriorityMax = 999
};
