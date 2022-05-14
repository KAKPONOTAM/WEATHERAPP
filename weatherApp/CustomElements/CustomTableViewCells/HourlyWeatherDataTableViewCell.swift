import UIKit
import Kingfisher

class HourlyWeatherDataTableViewCell: UITableViewCell {
    //MARK: - properties
    static let identifier = "HourlyWeatherDataTableViewCell"
    private var hourlyWeatherData: WeeklyWeatherData?
    
    private let hourWeatherInfoContainer: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hourWeatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HourlyWeatherDataCollectionViewCell.self, forCellWithReuseIdentifier: HourlyWeatherDataCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - override init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(hourWeatherInfoContainer)
        hourWeatherInfoContainer.contentView.addSubview(hourWeatherCollectionView)
        setupConstraints()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hourWeatherInfoContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            hourWeatherInfoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hourWeatherInfoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hourWeatherInfoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hourWeatherCollectionView.topAnchor.constraint(equalTo: hourWeatherInfoContainer.topAnchor),
            hourWeatherCollectionView.leadingAnchor.constraint(equalTo: hourWeatherInfoContainer.leadingAnchor),
            hourWeatherCollectionView.trailingAnchor.constraint(equalTo: hourWeatherInfoContainer.trailingAnchor),
            hourWeatherCollectionView.bottomAnchor.constraint(equalTo: hourWeatherInfoContainer.bottomAnchor)
        ])
    }
    
    func hourlyWeatherTableViewCellConfigure(hourWeatherData: WeeklyWeatherData) {
        self.hourlyWeatherData = hourWeatherData
        self.hourWeatherCollectionView.reloadData()
    }
}

extension HourlyWeatherDataTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData?.hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherDataCollectionViewCell.identifier, for: indexPath) as? HourlyWeatherDataCollectionViewCell else { return UICollectionViewCell() }
        
        guard let hourlyWeatherData = hourlyWeatherData else { return UICollectionViewCell() }
        
        cell.hourlyWeatherCollectionViewCellConfigure(hourlyWeatherData: hourlyWeatherData, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (hourWeatherInfoContainer.frame.width / 3) - 5
        let height = hourWeatherInfoContainer.frame.height - 10
        
        return CGSize(width: width, height: height)
    }
}
