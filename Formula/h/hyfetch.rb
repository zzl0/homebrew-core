class Hyfetch < Formula
  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/bb/af/0c4590b16c84073bd49b09ada0756fd9bd75b072e3ba9aec73101f0cc9f4/HyFetch-1.4.11.tar.gz"
  sha256 "9fa2c9c049ebaf0ad6d4e8e076ce90e64a4b9276946a1d2ffb6912bb1a4aa327"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53bbaac30e00d9e4a83452f38cc901120a7b91194a1aee1bde9e873b7248bece"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01c4269d226afe2976e22503e953b5a6e0392a0ff34ea01b9298ecc0211ac651"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df3da56d1cb0d88978ba5efab69d9bcb8014fded6ad4174a04e982f42a1dcaef"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5b1667572ea14ab811555cb9e6c37bb4693933a6f5cc421003e06ade7b2086e"
    sha256 cellar: :any_skip_relocation, ventura:        "3d42bc57821e651591f6c19ade514bf97b6eddcbb827a96c41fef98930f719c9"
    sha256 cellar: :any_skip_relocation, monterey:       "f5ccfd3d53357095a2be5f0bef3b099207fa6f2f16dad7d93969104b59bf8c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83d274693ef365b9bb67fc2a72cbc4900befd2caea02386f3e5a73ce279ae41e"
  end

  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  on_macos do
    depends_on "screenresolution"
  end

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/".config/hyfetch.json").write <<-EOS
    {
      "preset": "genderfluid",
      "mode": "rgb",
      "light_dark": "dark",
      "lightness": 0.5,
      "color_align": {
        "mode": "horizontal",
        "custom_colors": [],
        "fore_back": null
      },
      "backend": "neofetch",
      "distro": null,
      "pride_month_shown": [],
      "pride_month_disable": false
    }
    EOS
    system "#{bin}/neowofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
    system "#{bin}/hyfetch", "-C", testpath/"hyfetch.json",
                             "--args=\"--config none --color_blocks off --disable wm de term gpu\""
  end
end
