class Imgdiet < Formula
  desc "Optimize and resize images"
  homepage "https://git.sr.ht/~jamesponddotco/imgdiet-go"
  url "https://git.sr.ht/~jamesponddotco/imgdiet-go/archive/v0.1.1.tar.gz"
  sha256 "c503e03bb2b2bce9fce4bd71244af3ddec2ee920e31cfd7f1ca10da8ddf66784"
  license "MIT"
  head "https://git.sr.ht/~jamesponddotco/imgdiet-go", branch: "trunk"

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "vips"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/imgdiet"
  end

  test do
    system bin/"imgdiet", "--compression", "9", test_fixtures("test.png"), testpath/"out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
