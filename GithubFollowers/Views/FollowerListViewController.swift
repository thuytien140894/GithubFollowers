//
//  FollowerListViewController.swift
//  GithubFollowers
//
//  Created by Tien Thuy Ho on 11/5/23.
//

import UIKit
import Combine

final class FollowerListViewController: UIViewController {
    enum Section { case main }
    
    private let username: String
    private let provider: GithubFollowerProvider
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    private var cancellables = Set<AnyCancellable>()
    
    init(username: String, provider: GithubFollowerProvider = .init()) {
        self.username = username
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeListLayout())
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
        configureDataSource()
        
        provider.$followers
            .dropFirst()
            .sink { [weak self] in
                self?.updateUI(with: $0)
            }
            .store(in: &cancellables)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, follower in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as? FollowerCell else {
                return nil
            }
            
            cell.downloader = self?.provider.dataManager
            cell.toggleFavoriteHandle = {
                guard let self,
                      let index = self.provider.followers.firstIndex(of: follower) else {
                    return
                }
                
                self.provider.followers[index].isFavorite = !self.provider.followers[index].isFavorite
            }
            cell.setFollower(follower)
            return cell
        })
    }
    
    private func makeListLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.flexible(10)
        group.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        provider.loadFollowers(for: username)
    }
    
    private func updateUI(with followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
