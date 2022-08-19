//
//  ViewController.swift
//  SDWebImage WebAPI CollectionView
//
//  Created by macmini01 on 19/08/22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    var dogAllData: DogData?
    var dogImageAllLinks = [String]()
    
    //MARK: Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        fetchData()
    }
}

//MARK: Collection View Setup
extension ViewController {
    func collectionViewSetup() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

//MARK: API Calling
extension ViewController {
    func fetchData() {
        let url = URL(string: "https://dog.ceo/api/breed/hound/images")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            guard let validData = data, error == nil else {
                print("error")
                return
            }
            
            var dogObject: DogData?
            
            do {
                dogObject = try JSONDecoder().decode(DogData.self, from: validData)
            }
            catch {
                print("Error while Decoding JSON into Swift Structure \(error)")
            }
            
            self.dogAllData = dogObject
            self.dogImageAllLinks = self.dogAllData!.message
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        task.resume()
    }
}

//MARK: Collection View Stubs
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogImageAllLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if let imageURL = URL(string: dogImageAllLinks[indexPath.row]) {
            
            cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageView.sd_imageIndicator?.startAnimatingIndicator()
            
            cell.imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "emptyImage"), options: .continueInBackground, completed: nil)
            
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.layer.cornerRadius = cell.imageView.frame.height/2
            
        } else {
            print("Invalid URL No Image")
            cell.imageView.image = UIImage(named: "emptyImage")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: size, height: size)
    }
}

