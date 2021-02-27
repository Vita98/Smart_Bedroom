//
//  SecondPageViewController.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 04/07/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit
import Foundation

class SecondPageViewController: UIViewController {
    
    let hapticFeedbackGeneratorLongPressure = UIImpactFeedbackGenerator(style: .heavy)
    let hapticFeedbackGeneratorNormalPressure = UIImpactFeedbackGenerator(style: .light)
    
    @IBOutlet weak var firstQuadrantBedroomView: UIView!
    @IBOutlet weak var secondQuadrantBedroomView: UIView!
    @IBOutlet weak var thirdQuadrantBedroomView: UIView!
    @IBOutlet weak var fourthQuadrantBedroomView: UIView!
    
    var irregularSectionView : IrregularBedroomSectionView!
    var regularBedroomSectionsViews = [RegularBedroomSectionView?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .none
        
        addQuadrantsBorder()

        NotificationCenter.default.addObserver(self, selector: #selector(setLightTheme), name: lightThemeSelectedNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkTheme), name: darkThemeSelectedNotificationName, object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    private func addQuadrantsBorder(){
        firstQuadrantBedroomView.layer.borderColor = UIColor.white.cgColor
        firstQuadrantBedroomView.layer.borderWidth = 1
        addRegularBedroomSectionView(toQuadrantView: firstQuadrantBedroomView, withQuadrantNumber: 1)
        
        secondQuadrantBedroomView.layer.borderColor = UIColor.white.cgColor
        secondQuadrantBedroomView.layer.borderWidth = 1
        addRegularBedroomSectionView(toQuadrantView: secondQuadrantBedroomView, withQuadrantNumber: 2)
        
        thirdQuadrantBedroomView.layer.borderColor = UIColor.white.cgColor
        thirdQuadrantBedroomView.layer.borderWidth = 1
        addRegularBedroomSectionView(toQuadrantView: thirdQuadrantBedroomView, withQuadrantNumber: 3)
        
        addFourthQuadrantIrregularBedroomSectionView()
    }
    
    private func addRegularBedroomSectionView(toQuadrantView quadrantView : UIView, withQuadrantNumber quadrantNumber : Int){
        
        var localQuandrantView : UIView!
        var localregularBedroomSection : RegularBedroomSectionView!
        
        switch quadrantNumber {
        case 1:
            localQuandrantView = firstQuadrantBedroomView
        case 2:
            localQuandrantView = secondQuadrantBedroomView
        case 3:
            localQuandrantView = thirdQuadrantBedroomView
        default:
            localQuandrantView = nil
        }
        
        localregularBedroomSection = RegularBedroomSectionView(frame: quadrantView.frame, withQuadrantNumber: quadrantNumber, filled: BedroomSelectedSections[quadrantNumber - 1] ?? true)
        localregularBedroomSection.delegate = self
        localQuandrantView.addSubview(localregularBedroomSection)
        
        localregularBedroomSection.translatesAutoresizingMaskIntoConstraints = false
        localregularBedroomSection.topAnchor.constraint(equalTo: localQuandrantView.topAnchor, constant: 0).isActive = true
        localregularBedroomSection.leadingAnchor.constraint(equalTo: localQuandrantView.leadingAnchor, constant: 0).isActive = true
        localregularBedroomSection.trailingAnchor.constraint(equalTo: localQuandrantView.trailingAnchor, constant: 0).isActive = true
        localregularBedroomSection.bottomAnchor.constraint(equalTo: localQuandrantView.bottomAnchor, constant: 0).isActive = true
        
        regularBedroomSectionsViews.insert(localregularBedroomSection, at: quadrantNumber - 1)
        
    }
    
    private func addFourthQuadrantIrregularBedroomSectionView(){
        
        irregularSectionView = IrregularBedroomSectionView(frame: fourthQuadrantBedroomView.frame, withQuadrantNumber: 3, filled: BedroomSelectedSections[3] ?? true)
        irregularSectionView.delegate = self
        fourthQuadrantBedroomView.addSubview(irregularSectionView)
        
        irregularSectionView.translatesAutoresizingMaskIntoConstraints = false
        irregularSectionView.topAnchor.constraint(equalTo: fourthQuadrantBedroomView.topAnchor, constant: 0).isActive = true
        irregularSectionView.leadingAnchor.constraint(equalTo: fourthQuadrantBedroomView.leadingAnchor, constant: 0).isActive = true
        irregularSectionView.trailingAnchor.constraint(equalTo: fourthQuadrantBedroomView.trailingAnchor, constant: 0).isActive = true
        irregularSectionView.bottomAnchor.constraint(equalTo: fourthQuadrantBedroomView.bottomAnchor, constant: 0).isActive = true
        
    }
    
    private func updateSelectedSectionSharedData(){
        
        for (index, regularBedroomSectionView) in regularBedroomSectionsViews.enumerated() {
            if let section = regularBedroomSectionView {
                if section.isFillingColorEnabled { BedroomSelectedSections[index] = true }
                else { BedroomSelectedSections[index] = false }
            }
        }
        
        if let irregularSection = irregularSectionView{
            if irregularSection.isFillingColorEnabled { BedroomSelectedSections[3] = true }
            else { BedroomSelectedSections[3] = false }
        }
        
        WIFIModuleConnectionManager.sharedInstance.sendSelectedSection()
        
    }
    
    @IBAction func selectAllAction(_ sender: Any) {
        
        if !irregularSectionView.isFillingColorEnabled { irregularSectionView.fillingColortToggle }
        hapticFeedbackGeneratorLongPressure.impactOccurred()
        
        regularBedroomSectionsViews.forEach { (regularBedroomSectionView) in
            if let section = regularBedroomSectionView{
                if !section.isFillingColorEnabled { section.fillingColortToggle }
            }
        }
        
        updateSelectedSectionSharedData()
    }
    
}

extension SecondPageViewController : IrregularBedroomSectionViewDelegate {
    
