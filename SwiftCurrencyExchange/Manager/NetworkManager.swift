
import Foundation
import MBProgressHUD
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    typealias methodHandler = (_ response:[String:Any]) -> ()
    
    func sendDataOnNetworkWithHeaders(apiName:String, parameters:[String:Any], headers:HTTPHeaders, methodType:HTTPMethod, view:UIView, completionHandler: @escaping methodHandler){
        
        MBProgressHUD.showAdded(to: view, animated: true)
        print("url == \(apiName)")
        print("params ==\(parameters)")
        Alamofire.request(apiName, method: methodType, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate(contentType: ["application/json","text/html"]).responseJSON{ response in
            MBProgressHUD.hide(for: view, animated: true)
            switch response.result {
            case .success(let JSON):
                let jsonResponse = JSON as! [String:Any]
                completionHandler(jsonResponse)
            case .failure(let error):
                print("Error in response == \(error).")
                completionHandler([String:Any]())
            }
        }
    }
}

