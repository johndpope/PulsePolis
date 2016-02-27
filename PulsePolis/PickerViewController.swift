
//  PickerViewController.swift
//  PulsePolis
//
//  Created by IMAC  on 06.02.16.
//  Copyright © 2016 IMAC . All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import SwiftyJSON

class PickerViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    
    var cities: [City]?
    
    var subscription: Disposable?
    
    let sourceStringURL = "http://hotfinder.ru/hotjson/cities.php"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        getCities()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func getCities(){
        
        self.cities = APP.i().cities
        
        for(var i = 0; i < self.cities?.count; i++){
            if(APP.i().city?.id! == self.cities![i].id!){
                self.picker.selectRow(i, inComponent: 0, animated: false)
            }
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities?.count ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.cities![row])
        APP.i().city = self.cities![row]
    }
    
    //    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return self.cities![row].city
    //    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        if let _ =
            self.navigationController?.popToRootViewControllerAnimated(true){
                //                APP.i().city = self.cities![self.picker.selectedRowInComponent(0)]
                
        } else {
            //            APP.i().city = self.cities![self.picker.selectedRowInComponent(0)]
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = self.cities![row].city
        //        if(row == picker.selectedRowInComponent(0)){
        //            return NSAttributedString(string: string!, attributes: [NSForegroundColorAttributeName:ColorHelper.defaultColor])
        //        } else {
        //            return NSAttributedString(string: string!, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        //        }
        return NSAttributedString(string: string!, attributes: [NSForegroundColorAttributeName:ColorHelper.defaultColor])
    }
    
}
