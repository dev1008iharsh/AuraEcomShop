import UIKit

final class SignupVC: UIViewController {
    
    // MARK: - UI
    
    private let imgIllustration: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "SIGNUP_VECTOR"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let txtName: UITextField = {
        let tf = TextFieldHelper.makeTextField(placeholder: "Enter Your Name")
        return tf
    }()
    
    private let txtEmail: UITextField = {
        let tf = TextFieldHelper.makeTextField(placeholder: "Enter Your Email")
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let txtPassword: UITextField = {
        let tf = TextFieldHelper.makeTextField(placeholder: "YEnter our Password", isSecure: true)
        return tf
    }()
    
    private let txtPhone: UITextField = {
        let tf = TextFieldHelper.makeTextField(placeholder: "Enter Your 10 digit Phone Number")
        tf.keyboardType = .phonePad
        return tf
    }()
    
    private let btnSignup: UIButton = {
        let btn = ButtonHelper.makeButton(
            title: "Sign Up",
            style: .primary,
            font: FontHelper.roboto(.medium(18)),
            height: 55,
            cornerRadius: 12
        )
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupLayout()
        btnSignup.addTarget(self, action: #selector(didTapSignup), for: .touchUpInside)
    }
    
    // MARK: - UI Setup
    
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemPink.cgColor,
            UIColor.systemOrange.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupLayout() {
        [imgIllustration, txtName, txtEmail, txtPassword, txtPhone, btnSignup].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imgIllustration.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imgIllustration.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgIllustration.heightAnchor.constraint(equalToConstant: 180),
            imgIllustration.widthAnchor.constraint(equalToConstant: 180),
            
            txtName.topAnchor.constraint(equalTo: imgIllustration.bottomAnchor, constant: 30),
            txtName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            txtName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            txtName.heightAnchor.constraint(equalToConstant: 55),
            
            txtEmail.topAnchor.constraint(equalTo: txtName.bottomAnchor, constant: 20),
            txtEmail.leadingAnchor.constraint(equalTo: txtName.leadingAnchor),
            txtEmail.trailingAnchor.constraint(equalTo: txtName.trailingAnchor),
            txtEmail.heightAnchor.constraint(equalToConstant: 55),
            
            txtPassword.topAnchor.constraint(equalTo: txtEmail.bottomAnchor, constant: 20),
            txtPassword.leadingAnchor.constraint(equalTo: txtEmail.leadingAnchor),
            txtPassword.trailingAnchor.constraint(equalTo: txtEmail.trailingAnchor),
            txtPassword.heightAnchor.constraint(equalToConstant: 55),
            
            txtPhone.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 20),
            txtPhone.leadingAnchor.constraint(equalTo: txtPassword.leadingAnchor),
            txtPhone.trailingAnchor.constraint(equalTo: txtPassword.trailingAnchor),
            txtPhone.heightAnchor.constraint(equalToConstant: 55),
            
            btnSignup.topAnchor.constraint(equalTo: txtPhone.bottomAnchor, constant: 30),
            btnSignup.leadingAnchor.constraint(equalTo: txtPhone.leadingAnchor),
            btnSignup.trailingAnchor.constraint(equalTo: txtPhone.trailingAnchor),
            btnSignup.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapSignup() {
        guard let name = txtName.text, ValidationHelper.isValidName(name) else {
            AlertHelper.showOK(on: self, title: "Error", message: "Name must be at least 3 characters")
            return
        }
        guard let email = txtEmail.text, ValidationHelper.isValidEmail(email) else {
            AlertHelper.showOK(on: self, title: "Error", message: "Enter a valid email address")
            return
        }
        guard let password = txtPassword.text, ValidationHelper.isValidPassword(password) else {
            AlertHelper.showOK(on: self, title: "Error", message: "Password must be at least 8 characters with upper, lower, digit and special char")
            return
        }
        guard let phone = txtPhone.text, ValidationHelper.isValidPhone(phone) else {
            AlertHelper.showOK(on: self, title: "Error", message: "Enter a valid 10-digit phone number with +91 prefix")
            return
        }
        
        print("✅ Signing up user: \(name), \(email), \(phone)")
        // TODO: FirebaseAuthHelper.shared.signup(...)
    }
}
