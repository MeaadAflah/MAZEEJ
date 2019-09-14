//
//  ViewController2.swift
//  Mazeej
//
//  Created by Madio on 15/01/1441 AH.
//  Copyright © 1441 Fahad Almasmoum. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var inglabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var imageDetails: UIImageView!
    var image : UIImage?
    var food: String?
    var calories : Double?
    var healthLAbels : [String]?
    var diet : [String]?
    var ingrd : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDetails.image = image
        foodName.text = food
//        inglabel.text = ingrd!.joined(separator: ",")
//        dietLabel.text = diet?.joined(separator: ",")
//        healthLabel.text = healthLAbels?.joined(separator: ",")
        //calLabel.text = String(format:"%f", calories!)
        
        
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
