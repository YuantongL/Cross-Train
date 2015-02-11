//
//  GameViewController.swift
//  ICrossCommander
//
//  Created by Lyt on 9/8/14.
//  Copyright (c) 2014 Lyt. All rights reserved.
//

//This class is the view controller of all scenes, init all secenes and store them in the bank

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view. 
            
            Bank.storeScene(Mainplay.init(size: CGSizeMake(scene.frame.width, scene.frame.height)), x: 2)
            Bank.storeScene(gallary.init(size: CGSizeMake(scene.frame.width, scene.frame.height)), x: 3)
            Bank.storeScene(metric.init(size: CGSizeMake(scene.frame.width, scene.frame.height)), x: 4)
            Bank.storeScene(leaderboard.init(size: CGSizeMake(scene.frame.width, scene.frame.height)), x: 5)
            Bank.storeScene(missionselect.init(size: CGSizeMake(scene.frame.width, scene.frame.height)), x: 6)
            
            
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
