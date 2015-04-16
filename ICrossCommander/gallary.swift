//
//  gallary.swift
//  ICrossCommander
//
//  Created by Lyt on 12/22/14.
//  Copyright (c) 2014 Lyt. All rights reserved.
//

//This class is the view of gallary

import Foundation
import SpriteKit

var grav:CGFloat = 0 //scrolling gravity count
var dograv = false

class gallary: SKScene {
    
    var did = false;    //Record if the first time enter the view
    
    var back:SKSpriteNode!  //Back button
    var background:SKSpriteNode! //Background
    var gallary_content:[SKSpriteNode] = []
    
    override func didMoveToView(view: SKView) {
        if(did == false){
            did = true
            self.scaleMode = SKSceneScaleMode.AspectFill
            
            //Background
            background = SKSpriteNode(texture:SKTexture(imageNamed:"background_gallary"))
            background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            background.setScale(0.91)
            background.zPosition = 1
            self.addChild(background)
            
            //Back button
            back = SKSpriteNode(texture: SKTexture(imageNamed: "back_icon"))
            back.position = CGPoint(x:CGRectGetMidX(self.frame) - 460, y:CGRectGetMidY(self.frame) + 235)
            back.zPosition = 6
            back.setScale(2.6)
            self.addChild(back)
            
            var transit_fan:SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "transit_zheng"))
            transit_fan.position = CGPoint(x:CGRectGetMidX(self.frame) + 130, y:CGRectGetMidY(self.frame))
            transit_fan.zPosition = 100
            transit_fan.setScale(1.0)
            self.addChild(transit_fan)
            
            //Add 10 elements into the array
            for i in 0...9{
                var content:SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "gallary_content"))
                content.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGFloat(550 - i*130))
                content.zPosition = 2
                self.addChild(content)
                var t:SKLabelNode = SKLabelNode(text: String(i))
                content.addChild(t)
                gallary_content.append(content)
            }
            
            transit_fan.runAction(SKAction.moveTo(CGPoint(x:CGRectGetMidX(self.frame) - 1200, y:CGRectGetMidY(self.frame)), duration: 0.5), completion: {()
                transit_fan.removeFromParent()
            })
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
    
    //----------------------Functions for touches----------------------
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch:UITouch = touches.first as! UITouch
        
        let pnow:CGPoint = touch.locationInNode(self)
        let pold:CGPoint = touch.previousLocationInNode(self)
        
        let tran:CGFloat = pnow.y - pold.y  //If < zero, move upwards
        
        if(tran < 0 && gallary_content[0].position.y > 550){
            //Going upwards
            if(gallary_content[0].position.y + tran < 550){
                for k in 0...gallary_content.count - 1{
                    gallary_content[k].position = CGPoint(x: CGRectGetMidX(self.frame), y: CGFloat(550 - k*130))
                }
            }else{
                grav = tran
                for i in 0...gallary_content.count - 1{
                    gallary_content[i].position.y += tran
                }
            }
        }else if(tran > 0 && gallary_content[gallary_content.count - 1].position.y < 200){
            //Going downwards
            if(gallary_content[gallary_content.count - 1].position.y + tran > 200){
                for k in 0...gallary_content.count - 1{
                    gallary_content[k].position = CGPoint(x: CGRectGetMidX(self.frame), y: CGFloat(200 + (gallary_content.count - 1 - k)*130))
                }
            }else{
                grav = tran
                for i in 0...gallary_content.count - 1{
                    gallary_content[i].position.y += tran
                }
            }
        }
        
        if(grav < -50){
            grav = -50
        }else if(grav > 50){
            grav = 50
        }
        
    }
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        dograv = true
        
        back.texture = SKTexture(imageNamed: "back_icon")
        var tnode:SKSpriteNode = self.nodeAtPoint((touches.first as! UITouch).locationInNode(self)) as! SKSpriteNode
        
        if(tnode.isEqual(back)){
            //back to main
            var transit_zheng:SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "transit_zheng"))
            transit_zheng.position = CGPoint(x:CGRectGetMidX(self.frame) - 1200, y:CGRectGetMidY(self.frame))
            transit_zheng.zPosition = 100
            transit_zheng.setScale(1.0)
            self.addChild(transit_zheng)
            
            transit_zheng.runAction(SKAction.moveTo(CGPoint(x:CGRectGetMidX(self.frame) + 160, y:CGRectGetMidY(self.frame)), duration: 0.5), completion: {()
                //Set back the content places
                grav = 0
                for k in 0...self.gallary_content.count - 1{
                    self.gallary_content[k].position = CGPoint(x: CGRectGetMidX(self.frame), y: CGFloat(550 - k*130))
                }
                Bank.storeScene(self, x: 3)
                self.view?.presentScene(Bank.getScene(1))
                transit_zheng.removeFromParent()
            })
        }
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        dograv = false
        
        var tnode:SKSpriteNode = self.nodeAtPoint((touches.first as! UITouch).locationInNode(self)) as! SKSpriteNode
        if(tnode.isEqual(back)){
            back.texture = SKTexture(imageNamed: "back_icon_t")
        }
    }
    //----------------------End of touch functions----------------------
    
    //This function was called each frame
    override func update(currentTime: CFTimeInterval) {
        //This function is used to implement scrolling gravity
        if(dograv == true){
            if(grav > 0){
                //Go upwards
                if(gallary_content[gallary_content.count - 1].position.y < 200){
                    if(gallary_content[gallary_content.count - 1].position.y + grav > 200){
                        for k in 0...gallary_content.count - 1{
                            gallary_content[k].position = CGPoint(x: CGRectGetMidX(self.frame), y: CGFloat(200 + (gallary_content.count - 1 - k)*130))
                        }
                        grav = 0
                    }else{
                        for k in 0...gallary_content.count - 1{
                            gallary_content[k].position = CGPoint(x: CGRectGetMidX(self.frame), y: gallary_content[k].position.y + grav)
                        }
                        grav -= 2.0
                        if(grav < 0){
                            grav = 0
                        }
                    }
                }else{
                    grav = 0
                }
            }else if(grav < 0){
                //Go down
                if(gallary_content[0].position.y > 550){
                    if(gallary_content[0].position.y + grav < 550){
                        for k in 0...gallary_content.count - 1{
                            gallary_content[k].position = CGPoint(x: CGRectGetMidX(self.frame), y: CGFloat(550 - k*130))
                        }
                        grav = 0
                    }else{
                        for k in 0...gallary_content.count - 1{
                            gallary_content[k].position = CGPoint(x: CGRectGetMidX(self.frame), y: gallary_content[k].position.y + grav)
                        }
                        grav += 2.0
                        if(grav > 0){
                            grav = 0
                        }
                    }
                }else{
                    grav = 0
                }
            }
        }
    }


}







