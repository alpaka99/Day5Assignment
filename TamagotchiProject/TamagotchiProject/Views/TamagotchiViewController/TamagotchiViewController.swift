//
//  TamagotchiViewController.swift
//  TamagotchiProject
//
//  Created by user on 6/7/24.
//

import UIKit

import SnapKit

final class TamagotchiViewController: UIViewController {
    let messageBubble: TGMessageBubble = TGMessageBubble()
    let profile: TGProfileView = TGProfileView()
    let status: UILabel = UILabel()
    let feedFoodView: TGButtonTextField = TGButtonTextField()
    let feedWaterView: TGButtonTextField = TGButtonTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
}

extension TamagotchiViewController: CodeBaseBuildable {
    func configureHierarchy() {
        view.addSubview(messageBubble)
        view.addSubview(profile)
        view.addSubview(status)
        view.addSubview(feedFoodView)
        view.addSubview(feedWaterView)
    }
    
    func configureLayout() {
        profile.snp.makeConstraints {
            $0.size.equalTo(view.snp.width)
                .multipliedBy(0.5)
            $0.center.equalTo(view.snp.center)
        }
        
        messageBubble.snp.makeConstraints {
            $0.bottom.equalTo(profile.snp.top)
                .offset(-8)
            $0.width.equalTo(profile.snp.width)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        status.snp.makeConstraints {
            $0.top.equalTo(profile.snp.bottom)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        feedFoodView.snp.makeConstraints {
            $0.width.equalTo(profile.snp.width)
            $0.top.equalTo(status.snp.bottom)
                .offset(8)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        feedWaterView.snp.makeConstraints {
            $0.width.equalTo(profile.snp.width)
            $0.top.equalTo(feedFoodView.snp.bottom)
                .offset(8)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .TGBackgroundColor
        
        navigationItem.title = "고석환님의 다마고치"

        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(settingButtonTapped)
        )
        rightBarButtonItem.tintColor = .TGNavyColor
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        status.text = "LV0 • 밥알 0개 • 물방울 0개"
        status.textColor = .TGNavyColor
        status.font = .systemFont(ofSize: 12, weight: .bold)
    }
    
    func configureData(_ data: Tamagotchi) {
        
    }
    
    @objc
    func settingButtonTapped(_ button: UIBarButtonItem) {
        print(#function)
    }
}
