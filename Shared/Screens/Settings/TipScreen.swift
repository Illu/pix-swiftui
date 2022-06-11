//
//  TipScreen.swift
//  pix
//
//  Created by Maxime Nory on 2022-06-10.
//

import SwiftUI
import StoreKit

struct TipScreen: View {
	let productIDs = ["SMALLTIP", "GOODTIP", "GREATTIP"]
	let emojis = ["☕️", "🍕", "🎉"]
	
	@ObservedObject private var viewModel = TipViewModel()
	
    var body: some View {
		ScrollView {
			Image("chick").padding(16)
			Text("If you want to support the development of the App, feel free to leave a tip. It helps me cover the fees needed to keep the App running!")
			if (viewModel.transactionState == SKPaymentTransactionState.purchased) {
				Text("🎉 Thank you so much for your support!")
			}
			VStack {
				ForEach(viewModel.myProducts.indices, id: \.self) { index in
					HStack {
						VStack(alignment: .leading) {
							Text("\(emojis[index]) \(viewModel.myProducts[index].localizedTitle)")
								.font(.headline)
						}
						Spacer()
						if UserDefaults.standard.bool(forKey: viewModel.myProducts[index].productIdentifier) {
							Text ("Purchased 🙌")
								.foregroundColor(.green)
						} else {
							Button(action: {
								viewModel.purchaseProduct(product: viewModel.myProducts[index])
							}) {
								Text("Tip \(viewModel.myProducts[index].price) $")
							}
								.foregroundColor(.blue)
						}
					}
					.padding([.horizontal], 16)
					.padding([.vertical], 8)
				}
			}
			.padding([.all], 16)
			.background(ColorManager.cardBackground)
			.cornerRadius(16)
		}
		.padding([.horizontal], 16)
		.onAppear(perform: {
			viewModel.getProducts(productIDs: productIDs)
		})
		.background(ColorManager.screenBackground)
		.navigationTitle("Tip jar")
    }
}
