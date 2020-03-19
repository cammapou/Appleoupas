//
//  ViewController.swift
//  Apple ou pas
//
//  Created by Ddales on 17/12/2019.
//  Copyright © 2019 Ddales. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    
    var carte: MaVUE?
    var rect = CGRect()
    var buttonOui = MonButton()
    var buttonNon = MonButton()
    var playBoutton: MonButton?
    var scoreLabel = MonLabel()
    var timer = Timer()
    var tempsRestant = 0
    var score = 0
    var isGame = false
    
    var audioPlayer: AVAudioPlayer?
    var soundPlayer: AVAudioPlayer?
    
    var sonOui = Son(nom: "oui", ext: "wav")
    var sonNon = Son(nom: "non", ext: "mp3")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradient()
        container.frame = view.bounds
        rect = CGRect(
        x: container.frame.midX - 100,
        y: container.frame.midY - 100,
        width: 200,
        height: 200)
        self.setButton()
        self.setupLabel()
        self.setupGame()

    }
    
    func setupLabel() {
        scoreLabel = MonLabel(frame: CGRect(x: 20, y: 10, width: container.frame.width - 40, height: 60))
        container.addSubview(scoreLabel)
    }
    
    
    func setButton() {
        let tiers = container.frame.width / 3
        let quart = container.frame.width / 4
        let hauteur: CGFloat = 50
        let y = container.frame.height - (hauteur * 2.5)
        let taille = CGSize(width: tiers, height: hauteur)
        buttonNon.frame.size = taille
        buttonNon.center = CGPoint(x: quart, y: y)
        buttonNon.setup(string: "Non")
        buttonNon.addTarget(self, action: #selector(non), for: .touchUpInside)
        buttonNon.isHidden = true
        container.addSubview(buttonNon)
        buttonOui.frame.size = taille
        buttonOui.center = CGPoint(x: quart * 3, y: y)
        buttonOui.setup(string: "Oui")
        buttonOui.addTarget(self, action: #selector(oui), for: .touchUpInside)
        buttonOui.isHidden = true
        container.addSubview(buttonOui)

        
    }
        
    func setGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        view.bringSubviewToFront(container)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == carte?.masque {
            let positionX = touch.location(in: container).x
            let distance = container.frame.midX - positionX
            let angle = -distance / 360
            carte?.center.x = positionX
            carte?.transform = CGAffineTransform(rotationAngle: angle)
            if distance >= 75 {
                carte?.setMasqueColor(.non)
            } else if distance <= -75 {
                carte?.setMasqueColor(.oui)
            }else {
                carte?.setMasqueColor(.peutEtre)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == carte?.masque {
            UIView.animate(withDuration: 0.3, animations: {
                self.carte?.transform = CGAffineTransform.identity
                self.carte?.frame = self.rect
                self.carte?.setMasqueColor(.peutEtre)
            }) { (success) in
                if self.carte?.reponse != .peutEtre {
                    if self.carte?.reponse == .oui {
                        self.oui()
                    }
                    if self.carte?.reponse == .non {
                        self.non()
                    }
                }
            }
        }
    }
    
    func rotation() {
        guard carte != nil else {return}
        carte?.logo = Logo(bool: Int.random(in: 0...1) % 2 == 0)
        UIView.transition(with: carte!, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    func setupGame() {
        if isGame {
            if playBoutton != nil {
                  playBoutton?.removeFromSuperview()
                  playBoutton = nil
              }
            self.carte = MaVUE(frame: rect)
            self.container.addSubview(carte ?? UIView())
            buttonOui.isHidden = false
            buttonNon.isHidden = false
            let boolRandom = Int.random(in: 0...1) % 2 == 0
            carte?.logo = Logo(bool: boolRandom)
            
            let son = Son(nom: "tictac", ext: "mp3")
            if let url = Bundle.main.url(forResource: son.nom, withExtension: son.ext) {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.numberOfLoops = 0
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }else {
            if carte != nil {
                carte?.removeFromSuperview()
                carte = nil
            }
            score = 0
            self.buttonNon.isHidden = true
            self.buttonOui.isHidden = true
            playBoutton = MonButton(frame: CGRect(x: 40, y: container.frame.height / 2 - 30, width: container.frame.width - 80, height: 60))
            playBoutton?.setup(string: "Commencer à jouer")
            playBoutton?.addTarget(self, action: #selector(playIn), for: .touchUpInside)
            container.addSubview(playBoutton ?? UIButton())
        }
        
    }
    
    func alerte() {
        var best = UserDefaults.standard.integer(forKey: "score")
        if score > best {
            best = score
            UserDefaults.standard.set(best, forKey: "score")
            UserDefaults.standard.synchronize()
        }
        let alert = UIAlertController(title: "C'est fini", message: "Votre score et de: \(score)\nLe meilleur score est de: \(best)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            // self.playIn()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func jouerSon(_ son: Son) {
        guard let url = Bundle.main.url(forResource: son.nom, withExtension: son.ext) else {return}
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
   @objc func non() {
        if self.carte?.logo?.isApple == false {
            self.score += 1
            jouerSon(sonOui)
        } else {
            jouerSon(sonNon)
    }
    scoreLabel.updateText(tempsRestant, score)
    rotation()
    }

   @objc func oui() {
        if self.carte?.logo?.isApple == true {
            self.score += 1
            jouerSon(sonOui)
        } else {
            jouerSon(sonNon)
    }
    scoreLabel.updateText(tempsRestant, score)
    rotation()
    }
    
    @objc func playIn() {
        isGame = !isGame
        setupGame()
        if isGame {
            tempsRestant = 20
            timerfunc()
        }
    }
    
    func timerfunc() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                   self.tempsRestant -= 1
                   self.scoreLabel.updateText(self.tempsRestant, self.score)
                   if self.tempsRestant == 0 {
                    self.timer.invalidate()
                    self.scoreLabel.updateText(nil, nil)
                    self.audioPlayer?.stop()
                    self.alerte()
                    self.playIn()
                    }
             })
    }
}

