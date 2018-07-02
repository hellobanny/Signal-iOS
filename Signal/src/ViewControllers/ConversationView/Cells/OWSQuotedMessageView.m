//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import "OWSQuotedMessageView.h"
#import "ConversationViewItem.h"
#import "Environment.h"
#import "OWSBubbleShapeView.h"
#import "Signal-Swift.h"
#import <SignalMessaging/OWSContactsManager.h>
#import <SignalMessaging/SignalMessaging-Swift.h>
#import <SignalMessaging/UIColor+OWS.h>
#import <SignalMessaging/UIView+OWS.h>
#import <SignalServiceKit/TSAttachmentStream.h>
#import <SignalServiceKit/TSMessage.h>
#import <SignalServiceKit/TSQuotedMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSQuotedMessageView ()

@property (nonatomic, readonly) OWSQuotedReplyModel *quotedMessage;
@property (nonatomic, nullable, readonly) DisplayableText *displayableQuotedText;
@property (nonatomic, readonly) ConversationStyle *conversationStyle;

@property (nonatomic, readonly) BOOL isForPreview;
@property (nonatomic, readonly) BOOL isOutgoing;

@property (nonatomic, readonly) UILabel *quotedAuthorLabel;
@property (nonatomic, readonly) UILabel *quotedTextLabel;

@end

#pragma mark -

@implementation OWSQuotedMessageView

+ (OWSQuotedMessageView *)quotedMessageViewForConversation:(OWSQuotedReplyModel *)quotedMessage
                                     displayableQuotedText:(nullable DisplayableText *)displayableQuotedText
                                         conversationStyle:(ConversationStyle *)conversationStyle
                                                isOutgoing:(BOOL)isOutgoing
{
    OWSAssert(quotedMessage);

    return [[OWSQuotedMessageView alloc] initWithQuotedMessage:quotedMessage
                                         displayableQuotedText:displayableQuotedText
                                             conversationStyle:conversationStyle
                                                  isForPreview:NO
                                                    isOutgoing:isOutgoing];
}

+ (OWSQuotedMessageView *)quotedMessageViewForPreview:(OWSQuotedReplyModel *)quotedMessage
                                    conversationStyle:(ConversationStyle *)conversationStyle
{
    OWSAssert(quotedMessage);

    DisplayableText *_Nullable displayableQuotedText = nil;
    if (quotedMessage.body.length > 0) {
        displayableQuotedText = [DisplayableText displayableText:quotedMessage.body];
    }

    OWSQuotedMessageView *instance = [[OWSQuotedMessageView alloc] initWithQuotedMessage:quotedMessage
                                                                   displayableQuotedText:displayableQuotedText
                                                                       conversationStyle:conversationStyle
                                                                            isForPreview:YES
                                                                              isOutgoing:YES];
    [instance createContents];
    return instance;
}

- (instancetype)initWithQuotedMessage:(OWSQuotedReplyModel *)quotedMessage
                displayableQuotedText:(nullable DisplayableText *)displayableQuotedText
                    conversationStyle:(ConversationStyle *)conversationStyle
                         isForPreview:(BOOL)isForPreview
                           isOutgoing:(BOOL)isOutgoing
{
    self = [super init];

    if (!self) {
        return self;
    }

    OWSAssert(quotedMessage);

    _quotedMessage = quotedMessage;
    _displayableQuotedText = displayableQuotedText;
    _isForPreview = isForPreview;
    _conversationStyle = conversationStyle;
    _isOutgoing = isOutgoing;

    _quotedAuthorLabel = [UILabel new];
    _quotedTextLabel = [UILabel new];

    return self;
}

- (BOOL)hasQuotedAttachment
{
    return (self.quotedMessage.contentType.length > 0
        && ![OWSMimeTypeOversizeTextMessage isEqualToString:self.quotedMessage.contentType]);
}

- (BOOL)hasQuotedAttachmentThumbnailImage
{
    return (self.quotedMessage.contentType.length > 0
        && ![OWSMimeTypeOversizeTextMessage isEqualToString:self.quotedMessage.contentType] &&
        [TSAttachmentStream hasThumbnailForMimeType:self.quotedMessage.contentType]);
}

- (UIColor *)highlightColor
{
    BOOL isQuotingSelf = [NSObject isNullableObject:self.quotedMessage.authorId equalTo:TSAccountManager.localNumber];
    return (isQuotingSelf ? self.conversationStyle.bubbleColorOutgoingSent : [UIColor colorWithRGBHex:0xB5B5B5]);
}

