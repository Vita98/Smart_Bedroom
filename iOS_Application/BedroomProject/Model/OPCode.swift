//
//  OPCode.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 25/12/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import Foundation

public enum NormalStatusOPCode : String {
    case BUTTON = "BUTTON"
    case SECTION = "SECTIO"
    case WALLBUTTON = "WBUTTO"
    case LONGPRESSIONBUTTON = "LONPRE"
    case FIRSTCLICKWALLBUTTON = "1KWBUT"
    case STAIR = "STAIRS"
    case SETUP = "SETUPP"
    case MOVEMENTSENSOR = "MOVSEN"
}

public enum SetupStatusOPCode : String {
    case CHECKCONNECTION = "CHECKCONNE"
    case ENDSETUP = "ENDSETUP"
    case NOTRECEIVED = "NTRCVD"
}

public enum SetupConfigurationOPCode : String {
    case SECTION = "SECTIO"
    case WALLBUTTON = "WBUTTO"
    case LONGPRESSIONBUTTON = "LONPRE"
    case FIRSTCLICKWALLBUTTON = "1KWBUT"
    case MOVEMENTSENSOR = "MOVSEN"
}
