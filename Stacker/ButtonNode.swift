//
//  ButtonNode.swift
//  Stacker
//
//  Created by Wesley Espinoza on 2/22/20.
//  Copyright © 2020 Erick Espinoza. All rights reserved.
//

import Foundation
import SpriteKit

enum ButtonNodeState {
    case ButtonNodeStateActive, ButtonNodeStateSelected, ButtonNodeStateHidden
}

class ButtonNode: SKSpriteNode {
    var buttonEnabled = true
    /* Setup a dummy action closure */
    var selectedHandler: () -> Void = { print("No button action set") }
    
    /* Button state management */
    var state: ButtonNodeState = .ButtonNodeStateActive {
        didSet {
            if buttonEnabled{
                switch state {
                case .ButtonNodeStateActive:
                    /* Enable touch */
                    self.isUserInteractionEnabled = true
                    
                    /* Visible */
                    self.alpha = 1
                    break
                case .ButtonNodeStateSelected:
                    /* Semi transparent */
                    self.alpha = 0.7
                    break
                case .ButtonNodeStateHidden:
                    /* Disable touch */
                    self.isUserInteractionEnabled = false
                    
                    /* Hide */
                    self.alpha = 0
                    break
                }
            }
        }
    }
    
    /* Support for NSKeyedArchiver (loading objects from SK Scene Editor */
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        
        /* Enable touch on button node */
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if buttonEnabled{
            state = .ButtonNodeStateSelected
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if buttonEnabled {
            selectedHandler()
            state = .ButtonNodeStateActive
        }

    }
    
}
