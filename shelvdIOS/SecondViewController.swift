//
//  SecondViewController.swift
//  shelvdIOS
//
//  Created by Kat Matfield on 04/01/2015.
//  Copyright (c) 2015 Kat Matfield. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.frame = CGRect(x: 17,y: 18, width: 320,height: 411)
//        scrollView.sizeToFit()
        scrollView.contentSize = CGSize(width: 288,height: 15000)
        scrollView.scrollEnabled = true
        self.view.addSubview(scrollView)
        getBookData("finished", parentView: scrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBookData(bookStatus: String, parentView: UIView) -> Void {
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        
        var endpoint = ApiEndpoint(bookStatus: bookStatus)
        
        let session = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: NSURL(string: endpoint.url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            let bookJSON = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
            
            var distanceFromTop: CGFloat = 0
            for item in bookJSON {
                var thisBook = Book(bookDict: item as NSDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var label: UILabel = UILabel()
                    
                    label.textColor = UIColor.whiteColor()
                    label.numberOfLines = 0
                    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    label.textAlignment = NSTextAlignment.Center
                    label.text = thisBook.labelText
                    label.font = UIFont (name: "Baskerville", size: 18)

                    var width: CGFloat = 240
                    var height = self.heightForView(thisBook.labelText, font:label.font, width: width)
                    var centredXPoint: CGFloat = (parentView.frame.width - width) / 2
                    label.frame = CGRectMake(centredXPoint, distanceFromTop, width, height)
                    
                    parentView.addSubview(label)
                    distanceFromTop += CGRectGetHeight(label.frame) + 20
                    
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    
                })
            }
            
        })
        task.resume()
        
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }


}

