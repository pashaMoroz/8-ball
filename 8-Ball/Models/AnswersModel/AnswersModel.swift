//
//  AnswersModel.swift
//  8-Ball
//
//  Created by Pasha Moroz on 9/4/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//


struct Answer: Codable {
    let magic: Magic
}

struct Magic: Codable {
    let question, answer, type: String
}
