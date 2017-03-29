//
//  ViewController.swift
//  sampleCIDetectorApp
//
//  Created by Muneharu Onoue on 2017/03/28.
//  Copyright © 2017年 Muneharu Onoue. All rights reserved.
//

import UIKit
import CoreImage
import SpriteKit

class ViewController: UIViewController {
    @IBOutlet weak var myImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        myImage.layoutIfNeeded()
        myImage.image = myImage.image?.resize(spSize: myImage.frame.size)

        let options : [String: Any] = [CIDetectorAccuracyHigh:CIDetectorAccuracy]
        
        let detector : CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
        
        let faces :[CIFeature] = detector.features(in: CIImage(cgImage: myImage.image!.cgImage!))
        
        let transform : CGAffineTransform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -myImage.frame.size.height)
        
        for feature in faces {
            let faceRect : CGRect = feature.bounds.applying(transform)
            let faceOutline = UIView(frame: faceRect)
            faceOutline.layer.borderWidth = 1
            faceOutline.layer.borderColor = UIColor.red.cgColor
            myImage.addSubview(faceOutline)
        }

    }
}

extension UIImage {
    // aspect fill
    func resize(spSize: CGSize) -> UIImage {
        let ratioW = spSize.width / size.width 
        let ratioH = spSize.height / size.height 
        
        let adjustSizeW = CGSize(width: spSize.width, height: size.height * ratioW)
        let adjustSizeH = CGSize(width: size.width * ratioH, height: spSize.height)
        
        let adjustSize = adjustSizeW.width * adjustSizeW.height > adjustSizeH.width * adjustSizeH.height ? adjustSizeW : adjustSizeH
        
        UIGraphicsBeginImageContextWithOptions(adjustSize, true, 1)
        draw(in: CGRect(x: 0, y: 0, width: adjustSize.width, height: adjustSize.height))

        let adjustImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let adjustMarginW = adjustImage.size.width / 2 - spSize.width / 2
        let adjustMarginH = adjustImage.size.height / 2 - spSize.height / 2
        let adjustPoint = CGPoint(x: -adjustMarginW, y: -adjustMarginH)

        UIGraphicsBeginImageContextWithOptions(spSize, true, 1)
        adjustImage.draw(at: adjustPoint)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
