//
//  TestConversationVC.swift
//  Signal
//
//  Created by 张忠 on 2018/7/23.
//  Copyright © 2018年 Open Whisper Systems. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MobileCoreServices

private var chatABVKey: UInt8 = 0
private var actionBPBCKey: UInt8 = 1
private var keyboardHCKey: UInt8 = 2
private var emotionIVKey:  UInt8 = 3
private var shareMVKey:    UInt8 = 4
private var voiceIVKey:    UInt8 = 5
private var disposeKey:    UInt8 = 5
private var replyModelKey:    UInt8 = 6

let ReplyKeyword = "[回复]"

func associatedObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

func associatedNullableObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType?)
    -> ValueType? {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateNullableObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType?) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

//MARK: 定义变量和向OC暴露的接口
extension ConversationViewController {

    var chatActionBarView: TSChatActionBarView! { //action bar
        get {
            return associatedObject(base: self, key: &chatABVKey, initialiser: {
                return TSChatActionBarView()
            })
        }
        set { associateObject(base: self, key: &chatABVKey, value: newValue) }
    }
    var actionBarPaddingBottomConstranit: Constraint?{ //action bar 的 bottom Constraint
        get {
            return associatedNullableObject(base: self, key: &actionBPBCKey, initialiser: {
                return nil
            })
        }
        set { associateNullableObject(base: self, key: &actionBPBCKey, value: newValue) }
    }
    var keyboardHeightConstraint: NSLayoutConstraint?{  //键盘高度的 Constraint
        get {
            return associatedNullableObject(base: self, key: &keyboardHCKey, initialiser: {
                return nil
            })
        }
        set { associateNullableObject(base: self, key: &keyboardHCKey, value: newValue) }
    }
    var emotionInputView: TSChatEmotionInputView!{ //表情键盘
        get {
            return associatedObject(base: self, key: &emotionIVKey, initialiser: {
                return UIView.ts_viewFromNib(TSChatEmotionInputView.self)
            })
        }
        set { associateObject(base: self, key: &emotionIVKey, value: newValue) }
    }
    var shareMoreView: TSChatShareMoreView!{    //分享键盘
        get {
            return associatedObject(base: self, key: &shareMVKey, initialiser: {
                return TSChatShareMoreView()
            })
        }
        set { associateObject(base: self, key: &shareMVKey, value: newValue) }
    }
    
    var voiceIndicatorView: TSChatVoiceIndicatorView!{ //声音的显示 View
        get {
            return associatedObject(base: self, key: &voiceIVKey, initialiser: {
                return TSChatVoiceIndicatorView()
            })
        }
        set { associateObject(base: self, key: &voiceIVKey, value: newValue) }
    }
    
    var disposeBag: DisposeBag!{ //声音的显示 View
        get {
            return associatedObject(base: self, key: &disposeKey, initialiser: {
                return DisposeBag()
            })
        }
        set { associateObject(base: self, key: &disposeKey, value: newValue) }
    }
    
    var quotedReply: OWSQuotedReplyModel?{  //引用的回复消息
        get {
            return associatedNullableObject(base: self, key: &replyModelKey, initialiser: {
                return nil
            })
        }
        set { associateNullableObject(base: self, key: &replyModelKey, value: newValue) }
    }
    
    @objc func callAfterViewDidLoad(){
        setupSubviews(self)
        keyboardControl()
        setupActionBarButtonInterAction()
    }
    
    //设置回复的标识，在输入的文字前面加入 ReplyKeyword [回复] ,不重复插入
    @objc func setReplyModel(replyModel:OWSQuotedReplyModel){
        self.quotedReply = replyModel
        if !self.chatActionBarView.inputTextView.text.hasPrefix(ReplyKeyword){
            let text = ReplyKeyword + chatActionBarView.inputTextView.text
            self.chatActionBarView.inputTextView.text = text
        }
        chatActionBarView.inputTextView.becomeFirstResponder()
    }
    
    @objc func getQuotedReplyModel() -> OWSQuotedReplyModel? {
        return self.quotedReply
    }

    @objc class func parseText(text:String,font:UIFont) -> NSMutableAttributedString?{
        
        return TSChatTextParser.parseText(text, font: font)
    }
}

