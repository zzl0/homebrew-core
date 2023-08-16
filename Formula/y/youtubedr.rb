class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.8.2.tar.gz"
  sha256 "18a12b84dfd315b9f75b404f0b29125540489193c71ab5e323df8d7342ec5f8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bbdc2688fa0171b4cbe1da49ad429ebc4a832b73096c052432c789464de1772"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bbdc2688fa0171b4cbe1da49ad429ebc4a832b73096c052432c789464de1772"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bbdc2688fa0171b4cbe1da49ad429ebc4a832b73096c052432c789464de1772"
    sha256 cellar: :any_skip_relocation, ventura:        "3a3c63dc51152aef7bf80c1c4b8d11c88b2ab2a20c6a8a0858abbb24d127d040"
    sha256 cellar: :any_skip_relocation, monterey:       "3a3c63dc51152aef7bf80c1c4b8d11c88b2ab2a20c6a8a0858abbb24d127d040"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a3c63dc51152aef7bf80c1c4b8d11c88b2ab2a20c6a8a0858abbb24d127d040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "862b2c1c64723f4ca088afe035c05a3212e97e636f86905b31dbd4be58031262"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/youtubedr"

    generate_completions_from_executable(bin/"youtubedr", "completion")
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
