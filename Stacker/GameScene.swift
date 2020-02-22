//
//  GameScene.swift
//  Stacker
//
//  Created by Wesley Espinoza on 2/21/20.
//  Copyright © 2020 Erick Espinoza. All rights reserved.
//

import SpriteKit
import GameplayKit

// a helpful enum that allows us to keep track where we're at in our game
enum GameState: Equatable {
    case Paused
    case active
    case GameOver
    case Menu
    
}

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    
    //  varible to keep track of game state
    var gameState = GameState.Menu
    // this allows us to to add 1 per frame
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    // the speed we're scrolling the world
    let scrollSpeed: CGFloat = 200
    // reference to the scrollNode we made in the Scene
    var scrollNode: SKNode!
    // reference to our player
    var player: Player!
    //reference to our spawner
    var obstacleSpawner: ObstacleSpawner!
    // reference to the play button
    var playButton: ButtonNode!
    //reference to our barrier
    var barrier: SKSpriteNode!
    
    
    override func sceneDidLoad() {
        // setup our nodes
        setupNodes()
        // set the contact delegate to this scene because we want to work with it here.
        physicsWorld.contactDelegate = self
    }
    
    func setupNodes() {
        // find the node named player in the scene and make of Player Type
        player = self.childNode(withName: "player") as? Player
        // calls the setup function we made in Player.swift
        player.setup()
        
        // looks for node named obstacleSpawner
        obstacleSpawner = self.childNode(withName: "obstacleSpawner") as? ObstacleSpawner
        playButton = self.childNode(withName: "playButton") as? ButtonNode
        
        barrier = self.childNode(withName: "barrier") as? SKSpriteNode
        // setup barrier properties
        barrier.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: barrier.size.width, height: barrier.size.height))
        barrier.physicsBody?.isDynamic = true
        barrier.physicsBody?.allowsRotation = false
        barrier.physicsBody?.affectedByGravity = false
        barrier.physicsBody?.categoryBitMask = PhysicsCategory.Barrier
        barrier.physicsBody?.collisionBitMask = PhysicsCategory.None
        barrier.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.PlayerBody | PhysicsCategory.Invisible
        
        scrollNode = self.childNode(withName: "scrollNode")
        // tell our play button what to do once we select it.
        playButton.selectedHandler = {
            self.gameState = .active
            self.playButton.isHidden = true
            self.obstacleSpawner.generate(scene: self.scene!)
        }
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // when a player tapped we stack.
        player.stack(scene: scene!)
    }
    
    
    func scrollWorld() {
        /* Scroll World */
        scrollNode.position.x -= scrollSpeed * CGFloat(fixedDelta)
        /* Loop through scroll layer nodes */
        for ground in scrollNode.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollNode.convert(ground.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollNode)
                
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        // get bodyA of contact
         let bodyA = contact.bodyA
        // get bodyB of contact
         let bodyB = contact.bodyB
         
        
        // check if bodyA categoryBitMask is what we want
         if bodyA.categoryBitMask == PhysicsCategory.Barrier {
            
            // if bodyB bodyA equals an Obstacle or player or is invisible we remove it
             if bodyB.categoryBitMask == PhysicsCategory.Obstacle || bodyB.categoryBitMask == PhysicsCategory.PlayerBody || bodyB.categoryBitMask == PhysicsCategory.Invisible{
                // remove node
                 bodyB.node?.removeFromParent()
             }
             
         }
         if bodyB.categoryBitMask == PhysicsCategory.Barrier {
             if bodyA.categoryBitMask == PhysicsCategory.Obstacle || bodyA.categoryBitMask == PhysicsCategory.PlayerBody || bodyA.categoryBitMask == PhysicsCategory.Invisible{
                 bodyA.node?.removeFromParent()
             }
             
         }
         
     }
    
    
    func checkBody(){
        // check if we have nodes to check
        if player.bodyNodes.count >= 1 {
            // for every node inside or bodyNodes array
            for sprite in player.bodyNodes {
                // if the position if less than that of our player we then play an animation
                if sprite.position.x < player.position.x - 5 {
                    // we remove the node from the array using filter
                    player.bodyNodes = player.bodyNodes.filter {return $0 != sprite }
                    let rotate = SKAction.rotate(byAngle: 180, duration: 1.8)
                    let pushBack = SKAction.moveTo(x: sprite.position.x - 400, duration: 0.5)
                    let group = SKAction.group([pushBack, rotate])
                    // we run the animation
                    sprite.run(SKAction.repeatForever(group))
                    
                }
            }
            
            
            
            
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        scrollWorld()
        if gameState == .active {
            obstacleSpawner.generate(scene: self.scene!)
            checkBody()
        }
    }
}