//MARK: 控件初始化
extension ConversationViewController {
    /**
     初始化操作栏的 button 事件。包括 声音按钮，录音按钮，表情按钮，分享按钮 等各种事件的交互
     */
    @objc
    func setupActionBarButtonInterAction() {
        let voiceButton: TSChatButton = self.chatActionBarView.voiceButton
        let recordButton: UIButton = self.chatActionBarView.recordButton
        let emotionButton: TSChatButton = self.chatActionBarView.emotionButton
        let shareButton: TSChatButton = self.chatActionBarView.shareButton
        
        //切换声音按钮
        voiceButton.rx.tap.subscribe {[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.chatActionBarView.resetButtonUI()
            //根据不同的状态进行不同的键盘交互
            let showRecoring = strongSelf.chatActionBarView.recordButton.isHidden
            if showRecoring {
                strongSelf.chatActionBarView.showRecording()
                voiceButton.emotionSwiftVoiceButtonUI(showKeyboard: true)
                strongSelf.controlExpandableInputView(showExpandable: false)
            } else {
                strongSelf.chatActionBarView.showTyingKeyboard()
                voiceButton.emotionSwiftVoiceButtonUI(showKeyboard: false)
                strongSelf.controlExpandableInputView(showExpandable: true)
            }
            }.disposed(by: self.disposeBag)
        
        
        //录音按钮
        var finishRecording: Bool = true  //控制滑动取消后的结果，决定停止录音还是取消录音
        let longTap = UILongPressGestureRecognizer()
        recordButton.addGestureRecognizer(longTap)
        longTap.rx.event.subscribe {[weak self] _ in
            guard let strongSelf = self else { return }
            if longTap.state == .began { //长按开始
                finishRecording = true
                strongSelf.voiceIndicatorView.recording()
                strongSelf.voiceMemoGestureDidStart()
                //ZZTODO AudioRecordInstance.startRecord()
                recordButton.replaceRecordButtonUI(isRecording: true)
            } else if longTap.state == .changed { //长按平移
                let point = longTap.location(in: self!.voiceIndicatorView)
                if strongSelf.voiceIndicatorView.point(inside: point, with: nil) {
                    strongSelf.voiceIndicatorView.slideToCancelRecord()
                    finishRecording = false
                } else {
                    strongSelf.voiceIndicatorView.recording()
                    finishRecording = true
                }
            } else if longTap.state == .ended { //长按结束
                if finishRecording {
                    //ZZTODO AudioRecordInstance.stopRecord()
                    strongSelf.voiceMemoGestureDidEnd()
                } else {
                    //ZZTODO AudioRecordInstance.cancelRrcord()
                    strongSelf.voiceMemoGestureDidCancel()
                }
                strongSelf.voiceIndicatorView.endRecord()
                recordButton.replaceRecordButtonUI(isRecording: false)
            }
            }.disposed(by: self.disposeBag)
        
        
        //表情按钮
        emotionButton.rx.tap.subscribe {[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.chatActionBarView.resetButtonUI()
            //设置 button 的UI
            emotionButton.replaceEmotionButtonUI(showKeyboard: !emotionButton.showTypingKeyboard)
            //根据不同的状态进行不同的键盘交互
            if emotionButton.showTypingKeyboard {
                strongSelf.chatActionBarView.showTyingKeyboard()
            } else {
                strongSelf.chatActionBarView.showEmotionKeyboard()
            }
            
            strongSelf.controlExpandableInputView(showExpandable: true)
            }.disposed(by: self.disposeBag)
        
        
        //分享按钮
        shareButton.rx.tap.subscribe {[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.chatActionBarView.resetButtonUI()
            //根据不同的状态进行不同的键盘交互
            if shareButton.showTypingKeyboard {
                strongSelf.chatActionBarView.showTyingKeyboard()
            } else {
                strongSelf.chatActionBarView.showShareKeyboard()
            }
            
            strongSelf.controlExpandableInputView(showExpandable: true)
            }.disposed(by: self.disposeBag)
        
        
        //文字框的点击，唤醒键盘
        let textView: UITextView = self.chatActionBarView.inputTextView
        let tap = UITapGestureRecognizer()
        textView.addGestureRecognizer(tap)
        tap.rx.event.subscribe { _ in
            textView.inputView = nil
            textView.becomeFirstResponder()
            textView.reloadInputViews()
            }.disposed(by: self.disposeBag)
    }
    
    /**
     Control the actionBarView height:
     We should make actionBarView's height to original value when the user wants to show recording keyboard.
     Otherwise we should make actionBarView's height to currentHeight
     
     - parameter showExpandable: show or hide expandable inputTextView
     */
    func controlExpandableInputView(showExpandable: Bool) {
        let textView = self.chatActionBarView.inputTextView
        let currentTextHeight = self.chatActionBarView.inputTextViewCurrentHeight
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let textHeight = showExpandable ? currentTextHeight : kChatActionBarOriginalHeight
            self.chatActionBarView.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(textHeight)
            }
            self.view.layoutIfNeeded()
            //ZZTODO self.listTableView.scrollBottomToLastRow()
            textView?.contentOffset = CGPoint.zero
        })
    }
}

