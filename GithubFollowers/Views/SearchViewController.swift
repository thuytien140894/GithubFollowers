//
//  SearchViewController.swift
//  GithubFollowers
//
//  Created by Tien Thuy Ho on 11/5/23.
//

import UIKit

class SearchViewController: UIViewController {
    private let searchField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        view.addSubview(searchField)
        searchField.layer.borderColor = UIColor.gray.cgColor
        searchField.layer.borderWidth = 2
        searchField.layer.cornerRadius = 10
        searchField.placeholder = "Enter a username"
        searchField.textAlignment = .center
        searchField.delegate = self
        searchField.autocapitalizationType = .none
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                searchField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                searchField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                searchField.widthAnchor.constraint(equalToConstant: 200),
                searchField.heightAnchor.constraint(equalToConstant: 50),
            ]
        )
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        navigationController?.pushViewController(FollowerListViewController(username: searchText), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

