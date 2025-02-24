//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    var message:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        to hide the back button
        navigationItem.hidesBackButton = true
        title = "⚡️FlashChat"
        tableView.dataSource = self
        
        //        first step to use custome design file
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { QuerySnapshot, error in
                
                self.message = []
                
                if let e = error{
                    print("Issue retriving data from fireStore \(e)")
                }else{
                    if let snapshotDocument = QuerySnapshot?.documents{
                        for doc in snapshotDocument{
                            let data = doc.data()
                            if let messagesender = data[K.FStore.senderField] as? String,let messageBody = data[K.FStore.bodyField] as? String{
                                let newMessage = Message(sender: messagesender, body: messageBody)
                                self.message.append(newMessage)
                                
//                                dispatch is used so the changes that are happen in the ""main thread""
                                DispatchQueue.main.async{
                                    self.tableView.reloadData()
//                                    for scrolling the table view to the bottom message.
                                    let indexPath = IndexPath(row:self.message.count-1,section:0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            
            db.collection(K.FStore.collectionName).addDocument(data:[
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
                
            ]) { error in
                if let e=error{
                    print("There was an issue saving data to firestor,\(e)")
                }else{
                    
//                    dispatch is used so the changes that are happen in the ""main thread""
                    DispatchQueue.main.async{
                        self.messageTextfield.text = ""
                    }
                    print("Successfully saved data.")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
//            rootview controller here is welcome page.
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = message[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier:K.cellIdentifier, for: indexPath) as! MessageCell
        cell.lable.text = message.body
        
//        this is message from the current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.lable.textColor = UIColor(named: K.BrandColors.purple)
            
        }
       
//        this is message from the other user
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.lable.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
    
    
}
