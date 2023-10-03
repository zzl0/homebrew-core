class DezoomifyRs < Formula
  desc "Tiled image downloader"
  homepage "https://github.com/lovasoa/dezoomify-rs"
  url "https://github.com/lovasoa/dezoomify-rs/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "19bcd079d8a370456080ba65b2f51fa4aa2eee00207a18aa9782dd7faef9acb9"
  license "GPL-3.0-only"
  head "https://github.com/lovasoa/dezoomify-rs.git", branch: "master"

  depends_on "rust" => :build
  depends_on "imagemagick" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiles.yaml").write <<~EOS
      url_template: "https://cdn.jsdelivr.net/gh/lovasoa/dezoomify-rs@v2.11.2/testdata/generic/map_{{x}}_{{y}}.jpg"
      x_template: "x * tile_size"
      y_template: "y * tile_size"
      variables:
        - { name: x, from: 0, to: 1 } # Image width, in tiles
        - { name: y, from: 0, to: 1 } # Image height, in tiles
        - { name: tile_size, value: 256 }
      title: "testtile"
    EOS
    (testpath/"testtiles_shasum.txt").write <<~EOS
      d0544af94eac6b418af6824554cb6bbbca8b3772261a1eb5fe9d1afb1eab458b  testtile.png
    EOS
    dezoom_out = shell_output("#{bin}/dezoomify-rs tiles.yaml 2> /dev/null")
    assert_match "Image successfully saved", dezoom_out
    image_dimensions = shell_output("identify -format \"%w×%h\\n\" testtile.png").strip
    assert_equal "512×512", image_dimensions
  end
end
