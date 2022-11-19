//
//  MainViewController.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//

import UIKit

class MainViewController: UIViewController {

    private lazy var button: UIButton = {
        let button = UIButton()
        
        button.setTitle("GO TO ROUTE VIEW BUTTON", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutConfigure()
        componentConfigure()
    }
    
    func layoutConfigure() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 300),
            button.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func componentConfigure() {
        button.addTarget(self, action: #selector(goToRouteViewButtonClicked), for: .touchUpInside)
    }
}

extension MainViewController {
    @objc func goToRouteViewButtonClicked() {
        navigationController?.pushViewController(RouteViewController(), animated: true)
    }
}
