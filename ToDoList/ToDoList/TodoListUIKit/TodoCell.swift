//
//  TodoCell.swift
//  ToDoList
//
//  Created by Powers Mikaela on 01.07.2024.
//

import UIKit




class TodoCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = ColorsUIKit.labelPrimary
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        backgroundColor = ColorsUIKit.white

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
