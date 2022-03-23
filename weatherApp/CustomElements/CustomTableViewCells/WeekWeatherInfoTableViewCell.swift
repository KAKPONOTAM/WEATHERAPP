import UIKit


//MARK: - making custom class
class WeekWeatherInfoTableViewCell: UITableViewCell {
    //MARK: - properties
    static let identifier = "WeekWeatherInfoTableViewCell"
    
    private let weeklyWeatherInfoContainer: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let weatherDescriptionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maximalTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minimalTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - override inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(weeklyWeatherInfoContainer)
        self.backgroundColor = .clear
        
        weeklyWeatherInfoContainer.contentView.addSubview(weekdayLabel)
        weeklyWeatherInfoContainer.contentView.addSubview(weatherDescriptionImageView)
        weeklyWeatherInfoContainer.contentView.addSubview(maximalTemperatureLabel)
        weeklyWeatherInfoContainer.contentView.addSubview(minimalTemperatureLabel)
        weeklyWeatherInfoContainer.contentView.addSubview(temperatureLabel)
        
        setupConstraints()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            weeklyWeatherInfoContainer.topAnchor.constraint(equalTo: self.topAnchor),
            weeklyWeatherInfoContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weeklyWeatherInfoContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            weeklyWeatherInfoContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayLabel.topAnchor.constraint(equalTo: weeklyWeatherInfoContainer.topAnchor, constant: 5),
            weekdayLabel.leadingAnchor.constraint(equalTo: weeklyWeatherInfoContainer.leadingAnchor, constant: 10),
            weekdayLabel.bottomAnchor.constraint(equalTo: weeklyWeatherInfoContainer.bottomAnchor, constant: -5),
            weekdayLabel.widthAnchor.constraint(equalTo: weeklyWeatherInfoContainer.widthAnchor, multiplier: 1 / 6)
        ])
        
        NSLayoutConstraint.activate([
            weatherDescriptionImageView.topAnchor.constraint(equalTo: weeklyWeatherInfoContainer.topAnchor, constant: 5),
            weatherDescriptionImageView.leadingAnchor.constraint(equalTo: weekdayLabel.trailingAnchor, constant: 10),
            weatherDescriptionImageView.bottomAnchor.constraint(equalTo: weeklyWeatherInfoContainer.bottomAnchor, constant: -5),
            weatherDescriptionImageView.widthAnchor.constraint(equalTo: weeklyWeatherInfoContainer.widthAnchor, multiplier: 1 / 6)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: weeklyWeatherInfoContainer.topAnchor, constant: 5),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherDescriptionImageView.trailingAnchor, constant: 10),
            temperatureLabel.bottomAnchor.constraint(equalTo: weeklyWeatherInfoContainer.bottomAnchor, constant: -5),
            temperatureLabel.widthAnchor.constraint(equalTo: weeklyWeatherInfoContainer.widthAnchor, multiplier: 1 / 6)
        ])
        
        NSLayoutConstraint.activate([
            minimalTemperatureLabel.topAnchor.constraint(equalTo: weeklyWeatherInfoContainer.topAnchor, constant: 5),
            minimalTemperatureLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 10),
            minimalTemperatureLabel.bottomAnchor.constraint(equalTo: weeklyWeatherInfoContainer.bottomAnchor, constant: -5),
            minimalTemperatureLabel.widthAnchor.constraint(equalTo: weeklyWeatherInfoContainer.widthAnchor, multiplier: 1 / 6)
        ])
        
        NSLayoutConstraint.activate([
            maximalTemperatureLabel.topAnchor.constraint(equalTo: weeklyWeatherInfoContainer.topAnchor, constant: 5),
            maximalTemperatureLabel.leadingAnchor.constraint(equalTo: minimalTemperatureLabel.trailingAnchor, constant: 10),
            maximalTemperatureLabel.bottomAnchor.constraint(equalTo: weeklyWeatherInfoContainer.bottomAnchor, constant: -5),
            maximalTemperatureLabel.widthAnchor.constraint(equalTo: weeklyWeatherInfoContainer.widthAnchor, multiplier: 1 / 6)
        ])
    }
    
    func weeklyWeatherTableViewCellConfigure(weeklyWeatherData: WeeklyWeatherData, indexPath: IndexPath) {
        guard let iconId = weeklyWeatherData.daily?[indexPath.row].weather?.first?.icon,
              let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(iconId)@2x.png"),
              let weekDay = weeklyWeatherData.daily?[indexPath.row].dt,
              let temperature = weeklyWeatherData.daily?[indexPath.row].temp?.day,
              let maximalTemperature = weeklyWeatherData.daily?[indexPath.row].temp?.max,
              let minimalTemperature = weeklyWeatherData.daily?[indexPath.row].temp?.min else { return }
        
        let correctDay = Date.getCorrectDay(unixTime: weekDay)
        
        weekdayLabel.text = correctDay
        
        temperatureLabel.text = """
                                Temp:
                                \(Int(temperature))°C
                                """
        minimalTemperatureLabel.text = """
                                       Min:
                                       \(Int(minimalTemperature))°C
                                       """
        maximalTemperatureLabel.text = """
                                       Max:
                                       \(Int(maximalTemperature))°C
                                       """
        
        weatherDescriptionImageView.kf.setImage(with: iconUrl)
    }
}

