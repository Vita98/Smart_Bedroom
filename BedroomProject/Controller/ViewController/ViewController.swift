//
//  ViewController.swift
//  BedroomProject
//
//  Created by Vitandrea Sorino on 26/06/2019.
//  Copyright © 2019 VitandreaCorporation. All rights reserved.
//

import UIKit
import Photos

class ViewController: SuperViewController {
    
    @IBOutlet weak var allCollectionView: UICollectionView!
    @IBOutlet var mostUsedCollectionView: UICollectionView!
    
    let mostUsedCollectionViewController = MostUsedCollectionViewController()
    let allCollectionViewController = AllCollectionViewController()

    @IBOutlet weak var mainHorizontalStackView: UIStackView!
    @IBOutlet weak var mostUsedHorizontalStackView: UIStackView!
    @IBOutlet weak var pageViewContainer: UIView!
    @IBOutlet weak var allHorizontalStackView: UIStackView!
    @IBOutlet weak var rotellaView: UIView!
    
    @IBOutlet weak var mostUsedLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    
    var navigationBarTitleLabel : UILabel!
    let connectionStatusView = ConnectionStatusUIView()
    var settingsButton : UIButton!
    private let identifier = "Main"
    
    @IBOutlet weak var circleRedButton: UIButton!
    @IBOutlet weak var circleYellowButton: UIButton!
    @IBOutlet weak var circleGreenButton: UIButton!
    @IBOutlet weak var circlePurpleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mostUsedCollectionView.delegate = mostUsedCollectionViewController
        mostUsedCollectionView.dataSource = mostUsedCollectionViewController
        
        allCollectionView.delegate = allCollectionViewController
        allCollectionView.dataSource = allCollectionViewController

        setNavigatioBar()
        setCircleButtonsConstraints()
        setSwipeDownWithTwoFingersRecognizer()
        
        super.setBackgroundView()
        
        //Setting the stored image, if there is one
        if let oldBackground = SettingsManager.sharedInstance.backgroundImage {
            self.imageView.image = oldBackground
            self.setViewColorTheme(colorTheme: self.imageView.image!.isDark ? .Light : .Dark)
        }
        
        if SettingsManager.sharedInstance.randomBackgroundProperty{
            setBackgroundImage()
        }
        
        setConnectionStatusIndicator()
        
        //Setting up the label indicator status and the connection with the WIFI module
        WIFIModuleConnectionManager.sharedInstance.delegate = self
        
        self.navigationController?.addCustomTransitioning()
        
        PHPhotoLibrary.requestAuthorization { (auth) in
            switch auth {
            case .authorized:
                print("Authorized")
            case .denied:
                print("Denied")
            case .limited:
                print("Limited")
            case .notDetermined:
                print("Not determined")
            case .restricted:
                print("Resctricted")
            @unknown default:
                print("Default")
            }
        }
        
