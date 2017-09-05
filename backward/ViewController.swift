//
//  ViewController.swift
//  backward
//
//  Created by 곽기현 on 03/09/2017.
//  Copyright © 2017 aren. All rights reserved.
//

import UIKit
import GoogleMobileAds

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var inputTextView: UITextView!
    
    private var reversedText: String = "";
    private var countForAds: Int = 0;
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // add done button
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        inputTextView.inputAccessoryView = keyboardToolbar
        
        //textView set borader
        inputTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor;
        inputTextView.layer.borderWidth = 1.0;
        inputTextView.layer.cornerRadius = 5.0;
        
        //admob intersitial
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-2778546304304506/6177748708")
        let request = GADRequest()
        interstitial.load(request)
        
        //admob banner
        bannerView.adUnitID = "ca-app-pub-2778546304304506/2905127228"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTextView.delegate = self;
    }

//    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
//        return (string as NSString).boundingRect(with: CGSize(width: width, height: DBL_MAX),
//                                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
//                                                         attributes: [NSFontAttributeName: font],
//                                                         context: nil).size
//    }
//    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        var textWidth = UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset).width
//        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
//        
//        let boundingRect = sizeOfString(string: newText, constrainedToWidth: Double(textWidth), font: textView.font!)
//        let numberOfLines = boundingRect.height / textView.font!.lineHeight;
//        
//        return numberOfLines <= 14;
//    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        
        // text to share
        let text = reversedText + " by backward";
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
//        countForAds += 1;
//        showInterstitialAds();
    }
    @IBAction func copyButtonClicked(_ sender: Any) {
        
        UIPasteboard.general.string = reversedText + " by backward";
        self.showToast(message: "Copy to clipboard");
        
        countForAds += 1;
        showInterstitialAds();
    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text); //the textView parameter is the textView where text was changed
        reversedText = String(textView.text.characters.reversed());
        resultTextView.text = reversedText;
    }
    
    func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func dismiss(_ sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func showInterstitialAds() {
        if interstitial.isReady && (countForAds%3 == 0) {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }

}

