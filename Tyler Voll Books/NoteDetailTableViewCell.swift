//
//  NoteTableViewCell.swift
//  ElevenNote
//
//  Copyright (c) 2014 ElevenFifty. All rights reserved.
// Licensed under MIT for reuse

import UIKit

var blankNumber: Double = 0

class NoteDetailTableViewCell : UITableViewCell {
    
    // The note currently being shown
    weak var theNote : Note!
    
    // Interface builder outlets
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteDateLabel : UILabel!
    @IBOutlet weak var noteTextLabel : UILabel!
    
    
    // Insert note contents into the cell
    func setupCell(theNote:Note) {
        // Save a weak reference to the note
        self.theNote = theNote
        
        // Update the cell
        
        if(theNote.title == ""){
            blankNumber += 1
            noteTitleLabel.text = "Note #\(blankNumber)"
            
        }else{
            noteTitleLabel.text = theNote.title
        }
        //Checks to see if the title is blank and then provides a default title if the title is indeed blank
        
        if(theNote.text == ""){
            noteTextLabel.text = "This note is currently empty."
        }else{
            noteTextLabel.text = theNote.text
        }
       
        noteDateLabel.text = theNote.shortDate as String
    }
    
}
