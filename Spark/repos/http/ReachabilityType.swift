//
//  ReachabilityType.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation
import SystemConfiguration

/// Interface of a component that can relay information about the network connectivity
public protocol ReachabilityType {
    func isConnectedToNetwork() -> Bool
    func isConnectedToWifi() -> Bool
}


/// Standard implementation of ``ReachabilityType``
public class Reachability {

    public static let shared = Reachability()
    private init() {}
    
    public class func isConnectedToNetwork() -> Bool {
        let flags = getFlags()
        return isConnected(flags: flags)
    }

    private static func isConnected(flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }

    private static func getFlags() -> SCNetworkReachabilityFlags {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)

        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return SCNetworkReachabilityFlags(rawValue: 0)
        }

        return flags
    }
}

extension Reachability: ReachabilityType {
    public func isConnectedToWifi() -> Bool {
        let flags = Reachability.getFlags()
        if flags.contains(.isWWAN) {
            return false
        }

        return Reachability.isConnected(flags: flags)
    }

    public func isConnectedToNetwork() -> Bool {
        Reachability.isConnectedToNetwork()
    }
}

