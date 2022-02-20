//
//  ImageCollectionViewCell.swift
//  ARText
//
//  Created by nikilesh balaji on 2/20/22.
//  Copyright © 2022 nikilesh balaji. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ARText:SCNText{
    
    
    override init() {
        super.init()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init(text:String,
        font:UIFont,
        color:UIColor,
        depth:CGFloat
        ){
        super.init()
        
        self.string = text
        self.extrusionDepth = depth
        self.font = font
        self.alignmentMode = kCAAlignmentCenter
        self.truncationMode = kCATruncationMiddle
        self.firstMaterial?.isDoubleSided = true
        self.firstMaterial!.diffuse.contents = color        
        self.flatness = 0.3
    
    }
    
}

