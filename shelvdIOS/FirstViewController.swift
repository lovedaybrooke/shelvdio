//
//  FirstViewController.swift
//  shelvdIOS
//
//  Created by Kat Matfield on 04/01/2015.
//  Copyright (c) 2015 Kat Matfield. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bookCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getBookData("unfinished")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBookData(bookStatus: String) -> Void {
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        
        var endpoint = ApiEndpoint(bookStatus: bookStatus)
        
        let session = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: NSURL(string: endpoint.url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            let bookJSON = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
            
            var distanceFromTop: CGFloat = 120
            for item in bookJSON {
                var thisBook = Book(bookDict: item as NSDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var bookCollectionItem = UICollectionViewCell()
                    
                    bookCollectionItem.frame = CGRectMake(40, distanceFromTop, 240, 120)
                    self.view.addSubview(bookCollectionItem)
                    
                    var titleLabel: UILabel = UILabel()
                    titleLabel.textColor = UIColor.whiteColor()
                    titleLabel.numberOfLines = 0
                    titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    titleLabel.textAlignment = NSTextAlignment.Center
                    titleLabel.text = thisBook.title
                    titleLabel.font = UIFont(name: "Baskerville", size: 22)
                    var height = self.heightForView(thisBook.title, font: titleLabel.font, width: 240) + CGFloat(20)
                    titleLabel.frame = CGRectMake(0, 0, 240, height)
                    bookCollectionItem.addSubview(titleLabel)
                    
                    var isbnLabel: UILabel = UILabel()
                    isbnLabel.textColor = UIColor.whiteColor()
                    isbnLabel.textAlignment = NSTextAlignment.Center
                    isbnLabel.text = thisBook.isbn
                    isbnLabel.font = UIFont (name: "Avenir-Book", size: 16)
                    isbnLabel.frame = CGRectMake(0, height, 240, 20)
                    bookCollectionItem.addSubview(isbnLabel)
                    
                    distanceFromTop += 120
                    
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

