//
//  ConnectionStatusUIView.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 23/08/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

class ConnectionStatusUIView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private(set) var labelStatus = ConnectionStatus.disconnected
    
    private var statusLabel : UILabel = {
        let label = UILabel()
        label.text = "Disconnected"
        label.textColor = UIColor.red
        return label
    }()
    
    public func setStatusLabel(withStatus status : ConnectionStatus ){
        switch status {
        case .connected:
            
            if labelStatus == .disconnected || labelStatus == .setup {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.statusLabel.alpha = 0
                    }) { (flag) in
                        
                        self.statusLabel.textColor = UIColor.green
                        self.statusLabel.text = "Connected"
                        self.labelStatus = .connected
                        
                        UIView.animate(withDuration: 0.1, animations: {
                            self.statusLabel.alpha = 1
                        }) { (flag) in
                            UIView.animate(withDuration: 0.2, delay: 5, options: [], animations: {
                                self.statusLabel.alpha = 0
                            }, completion: nil)
                        }
                    }
                }
            }

        case .disconnected:
            DispatchQueue.main.async {
                self.statusLabel.textColor = UIColor.red
                self.statusLabel.text = "Disconnected"
                self.labelStatus = .disconnected
                
                UIView.animate(withDuration: 0.2) {
                    self.statusLabel.alpha = 1
                }
            }
        
        case .setup:
            DispatchQueue.main.async {
                self.statusLabel.textColor = UIColor.green
                self.statusLabel.text = "Setup"
                self.labelStatus = .setup
                
                UIView.animate(withDuration: 0.2) {
                    self.statusLabel.alpha = 1
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        self.addSubview(statusLabel)
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        statusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
    }

}
