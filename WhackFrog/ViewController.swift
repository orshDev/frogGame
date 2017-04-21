//
//  ViewController.swift
//  WhackFrog
//
//  Created by Shani Oliel on 4/9/17.
//  Copyright © 2017 Tamirg. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        //cell.setImage()
        cell.initGame()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class GameCell: UICollectionViewCell {
    @IBOutlet weak var btnClickFrog: UIButton!
    let frogImage = UIImage(named:"frog.jpg")
    let leafImage = UIImage(named:"leaf.jpg")
    var frogpop : Timer!
    var isFrog :Bool = false

    
    
    @IBAction func btnHitFrog(_ sender: UIButton) {
        btnClickFrog.setImage(frogImage, for: .normal)
        
    }
    
    func initGame(){
        
        btnClickFrog.setImage(leafImage, for: .normal)
        frogpop = Timer.scheduledTimer(timeInterval: randomNumber(), target: self, selector: #selector(timeTohitFrog), userInfo: nil, repeats: false)
        
        
        //DispatchQueue.global(qos: .userInitiated).async {
        
          //  self.frogpop = Timer.scheduledTimer(timeInterval: self.randomNumber(), target: self, selector: #selector(self.timeTohitFrog), userInfo: nil, repeats: true)
            
            
            //DispatchQueue.main.async {
                
            //}
        //}
        
        

    }
    
    func setImage(){
        btnClickFrog.setImage(leafImage, for: .normal)
    }
    
    func timeTohitFrog(){
        
        if (!isFrog) {
            isFrog=true
            btnClickFrog.setImage(frogImage, for: .normal)
            
        } else {
            isFrog = false
            btnClickFrog.setImage(frogImage, for: .normal)
        }
        
        

        
        //let when DispatchTime.now() + 2
        //DispatchQueue.main.asyncAfter(deadline: <#T##DispatchTime#>execute: <#T##() -> Void#>)

        
        
    }
    
    func randomNumber() -> Double{
        let randomNum:UInt32 = arc4random_uniform(6) + 3
        let num:Double = Double(randomNum)
        return num
    }
    
    
    
}

