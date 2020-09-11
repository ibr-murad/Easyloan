//
//  EKAtributtes+Ex.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation


extension EKAttributes

func setupAttributes() -> EKAttributes {
    var attributes = EKAttributes.centerFloat
    attributes.displayDuration = .infinity
    
    attributes.shadow = .active(
        with: .init(
            color: .black,
            opacity: 0.3,
            radius: 8
        )
    )
    attributes.screenInteraction = .dismiss
    attributes.entryInteraction = .absorbTouches
    attributes.scroll = .enabled(
        swipeable: true,
        pullbackAnimation: .jolt
    )
    
    attributes.entranceAnimation = .init(
        translate: .init(
            duration: 0.7,
            spring: .init(damping: 1, initialVelocity: 0)
        ),
        scale: .init(
            from: 1.05,
            to: 1,
            duration: 0.4,
            spring: .init(damping: 1, initialVelocity: 0)
        )
    )
    
    attributes.exitAnimation = .init(
        translate: .init(duration: 0.2)
    )
    attributes.popBehavior = .animated(
        animation: .init(
            translate: .init(duration: 0.2)
        )
    )
    
    attributes.positionConstraints.verticalOffset = 10
    attributes.statusBar = .light
    return attributes
}
