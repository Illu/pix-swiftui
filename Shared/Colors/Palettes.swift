//
//  Palettes.swift
//  pix
//
//  Created by Maxime Nory on 2022-01-04.
//

import Foundation

struct Palette {
    var name: String
    var colors: [String]
}

let Palettes: [Palette] = [
    Palette(
        name: "Classic",
        colors: [
            "#2B2D42",
            "#FFFFFF",
            "#ED6A5A",
            "#FFB800",
            "#35CE8D",
            "#4DB3FF",
            "#0085FF"
        ]
    ),
    Palette(
        name: "Fall",
        colors: [
            "#291517",
            "#5A1F31",
            "#A47973",
            "#F79A32",
            "#AD4D00",
            "#0A4E35",
            "#859B8E"
        ]
    ),
    Palette(
        name: "Ocean",
        colors: [
            "#023450",
            "#076194",
            "#6493AD",
            "#72ACAE",
            "#B4DADB",
            "#F2F1F7",
            "#B2AFCC"
        ]
    ),
    Palette(
        name: "Greens",
        colors: [
            "#DFEEC5",
            "#BAD87C",
            "#BDFF00",
            "#73DB21",
            "#55B808",
            "#188B46",
            "#01672A"
        ]
    ),
    Palette(
        name: "Skin",
        colors: [
            "#F9F4F0",
            "#FAEBDE",
            "#F8ECCF",
            "#E6C6A2",
            "#795A3D",
            "#5F3D1F",
            "#402812"
        ]
    )
]
