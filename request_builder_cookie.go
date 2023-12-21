package fastshot

import (
	"net/http"
)

// BuilderCookie is the interface that wraps the basic methods for setting HTTP Cookies.
var _ BuilderCookie[RequestBuilder] = (*RequestCookieBuilder)(nil)

// RequestCookieBuilder serves as the main entry point for configuring HTTP Cookies.
type RequestCookieBuilder struct {
	parentBuilder *RequestBuilder
}

// BuilderCookie returns a new RequestCookieBuilder for setting custom HTTP Cookies.
func (b *RequestBuilder) Cookie() *RequestCookieBuilder {
	return &RequestCookieBuilder{parentBuilder: b}
}

// Add adds a custom cookie to the HTTP client.
func (b *RequestCookieBuilder) Add(cookie *http.Cookie) *RequestBuilder {
	b.parentBuilder.request.httpCookies = append(b.parentBuilder.request.httpCookies, cookie)
	return b.parentBuilder
}
