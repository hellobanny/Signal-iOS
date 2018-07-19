//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#ifndef TextSecureKit_Constants_h
#define TextSecureKit_Constants_h

typedef NS_ENUM(NSInteger, TSWhisperMessageType) {
    TSUnknownMessageType            = 0,
    TSEncryptedWhisperMessageType   = 1,
    TSIgnoreOnIOSWhisperMessageType = 2, // on droid this is the prekey bundle message irrelevant for us
    TSPreKeyWhisperMessageType      = 3,
    TSUnencryptedWhisperMessageType = 4,
};

#pragma mark Server Address

#define textSecureHTTPTimeOut 10

#define kLegalTermsUrlString @"https://signal.org/legal/"
#define SHOW_LEGAL_TERMS_LINK
/*
//#ifndef DEBUG
//10.35.11.134  8080  8001 8080
#define textSecureWebSocketAPI @"ws://10.35.11.134/v1/websocket/"
#define textSecureServerURL @"http://10.35.11.134/"
#define textSecureCDNServerURL @"http://10.35.11.134"
#define textSecureServiceReflectorHost @"textsecure-service-reflected.10.35.11.134"
#define textSecureCDNReflectorHost @"textsecure-service-reflected.10.35.11.134"
*/

//47.96.76.141
#define textSecureWebSocketAPI @"ws://52.194.115.31/v1/websocket/"
#define textSecureServerURL @"http://52.194.115.31/"
#define textSecureCDNServerURL @"http://52.194.115.31"
#define textSecureServiceReflectorHost @"textsecure-service-reflected.52.194.115.31"
#define textSecureCDNReflectorHost @"textsecure-service-reflected.52.194.115.31"

// Production
/*#define textSecureWebSocketAPI @"wss://textsecure-service.whispersystems.org/v1/websocket/"
#define textSecureServerURL @"https://textsecure-service.whispersystems.org/"
#define textSecureCDNServerURL @"https://cdn.signal.org"
// Use same reflector for service and CDN
#define textSecureServiceReflectorHost @"textsecure-service-reflected.whispersystems.org"
#define textSecureCDNReflectorHost @"textsecure-service-reflected.whispersystems.org"*/

//#else
//
//// Staging
//#define textSecureWebSocketAPI @"wss://textsecure-service-staging.whispersystems.org/v1/websocket/"
//#define textSecureServerURL @"https://textsecure-service-staging.whispersystems.org/"
//#define textSecureCDNServerURL @"https://cdn-staging.signal.org"
//#define textSecureServiceReflectorHost @"meek-signal-service-staging.appspot.com";
//#define textSecureCDNReflectorHost @"meek-signal-cdn-staging.appspot.com";
//
//#endif

#define textSecureAccountsAPI @"v1/accounts"
#define textSecureAttributesAPI @"/attributes/"

#define textSecureMessagesAPI @"v1/messages/"
#define textSecureKeysAPI @"v2/keys"
#define textSecureSignedKeysAPI @"v2/keys/signed"
#define textSecureDirectoryAPI @"v1/directory"
#define textSecureAttachmentsAPI @"v1/attachments"
#define textSecureDeviceProvisioningCodeAPI @"v1/devices/provisioning/code"
#define textSecureDeviceProvisioningAPIFormat @"v1/provisioning/%@"
#define textSecureDevicesAPIFormat @"v1/devices/%@"
#define textSecureProfileAPIFormat @"v1/profile/%@"
#define textSecureSetProfileNameAPIFormat @"v1/profile/name/%@"
#define textSecureProfileAvatarFormAPI @"v1/profile/form/avatar"
#define textSecure2FAAPI @"/v1/accounts/pin"

#define SignalApplicationGroup @"group.com.bamboo.tokenpipe"

#endif
