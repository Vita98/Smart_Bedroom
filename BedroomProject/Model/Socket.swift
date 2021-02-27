//
//  Socket.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 25/02/21.
//  Copyright © 2021 VitandreaCorporation. All rights reserved.
//

import Foundation

struct Socket {
    var address : String
    var port : Int32
    
    init(_ address : String, _ port : Int32) {
        self.address = address
        self.port = port
    }
}
