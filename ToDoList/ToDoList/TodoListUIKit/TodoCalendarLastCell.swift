//
//  TodoCalendarLastCell.swift
//  ToDoList
//
//  Created by Powers Mikaela on 01.07.2024.
//

import UIKit

class TodoCalendarLastCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = ColorsUIKit.labelTertiary
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateAppearance()
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func updateAppearance() {
        if isSelected || isHighlighted {
            backgroundColor = ColorsUIKit.labelDisable
            layer.borderWidth = 2.0
            layer.borderColor = ColorsUIKit.labelTertiary!.cgColor
            layer.cornerRadius = 16
        } else {
            backgroundColor = ColorsUIKit.backPrimary // Верните исходный цвет фона
            layer.borderWidth = 0.0
        }
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .vertical
        stackView.alignment = .center

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
