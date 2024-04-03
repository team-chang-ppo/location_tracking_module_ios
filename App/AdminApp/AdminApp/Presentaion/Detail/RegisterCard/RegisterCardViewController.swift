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
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var registerButton = UIButton(type: .system)
    private var creditCardImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "creditcard.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var viewModel : RegisterCardViewModel!
    
    private var item = RegisterCardContent.item
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupLayout()
        bind()
    }
    
    private func bind() {
        viewModel.paymentURL
            .receive(on: RunLoop.main)
            .sink { [weak self] urlString in
                DispatchQueue.main.async {
                    let webViewController = KaKaoPayViewController()
                    webViewController.completionHandler = { [weak self] success in
                        if success {
                            self?.titleLabel.text = "카드 등록 성공 !"
                            self?.creditCardImageView.image = UIImage(systemName: "checkmark.circle.fill")
                            self?.descriptionLabel.text = "이제 원하는 APIKEY를 등록할 수 있어요 !"
                            self?.descriptionLabel.isHidden = true
                            self?.registerButton.setTitle("확인", for: .normal)
                            self?.registerButton.addTarget(self, action: #selector(self?.closeView), for: .touchUpInside)
                            
                        } else {
                            self?.creditCardImageView.image = UIImage(systemName: "creditcard.trianglebadge.exclamationmark")
                            self?.titleLabel.text = "카드 등록 실패"
                            self?.descriptionLabel.text = "정기 결제 등록이 실패했습니다. 다시 등록을 해주세요 !"
                        }
                    }
                    webViewController.url = urlString ?? ""
                    self?.present(webViewController, animated: true, completion: nil)
                }
            }
            .store(in: &subscriptions)
    }
    private func setupViews() {
        // 타이틀 설정
        titleLabel.text = item.title
        titleLabel.textAlignment = .center // 중앙 정렬
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        
        // 설명 설정
        descriptionLabel.text = item.description
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0 // 여러 줄 표시 가능하도록
        
        // 버튼 설정
        registerButton.setTitle("카카오 페이로 카드 등록하기", for: .normal)
        registerButton.backgroundColor = .systemBlue // 배경색 설정
        registerButton.setTitleColor(.white, for: .normal) // 글씨 색 설정
        registerButton.layer.cornerRadius = 25 // 캡슐 형태를 만들기 위한 cornerRadius 설정
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium) // 글씨체 및 크기 설정
        registerButton.addTarget(self, action: #selector(didTapped), for: .touchUpInside) // 버튼 액션 추가
        
        // 뷰에 추가
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(registerButton)
        view.addSubview(creditCardImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        // 타이틀 레이아웃
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        // 설명 레이아웃
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // 아이콘 이미지
        NSLayoutConstraint.activate([
            creditCardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creditCardImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            creditCardImageView.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -20),
            creditCardImageView.heightAnchor.constraint(equalToConstant: 100),
            creditCardImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // 버튼 레이아웃
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            
        ])
    }
    
    @objc func didTapped() {
        viewModel.fetchPaymentURL()
    }
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    
}

