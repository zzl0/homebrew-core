class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/v1.19.1/google-java-format-1.19.1-all-deps.jar"
  sha256 "7df34e51f87829bf267dcd03c25fe54943028432d85bf1138bd0acc75988b5e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98fcafe5cd9189474aaf6d719e314089ef2682d2f03714b0dbb97bc36c1a3b69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98fcafe5cd9189474aaf6d719e314089ef2682d2f03714b0dbb97bc36c1a3b69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98fcafe5cd9189474aaf6d719e314089ef2682d2f03714b0dbb97bc36c1a3b69"
    sha256 cellar: :any_skip_relocation, sonoma:         "98fcafe5cd9189474aaf6d719e314089ef2682d2f03714b0dbb97bc36c1a3b69"
    sha256 cellar: :any_skip_relocation, ventura:        "98fcafe5cd9189474aaf6d719e314089ef2682d2f03714b0dbb97bc36c1a3b69"
    sha256 cellar: :any_skip_relocation, monterey:       "98fcafe5cd9189474aaf6d719e314089ef2682d2f03714b0dbb97bc36c1a3b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a0271c8c3ca90b3acc81f376b1d01227631a450fe87e6189db32fa46c6275c9"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  resource "google-java-format-diff" do
    url "https://raw.githubusercontent.com/google/google-java-format/v1.19.1/scripts/google-java-format-diff.py"
    sha256 "aa9621c0f0859e1112231a7d44ce8d21854f6915ca643a0d53a119f4d1aa8488"
  end

  def install
    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec/"google-java-format.jar", "google-java-format"
    resource("google-java-format-diff").stage do
      bin.install "google-java-format-diff.py" => "google-java-format-diff"
      rewrite_shebang detected_python_shebang, bin/"google-java-format-diff"
    end
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
    (testpath/"bar.java").write <<~BAR
      class Bar{
        int  x;
      }
    BAR
    patch = <<~PATCH
      --- a/bar.java
      +++ b/bar.java
      @@ -1,0 +2 @@ class Bar{
      +  int x  ;
    PATCH
    `echo '#{patch}' | #{bin}/google-java-format-diff -p1 -i`
    assert_equal <<~BAR, File.read(testpath/"bar.java")
      class Bar{
        int x;
      }
    BAR
    assert_equal version, resource("google-java-format-diff").version
  end
end
