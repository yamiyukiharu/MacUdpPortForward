//
//  main.swift
//  UdpPortForward
//
//  Created by Soon Hao Ye  on 18/3/16.
//  Copyright © 2016 Soon Hao Ye . All rights reserved.
//

import Foundation

let LOCAL_MACHINE_PORT = 8888
let EMULATOR_PORT = 5000
let PACKET_SIZE = 100
//let EMULATOR_IP_ADDRESS = "10.0.2.15"
let EMULATOR_IP_ADDRESS = "127.0.0.1"

func getIpAddress()->String {
    let localMachine:NSHost = NSHost.currentHost()
    let localAddresses:[String] = localMachine.addresses
    var ipAddress:String = ""
    for address in localAddresses {
        let arr = Array(address.characters)
        let cmp = Array("192".characters)
        if(arr[0] == cmp[0] && arr[1] == cmp[1] && arr[2] == cmp[2]) {
            ipAddress = address
        }
    }
    return ipAddress
}

func listenToPort(ipAddress: String)->(Bool,[UInt8]?) {
    let listener:UDPServer = UDPServer(addr: ipAddress, port: LOCAL_MACHINE_PORT)
    let (data,_,_) = listener.recv(PACKET_SIZE)
    listener.close()
    if(data == nil) {
        return(false,nil)
    }
    return(true,data)
}

func sendToPort(ipAddress:String, packet:[UInt8])->(Bool,String) {
    let client:UDPClient = UDPClient(addr: ipAddress, port: EMULATOR_PORT)
    let (success,errorMessage) = client.send(data: packet)
    client.close()
    if(!success) {
        return (false,errorMessage)
    }
    return (true,"success")
}

let localMachineIpAddress = "172.19.170.246"//getIpAddress()
while(true) {
    let (success,packet) = listenToPort(localMachineIpAddress)
    if(success) {
        sendToPort(EMULATOR_IP_ADDRESS, packet: packet!)
    }
}