        //Checking if the WifiManager singletone is already into the setup status
        if WIFIModuleConnectionManager.sharedInstance.connectionStatus == .setup {
            //Showing the loading view
            DispatchQueue.main.sync {
                LoadingView.sharedInstance.show(self.identifier, isAnimated: false)
            }
        }
    }
    
    
    private func setConnectionStatusIndicator(){
        self.view.addSubview(connectionStatusView)
        
        connectionStatusView.translatesAutoresizingMaskIntoConstraints = false
        connectionStatusView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        connectionStatusView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        connectionStatusView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        connectionStatusView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width / 2).isActive = true
        
        connectionStatusView.setStatusLabel(withStatus: WIFIModuleConnectionManager.sharedInstance.connectionStatus)
        
    }
    
    private func setSwipeDownWithTwoFingersRecognizer(){
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownWithTwoFingersEvent(_:)))
        gesture.direction = .down
        gesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func swipeDownWithTwoFingersEvent(_ gesture : UISwipeGestureRecognizer){
        setBackgroundImage()
    }
    
    private func setCircleButtonsConstraints(){
        circleRedButton.imageView!.translatesAutoresizingMaskIntoConstraints = false
        circleRedButton.imageView!.topAnchor.constraint(equalTo: circleRedButton.topAnchor, constant: 0).isActive = true
        circleRedButton.imageView!.leadingAnchor.constraint(equalTo: circleRedButton.leadingAnchor, constant: 0).isActive = true
        circleRedButton.imageView!.trailingAnchor.constraint(equalTo: circleRedButton.trailingAnchor, constant: 0).isActive = true
        circleRedButton.imageView!.bottomAnchor.constraint(equalTo: circleRedButton.bottomAnchor, constant: 0).isActive = true
        
        circleYellowButton.imageView!.translatesAutoresizingMaskIntoConstraints = false
        circleYellowButton.imageView!.topAnchor.constraint(equalTo: circleYellowButton.topAnchor, constant: 0).isActive = true
        circleYellowButton.imageView!.leadingAnchor.constraint(equalTo: circleYellowButton.leadingAnchor, constant: 0).isActive = true
        circleYellowButton.imageView!.trailingAnchor.constraint(equalTo: circleYellowButton.trailingAnchor, constant: 0).isActive = true
        circleYellowButton.imageView!.bottomAnchor.constraint(equalTo: circleYellowButton.bottomAnchor, constant: 0).isActive = true
        
        circlePurpleButton.imageView!.translatesAutoresizingMaskIntoConstraints = false
        circlePurpleButton.imageView!.topAnchor.constraint(equalTo: circlePurpleButton.topAnchor, constant: 0).isActive = true
        circlePurpleButton.imageView!.leadingAnchor.constraint(equalTo: circlePurpleButton.leadingAnchor, constant: 0).isActive = true
        circlePurpleButton.imageView!.trailingAnchor.constraint(equalTo: circlePurpleButton.trailingAnchor, constant: 0).isActive = true
        circlePurpleButton.imageView!.bottomAnchor.constraint(equalTo: circlePurpleButton.bottomAnchor, constant: 0).isActive = true
        
        circleGreenButton.imageView!.translatesAutoresizingMaskIntoConstraints = false
        circleGreenButton.imageView!.topAnchor.constraint(equalTo: circleGreenButton.topAnchor, constant: 0).isActive = true
        circleGreenButton.imageView!.leadingAnchor.constraint(equalTo: circleGreenButton.leadingAnchor, constant: 0).isActive = true
        circleGreenButton.imageView!.trailingAnchor.constraint(equalTo: circleGreenButton.trailingAnchor, constant: 0).isActive = true
        circleGreenButton.imageView!.bottomAnchor.constraint(equalTo: circleGreenButton.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setBackgroundImage(){
        
        let urlString = "https://picsum.photos/\(Int(UIScreen.main.bounds.width))/\(Int(UIScreen.main.bounds.height))"
        let catPictureURL = URL(string: urlString)!
        
        let session = URLSession(configuration: .default)
        
        print("url: \(urlString)")        
        //LoadingView.sharedInstance.show(identifier, isAnimated: true)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading the picture: \(e)")
                //LoadingView.sharedInstance.hide(self.identifier, isAnimated: true)
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded the picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 1, animations: {
                                
                                //Showing with fade animation the new downloaded background image
                                self.changeBackground(withNewImage: image!, withFade: true)
                                SettingsManager.sharedInstance.backgroundImage = image!
                                
                                self.setViewColorTheme(colorTheme: image!.isDark ? .Light : .Dark)
                                //LoadingView.sharedInstance.hide(self.identifier, isAnimated: true)
                            }, completion: nil )
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                        //LoadingView.sharedInstance.hide(self.identifier, isAnimated: true)
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    //LoadingView.sharedInstance.hide(self.identifier, isAnimated: true)
                }
            }
        }
        downloadPicTask.resume()
        
    }
    
    private func setViewColorTheme(colorTheme theme : ColorTheme){
        switch theme {
        case .Dark:
            print("Dark")
            mostUsedLabel.textColor = .black
            allLabel.textColor = .black
            self.navigationBarTitleLabel.textColor = .black
            changeStatusBarStyle(withStyle: .default)
            appColorTheme = theme
            
            NotificationCenter.default.post(name: darkThemeSelectedNotificationName, object: nil)
        case .Light:
            print("Light")
            mostUsedLabel.textColor = .white
            allLabel.textColor = .white
            self.navigationBarTitleLabel.textColor = .white
            changeStatusBarStyle(withStyle: .black)
            appColorTheme = theme
            
            NotificationCenter.default.post(name: lightThemeSelectedNotificationName, object: nil)
        }
    }
    
    private func changeStatusBarStyle(withStyle style : UIBarStyle){
        self.navigationController?.navigationBar.barStyle = style
        changeSettingsIcon(withStyle: style)
    }
    
}

extension ViewController {
    
    @IBAction func circleRedButtonTouchUpInsideEvent(_ sender: Any) {
        WIFIModuleConnectionManager.sharedInstance.sendButtonCommand(remoteButton: SPECIAL_REMOTE_BUTTON.REDCIRLCE.rawValue)
    }
    
    @IBAction func circleYellowButtonTouchUpInsideEvent(_ sender: Any) {
        WIFIModuleConnectionManager.sharedInstance.sendButtonCommand(remoteButton: SPECIAL_REMOTE_BUTTON.YELLOWCIRCLE.rawValue)
    }
    
    @IBAction func circleGreenButtonTouchUpInsideEvent(_ sender: Any) {
        WIFIModuleConnectionManager.sharedInstance.sendButtonCommand(remoteButton: SPECIAL_REMOTE_BUTTON.GREENCIRCLE.rawValue)
    }
    
    @IBAction func circlePurpleButtonTouchUpInsideEvent(_ sender: Any) {
        WIFIModuleConnectionManager.sharedInstance.sendButtonCommand(remoteButton: SPECIAL_REMOTE_BUTTON.PURPLECIRCLE.rawValue)
    }
    
    @objc func settingButtonTouchUpInside(_ sender : Any){
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
}

extension ViewController : ButtonPressedDelegate{
    func buttonPressed(_ button: RemoteButtonIndex) {
        WIFIModuleConnectionManager.sharedInstance.sendButtonCommand(remoteButton: button)
    }
}

extension ViewController : WIFIModuleConnectionManagerDelegate{
    
    func onStartSetup() {
        //Showing the loading view
        DispatchQueue.main.sync {
            LoadingView.sharedInstance.show(self.identifier, isAnimated: true)
        }
    }
    
    func onEndSetup() {
        //Dismissing the loading view
        DispatchQueue.main.sync {
            LoadingView.sharedInstance.hide(self.identifier, isAnimated: true)
        }
    }
    
    func WIFIModuleConnectionStatusChanged(actualConnectionStatus status: ConnectionStatus) {
        self.connectionStatusView.setStatusLabel(withStatus: status)
    }
}
