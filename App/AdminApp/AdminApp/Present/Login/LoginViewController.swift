import UIKit
import Combine
import SnapKit
import Then

class LoginViewController: UIViewController {
    private let networkService = NetworkService(configuration: .default)
    private var subscriptions = Set<AnyCancellable>()
    private lazy var KaKaoLoginBtn = UIButton().then {
        $0.makeRounded(cornerRadius: 6)
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = UIColor(hexCode: "#FAE100")
        config.title = "카카오로 로그인하기"
        config.baseForegroundColor = .black
        if let image = UIImage(named: "kakao_mark") {
            let resizedImage = image.resizeImage(image: image, targetSize: CGSize(width: 45, height: 45))
            config.image = resizedImage
        }
        config.imagePadding = 10
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        $0.configuration = config
    }
    
    private lazy var GitHubLoginBtn = UIButton().then {
        $0.makeRounded(cornerRadius: 6)
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .label
        config.title = "GitHub로 로그인하기"
        config.baseForegroundColor = .whiteBlackBackgroundColor
        if let image = UIImage(named: "github_mark") {
            let resizedImage = image.resizeImage(image: image, targetSize: CGSize(width: 40, height: 40))
            config.image = resizedImage
        }
        config.imagePadding = 10
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        $0.configuration = config
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "편리한 위치 추적 API"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .label
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "Location Tracking\nModule"
        $0.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        $0.textColor = .label
        $0.textAlignment = .left
        $0.numberOfLines = 2
    }
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "location.circle")
        $0.tintColor = .label
        $0.contentMode = .scaleAspectFit
    }
    
    private var symbolTimer: Timer?
    private let symbols: [String] = ["location.magnifyingglass", "location.circle", "map.circle", "mappin.and.ellipse", "icloud", "antenna.radiowaves.left.and.right"]
    private var currentSymbolIndex = 0
    
    private let predefinedColors: [[UIColor]] = [
        [.systemRed, .systemBlue, .systemBlue],
        [.label, .systemGray, .systemGray],
        [.LightBlue500, .Green500, .Yellow500],
        [.systemPink, .systemTeal, .systemIndigo]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        setupViews()
        setupConstraints()
        
        KaKaoLoginBtn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        GitHubLoginBtn.addTarget(self, action: #selector(didTapGitHubSignIn), for: .touchUpInside)
        
        startSymbolCycle()
    }
    
    private func setupViews() {
        [subtitleLabel, titleLabel, iconImageView, GitHubLoginBtn, KaKaoLoginBtn].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        GitHubLoginBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.bottom.equalTo(KaKaoLoginBtn.snp.top).offset(-20)
        }
        
        KaKaoLoginBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
    
    @objc private func didTapSignIn() {
        let vc = KaKaoLoginWebViewController()
        vc.completionHandler = { success in
            self.handleSignIn(success: success)
        }
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
    
    @objc private func didTapGitHubSignIn() {
        let vc = GithubLoginWebViewController()
        vc.completionHandler = { success in
            self.handleSignIn(success: success)
        }
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            DispatchQueue.main.async {
                self.showConfirmationPopup(mainText: "로그인 오류", subText: "회원 탈퇴 신청을 했거나\n네트워크 오류가 발생했습니다. 다시 시도해주세요.", centerButtonTitle: "확인") {
                    return
                }
            }
            return
        }
        DispatchQueue.global().async {
            print("1")
            let resource = Resource<UserResponse?>(
                base: Config.serverURL,
                path: "api/members/v1/me",
                params: [:],
                header: [:],
                httpMethod: .GET
            )
            self.networkService.load(resource)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        break
                    }
                } receiveValue: { [weak self] userResponse in
                    guard let user = userResponse?.result else { return }
                    KeychainManager.save(key: "userID", data: String(user.id).data(using:.utf8)!)
                    print(user.id)
                    DispatchQueue.main.async {
                        let homeVC = TabBarController()
                        homeVC.modalPresentationStyle = .fullScreen
                        self?.present(homeVC, animated: true)
                    }
                }
                .store(in: &self.subscriptions)
        }
    }
    
    private func startSymbolCycle() {
        symbolTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateSymbol), userInfo: nil, repeats: true)
    }
    
    @objc private func updateSymbol() {
        currentSymbolIndex = (currentSymbolIndex + 1) % symbols.count
        let nextSymbol = UIImage(systemName: symbols[currentSymbolIndex])!
        let colors = predefinedColors.randomElement() ?? [.black, .darkGray, .lightGray]
        let configuration = UIImage.SymbolConfiguration(paletteColors: colors)
        let configuredImage = nextSymbol.withConfiguration(configuration)
        iconImageView.setSymbolImage(configuredImage, contentTransition: .replace.upUp)
    }
    
    deinit {
        symbolTimer?.invalidate()
    }
}
