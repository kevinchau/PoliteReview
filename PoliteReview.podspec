Pod::Spec.new do |spec|
spec.name = "PoliteReview"
spec.version = "1.0.0"
spec.summary = "A Polite Way to Request Reviews for iOS"
spec.homepage = "https://github.com/kevinchau/PoliteReview"
spec.license = { type: 'MIT', file: 'LICENSE' }
spec.authors = { "Your Name" => 'chaukevin@gmail.com' }
spec.social_media_url = "http://twitter.com/kchau"

spec.platform = :ios, "9.1"
spec.requires_arc = true
spec.source = { git: "https://github.com/kevinchau/PoliteReview.git", tag: "v#{spec.version}", submodules: true }
spec.source_files = "PoliteReview/**/*.{h,swift,strings}"

end
