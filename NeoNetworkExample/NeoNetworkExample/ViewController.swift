import UIKit
import NeoNetwork
import Combine

struct Model: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

class ViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!

    private let neoNetwork = NeoNetwork()
    private let url: URL = .init(string: "https://jsonplaceholder.typicode.com/todos/1")!
    private var subscriptions: Set<AnyCancellable> = .init()

    private let userIdLabel = UILabel()
    private let idLabel = UILabel()
    private let titleLabel = UILabel()
    private let completedLabel = UILabel()
    private let errorLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        [userIdLabel, idLabel, titleLabel, completedLabel].forEach {
            stackView.addArrangedSubview($0)
        }

        neoNetwork.fetch(from: url).sink(
            receiveCompletion: { error in },
            receiveValue: { [weak self] (model: Model) in
                DispatchQueue.main.async {
                    self?.userIdLabel.text = "UserId: " + String(model.userId)
                    self?.idLabel.text = "Id: " + String(model.id)
                    self?.titleLabel.text = "Title: " + model.title
                    self?.completedLabel.text = "Completed: " + String(model.completed)
                }
            }
        ).store(in: &subscriptions)
    }
}

