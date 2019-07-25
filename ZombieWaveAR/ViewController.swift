//
//  ViewController.swift
//  ZombieWaveAR
//
//  Created by Pursuit on 7/25/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SpriteKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate,ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var trackerNode: SCNNode!
    var Gamestarted = false
    var foundaSurface = false
    var trackingForArenaPosition = SCNVector3Make(0.0, 0.0, 0.0)
    
    
   var arenaNode: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
//        constraints()
let scene = SCNScene(named: "art.scnassets/CityStreet/untitled.dae")!
        sceneView.scene = scene
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        if Gamestarted {
            
        } else {
            
            guard let safeUnwrap = trackerNode else {return}
            
            safeUnwrap.removeFromParentNode()
            
            Gamestarted = true
            
            guard let arena = sceneView.scene.rootNode.childNode(withName: "rua", recursively: false) else {return}
            
            arenaNode = arena
            
            arenaNode.position = SCNVector3Make(trackingForArenaPosition.x, trackingForArenaPosition.y, trackingForArenaPosition.z)
            
//            arenaNode.scale = SCNVector3(0.025,0.025,0.025)
            sceneView.scene.rootNode.addChildNode(arenaNode)
            arenaNode.isHidden = false
        }
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !Gamestarted else {return}
        
        guard let hitTest = sceneView.hitTest(CGPoint(x: view.frame.midX, y: view.frame.midX), types: [.existingPlane,.featurePoint,.estimatedHorizontalPlane]).first else {return}
        
        let trans = SCNMatrix4(hitTest.worldTransform)
        trackingForArenaPosition = SCNVector3Make(trans.m41, trans.m42, trans.m43)
        
        if !foundaSurface {
            let trackerPlane = SCNPlane(width: 0.15, height: 0.15)
            trackerPlane.firstMaterial?.diffuse.contents = UIImage.init(named: "placer")
            trackerPlane.firstMaterial?.isDoubleSided =  true
            trackerNode = SCNNode(geometry: trackerPlane)
            trackerNode.eulerAngles.x = -.pi * 0.5
            sceneView.scene.rootNode.addChildNode(trackerNode)
            foundaSurface = true
        }
        
        trackerNode.position = trackingForArenaPosition
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
