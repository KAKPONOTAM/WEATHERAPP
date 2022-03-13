import UIKit

class HourlyWeatherDataCollectionViewCell: UICollectionViewCell {
    //MARK: - properties
   static let identifier = "HourlyWeatherDataCollectionViewCell"
    
    private let weatherDescriptionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: - override init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(weatherDescriptionImageView)
        contentView.addSubview(hourLabel)
        contentView.addSubview(temperatureLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hourLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            hourLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            hourLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 4),
            hourLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            weatherDescriptionImageView.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 5),
            weatherDescriptionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            weatherDescriptionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            weatherDescriptionImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 3)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: weatherDescriptionImageView.bottomAnchor, constant: 5),
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            temperatureLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 3),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
    
    func hourlyWeatherCollectionViewCellConfigure(hourlyWeatherData: WeeklyWeatherData, indexPath: IndexPath) {
        guard let date = hourlyWeatherData.hourly?[indexPath.item].dt,
              let hourWeatherIconId = hourlyWeatherData.hourly?[indexPath.row].weather?.first?.icon,
              let hourWeatherDescriptionIconIdUrl = URL(string: "https://openweathermap.org/img/wn/\(hourWeatherIconId)@2x.png"),
              let dataImage = try? Data(contentsOf: hourWeatherDescriptionIconIdUrl),
              let timezoneOffset = hourlyWeatherData.timezone_offset,
              let temperature = hourlyWeatherData.hourly?[indexPath.item].temp else { return }
        
        let correctHour = Date.getCorrectHour(unixTime: date, timezoneOffset: timezoneOffset)
        hourLabel.text = correctHour
        weatherDescriptionImageView.image = UIImage(data: dataImage)
        temperatureLabel.text = """
                                Temp:
                                \(Int(temperature))°C
                                """
    }
}

