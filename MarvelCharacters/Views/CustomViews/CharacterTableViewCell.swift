//
//  CharacterTableViewCell.swift
//  MarvelCharacters
//
//  Created by Ethan Scott on 12/11/21.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadowViewAndImageView()
    }

    var character: Character? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let character = character else {return}
        characterNameLabel.text = character.name
        
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
    }
    
    func setupShadowViewAndImageView() {
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOffset = CGSize(width: -1, height: 3)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.borderWidth = 5
        
        characterImageView.layer.borderWidth = 3
    }

}
