import UIKit
import SnapKit


enum ETAToggleButtonState {
    case Enabled
    case Disabled
}

final class ETAToggleButton: UIButton {
    convenience init(type: ETAToggleButtonState, text: String = "") {
        self.init(frame: .zero)
        configure(type: type, text: text)
    }
    
    override var isEnabled: Bool {
        didSet {
            updateButtonState()
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateButtonState(){
        if isEnabled {
            self.backgroundColor = .Main
            self.setTitleColor(.white, for: .normal)
        } else {
            self.backgroundColor = .Grey300
            self.setTitleColor(.Grey600, for: .normal)
        }
    }
    
    private func configure(type: ETAToggleButtonState, text: String) {
        self.setTitle(text, for: .normal)
        self.layer.cornerRadius = 18
        self.titleLabel?.font = .pretendard(.SemiBold, size: 13)
        
        switch type {
        case .Enabled:
            self.backgroundColor = .Main
            self.setTitleColor(.white, for: .normal)
        case .Disabled:
            self.backgroundColor = .Grey300
            self.setTitleColor(.Grey600, for: .normal)
            self.isEnabled = false
        }
        self.snp.makeConstraints {
            $0.width.equalTo(51)
            $0.height.equalTo(31)
        }
    }
}
