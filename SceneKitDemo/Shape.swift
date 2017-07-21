//
//  Shape.swift
//  SceneKitDemo
//
//  Created by Eric Internicola on 7/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation


/// The Primitive ScenKit Shapes
///
/// - plane: a 2-D plane shape, that's rendered in 3-space
/// - sphere: a sphere (e.g. globe)
/// - box: a box
/// - cylinder: a cylinder
/// - torus: a torus (a ring shape)
/// - capsule: a capsule (a pill shape)
/// - tube: a tube
enum Shape {

    case unknown

    case plane
    case sphere
    case box
    case cylinder
    case torus
    case capsule
    case tube

}

// MARK: - API

extension Shape {

    static var values: [Shape] {
        return [.box, .capsule, .cylinder, .plane, .sphere, .torus, .tube]
    }

    var name: String {
        switch self {
        case .box:
            return "Box"

        case .capsule:
            return "Capsule"

        case .cylinder:
            return "Cylinder"

        case .plane:
            return "Plane"

        case .sphere:
            return "Sphere"

        case .torus:
            return "Torus"

        case .tube:
            return "Tube"

        case .unknown:
            return "Unknown Shape"
        }
    }
}
