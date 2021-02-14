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

#import "RNFBMessagingCompletion.h"

@implementation RNFBMessagingCompletion

static RNFBMessagingCompletion *sharedInstance;

+ (instancetype)shared {
  static dispatch_once_t once;
  static RNFBMessagingCompletion *sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[RNFBMessagingCompletion alloc] init];
  });
  return sharedInstance;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _completionDict = [NSMutableDictionary new];
  }
  return self;
}

- (void)addCompletion:(NSString *)messageId handler:(id)completion {
  [_completionDict setValue:completion forKey:messageId];
}

- (void)completeWillPresentNotification:(NSString *)messageId option:(UNNotificationPresentationOptions)option {
  NSDictionary* completion = [_completionDict objectForKey:messageId];
  if (completion) {
    RNFBMessageNotificationPresentationCompletionHandler handler = [completion objectForKey:@"handler"];
    handler(option);
    
    [_completionDict removeObjectForKey:messageId];
  }
}

- (void)completeFetchResult:(NSString *)messageId result:(UIBackgroundFetchResult)result {
  NSDictionary* completion = [_completionDict objectForKey:messageId];
  if (completion) {
    RNFBMessageFetchResultCompletionHandler handler = [completion objectForKey:@"handler"];
    handler(result);
    
    NSUInteger backgroundTaskId = [[completion objectForKey:@"backgroundTaskId"] integerValue];
    // Stop background task after the longest timeout, async queue is okay to freeze again after handling period
    if (backgroundTaskId != UIBackgroundTaskInvalid) {
      [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
      backgroundTaskId = UIBackgroundTaskInvalid;
    }
    
    [_completionDict removeObjectForKey:messageId];
  }
}

@end
