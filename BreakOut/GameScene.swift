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

// create bitMasks.  This is called Bitmasking.  0x tells the variable that it is going to be a bit.  0x1 is referring to 1 as a 32 bit number.  << is shifting the bit left, so 0x1 << 4 will be 00...0010000.  a 32 bit number with a 1 and 4 zeros afterwards.
let BallCategory: UInt32 = 0x1 << 0 // 0000000000000000000000000000001
let BottomCategory : UInt32 = 0x1 << 1 // 0000000000000000000000000000010
let BlockCategory : UInt32 = 0x1 << 2 // 0000000000000000000000000000100
let PaddleCategory : UInt32 = 0x1 << 3 // 0000000000000000000000000001000
let BorderCategory : UInt32 = 0x1 << 4 // 0000000000000000000000000010000


class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
        
        // create a view at the very bottom.  Bottom is made programmaticcally.
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        // get reference to paddle
        let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
        
        // set bit masks to physics bodys of items on view
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory
        
        
        // this will help whenever ball contacts bottom.  Add SKPhysicsContactDelegate to get access to methods
        ball.physicsBody!.contactTestBitMask = BottomCategory
        physicsWorld.contactDelegate = self // this will allow us to call didBegin(contact...)
        
        // create blocks programmaticcally
        let numberOfBlocks = 8
        let blockWidth = SKSpriteNode(imageNamed: "block").size.width
        let totalBlockWidth = blockWidth * CGFloat(numberOfBlocks)
        
        let xOffSet = (frame.width - totalBlockWidth) / 2
        
        for i in 0..<numberOfBlocks {
            let block = SKSpriteNode(imageNamed: "block")
            block.position = CGPoint(x: xOffSet + CGFloat(CGFloat(i) + 0.5) * blockWidth, y: frame.height * 0.8)
            block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0.0
            block.physicsBody!.affectedByGravity = false
            block.physicsBody!.isDynamic = false
            block.name = "block"
            block.physicsBody!.categoryBitMask = BlockCategory
            block.zPosition = 1
            addChild(block)
        }
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // use the bitmasks to help figure out who is what and what hit what
        let firstBody : SKPhysicsBody
        let secondBody : SKPhysicsBody
        
        // bodyA and bodyB can come in different orders with contacts.  Make sure to match them
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            print("first contact made with bottom.")
        }
        
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
        isFingerOnPaddle = false
    }
    
    
    
}
