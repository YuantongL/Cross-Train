//
//  OnTrack.swift
//  ICrossCommander
//
//  Created by Lyt on 12/20/14.
//  Copyright (c) 2014 Lyt. All rights reserved.
//

//  This class serves for control the train on track

import Foundation
import SpriteKit

class OnTrack {
    
    func GetComponent(world:Int, train:Int, compo:String) -> SKSpriteNode {
        var returnnode:SKSpriteNode!
        var wstr:String!
        
        switch world{
        case 0:
            wstr = "China"
        case 1:
            wstr = "USA"
        case 2:
            wstr = "Euro"
        case 3:
            wstr = "Japan"
        default:
            println("default\n")
        }
        
        var str:NSString = String(format: "Train_%@_%d_%@_L", wstr, train + 1, compo)
        
        returnnode = SKSpriteNode(imageNamed: str as String)
        
        return returnnode
    }
    
    //When this function is called, it generate one train and put it on the rail
    //This function used to call a train on to the secreen, when train is out, get the sknodes remove
    func LetTrainGo(world:Int, train:Int, trainway:SKSpriteNode, zhengfan:Int) {
        //zhengfan = 0 = up, 1 = down
        let train_scale:CGFloat = 1.03
        var Distance:Float = 720 //The interval between each train sections
        var NumOfObjects:NSInteger = 6   //Total number of sections
                
        //Head--------------------------------------------------
        var train_head:SKSpriteNode!
        train_head = self.GetComponent(world, train: train, compo: "Head")
        train_head.position = CGPoint(x: 0, y: 0) //The initial positon of the head
        train_head.setScale(train_scale);
        
        if(zhengfan == 0){
            train_head.xScale = train_head.xScale * -1
        }else if(zhengfan == 1){
            
        }
        
        trainway.addChild(train_head)
        
        //Mid--------------------------------------------------
        for i in 0...NumOfObjects
        {
            var train_mid:SKSpriteNode!
            train_mid = self.GetComponent(world, train: train, compo: "Mid")
            train_mid.setScale(train_scale)
            
            if(zhengfan == 0){
                train_mid.xScale = train_mid.xScale * -1
                train_mid.position = CGPoint(x: CGFloat(-Distance * Float(i + 1)), y: 0)
            }else if(zhengfan == 1){
                train_mid.position = CGPoint(x: CGFloat(Distance * Float(i + 1)), y: 0)
            }
            
            trainway.addChild(train_mid)
        }
        
        
        //End--------------------------------------------------
        var train_end:SKSpriteNode!
        train_end = self.GetComponent(world, train: train, compo: "End")
        
        train_end.position = CGPoint(x: CGFloat(-Distance * Float(NumOfObjects + 2)), y: 0)
        train_end.setScale(train_scale)
        
        if(zhengfan == 0){
            train_end.position = CGPoint(x: CGFloat(-Distance * Float(NumOfObjects + 2)), y: 0)
            train_end.xScale = train_end.xScale * -1
        }else if(zhengfan == 1){
            train_end.position = CGPoint(x: CGFloat(Distance * Float(NumOfObjects + 2)), y: 0)
        }
        
        trainway.addChild(train_end)
        
        
        
        //Other---------------animations-----------------------------------
        var run_time:NSTimeInterval!    //Time of train stay on the rail, used to control speed
        if(train == 0){
            run_time = 8
        }else if(train == 1){
            run_time = 17
        }
        
        if(zhengfan == 0){
            var arrow:SKSpriteNode = SKSpriteNode(imageNamed: "arrow_left")
            arrow.position = CGPoint(x: 260, y: 480)
            arrow.setScale(2.0)
            arrow.zPosition = 50
            trainway.parent?.addChild(arrow)
            
            let a1:SKAction = SKAction.hide()
            let a2:SKAction = SKAction.unhide()
            let w:SKAction = SKAction.waitForDuration(0.5)
            let actt:[SKAction] = [a2, w, a1, w]
            let act:SKAction = SKAction.repeatAction(SKAction.sequence(actt), count: 20)
            
            arrow.runAction(act, completion: {()
                arrow.removeFromParent()
                trainway.runAction(SKAction.moveTo(CGPointMake(7000, trainway.position.y), duration: run_time), completion: {()
                    trainway.position = CGPoint(x:-1200, y:trainway.position.y)
                    trainway.removeAllChildren()  //remove all child
                    OnGoingTrain = false    //Set the sign of trains on the rail
                })
            })
            
        }else if(zhengfan == 1){
            
            var arrow:SKSpriteNode = SKSpriteNode(imageNamed: "arrow_right")
            arrow.position = CGPoint(x: 780, y: 390)
            arrow.setScale(2.0)
            arrow.zPosition = 50
            trainway.parent?.addChild(arrow)
            
            let a1:SKAction = SKAction.hide()
            let a2:SKAction = SKAction.unhide()
            let w:SKAction = SKAction.waitForDuration(0.5)
            let actt:[SKAction] = [a2, w, a1, w]
            let act:SKAction = SKAction.repeatAction(SKAction.sequence(actt), count: 20)
            
            arrow.runAction(act, completion: {()
                trainway.runAction(SKAction.moveTo(CGPointMake(-7000, trainway.position.y), duration: run_time), completion: {()
                    arrow.removeFromParent()
                    trainway.position = CGPoint(x:1200, y:trainway.position.y)
                    trainway.removeAllChildren()
                    OnGoingTrain = false
                })
            })
            
        }
        
    }

}



