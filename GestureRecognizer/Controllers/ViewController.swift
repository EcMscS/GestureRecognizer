//
//  ViewController.swift
//  GestureRecognizer
//
//  Created by Jeffrey Lai on 11/12/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var trashImageView: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var fileViewOrigin:CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        addPanGesture(view: fileImageView)
    }

    func initialSetup() {
        refreshButton.isHidden = true
        fileViewOrigin = fileImageView.frame.origin
        view.bringSubviewToFront(fileImageView)
    }
    
    func addPanGesture(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let fileView = sender.view!
        
        switch sender.state {
        case .began, .changed:
            moveViewWithPan(view: fileView, sender: sender)
        case .ended:
            if fileView.frame.intersects(trashImageView.frame) {
                deleteView(view: fileView)
            } else {
                returnViewToOrigin(view: fileView)
            }
        default:
            break
        }
    }
    
    func moveViewWithPan(view: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func returnViewToOrigin(view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.fileImageView.frame.origin = self.fileViewOrigin
        }, completion: nil)
    }
    
    func deleteView(view: UIView) {
        UIView.animate(withDuration: 1.0, animations: {
            self.fileImageView.alpha = 0.0
        }) { _ in
            self.refreshButton.isHidden = false
        }
    }
    
    func resetFileImage() {
        fileImageView.frame.origin = fileViewOrigin
        fileImageView.alpha = 1.0
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        refreshButton.isHidden = true
        resetFileImage()
    }
    
}

