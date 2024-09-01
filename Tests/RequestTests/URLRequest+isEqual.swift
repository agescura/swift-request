import Foundation

extension URLRequest {
	func isEqual(_ rhs: URLRequest) -> Bool {
		var equal = self.url == rhs.url &&
		self.url?.host == rhs.url?.host &&
		self.url?.port == rhs.url?.port &&
		self.url?.path == rhs.url?.path &&
		self.url?.query == rhs.url?.query &&
		self.httpMethod == rhs.httpMethod &&
//		self.allHTTPHeaderFields?.description == rhs.allHTTPHeaderFields?.description //&&
		self.cachePolicy == rhs.cachePolicy &&
		self.timeoutInterval == rhs.timeoutInterval &&
		self.mainDocumentURL == rhs.mainDocumentURL &&
		self.networkServiceType == rhs.networkServiceType &&
		self.allowsCellularAccess == rhs.allowsCellularAccess &&
		self.allowsExpensiveNetworkAccess == rhs.allowsExpensiveNetworkAccess &&
		self.allowsConstrainedNetworkAccess == rhs.allowsConstrainedNetworkAccess
		
		if #available(iOS 14.5, macOS 11.3, tvOS 14.5, watchOS 7.4, *) {
			equal = equal &&
			self.assumesHTTP3Capable == rhs.assumesHTTP3Capable
		}
		if #available(iOS 15, macOS 12, tvOS 15, watchOS 8.0, *) {
			equal = equal &&
			self.attribution == rhs.attribution
		}
		if #available(iOS 16.1, macOS 13, tvOS 16.1, watchOS 9.1, *) {
			equal = equal &&
			self.requiresDNSSECValidation == rhs.requiresDNSSECValidation
		}
		// httpBodyStream
		return equal &&
		self.httpShouldHandleCookies == rhs.httpShouldHandleCookies &&
		self.httpShouldUsePipelining == rhs.httpShouldUsePipelining
		
	}
}
