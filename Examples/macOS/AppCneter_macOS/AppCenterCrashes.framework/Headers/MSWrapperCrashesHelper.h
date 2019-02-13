#import <Foundation/Foundation.h>

#import "MSCrashHandlerSetupDelegate.h"

@class MSErrorReport;
@class MSErrorAttachmentLog;

/**
 * This general class allows wrappers to supplement the Crashes SDK with their own behavior.
 */
@interface MSWrapperCrashesHelper : NSObject

/**
 * Sets the crash handler setup delegate.
 *
 * @param delegate The delegate to set.
 */
+ (void)setCrashHandlerSetupDelegate:(id<MSCrashHandlerSetupDelegate>)delegate;

/**
 * Gets the crash handler setup delegate.
 *
 * @return The delegate being used by Crashes.
 */
+ (id<MSCrashHandlerSetupDelegate>)getCrashHandlerSetupDelegate;

/**
 * Enables or disables automatic crash processing.
 *
 * @param automaticProcessing Passing NO causes SDK not to send reports immediately, even if "Always Send" is true.
 */
+ (void)setAutomaticProcessing:(BOOL)automaticProcessing;

/**
 * Gets a list of unprocessed crash reports. Will block until the service starts.
 *
 * @return An array of unprocessed error reports.
 */
+ (NSArray<MSErrorReport *> *)unprocessedCrashReports;

/**
 * Resumes processing for a given subset of the unprocessed reports.
 *
 * @param filteredIds An array containing the errorId/incidentIdentifier of each report that should be sent.
 *
 * @return YES if should "Always Send" is true.
 */
+ (BOOL)sendCrashReportsOrAwaitUserConfirmationForFilteredIds:(NSArray<NSString *> *)filteredIds;

/**
 * Sends error attachments for a particular error report.
 *
 * @param errorAttachments An array of error attachments that should be sent.
 * @param incidentIdentifier The identifier of the error report that the attachments will be associated with.
 */
+ (void)sendErrorAttachments:(NSArray<MSErrorAttachmentLog *> *)errorAttachments withIncidentIdentifier:(NSString *)incidentIdentifier;

@end
