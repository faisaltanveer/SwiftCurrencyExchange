
import UIKit
import CoreData

class CurrencyConversionViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var selectCurrencyButton:UIButton!
    @IBOutlet weak var currencyConversionCollectionView:UICollectionView!
    
    var managedObjectContext: NSManagedObjectContext!
    var viewModel: CurrencyConversionViewModel!
    
    let currencyPicker = UIPickerView()
    let toolbarForPicker = UIToolbar()
    var sourceCurrencyIndex = 0
    private var refreshTimer: Timer?
    
    //MARK: View loading life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: Custom methods
    func initialSetup(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        viewModel = CurrencyConversionViewModel(managedObjectContext: managedObjectContext)
        refreshTimer = Timer.scheduledTimer(timeInterval: 30 * 60, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        setup_controls()
    }
    func setup_controls() {
        self.configureCurrencyPicker()
        self.configureToolbarPicker()
        self.updateCurrencyData()
    }
    @objc private func refreshData() {
        viewModel.fetchExchangeRates()
    }
    func updateCurrencyData() {
        viewModel.updateData = {
            self.currencyConversionCollectionView.reloadData()
            self.currencyPicker.reloadAllComponents()
        }
    }
    //MARK: Buttons action methods
    
    @objc func pickerDoneButtonAction() {
        currencyPicker.isHidden = true
        toolbarForPicker.isHidden = true
        currencyConversionCollectionView.isHidden = false
        sourceCurrencyIndex = currencyPicker.selectedRow(inComponent: 0)
        if sourceCurrencyIndex < viewModel.currencyConverter.exchangeRates.count{
            let selectedCurrencyItem = viewModel.currencyConverter.exchangeRates[sourceCurrencyIndex]
            selectCurrencyButton.setTitle(selectedCurrencyItem.currencyCode, for: .normal)
        }
        self.currencyConversionCollectionView.reloadData()
    }
    @IBAction func refreshDataButtonAction(_ sender:UIButton){
        refreshData()
    }
    @IBAction func selectCurrencyButtonAction(_ sender: UIButton) {
        if let amount = amountTextField.text {
            if amount.isEmpty{
                DialogueManager.showInfo(viewController: self, message: "Please enter amount") {}
                return
            }
        }
        toolbarForPicker.isHidden = false
        currencyPicker.isHidden = false
    }
}
extension CurrencyConversionViewController{
    func configureCurrencyPicker() {
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyPicker.backgroundColor = .white
        view.addSubview(currencyPicker)
        currencyPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            currencyPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencyPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currencyPicker.heightAnchor.constraint(equalToConstant: 300)
        ])
        currencyPicker.isHidden = true
    }
}
extension CurrencyConversionViewController{
    func configureToolbarPicker() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerDoneButtonAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarForPicker.items = [flexibleSpace, doneButton]
        //toolbarForPicker.sizeToFit()
        toolbarForPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbarForPicker)
        NSLayoutConstraint.activate([
            toolbarForPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbarForPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarForPicker.bottomAnchor.constraint(equalTo: currencyPicker.topAnchor),
            toolbarForPicker.heightAnchor.constraint(equalToConstant: 44)
        ])
        toolbarForPicker.isHidden = true
    }
}
extension CurrencyConversionViewController:UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.currencyConverter.exchangeRates.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currencyItem = viewModel.currencyConverter.exchangeRates[row]
        return currencyItem.currencyCode
    }
}
extension CurrencyConversionViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currencyConverter.exchangeRates.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currencyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrenyCell", for: indexPath) as! CurrencyConversionCollectionViewCell
        let currencyItem = viewModel.currencyConverter.exchangeRates[indexPath.row]
        currencyCell.configureData(currencyItem: currencyItem, atIndex: indexPath.row, currencyController: self)
        return currencyCell
    }
}
