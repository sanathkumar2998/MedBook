//
//  BookTableViewCell.swift
//  MedBook
//
//  Created by Sanath on 12/04/24.
//

import UIKit
import Kingfisher

protocol BookCellData {
    var title: String { get }
    var ratingsAverage: String { get }
    var ratingsCount: String { get }
    var authorName: String { get }
    var coverImageURLString: String { get }
}

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorNameLabel: UILabel!
    @IBOutlet private var ratingsAverageLabel: UILabel!
    @IBOutlet private var ratingsCountLabel: UILabel!
    
    var data: BookCellData? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
}

private extension BookTableViewCell {
    func setup() {
        contentView.layer.cornerRadius = 12
    }
    
    func setData() {
        guard let data else { return }
        
        let url = URL(string: data.coverImageURLString)
        coverImageView.kf.setImage(with: url)
        titleLabel.text = data.title
        authorNameLabel.text = data.authorName
        ratingsAverageLabel.text = data.ratingsAverage
        ratingsCountLabel.text = data.ratingsCount
    }
}
