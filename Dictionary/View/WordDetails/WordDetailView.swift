//
//  WordDetailView.swift
//  Dictionary
//
//  Created by Matheus Xavier on 14/09/22.
//

import Foundation
import UIKit
import AVFAudio

class WordDetailView: UIView {
    var word: Word?
    private var audio: String = ""
    private var timer: Timer!
    private var player: AVAudioPlayer?
    private var slider: UISlider!
    private var duration: Float = 0 {
        didSet {
            DispatchQueue.main.async {
                self.slider.minimumValue = 0
                self.slider.maximumValue = self.duration
            }
        }
    }
    
    private lazy var playBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setDimensions(height: 20, width: 20)
        btn.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
        btn.addTarget(self, action: #selector(handlePlayAudio), for: .touchUpInside)
        return btn
    }()
    
    private let mainLb: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 22, weight: .semibold)
        lb.textColor = dynamicColor
        lb.textAlignment = .center
        return lb
    }()
    
    private let subLb: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20, weight: .medium)
        lb.textColor = dynamicColor
        lb.textAlignment = .center
        return lb
    }()
    
    private let notFoundTitle: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 24, weight: .bold)
        lb.textColor = dynamicColor
        lb.text = "Word Not Found"
        lb.textAlignment = .left
        return lb
    }()
    
    private let notFoundSubTitle: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 22, weight: .semibold)
        lb.textColor = dynamicColor
        lb.setDimensions(height: nil, width: 250)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    private let notFoundImage: UIImageView = {
        let imgv = UIImageView(image: UIImage(systemName: "text.badge.xmark"))
        imgv.setDimensions(height: 45, width: 50)
        return imgv
    }()
    
    private let title: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 24, weight: .bold)
        lb.textColor = dynamicColor
        lb.text = "Meanings"
        lb.textAlignment = .left
        return lb
    }()
    
    private let sounds: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 24, weight: .bold)
        lb.textColor = dynamicColor
        lb.text = "Pronunciation"
        lb.textAlignment = .left
        return lb
    }()
    
    private let meaning: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.textColor = dynamicColor
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateSlider(){
            guard let currentTime = self.player?.currentTime else { return }
            self.slider.value = Float(currentTime)
            if self.slider.value > 0.95 * self.slider.maximumValue {
                self.slider.value = 0
                self.player?.stop()
                self.changePlayPauseIcon()
            }
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        player?.stop()
        player?.currentTime = TimeInterval(sender.value)
        player?.prepareToPlay()
        player?.play()
    }
    
    @objc func handlePlayAudio(){
        self.changePlayPauseIcon()
        if player == nil || !(player?.isPlaying ?? true) {
            self.playPhonetic()
        } else {
            player?.stop()
        }
    }
    
    public func configureUI(){
        self.slider = UISlider()
        self.slider.value = 0
        self.slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        self.backgroundColor = .systemGray6
        self.mainLb.text = word?.word ?? ""
        var wordPhonetic: String = "Phonetic not found."
        word?.phonetics?.forEach({ phonetic in
            if phonetic.text != nil && phonetic.text != "" {
                wordPhonetic = phonetic.text!
            }
        })
        self.subLb.text = word?.phonetic ?? wordPhonetic
        var text: String = ""
        word?.meanings?.forEach({ meaning in
            text += "\((meaning.partOfSpeech?.capitalized)!) - \((meaning.definitions?[0].definition)!) \n\n"
        })
        self.meaning.text = text
        self.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        let mainStack = UIStackView(arrangedSubviews: [mainLb, subLb])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.distribution = .fillEqually
        mainStack.backgroundColor = .systemGray5
        self.addSubview(mainStack)
        mainStack.anchor(top: self.safeAreaLayoutGuide.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 100)
        self.addSubview(title)
        title.anchor(top: mainStack.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 25, paddingLeft: 16, paddingRight: 16)
        
        self.addSubview(meaning)
        meaning.anchor(top: title.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 25, paddingLeft: 16, paddingRight: 16)
        
        
        word?.phonetics?.forEach({ phonetic in
            if phonetic.audio != nil && phonetic.audio != ""  {
                audio = phonetic.audio!
            }
        })
        if audio != "" {
            self.addSubview(sounds)
            sounds.anchor(top: meaning.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 25, paddingLeft: 16, paddingRight: 16)
            self.addSubview(playBtn)
            playBtn.anchor(top: sounds.bottomAnchor, left: self.leftAnchor, paddingTop: 40, paddingLeft: 16)
            self.addSubview(slider)
            slider.anchor( left: playBtn.rightAnchor, paddingLeft: 16)
            slider.centerY(inView: playBtn)
            slider.setDimensions(height: nil, width: 280)
        }
    }
    
    private func changePlayPauseIcon() {
        DispatchQueue.main.async { [self] in
            if self.player?.isPlaying ?? false {
                self.playBtn.setImage(UIImage.init(systemName: "pause.fill"), for: .normal)
            } else {
                self.playBtn.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
            }
        }
    }
    
    private func playPhonetic() {
        self.timer?.invalidate()
        guard let url = URL(string: audio) else { return }
        Services.shared.downloadAudioFromAPI(url: url) { url in
            do {
                self.player = try AVAudioPlayer(contentsOf: url!)
                if let duration = self.player?.duration {
                    self.duration = Float(duration)
                }
                self.player?.prepareToPlay()
                self.player?.play()
                DispatchQueue.main.async { [self] in
                    self.timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(WordDetailView.updateSlider), userInfo: nil, repeats: true)
                    self.changePlayPauseIcon()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func configureNotFound(){
        self.backgroundColor = .systemGray6
        self.addSubview(notFoundTitle)
        notFoundTitle.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 25, paddingLeft: 16)
        self.addSubview(notFoundSubTitle)
        notFoundSubTitle.anchor(top: notFoundTitle.topAnchor, left: leftAnchor, paddingTop: 25, paddingLeft: 16)
        notFoundSubTitle.text = "We can't find \"\(word?.word ?? "")\", sorry for this!"
        self.addSubview(notFoundImage)
        notFoundImage.tintColor = .systemGray4
        notFoundImage.centerX(inView: self)
        notFoundImage.centerY(inView: self)
    }
}
