//
//  NoteListItemTableViewCell.swift
//  Notes
//
//  Created by Mike Haydan on 23/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import UIKit

protocol NoteListItemTableViewCellView {
    func set(title: String)
}

final class NoteListItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var noteTitleLabel: UILabel!
    
}

// MARK: - NoteListItemTableViewCellView

extension NoteListItemTableViewCell: NoteListItemTableViewCellView {
    
    func set(title: String) {
        self.noteTitleLabel.text = title
    }
}
