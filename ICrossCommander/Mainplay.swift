//
//  GameScene.swift
//  ICrossCommander
//
//  Created by Lyt on 9/8/14.
//  Copyright (c) 2014 Lyt. All rights reserved.
//

//  This is the main game scene with trains and cars

import SpriteKit

var OnGoingTrain:Bool!  //record if the train has been here

class Mainplay: SKScene {
    //Starting porint of the cars
    let down = CGPoint(x: -400.0, y: -600.0)
    let up = CGPoint(x: 400.0, y: 600.0)
    
    //Number of cars in the line waiting
    var remain_l = 0
    var remain_r = 0
    
    let traffic_time = 7.5;
    var level = 0  //Current level
    var did_ornot = false   //Record if the first time enter the view
    
    var timer_L:NSTimer!    //Timer for the cars
    var timer_R:NSTimer!
    var timer_train:NSTimer!     //Timer for the next train
    var timer_remain:NSTimer!   //Add cars according to level
    var timer_sec:NSTimer!      //Count every second
    
    var GanZi_Up:Int = 1   //Record the pole is up or not, 1 = up －1 = down  5 = raising  -5 = getting down
    
    var track_position_down:CGFloat = 46
    var track_position_up:CGFloat = 129
    
    let track_ins = OnTrack()
    
    var backgroundS:SKSpriteNode!   //background photo
    var back_icon:SKSpriteNode!
    var track1:SKSpriteNode!        //down railway
    var track2:SKSpriteNode!        //up railway
    var truck_L:SKSpriteNode!         //left track
    var truck_R:SKSpriteNode!         //right track
    var back_components1:SKSpriteNode!  //tele pole
    var back_components2:SKSpriteNode!
    var back_components3:SKSpriteNode!
    var back_components4:SKSpriteNode!
    
    var world:Int = -1
    
    var time_left_train:Int = 0 //The time left for next train
    
