//
//  EducationLevelViewCell.swift
//  EducationApp
//
//  Created by Shivam Singh on 19/04/20.
//  Copyright © 2020 Shivam Singh. All rights reserved.
//

import UIKit

class EducationLevelViewCell: UITableViewCell {

    var cellDelegate: ButtonPressProtocol?

    let levelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(Constants.primaryColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        return button
    }()

    let badgeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Constants.primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = Constants.secondaryColor
        label.layer.cornerRadius = 12.5
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()

    func setupView() {
        addSubview(levelButton)
        addSubview(badgeLabel)
        self.selectionStyle = .none
        NSLayoutConstraint.activate([
            levelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            levelButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            levelButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            levelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            levelButton.heightAnchor.constraint(equalToConstant: 50),
            badgeLabel.heightAnchor.constraint(equalToConstant: 25),
            badgeLabel.widthAnchor.constraint(equalToConstant: 25),
            badgeLabel.rightAnchor.constraint(equalTo: self.levelButton.rightAnchor, constant: -20),
            badgeLabel.topAnchor.constraint(equalTo: self.levelButton.topAnchor, constant: 12.5),
        ])
        levelButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonPressed(sender: UIButton) {
        sender.backgroundColor = Constants.secondaryColor
        cellDelegate?.didPressButton(sender)
    }
}

protocol ButtonPressProtocol : class {
    func didPressButton(_ sender: UIButton)
}
