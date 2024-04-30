//
//  ToasterPopupViewController.swift
//  AdminApp
//
//  Created by 승재 on 4/30/24.
//

import UIKit
import SnapKit
import Then

typealias ButtonAction = (() -> Void)

enum ETAPopupType {
    case Confirmation // 가운데 버튼
    case Cancelable   // 왼쪽 오른쪽 버튼
}

class ETAPopupViewController: UIViewController {
    var mainText: String?
    var subText: String?
    var leftButtonTitle: String = ""
    var rightButtonTitle: String = ""
    var centerButtonTitle: String = ""
    var leftButtonHandler: ButtonAction?
    var rightButtonHandler: ButtonAction?
    var centerButtonHandler: ButtonAction?
    var popupType: ETAPopupType = .Confirmation
    
    private let containerView = UIView().then {
        $0.backgroundColor = .defaultBackgroundColor
        $0.makeRounded(cornerRadius: 12)
        $0.clipsToBounds = true
    }
    
    private let popupStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
        
    }
    
    private let mainLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .label
        $0.numberOfLines = 0
    }
    
    private let subLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .Grey600
        $0.numberOfLines = 0
    }
    
    private let leftButton = UIButton().then {
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.backgroundColor = .defaultCellColor
        $0.makeRounded(cornerRadius: 8)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let rightButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.makeRounded(cornerRadius: 8)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let centerButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.makeRounded(cornerRadius: 8)
        $0.backgroundColor = .systemBlue
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    init(mainText: String?, subText: String?, leftButtonTitle: String, rightButtonTitle: String, leftButtonHandler: ButtonAction?, rightButtonHandler: ButtonAction?) {
        self.mainText = mainText
        self.subText = subText
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonHandler = leftButtonHandler
        self.rightButtonHandler = rightButtonHandler
        self.popupType = .Cancelable
        self.leftButton.setTitle(leftButtonTitle, for: .normal)
        self.rightButton.setTitle(rightButtonTitle, for: .normal)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(mainText: String?, subText: String?, centerButtonTitle: String, centerButtonHandler: ButtonAction?) {
        self.mainText = mainText
        self.subText = subText
        self.centerButtonTitle = centerButtonTitle
        self.centerButtonHandler = centerButtonHandler
        self.popupType = .Confirmation
        self.centerButton.setTitle(centerButtonTitle, for: .normal)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)  // 전체 배경을 반투명 회색으로 설정
        setupHierarchy()
        setupLayout()
        setupContent()
    }
    
    private func setupContent() {
        // Text 설정
        mainLabel.text = mainText
        subLabel.text = subText
        

        // Button actions 설정
        leftButton.addTarget(self, action: #selector(handleLeftButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(handleRightButton), for: .touchUpInside)
        centerButton.addTarget(self, action: #selector(handleCenterButton), for: .touchUpInside)
    }
    
    private func setupHierarchy() {
        view.addSubview(containerView)  // 컨테이너 뷰 추가
        containerView.addSubview(popupStackView)  // 스택 뷰를 컨테이너 뷰 안에 추가
        popupStackView.addArrangedSubview(labelStackView)
        popupStackView.addArrangedSubview(buttonStackView)
        
        if mainText != nil {
            labelStackView.addArrangedSubview(mainLabel)
        }
        if subText != nil {
            labelStackView.addArrangedSubview(subLabel)
        }
        
        switch popupType {
        case .Cancelable:
            [leftButton, rightButton].forEach {
                buttonStackView.addArrangedSubview($0)  // 수정: addSubview -> addArrangedSubview
            }
        case .Confirmation:
            buttonStackView.addArrangedSubview(centerButton)
        }
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalTo(view).inset(40)  // 팝업의 너비를 조절하려면 이 값을 조정
            make.height.equalTo(210)  // 필요에 따라 높이 조절
        }
        
        popupStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)  // 컨테이너 뷰의 내부 여백 설정
        }
        mainLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(12)
            $0.height.equalTo(35)
        }
        subLabel.snp.makeConstraints{
//            $0.top.equalTo(mainLabel).offset(25)
            $0.height.equalTo(110)
        }
        buttonStackView.snp.makeConstraints{
            $0.height.equalTo(35)
        }
        
    }
    @objc private func handleLeftButton() {
        leftButtonHandler?()
        dismiss(animated: true)
    }

    @objc private func handleRightButton() {
        rightButtonHandler?()
        dismiss(animated: true)
    }

    @objc private func handleCenterButton() {
        centerButtonHandler?()
        dismiss(animated: true)
    }
}

extension UIViewController {
    /// 취소 가능한 팝업 표시
    func showPopup(mainText: String?, subText: String?, leftButtonTitle: String, rightButtonTitle: String, leftButtonHandler: (() -> Void)? = nil, rightButtonHandler: (() -> Void)? = nil) {
        let popup = ETAPopupViewController(mainText: mainText, subText: subText, leftButtonTitle: leftButtonTitle, rightButtonTitle: rightButtonTitle, leftButtonHandler: leftButtonHandler, rightButtonHandler: rightButtonHandler)
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true)
    }
    
    /// 확인 버튼만 있는 팝업 표시
    func showConfirmationPopup(mainText: String?, subText: String?, centerButtonTitle: String, centerButtonHandler: (() -> Void)? = nil) {
        let popup = ETAPopupViewController(mainText: mainText, subText: subText, centerButtonTitle: centerButtonTitle, centerButtonHandler: centerButtonHandler)
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true)
    }
}
