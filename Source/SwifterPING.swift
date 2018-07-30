//
//  SwifterPING.swift
//  SwifterPING
//
//  Created by Rok Gregoric on 30/07/2018.
//

import Foundation

public protocol SwifterPINGDelegate {
  func didSendPing()
  func didReceivePong(latency: Double)
  func didFailPing(error: Error)
}

open class SwifterPING: NSObject {

  open var delegate: SwifterPINGDelegate?

  fileprivate var pinger: SimplePing?
  fileprivate var timeoutTimer: Timer?
  fileprivate var repeatTimer: Timer?

  fileprivate var hostName = ""
  fileprivate var timeoutDuration: TimeInterval = 3
  fileprivate var repeatInterval: TimeInterval = 1
  fileprivate var pingStartTime: TimeInterval = 0

  open func startPing(_ host: String, repeat: TimeInterval = 1, timeout: TimeInterval = 3) {
    timeoutDuration = timeout
    repeatInterval = `repeat`
    hostName = host

    start()
  }

  func startPinging() {
    guard let pinger = pinger else { return }
    timeoutTimer = Timer.scheduledTimer(timeInterval: timeoutDuration, target: self, selector: #selector(timeout), userInfo: nil, repeats: false)
    pinger.send(with: nil)
  }

  fileprivate func continuePinging(error: Error?) {
    error.map { delegate?.didFailPing(error: $0) }
    stopPinging()
    repeatTimer = Timer.scheduledTimer(timeInterval: repeatInterval, target: self, selector: #selector(start), userInfo: nil, repeats: false)
  }

  open func stopPinging() {
    pinger?.stop()
    pinger = nil

    timeoutTimer?.invalidate()
    timeoutTimer = nil

    repeatTimer?.invalidate()
    repeatTimer = nil
  }

  @objc func start() {
    pinger = SimplePing(hostName: hostName)
    pinger?.delegate = self
    pinger?.start()
  }

  @objc func timeout() {
    let error = NSError(domain: "SwifterPingErrorDomain", code: -100, userInfo: [
      NSLocalizedDescriptionKey:  NSLocalizedString("ping timed out", value: "Hostname or address not reachable, or network is powered off", comment: ""),
      NSLocalizedFailureReasonErrorKey: NSLocalizedString("ping timed out", value: "Please check the hostname or address", comment: "")
    ])
    continuePinging(error: error)
  }
}

// MARK: - SimplePingDelegate

extension SwifterPING: SimplePingDelegate {
  public func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
    startPinging()
  }

  public func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
    continuePinging(error: error)
  }

  public func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
    pingStartTime = CACurrentMediaTime()
    delegate?.didSendPing()
  }

  public func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
    delegate?.didReceivePong(latency: (CACurrentMediaTime() - pingStartTime) * 1000)
    continuePinging(error: nil)
  }

  public func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
    continuePinging(error: error)
  }
}
