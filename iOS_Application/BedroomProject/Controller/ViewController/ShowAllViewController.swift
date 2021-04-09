//
//  ShowAllViewController.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 06/09/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

class ShowAllViewController: SuperViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button12: UIButton!
    @IBOutlet weak var button13: UIButton!
    @IBOutlet weak var button14: UIButton!
    @IBOutlet weak var button15: UIButton!
    @IBOutlet weak var button16: UIButton!
    
    private var allButton : [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setBackgroundView()

        // Do any additional setup after loading the view.
        inizializeButtonArray()
        setActionToAllButton()
    }
    
    private func inizializeButtonArray(){
        allButton = [button1,button2,button3,button4,button5,button6,button7,button8,button9,button10,button11,button12,button13,button14,button15,button16]
    }
    
    
    private func setActionToAllButton(){
        for i in 0...ALL_COLLECTION_VIEW_BUTTON.count-1{
            allButton[i].setImage(UIImage(named: REMOTE_BUTTON[ALL_COLLECTION_VIEW_BUTTON[i]] ?? ""), for: .normal)
            allButton[i].accessibilityIdentifier = String(ALL_COLLECTION_VIEW_BUTTON[i])
            allButton[i].addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        }
    }
    
    @objc func touchUpInside(_ caller : UIButton){
        print("Touch up inside")
        if let remoteButton = caller.accessibilityIdentifier{
            WIFIModuleConnectionManager.sharedInstance.sendButtonCommand(remoteButton: Int(remoteButton) ?? 0)
            print("Sending: \(remoteButton)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
