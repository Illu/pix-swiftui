//
//  HomeScreen.swift
//  pix
//
//  Created by Maxime Nory on 2021-11-10.
//

import SwiftUI

struct HomeScreen: View {

	var body: some View {
		ZStack {
			Feed()
		}
	}
}

struct HomeScreen_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			HomeScreen()
		}
	}
}
