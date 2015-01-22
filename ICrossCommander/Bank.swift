//
//  Bank.swift
//  ICrossCommander
//
//  Created by Lyt on 11/14/14.
//  Copyright (c) 2014 Lyt. All rights reserved.
//
//  This is the class stored everything I need
//

import Foundation
import SpriteKit


struct Bank {
    
    static var FirstScene:SKScene!  //1
    static var PlayScene:SKScene!   //2
    static var GallaryScene:SKScene!    //3
    static var MetricScene:SKScene!     //4
    static var LeaderboardScene:SKScene!    //5
    static var MissionScene:SKScene!    //6
    
    static var previous_scene:Int = 0  //previous scene
    
    static var sc_shot = [UIImage]()   //Save the screenshots, dictionary
    
    static var whichworld:Int = 0
    
    //------------Level-------------
    //world stores from 1 to... just use the value will from 1...
    static func getworld() -> Int {
        return self.whichworld
    }
    
    static func storeworld(w:Int) {
        self.whichworld = w
    }
    
    //------------Scenes------------
    static func getScene(x:Int) -> SKScene {
        //Get the scene
        var returnScene:SKScene!
        if(x == 1){
            returnScene = self.FirstScene
        }else if(x == 2){
            returnScene = self.PlayScene
        }else if(x == 3){
            returnScene = self.GallaryScene
        }else if(x == 4){
            returnScene = self.MetricScene
        }else if(x == 5){
            returnScene = self.LeaderboardScene
        }else if(x == 6){
            returnScene = self.MissionScene
        }
        return returnScene
    }
    
    static func storeScene(aScene:SKScene, x:Int) {
        //Push the scene
        if(x == 1){
            self.FirstScene = aScene
        }else if(x == 2){
            self.PlayScene = aScene
        }else if(x == 3){
            self.GallaryScene = aScene
        }else if(x == 4){
            self.MetricScene = aScene
        }else if(x == 5){
            self.LeaderboardScene = aScene
        }else if(x == 6){
            self.MissionScene = aScene
        }
    }
    
    
    //---------------previous scene---------------
    static func getpreviousscene() -> Int {
        return self.previous_scene
    }
    
    static func storepreviousscene(x:Int) {
        self.previous_scene = x
    }
    
    //-----------------screen shot------------------
    //store number of level from 1 to
    static func getshot(num:Int) -> UIImage {
        //num is level of 关
        return sc_shot[num - 1]
    }
    
    static func storeshot(im:UIImage, num:Int) {
        sc_shot[num - 1] = im
    }
}






