//
//  AccelerometerViewController.swift
//  Sensors
//
//  Created by Linda Cobb on 9/22/14.
//  Copyright (c) 2014 TimesToCome Mobile. All rights reserved.
//



import Foundation
import UIKit
import CoreMotion
import SceneKit
import Accelerate


// measures device acceleration in g along x, y, z

// level
// protractor
// ? vibration detection
// human motion
// g



class AccelerometerViewController: UIViewController
{
    
    @IBOutlet var xLabel: UILabel!
    @IBOutlet var yLabel: UILabel!
    @IBOutlet var zLabel: UILabel!
    
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var sceneView: SCNView!
    
    var motionManager: CMMotionManager!
    var stopUpdates = false
    
    var xCone: SCNNode!
    var yCone: SCNNode!
    var zCone: SCNNode!
    
    let radius: CGFloat = 5.0
    let height: CGFloat = 1.0
    let scale: Float = 100.0
    
    
    
    required init( coder aDecoder: NSCoder ){
        super.init(coder: aDecoder)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        motionManager = appDelegate.sharedManager

    }
    
    
    convenience override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        self.init(nibName: nil, bundle: nil)
    }


    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        setupScene()
    }
    
    
    
    @IBAction func stop(){
        
        stopUpdates = true
    }
    
    
    
    @IBAction func start(){
        
        stopUpdates = false
        startUpdates()
    }
    
    
    
    func startUpdates(){
        
        let updateInterval = 1.0/60.0
        motionManager.accelerometerUpdateInterval = updateInterval
        
        let dataQueue = NSOperationQueue()
        
        motionManager.startAccelerometerUpdatesToQueue(dataQueue, withHandler: {

            data, error in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                // move markers
                SCNTransaction.setAnimationDuration(0.1)
                var xmark:Float = Float(data.acceleration.x) * self.scale
                self.xCone.position = SCNVector3Make(xmark, 0.0, 0.0)
                
                var ymark:Float = Float(data.acceleration.y) * self.scale
                self.yCone.position = SCNVector3Make(0.0, ymark, 0.0)
                
                // update labels
                self.xLabel.text = NSString(format: "X: %.6lf g", data.acceleration.x) as String
                self.yLabel.text = NSString(format: "Y: %.6lf g", data.acceleration.y) as String
                self.zLabel.text = NSString(format: "Z: %.6lf g", data.acceleration.z) as String
                    
                if ( self.stopUpdates ){
                    self.motionManager.stopAccelerometerUpdates()
                    NSOperationQueue.mainQueue().cancelAllOperations()
                }

            })
        })
        
       
    }
    
    
    func setupScene(){
        
        let scene = SCNScene()
        
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = -100.0
        //cameraNode.camera?.zNear = 100.0
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 10, y: 10, z: 150)
        
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLightTypeAmbient
        ambientLightNode.light?.color = UIColor.whiteColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        
        //grid lines
        
        let width = sceneView.bounds.width
        
        
        let xSlider = SCNBox(width: 1.0, height: 1.0, length: width, chamferRadius: 0.1)
        let xSliderMaterial = SCNMaterial()
        xSliderMaterial.diffuse.contents = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let xBar = SCNNode(geometry: xSlider)
        xBar.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
        xBar.rotation = SCNVector4Make(0.0, 1.0, 0.0, 1.57)
        xBar.geometry?.firstMaterial = xSliderMaterial
        scene.rootNode.addChildNode(xBar)
        
        
        let ySlider = SCNBox(width: 1.0, height: 1.0, length: width, chamferRadius: 0.1)
        let ySliderMaterial = SCNMaterial()
        ySliderMaterial.diffuse.contents = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let yBar = SCNNode(geometry: ySlider)
        yBar.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
        yBar.rotation = SCNVector4Make(1.0, 0.0, 0.0, 1.57)
        yBar.geometry?.firstMaterial = ySliderMaterial
        scene.rootNode.addChildNode(yBar)
        
        
        
        // first marker
        let xsphere = SCNSphere(radius: radius)
        let xmaterial = SCNMaterial()
        xmaterial.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        xCone = SCNNode(geometry: xsphere)
        xCone.position = SCNVector3( x: 0.0, y: 0.0, z: 0.0 )
        xCone.geometry?.firstMaterial = xmaterial
        scene.rootNode.addChildNode(xCone)
        
        
        
        // second marker
        let ysphere = SCNSphere(radius: radius)
        let ymaterial = SCNMaterial()
        ymaterial.diffuse.contents = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        yCone = SCNNode(geometry: ysphere)
        yCone.position = SCNVector3( x: 0.0, y: 0.0, z: 0.0 )
        yCone.geometry?.firstMaterial = ymaterial
        scene.rootNode.addChildNode(yCone)
        
        
        
        // third marker
        let zcone = SCNCone(topRadius: radius, bottomRadius: radius, height: height)
        let zmaterial = SCNMaterial()
        zmaterial.diffuse.contents = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        
        zCone = SCNNode(geometry: zcone)
        zCone.position = SCNVector3( x: 0.0, y: 0.0, z: 0.0 )
        zCone.geometry?.firstMaterial = zmaterial
        //  scene.rootNode.addChildNode(zCone)
        
        
        
        // set the scene to the view
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.whiteColor()
        
        
    }
    
    

    
    override func viewDidDisappear(animated: Bool){
        
        super.viewDidDisappear(animated)
        stop()
        
    }
    
    
}