//
//  GameScene.swift
//  Drizzy Jones
//
//  Created by Nishant on 2015-12-19.
//  Copyright (c) 2015 Epicara. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var score = 0
    var health = 5
    var gameOver : Bool?
    let maxNumberOfShips = 10
    var currentNumberOfShips : Int?
    var timeBetweenShips : Double?
    var moverSpeed = 7.5
    let moveFactor = 1.05
    var now : NSDate?
    var nextTime : NSDate?
    var gameOverLabel : SKLabelNode?
    var healthLabel : SKLabelNode?
    let background = SKSpriteNode(imageNamed: "Jones")
    var isFirstTimeLaunch = true
    var button: SKNode?
    
    /*
    Entry point into our scene
    */
    override func didMoveToView(view: SKView) {
        
        initializeValues()
    }
    
    /*
    Sets the initial values for our variables.
    */
    func initializeValues(){
        
        self.removeAllChildren()
        background.size = CGSize(width: self.frame.size.width/2.6, height: self.frame.size.width/2.6)
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        self.insertChild(background, atIndex: 0)
//        self.addChild(background)
        
        score = 0
        gameOver = false
        currentNumberOfShips = 0
        timeBetweenShips = 1.0
        moverSpeed = 5.0
        health = 5
        nextTime = NSDate()
        now = NSDate()
        
        healthLabel = SKLabelNode(fontNamed:"System")
        healthLabel?.text = "Health: \(health)"
        healthLabel?.fontSize = 20
        healthLabel?.fontColor = SKColor.whiteColor()
        healthLabel?.position = CGPoint(x:CGRectGetMinX(self.frame) + 45, y:(CGRectGetMinY(self.frame) + 3));
        
        
        self.addChild(healthLabel!)
        
        print("Height - \(self.view?.frame.height)")
        print("Wodth - \(self.view?.frame.width)")
        
        print("initializeValues")
    }
    
    /*
    Called before each frame is rendered
    */
    override func update(currentTime: CFTimeInterval) {
        
        if (checkIfFirstTimeLaunch() == false)
        {
            healthLabel?.text="Health: \(health)"
            if(health <= 3){
                healthLabel?.fontColor = SKColor.redColor()
            }
            
            let constX = UInt32((self.view?.frame.width)!) //1024
            
            now = NSDate()
            if (currentNumberOfShips < maxNumberOfShips &&
                now?.timeIntervalSince1970 > nextTime?.timeIntervalSince1970 &&
                health > 0){
                    
                    nextTime = now?.dateByAddingTimeInterval(NSTimeInterval(timeBetweenShips!))
                    let newX = Int(arc4random()%constX)
                    let newY = Int(self.frame.height+10)
                    let p = CGPoint(x:newX,y:newY)
                    let destination =  CGPoint(x: CGFloat(newX), y: CGFloat(0.0))
                    
                    createShip(p, destination: destination)
                    
                    moverSpeed = moverSpeed/moveFactor
                    timeBetweenShips = timeBetweenShips!/moveFactor
            }
            checkIfShipsReachTheBottom()
            checkIfGameIsOver()
        }
        
    }
    
    /*
    Creates a ship
    Rotates it 90º
    Adds a mover to it go downwards
    Adds the ship to the scene
    */
    func createShip(p:CGPoint, destination:CGPoint) {
        let sprite = SKSpriteNode(imageNamed:"Dumbbell")
        sprite.name = "Destroyable"
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = p
        
        let duration = NSTimeInterval(moverSpeed)
        let action = SKAction.moveTo(destination, duration: duration)
        sprite.runAction(SKAction.repeatActionForever(action))
        
        let rotationAction = SKAction.rotateToAngle(CGFloat(3.142), duration: 0)
        sprite.runAction(SKAction.repeatAction(rotationAction, count: 0))
        
        currentNumberOfShips?+=1
        self.addChild(sprite)
    }
    
    /*
    Called when a touch begins
    */
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            if let theName = self.nodeAtPoint(location).name {
                if theName == "Destroyable" {
                    self.removeChildrenInArray([self.nodeAtPoint(location)])
                    currentNumberOfShips?-=1
                    score+=1
                }
            }
            if (gameOver==true)
            {
                
            }
            else if (isFirstTimeLaunch){
                initializeValues()
                self.isFirstTimeLaunch = false
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            
            if ((button?.containsPoint(location)) != nil) {
                print("tapped!")
                initializeValues()
            }
        }
    }
    
    /*
    Check if the game is over by looking at our health
    Shows game over screen if needed
    */
    func checkIfGameIsOver(){
        if (health <= 0 && gameOver == false){
            self.removeAllChildren()
            showGameOverScreen()
            gameOver = true
        }
    }
    
    /*
    Checks if an enemy ship reaches the bottom of our screen
    */
    func checkIfShipsReachTheBottom(){
        for child in self.children {
            if(child.position.y == 0){
                self.removeChildrenInArray([child])
                currentNumberOfShips?-=1
                health -= 1
            }
        }
    }
    
    func checkIfFirstTimeLaunch()->Bool
    {
        if (isFirstTimeLaunch)
        {
            self.showFirstTimeLaunchScreen()
            
            return true
        }
        
        return false
    }
    
    /*
    Displays the actual game over screen
    */
    func showGameOverScreen(){
        gameOverLabel = SKLabelNode(fontNamed:"System")
        gameOverLabel?.text = "Game Over! Score: \(score)"
        gameOverLabel?.fontColor = SKColor.redColor()
        gameOverLabel?.fontSize = 20;
        gameOverLabel?.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(gameOverLabel!)
        
        button = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        // Put it in the center of the scene
        button!.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));

        self.addChild(button!)
    }
    
    
    func showFirstTimeLaunchScreen()
    {
        self.removeAllChildren()
        
        gameOverLabel = SKLabelNode(fontNamed:"System")
        gameOverLabel?.text = "Drizzy Jones. Tap to start game."
        gameOverLabel?.fontColor = SKColor.greenColor()
        gameOverLabel?.fontSize = 20;
        gameOverLabel?.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(gameOverLabel!)
    

    }
}