//
//  ChattStore.swift
//  swiftChatter
//
//  Created by Yuer Gao on 9/9/22.
//

import Foundation

final class ChattStore {
    static let shared = ChattStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    @Published private(set) var chatts = [Chatt]()
    private let nFields = Mirror(reflecting: Chatt()).children.count

    private let serverUrl = "https://18.188.225.37/"
    
    func postChatt(_ chatt: Chatt) {
            var geoObj: Data?
           if let geodata = chatt.geodata {
               geoObj = try? JSONSerialization.data(withJSONObject: [geodata.lat, geodata.lon, geodata.loc, geodata.facing, geodata.speed])
           }
           
           let jsonObj = ["username": chatt.username,
                          "message": chatt.message,
                          "geodata": (geoObj == nil) ? nil : String(data: geoObj!, encoding: .utf8)]
           guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
               print("postChatt: jsonData serialization error")
               return
           }
                   
           guard let apiUrl = URL(string: serverUrl+"postmaps/") else {
               print("postChatt: Bad URL")
               return
           }
           
           var request = URLRequest(url: apiUrl)
           request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
           request.httpMethod = "POST"
           request.httpBody = jsonData

           URLSession.shared.dataTask(with: request) { data, response, error in
               guard let _ = data, error == nil else {
                   print("postChatt: NETWORKING ERROR")
                   return
               }
               if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                   print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
                   return
               }
               self.getChatts()
           }.resume()
       }
    
    func getChatts() {
           guard let apiUrl = URL(string: serverUrl+"getmaps/") else {
               print("getChatts: Bad URL")
               return
           }
           
           var request = URLRequest(url: apiUrl)
           request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
           request.httpMethod = "GET"

           URLSession.shared.dataTask(with: request) { data, response, error in
               
               guard let data = data, error == nil else {
                   print("getChatts: NETWORKING ERROR")
                   return
               }
               if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                   print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
                   return
               }
               
               guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                   print("getChatts: failed JSON deserialization")
                   return
               }
               let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
               self.chatts = [Chatt]()
               for chattEntry in chattsReceived {
                   if chattEntry.count == self.nFields {
                   let geoArr = chattEntry[3]?.data(using: .utf8).flatMap {
                                           try? JSONSerialization.jsonObject(with: $0) as? [Any]
                                       }
                   self.chatts.append(Chatt(username: chattEntry[0],
                                            message: chattEntry[1],
                                            timestamp: chattEntry[2],
                                            geodata: geoArr.map {
                                               GeoData(lat: $0[0] as! Double,
                                                       lon: $0[1] as! Double,
                                                       loc: $0[2] as! String,
                                                       facing: $0[3] as! String,
                                                       speed: $0[4] as! String)
                                            }
                   ))
                   } else {
                       print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                   }
               }
               
           }.resume()
       }
}
