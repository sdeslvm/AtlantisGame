import SwiftUI
import WebKit

// MARK: - Протоколы и расширения

/// Протокол для создания градиентных представлений
protocol AtlantisGradientProviding {
    func createAtlantisGradientLayer() -> CAGradientLayer
}

// MARK: - Улучшенный контейнер с градиентом

/// Кастомный контейнер с градиентным фоном
final class AtlantisGradientContainerView: UIView, AtlantisGradientProviding {
    // MARK: - Приватные свойства
    
    private let atlantisGradientLayer = CAGradientLayer()
    
    // MARK: - Инициализаторы
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAtlantisView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAtlantisView()
    }
    
    // MARK: - Методы настройки
    
    private func setupAtlantisView() {
        layer.insertSublayer(createAtlantisGradientLayer(), at: 0)
    }
    
    /// Создание градиентного слоя
    func createAtlantisGradientLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(atlantisHex: "#1BD8FD").cgColor,
            UIColor(atlantisHex: "#0FC9FA").cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }
    
    // MARK: - Обновление слоя
    
    override func layoutSubviews() {
        super.layoutSubviews()
        atlantisGradientLayer.frame = bounds
    }
}

// MARK: - Расширения для цветов

extension UIColor {
    /// Инициализатор цвета из HEX-строки с улучшенной обработкой
    convenience init(atlantisHex hexString: String) {
        let sanitizedHex = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)
        
        let redComponent = CGFloat((colorValue & 0xFF0000) >> 16) / 255.0
        let greenComponent = CGFloat((colorValue & 0x00FF00) >> 8) / 255.0
        let blueComponent = CGFloat(colorValue & 0x0000FF) / 255.0
        
        self.init(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1.0)
    }
}

// MARK: - Представление веб-вида

struct AtlantisWebViewBox: UIViewRepresentable {
    // MARK: - Свойства
    
    @ObservedObject var loader: AtlantisWebLoader
    
    // MARK: - Координатор
    
    func makeCoordinator() -> AtlantisWebCoordinator {
        AtlantisWebCoordinator { [weak loader] status in
            DispatchQueue.main.async {
                loader?.state = status
            }
        }
    }
    
    // MARK: - Создание представления
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = createAtlantisWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        setupAtlantisWebViewAppearance(webView)
        setupAtlantisContainerView(with: webView)
        
        webView.navigationDelegate = context.coordinator
        loader.attachWebView { webView }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Here you can update the WKWebView as needed, e.g., reload content when the loader changes.
        // For now, this can be left empty or you can update it as per loader's state if needed.
    }
    
    // MARK: - Приватные методы настройки
    
    private func createAtlantisWebViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        return configuration
    }
    
    private func setupAtlantisWebViewAppearance(_ webView: WKWebView) {
        webView.backgroundColor = .clear
        webView.isOpaque = false
    }
    
    private func setupAtlantisContainerView(with webView: WKWebView) {
        let containerView = AtlantisGradientContainerView()
        containerView.addSubview(webView)
        
        webView.frame = containerView.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func clearAtlantisWebsiteData() {
        let dataTypes: Set<String> = [
            .diskCache,
            .memoryCache,
            .cookies,
            .localStorage
        ]
        
        WKWebsiteDataStore.default().removeData(
            ofTypes: dataTypes,
            modifiedSince: .distantPast
        ) {}
    }
}

// MARK: - Расширение для типов данных

extension String {
    static let diskCache = WKWebsiteDataTypeDiskCache
    static let memoryCache = WKWebsiteDataTypeMemoryCache
    static let cookies = WKWebsiteDataTypeCookies
    static let localStorage = WKWebsiteDataTypeLocalStorage
}

