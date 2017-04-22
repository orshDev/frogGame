//
//  ViewController.swift
//  WhackFrog
//
//  Created by Shani Oliel on 4/9/17.
//  Copyright © 2017 Tamirg. All rights reserved.
//

import UIKit
var Timer1 = Timer()
var frogpop : Timer!
var Counter = 60
var GameScore = 0
var FrogCounter = 9
var StopGame = false

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var background: UIView?
    @IBOutlet weak var TimerLabel: UILabel!
    var FlagTimeIsUp: Bool = false
    let winImage = UIImage(named:"youwin.jpg")
    let timeOverImage = UIImage(named:"gameover.jpg")
    
    let boardImage = UIImage(named:"board.jpg")
    let newGameImage = UIImage(named:"newgame.jpg")
    
    @IBOutlet weak var ScorePoint: UILabel!

    
    
    @IBOutlet weak var StartGameView: UIImageView!
    @IBOutlet weak var StartNewGame: UIButton!
   
  
    @IBOutlet weak var GameFinishHeader: UIImageView!
    
    @IBOutlet weak var ScoreBoard: UIImageView!
    
    @IBOutlet weak var TimeBoard: UIImageView!
    
    @IBAction func StartNewGameClick(_ sender: UIButton) {
        print("start new game")
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "swamp.jpg")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
           
        ScoreBoard.image = boardImage
        TimeBoard.image = boardImage
        DisplayTimer()
        TimerLabel.text = "Time: \(Counter)"
        ScorePoint.text = "\(GameScore)"
            
    }
    
    func DisplayTimer() {
        Timer1 = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        

        if Counter != 0 {
            Counter -= 1
            print(Counter)
            TimerLabel.text = "\(Counter)"
            ScorePoint.text = "\(GameScore)"
        } else {
            //print("finish")
           
            // call a game over method here...
            FlagTimeIsUp=true
        }
        checkFinishGame()
    }

    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        cell.setImage()
        cell.initGame()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkFinishGame(){
        if (FlagTimeIsUp) {
            print("Game over Time is Up")
             Timer1.invalidate()
            frogpop.invalidate()
            StopGame = true
            GameFinishHeader.image = timeOverImage
            StartGameView.image = #imageLiteral(resourceName: "newgame")
            
           
            
        }
        if (FrogCounter == 0){
            print("Game over you win")
            Timer1.invalidate()
            GameFinishHeader.image = #imageLiteral(resourceName: "youwin")
            StartGameView.image = #imageLiteral(resourceName: "newgame")
        }
    }

}

class GameCell: UICollectionViewCell {
    @IBOutlet weak var btnClickFrog: UIButton!
    let frogImage = UIImage(named:"frog.jpg")
    let leafImage = UIImage(named:"leaf.jpg")
    
    var isFrog :Bool = false
    var hit: Bool = false
    var Celllock: Bool = false
    
    
    @IBAction func btnHitFrog(_ sender: UIButton) {
        
     if (!StopGame){
          if (!Celllock){
        
            if isFrog{
                btnClickFrog.setImage(nil, for: .normal)
                GameScore += 20
                print("Score" + "\(GameScore)")
                FrogCounter -= 1
                print("NumOfFrogs" + "\(FrogCounter)")
                hit = true
                Celllock = true
            }
        }
     }
        
       
        
    }
    
    func initGame(){
        
     
        frogpop = Timer.scheduledTimer(timeInterval: randomNumber(), target: self, selector: #selector(timeTohitFrog), userInfo: nil, repeats: true)
        
        
        
        
        

    }
    
    func setImage(){
        btnClickFrog.setImage(leafImage, for: .normal)
    }
    
    func timeTohitFrog(){
        if (!StopGame){
        
            if (hit){
                btnClickFrog.setImage(nil, for: .normal)
            }
            else{
                
                if (!isFrog) {
                    isFrog=true
                    btnClickFrog.setImage(frogImage, for: .normal)
                    
                } else {
                    isFrog = false
                    btnClickFrog.setImage(leafImage, for: .normal)
                }
            }
        }
     
       
        
    }
    
    func randomNumber() -> Double{
        let randomNum:UInt32 = arc4random_uniform(6) + 3
        let num:Double = Double(randomNum)
        return num
    }
    
    
    
}