extension ConversationViewController {
    /**
     发送文字
     */
    func chatSendText() {
        dispatch_async_safely_to_main_queue({[weak self] in
            guard let strongSelf = self else { return }
            guard let textView = strongSelf.chatActionBarView.inputTextView else {return }
            guard textView.text.ts_length < 1000 else {
                BBCommon.notice(title: "超出字数限制")
                return
            }
            
            var text = textView.text.trimmingCharacters(in: CharacterSet.whitespaces)
            if text.length == 0 {
                BBCommon.notice(title: "不能发送空白消息")
                return
            }
            
            if text.hasPrefix(ReplyKeyword) && self?.quotedReply != nil {
                text.removeFirst(ReplyKeyword.count)
            }
            else {
                self?.quotedReply = nil
            }
            self?.try(toSendTextMessage: text, updateKeyboardState: true)
            textView.text = "" //发送完毕后清空
            self?.quotedReply = nil
            
            strongSelf.textViewDidChange(strongSelf.chatActionBarView.inputTextView)
        })
    }
}


// 表情点击完毕后
extension ConversationViewController: ChatEmotionInputViewDelegate {
    //点击表情
    func chatEmoticonInputViewDidTapCell(_ cell: TSChatEmotionCell) {
        self.chatActionBarView.inputTextView.insertText(cell.emotionModel!.text)
    }
    
    //点击撤退删除
    func chatEmoticonInputViewDidTapBackspace(_ cell: TSChatEmotionCell) {
        self.chatActionBarView.inputTextView.deleteBackward()
    }
    
    //点击发送文字，包含表情
    func chatEmoticonInputViewDidTapSend() {
        self.chatSendText()
    }
}

// MARK: - @protocol UITextViewDelegate
extension ConversationViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            //点击发送文字，包含表情
            self.chatSendText()
            return false
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let contentHeight = textView.contentSize.height
        guard contentHeight < kChatActionBarTextViewMaxHeight else {
            return
        }
        
        self.chatActionBarView.inputTextViewCurrentHeight = contentHeight + 17
        self.controlExpandableInputView(showExpandable: true)
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //设置键盘类型，响应 UIKeyboardWillShowNotification 事件
        self.chatActionBarView.inputTextViewCallKeyboard()
        
        //使 UITextView 滚动到末尾的区域
        UIView.setAnimationsEnabled(false)
        let range = NSMakeRange(textView.text.ts_length - 1, 1)
        textView.scrollRangeToVisible(range)
        UIView.setAnimationsEnabled(true)
        return true
    }
}

private let kCustomKeyboardHeight: CGFloat = 216

// MARK: - @extension TSChatViewController
extension ConversationViewController {
    /**
     创建聊天的各种子 view
     */
    @objc
    func setupSubviews(_ delegate: UITextViewDelegate) {
        self.setupActionBar(delegate)
        self.setupKeyboardInputView()
        self.setupVoiceIndicatorView()
    }
    
    /**
     初始化操作栏
     */
    fileprivate func setupActionBar(_ delegate: UITextViewDelegate) {
        self.chatActionBarView = UIView.ts_viewFromNib(TSChatActionBarView.self)
        self.chatActionBarView.delegate = self
        self.chatActionBarView.inputTextView.delegate = delegate
        self.view.addSubview(self.chatActionBarView)
        self.chatActionBarView.snp.makeConstraints { [weak self] (make) -> Void in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            strongSelf.actionBarPaddingBottomConstranit = make.bottom.equalTo(strongSelf.view.snp.bottom).constraint
            make.height.equalTo(kChatActionBarOriginalHeight)
        }
    }
    
