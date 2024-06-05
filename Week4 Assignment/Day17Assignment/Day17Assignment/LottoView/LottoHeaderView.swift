//
//  LottoHeaderView.swift
//  Day17Assignment
//
//  Created by user on 6/5/24.
//

import UIKit

import SnapKit

final class LottoHeaderView: UIView {
    
    let title: UILabel = UILabel()
    let drawDate: UILabel = UILabel()
    let divider: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        self.addSubview(title)
        self.addSubview(drawDate)
        self.addSubview(divider)
    }
    
    private func configureLayout() {
        title.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide)
        }
        
        drawDate.snp.makeConstraints { make in
            make.centerY.equalTo(title.snp.centerY)
            make.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
                .offset(8)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges)
            make.height.equalTo(1.5)
            make.bottom.equalTo(self.snp.bottom)
        }
        
    }
    
    private func configureUI() {
        title.text = "당첨 번호 안내"
        
        drawDate.textAlignment = .right
        divider.backgroundColor = .systemGray4
    }
    
    internal func configureData(_ data: LottoInfo) {
        drawDate.text = "\(data.drwNoDate) 추첨"
    }
}
