//
//  StartViewController.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/04/19.
//

import UIKit

class StartViewController: UIViewController {

    private var Image: UIImage!
    @IBOutlet weak var startImage: UIImageView!
    
    @IBAction func startButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Image = UIImage(named: "startImage1")
        self.startImage.image = self.Image
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
