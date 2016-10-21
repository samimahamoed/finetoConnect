//
//  Data+TypeConversion.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 21/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import Foundation


extension Data {
    var u8:UInt8 {
        assert(self.count >= 1)
        var data:UInt8 = 0x00
        self.copyBytes(to: &data, count: 1)
        return data
    }
    
    var u16:UInt16 {
        let capacity = self.count/MemoryLayout<UInt16>.size
        
        var bytes = Array(repeating: 0 as UInt8, count:self.count)
        self.copyBytes(to: &bytes, count:self.count)
        let pointer = UnsafeMutablePointer<UInt8>(mutating: bytes)
        
        let uint16ptr = pointer.withMemoryRebound(to: UInt16.self, capacity: Int(capacity)) {
            UnsafeBufferPointer(start: $0, count: Int(capacity))
        }
        
        return (uint16ptr.baseAddress?.pointee)!
    }
    
    var u32:UInt32 {
        let capacity = self.count/MemoryLayout<UInt32>.size
        
        var bytes = Array(repeating: 0 as UInt8, count:self.count)
        self.copyBytes(to: &bytes, count:self.count)
        let pointer = UnsafeMutablePointer<UInt8>(mutating: bytes)
        
        
        
        let uint32ptr = pointer.withMemoryRebound(to: UInt32.self, capacity: Int(capacity)) {
            UnsafeBufferPointer(start: $0, count: Int(capacity))
        }
        
        return (uint32ptr.baseAddress?.pointee)!
    }
    
    
    
    
    var u64:UInt64 {
        let capacity = self.count/MemoryLayout<UInt64>.size
        
        var bytes = Array(repeating: 0 as UInt8, count:self.count)
        self.copyBytes(to: &bytes, count:self.count)
        let pointer = UnsafeMutablePointer<UInt8>(mutating: bytes)
        
        
        
        let uint64ptr = pointer.withMemoryRebound(to: UInt64.self, capacity: Int(capacity)) {
            UnsafeBufferPointer(start: $0, count: Int(capacity))
        }
        
        return (uint64ptr.baseAddress?.pointee)!
    }
    
    func rowDataToString() -> String {
        
        var bytes = Array(repeating: 0 as UInt8, count:self.count)
        self.copyBytes(to: &bytes, count:self.count)
        
        var str = "0x"
        for byte in bytes {
            str += String(format:"%02hhx", byte)
        }

        return str
    }
    
    
    var u32_BE:UInt32 {
        var bytes = Array(repeating: 0 as UInt8, count:self.count)
        self.copyBytes(to: &bytes, count:self.count)
        let data = bytes.map { UInt32($0) }
        let data32:UInt32 = data[0]<<24 + data[1]<<16 + data[2]<<8 + data[3]
        return data32
    }
    
    var u32_LE:UInt32 {
        var bytes = Array(repeating: 0 as UInt8, count:self.count)
        self.copyBytes(to: &bytes, count:self.count)
        let data = bytes.map { UInt32($0) }
        let data32:UInt32 =  data[3]<<24 + data[2]<<16 + data[1]<<8 + data[0]
        
        return data32
    }
    
    var u8_bytes:[UInt8] { //just return the byte array
        var bytes = Array(repeating: 0 as UInt8, count:self.count)
        self.copyBytes(to: &bytes, count: self.count)
        return bytes
    }
    
    
}
