class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/bf/04/13a5091a1da014fad160710abfad2aa03a72bc41e4678c95be2b5ee67818/HyFetch-1.4.10.tar.gz"
  sha256 "023733fa358380fd41589cd80e9b008d376eeef16b489fba8ee8610e71e42057"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  on_macos do
    depends_on "screenresolution"
  end

  def install
    virtualenv_install_with_resources
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
