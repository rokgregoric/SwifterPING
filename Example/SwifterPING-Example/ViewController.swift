//
//  ViewController.swift
//  SwifterPING-Example
//
//  Created by Rok Gregoric on 30/07/2018.
//  Copyright © 2018 RG. All rights reserved.
//

import UIKit
import SwifterPING

class ViewController: UIViewController {
  @IBOutlet weak var hostField: UITextField!

  var ping: SwifterPING?

  @IBAction func startTapped() {
    stopTapped()

    ping = SwifterPING()
    ping?.delegate = self
    ping?.startPing(hostField.text!, timeout: 3)
  }

  @IBAction func stopTapped() {
    ping?.stopPinging()
    ping = nil
  }

  var time: TimeInterval = 0
}

// MARK: - SwifterPINGDelegate

extension ViewController: SwifterPINGDelegate {
  func didSendPing() {
    print("Sent Ping")
  }

  func didReceivePong(latency: TimeInterval) {
    print("Received Pong", String(format: "%0.3f ms", latency))
  }

  func didFailPing(error: Error) {
    print("Ping failed", error)
  }
}

