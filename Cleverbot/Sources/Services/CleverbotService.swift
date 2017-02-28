//
//  CleverbotService.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Alamofire
import ObjectMapper
import RxSwift

protocol CleverbotServiceType {
  func getReply(text: String, cs: String?) -> Observable<IncomingMessage>
}

final class CleverbotService: BaseService, CleverbotServiceType {

  /// Sends the message and returns the observable of received message.
  ///
  /// - parameter text: Message to send
  /// - parameter cs: Cleverbot state. Send the `cs` property of the last received message.
  ///
  /// - seealso: https://www.cleverbot.com/api/howto/
  func getReply(text: String, cs: String?) -> Observable<IncomingMessage> {
    let urlString = "https://www.cleverbot.com/getreply"
    let apiKey = Configuration.apiKey
    var parameters: [String: Any] = [
      "key": apiKey,
      "input": text,
    ]
    if let cs = cs {
      parameters["cs"] = cs
    }
    return Observable.create { observer in
      let request = Alamofire.request(urlString, parameters: parameters)
        .responseString { response in
          switch response.result {
          case .success(let jsonString):
            do {
              let incomingMessage = try Mapper<IncomingMessage>().map(JSONString: jsonString)
              observer.onNext(incomingMessage)
              observer.onCompleted()
            } catch (let error) {
              observer.onError(error)
            }
          case .failure(let error):
            observer.onError(error)
          }
        }
      return Disposables.create {
        request.cancel()
      }
    }
  }

}
