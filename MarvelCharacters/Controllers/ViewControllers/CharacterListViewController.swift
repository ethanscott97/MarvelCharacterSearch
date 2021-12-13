//
//  CharacterListViewController.swift
//  MarvelCharacters
//
//  Created by Ethan Scott on 12/11/21.
//

import UIKit

class CharacterListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var returnToTopButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        getAllCharacters()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.searchController?.resignFirstResponder()
    }
    
    @IBAction func returnToTopButtonTapped(_ sender: Any) {
        tableview.setContentOffset(.zero, animated: true)
    }
    
    
    var characters: [Character] = []
    var didSearch = false
    var totalResults = 0
    
    //MARK: - TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if characters.count != 0 {
            return characters.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if characters.count != 0 {
            guard let cell = tableview.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterTableViewCell else {return UITableViewCell()}
            
            cell.character = characters[indexPath.row]
            
            return cell
        } else if didSearch {
            let cell = tableview.dequeueReusableCell(withIdentifier: "noResultsCell", for: indexPath)
            return cell
        }
        //So initial load doesn't show a white cell
        let clearCell = UITableViewCell()
        clearCell.backgroundColor = .clear
        return clearCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let resultsShowing = self.characters.count
        
        if indexPath.row == characters.count - 1 && resultsShowing < totalResults {
            if !didSearch {
                CharacterController.fetchAllCharacters(offset: resultsShowing) { result in
                    DispatchQueue.main.async {
                        switch result {
                        
                        case .success(let data):
                            self.characters += data.0
                            self.totalResults = data.1
                            self.tableview.reloadData()
                            print("Loading more characters: \(self.characters.count) of \(self.totalResults)")
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                    }
                }
            } else {
                guard let searchText = searchBar.text else {return}
                CharacterController.fetchCharactersWith(searchTerm: searchText, offset: resultsShowing) { result in
                    DispatchQueue.main.async {
                        switch result {
                        
                        case .success(let data):
                            self.characters += data.0
                            self.totalResults = data.1
                            self.tableview.reloadData()
                            print("Loading more characters: \(self.characters.count) of \(self.totalResults)")
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //returnToTopButton will appear when scrolled down
        returnToTopButton.tintColor = .black
        if tableview.contentOffset.y.isLessThanOrEqualTo(CGFloat(50)) {
            returnToTopButton.tintColor = .clear
        }
    }
    
    //MARK: - SearchBar Functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
        
        CharacterController.fetchCharactersWith(searchTerm: searchTerm.lowercased(), offset: 0) { result in
            DispatchQueue.main.async {
                switch result {
                
                case .success(let data):
                    self.characters = data.0
                    self.totalResults = data.1
                    self.tableview.reloadData()
                    self.didSearch = true
                    print("Loading characters: \(self.characters.count) of \(self.totalResults)")
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    

    //MARK: - Functions
    func getAllCharacters() {
        let offset = self.characters.count
        CharacterController.fetchAllCharacters(offset: offset) { result in
            DispatchQueue.main.async {
                switch result {
                
                case .success(let data):
                    self.characters = data.0
                    self.totalResults = data.1
                    self.tableview.reloadData()
                    print("Loading characters: \(self.characters.count) of \(self.totalResults)")
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    func setupView() {
        //rotate and set background of tableview
        let tempImageView = UIImageView(image: UIImage(named: "background"))
        tempImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        tempImageView.frame = self.tableview.frame
        self.tableview.backgroundView = tempImageView
        //this line prevents a major gap between bottom of tableview and the last cell
        tableview.estimatedRowHeight = 150
        
        returnToTopButton.tintColor = .clear
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableview.indexPathForSelectedRow,
                  let destination = segue.destination as? CharacterDetailViewController else {return}
            let characterToSend = characters[indexPath.row]
            destination.character = characterToSend
        }
    }


}
