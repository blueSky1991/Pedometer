//
//  SoundPlayer.swift
//  Pedometer
//
//  Created by 张东东 on 2017/4/14.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit
import AVFoundation

protocol SoundPlayerDelegate:NSObjectProtocol {
    //朗读开始
    func speechSynthesizerDidStartSpeechUtterance(_: AVSpeechSynthesizer,_: AVSpeechUtterance)
    //朗读暂停
     func speechSynthesizerDidPauseSpeechUtterance(_: AVSpeechSynthesizer,_: AVSpeechUtterance)
    //朗读继续
     func speechSynthesizerDidContinueSpeechUtterance(_: AVSpeechSynthesizer,_: AVSpeechUtterance)
    //朗读结束
     func speechSynthesizerDidFinishSpeechUtterance(_: AVSpeechSynthesizer,_: AVSpeechUtterance)
    //朗读中
    func speechSynthesizerWillSpeakRangeOfSpeechString(_characterRange:NSRange,_: AVSpeechSynthesizer,_: AVSpeechUtterance)
    
}

class SoundPlayer: NSObject,AVSpeechSynthesizerDelegate {
    
    var rate:Float? = 0.5 //设置语速
    var volume:Float? = 1.0 //设置音量（0.0~1.0）默认为1.0
    var pitchMultiplier:Float?  = 1.0 //设置语调 (0.5-2.0)
    var autoPlay:Bool?
    var delegate:SoundPlayerDelegate?
    var player:AVSpeechSynthesizer?

    static var shareInstance: SoundPlayer {
        
        struct Static {
            
            static let instance: SoundPlayer = SoundPlayer()
        }
        
        return Static.instance
    }
    
    private override init() {}

    
}

extension SoundPlayer{

    
    //播放文字
    func play(string:String) -> Void {
        if !(string.isEmpty) {
            self.player = AVSpeechSynthesizer() ;
            self.player?.delegate = self;
            let utterance = AVSpeechUtterance.init(string: string)//设置语音内容
            utterance.voice  = AVSpeechSynthesisVoice.init(language: "zh-CN")//设置语言
            utterance.rate   = self.rate!
            utterance.volume = self.volume!
            utterance.pitchMultiplier = self.pitchMultiplier!
            utterance.postUtteranceDelay = 0; //目的是让语音合成器播放下一语句前有短暂的暂停
            self.player?.speak(utterance)
        }

        
    }
    //停止播放
    func stopSpeaking() -> Void {

        self.player?.stopSpeaking(at: .immediate)
    }
    //暂停播放
    func pauseSpeaking() -> Void {
        self.player?.pauseSpeaking(at: .immediate)
        
    }
     //继续播放
    func continueSpeaking() -> Void {
        
        self.player?.continueSpeaking()
    }



    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        delegate?.speechSynthesizerDidStartSpeechUtterance(synthesizer, utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        delegate?.speechSynthesizerDidPauseSpeechUtterance(synthesizer, utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
         delegate?.speechSynthesizerDidFinishSpeechUtterance(synthesizer, utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        delegate?.speechSynthesizerDidContinueSpeechUtterance(synthesizer, utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        delegate?.speechSynthesizerWillSpeakRangeOfSpeechString(_characterRange: characterRange, synthesizer, utterance)
    }
    
}

