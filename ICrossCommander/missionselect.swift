//
//  missionselect.swift
//  ICrossCommander
//
//  Created by Lyt on 12/23/14.
//  Copyright (c) 2014 Lyt. All rights reserved.
//

//This class is the view of mission select

import Foundation
import SpriteKit

var zeropoint:CGFloat! //zero point for every page

class missionselect:SKScene {
    
    var background:SKSpriteNode!
    var earth:SKSpriteNode!
    var back:SKSpriteNode!
    var left:SKSpriteNode!
    var right:SKSpriteNode!
    var alert_box:SKSpriteNode!
    var alert_yes:SKSpriteNode!
    var alert_no:SKSpriteNode!
    
    //var panel:SKSpriteNode!     //The panel to place missions
    
    var mission_array:[SKSpriteNode] = []    //Missions
    var did = false
    var current_page = 1    //Record which page it is in
    
    override func didMoveToView(view: SKView) {
        if(did == false){
            did = true
            zeropoint = CGRectGetMidX(self.frame)
            self.scaleMode = SKSceneScaleMode.AspectFill
            
            //Background
            background = SKSpriteNode(texture:SKTexture(imageNamed:"background_mission"))
            background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            background.setScale(0.91)
            background.zPosition = 1
            self.addChild(background)
            
            //earth
            earth = SKSpriteNode(texture:SKTexture(imageNamed:"Earth"))
            earth.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 550)
            earth.setScale(1.6)
            earth.zPosition = 1
            self.addChild(earth)
            
            let action_r:SKAction = SKAction.repeatActionForever(SKAction.rotateByAngle(3.0, duration: 20.0))
            earth.runAction(action_r)
            
            //Declare gestures
            var swipe_right = UISwipeGestureRecognizer(target: self, action: "ges_right")
            swipe_right.direction = UISwipeGestureRecognizerDirection.Right
            self.view?.addGestureRecognizer(swipe_right)
            var swipe_left = UISwipeGestureRecognizer(target: self, action: "ges_left")
            swipe_left.direction = UISwipeGestureRecognizerDirection.Left
            self.view?.addGestureRecognizer(swipe_left)
            
            //Back button
            back = SKSpriteNode(texture: SKTexture(imageNamed: "back_icon"))
            back.position = CGPoint(x:CGRectGetMidX(self.frame) - 460, y:CGRectGetMidY(self.frame) + 235)
            back.zPosition = 6
            back.setScale(2.6)
            self.addChild(back)
            
            //left and right
            left = SKSpriteNode(texture: SKTexture(imageNamed: "turn_page_left"))
            left.position = CGPoint(x:CGRectGetMidX(self.frame) - 440, y:CGRectGetMidY(self.frame))
            left.zPosition = 6
            left.setScale(1.5)
            self.addChild(left)
            left.hidden = true
            
            right = SKSpriteNode(texture: SKTexture(imageNamed: "turn_page_right"))
            right.position = CGPoint(x:CGRectGetMidX(self.frame) + 440, y:CGRectGetMidY(self.frame))
            right.zPosition = 6
            right.setScale(1.5)
            self.addChild(right)
            
            //Alert box
            alert_box = SKSpriteNode(texture:SKTexture(imageNamed:"alert_box"))
            alert_box.position = CGPoint(x:CGRectGetMidX(self.frame) + 100, y:CGRectGetMidY(self.frame) + 100)
            alert_box.setScale(0.4)
            alert_box.zRotation = -0.2
            
            alert_box.alpha = 0.0
            alert_box.zPosition = 8
            
            alert_yes = SKSpriteNode(texture:SKTexture(imageNamed:"alert_yes"))
            alert_yes.position = CGPoint(x:-300, y:-200)
            alert_yes.setScale(0.7)
            alert_yes.zPosition = 9
            alert_box.addChild(alert_yes)
            
            alert_no = SKSpriteNode(texture:SKTexture(imageNamed:"alert_no"))
            alert_no.position = CGPoint(x:300, y:-200)
            alert_no.setScale(0.7)
            alert_no.zPosition = 9
            alert_box.addChild(alert_no)
            
            //Missions
            for i in 1...5{
                //Store image in bank
                var str:NSString = NSString(format: "mission_%d", i)
                var content:UIImage = UIImage(named: str as String)!
                Bank.sc_shot.append(content)
            }
            
            for i in 1...5{
                var str:NSString = NSString(format: "mission_%d", i)
                var content:SKSpriteNode = SKSpriteNode(texture: SKTexture(image: Bank.getshot(i)))
                content.position = CGPoint(x: CGRectGetMidX(self.frame) + CGFloat(i) * CGRectGetWidth(self.frame), y: CGRectGetMidY(self.frame))
                content.zPosition = 2
                content.setScale(0.5)
                self.addChild(content)
                mission_array.append(content)
            }
            
            var transit_fan:SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "transit_zheng"))
            transit_fan.position = CGPoint(x:CGRectGetMidX(self.frame) + 130, y:CGRectGetMidY(self.frame))
            transit_fan.zPosition = 100
            transit_fan.setScale(1.0)
            self.addChild(transit_fan)
            
            transit_fan.runAction(SKAction.moveTo(CGPoint(x:CGRectGetMidX(self.frame) - 1200, y:CGRectGetMidY(self.frame)), duration: 0.5), completion: {()
                transit_fan.removeFromParent()
            })
            
        }else{
            //Add gestures again
            var swipe_right = UISwipeGestureRecognizer(target: self, action: "ges_right")
            swipe_right.direction = UISwipeGestureRecognizerDirection.Right
            self.view?.addGestureRecognizer(swipe_right)
            var swipe_left = UISwipeGestureRecognizer(target: self, action: "ges_left")
            swipe_left.direction = UISwipeGestureRecognizerDirection.Left
            self.view?.addGestureRecognizer(swipe_left)
            
            if(Bank.getpreviousscene() == 2){
                Bank.storepreviousscene(0)  //Reset previous scene, in order to run the effect
                mission_array[Bank.getworld()-1].texture = SKTexture(image: Bank.getshot(Bank.getworld()))
                
                //shrink effect
                let aa:SKAction = SKAction.scaleBy(0.5, duration: 0.3)
                mission_array[current_page - 1].runAction(aa)
            }else{
                var transit_fan:SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "transit_zheng"))
                transit_fan.position = CGPoint(x:CGRectGetMidX(self.frame) + 130, y:CGRectGetMidY(self.frame))
                transit_fan.zPosition = 100
                transit_fan.setScale(1.0)
                self.addChild(transit_fan)
                
                transit_fan.runAction(SKAction.moveTo(CGPoint(x:CGRectGetMidX(self.frame) - 1200, y:CGRectGetMidY(self.frame)), duration: 0.5), completion: {()
                    transit_fan.removeFromParent()
                })
            }
        }
    }
    
    //----------------------Function for touches----------------------
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var tnode:SKSpriteNode = self.nodeAtPoint((touches.first as! UITouch).locationInNode(self)) as! SKSpriteNode
        
        if(tnode.isEqual(back)){
            back.texture = SKTexture(imageNamed: "back_icon_t")
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        back.texture = SKTexture(imageNamed: "back_icon")
        var tnode:SKSpriteNode = self.nodeAtPoint((touches.first as! UITouch).locationInNode(self)) as! SKSpriteNode
        
        if(tnode.isEqual(back)){
            //back to main
            var transit_zheng:SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "transit_zheng"))
            transit_zheng.position = CGPoint(x:CGRectGetMidX(self.frame) - 1200, y:CGRectGetMidY(self.frame))
            transit_zheng.zPosition = 100
            transit_zheng.setScale(1.0)
            self.addChild(transit_zheng)
            
            //remove all gestures
            if let recognizers = self.view?.gestureRecognizers {
                for recognizer in recognizers {
                    self.view?.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
                }
            }
            
            transit_zheng.runAction(SKAction.moveTo(CGPoint(x:CGRectGetMidX(self.frame) + 160, y:CGRectGetMidY(self.frame)), duration: 0.5), completion: {()
                Bank.storeScene(self, x: 6)
                self.view?.presentScene(Bank.getScene(1))
                transit_zheng.removeFromParent()
            })
        }else if(tnode.isEqual(left)){
            //turn page left
            ges_right()
        }else if(tnode.isEqual(right)){
            //turn page right
            ges_left()
        }else if(tnode.isEqual(alert_yes)){
            //click yes
            var fadein_act:SKAction = SKAction.fadeAlphaTo(0.0, duration: 0.2)
            var move_act:SKAction = SKAction.moveTo(CGPoint(x:CGRectGetMidX(self.frame) - 100, y:CGRectGetMidY(self.frame) + 100), duration: 0.2)
            var rotate_act:SKAction = SKAction.rotateByAngle(0.2, duration: 0.2)
            var combine:[SKAction] = [fadein_act, move_act, rotate_act]
            
            var combine_act:SKAction = SKAction.group(combine)
            self.alert_box.runAction(combine_act, completion: {()
                self.alert_box.position = CGPoint(x:CGRectGetMidX(self.frame) + 100, y:CGRectGetMidY(self.frame) + 100)
                self.alert_box.zRotation = -0.2
                self.alert_box.removeFromParent()
                
                let aa:SKAction = SKAction.scaleBy(2.0, duration: 0.3)
                self.mission_array[self.current_page - 1].runAction(aa, completion: {()
                    Bank.storeworld(self.current_page)
                    Bank.storeScene(self, x: 6)
                    self.view?.presentScene(Bank.getScene(2))
                })
            })
        }else if(tnode.isEqual(alert_no)){
            //click no
            fadeout_alertbox()
        }else{
            for k in 0...4{
                if(tnode.isEqual(mission_array[k])){
                    //remove all gestures
                    if let recognizers = self.view?.gestureRecognizers {
                        for recognizer in recognizers {
                            self.view?.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
                        }
                    }
                    
                    if(Bank.getworld() == 0 || Bank.getworld() == self.current_page){
                        //If no previous world, or going in existing world
                        //enlarge the picture and enter
                        let aa:SKAction = SKAction.scaleBy(2.0, duration: 0.3)
                        mission_array[k].runAction(aa, completion: {()
                            Bank.storeworld(k + 1)
                            Bank.storeScene(self, x: 6)
                            self.view?.presentScene(Bank.getScene(2))
                        })
                    }else{
                        //Else if going in a new world, pop out the box
                        fadein_alertbox()
                    }
                    //println(k)
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var tnode:SKSpriteNode = self.nodeAtPoint((touches.first as! UITouch).locationInNode(self)) as! SKSpriteNode
        if(!tnode.isEqual(back)){
            back.texture = SKTexture(imageNamed: "back_icon")
        }
    }
    //----------------------end of touch functions----------------------
    
    //----------------------Gesture handlers----------------------
    func ges_right(){
        //Handles swipe right, turn page left
        if(current_page != 1){
            zeropoint  = zeropoint + CGRectGetWidth(self.frame)
            current_page--
            
            let a1:SKAction = SKAction.fadeOutWithDuration(0.25)
            let a2:SKAction = SKAction.fadeInWithDuration(0.25)
            let actt:[SKAction] = [a1, a2]
            let act:SKAction = SKAction.sequence(actt)
            left.runAction(act)
            if(current_page == 1){
                left.hidden = true
                right.runAction(act)
            }else if(current_page == 4){
                right.hidden = false
                left.runAction(act)
            }else{
                left.runAction(act)
                right.runAction(act)
            }
        }
    }
    
    func ges_left(){
        //Handles swipe left, turn page right
        if(current_page != 5){
            zeropoint = zeropoint - CGRectGetWidth(self.frame)
            current_page++
            
            let a1:SKAction = SKAction.fadeOutWithDuration(0.25)
            let a2:SKAction = SKAction.fadeInWithDuration(0.25)
            let actt:[SKAction] = [a1, a2]
            let act:SKAction = SKAction.sequence(actt)
            if(current_page == 2){
                left.hidden = false
                right.runAction(act)
            }else if(current_page == 5){
                right.hidden = true
                left.runAction(act)
            }else{
                left.runAction(act)
                right.runAction(act)
            }
            
        }
    }
    //----------------------end of gesture functions----------------------
    
    //This function is called every frame, here for moving the background
    override func update(currentTime: CFTimeInterval) {
        //Use to turn pages
        var v = (zeropoint - mission_array[0].position.x)/8
        if(v != 0){
            if(abs(zeropoint - mission_array[0].position.x) < 7){
                mission_array[0].position.x = zeropoint
            }else{
                if(v < 7 && v > 0){
                    v = 7
                }else if(v > -7 && v < 0){
                    v = -7
                }
                for i in 0...4{
                    mission_array[i].position.x += v
                }
            }
        }
    }
    
    //This function is called when user wish to start a new game, push the alert to notify the user
    func fadein_alertbox(){
        self.addChild(alert_box)
        var fadein_act:SKAction = SKAction.fadeAlphaTo(1.0, duration: 0.2)
        var move_act:SKAction = SKAction.moveTo(CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)), duration: 0.2)
        var rotate_act:SKAction = SKAction.rotateByAngle(0.2, duration: 0.2)
        var combine:[SKAction] = [fadein_act, move_act, rotate_act]
        var combine_act:SKAction = SKAction.group(combine)
        self.alert_box.runAction(combine_act)
    }
    
    //This function is called to fade out the alerbox just shown
    func fadeout_alertbox(){
        var fadein_act:SKAction = SKAction.fadeAlphaTo(0.0, duration: 0.2)
        var move_act:SKAction = SKAction.moveTo(CGPoint(x:CGRectGetMidX(self.frame) - 100, y:CGRectGetMidY(self.frame) + 100), duration: 0.2)
        var rotate_act:SKAction = SKAction.rotateByAngle(0.2, duration: 0.2)
        var combine:[SKAction] = [fadein_act, move_act, rotate_act]
        var combine_act:SKAction = SKAction.group(combine)
        self.alert_box.runAction(combine_act, completion: {()
            self.alert_box.position = CGPoint(x:CGRectGetMidX(self.frame) + 100, y:CGRectGetMidY(self.frame) + 100)
            self.alert_box.zRotation = -0.2
            self.alert_box.removeFromParent()
            
        })
    }
}







