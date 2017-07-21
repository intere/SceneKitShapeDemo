//
//  GameViewController.swift
//  SceneKitDemo
//
//  Created by Eric Internicola on 7/21/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class ShapeViewController: UIViewController {

    var shape = Shape.unknown {
        didSet {
            updatedShape()
        }
    }
    var scnView: SCNView!
    var scene: SCNScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/empty-scene.scn")!
        
        // retrieve the SCNView
        scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}

// MARK: - Implementation

extension ShapeViewController {

    struct Constants {
        static let nodeName = "geometry"
    }

    func updatedShape() {
        removeNodes()

        guard let node = shape.node else {
            return
        }

        node.position = SCNVector3(x: -5, y: 0, z: -5)
        scene.rootNode.addChildNode(node)

        node.runAction(SCNAction.repeat(SCNAction.rotateBy(x: 2, y: 2, z: 2, duration: 1), count: 3))
    }

    /// Remove all of the children
    func removeNodes() {
        for child in scene.rootNode.childNodes {
            guard child.name == Constants.nodeName else {
                continue
            }

            child.removeFromParentNode()
        }
    }
}

// MARK: - Shape Extension

extension Shape {

    private var geometry: SCNGeometry? {
        switch self {
        case .plane:
            return SCNPlane(width: 1, height: 2)

        case .box:
            return SCNBox(width: 1, height: 1, length: 1.5, chamferRadius: 0.1)

        case .capsule:
            return SCNCapsule(capRadius: 0.3, height: 2)

        case .cylinder:
            return SCNCylinder(radius: 0.4, height: 2)

        case .sphere:
            return SCNSphere(radius: 0.7)

        case .torus:
            return SCNTorus(ringRadius: 0.8, pipeRadius: 0.2)

        case .tube:
            return SCNTube(innerRadius: 0.3, outerRadius: 0.5, height: 1.5)

        default:
            break
        }
        return nil
    }

    var node: SCNNode? {
        guard let geometry = geometry else {
            return nil
        }

        let node = SCNNode(geometry: geometry)
        node.name = ShapeViewController.Constants.nodeName

        return node
    }

}
