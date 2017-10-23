import UIKit
import MobileCoreServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UIDropInteractionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        
        let dropInteraction = UIDropInteraction(delegate: self)
        selectedImageView.layer.borderWidth = 5.0
        selectedImageView.isUserInteractionEnabled = true
        selectedImageView.addInteraction(dropInteraction)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! UIImageTableCell
        cell.rowImageView.image = getImage(position)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    private func getImage(_ position: Int) -> UIImage{
        switch position {
        case 0:
            return UIImage(named: "castle")!
        case 1:
            return UIImage(named: "campaign")!
        case 2:
            return UIImage(named: "nature")!
        case 3:
            return UIImage(named: "sun")!
        case 4:
            return UIImage(named: "firework")!
        default:
            return UIImage(named: "firework")!
        }
    }
    
    // Drag
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let position = indexPath.row
        let image = getImage(position)
        
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        return [item]
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let cell = tableView.cellForRow(at: indexPath) as! UIImageTableCell
        let rowImageView = cell.rowImageView
        let frame = rowImageView!.frame
        let parameters = UIDragPreviewParameters()
        let rect = CGRect(x: frame.origin.x,
                          y: frame.origin.y,
                          width: frame.width,
                          height: frame.height)
        parameters.visiblePath = UIBezierPath(roundedRect: rect,
                                              cornerRadius: 0)
        return parameters
    }
    
    // Drop
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) && session.items.count == 1
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
        let operation: UIDropOperation
        
        if selectedImageView.frame.contains(dropLocation) {
            operation = .copy
        } else {
            operation = .cancel
        }
        return UIDropProposal(operation: operation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]
            self.selectedImageView.image = images.first
        }
    }
    
}
