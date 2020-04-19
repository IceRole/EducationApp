//
//  EducationViewModel.swift
//  EducationApp
//
//  Created by Shivam Singh on 19/04/20.
//  Copyright © 2020 Shivam Singh. All rights reserved.
//

import UIKit

class EducationViewModel: NSObject {

    public var levelList: EducationData?

    public func parseData() {
        levelList = DataParser.fetchEducationDataFromFile()
    }

    func getTopNavigationTitle(secondViewLoad: Bool, selectedIndex: Int) -> String {
        return secondViewLoad ? levelList?.education?[selectedIndex].level ?? "" : levelList?.title ?? ""
    }

    func hideAndShowViewAnimated(_ levelTableView: UITableView) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        //Hide Table View
        UIView.transition(with: levelTableView, duration: 1.0, options: transitionOptions, animations: {
            levelTableView.isHidden = true
        })
        //Show Table View
        UIView.transition(with: levelTableView, duration: 1.0, options: transitionOptions, animations: {
            levelTableView.isHidden = false
            levelTableView.reloadData()
        })
    }

}
