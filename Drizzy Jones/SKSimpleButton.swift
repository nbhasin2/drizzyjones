//
//  SKSimpleButton.swift
//  SpriteKitButton
//
//  Created by Anh Nguyen on 2/11/15.
//  Copyright (c) 2015 The 3A Team. All rights reserved.
//

import Foundation
import SpriteKit

class SKSimpleButton: SKSpriteNode {
    enum SKButtonActionType: Int {
        case TouchUpInside = 1
        case TouchDown = 2
        case TouchUp = 3
    }
    
    var defaultTexture: SKTexture
    var selectedTexture: SKTexture
    var disabledTexture: SKTexture?
    var actionTouchUpInside: Selector?
    var actionTouchUp: Selector?
    var actionTouchDown: Selector?
    weak var targetTouchUpInside: AnyObject?
    weak var targetTouchUp: AnyObject?
    weak var targetTouchDown: AnyObject?
    
    var isEnabled: Bool = true {
        didSet {
            if (disabledTexture != nil) {
                texture = isEnabled ? defaultTexture : disabledTexture
            }
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            texture = isSelected ? selectedTexture : defaultTexture
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // MARK: Create button with textures
    init(normalTexture defaultTexture: SKTexture!, selectedTexture:SKTexture!, disabledTexture: SKTexture?) {
        
        self.defaultTexture = defaultTexture
        self.selectedTexture = selectedTexture
        self.disabledTexture = disabledTexture
        
        super.init(texture: defaultTexture, color: UIColor.whiteColor(), size: defaultTexture.size())
        
        userInteractionEnabled = true
        
        // Adding this node as an empty layer. Without it the touch functions are not being called
        // The reason for this is unknown when this was implemented...?
//        SKSpriteNode(texture: nil, color: nil, size: defaultTexture.size())
        
        let bugFixLayerNode = SKSpriteNode(texture: nil, color: UIColor.clearColor(), size: defaultTexture.size())
        bugFixLayerNode.position = self.position
        addChild(bugFixLayerNode)
    }
    
    /**
    * Taking a target object and adding an action that is triggered by a button event.
    */
    func setButtonAction(target: AnyObject, triggerEvent event:SKButtonActionType, action:Selector) {
        switch (event) {
        case .TouchUpInside:
            targetTouchUpInside = target
            actionTouchUpInside = action
        case .TouchDown:
            targetTouchDown = target
            actionTouchDown = action
        case .TouchUp:
            targetTouchUp = target
            actionTouchUp = action
        }
    }
    
    // MARK: Touch Gesture
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: AnyObject! = touches.first
        let touchLocation = touch.locationInNode(parent!)
        
        if (!isEnabled) {
            return
        }
        isSelected = true
        if (targetTouchDown != nil && targetTouchDown!.respondsToSelector(actionTouchDown!)) {
            UIApplication.sharedApplication().sendAction(actionTouchDown!, to: targetTouchDown, from: self, forEvent: nil)
        }
    }
    
//    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (!isEnabled) {
            return
        }
        
        let touchLocation = touches.first!.locationInNode(parent!)
        
        if (CGRectContainsPoint(frame, touchLocation)) {
            isSelected = true
        } else {
            isSelected = false
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       if (!isEnabled) {
            return
        }
        
        isSelected = false
        
        if (targetTouchUpInside != nil && targetTouchUpInside!.respondsToSelector(actionTouchUpInside!)) {
            let touchLocation = touches.first!.locationInNode(parent!)
            
            if (CGRectContainsPoint(frame, touchLocation) ) {
                UIApplication.sharedApplication().sendAction(actionTouchUpInside!, to: targetTouchUpInside, from: self, forEvent: nil)
            }
        }
        
        if (targetTouchUp != nil && targetTouchUp!.respondsToSelector(actionTouchUp!)) {
            UIApplication.sharedApplication().sendAction(actionTouchUp!, to: targetTouchUp, from: self, forEvent: nil)
        }
    }
}