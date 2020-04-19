//
//  EducationViewController.swift
//  EducationApp
//
//  Created by Shivam Singh on 19/04/20.
//  Copyright © 2020 Shivam Singh. All rights reserved.
//

import UIKit

class EducationViewController: UIViewController {

    @IBOutlet weak var educationTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var levelTableView: UITableView!
    @IBOutlet weak var secondStepProgress: UILabel!
    @IBOutlet weak var semiTransView: UILabel!
    @IBOutlet weak var thirdStepProgress: UILabel!
    @IBOutlet weak var doneButton: UIButton!

    var educationViewModel: EducationViewModel?
    var buttonDelegate: ButtonPressProtocol?
    var secondViewLoad = false
    var levelButtonPressedIndex = -1
    var subjectButtonPressedIndex = -1
    var bagdeSelected = [Int: [String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide Navigation bar
        self.navigationController?.isNavigationBarHidden = true
        //setUp Model and Table
        setUpViewModel()
        setupTableView()
        setUpTitle()
    }

    func setUpViewModel() {
        educationViewModel = EducationViewModel()
        educationViewModel?.parseData()
    }

    func setUpTitle() {
        educationTitle.text = educationViewModel?.getTopNavigationTitle(secondViewLoad: secondViewLoad, selectedIndex: levelButtonPressedIndex)
    }

    func setupTableView() {
        levelTableView.delegate = self
        levelTableView.dataSource = self
        levelTableView.separatorColor = .clear
        levelTableView.register(EducationLevelViewCell.self, forCellReuseIdentifier: "levelButton")
        levelTableView.reloadData()
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        sender.isHidden = true
        secondViewLoad = false
        levelButtonPressedIndex = -1
        subjectButtonPressedIndex = -1
        levelTableView.reloadData()
        secondStepProgress.backgroundColor = .white
        doneButton.isHidden = true
        bagdeSelected.removeAll()
        setUpTitle()
    }

    @IBAction func doneButtonAction(_ sender: Any) {
        self.thirdStepProgress.backgroundColor = Constants.secondaryColor
        self.backButton.isHidden = true
        self.doneButton.isHidden = true
        self.levelTableView.isHidden = true
        self.educationTitle.text = "Success"
    }

}

// MARK: Level Table DataSource and Delegate
extension EducationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondViewLoad ?
            educationViewModel?.levelList?.education?[levelButtonPressedIndex].subjects?.count ?? 0 :
        educationViewModel?.levelList?.education?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "levelButton", for: indexPath) as! EducationLevelViewCell
        cell.backgroundColor = .clear
        cell.cellDelegate = self
        cell.levelButton.tag = indexPath.row
        cell.levelButton.backgroundColor = secondViewLoad &&
            subjectButtonPressedIndex == indexPath.row ? Constants.secondaryColor : .white
        let buttonTitle = secondViewLoad ? educationViewModel?.levelList?.education?[levelButtonPressedIndex].subjects?[indexPath.row].item : educationViewModel?.levelList?.education?[indexPath.row].level
        cell.levelButton.setTitle(buttonTitle?.capitalizingFirstLetter(), for: .normal)
        cell.badgeLabel.isHidden =  secondViewLoad ? !bagdeSelected.keys.contains(indexPath.row) :
        true
        cell.badgeLabel.text = "\(bagdeSelected[indexPath.row]?.count ?? 0)"

        return cell
    }
}

// MARK: Table Cell Button and Radio Button Delegate
extension EducationViewController: ButtonPressProtocol, RadioPressProtocol {

    func didPressButton(_ sender: UIButton) {
        if !secondViewLoad && sender.titleLabel?.text != Constants.noEducationLevel,
            educationViewModel?.levelList?.education?[sender.tag].subjects?.count ?? 0 > 0 {
            Constants.delay(0.2, closure: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.secondStepProgress.backgroundColor = Constants.secondaryColor
                strongSelf.secondViewLoad = true
                strongSelf.backButton.isHidden = false
            strongSelf.doneButton.isHidden = false
                strongSelf.levelButtonPressedIndex = sender.tag
                strongSelf.setUpTitle()
                strongSelf.educationViewModel?.hideAndShowViewAnimated(strongSelf.levelTableView)
            })
        } else if secondViewLoad, sender.titleLabel?.text != Constants.noEducationLevel, let count = self.educationViewModel?.levelList?.education?[levelButtonPressedIndex].subjects?[sender.tag].courses?.count, count > 0 {
            subjectButtonPressedIndex = sender.tag
            levelTableView.reloadData()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let pvc = storyboard.instantiateViewController(withIdentifier: "CoursesViewController") as? CoursesViewController else { return }
            pvc.modalPresentationStyle = UIModalPresentationStyle.custom
            pvc.transitioningDelegate = self
            pvc.selectedSubject =  self.educationViewModel?.levelList?.education?[levelButtonPressedIndex].subjects?[sender.tag]
            pvc.cellDelegate = self
            pvc.courseSelectedArray = self.bagdeSelected[subjectButtonPressedIndex] ?? []
            semiTransView.isHidden = false
            present(pvc, animated: true, completion: nil)
        } else if sender.titleLabel?.text != Constants.noEducationLevel {
            subjectButtonPressedIndex = sender.tag
            levelTableView.reloadData()
            let alert = UIAlertController(title: "Sorry..!!", message: "No Data Available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func didPressRadioButton(_ sender: UIButton) {
        let buttonTitle = self.educationViewModel?.levelList?.education?[levelButtonPressedIndex].subjects?[subjectButtonPressedIndex].courses?[sender.tag] ?? ""
        var courseArray = [String]()
        courseArray = bagdeSelected[subjectButtonPressedIndex] ?? []
        if sender.isSelected {
            courseArray.append(buttonTitle)
            bagdeSelected[subjectButtonPressedIndex] = courseArray
        } else {
            let index = courseArray.firstIndex(of: buttonTitle) ?? 0
            courseArray.remove(at: index)
            if courseArray.count < 1 {
                bagdeSelected.removeValue(forKey: subjectButtonPressedIndex)
            } else {
                bagdeSelected[subjectButtonPressedIndex] = courseArray
            }
        }
        levelTableView.reloadData()
    }
}

extension EducationViewController: UIViewControllerTransitioningDelegate {
   func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
          return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
      }
}
