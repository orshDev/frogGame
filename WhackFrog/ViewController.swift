//
//  ViewController.swift
//  WhackFrog
// Tamir Geva and Or Shechter
//

import UIKit
import AudioToolbox
import AVFoundation
import CoreLocation
import CoreMotion

var Timer1 = Timer()
var frogpop : Timer!
var MissCounter = 0
var HitFrogCounter = 0
var StopGame = false
var usewheel = false
var player:AVAudioPlayer?



class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,CLLocationManagerDelegate {
    
    
    var motionManager = CMMotionManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var wheelView: UIImageView!
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet var background: UIView?
    @IBOutlet weak var TimerLabel: UILabel!
    var GameOver: Bool = false
    let winImage = UIImage(named:"youwin.jpg")
    let timeOverImage = UIImage(named:"gameover.jpg")
    let wheelImage = UIImage(named:"savewheel.png")
    
    let boardImage = UIImage(named:"board.jpg")
    let newGameImage = UIImage(named:"newgame.jpg")
    var locationManager: CLLocationManager!

    var scores : [Score] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var InHighScore:Bool = false;
    var cell :  GameCell!
    @IBOutlet weak var btnwheel: UIButton!
   
    @IBOutlet weak var ScorePoint: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnScores: UIButton!
    
    
    @IBOutlet weak var StartGameView: UIImageView?
    @IBOutlet weak var StartNewGame: UIButton!
    
    
    @IBOutlet weak var GameFinishHeader: UIImageView?
    
    @IBOutlet weak var ScoreBoard: UIImageView!
    
    @IBOutlet weak var TimeBoard: UIImageView!
    
       //  var player = AVAudioPlayer()
    var collection : UICollectionView?
    @IBAction func btnwheel(_ sender: Any) {
        print("use wheel")
        usewheel = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        //set background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "swamp.jpg")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        view.backgroundColor = UIColor.gray
        
        
        
        
        
        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//        
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//        
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        wheelView.image = wheelImage
      
        ScoreBoard.image = boardImage
        TimeBoard.image = boardImage
        DisplayTimer()
        TimerLabel.text = "\(MissCounter)"
        ScorePoint.text = "\(HitFrogCounter)"
        print("fdfd")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager.gyroUpdateInterval = 0.2
        print("enter Gyro")
        

        motionManager.startGyroUpdates(to: OperationQueue.current!){(dataGyro,error) in
        
            if let mydata = dataGyro{
                if (usewheel){
                
                    if mydata.rotationRate.x > 2 || mydata.rotationRate.y > 2 {
                        print("rotate screen")
                        print(mydata.rotationRate)
                        //
                        
                    }
                }
                
              
                
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }


    func DisplayTimer() {
        Timer1 = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        
        
        if MissCounter < 3 {
            
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
    func numberOfSections(in collection: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         cell = collection.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        print(indexPath)
        cell.setImage()
        if(usewheel){
         cell.initGame(setuptime: 10)
            print("slow")
        }
        else{
         cell.initGame(setuptime: 2)
        }
       
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
            
            //check if in high score table
            InHighScore = checkIfInHighScore()
            if (InHighScore){
                btnSave.isHidden = false
                btnScores.isHidden = false
                lblName.isHidden = false
                
            }
            else{
                btnSave.setTitle("continue",for : .normal)
                btnSave.isHidden = false
            }
            
        }
        if (HitFrogCounter == 30){
            print("Game over you win")
            Timer1.invalidate()
            frogpop.invalidate()
            StopGame = true
            self.GameFinishHeader?.image = #imageLiteral(resourceName: "youwin")
            StartGameView?.image = #imageLiteral(resourceName: "newgame")
            print("gfg");
            
            //check if in high score table
            InHighScore = checkIfInHighScore()
            if (InHighScore){
                btnSave.isHidden = false
                btnScores.isHidden = false
                lblName.isHidden = false
                
            }
            else{
                btnSave.setTitle("continue",for : .normal)
                btnSave.isHidden = false
            }
            
            
        }
    }
    
    func checkIfInHighScore()->Bool{
        
        let data =  getHighScorePlayersData()
        print(data)
        if data.isEmpty{
         return true
        }
        let currentScore = Int16(HitFrogCounter);
        for playerdata in data
        {
            
            
           // if (3<currentScore ){
           //     return true
           // }
            if (playerdata.score<currentScore ){
                return true
           }
            
        }
        
        
        return false
    }
    
    func getHighScorePlayersData()->[Score]
    {
        do{
            scores = try context.fetch(Score.fetchRequest())
        }
        catch{
            print("Fetch Failed")
        }
        
        return scores
        
    }
    
    func saveScore() {
        if(InHighScore){
            
            //searching the current location
            let locCoord = CLLocationCoordinate2DMake(self.locationManager.location!.coordinate.latitude, self.locationManager.location!.coordinate.longitude)
            
            // 1. pass the data from the current location to lat and lng
            let latitude = locCoord.latitude
            let longitude = locCoord.longitude
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let score = Score(context: context)
            score.name = lblName.text!
            score.score = Int16(HitFrogCounter)
            score.date = Date() as NSDate?
            score.lat = latitude
            score.lng = longitude
            print("lat" + "\(latitude)"+"lang"+"\(longitude)")
        
        }
        
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func continueToScoreBoard(){
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func turnofimages(){
        GameFinishHeader?.image = nil
        StartGameView?.image = nil
    }
    
    @IBAction func btnSave(_ sender: Any) {
        saveScore()
        performSegue(withIdentifier: "ShowScoresSegue", sender: self)
    }
    @IBAction func ViewScoresTable(_ sender: Any) {
        performSegue(withIdentifier: "ShowScoresSegue", sender: self)
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
            btnScores.isHidden = true
            
            
            //collectionView.reloadItems(at: [IndexPath])
            
        }
    }
}

class GameCell: UICollectionViewCell {
    @IBOutlet weak var btnClickFrog: UIButton!
    let frogImage = UIImage(named:"frog.jpg")
    let leafImage = UIImage(named:"leaf.jpg")
    @IBOutlet weak var Frogview: UIImageView?
    var isFrog :Bool = false
    var hit: Bool = false
    var counterpopFrog = 0
    var numofpopFrog = 2
    var urlSound = "http://soundbible.com/mp3/Bull Frog-SoundBible.com-1416996315.mp3"
    // var Celllock: Bool = false
    var i = 1
    //COMMITTTTT
    
    
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
    
        func initAnimation(){
    
          Frogview?.image = frogImage
           animation()
        }
    
    
    func initGame(setuptime: Int){
        initAnimation()
        frogpop = Timer.scheduledTimer(timeInterval: randomNumber(numDelay: setuptime), target: self, selector: #selector(timeTohitFrog), userInfo: nil, repeats: true)
        
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
    
    override func prepareForReuse() {
        
    }
    
    func randomNumber(numDelay: Int) -> Double{
        print("enter random")
        var randomNum:UInt32
        if (usewheel){
            print("enter slow mode")
           randomNum = arc4random_uniform(UInt32(2)) + 1

        }
        else{
         randomNum = arc4random_uniform(UInt32(10)) + 1
        }
        
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
        func animation(){
    
            UIView.animate(withDuration: 0.7, delay: 1.0, options: .curveEaseOut, animations: {
                
                
                var frogFrame = self.Frogview?.frame
                frogFrame?.origin.y += (frogFrame?.size.height)!
                
                
            }, completion: { finished in
                print("frog move animation")
            })        }
    

    
    
}

