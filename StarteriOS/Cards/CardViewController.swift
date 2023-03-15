//
//  ViewController.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 20/02/23.
//

import UIKit

class CardViewController: UIViewController {
 
    @IBOutlet weak var cardsTableView: UITableView!
    let child = SpinnerViewController()
    var cardsViewModel: CardsViewModel?
    var cellIdentifier = "cardCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.callToViewModelForUIUpdate()
    }
    
    func setupSpinner() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func hideSpinner() {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    func callToViewModelForUIUpdate() {
        self.cardsViewModel = CardsViewModel()
        self.cardsViewModel?.delegate = self
        self.setupSpinner()
        self.cardsViewModel?.bindViewModelToController = {
            DispatchQueue.main.async {
                self.hideSpinner()
                self.cardsTableView.delegate = self
                self.cardsTableView.dataSource = self
                self.cardsTableView.reloadData()
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension CardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsViewModel?.cardModel?.cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CardsCell else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        // Remove cell highlight/selection colour
        cell.selectionStyle = .none
        cell.result = cardsViewModel?.cardModel?.cards?[indexPath.row]
        return cell
    }
    
}

// MARK: CardsViewModel Delegate
extension CardViewController: CardsViewModelDelegate {
    
    static let title = "Alert!!"
    static let message = "Data fetch failed"
    
    func failStatus() {
        DispatchQueue.main.async {
            self.hideSpinner()
            self.showAlert(title: CardViewController.title, message: CardViewController.message)
        }
    }
    func refreshData() {
        hideSpinner()
    }
}
