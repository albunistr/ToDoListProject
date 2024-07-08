//
//  TodoCalendarTableViewCell.swift
//  ToDoList
//
//  Created by Powers Mikaela on 05.07.2024.
//

import UIKit

class TodoCalendarTableViewCell: UITableViewCell {
    
    // MARK: - Views
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var circleView: UIImageView = {
        let circle = UIImage(named: "workColor")
        let circleImage = UIImageView(image: circle)
        circleImage.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            circleImage.widthAnchor.constraint(equalToConstant: 20),
            circleImage.heightAnchor.constraint(equalToConstant: 20)
        ])

        circleImage.translatesAutoresizingMaskIntoConstraints = false
        return circleImage
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 3
        label.text = ""
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = ColorsUIKit.white

        setupView()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Extensions
extension TodoCalendarTableViewCell: CellConfigurable {
    override func prepareForReuse() {
         super.prepareForReuse()
        label.text = nil
        label.attributedText = nil
    }
    
    func configure(with todoItem: TodoItem) {
        if todoItem.isCompleted {
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: todoItem.text)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributedString.length))
            label.attributedText = attributedString
            label.textColor = ColorsUIKit.labelTertiary
        } else {
            label.text = todoItem.text
            label.textColor = ColorsUIKit.labelPrimary
        }

        var imageString = ""
        switch todoItem.category {
        case .work:
            imageString = "workColor"
        case .studying:
            imageString = "studyingColor"
        case .hobby:
            imageString = "hobbyColor"
        case .other:
            imageString = "otherColor"
        }

        circleView.image = UIImage(named: imageString)
    }
}

private extension TodoCalendarTableViewCell {
    private func setupView() {
        addSubview(stackView)

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(circleView)
    }

    private func setupConstraints() {
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