    /**
     初始化表情键盘，分享更多键盘
     */
    fileprivate func setupKeyboardInputView() {
        //emotionInputView init
        self.emotionInputView = UIView.ts_viewFromNib(TSChatEmotionInputView.self)
        self.emotionInputView.delegate = self
        self.view.addSubview(self.emotionInputView)
        self.emotionInputView.snp.makeConstraints {[weak self] (make) -> Void in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.top.equalTo(strongSelf.chatActionBarView.snp.bottom).offset(0)
            make.height.equalTo(kCustomKeyboardHeight)
        }
        
        //shareMoreView init
        self.shareMoreView = UIView.ts_viewFromNib(TSChatShareMoreView.self)
        if self.thread.isGroupThread(){
            shareMoreView.changeToGroupShareView()
        }
        self.shareMoreView!.delegate = self
        self.view.addSubview(self.shareMoreView)
        self.shareMoreView.snp.makeConstraints {[weak self] (make) -> Void in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.top.equalTo(strongSelf.chatActionBarView.snp.bottom).offset(0)
            make.height.equalTo(kCustomKeyboardHeight)
        }
    }
    
    /**
     初始化 VoiceIndicator
     */
    fileprivate func setupVoiceIndicatorView() {
        //voiceIndicatorView init
        self.voiceIndicatorView = UIView.ts_viewFromNib(TSChatVoiceIndicatorView.self)
        self.view.addSubview(self.voiceIndicatorView)
        self.voiceIndicatorView.snp.makeConstraints {[weak self] (make) -> Void in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.view.snp.top).offset(100)
            make.left.equalTo(strongSelf.view.snp.left)
            make.bottom.equalTo(strongSelf.view.snp.bottom).offset(-100)
            make.right.equalTo(strongSelf.view.snp.right)
        }
        self.voiceIndicatorView.isHidden = true
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ConversationViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //弹出键盘后，避免按钮的点击事件被listTableView的手势拦截而不执行，例如播放语音
        if touch.view is UIButton {
            return false
        }
        return true
    }
}

/*
 所有的键盘动画都是控制 chatActionBar 的 bottomConstraint。
 表情键盘和分享键盘的约束都是依赖 chatActionBar
 */

