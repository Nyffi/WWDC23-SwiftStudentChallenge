//
//  MainScene.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 30/03/23.
//

import Foundation
import SpriteKit

class MainScene: SKScene {
    var mainNodes: [SKNode] = []
    var music: SKAudioNode = SKAudioNode()
    
    override func didMove(to view: SKView) {
        let cfURL = Bundle.main.url(forResource: "IM_FELL_DW_Pica_Roman_SC", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        
        mainNodes = self.children.filter({ $0.name?.contains(["Menu"]) == true })
        music = SKAudioNode(fileNamed: "menuMusic")
        music.run(.changeVolume(to: 0.75, duration: 0))
        addChild(music)
        
        print(mainNodes)
        
        if UserDefaults.standard.bool(forKey: "gameHasBeenPlayed") {
            UserDefaults.standard.set(false, forKey: "gameHasBeenPlayed")
            
            let newScoreValue = UserDefaults.standard.integer(forKey: "currentAttemptScore")
            let highScoreValue = UserDefaults.standard.integer(forKey: "highScore")
            
            for node in mainNodes {
                node.isHidden = true
            }
            
            guard let scoreNode = mainNodes.first(where: { $0.name == "scoreMenu" }) else {
                mainNodes[0].isHidden = false; return
            }
            scoreNode.isHidden = false
            
            guard let newScore = scoreNode.childNode(withName: "lblScoreValueNew") as? SKLabelNode else {return}
            guard let oldScore = scoreNode.childNode(withName: "lblScoreValueOld") as? SKLabelNode else {return}
            
            newScore.text = String(format: "%08d", newScoreValue)
            oldScore.text = String(format: "%08d", highScoreValue)
        }
    }
    
    func touchDown(atPoint pos: CGPoint) {
        if self.nodes(at: pos).contains(where: { $0.name == "btnStart" }) {
            for node in mainNodes {
                node.isHidden = true
            }
            
            guard let tutorialNode = mainNodes.first(where: { $0.name == "tutorialMenu" }) else { mainNodes[0].isHidden = false; return }
            tutorialNode.isHidden = false
            return
        }
        
        if self.nodes(at: pos).contains(where: { $0.name == "btnAbout" }) {
            for node in mainNodes {
                node.isHidden = true
            }
            
            guard let aboutNode = mainNodes.first(where: { $0.name == "aboutMenu" }) else { mainNodes[0].isHidden = false; return }
            aboutNode.isHidden = false
            return
        }
        
        if self.nodes(at: pos).contains(where: { $0.name == "btnBack" }) {
            for node in mainNodes {
                node.isHidden = true
            }
            
            guard let mainNode = mainNodes.first(where: { $0.name == "mainMenu" }) else { mainNodes[0].isHidden = false; return }
            mainNode.isHidden = false
            return
        }
        
        if self.nodes(at: pos).contains(where: { $0.name == "btnBegin" }) {
            SceneManager.switchScenes(from: self, to: .Level)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
}