    func mainShapeLayerHitted(inLocation location: CGPoint) {
        print("Layer hitted in location \(location)")
        irregularSectionView.fillingColortToggle
        hapticFeedbackGeneratorNormalPressure.impactOccurred()
        updateSelectedSectionSharedData()
    }
    
    func mainShapeLayerLongPressure(inLocation location: CGPoint) {
        print("Layer hitted with long pressure in location \(location)")
        
        if !irregularSectionView.isFillingColorEnabled { irregularSectionView.fillingColortToggle }
        hapticFeedbackGeneratorLongPressure.impactOccurred()
        
        regularBedroomSectionsViews.forEach { (regularBedroomSectionView) in
            if let section = regularBedroomSectionView{
                if section.isFillingColorEnabled { section.fillingColortToggle }
                updateSelectedSectionSharedData()
            }
        }
    }
    
}

extension SecondPageViewController : RegularBedroomSectionViewDelegate {
    func mainShapeLayerHitted(inLocation location: CGPoint, withSenderQuadrantNumber senderQuadrantNumber: Int) {
        print("Layer hitted in location \(location) with sender quadrant number \(senderQuadrantNumber)")
        
        if let section = regularBedroomSectionsViews[senderQuadrantNumber - 1] {
            section.fillingColortToggle
            hapticFeedbackGeneratorNormalPressure.impactOccurred()
            updateSelectedSectionSharedData()
        }
    }
    
    func mainShapeLayerLongPressure(inLocation location: CGPoint, withSenderQuadrantNumber senderQuadrantNumber: Int) {
        print("Layer hitted with long pressure in location \(location) with sender quadrant number \(senderQuadrantNumber)" )
        
        if irregularSectionView.isFillingColorEnabled { irregularSectionView.fillingColortToggle }
        hapticFeedbackGeneratorLongPressure.impactOccurred()
        
        for (index, regularBedroomSectionView) in regularBedroomSectionsViews.enumerated() {
            if let section = regularBedroomSectionView {
                if senderQuadrantNumber - 1 == index{
                    if !section.isFillingColorEnabled { section.fillingColortToggle }
                }else{
                    if section.isFillingColorEnabled { section.fillingColortToggle }
                }
            }
        }
        updateSelectedSectionSharedData()
    }
}

extension SecondPageViewController : ThemeDelegate {
    
    @objc func setDarkTheme(){
        
    }
    
    @objc func setLightTheme(){
        
    }
    
}


