//
//  ContentView.swift
//  ChatGPT WebView
//
//  Created by Daniel Illescas Romero on 11/5/23.
//

import SwiftUI

struct ContentView: View {

	@State
	private var isInitiallyLoading: Bool = true

	@State
	private var webViewOpacity: CGFloat = 0

	@State
	private var rotationAngle: Double = 0.0

	private let initialURL: URL = URL(string: "https://chat.openai.com")!

	var body: some View {
		ZStack {
			WebView(initialURL: initialURL, delayAfterLoadInMs: 1000) {
				withAnimation(.linear(duration: 0.3)) {
					isInitiallyLoading = false
					webViewOpacity = 1
				}
			}
			.opacity(webViewOpacity)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(
				Color("BackgroundColor"),
				ignoresSafeAreaEdges: .all
			)

			if isInitiallyLoading {
				Color("SplashBackgroundColor")
					.ignoresSafeArea()
				VStack {
					Image("SplashImage")
						.rotationEffect(.degrees(rotationAngle))
						.animation(.linear(duration: 4).repeatForever(autoreverses: false).delay(0.1), value: rotationAngle)
						.onAppear {
							rotationAngle = 360.0
						}
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
