//
//  WKWebView.swift
//  ChatGPT WebView
//
//  Created by Daniel Illescas Romero on 11/5/23.
//

import SwiftUI
import WebKit

#if os(iOS)
import UIKit

struct WebView: UIViewRepresentable {

	let initialURL: URL
	let delayAfterLoadInMs: Int
	let initialNavigationDidFinish: () -> Void

	init(initialURL: URL, delayAfterLoadInMs: Int = 0, initialNavigationDidFinish: @escaping () -> Void) {
		self.initialURL = initialURL
		self.delayAfterLoadInMs = delayAfterLoadInMs
		self.initialNavigationDidFinish = initialNavigationDidFinish
	}

	func makeCoordinator() -> WebViewCoordinator {
		WebViewCoordinator(delayAfterLoadInMs: delayAfterLoadInMs, navigationDidFinish: initialNavigationDidFinish)
	}
	
	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView(frame: .zero)
		webView.load(URLRequest(url: initialURL))
		webView.navigationDelegate = context.coordinator
		return webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
		
	}
}
#elseif os(macOS)
import AppKit

struct WebView: NSViewRepresentable {

	let initialURL: URL
	let delayAfterLoadInMs: Int
	let initialNavigationDidFinish: () -> Void

	init(initialURL: URL, delayAfterLoadInMs: Int = 0, initialNavigationDidFinish: @escaping () -> Void) {
		self.initialURL = initialURL
		self.delayAfterLoadInMs = delayAfterLoadInMs
		self.initialNavigationDidFinish = initialNavigationDidFinish
	}

	func makeCoordinator() -> WebViewCoordinator {
		WebViewCoordinator(delayAfterLoadInMs: delayAfterLoadInMs, navigationDidFinish: initialNavigationDidFinish)
	}

	func makeNSView(context: NSViewRepresentableContext<WebView>) -> WKWebView {
		let webView = WKWebView(frame: .zero)
		webView.load(URLRequest(url: initialURL))
		webView.navigationDelegate = context.coordinator
		return webView
	}

	func updateNSView(_ nsView: WKWebView, context: NSViewRepresentableContext<WebView>) {

	}
}
#endif

class WebViewCoordinator: NSObject, WKNavigationDelegate {

	private var initialNavigationFinished = false
	private let delayAfterLoadInMs: Int
	private let navigationDidFinish: () -> Void

	init(delayAfterLoadInMs: Int, navigationDidFinish: @escaping () -> Void) {
		self.delayAfterLoadInMs = delayAfterLoadInMs
		self.navigationDidFinish = navigationDidFinish
	}

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		controlNavigationCallback()
	}

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		controlNavigationCallback()
	}

	private func controlNavigationCallback() {
		if !initialNavigationFinished {
			initialNavigationFinished = true
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delayAfterLoadInMs)) {
				self.navigationDidFinish()
			}
		}
	}
}
