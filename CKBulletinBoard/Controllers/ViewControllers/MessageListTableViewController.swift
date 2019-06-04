//
//  MessageListTableViewController.swift
//  CKBulletinBoard
//
//  Created by Kaden Hendrickson on 6/3/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class MessageListTableViewController: UITableViewController {

  
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MessageController.shared.fetchMessages { (success) in
            if success == true {
                DispatchQueue.main.async {
                   self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let messageText = messageTextField.text else {return}
        MessageController.shared.createMessage(text: messageText, timestamp: Date())
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.shared.messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)

        let message = MessageController.shared.messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: message.timestamp, dateStyle: .medium, timeStyle: .short)
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let message = MessageController.shared.messages[indexPath.row]
            MessageController.shared.removeMessage(message: message) { (success) in
                if success {
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
