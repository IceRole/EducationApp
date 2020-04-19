//
//  CoursesViewCell.swift
//  EducationApp
//
//  Created by Shivam Singh on 19/04/20.
//  Copyright © 2020 Shivam Singh. All rights reserved.
//

import UIKit

class CoursesViewCell: UITableViewCell {
    var cellDelegate: RadioPressProtocol?
    var radioDelegate: RadioPressProtocol?

    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var courseRadioButton: CustomRadioButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func courseActionButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        cellDelegate?.didPressRadioButton(sender)
        radioDelegate?.didPressRadioButton(sender)
    }
    
}

protocol RadioPressProtocol : class {
    func didPressRadioButton(_ sender: UIButton)
}
