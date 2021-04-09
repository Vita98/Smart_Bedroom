//
//  RegularBedroomSectionView.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 21/07/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

public protocol RegularBedroomSectionViewDelegate {
    func mainShapeLayerHitted(inLocation location : CGPoint, withSenderQuadrantNumber  senderQuadrantNumber : Int)
    func mainShapeLayerLongPressure(inLocation location : CGPoint, withSenderQuadrantNumber  senderQuadrantNumber : Int)
}

class RegularBedroomSectionView: UIView {

    private var path: UIBezierPath!
    public var mainShapeLayer : CAShapeLayer!
    private(set) var isFillingColorEnabled : Bool = true
    private(set) var quadrantNumber : Int = 0
    
    public var fillingColortToggle : Void {
        get{
            if isFillingColorEnabled {
                isFillingColorEnabled = false
                hideFillingColorLayer(withDuration: 0.4)
            } else {
                isFillingColorEnabled = true
                showFillingColorLayer(withDuration: 0.4)
            }
        }
    }
    
    public var delegate : RegularBedroomSectionViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, withQuadrantNumber quadrantNumber : Int, filled : Bool ) {
        self.init(frame: frame)
        self.quadrantNumber = quadrantNumber
        self.isFillingColorEnabled = filled
        
        if isFillingColorEnabled{
            showFillingColorLayer(withDuration: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = nil
        path = UIBezierPath()
        
        path.move(to: CGPoint(x: 1, y: 1))
        path.addLine(to: CGPoint(x: 1, y: rect.maxY - 1))
        path.addLine(to: CGPoint(x: rect.maxX - 1 , y: rect.maxY - 1))
        path.addLine(to: CGPoint(x: rect.maxX - 1, y: rect.maxY ))
        path.addLine(to: CGPoint(x: rect.maxX - 1, y: 0))
        path.close()
        
        mainShapeLayer = CAShapeLayer()
        mainShapeLayer.strokeColor = UIColor.white.cgColor
        mainShapeLayer.lineWidth = 1
        mainShapeLayer.path = path.cgPath
        layer.addSublayer(mainShapeLayer)
        layer.mask = mainShapeLayer
        
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressure(sender:)))
        self.addGestureRecognizer(longGestureRecognizer)
    }
    
    
    private func hideFillingColorLayer(withDuration duration : CFTimeInterval){
        
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = bedroomMapSectionColor.cgColor
        animation.toValue = .none
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        self.layer.add(animation, forKey: "backgroundColorHiding")
    }
    
    private func showFillingColorLayer(withDuration duration : CFTimeInterval){
        
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = .none
        animation.toValue = bedroomMapSectionColor.cgColor
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        self.layer.add(animation, forKey: "backgroundColorShowing")
    }
    
    @objc private func longPressure(sender : UILongPressGestureRecognizer){
        if sender.state == .ended{
            let point = sender.location(ofTouch: 0, in: self)
            
            if path.contains(point) { // Optional, if you are inside its content path
                if let delegate = self.delegate{
                    delegate.mainShapeLayerLongPressure(inLocation: point, withSenderQuadrantNumber: quadrantNumber)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        
        if path.contains(point!) { // Optional, if you are inside its content path
            if let delegate = self.delegate{
                delegate.mainShapeLayerHitted(inLocation: point!, withSenderQuadrantNumber: quadrantNumber)
            }
        }
    }

}
