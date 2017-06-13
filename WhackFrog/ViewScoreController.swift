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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()

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
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return
//    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as! PlayerCell
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
    var datetime =  Date() as NSDate?
    
    func configure(score: Score) {
        
//        if let playerName = score.name{
//        }

    }
}
