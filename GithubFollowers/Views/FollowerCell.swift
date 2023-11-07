//
//  FollowerCell.swift
//  GithubFollowers
//
//  Created by Tien Thuy Ho on 11/5/23.
//

import Foundation
import UIKit

protocol ImageDownloader {
    func downloadImage(from url: URL) async throws -> Data
}

final class FollowerCell: UICollectionViewCell {
    static let reuseIdentifier = "FollowerCell"
    private let label = UILabel()
    private let imageView = UIImageView()
    private let favoriteButton = UIButton()
    var downloader: ImageDownloader?
    var follower: Follower?
    var toggleFavoriteHandle: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configureView() {
//        backgroundColor = .red
        
        label.textAlignment = .center
        addSubview(label)
        
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        favoriteButton.setImage(.init(systemName: "heart"), for: .normal)
        favoriteButton.setImage(.init(systemName: "heart.fill"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.contentHorizontalAlignment = .fill
        favoriteButton.contentVerticalAlignment = .fill
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        addSubview(favoriteButton)
        bringSubviewToFront(favoriteButton)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            favoriteButton.centerXAnchor.constraint(equalTo: imageView.trailingAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: imageView.bottomAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
    
    @objc private func toggleFavorite() {
        favoriteButton.isSelected = !favoriteButton.isSelected
        toggleFavoriteHandle?()
    }
    
    private func downloadImage(from url: URL) async throws -> UIImage? {
        guard let downloader else {
            return nil
        }
        
        let data = try await downloader.downloadImage(from: url)
        return UIImage(data: data) ?? UIImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFollower(_ follower: Follower) {
        label.text = follower.login
        
        Task {
            do {
                let image = try await downloadImage(from: follower.avatarURL)
                imageView.image = image
            } catch {
                
            }
        }
    }
}
