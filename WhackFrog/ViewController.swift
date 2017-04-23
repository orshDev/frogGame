//
//  ViewController.swift
//  WhackFrog
//
//  Created by Shani Oliel on 4/9/17.
//  Copyright © 2017 Tamirg. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

var Timer1 = Timer()
var frogpop : Timer!
var MissCounter = 0
var HitFrogCounter = 0
var StopGame = false
var player:AVAudioPlayer?




class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var background: UIView?
    @IBOutlet weak var TimerLabel: UILabel!
    var GameOver: Bool = false
    let winImage = UIImage(named:"youwin.jpg")
    let timeOverImage = UIImage(named:"gameover.jpg")
    
    let boardImage = UIImage(named:"board.jpg")
    let newGameImage = UIImage(named:"newgame.jpg")
    
    @IBOutlet weak var ScorePoint: UILabel!

    
    
    @IBOutlet weak var StartGameView: UIImageView?
    @IBOutlet weak var StartNewGame: UIButton!
   
  
    @IBOutlet weak var GameFinishHeader: UIImageView?
    
    @IBOutlet weak var ScoreBoard: UIImageView!
    
    @IBOutlet weak var TimeBoard: UIImageView!
    
     //  var player = AVAudioPlayer()
    
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
        TimerLabel.text = "\(MissCounter)"
        ScorePoint.text = "\(HitFrogCounter)"
      
            
    }
    
    func DisplayTimer() {
        Timer1 = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        

        if MissCounter != 3 {
          
            TimerLabel.text = "\(MissCounter)"
            ScorePoint.text = "\(HitFrogCounter)"
        } else {
            print("finish")
            TimerLabel.text = "\(MissCounter)"
            StopGame=true
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
        if (StopGame) {
            print("Game over you have 3 striks")
            Timer1.invalidate()
            frogpop.invalidate()
            GameFinishHeader?.image = timeOverImage
            StartGameView?.image = #imageLiteral(resourceName: "newgame")
            
           
            
        }
        if (HitFrogCounter == 30){
            print("Game over you win")
            Timer1.invalidate()
            frogpop.invalidate()
            StopGame = true
            self.GameFinishHeader?.image = #imageLiteral(resourceName: "youwin")
            StartGameView?.image = #imageLiteral(resourceName: "newgame")
        }
    }
    
    
    func turnofimages(){
        GameFinishHeader?.image = nil
        StartGameView?.image = nil
    }

    
    @IBAction func StartNewGameClick(_ sender: UIButton) {
        if (StopGame){
            print("start new game")
            HitFrogCounter = 0
            MissCounter = 0
            StopGame = false
            turnofimages()
            TimerLabel.text = "\(MissCounter)"
            ScorePoint.text = "\(HitFrogCounter)"
            frogpop.fire()
            DisplayTimer()
            
            //collectionView.reloadItems(at: [IndexPath])
            
        }
        
        
    }
   
}

class GameCell: UICollectionViewCell {
    @IBOutlet weak var btnClickFrog: UIButton!
    let frogImage = UIImage(named:"frog.jpg")
    let leafImage = UIImage(named:"leaf.jpg")
    
    var isFrog :Bool = false
    var hit: Bool = false
    var counterpopFrog = 0
    var numofpopFrog = 2
   var urlSound = "http://soundbible.com/mp3/Bull Frog-SoundBible.com-1416996315.mp3"
   // var Celllock: Bool = false
    
    
    @IBAction func btnHitFrog(_ sender: UIButton) {
        
     if (!StopGame){
        
            if isFrog{
                btnClickFrog.setImage(leafImage, for: .normal)
                HitFrogCounter += 1
                print("Score" + "\(HitFrogCounter)")
               // playSound()
                hit = true
              
            }
            else{
                MissCounter += 1
                print("NumOfmisses" + "\(MissCounter)")

            }
        //}
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
            
                if (!isFrog) {
                    isFrog=true
                    btnClickFrog.setImage(frogImage, for: .normal)
                 
                    
                } else {
                    isFrog = false
                    btnClickFrog.setImage(leafImage, for: .normal)
                }
         
        }
     
       
        
    }
    
    func randomNumber() -> Double{
        let randomNum:UInt32 = arc4random_uniform(2) + 1
        let num:Double = Double(randomNum)
        return num
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: urlSound, withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    
}

