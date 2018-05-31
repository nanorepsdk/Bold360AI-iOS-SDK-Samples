// ===================================================================================================
// Copyright © 2018 nanorep.
// NanorepUI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import NanorepUI

class ViewController: UIViewController, NanorepPersonalInfoHandler, UITextFieldDelegate, NRApplicationContentHandler, NRReadMoreViewControllerDelegate  {
    /************************************************************/
    // MARK: - Properties
    /************************************************************/
    
    // Outlets
    @IBOutlet weak var kbTF: UITextField!
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var phoneConfirmation: UISwitch!
    @IBOutlet weak var articleIdTF: UITextField!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var sdkVersion: UILabel!
    
    // Params
    var widgetController: NRWidgetViewController!
    
    /************************************************************/
    // MARK: - Functions
    /************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loadNanorep(_ sender: Any) {
        self.view.endEditing(true)
        
        let accountParams = AccountParams()
        accountParams.account =  self.accountTF.text
        accountParams.knowledgeBase = self.kbTF.text
        
        NanoRep.shared().prepare(with: accountParams)
        
        NanoRep.shared().fetchConfiguration = {
            (configuration: NRConfiguration?, error: Error?) -> Void in
            
            if error != nil {
                print(error.debugDescription)
            }

            configuration?.useLabels = true
            DispatchQueue.main.async { [unowned self] in
                self.widgetController = NRWidgetViewController()
                self.widgetController.infoHandler = self
                self.widgetController.view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 44.0))
                self.addChildViewController(self.widgetController)
                self.view.addSubview(self.widgetController.view)
            }
        }
    }

    /************************************************************/
    // MARK: - NRReadMoreViewControllerDelegate
    /************************************************************/
    func personalInfo(withExtraData extraData: [AnyHashable : Any]!, channel: NRChanneling!, completionHandler handler: (([AnyHashable : Any]?) -> Void)!) {
        handler(extraData)
    }
    
    func didFetchExtraData(_ formData: [AnyHashable : Any]!) {
        
    }
    
    func didSubmitForm() {
        
    }
    
    func didCancelForm() {
        
    }
    
    func didFailSubmitFormWithError(_ error: Error!) {
        
    }
    
    func shouldOverridePhoneChannel(_ phoneChannel: NRChannelingPhoneNumber!) -> Bool {
        if self.phoneConfirmation.isOn {
            let alert = UIAlertController(title: "Phone Confirmation", message: "Need your approval for dialing number :\n" + (phoneChannel?.phoneNumber ?? ""), preferredStyle: .alert)
            let action = UIAlertAction(title: "Approve", style: .default, handler: nil)
            alert.addAction(action)
            widgetController.present(alert, animated: true)
        }
        return phoneConfirmation.isOn
    }
    
    func presentFileList(_ files: [String]?) {
        let alert = UIAlertController(title: "Files To Upload", message: nil, preferredStyle: .actionSheet)
        for key: String? in files ?? [String?]() {
            alert.addAction(UIAlertAction(title: key, style: .default, handler: { action in
            }))
        }
        widgetController.present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Deep link example
        let account = AccountParams()
        account.account = accountTF.text
        account.knowledgeBase = kbTF.text
        NanoRep.shared().prepare(with: account)
        weak var weakSelf: ViewController? = self
        NanoRep.shared().fetchConfiguration = { config, err in
            if (err != nil) {
                print("ERROR ::\(String(describing: err))")
            } else {
                DispatchQueue.main.async(execute: {
                    let deepLink = NRReadMoreViewController()
                    deepLink.infoHandler = self
                    deepLink.delegate = self
                    deepLink.articleId = textField.text
                    deepLink.applicationHandler = weakSelf
                    let navController = UINavigationController(rootViewController: deepLink)
                    navController.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.dismissDeeplinkPage(_:)))
                    weakSelf?.present(navController, animated: true)
                })
            }
        }
        
        return true
    }
    
    @objc func dismissDeeplinkPage(_ sender: UIBarButtonItem?) {
        self.presentedViewController?.dismiss(animated: true)
    }

    func didSubmitFeedback(_ info: [AnyHashable : Any]!) {
        
    }
    
    func presenting(_ controller: UIViewController!, shouldHandleClickedLink link: String!) -> Bool {
        return true
    }
    
    func didClick(toCall phoneNumber: String!) {
        
    }
    
    func didClickLink(_ url: String!) {
        
    }
    
    func didSessionExpire() {
        
    }
    
    func controller(_ controller: NRConversationalViewController!, didClickApplicationQuickOption quickOption: NRQuickOption!) {
        
    }
    
    func readmoreController(_ readmoreController: NRReadMoreViewController!, presentModally controller: UIViewController!) {
        if let aController = controller {
            readmoreController?.navigationController?.present(aController, animated: true)
        }
    }
}

