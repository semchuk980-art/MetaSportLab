import SwiftUI
import WebKit

final class MetaSportLabbekijkmodel: NSObject, ObservableObject {
    @AppStorage("PulseMotionData") var mninfMetaSportLab = ""
    @AppStorage("staat") var staat: StanInformacii = .inactive {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
        
    @Published var wsMetaSportLab = true {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    @Published var whyMetaSportLab: WKWebView {
        didSet {
            upsubMetaSportLab()
        }
    }
    
    var truMetaSportLab: Bool { return staat == .zavantajeno }
    var ldMetaSportLab: Bool {
        if wsMetaSportLab { return true }
        return (staat == .zavantajeno || staat == .noContent) == false
    }
    
    private var subdtMetaSportLab: [NSKeyValueObservation] = []
    private var mndtMetaSportLab: DispatchWorkItem?

    override init() {
        self.whyMetaSportLab = InfoConfigurationView()
        super.init()
        upsubMetaSportLab()
        DispatchQueue.main.async {
            self.whyMetaSportLab.navigationDelegate = self
            self.whyMetaSportLab.uiDelegate = self
        }
    }
    
    private func upsubMetaSportLab() {
        func pidpusnik<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
            whyMetaSportLab.observe(keyPath, options: [.prior]) { _, change in
                if change.isPrior {
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }
            }
        }
        cnclMetaSportLab()
        subdtMetaSportLab = [
            pidpusnik(for: \.canGoBack),
            pidpusnik(for: \.canGoForward)
        ]
    }
    
    private func cnclMetaSportLab() {
        subdtMetaSportLab.forEach { $0.invalidate() }
        subdtMetaSportLab.removeAll()
    }
    
    func ldsbMetaSportLab(info initialInfo: String) {
        switch staat {
        case .inactive:
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.mninfMetaSportLab = initialInfo
                let request = URLRequest(url: URL(string: initialInfo)!, cachePolicy: .returnCacheDataElseLoad)
                self.staat = .saved
                self.whyMetaSportLab.load(request)
            }
        case .zavantajeno:
            ldagMetaSportLab()
        default: break
        }
    }
    
    func ldagMetaSportLab() {
        guard staat == .zavantajeno else { return }
        let request = URLRequest(url: URL(string: mninfMetaSportLab)!, cachePolicy: .returnCacheDataElseLoad)
        DispatchQueue.main.async { [weak self] in self?.whyMetaSportLab.load(request) }
    }
    
    func cllctdtMetaSportLab() { staat = .noContent }
    func backMetaSportLab() { whyMetaSportLab.goBack() }
    func worvMetaSportLab() { whyMetaSportLab.goForward() }
    
    private func cchLdMetaSportLab() {
        staat = .zavantajeno
        mndtMetaSportLab?.cancel()
        mndtMetaSportLab = nil
        AppDelegate.orientationLock = .portrait
    }
}

extension MetaSportLabbekijkmodel: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if staat == .saved, navigationAction.navigationType == .other, let redirectedUrl = navigationAction.request.url, redirectedUrl != URL(string: mninfMetaSportLab) {
            cchLdMetaSportLab()
        }
        if let data = navigationAction.request.url {
            if data.hasDirectoryPath {
                if MetaSportLabverpakt.base == "" {
                    MetaSportLabverpakt.base = data.absoluteString
                }
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mninfMetaSportLab = webView.url!.absoluteString
        guard staat == .saved else { return }
        let item = DispatchWorkItem { [weak self] in self?.cllctdtMetaSportLab() }
        mndtMetaSportLab?.cancel()
        mndtMetaSportLab = item
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: item)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil
    }
}

enum StanInformacii: String {
    case inactive
    case saved
    case zavantajeno
    case noContent
}

class InfoConfigurationView: WKWebView {
    convenience init() {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        self.init(frame: .zero, configuration: configuration)
    }
}
