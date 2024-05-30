//
//  RegisterCardViewController.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//
import UIKit
import Combine


class RegisterCardViewController: UIViewController {

    private var subscriptions = Set<AnyCancellable>()
    private var titleLabel =
    UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        $0.textAlignment = .center
        $0.text = "정기 결제 카드 등록"
    }
    private var descriptionLabel = UILabel().then{
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = "카카오 페이를 통해 Location Tracking Module을 사용할 수 있는 API KEY를 구매 할 수 있어요 !"
        
    }
    private var registerButton = UIButton(type: .system).then {
        $0.setTitle("카카오 페이로 카드 등록하기", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 25
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
    }
    private let creditCardImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "creditcard.fill")
    }
    
    var viewModel: RegisterCardViewModel!
    var completion: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        setupUI()
        setupLayout()
        bind()
    }
    
    private func bind() {
        viewModel.paymentURL
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] urlString in
                // 성공적으로 URL 문자열을 받았을 때의 처리
                self?.navigateToWebViewController(with: urlString)
            })
            .store(in: &subscriptions)
    }
    
    private func setupUI() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        [titleLabel, descriptionLabel, registerButton, creditCardImageView].forEach(view.addSubview)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        creditCardImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(registerButton.snp.top).offset(-40)
            $0.height.equalTo(100)
            $0.width.equalTo(100)
        }
        
        registerButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
    }
    
    @objc func registerButtonTapped() {
        viewModel.fetchPaymentURL()
    }
    
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    private func navigateToWebViewController(with urlString: String?) {
        guard let urlString = urlString else { return }
        let webViewController = KaKaoPayViewController()
        webViewController.completionHandler = { [weak self] success in
            if success {
                self?.configureForSuccess()
            } else {
                self?.configureForFailure()
            }
        }
        webViewController.url = urlString
        self.present(webViewController, animated: true, completion: nil)
    }
    
    private func configureForSuccess() {
        self.titleLabel.text = "카드 등록 성공 !"
        self.creditCardImageView.image = UIImage(systemName: "checkmark.circle.fill")
        self.descriptionLabel.text = "이제 원하는 APIKEY를 등록할 수 있어요 !"
        self.registerButton.setTitle("확인", for: .normal)
        self.registerButton.addTarget(self, action: #selector(self.closeView), for: .touchUpInside)
        completion?(true)
    }
    
    private func configureForFailure() {
        self.creditCardImageView.image = UIImage(systemName: "creditcard.trianglebadge.exclamationmark")
        self.titleLabel.text = "카드 등록 실패"
        self.descriptionLabel.text = "정기 결제 등록이 실패했습니다. 다시 등록을 해주세요 !"
        self.registerButton.setTitle("확인", for: .normal)
        self.registerButton.addTarget(self, action: #selector(self.closeView), for: .touchUpInside)
        completion?(true)
    }
}
