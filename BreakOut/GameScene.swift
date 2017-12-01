//
//  GameScene.swift
//  BreakOut
//
//  Created by Christopher Walter on 11/30/17.
//  Copyright © 2017 AssistStat. All rights reserved.
//

import SpriteKit
import GameplayKit

// these will prevent spelling errors down the road, because we use them a lot
let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"

var isFingerOnPaddle = false


class GameScene: SKScene {
    
    // this is like viewDidLoad in a VC
    override func didMove(to view: SKView) {
        
        // set the border of the world to the frame.
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0.0
        self.physicsBody = borderBody
        
        // take gravity out of physics world
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
        ball.physicsBody?.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        // self is a SKScene, so we can use self there
        let touchLocation = touch!.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node?.name == PaddleCategoryName {
                print("Began touch on Paddle")
                isFingerOnPaddle = true
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFingerOnPaddle {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            
            let myPaddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
            // not quite sure why this math is here in the next 3 lines.  Figure it OUT!!!
            var paddlex = myPaddle.position.x + (touchLocation.x - previousLocation.x)
            paddlex = max(paddlex, myPaddle.size.width/2.0)
            paddlex = min(paddlex, size.width - myPaddle.size.width/2.0)
            
            myPaddle.position = CGPoint(x: paddlex, y: myPaddle.position.y)
            
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
