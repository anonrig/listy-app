
import Foundation
import FBSDKCoreKit

enum HTTPRequestAuthType {
    case HTTPBasicAuth
    case HTTPTokenAuth
    case FBTokenAuth
}

enum HTTPRequestContentType {
    case HTTPJsonContent
    case HTTPMultipartContent
}

struct HTTPHelper {
    static let BASE_URL = "http://127.0.0.1:3001"
    
    func buildRequest(path: String!, method: String, authType: HTTPRequestAuthType,
        requestContentType: HTTPRequestContentType = HTTPRequestContentType.HTTPJsonContent, requestBoundary:NSString = "") -> NSMutableURLRequest {
            // 1. Create the request URL from path
            let requestURL = NSURL(string: "\(HTTPHelper.BASE_URL)/\(path)")
            var request = NSMutableURLRequest(URL: requestURL!)
            
            // Set HTTP request method and Content-Type
            request.HTTPMethod = method
            
            // 2. Set the correct Content-Type for the HTTP Request. This will be multipart/form-data for photo upload request and application/json for other requests in this app
            switch requestContentType {
            case .HTTPJsonContent:
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            case .HTTPMultipartContent:
                let contentType = NSString(format: "multipart/form-data; boundary=%@", requestBoundary)
                request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            }
            
            // 3. Set the correct Authorization header.
            switch authType {
            case .HTTPTokenAuth:
                // Retreieve Auth_Token from Keychain
                var userToken : NSString? = KeychainAccess.passwordForAccount("jwt-token", service: "KeyChainService")
                if userToken == nil {
                    userToken = ""
                }
                
                // Set Authorization header
                request.addValue("token \(userToken!)", forHTTPHeaderField: "Authorization")
            case .FBTokenAuth:
                //Retreive FB Auth Token
                var fbToken : String = FBSDKAccessToken.currentAccessToken().tokenString
                // Set Authorization header
                request.addValue("Token token=\(fbToken)", forHTTPHeaderField: "Authorization")
            default:
                println("default");
            }
            
            return request
    }
    
    func sendRequest(request: NSURLRequest, completion:(NSData!, NSError!) -> Void) -> () {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(data, error)
                })
                
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let httpResponse = response as! NSHTTPURLResponse
                
                println(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    completion(data, nil)
                } else {
                    var jsonerror:NSError?
                    
                    if let errorDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error:&jsonerror) as? NSDictionary {
                        let responseError : NSError = NSError(domain: "HTTPHelperError", code: httpResponse.statusCode, userInfo: errorDict as? [NSObject : AnyObject])
                        completion(data, responseError)
                    }
                }
            });
        }
        
        task.resume()
    }
    func getErrorMessage(error: NSError) -> NSString {
        var errorMessage : NSString
        
        if error.domain == "HTTPHelperError" {
            let userInfo = error.userInfo as NSDictionary!
            errorMessage = userInfo.valueForKey("message") as! NSString
        } else {
            errorMessage = error.description
        }
        
        return errorMessage
    }
}