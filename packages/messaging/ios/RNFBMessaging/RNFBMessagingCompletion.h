//
/**
 * Copyright (c) 2016-present Invertase Limited & Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this library except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <Firebase/Firebase.h>

typedef void (^RNFBMessageNotificationPresentationCompletionHandler)(UNNotificationPresentationOptions option);
typedef void (^RNFBMessageFetchResultCompletionHandler)(UIBackgroundFetchResult result);

@interface RNFBMessagingCompletion: NSObject

/**
 * Returns the shared instance
 *
 * @returns RNFBMessagingCompletion.
 */
+ (RNFBMessagingCompletion *)shared;

@property(nonatomic, strong) NSMutableDictionary<NSString *, id> *completionDict;

- (void)addCompletion:(NSString*)messageId handler:(id)completion;
- (void)completeWillPresentNotification:(NSString*)messageId option:(UNNotificationPresentationOptions)option;
- (void)completeFetchResult:(NSString*)messageId result:(UIBackgroundFetchResult)result;
@end
