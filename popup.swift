//
//  popup.swift
//  wof0.2
//
//  Created by Marc Beepath on 12/11/2022.
//

import UIKit

class popup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        correctPhraseLabel.text = correctPhrase
        congratsLabel.text = congrats
        scoreMessageLabel.text = scoreMessage

        // Do any additional setup after loading the view.
    }
    
    var correctPhrase = ""
    var congrats = ""
    var scoreMessage = ""

    @IBOutlet weak var correctPhraseLabel: UILabel!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var scoreMessageLabel: UILabel!
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
