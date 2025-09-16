import UIKit
import SDWebImage

final class CategoryCVC: UICollectionViewCell {
    
    private let imgCategory: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let lblCategoryName: UILabel = {
        let lbl = UILabel()
        lbl.font = FontHelper.roboto(.medium(13))
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.textColor = .AppTheme.textPrimary
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .AppTheme.background
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        
        // Shadow for depth
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.15
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [imgCategory, lblCategoryName])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imgCategory.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75)
        ])
    }
    
    func configure(with category: Category, searchQuery: String?) {
        // Highlight search matches in the label
        lblCategoryName.attributedText = SearchHelper.highlight(
            text: category.name,
            searchQuery: searchQuery
        )
        
        // Load image from URL
        imgCategory.sd_setImage(
            with: URL(string: category.imagePath),
            placeholderImage: UIImage(named: "DefaultCategoryImage")
        )
    }
}
