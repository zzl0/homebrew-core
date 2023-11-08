class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2adc1dec0d2c63cbffa94204b212926f2735a59753494fca72c3cfe4001d472f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c4be86bd9b826d458a544c71bfaf0ec731194814058d66734746ffb38350760"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "271c6437b052266f984385bc9b2c858f5b3a49b64dc2cc5b7c6d59ee1f8b5fd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835707d1e97370f90da250af0530a0fbeac76a5dc9ffb23f9fe3bcae92de89dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cff9381bd1df190b0ce4f1707d06b061f4f3da260feffd6598d0f8bfc1862b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "383f766df2410e860a92661d374a5069fedddf584efc41822e7e95e1b2b16823"
    sha256 cellar: :any_skip_relocation, ventura:        "7a96cfa7331341b29fd88b3db25b2c18467e93cbfc7c0045bc923c0aabfe361d"
    sha256 cellar: :any_skip_relocation, monterey:       "dcbc3366946b79448289b73a88e26e2686a9847fe8c6f68abe6e421e54a23551"
    sha256 cellar: :any_skip_relocation, big_sur:        "d33e64b4ef076ac70f487f5095b94ce9d9f306ba8036f2015cfa381fbcec86aa"
    sha256 cellar: :any_skip_relocation, catalina:       "4361d802ac3d701e6779538f8329148635c9facac816d04df5efd75928d6186f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2314e052715a9a728694c5dead51555f276b7e51cea9c1bf7be6e1e51af0bfe8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "gen/sd.1"
    bash_completion.install "gen/completions/sd.bash" => "sd"
    fish_completion.install "gen/completions/sd.fish"
    zsh_completion.install "gen/completions/_sd"
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
