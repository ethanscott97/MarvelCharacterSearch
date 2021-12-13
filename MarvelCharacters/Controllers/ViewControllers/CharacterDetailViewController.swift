//
//  CharacterDetailViewController.swift
//  MarvelCharacters
//
//  Created by Ethan Scott on 12/11/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionTextView: UITextView!
    @IBOutlet weak var panelView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    var character: Character?
    
    func updateViews() {
        guard let character = character else {return}
        characterNameLabel.text = character.name
        characterDescriptionTextView.text = character.description
        if characterDescriptionTextView.text == "" {
            characterDescriptionTextView.text = "Unknown origins. Further research required"
        }
        CharacterController.fetchCharacterImage(for: character) { result in
            DispatchQueue.main.async {
                switch result {
                
                case .success(let image):
                    self.characterImageView.image = image
                case .failure(let error):
                    self.characterImageView.image = UIImage(named: "notAvailable")
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        let tempImageView = UIImageView(image: UIImage(named: "background"))
        tempImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        tempImageView.frame = view.frame
        view.insertSubview(tempImageView, at: 0)
        
        characterImageView.layer.borderWidth = 5
        characterNameLabel.layer.shadowRadius = 2
        panelView.layer.borderWidth = 5
    }

}
