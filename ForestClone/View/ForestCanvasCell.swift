//
//  ForestCanvasCell.swift
//  ForestClone
//
//  Created by Christian Leovido on 27/06/2020.
//  Copyright © 2020 Accent IT Services. All rights reserved.
//

import UIKit
import SceneKit

class ForestCanvasCell: UITableViewCell {

    static let identifier = "ForestCanvasCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        configureSceneKitLand()

    }

    func configureSceneKitLand() {

        // 1. Create a sceneView where we put in the land of the forest
        let sceneView = SCNView(frame: frame)
        sceneView.backgroundColor = .clear
        addSubview(sceneView)

        // 2. Create a SCNScene
        let scene = SCNScene()
        sceneView.scene = scene

        // 2. Create a SCNCamera.
        // This will render the position of the camera.
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 3.0)

        // 3. SCNLight render the light on which to project on the object
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)

        // 4. Create the box
        let cubeGeometry = SCNBox(width: 2.5, height: 0.4, length: 2.5, chamferRadius: 0.0)
        let cubeNode = SCNNode(geometry: cubeGeometry)

        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.green
        cubeGeometry.materials = [redMaterial]

        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cubeNode)

        cameraNode.position = SCNVector3(x: -3.0, y: 3.0, z: 3.0)

        let constraint = SCNLookAtConstraint(target: cubeNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
