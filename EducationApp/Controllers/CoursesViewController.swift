//
//  CoursesViewController.swift
//  EducationApp
//
//  Created by Shivam Singh on 19/04/20.
//  Copyright © 2020 Shivam Singh. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {

    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var coursesTableView: UITableView!

    var selectedSubject: Subjects?
    var courseSelectedArray = [String]()
    var cellDelegate: RadioPressProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup Views
        setupTableView()
        setupTitle()
    }

    func setupTableView() {
        coursesTableView.delegate = self
        coursesTableView.dataSource = self
        coursesTableView.separatorColor = .white
        coursesTableView.tableFooterView = UIView()
        coursesTableView.reloadData()
    }

    func setupTitle() {
        self.courseTitle.text = (selectedSubject?.item?.capitalizingFirstLetter() ?? "") + " Courses"
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let topController = keyWindow?.rootViewController {
                if let presentedViewController = topController as? UINavigationController, let controller = presentedViewController.visibleViewController as? EducationViewController {
                    controller.semiTransView.isHidden = true
                }
            }
        })
    }

}

// MARK: Level Table DataSource and Delegate
extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSubject?.courses?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell", for: indexPath) as! CoursesViewCell
        cell.backgroundColor = .clear
        cell.cellDelegate = cellDelegate
        cell.radioDelegate = self
        cell.courseRadioButton.tag = indexPath.row
        let courseLabel = selectedSubject?.courses?[indexPath.row]
        cell.courseLabel.text = courseLabel
        cell.courseRadioButton.isSelected = courseSelectedArray.contains(courseLabel ?? "")
        return cell
    }
}

extension CoursesViewController: RadioPressProtocol {
    func didPressRadioButton(_ sender: UIButton) {
        let radioButtonTitle = selectedSubject?.courses?[sender.tag]
        if sender.isSelected {
            courseSelectedArray.append(radioButtonTitle ?? "")
        } else {
            let index = courseSelectedArray.firstIndex(of: title ?? "") ?? 0
            courseSelectedArray.remove(at: index)
        }
        coursesTableView.reloadData()
    }
}

class HalfSizePresentationController : UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }
            return CGRect(x: 50, y: 100, width: theView.bounds.width - 100, height: theView.bounds.height - 200)
        }
    }
}

