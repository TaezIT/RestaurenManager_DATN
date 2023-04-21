//
//  StaffManagerViewController.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 19/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddStaffManagerViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: TextField!
    @IBOutlet weak var txtStaffName: UITextField!
    @IBOutlet weak var swStaffAuthority: UISegmentedControl!
    @IBOutlet weak var swStaffAuthority2: UISegmentedControl!
    @IBOutlet weak var txtStaffPhone: UITextField!
    @IBOutlet weak var txtStaffAddress: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    
    weak var delegate: ManagerDataViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEndEditingTapGuesture()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.fetchData()
    }
    
    @IBAction func swChangedValue(_ sender: UISegmentedControl) {
        if sender == swStaffAuthority {
            swStaffAuthority2.selectedSegmentIndex = -1
        } else {
            swStaffAuthority.selectedSegmentIndex = -1
        }
    }
    
    @IBAction func btnConfirmWasTapped(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        let staffName = txtStaffName.text ?? ""
        let password = txtPassword.text ?? ""
        let rePassword = txtRePassword.text ?? ""
        let staffPhone = txtStaffPhone.text ?? ""
        let staffAddress = txtStaffAddress.text ?? ""
        var author: Int? = nil
        
        if txtEmail.text?.isEmpty == true {
            self.showAlert(title: "Vui lòng nhập Email đăng nhập", message: "") { [weak self] in
                self?.txtEmail.becomeFirstResponder()
            }
            return
        }
        
        if txtEmail.text?.isValidEmail() == false {
            self.showAlert(title: "Email bạn nhập không hợp lệ", message: "") { [weak self] in
                self?.txtEmail.becomeFirstResponder()
            }
            return
        }
        
        if txtPassword.text?.isEmpty == true {
            self.showAlert(title: "Vui lòng nhập mật khẩu đăng nhập", message: "") { [weak self] in
                self?.txtPassword.becomeFirstResponder()
            }
            return
        }
        
    
        
        if password != rePassword {
            self.showAlert(title: "Mật khẩu nhập lại không đúng", message: "") { [weak self] in
                self?.txtRePassword.becomeFirstResponder()
            }
            return
        }
        
        if txtPassword.text?.isValidPassword() == false || txtRePassword.text?.isValidPassword() == false {
            self.showAlert(title: "Mật khẩu phải có 8-20 kí tự và không được chứa các kí tự đặc biệt ", message: "") { [weak self] in
                self?.txtPassword.becomeFirstResponder()
            }
            return
        }
        
        if txtStaffName.text?.isEmpty == true {
            self.showAlert(title: "Vui lòng nhập tên nhân viên", message: "") { [weak self] in
                self?.txtStaffName.becomeFirstResponder()
            }
            return
        }
     
        
        if txtStaffPhone.text?.isEmpty == true {
            self.showAlert(title: "Vui lòng nhập số điện thoại nhân viên", message: "") { [weak self] in
                self?.txtStaffPhone.becomeFirstResponder()
            }
            return
        }
        
        if PresentHandler.isPhoneValid(self.txtStaffPhone.text) == false {
            self.showAlert(title: "Số điện thoại nhân viên không hợp lệ", message: "") { [weak self] in
                self?.txtStaffPhone.becomeFirstResponder()
            }
            return
        }
        
        if txtStaffAddress.text?.isEmpty == true {
            self.showAlert(title: "Vui lòng nhập địa chỉ nhân viên", message: "") { [weak self] in
                self?.txtStaffAddress.becomeFirstResponder()
            }
            return
        }
        
        switch swStaffAuthority.selectedSegmentIndex {
        case 0:
            author = 3
        case 1:
            author = 2
        case 2:
            author = 4
        default: break
        }
        
        switch swStaffAuthority2.selectedSegmentIndex {
        case 0:
            author = 5
        case 1:
            author = 1
        default: break
        }
        
        if author == nil {
            self.showAlert(title: "Vui lòng chọn quyền của nhân viên", message: "")
            return
        }
        
        let originalUser = Auth.auth().currentUser
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { [weak self] (data, error) in
            if let uid = data?.user.uid {
                db.collection("NhanVien").document(uid).setData(["daxoa": 0, "diachi": staffAddress, "email": self!.txtEmail.text!, "idnhanvien": uid, "idtaikhoandangnhap": uid, "quyen": author!, "sodienthoai": staffPhone, "tennhanvien": staffName]) {[weak self] error in
                    
                    if error == nil {
                        if let originalUser = originalUser {
                            Auth.auth().updateCurrentUser(originalUser, completion: nil)
                        }
                        
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
        
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnBackWasTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
