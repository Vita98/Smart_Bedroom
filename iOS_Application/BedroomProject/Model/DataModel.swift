//
//  DataModel.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 05/07/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import Foundation

public typealias RemoteButton = String

public typealias RemoteButtonIndex = Int

public let REMOTE_BUTTON : [Int : RemoteButton] = [ 1 : "ON", 2 : "OFF", 14: "CANDLE" , 13 : "BULB" , 3: "SUN" , 4: "ICE"  , 15: "BABY" , 16:"SLEEPING", 6: "READ" , 5:"MEDITATION" , 17: "SUNSHINE" , 18: "AUTOMOVE" , 8: "RANDOMMOVE", 7: "PALM" , 19: "GREEN", 20:"SEA" , 10:"FIRE", 9:"LOVE", 11: "MOREBRIGHT", 12: "LESSBRIGHT" , 21: "REDCIRCLE", 22: "PURPLECIRCLE" , 23: "GREENCIRCLE", 24: "YELLOWCIRCLE"]

public enum SPECIAL_REMOTE_BUTTON : Int{
    case ON = 1
    case OFF = 2
    case LESSBRIGHT = 12
    case MOREBRIGHT = 11
    case REDCIRLCE = 21
    case PURPLECIRCLE = 22
    case GREENCIRCLE = 23
    case YELLOWCIRCLE = 24
}

public let MOST_USED_BUTTON : [Int] = [6 , 15 , 13 , 3 , 16 , 18 , 8 , 10 ]

public let ALL_COLLECTION_VIEW_BUTTON : [Int] = [14 , 13 , 3 , 4 , 15 , 16 , 6 , 5 , 17 , 18 , 8 , 7 , 19 , 20 , 10 , 9]
