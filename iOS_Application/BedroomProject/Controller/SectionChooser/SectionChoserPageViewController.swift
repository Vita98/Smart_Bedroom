//
//  SectionChoserPageViewControllerV2.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 09/08/2020.
//  Copyright © 2020 VitandreaCorporation. All rights reserved.
//

import UIKit

class SectionChoserPageViewController: UIPageViewController, UIPageViewControllerDelegate {

    fileprivate lazy var pages: [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstPageViewController"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondPageViewController"),
        ]
    }()
    
    var pageControl: UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .none
        delegate = self
        dataSource = self
        
        self.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        //Setting the delegate for the button pressed of th FirstPageViewController
        if let first = pages[0] as? FirstPageViewController {
            first.buttonPressedDelegate = self
        }
        
        //Setting up the page dots indicator
        pageControl.numberOfPages = pages.count
        self.view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pageControl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapControl)))
        // Do any additional setup after loading the view.
    }
    
    @objc func tapControl(){
        print("\n OLE \n")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

extension SectionChoserPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return nil }
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else {
            return nil }
        
        return pages[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let previousIndex = self.pageControl.currentPage
        
        let pageContentViewC = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.firstIndex(of: pageContentViewC)!
        
        if previousIndex == self.pageControl.currentPage { return }
    }
}

extension SectionChoserPageViewController : ButtonPressedDelegate {
    func buttonPressed(_ button: RemoteButtonIndex) {
        WIFIModuleConnectionManager.sharedInstance.sendButtonCommand(remoteButton: button)
    }
}
