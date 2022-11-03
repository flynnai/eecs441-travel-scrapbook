//
//  MainVC.swift
//  swiftChatter
//
//  Created by Yuer Gao on 9/9/22.
//

import UIKit
import Combine
import GoogleMaps

final class MainVC: UITableViewController {
    
    private let locmanager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup refreshControler here later
                refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
        
        // add swipe (left) gesture recorgnizer
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(startMap(_:)))
        swipeRecognizer.direction = .left
        self.view.addGestureRecognizer(swipeRecognizer)
        
        ChattStore.shared.getChatts()
        
        chattsSubscriber = ChattStore.shared.$chatts
                  .receive(on: DispatchQueue.main)
                  .sink { _ in
                      self.tableView.reloadData()
                  }
        let composeButton = UIBarButtonItem(
                    systemItem: .compose,
                    primaryAction:UIAction(handler: { _ in
                                            let postVC = PostVC()
                                            postVC.locmanager = self.locmanager
                                            self.navigationController?.present(
                                                UINavigationController(rootViewController: postVC), animated: true
                    ) }))
                self.navigationItem.rightBarButtonItem = composeButton
                self.navigationItem.title = "Chatter"
        
        // Configure the location manager and ask for user permission
               locmanager.desiredAccuracy = kCLLocationAccuracyBest
               locmanager.requestWhenInUseAuthorization()
    }
    // MARK:- TableView handlers

    override func numberOfSections(in tableView: UITableView) -> Int {
        // how many sections are in table
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows per section
        return ChattStore.shared.chatts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // event handler when a cell is tapped
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // populate a single cell
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChattTableCell", for: indexPath) as? ChattTableCell else {
               fatalError("No reusable cell!")
           }
           
           let chatt = ChattStore.shared.chatts[indexPath.row]
           cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
           cell.usernameLabel.text = chatt.username
           cell.messageLabel.text = chatt.message
           cell.timestampLabel.text = chatt.timestamp
            // remember: cells are recycled and reused
          if let geodata = chatt.geodata {
              cell.geodataLabel.text = "Posted from " + geodata.loc
                  + ", while facing " + geodata.facing + " moving at " + geodata.speed + " speed."
              cell.geodataLabel.highlight(searchedText: geodata.loc, geodata.facing, geodata.speed)
              cell.mapButton.isHidden = false
              cell.renderChatt = {
                  let mapsVC = MapsVC()
                  mapsVC.chatt = chatt
                  self.navigationController?.pushViewController(mapsVC, animated: true)
              }
          } else {
              cell.geodataLabel.text = nil
              cell.mapButton.isHidden = true
              cell.renderChatt = nil
          }
           return cell
       }
    
    private func refreshTimeline(_ sender: UIAction?) {
        ChattStore.shared.getChatts()

        // stop the refreshing animation upon completion:
        self.refreshControl?.endRefreshing()
    }
    
    override func loadView() {
           super.loadView()

           tableView.register(ChattTableCell.self, forCellReuseIdentifier: "ChattTableCell")
           tableView.dataSource = self
           tableView.delegate = self

           refreshControl = UIRefreshControl()
       }
    
    private var chattsSubscriber: AnyCancellable?
    
    @objc func startMap(_ sender: UISwipeGestureRecognizer) {
        let mapsVC = MapsVC()
        mapsVC.locmanager = self.locmanager
        self.navigationController?.pushViewController(mapsVC, animated: true)
    }
}
