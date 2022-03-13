import UIKit

class SunriseAndSunsetTableViewCell: UITableViewCell {
    //MARK: - properties
    static let identifier = "SunriseAndSunsetTableViewCell"
    
    private let sunriseAndSunsetTableViewCellInfoContainer: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sunsetInfoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = LayerManager.shared.cornerRadius
        return view
    }()
    
    private let sunriseInfoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = LayerManager.shared.cornerRadius
        return view
    }()
    
    private let sunsetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "sunset")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let sunriseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "sunrise")
        return imageView
    }()
    
    private let sunriseTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sunsetTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - override init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        contentView.addSubview(sunriseAndSunsetTableViewCellInfoContainer)
        sunriseAndSunsetTableViewCellInfoContainer.contentView.addSubview(sunsetInfoContainer)
        sunriseAndSunsetTableViewCellInfoContainer.contentView.addSubview(sunriseInfoContainer)
        
        sunsetInfoContainer.addSubview(sunsetImageView)
        sunsetInfoContainer.addSubview(sunsetTimeLabel)
        
        sunriseInfoContainer.addSubview(sunriseImageView)
        sunriseInfoContainer.addSubview(sunriseTimeLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - methods
    private func  setupConstraints() {
        NSLayoutConstraint.activate([
            sunriseAndSunsetTableViewCellInfoContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            sunriseAndSunsetTableViewCellInfoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sunriseAndSunsetTableViewCellInfoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sunriseAndSunsetTableViewCellInfoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sunsetInfoContainer.topAnchor.constraint(equalTo: sunriseAndSunsetTableViewCellInfoContainer.topAnchor, constant: 5),
            sunsetInfoContainer.leadingAnchor.constraint(equalTo: sunriseAndSunsetTableViewCellInfoContainer.leadingAnchor, constant: 5),
            sunsetInfoContainer.widthAnchor.constraint(equalTo: sunriseAndSunsetTableViewCellInfoContainer.widthAnchor, multiplier: 1 / 2.5),
            sunsetInfoContainer.bottomAnchor.constraint(equalTo: sunriseAndSunsetTableViewCellInfoContainer.bottomAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            sunriseInfoContainer.topAnchor.constraint(equalTo: sunriseAndSunsetTableViewCellInfoContainer.topAnchor, constant: 5),
            sunriseInfoContainer.widthAnchor.constraint(equalTo: sunriseAndSunsetTableViewCellInfoContainer.widthAnchor, multiplier: 1 / 2.5),
            sunriseInfoContainer.trailingAnchor.constraint(equalTo: sunriseAndSunsetTableViewCellInfoContainer.trailingAnchor, constant: -5),
            sunriseInfoContainer.bottomAnchor.constraint(equalTo: sunriseAndSunsetTableViewCellInfoContainer.bottomAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            sunsetImageView.topAnchor.constraint(equalTo: sunsetInfoContainer.topAnchor, constant: 5),
            sunsetImageView.leadingAnchor.constraint(equalTo: sunsetInfoContainer.leadingAnchor, constant: 15),
            sunsetImageView.trailingAnchor.constraint(equalTo: sunsetInfoContainer.trailingAnchor, constant: -15),
            sunsetImageView.heightAnchor.constraint(equalTo: sunsetInfoContainer.heightAnchor, multiplier: 1 / 2)
        ])
        
        NSLayoutConstraint.activate([
            sunsetTimeLabel.topAnchor.constraint(equalTo: sunsetImageView.bottomAnchor, constant: 5),
            sunsetTimeLabel.leadingAnchor.constraint(equalTo: sunsetInfoContainer.leadingAnchor, constant: 15),
            sunsetTimeLabel.trailingAnchor.constraint(equalTo: sunsetInfoContainer.trailingAnchor, constant: -15),
            sunsetTimeLabel.bottomAnchor.constraint(equalTo: sunsetInfoContainer.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            sunriseImageView.topAnchor.constraint(equalTo: sunriseInfoContainer.topAnchor, constant: 5),
            sunriseImageView.leadingAnchor.constraint(equalTo: sunriseInfoContainer.leadingAnchor, constant: 15),
            sunriseImageView.trailingAnchor.constraint(equalTo: sunriseInfoContainer.trailingAnchor, constant: -15),
            sunriseImageView.heightAnchor.constraint(equalTo: sunriseInfoContainer.heightAnchor, multiplier: 1 / 2)
        ])
        
        NSLayoutConstraint.activate([
            sunriseTimeLabel.topAnchor.constraint(equalTo: sunriseImageView.bottomAnchor, constant: 5),
            sunriseTimeLabel.leadingAnchor.constraint(equalTo: sunriseInfoContainer.leadingAnchor, constant: 15),
            sunriseTimeLabel.trailingAnchor.constraint(equalTo: sunriseInfoContainer.trailingAnchor, constant: -15),
            sunriseTimeLabel.bottomAnchor.constraint(equalTo: sunriseInfoContainer.bottomAnchor, constant: -15)
        ])
    }
    
    func configure(sunriseAndSunsetTime: CurrentWeatherInfo) {
        guard let sunriseUnixTime = sunriseAndSunsetTime.sys?.sunrise,
              let sunsetUnixTime = sunriseAndSunsetTime.sys?.sunset else { return }
        
        let sunsetTime = Date.getCorrectTimeForSunriseAndSunset(unixTime: sunsetUnixTime)
        let sunriseTime = Date.getCorrectTimeForSunriseAndSunset(unixTime: sunriseUnixTime)
        
        sunriseTimeLabel.text = sunriseTime
        sunsetTimeLabel.text = sunsetTime
    }
}