// MARK: - @extension TSChatViewController
extension ConversationViewController {
    /**
     键盘控制
     */
    @objc
    func keyboardControl() {
        /**
         Keyboard notifications
         */
        NotificationCenter.default
            .rx.notification(Notification.Name(rawValue: NSNotification.Name.UIKeyboardWillShow.rawValue), object: nil)
            .subscribe(onNext: {[weak self] notification in
                guard let strongSelf = self else { return }
                //strongSelf.listTableView.scrollToBottomAnimated(false)
                strongSelf.keyboardControl(notification, isShowing: true)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(Notification.Name(rawValue: NSNotification.Name.UIKeyboardDidShow.rawValue), object: nil)
            .subscribe(onNext: {notification in
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                    _ = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(Notification.Name(rawValue: NSNotification.Name.UIKeyboardWillHide.rawValue), object: nil)
            .subscribe(onNext: {[weak self] notification in
                guard let strongSelf = self else { return }
                strongSelf.keyboardControl(notification, isShowing: false)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(Notification.Name(rawValue: NSNotification.Name.UIKeyboardDidHide.rawValue), object: nil)
            .subscribe(onNext: {notification in
            })
            .disposed(by: disposeBag)
    }
    
    /**
     控制键盘事件
     http://stackoverflow.com/questions/19311045/uiscrollview-animation-of-height-and-contentoffset-jumps-content-from-bottom
     - parameter notification: NSNotification 对象
     - parameter isShowing:    是否显示键盘？
     */
    func keyboardControl(_ notification: Notification, isShowing: Bool) {
        /*
         如果是表情键盘或者 分享键盘 ，走自己 delegate 的处理键盘事件。
         
         因为：当点击唤起自定义键盘时，操作栏的输入框需要 resignFirstResponder，这时候会给键盘发送通知。
         通知中需要对 actionbar frame 进行重置位置计算, 在 delegate 回调中进行计算。所以在这里进行拦截。
         Button 的点击方法中已经处理了 delegate。
         */
        let keyboardType = self.chatActionBarView.keyboardType
        if keyboardType == .emotion || keyboardType == .share {
            return
        }
        
        /*
         处理 Default, Text 的键盘属性
         */
        var userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value
        
        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y
        let options = UIViewAnimationOptions(rawValue: UInt(curve!) << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        
        //self.listTableView.stopScrolling()
        self.actionBarPaddingBottomConstranit?.update(offset:-heightOffset)
        
        UIView.animate(
            withDuration: duration!,
            delay: 0,
            options: options,
            animations: {
                self.view.layoutIfNeeded()
                if isShowing {
                    //self.listTableView.scrollToBottom(animated: false)
                }
        },
            completion: { bool in
                
        })
    }
    
    //获取键盘的高度
    func appropriateKeyboardHeight(_ notification: Notification) -> CGFloat {
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var keyboardHeight: CGFloat = 0.0
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
            keyboardHeight = min(endFrame.width, endFrame.height)
        }
        
        if notification.name == Notification.Name("") {
            keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            keyboardHeight -= self.tabBarController!.tabBar.frame.height
        }
        return keyboardHeight
    }
    
    func appropriateKeyboardHeight()-> CGFloat {
        var height = self.view.bounds.size.height
        height -= self.keyboardHeightConstraint!.constant
        
        guard height > 0 else {
            return 0
        }
        return height
    }
    
    /**
     隐藏自定义键盘，当唤醒的自定义键盘时候，这时候点击切换录音 button。需要隐藏掉
     */
    fileprivate func hideCusttomKeyboard() {
        let heightOffset: CGFloat = 0
        //self.listTableView.stopScrolling()
        self.actionBarPaddingBottomConstranit?.update(offset: -heightOffset)
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: {
                self.view.layoutIfNeeded()
        },
            completion: { bool in
        })
    }
    
    /**
     隐藏所有键盘,
     使用场景：
     1.点击 UITableView 使用
     2.开始滚动 UITableView 使用
     */
    func hideAllKeyboard() {
        self.hideCusttomKeyboard()
        self.chatActionBarView.resignKeyboard()
    }
}

// MARK: - @delegate TSChatActionBarViewDelegate
extension ConversationViewController: TSChatActionBarViewDelegate {
    /**
     隐藏自定义键盘
     */
    func chatActionBarRecordVoiceHideKeyboard() {
        self.hideCusttomKeyboard()
    }
    
    /**
     调起表情键盘
     */
    func chatActionBarShowEmotionKeyboard() {
        let heightOffset = self.emotionInputView.ts_height
        //self.listTableView.stopScrolling()
        self.actionBarPaddingBottomConstranit?.update(offset: -heightOffset)
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: {
                //表情键盘归位
                self.emotionInputView.snp.updateConstraints { make in
                    make.top.equalTo(self.chatActionBarView.snp.bottom).offset(0)
                }
                //分享键盘隐藏
                self.shareMoreView.snp.updateConstraints { make in
                    make.top.equalTo(self.chatActionBarView.snp.bottom).offset(self.view.ts_height)
                }
                self.view.layoutIfNeeded()
                //self.listTableView.scrollBottomToLastRow()
        },
            completion: { bool in
        })
    }
    
    /**
     调起分享键盘
     */
    func chatActionBarShowShareKeyboard() {
        let heightOffset = self.shareMoreView.ts_height
        //self.listTableView.stopScrolling()
        self.actionBarPaddingBottomConstranit?.update(offset: -heightOffset)
        
        self.shareMoreView.ts_top = self.view.ts_height
        self.view.bringSubview(toFront: self.shareMoreView)
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: {
                //分享键盘归位，盖在表情键盘上，所以不需要控制表情键盘
                self.shareMoreView.snp.updateConstraints { make in
                    make.top.equalTo(self.chatActionBarView.snp.bottom).offset(0)
                }
                self.view.layoutIfNeeded()
                //self.listTableView.scrollBottomToLastRow()
        },
            completion: { bool in
        })
    }
}

extension ConversationViewController: ChatShareMoreViewDelegate {
    
    func userClickShareViewAt(index: IndexPath) {
        let row = index.row
        if row == 0 {//照片
            self.chooseFromLibraryAsMedia()
        }
        else if row == 1 {//拍照
            self.takePictureOrVideo()
        }
        if self.thread.isGroupThread(){
            if row == 2 {
                self.startSendGroupPocket()
            }
        }
        else {
            if row == 2{
                self.startSendRedPocket()
            }
            else if row == 3{
                self.startTransfer()
            }
        }
    }
    
    //选择打开相册
    func chatShareMoreViewPhotoTaped() {
        
    }
    
    //选择打开相机
    func chatShareMoreViewCameraTaped() {
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .notDetermined {
            self.checkCameraPermission()
        } else if authStatus == .restricted || authStatus == .denied {
            TSAlertView_show("无法访问您的相机", message: "请到设置 -> 隐私 -> 相机 ，打开访问权限" )
        } else if authStatus == .authorized {
            //self.openCamera()
        }
    }
    
    
    func checkCameraPermission () {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {granted in
            if !granted {
                TSAlertView_show("无法访问您的相机", message: "请到设置 -> 隐私 -> 相机 ，打开访问权限" )
            }
        })
    }
}
