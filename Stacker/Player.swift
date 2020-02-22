//
//  Player.swift
//  Stacker
//
//  Created by Wesley Espinoza on 2/21/20.
//  Copyright © 2020 Erick Espinoza. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    // Variable to decide whether or not our player can stack again.
    var canStack: Bool = true
    // Variable that tells us the max number if stacks they can do.
    let maxStack: Int = 7
    // variable to keep track of the bodyNodes we've added to the player
    var bodyNodes: [SKSpriteNode] = []
    
    
    // function that sets up the player.
    func setup(){
        // assining a SKPhysicsBody to ourself
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        
        // we want gravity to affect our player so we set affectedByGravity to true
        self.physicsBody?.affectedByGravity = true
        
        // we want our player to use the physics engine so we set isDynamic true
        self.physicsBody?.isDynamic = true
        
        // we dont want the player to rotate so we set allowsRotation false
        self.physicsBody?.allowsRotation = false
        
        // we set the categoryBitMask to tell swift that this node is a player
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        
        // we set the collisionBitMask to tell swift that this node will collide with the Ground Obstacles and the players body nodes
        self.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground | PhysicsCategory.PlayerBody
        
        // we set the contactTestBitMask to tell swift that we want to knwo when the node actually collides with Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
        
        // we set the texture to an image named head. if you have a differnt texture it goes here.
        self.texture = SKTexture(imageNamed: "head")
    }
    
    // this function allows us to make a stack under the player
    func stack(scene: SKScene){
        // we first check if we can are allowed to stack and if we have less than the max number of staks
        if canStack && bodyNodes.count <= maxStack{
            // we set canStack to false because while we do this we dont want the user to be able to stack again.
            canStack = false
            // an SKSpriteNode is created and stored inside a variable called body
            let body = SKSpriteNode(color: .cyan, size: CGSize(width: 100, height: 100))
            // the texture is set
            body.texture = SKTexture(imageNamed: "body")
            // we set the physicsBody properties
            body.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
            body.physicsBody?.allowsRotation = false
            body.physicsBody?.isDynamic = true
            body.physicsBody?.affectedByGravity = true
            body.physicsBody?.categoryBitMask = PhysicsCategory.PlayerBody
            body.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
            body.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Obstacle | PhysicsCategory.PlayerBody
            
            // move action to move our player up
            let jump = SKAction.moveTo(y: self.position.y + self.size.height + 10, duration: 0.2)
            
            // action to add our body to the scene
            let addChild = SKAction.run {
                // set the postion to under the player and convert it to the scene space
                body.position = scene.convert(CGPoint(x: self.position.x, y: self.position.y - (self.size.height + 15)), to: scene)
                
                // add it to out list of body nodes to keep track of it
                self.bodyNodes.append(body)
                
                // actaully add it to the scene
                scene.addChild(body)
            }
            
            // we create a small delay before re activating the stack
            let smallWait = SKAction.wait(forDuration: 0.025)
            
            // actally activates the stacks
            let enableStack = SKAction.run {
                self.canStack = true
            }
            
            // we make sure everything runs in the order we want.
            let sequence = SKAction.sequence([jump, addChild, smallWait, enableStack])
            // make the player run the actions we just made
            self.run(sequence)
        }
        
    }
    
}
