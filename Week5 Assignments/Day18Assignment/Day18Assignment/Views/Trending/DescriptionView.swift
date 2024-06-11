//
//  DescriptionView.swift
//  Day18Assignment
//
//  Created by user on 6/10/24.
//

import UIKit

import Alamofire
import SnapKit

final class DescriptionView: UIView {
    let background: UIView = UIView()
    var title: UILabel = UILabel()
    var subtitle: UILabel = UILabel()
    let divider: UIView = UIView()
    let detailLabel: UILabel = UILabel()
    let disclosureButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension DescriptionView: CodeBaseBuilldable {
    func configureHierarchy() {
        self.addSubview(background)
        background.addSubview(title)
        background.addSubview(subtitle)
        background.addSubview(divider)
        background.addSubview(detailLabel)
        background.addSubview(disclosureButton)
    }
    
    func configureLayout() {
        background.snp.makeConstraints {
            $0.edges.equalTo(self.snp.edges)
        }
        
        title.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(background)
                .inset(16)
        }
        
        subtitle.snp.makeConstraints {
            $0.leading.trailing.equalTo(title)
            $0.top.equalTo(title.snp.bottom)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(title)
            $0.top.equalTo(subtitle.snp.bottom)
                .offset(16)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
                .offset(16)
            $0.leading.equalTo(divider.snp.leading)
            $0.bottom.equalTo(background.snp.bottom)
                .offset(-8)
            $0.height.equalTo(30)
        }
        
        disclosureButton.snp.makeConstraints {
            $0.leading.equalTo(detailLabel.snp.trailing)
            $0.trailing.equalTo(divider.snp.trailing)
            $0.centerY.equalTo(detailLabel.snp.centerY)
            $0.size.equalTo(44)
        }
        
    }
    
    func configureUI() {
        background.backgroundColor = .white
        
        title.numberOfLines = 1
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        
        subtitle.numberOfLines = 1
        subtitle.font = .systemFont(ofSize: 16, weight: .regular)
        subtitle.textColor = .darkGray
        
        divider.backgroundColor = .darkGray
        
        detailLabel.textColor = .darkGray
        detailLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        detailLabel.text = "자세히보기"
        
        disclosureButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        disclosureButton.tintColor = .darkGray
    }
    
    func configureData(_ data: TrendingInfo) {
        title.text = data.name
        fetchCreditData(data)
    }
    
    func fetchCreditData(_ data: TrendingInfo) {
        let parameters: Parameters = [
            "language" : "en-US"
        ]
        
        let headers: HTTPHeaders = [
            "accept" : "application/json",
            "Authorization" : "Bearer \(TMDBKey.accessToken)"
        ]
        
        AF.request(
            "https://api.themoviedb.org/3/tv/\(data.id)/credits",
            parameters: parameters,
            headers: headers
        )
        .responseDecodable(of: CreditResponse.self) { [weak self] response in
            switch response.result {
            case .success(let value):
                self?.subtitle.text = value.cast.map { $0.name }.joined(separator: ", ")
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
