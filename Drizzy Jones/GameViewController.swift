//
//  GameViewController.swift
//  Drizzy Jones
//
//  Created by Nishant on 2015-12-19.
//  Copyright (c) 2015 Epicara. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeScene()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Scene Intializer
    
    func initializeScene()
    {
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            var skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.scene?.size = skView.bounds.size
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
        }
    }
}
