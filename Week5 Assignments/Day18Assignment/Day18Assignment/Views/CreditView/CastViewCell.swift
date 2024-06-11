//
//  CastViewCell.swift
//  Day18Assignment
//
//  Created by user on 6/10/24.
//

import UIKit

import SnapKit

final class CastViewCell: UITableViewCell {
    let profileImage: UIImageView = UIImageView()
    let actorName: UILabel = UILabel()
    let playedRole: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CastViewCell: CodeBaseBuilldable {
    func configureHierarchy() {
        contentView.addSubview(profileImage)
        contentView.addSubview(actorName)
        contentView.addSubview(playedRole)
    }
    
    func configureLayout() {
        profileImage.snp.makeConstraints {
            $0.width.equalTo(contentView.snp.width)
                .multipliedBy(0.2)
            $0.height.equalTo(profileImage.snp.width)
                .multipliedBy(1.3)
            $0.verticalEdges.equalTo(contentView.snp.verticalEdges)
                .inset(8)
            $0.leading.equalTo(contentView.snp.leading)
                .offset(8)
        }
        
        actorName.snp.makeConstraints {
            $0.centerY.equalTo(profileImage.snp.centerY)
                .offset(-16)
            $0.leading.equalTo(profileImage.snp.trailing)
                .offset(16)
            $0.trailing.equalTo(contentView.snp.trailing)
                .offset(-16)
        }
        
        playedRole.snp.makeConstraints {
            $0.centerY.equalTo(profileImage.snp.centerY)
                .offset(16)
            $0.leading.equalTo(actorName.snp.leading)
            $0.trailing.equalTo(actorName.snp.trailing)
        }
    }
    
    func configureUI() {
        profileImage.backgroundColor = .systemGray4
        profileImage.layer.cornerRadius = 8
        profileImage.clipsToBounds = true
        
        actorName.font = .systemFont(ofSize: 16, weight: .medium)
        playedRole.font = .systemFont(ofSize: 16, weight: .medium)
        playedRole.textColor = .systemGray3
    }
    
    func configureData(_ creditInfo: CreditInfo) {
        actorName.text = creditInfo.name
        playedRole.text = creditInfo.character
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(creditInfo.profile_path)") {
            profileImage.kf.setImage(with: url)
        }
    }
}
