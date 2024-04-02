//
//  File.swift
//  LocationApp
//
//  Created by 승재 on 4/2/24.
//

import OHHTTPStubs

final class MockTest{
    func hmm(){
        
    }
    
}


extension URLRequest {
    var ohhttpStubs_httpBody: Data? {
        if let httpBody = self.httpBody {
            return httpBody
        }
        if let httpBodyStream = self.httpBodyStream {
            httpBodyStream.open()
            let bufferSize = 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            var data = Data()
            while httpBodyStream.hasBytesAvailable {
                let readDat = httpBodyStream.read(buffer, maxLength: bufferSize)
                data.append(buffer, count: readDat)
            }
            buffer.deallocate()
            httpBodyStream.close()
            return data
        }
        return nil
    }
}
