//
//  metric.swift
//  ICrossCommander
//
//  Created by Lyt on 12/22/14.
//  Copyright (c) 2014 Lyt. All rights reserved.
//

//This is the class for metric

import Foundation
import SpriteKit

class metric: SKScene {
    
    var back:SKSpriteNode!
    var background:SKSpriteNode!
    var did = false;
    
    override func didMoveToView(view: SKView) {
        if(did == false){
            did = true
            self.scaleMode = SKSceneScaleMode.AspectFill
            //Background
            background = SKSpriteNode(texture:SKTexture(imageNamed:"background_metric"))
            background.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            //background.setScale(0.91)
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
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        back.texture = SKTexture(imageNamed: "back_icon")
        var tnode:SKSpriteNode = self.nodeAtPoint((touches.anyObject() as UITouch).locationInNode(self)) as SKSpriteNode
        
        if(tnode.isEqual(back)){
            //back to main
            var transit_zheng:SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "transit_zheng"))
            transit_zheng.position = CGPoint(x:CGRectGetMidX(self.frame) - 1200, y:CGRectGetMidY(self.frame))
            transit_zheng.zPosition = 100
            transit_zheng.setScale(1.0)
            self.addChild(transit_zheng)
            
            transit_zheng.runAction(SKAction.moveTo(CGPoint(x:CGRectGetMidX(self.frame) + 160, y:CGRectGetMidY(self.frame)), duration: 0.5), completion: {()
                Bank.storeScene(self, x: 4)
                self.view?.presentScene(Bank.getScene(1))
                transit_zheng.removeFromParent()
            })
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var tnode:SKSpriteNode = self.nodeAtPoint((touches.anyObject() as UITouch).locationInNode(self)) as SKSpriteNode
        if(tnode.isEqual(back)){
            back.texture = SKTexture(imageNamed: "back_icon_t")
        }
    }
    //----------------------end of function of touches----------------------

}