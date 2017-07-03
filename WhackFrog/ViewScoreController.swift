//
//  ViewScoreControllerViewController.swift
//  WhackFrog
//
//  Created by Shani Oliel on 5/31/17.
//  Copyright © 2017 Tamirg. All rights reserved.
//

import UIKit
var scores : [Score] = []

class ViewScoreControllerViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapbtn: UIButton!
    //let pageTitle = UIImage(named:"high-score.png")
    
    @IBOutlet weak var pageTitleView: UIImageView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //set background
        
        // Do any additional setup after loading the view.
        
        //pageTitleView.image = pageTitle
    }
    @IBAction func MapbtnPress(_ sender: Any) {
        
          performSegue(withIdentifier: "navigate_scoreTable_to_map", sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        // tableView.reloadData()
        sortList()
            }


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData()
    {
        do{
        
            scores = try context.fetch(Score.fetchRequest())
        
        }
        catch{
            print("Fetch Failed")
        }
        
    }
    
    func sortList() { // should probably be called sort and not filter
        scores.sort() { $0.score > $1.score } // sort the fruit by name

        tableView.reloadData(); // notify the table view the data has changed
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        return
    //    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " Player        | Score          | Date "
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for :indexPath) as! PlayerCell
        cell.configure(score: scores[indexPath.row])
        
        
        
        return cell
    }
    
    
    
    
    func tableView( _ tableView : UITableView, numberOfRowsInSection section :Int)->Int{
        return scores.count
    }
    
    
    
}
class PlayerCell : UITableViewCell {
    var name :String = ""
    var score : String = ""
    //var name_player: UILabel?
    //var date_play: UILabel?
    //var score_play: UILabel?
    var datetime =  Date() as NSDate?
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var PlayerName: UILabel!
    func configure(score: Score) {
        
        let backgroundImage = UIImage(named: "high_score_board.png")
        let imageView = UIImageView(image: backgroundImage)
        backgroundView = imageView
        PlayerName?.text = score.name
        lblDate?.text = getstringDateFormat(date: score.date!)
        lblScore?.text = score.score.description
        
    }
    func getstringDateFormat(date:NSDate)->String
    {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date as Date)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
    }
}