    override func didMoveToView(view: SKView) {
        let ww = Bank.getworld()
        if(world != ww){
            world = ww
            if(did_ornot == true){
                track1.removeAllChildren()
                track2.removeAllChildren()
                truck_L.removeAllChildren()
                truck_R.removeAllChildren()
                
                back_components3.removeFromParent()
                
                //pole
                var str = String(format: "GanZi_level_%d_L", self.world)
                back_components3 = SKSpriteNode(texture: SKTexture(imageNamed: str))
                back_components3.anchorPoint = CGPoint(x:0.08, y:0.5)
                back_components3.position = CGPoint(x:CGRectGetMidX(self.frame) - 245, y:CGRectGetMidY(self.frame) - 10)
                back_components3.zPosition = 7
                back_components3.setScale(0.905)
                back_components3.zRotation = 1.57
                self.addChild(back_components3)
                GanZi_Up = 1
                
                //If world changed
                backgroundS.texture = SKTexture(imageNamed: String(format: "background_level_%d_L", self.world))
                back_components1.texture = SKTexture(imageNamed: String(format: "DXG_level_%d_L", self.world))
                back_components2.texture = SKTexture(imageNamed: String(format: "GanJia_level_%d_L", self.world))
                back_components4.texture = SKTexture(imageNamed: String(format: "PoliceRoom_level_%d_L", self.world))
                
                //Add the gestures again to the view
                var swipe_up = UISwipeGestureRecognizer(target: self, action: "ges_up")
                swipe_up.direction = UISwipeGestureRecognizerDirection.Up
                self.view?.addGestureRecognizer(swipe_up)
                var swipe_down = UISwipeGestureRecognizer(target: self, action: "ges_down")
                swipe_down.direction = UISwipeGestureRecognizerDirection.Down
                self.view?.addGestureRecognizer(swipe_down)
                
                self.paused = false
                
                println(time_left_train)
                timer_train = NSTimer.scheduledTimerWithTimeInterval(
                    NSTimeInterval(time_left_train),
                    target: self,
                    selector: "tcom",
                    userInfo: nil,
                    repeats: false
                )
                
                //This timer will count for when next car arrives
                timer_L = NSTimer.scheduledTimerWithTimeInterval(
                    3,
                    target: self,
                    selector: "result_L",
                    userInfo: nil,
                    repeats: true
                )
                
                timer_R = NSTimer.scheduledTimerWithTimeInterval(
                    3,
                    target: self,
                    selector: "result_R",
                    userInfo: nil,
                    repeats: true
                )
                
                timer_remain = NSTimer.scheduledTimerWithTimeInterval(
                    4,
                    target: self,
                    selector: "add_car",
                    userInfo: nil,
                    repeats: true
                )
                
                timer_sec = NSTimer.scheduledTimerWithTimeInterval(
                    1,  //count for every seconds
                    target: self,
                    selector: "count_sec",
                    userInfo: nil,
                    repeats: true
                )
            }else{
                //If world changed and game init
                
                /* Setup your scene here */
                did_ornot = true
                
                var str:String = String(format: "background_level_%d_L", self.world)
                let backgroundT = SKTexture(imageNamed:str)
                backgroundS = SKSpriteNode(texture:backgroundT)
                backgroundS.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
                self.scaleMode = SKSceneScaleMode.AspectFill
                backgroundS.setScale(0.905)
                backgroundS.zPosition = 0       //view depth
                self.addChild(backgroundS)
                
                //top rail
                track2 = SKSpriteNode()
                track2.zPosition = 3
                track2.setScale(0.905)
                self.addChild(track2)
                
                //---------------------------tracks-------------------------------
                //left track
                truck_L = SKSpriteNode()
                truck_L.position = CGPoint(x:CGRectGetMidX(self.frame) - 98, y:CGRectGetMidY(self.frame))
                truck_L.zPosition = 0
                truck_L.setScale(0.905)
                self.addChild(truck_L)
                
                //right track
                truck_R = SKSpriteNode()
                truck_R.position = CGPoint(x:CGRectGetMidX(self.frame) + 20, y:CGRectGetMidY(self.frame))
                truck_R.zPosition = 0
                truck_R.setScale(0.905)
                self.addChild(truck_R)
                //----------------------------------------------------------
                
                //tele pole
                str = String(format: "DXG_level_%d_L", self.world)
                back_components1 = SKSpriteNode(texture: SKTexture(imageNamed: str))
                back_components1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 120)
                back_components1.zPosition = 4
                back_components1.setScale(0.905)
                self.addChild(back_components1)
                
                //down rail
                track1 = SKSpriteNode()
                track1.zPosition = 5
                track1.setScale(0.905)
                self.addChild(track1)
                
                //tele pole stick
                str = String(format: "GanJia_level_%d_L", self.world)
                back_components2 = SKSpriteNode(texture: SKTexture(imageNamed: str))
                back_components2.position = CGPoint(x:CGRectGetMidX(self.frame) - 80, y:CGRectGetMidY(self.frame) - 30)
                back_components2.zPosition = 6
                back_components2.setScale(0.905)
                self.addChild(back_components2)
                
                //the stick
                str = String(format: "GanZi_level_%d_L", self.world)
                back_components3 = SKSpriteNode(texture: SKTexture(imageNamed: str))
                back_components3.anchorPoint = CGPoint(x:0.08, y:0.5)
                back_components3.zRotation = 1.57
                back_components3.position = CGPoint(x:CGRectGetMidX(self.frame) - 245, y:CGRectGetMidY(self.frame) - 10)
                back_components3.zPosition = 7
                back_components3.setScale(0.905)
                
                self.addChild(back_components3)
                
                //police room
                str = String(format: "PoliceRoom_level_%d_L", self.world)
                back_components4 = SKSpriteNode(texture: SKTexture(imageNamed: str))
                back_components4.position = CGPoint(x:CGRectGetMidX(self.frame) - 385, y:CGRectGetMidY(self.frame) - 120)
                back_components4.zPosition = 8
                back_components4.setScale(0.905)
                self.addChild(back_components4)
                
                //back_icon
                back_icon = SKSpriteNode(texture: SKTexture(imageNamed: "back_icon"))
                back_icon.position = CGPoint(x:CGRectGetMidX(self.frame) - 460, y:CGRectGetMidY(self.frame) + 235)
                back_icon.zPosition = 6
                back_icon.setScale(2.6)
                self.addChild(back_icon)
                
                self.MovementSet(0)
                
                //-----------Gesture------------
                var swipe_up = UISwipeGestureRecognizer(target: self, action: "ges_up")
                swipe_up.direction = UISwipeGestureRecognizerDirection.Up
                self.view?.addGestureRecognizer(swipe_up)
                var swipe_down = UISwipeGestureRecognizer(target: self, action: "ges_down")
                swipe_down.direction = UISwipeGestureRecognizerDirection.Down
                self.view?.addGestureRecognizer(swipe_down)
                
                //Setup the timers
                var time_rand = Int(arc4random_uniform(30))
                println(time_rand)
                time_rand += 10
                time_left_train = time_rand
                timer_train = NSTimer.scheduledTimerWithTimeInterval(
                    NSTimeInterval(time_rand),
                    target: self,
                    selector: "tcom",
                    userInfo: nil,
                    repeats: false
                )
                
                
                timer_L = NSTimer.scheduledTimerWithTimeInterval(
                    3,
                    target: self,
                    selector: "result_L",
                    userInfo: nil,
                    repeats: true
                )
                
                timer_R = NSTimer.scheduledTimerWithTimeInterval(
                    3,
                    target: self,
                    selector: "result_R",
                    userInfo: nil,
                    repeats: true
                )
                
                timer_remain = NSTimer.scheduledTimerWithTimeInterval(
                    4,  //Uset this to control traffic flow
                    target: self,
                    selector: "add_car",
                    userInfo: nil,
                    repeats: true
                )
                
                timer_sec = NSTimer.scheduledTimerWithTimeInterval(
                    1,  //count for every seconds
                    target: self,
                    selector: "count_sec",
                    userInfo: nil,
                    repeats: true
                )

                
                
            }
        }else{
            //if this is the second time get into the view
            
            //Add the gestures again to the view
            var swipe_up = UISwipeGestureRecognizer(target: self, action: "ges_up")
            swipe_up.direction = UISwipeGestureRecognizerDirection.Up
            self.view?.addGestureRecognizer(swipe_up)
            var swipe_down = UISwipeGestureRecognizer(target: self, action: "ges_down")
            swipe_down.direction = UISwipeGestureRecognizerDirection.Down
            self.view?.addGestureRecognizer(swipe_down)
            
            self.paused = false
            
            println(time_left_train)
            timer_train = NSTimer.scheduledTimerWithTimeInterval(
                NSTimeInterval(time_left_train),
                target: self,
                selector: "tcom",
                userInfo: nil,
                repeats: false
            )
            
            //This timer will count for when next car arrives
            timer_L = NSTimer.scheduledTimerWithTimeInterval(
                3,
                target: self,
                selector: "result_L",
                userInfo: nil,
                repeats: true
            )
            
            timer_R = NSTimer.scheduledTimerWithTimeInterval(
                3,
                target: self,
                selector: "result_R",
                userInfo: nil,
                repeats: true
            )
            
            timer_remain = NSTimer.scheduledTimerWithTimeInterval(
                4,
                target: self,
                selector: "add_car",
                userInfo: nil,
                repeats: true
            )
            
            timer_sec = NSTimer.scheduledTimerWithTimeInterval(
                1,  //count for every seconds
                target: self,
                selector: "count_sec",
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        back_icon.texture = SKTexture(imageNamed: "back_icon")
        var tnode:SKSpriteNode = self.nodeAtPoint((touches.first as! UITouch).locationInNode(self)) as! SKSpriteNode
        
        if(tnode.isEqual(back_icon)){
            //remove all gestures
            if let recognizers = self.view?.gestureRecognizers {
                for recognizer in recognizers {
                    self.view?.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
                }
            }
            
            //------------------- transition between scene------------------
            //Take a screenshot
            UIGraphicsBeginImageContext(CGSizeMake(1136, 640)) //Create a image in the size of the view
            self.view?.drawViewHierarchyInRect(CGRectMake(0.0, 0.0, 1136, 640), afterScreenUpdates: true)
            let shot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            Bank.storeshot(shot, num: world)    //store the screen shot
            
            Bank.storepreviousscene(2)
            Bank.storeScene(self, x: 2)
            
            //Invalid all timers
            timer_L.invalidate()
            timer_R.invalidate()
            timer_remain.invalidate()
            timer_train.invalidate()
            timer_sec.invalidate()
            
            self.paused = true
            self.view?.presentScene(Bank.getScene(6))
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var tnode:SKSpriteNode = self.nodeAtPoint((touches.first as! UITouch).locationInNode(self)) as! SKSpriteNode
        if(tnode.isEqual(back_icon)){
            back_icon.texture = SKTexture(imageNamed: "back_icon_t")
        }
    }
    
    //This function is gesture handler for the stick up
    func ges_up() {
        //slide to lift the stick

        if(GanZi_Up == -1){
            //If the sign is down, and train has come through, slide would lift the sign
            GanZi_Up = 5
            back_components3.runAction(SKAction.rotateByAngle(1.57, duration: 2), completion: {()
                self.GanZi_Up = 1
                
                for c in self.truck_L.children as! [SKSpriteNode] {
                    c.paused = false
                }
                
                for c in self.truck_R.children as! [SKSpriteNode] {
                    c.paused = false
                }
            })
        }
    }
    
    //This function is gesture handler for the stick down
    func ges_down() {
        //slide down to low the stick
        if(GanZi_Up == 1){
            GanZi_Up = -5
            //If the sign is up, slide to low the stick
            back_components3.runAction(SKAction.rotateByAngle(-1.57, duration: 2), completion: {()
                self.GanZi_Up = -1
            })
        }
    }
    
    //This function set the traffic according to the number of cars on the way
    func MovementSet(lorr:Int) {
        //This function add traffic into left or right car line    0=L 1=R
        let randnum = Int(arc4random_uniform(2))    //Random the car

        if(lorr == 0){
            //Left
            if(remain_l > 0){
                remain_l--
            }
            
            var truck1:SKSpriteNode!
            if(randnum == 0){
                truck1 = SKSpriteNode(imageNamed: "Traffic1_Z")
            }else if(randnum == 1){
                truck1 = SKSpriteNode(imageNamed: "Traffic2_ZL")
            }
            truck1.position = down
            truck1.setScale(1.0)
            truck1.zPosition = 8
            truck_L.addChild(truck1)
            
            truck1.runAction(SKAction.moveTo(up, duration: traffic_time), completion: {()
                truck1.removeFromParent()
            })
        }else{
            //Right
            if(remain_r > 0){
                remain_r--
            }
            
            var truck2:SKSpriteNode!
            if(randnum == 0){
                truck2 = SKSpriteNode(imageNamed: "Traffic1_BL")
            }else if(randnum == 1){
                truck2 = SKSpriteNode(imageNamed: "Traffic2_BL")
            }
            truck2.position = up
            truck2.setScale(1.0)
            var x:CGFloat = 0
            for c in truck_R.children as! [SKSpriteNode] {
                c.zPosition = 2 - x*0.1
                x++
            }
            
            truck2.zPosition = 2 - x*0.1
            truck_R.addChild(truck2)
            
            truck2.runAction(SKAction.moveTo(down, duration: traffic_time), completion: {()
                truck2.removeFromParent()
            })
        }
    }
    
    //This function was called every frame, here function as a observer for the situation of cars on the track
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //check for cross the railway
        for c in truck_L.children as! [SKSpriteNode] {
            if(c.position.y > 50){
                c.zPosition = 1
            }
        }
        for c in truck_R.children as! [SKSpriteNode] {
            if(c.position.y < 50){
                c.zPosition += 7
            }
        }
        
        
        //check for stop at the sign
        if(GanZi_Up != 1){
            //If the stick is down, then check every frame
            var count:CGFloat = 0;
            for c in truck_L.children as! [SKSpriteNode] {
                if(c.position.y < (-130 - count * 200) && c.position.y > (-150 - count * 200)){
                    count = count + 1.0
                    c.paused = true
                }
            }
            
            count = 0
            for c in truck_R.children as! [SKSpriteNode] {
                if(c.position.y > (210 + count * 200) && c.position.y < (230 + count * 200)){
                    count = count + 1.0
                    c.paused = true
                }
            }
        }
    }
    
    
    
    //-------------------------------Timer call backs---------------------------------
    func tcom() {
        
        timer_train.invalidate()
        
        //Train comming call back
        //This function controls how to gengerate the train
        var randnum_way = Int(arc4random_uniform(2))    //Up or Down
        var randnum_kind = Int(arc4random_uniform(2))   //Which kind of train
        if(randnum_way == 0){
            //Up way
            track2.position = CGPoint(x:CGRectGetMidX(self.frame) - 1200, y:CGRectGetMidY(self.frame) + track_position_up)
            track_ins.LetTrainGo(self.world, train: randnum_kind, trainway: track2, zhengfan: 0)
        }else if(randnum_way == 1){
            //Down way
            track1.position = CGPoint(x:CGRectGetMidX(self.frame) + 1200, y:CGRectGetMidY(self.frame) + track_position_down)
            track_ins.LetTrainGo(self.world, train: randnum_kind, trainway: track1, zhengfan: 1)
        }
        
        var time_rand = Int(arc4random_uniform(30))
        println(time_rand)
        time_rand += 30
        time_left_train = time_rand
        timer_train = NSTimer.scheduledTimerWithTimeInterval(
            NSTimeInterval(time_rand),
            target: self,
            selector: "tcom",
            userInfo: nil,
            repeats: false
        )
        
    }
    
    //Timer L R callback, if the stick is up, generate new cars on the road
    func result_L() {
        if(GanZi_Up != 1){
            var numchild = truck_L.children.count
            if(numchild < 3){
                self.MovementSet(0)
            }
        }else{
            self.MovementSet(0)
        }
    }
    
    func result_R() {
        if(GanZi_Up != 1){
            var numchild = truck_R.children.count
            if(numchild < 2){
                self.MovementSet(1)
            }
        }else{
            self.MovementSet(1)
        }
    }
    
    //Timer_remain callback
    func calculator() {
        //This function set the timer time according to the level and traffic numbers
        if(remain_l > 0){
            timer_L.invalidate()
            timer_L = NSTimer.scheduledTimerWithTimeInterval(
                1.5,
                target: self,
                selector: "result_L",
                userInfo: nil,
                repeats: true
            )
        }else{
            timer_L.invalidate()
            timer_L = NSTimer.scheduledTimerWithTimeInterval(
                3,
                target: self,
                selector: "result_L",
                userInfo: nil,
                repeats: true
            )
        }
        
        if(remain_r > 0){
            timer_R.invalidate()
            timer_R = NSTimer.scheduledTimerWithTimeInterval(
                1.5,
                target: self,
                selector: "result_R",
                userInfo: nil,
                repeats: true
            )
        }else{
            timer_R.invalidate()
            timer_R = NSTimer.scheduledTimerWithTimeInterval(
                3,
                target: self,
                selector: "result_R",
                userInfo: nil,
                repeats: true
            )
        }
        
    }
    
    //timer_remain call back
    func add_car() {
        self.calculator()
        remain_l++
        remain_r++
        
    }
    
    func count_sec() {
        //Every second counts down, used to resume game for timer
        time_left_train--
    }
    
}

















