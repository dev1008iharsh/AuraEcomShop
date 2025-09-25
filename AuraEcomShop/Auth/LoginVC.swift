import UIKit

final class LoginVC: UIViewController {
    
    // MARK: - UI
    
    private let imgIllustration: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "LOGIN_VECTOR"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome Back!"
        lbl.font = FontHelper.roboto(.bold(24))
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let lblSubtitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please log into your existing account"
        lbl.font = FontHelper.roboto(.regular(14))
        lbl.textColor = .white.withAlphaComponent(0.8)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let txtEmail: UITextField = {
        let tf = TextFieldHelper.makeTextField(placeholder: "Enter Your Email", isSecure: false)
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let txtPassword: UITextField = {
        let tf = TextFieldHelper.makeTextField(placeholder: "Enter Your Password", isSecure: true)
        return tf
    }()
    
    private let btnLogin: UIButton = {
        let btn = ButtonHelper.makePillButton(
            title: "Log in",
            style: .success,
            font: FontHelper.roboto(.medium(18)),
            height: 55
        )
        return btn
    }()
    
    private let btnRegister: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = FontHelper.roboto(.medium(18))
        btn.layer.cornerRadius = 12
        btn.layer.masksToBounds = true
        
        // Gradient background
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemPink.cgColor,
            UIColor.systemOrange.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 12
        gradient.frame = CGRect(x: 0, y: 0, width: 300, height: 50) // temporary frame
        
        btn.layer.insertSublayer(gradient, at: 0)
        
        // Shadow
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 0, height: 3)
        btn.layer.shadowRadius = 4
        
        btn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        return btn
    }()
    
    private let lblNewUser: UILabel = {
        let lbl = UILabel()
        lbl.text = "New here?"
        lbl.font = FontHelper.roboto(.regular(14))
        lbl.textColor = .white.withAlphaComponent(0.8)
        return lbl
    }()
    
    private lazy var stackRegister: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lblNewUser, btnRegister])
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupLayout()
        btnLogin.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        btnRegister.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }
    
    @objc private func didTapRegister() {
        let signupVC = SignupVC()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = btnRegister.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = btnRegister.bounds
        }
    }
    
    // MARK: - UI Setup
    
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemIndigo.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupLayout() {
        [imgIllustration, lblTitle, lblSubtitle, txtEmail, txtPassword, btnLogin, btnRegister].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imgIllustration.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imgIllustration.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgIllustration.heightAnchor.constraint(equalToConstant: 180),
            imgIllustration.widthAnchor.constraint(equalToConstant: 180),
            
            lblTitle.topAnchor.constraint(equalTo: imgIllustration.bottomAnchor, constant: 20),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            lblSubtitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            lblSubtitle.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            lblSubtitle.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor),
            
            txtEmail.topAnchor.constraint(equalTo: lblSubtitle.bottomAnchor, constant: 40),
            txtEmail.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            txtEmail.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor),
            txtEmail.heightAnchor.constraint(equalToConstant: 55),
            
            txtPassword.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: 20),
            txtPassword.leadingAnchor.constraint(equalTo: txtEmail.leadingAnchor),
            txtPassword.trailingAnchor.constraint(equalTo: txtEmail.trailingAnchor),
            txtPassword.heightAnchor.constraint(equalToConstant: 55),
            
            btnLogin.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 30),
            btnLogin.leadingAnchor.constraint(equalTo: txtPassword.leadingAnchor),
            btnLogin.trailingAnchor.constraint(equalTo: txtPassword.trailingAnchor),
            btnLogin.heightAnchor.constraint(equalToConstant: 55),
            
            btnRegister.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 16),
            btnRegister.centerXAnchor.constraint(equalTo: btnLogin.centerXAnchor),
            btnRegister.heightAnchor.constraint(equalToConstant: 50),
            btnRegister.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        
    }
    
    // MARK: - Actions
    
    @objc private func didTapLogin() {
        guard let email = txtEmail.text, ValidationHelper.isValidEmail(email) else {
            AlertHelper.showOK(on: self, title: "Error", message: "Enter a valid email address")
            return
        }
        guard let password = txtPassword.text, ValidationHelper.isValidPassword(password) else {
            AlertHelper.showOK(on: self, title: "Error", message: "Password must be at least 8 characters with upper, lower, digit and special char")
            return
        }
        
        print("✅ Logging in with email: \(email)")
        // TODO: FirebaseAuthHelper.shared.login(...)
    }
}
