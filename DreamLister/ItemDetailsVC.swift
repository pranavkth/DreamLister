//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by pranav gupta on 07/02/17.
//  Copyright © 2017 Pranav gupta. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField :  CustomTextField!
    @IBOutlet weak var price : CustomTextField!
    @IBOutlet weak var details : CustomTextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    // function which is called when load image is pressed.
    
    @IBAction func loadImagePressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func DeleteBtnPressed(_ sender: Any) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
            _ = navigationController?.popViewController(animated: true)
        }
            
        
    }
    @IBAction func SaveBtnPressed(_ sender: Any) {
        
        var item : Item!
        
        // since picture is an entity in itself so first it is created as an nsmanaged object and then assigned to the item relationship.
        
        if itemToEdit == nil {
            item = Item(context: context)
        }
        else{
            item = itemToEdit
        }
        
        let picture = Image(context: context)
        picture.image = imageView.image
        item.toImage = picture
        
        if let title = titleField.text{
            item.title = title
        }
        //making the price as string and finally double value.
        if let price = price.text{
            item.price = (price as NSString).doubleValue
        }
        if let details = details.text{
            item.details = details
        }
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
        
     }
    
    var stores = [Store]()
    var itemToEdit : Item?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // any code setup must work only when the storyboard is connected to it.
        //Code to change the title of the back button in navigation bar while coming from different screen.
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        titleField.delegate = self
        price.delegate = self
        details.delegate = self
        storePicker.dataSource = self
        storePicker.delegate = self
        imagePicker.delegate = self
    
        getStore()
        
        if itemToEdit != nil{
            loadItemData()
        }
        
        /*let store1 = Store(context: context)
        store1.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Amazon"
        let store3 = Store(context:context)
        store3.name  = "Flipkart"
        let store4 = Store(context: context)
        store4.name = "Snapdeal"
        let store5 = Store(context: context)
        store5.name = "Myntra"
        let store6 = Store(context:context)
        store6.name = "Jabong"
        
        ad.saveContext()*/
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // function to get rid of keyboard when it is not longer required.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return  store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //todo
    }
    
    func getStore(){
        
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }
        catch{
            //handle the error.
        }
        
    }
    
    func loadItemData(){
        
        if let item = itemToEdit {
            titleField.text = item.title
            price.text = String(item.price)
            details.text = item.details
            imageView.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore{
                var index = 0
                repeat{
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while index < stores.count
            
            }
        }
    }
    
    
    
    

}
