//
//  UIImageViewExtensions.swift
//  FlavioCarbonara
//
//  Created by Vitandrea Sorino on 19/06/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

extension CGSize {
    static func aspectFit(aspectRatio : CGSize, _ boundingSize: CGSize) -> CGSize {
        var boundingSize = boundingSize
        let mW = boundingSize.width / aspectRatio.width;
        let mH = boundingSize.height / aspectRatio.height;
        if( mH < mW ) {
            boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
        }
        else if( mW < mH ) {
            boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
        }
        return boundingSize;
    }
    
    static func aspectFill(aspectRatio :CGSize, _ minimumSize: CGSize) -> CGSize {
        var minimumSize = minimumSize
        let mW = minimumSize.width / aspectRatio.width;
        let mH = minimumSize.height / aspectRatio.height;
        if( mH > mW ) {
            minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width;
        }
        else if( mW > mH ) {
            minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height;
        }
        return minimumSize;
    }
}
