//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import <SignalMessaging/OWSViewController.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ConversationViewAction) {
    ConversationViewActionNone,
    ConversationViewActionCompose,
    ConversationViewActionAudioCall,
    ConversationViewActionVideoCall,
};

@class TSThread;
@class ConversationViewItem;

@interface ConversationViewController : OWSViewController

@property (nonatomic, readonly) TSThread *thread;
@property (nonatomic, readonly) AVAudioRecorder *audioRecorder;

- (void)configureForThread:(TSThread *)thread
                    action:(ConversationViewAction)action
            focusMessageId:(nullable NSString *)focusMessageId;

- (void)popKeyBoard;
- (void)tryToSendOperationText:(NSString *) opText;
- (void)tryToSendRedPocketAck:(NSString *) ackText;
- (void)makeConversationItemPicked:(ConversationViewItem *)viewItem;

#pragma mark Open access

- (void)takePictureOrVideo;
- (void)chooseFromLibraryAsMedia;
- (void)tryToSendTextMessage:(NSString *)text updateKeyboardState:(BOOL)updateKeyboardState;
- (void)voiceMemoGestureDidStart;
- (void)voiceMemoGestureDidEnd;
- (void)voiceMemoGestureDidCancel;

#pragma mark 3D Touch Methods

- (void)peekSetup;
- (void)popped;

@end

NS_ASSUME_NONNULL_END
