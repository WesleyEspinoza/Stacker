//
//  ObstacleSpawner.swift
//  Stacker
//
//  Created by Wesley Espinoza on 2/22/20.
//  Copyright © 2020 Erick Espinoza. All rights reserved.
//

import Foundation
import SpriteKit

// struct that allows us to acces the values assigned to the case
struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Obstacle: UInt32 = 0b10
    static let Ground: UInt32 = 0b100
    static let PlayerBody: UInt32 = 0b1000
    static let Barrier: UInt32 = 0b10000
    static let Invisible: UInt32 = 0b100000
}

class ObstacleSpawner: SKSpriteNode {
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    var timePerCent: CFTimeInterval?
    var pointer = 0
    var currentScheme: [[Int]] = []
    
    let test: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 1, 0, 0, 0],
                         [0, 0, 0, 0, 1, 1, 0, 0, 0],
                         [0, 0, 0, 1, 1, 1, 0, 0, 0],
                         [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    let testTwo: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    let testThree: [[Int]] = [[0, 0, 0, 1, 1, 0, 0, 0, 0],
                              [0, 0, 0, 1, 1, 0, 0, 0, 0],
                              [0, 0, 0, 1, 1, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 1, 1, 1, 1, 0, 0, 0],
                              [0, 0, 1, 1, 1, 1, 0, 0, 0],
                              [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    let testFour: [[Int]] = [[0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    let testFive: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    let testSix: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    let testSeven: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 1, 1, 1, 1, 0, 0, 0],
                              [0, 0, 1, 0, 0, 1, 0, 0, 0],
                              [0, 0, 1, 0, 0, 1, 0, 0, 0],
                              [0, 0, 1, 1, 1 ,1, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    let testEight: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 1, 0, 0, 0, 0],
                              [0, 0, 0, 0, 1, 1, 0, 0, 0],
                              [0, 0, 0, 0, 1, 1, 1, 0, 0],
                              [0, 0, 0, 0, 1, 1, 1, 1, 0]]
    
    let testNine: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 1, 1, 1, 0, 0, 0],
                             [0, 0, 0, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    
    
    let testTen: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 1, 0, 0, 0],
                            [0, 0, 0, 0, 0, 1, 0, 0, 0],
                            [0, 0, 0, 0, 1, 1, 0, 0, 0],
                            [0, 0, 0, 0, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    
    
    
    
    
    func generate(scene: SKScene, _ customSchemes: [[[Int]]] = []){
        var schemes: [[[Int]]] = []
        if customSchemes.isEmpty {
            schemes = [test, testTwo, testThree, testFour, testFive, testSix, testSeven, testEight, testNine, testTen]
        } else {
            schemes = customSchemes
        }
        
        
        
        if timePerCent == nil {
            timePerCent = 0
            currentScheme = schemes.randomElement()!
            
            let child = self.children[0] as! SKSpriteNode
            let intialPos = self.children[0].position.x
            while child.position.x <= intialPos + child.size.width / 2 {
                child.position.x += 1.9
                timePerCent! += fixedDelta
            }
            child.position.x = intialPos
            
        }
        
        
        
        spawnTimer += fixedDelta
        if spawnTimer > Double(timePerCent!) {
            let copy = self.copy() as! SKSpriteNode
            copy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
            
            var column: [SKSpriteNode] = []
            
            for row in 0...currentScheme.count - 1 {
                if pointer > 8 {
                    pointer = 0
                    currentScheme = schemes.randomElement()!
                }
                let child = copy.childNode(withName: "spawnBlock-\(row)") as! SKSpriteNode
                if currentScheme[row][pointer] != 1 {
                    child.texture = nil
                    child.color = UIColor.clear
                    child.zPosition = -1
                    child.physicsBody?.affectedByGravity = false
                    child.physicsBody?.allowsRotation = false
                    child.physicsBody?.isDynamic = false
                    child.physicsBody?.density = 0
                    child.physicsBody?.categoryBitMask = PhysicsCategory.Invisible
                    child.physicsBody?.collisionBitMask = PhysicsCategory.None
                    child.position = scene.convert(child.position, to: scene)
                    child.position.x = child.position.x + 800
                    child.removeFromParent()
                } else {
                    child.physicsBody?.affectedByGravity = false
                    child.physicsBody?.allowsRotation = false
                    child.physicsBody?.isDynamic = false
                    child.physicsBody?.density = 0
                    child.position = scene.convert(child.position, to: scene)
                    child.position.x = child.position.x + 800
                    child.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
                    child.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Ground | PhysicsCategory.Obstacle
                    column.append(child.copy() as! SKSpriteNode)
                }
                
                
            }
            copy.removeAllChildren()
            copy.removeFromParent()
            
            let move = SKAction.moveBy(x: -100, y: 0, duration: 0.5)
            let repeater = SKAction.repeatForever(move)
            
            for copiedChild in column {
                scene.addChild(copiedChild)
                copiedChild.run(repeater)
            }
            column = []
            
            spawnTimer = 0
            pointer += 1
        }
        
    }
    
}