#pragma mark -

- (CGFloat)bubbleHMargin
{
    return 6.f;
}

- (CGFloat)hSpacing
{
    return 8.f;
}

- (CGFloat)stripeThickness
{
    return 4.f;
}

- (void)createContents
{
    // Ensure only called once.
    OWSAssert(self.subviews.count < 1);

    self.userInteractionEnabled = YES;
    self.layoutMargins = UIEdgeInsetsZero;
    self.clipsToBounds = YES;

    CAShapeLayer *maskLayer = [CAShapeLayer new];
    OWSLayerView *innerBubbleView = [[OWSLayerView alloc]
         initWithFrame:CGRectZero
        layoutCallback:^(UIView *layerView) {
            CGRect layerFrame = layerView.bounds;

            UIBezierPath *bezierPath = [UIBezierPath new];

            CGFloat bubbleLeft = 0.f;
            CGFloat bubbleRight = layerFrame.size.width;
            CGFloat bubbleTop = 0.f;
            CGFloat bubbleBottom = layerFrame.size.height;
            // TODO:
            CGFloat bubbleTopRounding = 12.f;
            CGFloat bubbleBottomRounding = 12.f;

            [bezierPath moveToPoint:CGPointMake(bubbleLeft + bubbleTopRounding, bubbleTop)];
            [bezierPath addLineToPoint:CGPointMake(bubbleRight - bubbleTopRounding, bubbleTop)];
            [bezierPath addQuadCurveToPoint:CGPointMake(bubbleRight, bubbleTop + bubbleTopRounding)
                               controlPoint:CGPointMake(bubbleRight, bubbleTop)];
            [bezierPath addLineToPoint:CGPointMake(bubbleRight, bubbleBottom - bubbleBottomRounding)];
            [bezierPath addQuadCurveToPoint:CGPointMake(bubbleRight - bubbleBottomRounding, bubbleBottom)
                               controlPoint:CGPointMake(bubbleRight, bubbleBottom)];
            [bezierPath addLineToPoint:CGPointMake(bubbleLeft + bubbleBottomRounding, bubbleBottom)];
            [bezierPath addQuadCurveToPoint:CGPointMake(bubbleLeft, bubbleBottom - bubbleBottomRounding)
                               controlPoint:CGPointMake(bubbleLeft, bubbleBottom)];
            [bezierPath addLineToPoint:CGPointMake(bubbleLeft, bubbleTop + bubbleTopRounding)];
            [bezierPath addQuadCurveToPoint:CGPointMake(bubbleLeft + bubbleTopRounding, bubbleTop)
                               controlPoint:CGPointMake(bubbleLeft, bubbleTop)];

            maskLayer.path = bezierPath.CGPath;
        }];
    innerBubbleView.layer.mask = maskLayer;
    // TODO: Color.
    innerBubbleView.backgroundColor = [[UIColor ows_cyan800Color] colorWithAlphaComponent:0.25f];
    [self addSubview:innerBubbleView];
    [innerBubbleView autoPinLeadingToSuperviewMarginWithInset:self.bubbleHMargin];
    [innerBubbleView autoPinTrailingToSuperviewMarginWithInset:self.bubbleHMargin];
    [innerBubbleView autoPinTopToSuperviewMargin];
    [innerBubbleView autoPinBottomToSuperviewMargin];

    UIStackView *hStackView = [UIStackView new];
    hStackView.axis = UILayoutConstraintAxisHorizontal;
    hStackView.spacing = self.hSpacing;
    [innerBubbleView addSubview:hStackView];
    [hStackView autoPinToSuperviewEdges];

    UIView *stripeView = [UIView new];
    // TODO: Color.
    stripeView.backgroundColor = [UIColor ows_cyan800Color];
    [stripeView autoSetDimension:ALDimensionWidth toSize:self.stripeThickness];
    [stripeView setContentHuggingHigh];
    [stripeView setCompressionResistanceHigh];
    [hStackView addArrangedSubview:stripeView];

    UIStackView *vStackView = [UIStackView new];
    vStackView.axis = UILayoutConstraintAxisVertical;
    vStackView.layoutMargins = UIEdgeInsetsMake(self.textVMargin, 0, self.textVMargin, 0);
    vStackView.layoutMarginsRelativeArrangement = YES;
    [hStackView addArrangedSubview:vStackView];

    UILabel *quotedAuthorLabel = [self configureQuotedAuthorLabel];
    [vStackView addArrangedSubview:quotedAuthorLabel];
    [quotedAuthorLabel autoSetDimension:ALDimensionHeight toSize:self.quotedAuthorHeight];
    [quotedAuthorLabel setContentHuggingVerticalHigh];
    [quotedAuthorLabel setContentHuggingHorizontalLow];
    [quotedAuthorLabel setCompressionResistanceHorizontalLow];

    UILabel *quotedTextLabel = [self configureQuotedTextLabel];
    [vStackView addArrangedSubview:quotedTextLabel];
    [quotedTextLabel setContentHuggingLow];
    [quotedTextLabel setCompressionResistanceLow];

    if (self.hasQuotedAttachment) {
        UIView *_Nullable quotedAttachmentView = nil;
        UIImage *_Nullable thumbnailImage = [self tryToLoadThumbnailImage];
        if (thumbnailImage) {
            quotedAttachmentView = [self imageViewForImage:thumbnailImage];
            quotedAttachmentView.clipsToBounds = YES;
            quotedAttachmentView.backgroundColor = [UIColor whiteColor];

            if (self.isVideoAttachment) {
                UIImage *contentIcon = [UIImage imageNamed:@"attachment_play_button"];
                contentIcon = [contentIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *contentImageView = [self imageViewForImage:contentIcon];
                contentImageView.tintColor = [UIColor whiteColor];
                [quotedAttachmentView addSubview:contentImageView];
                [contentImageView autoCenterInSuperview];
            }
        } else if (self.quotedMessage.thumbnailDownloadFailed) {
            // TODO design review icon and color
            UIImage *contentIcon =
                [[UIImage imageNamed:@"btnRefresh--white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *contentImageView = [self imageViewForImage:contentIcon];
            contentImageView.contentMode = UIViewContentModeScaleAspectFit;
            contentImageView.tintColor = UIColor.whiteColor;

            quotedAttachmentView = [UIView containerView];
            [quotedAttachmentView addSubview:contentImageView];
            quotedAttachmentView.backgroundColor = self.highlightColor;
            [contentImageView autoCenterInSuperview];
            [contentImageView
                autoSetDimensionsToSize:CGSizeMake(self.quotedAttachmentSize * 0.5f, self.quotedAttachmentSize * 0.5f)];

            UITapGestureRecognizer *tapGesture =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFailedThumbnailDownload:)];
            [quotedAttachmentView addGestureRecognizer:tapGesture];
            quotedAttachmentView.userInteractionEnabled = YES;
        } else {
            UIImage *contentIcon = [UIImage imageNamed:@"generic-attachment"];
            UIImageView *contentImageView = [self imageViewForImage:contentIcon];
            contentImageView.contentMode = UIViewContentModeScaleAspectFit;

            UIView *wrapper = [UIView containerView];
            [wrapper addSubview:contentImageView];
            [contentImageView autoCenterInSuperview];
            [contentImageView autoSetDimension:ALDimensionWidth toSize:self.quotedAttachmentSize * 0.5f];
            quotedAttachmentView = wrapper;
        }

        [quotedAttachmentView autoSetDimension:ALDimensionWidth toSize:self.quotedAttachmentSize];
        [quotedAttachmentView setContentHuggingHigh];
        [quotedAttachmentView setCompressionResistanceHigh];
        [hStackView addArrangedSubview:quotedAttachmentView];
    } else {
        // If there's no attachment, add an empty view so that
        // the stack view's spacing serves as a margin between
        // the text views and the trailing edge.
        UIView *emptyView = [UIView containerView];
        [hStackView addArrangedSubview:emptyView];
        [emptyView setContentHuggingHigh];
        [emptyView autoSetDimension:ALDimensionWidth toSize:0.f];
    }
}

- (void)didTapFailedThumbnailDownload:(UITapGestureRecognizer *)gestureRecognizer
{
    DDLogDebug(@"%@ in didTapFailedThumbnailDownload", self.logTag);

    if (!self.quotedMessage.thumbnailDownloadFailed) {
        OWSFail(@"%@ in %s thumbnailDownloadFailed was unexpectedly false", self.logTag, __PRETTY_FUNCTION__);
        return;
    }

    if (!self.quotedMessage.thumbnailAttachmentPointer) {
        OWSFail(@"%@ in %s thumbnailAttachmentPointer was unexpectedly nil", self.logTag, __PRETTY_FUNCTION__);
        return;
    }

    [self.delegate didTapQuotedReply:self.quotedMessage
        failedThumbnailDownloadAttachmentPointer:self.quotedMessage.thumbnailAttachmentPointer];
}

- (nullable UIImage *)tryToLoadThumbnailImage
{
    if (!self.hasQuotedAttachmentThumbnailImage) {
        return nil;
    }

    // TODO: Possibly ignore data that is too large.
    UIImage *_Nullable image = self.quotedMessage.thumbnailImage;
    // TODO: Possibly ignore images that are too large.
    return image;
}

- (UIImageView *)imageViewForImage:(UIImage *)image
{
    OWSAssert(image);

    UIImageView *imageView = [UIImageView new];
    imageView.image = image;
    // We need to specify a contentMode since the size of the image
    // might not match the aspect ratio of the view.
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    // Use trilinear filters for better scaling quality at
    // some performance cost.
    imageView.layer.minificationFilter = kCAFilterTrilinear;
    imageView.layer.magnificationFilter = kCAFilterTrilinear;
    return imageView;
}

- (UILabel *)configureQuotedTextLabel
{
    OWSAssert(self.quotedTextLabel);

    UIColor *textColor = self.quotedTextColor;
    UIFont *font = self.quotedTextFont;
    NSString *text = @"";

    NSString *_Nullable fileTypeForSnippet = [self fileTypeForSnippet];
    NSString *_Nullable sourceFilename = [self.quotedMessage.sourceFilename filterStringForDisplay];

    if (self.displayableQuotedText.displayText.length > 0) {
        text = self.displayableQuotedText.displayText;
        textColor = self.quotedTextColor;
        font = self.quotedTextFont;
    } else if (fileTypeForSnippet) {
        text = fileTypeForSnippet;
        textColor = self.fileTypeTextColor;
        font = self.fileTypeFont;
    } else if (sourceFilename) {
        text = sourceFilename;
        textColor = self.filenameTextColor;
        font = self.filenameFont;
    } else {
        text = NSLocalizedString(
                                 @"QUOTED_REPLY_TYPE_ATTACHMENT", @"Indicates this message is a quoted reply to an attachment of unknown type.");
        textColor = self.fileTypeTextColor;
        font = self.fileTypeFont;
    }

    self.quotedTextLabel.numberOfLines = self.isForPreview ? 1 : 2;
    self.quotedTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.quotedTextLabel.text = text;
    self.quotedTextLabel.textColor = textColor;
    self.quotedTextLabel.font = font;

    return self.quotedTextLabel;
}

- (nullable NSString *)fileTypeForSnippet
{
    // TODO: Are we going to use the filename?  For all mimetypes?
    NSString *_Nullable contentType = self.quotedMessage.contentType;
    if (contentType.length < 1) {
        return nil;
    }

    if ([MIMETypeUtil isAudio:contentType]) {
        return NSLocalizedString(
            @"QUOTED_REPLY_TYPE_AUDIO", @"Indicates this message is a quoted reply to an audio file.");
    } else if ([MIMETypeUtil isVideo:contentType]) {
        return NSLocalizedString(
            @"QUOTED_REPLY_TYPE_VIDEO", @"Indicates this message is a quoted reply to a video file.");
    } else if ([MIMETypeUtil isImage:contentType]) {
        return NSLocalizedString(
            @"QUOTED_REPLY_TYPE_IMAGE", @"Indicates this message is a quoted reply to an image file.");
    } else if ([MIMETypeUtil isAnimated:contentType]) {
        return NSLocalizedString(
            @"QUOTED_REPLY_TYPE_GIF", @"Indicates this message is a quoted reply to animated GIF file.");
    }
    return nil;
}

- (BOOL)isAudioAttachment
{
    // TODO: Are we going to use the filename?  For all mimetypes?
    NSString *_Nullable contentType = self.quotedMessage.contentType;
    if (contentType.length < 1) {
        return NO;
    }

    return [MIMETypeUtil isAudio:contentType];
}

- (BOOL)isVideoAttachment
{
    // TODO: Are we going to use the filename?  For all mimetypes?
    NSString *_Nullable contentType = self.quotedMessage.contentType;
    if (contentType.length < 1) {
        return NO;
    }

    return [MIMETypeUtil isVideo:contentType];
}

- (UILabel *)configureQuotedAuthorLabel
{
    OWSAssert(self.quotedAuthorLabel);

    NSString *_Nullable localNumber = [TSAccountManager localNumber];
    NSString *quotedAuthorText;
    if ([localNumber isEqualToString:self.quotedMessage.authorId]) {

        if (self.isOutgoing) {
            quotedAuthorText = NSLocalizedString(
                @"QUOTED_REPLY_AUTHOR_INDICATOR_YOURSELF", @"message header label when quoting yourself");
        } else {
            quotedAuthorText = NSLocalizedString(
                @"QUOTED_REPLY_AUTHOR_INDICATOR_YOU", @"message header label when someone else is quoting you");
        }
    } else {
        OWSContactsManager *contactsManager = Environment.current.contactsManager;
        NSString *quotedAuthor = [contactsManager contactOrProfileNameForPhoneIdentifier:self.quotedMessage.authorId];
        quotedAuthorText = [NSString
            stringWithFormat:
                NSLocalizedString(@"QUOTED_REPLY_AUTHOR_INDICATOR_FORMAT",
                    @"Indicates the author of a quoted message. Embeds {{the author's name or phone number}}."),
            quotedAuthor];
    }

    self.quotedAuthorLabel.text = quotedAuthorText;
    self.quotedAuthorLabel.font = self.quotedAuthorFont;
    // TODO:
    self.quotedAuthorLabel.textColor = [self quotedAuthorColor];
    self.quotedAuthorLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.quotedAuthorLabel.numberOfLines = 1;

    return self.quotedAuthorLabel;
}

#pragma mark - Measurement

- (CGFloat)textVMargin
{
    return 7.f;
}

- (CGSize)sizeForMaxWidth:(CGFloat)maxWidth
{
    CGSize result = CGSizeZero;

    result.width += self.bubbleHMargin * 2 + self.stripeThickness + self.hSpacing * 2;

    CGFloat thumbnailHeight = 0.f;
    if (self.hasQuotedAttachment) {
        result.width += self.quotedAttachmentSize;

        thumbnailHeight += self.quotedAttachmentSize;
    }

    // Quoted Author
    CGFloat textWidth = 0.f;
    CGFloat maxTextWidth = maxWidth - result.width;
    CGFloat textHeight = self.textVMargin * 2 + self.quotedAuthorHeight;
    {
        UILabel *quotedAuthorLabel = [self configureQuotedAuthorLabel];

        CGSize quotedAuthorSize = CGSizeCeil([quotedAuthorLabel sizeThatFits:CGSizeMake(maxTextWidth, CGFLOAT_MAX)]);
        textWidth = quotedAuthorSize.width;
    }

    {
        UILabel *quotedTextLabel = [self configureQuotedTextLabel];

        CGSize textSize = CGSizeCeil([quotedTextLabel sizeThatFits:CGSizeMake(maxTextWidth, CGFLOAT_MAX)]);
        textWidth = MAX(textWidth, textSize.width);
        textHeight += textSize.height;
    }

    textWidth = MIN(textWidth, maxTextWidth);
    result.width += textWidth;
    result.height += MAX(textHeight, thumbnailHeight);

    return CGSizeCeil(result);
}

- (UIFont *)quotedAuthorFont
{
    return UIFont.ows_dynamicTypeSubheadlineFont.ows_mediumWeight;
}

- (UIColor *)quotedAuthorColor
{
    return [UIColor ows_light90Color];
}

- (UIColor *)quotedTextColor
{
    return [UIColor ows_light90Color];
}

- (UIFont *)quotedTextFont
{
    return [UIFont ows_dynamicTypeBodyFont];
}

- (UIColor *)fileTypeTextColor
{
    return [UIColor colorWithWhite:0.5f alpha:1.f];
}

- (UIFont *)fileTypeFont
{
    return self.quotedTextFont.ows_italic;
}

- (UIColor *)filenameTextColor
{
    return [UIColor colorWithWhite:0.5f alpha:1.f];
}

- (UIFont *)filenameFont
{
    return self.quotedTextFont;
}

- (CGFloat)quotedAuthorHeight
{
    return (CGFloat)ceil([self quotedAuthorFont].lineHeight * 1.f);
}

- (CGFloat)quotedAttachmentSize
{
    return 54.f;
}

#pragma mark -

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self sizeForMaxWidth:CGFLOAT_MAX];
}

@end

NS_ASSUME_NONNULL_END
