Pod::Spec.new do |s|
s.name = "PoliteReview"
s.version = "1.2.1"
s.summary = "A Polite Way to Request Reviews for iOS"
s.homepage = "https://github.com/kevinchau/PoliteReview"
s.license = { type: 'MIT', file: 'LICENSE' }
s.authors = { "Your Name" => 'chaukevin@gmail.com' }
s.social_media_url = "http://twitter.com/kchau"

s.platform = :ios, "9.1"
s.requires_arc = true
s.source = { git: "https://github.com/kevinchau/PoliteReview.git", :tag => s.version.to_s }
s.source_files = "PoliteReview/**/*.{h,swift,strings}"

end
