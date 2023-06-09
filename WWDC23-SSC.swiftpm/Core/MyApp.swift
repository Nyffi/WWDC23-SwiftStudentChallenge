import SwiftUI
import SpriteKit

@main
struct MyApp: App {
    var scene: SKScene {
        guard let scene = MainScene(fileNamed: "MainMenu") else { return MainScene() }
        scene.size = CGSize(width: 720, height: 960) // 960 x 720
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some Scene {
        WindowGroup {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .previewInterfaceOrientation(.portrait)
        }
    }
}
