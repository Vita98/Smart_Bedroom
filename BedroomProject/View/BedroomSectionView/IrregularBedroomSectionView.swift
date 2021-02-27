//
//  bedroomIrregularSectionUIView.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 19/07/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit

public protocol IrregularBedroomSectionViewDelegate {
    func mainShapeLayerHitted(inLocation location : CGPoint)
    func mainShapeLayerLongPressure(inLocation location : CGPoint)
}

class IrregularBedroomSectionView : UIView{
    
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
    
    public var delegate : IrregularBedroomSectionViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame : CGRect, withQuadrantNumber quadrantNumber : Int, filled : Bool) {
        self.init(frame: frame)
        isFillingColorEnabled = filled
        self.quadrantNumber = quadrantNumber
        
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
        
        path.move(to: CGPoint(x: 1.5, y: 0))
        path.addLine(to: CGPoint(x: 1.5, y: rect.maxY - 2))
        path.addLine(to: CGPoint(x: rect.maxX / 2 - 1 , y: rect.maxY - 2))
        path.addLine(to: CGPoint(x: rect.maxX - 2, y: rect.maxY * 0.35))
        path.addLine(to: CGPoint(x: rect.maxX - 2, y: 0))
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
                    delegate.mainShapeLayerLongPressure(inLocation: point)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        
        if path.contains(point!) { // Optional, if you are inside its content path
            if let delegate = self.delegate{
                delegate.mainShapeLayerHitted(inLocation: point!)
            }
        }
    }
    
}
