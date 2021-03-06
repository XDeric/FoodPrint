//
//  FoodDetailsVC.swift
//  foodprint-hackathon-app
//
//  Created by Sunni Tang on 12/18/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class FoodDetailsVC: UIViewController {
    
    //MARK: - Properties
    
    lazy var imageOutlet: UIImageView = {
        let image = UIImageView()
        //image.frame = CGRect(x: 80, y: 100, width: 250, height: 250)
        image.image = #imageLiteral(resourceName: "kissclipart-green-carbon-footprint-png-clipart-ecological-foot-38f626cbaf4ff037")
        return image
    }()
    
    lazy var foodNameLabel: UILabel = {
        let label = UILabel()
        //label.frame = CGRect(x: 0, y: 425, width: 420, height: 40)
        label.textAlignment = .center
        label.text = "Name: "
        label.backgroundColor = .red
        return label
    }()
    
    lazy var caloriesPerServingLabel: UILabel = {
        let label = UILabel()
        //label.frame = CGRect(x: 0, y: 500, width: 420, height: 40)
        label.text = "Calories: "
        label.textAlignment = .center
//        label.backgroundColor = .blue
        return label
    }()
    
    lazy var servingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Servings: "
        label.textAlignment = .left
//        label.backgroundColor = .blue
        return label
    }()
    
    lazy var servingsTextField: UITextField = {
        let textField = UITextField()
        //textField.frame = CGRect(x: 175, y: 575, width: 250, height: 40)
        textField.placeholder = "Enter a number"
        textField.delegate = self
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var totalCaloriesLabel: UILabel = {
        let label = UILabel()
        //label.frame = CGRect(x: 0, y: 650, width: 420, height: 40)
        label.textAlignment = .center
        label.text = "Total Calories: "
        label.backgroundColor = .blue

        return label
    }()
    
    lazy var totalEmissionsLabel: UILabel = {
          let label = UILabel()
          //label.frame = CGRect(x: 0, y: 725, width: 420, height: 40)
          label.textAlignment = .center
          label.text = "Total Emission: "
          label.backgroundColor = .blue

          return label
      }()

    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        //button.frame = CGRect(x: 180, y: 800, width: 50, height: 50)
        return button
    }()
    
    var currentUser = try? AppUserPersistenceHelper.manager.getUser().last
    
    var totalAmount: String = "" {
        didSet{
            setText(amount: Double(totalAmount) ?? 1)
        }
    }
    
    //MARK: Foods
    var foodsDetail: Food!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setText(amount: Double(totalAmount) ?? 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.backgroundColor = .lightGray
        setupConstraints()
    }
    
    @objc func addButtonPressed() {
        do {
            try AppUserPersistenceHelper.manager.updateUserFoodHistory(user: currentUser!, food: foodsDetail)
        } catch {
            print(error)
        }
        
    
        
         self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private Methods
    
    private func setText(amount: Double ){
        foodNameLabel.text = "Name: \(foodsDetail.name)"
        caloriesPerServingLabel.text = "Calories: \(foodsDetail.calories * Int(amount))"
        servingsLabel.text = "Servings: \(foodsDetail.servings ?? 1)"
        totalCaloriesLabel.text = "Total Calories: \(foodsDetail.calories * Int(amount))"
        totalEmissionsLabel.text = "Total Emission: \(foodsDetail.carbonEmissionsGramsPerServing * amount)"
    }
    
    private func addSubViews() {
        view.backgroundColor = .white
        view.addSubview(imageOutlet)
        view.addSubview(foodNameLabel)
        view.addSubview(caloriesPerServingLabel)
        view.addSubview(servingsLabel)
        view.addSubview(servingsTextField)
        view.addSubview(totalCaloriesLabel)
        view.addSubview(totalEmissionsLabel)
        view.addSubview(addButton)
    }
    
    private func setupConstraints(){
        let stackView = UIStackView(arrangedSubviews: [foodNameLabel,caloriesPerServingLabel,servingsTextField ,servingsLabel,totalCaloriesLabel,totalEmissionsLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        imageOutlet.translatesAutoresizingMaskIntoConstraints = false
        foodNameLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesPerServingLabel.translatesAutoresizingMaskIntoConstraints = false
        servingsLabel.translatesAutoresizingMaskIntoConstraints = false
        servingsTextField.translatesAutoresizingMaskIntoConstraints = false
        totalCaloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        totalEmissionsLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            imageOutlet.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageOutlet.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:  0.5),
            imageOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageOutlet.heightAnchor.constraint(equalTo: imageOutlet.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: imageOutlet.bottomAnchor, constant: 15),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 300),
            
            addButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 55)
            
        ])
    }
}

//MARK: - Extensions

extension FoodDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.totalAmount = textField.text ?? "1"
        //update UI Code
        return true
    }

}
