class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-12.76.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-12.76.tar.gz"
  sha256 "5d3430ec57aa031f7ca43170f7ed6338a66bda99ab95b9e071f1ee27555f515f"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "999f1d958e40e3897b1d27fecfc0bfd3a565f8e789a44ecdb57ee5727bf2893b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad413ba50a54932cd451afce6e4c4c24c5de4d8094f8c13253f39ae205518cf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad413ba50a54932cd451afce6e4c4c24c5de4d8094f8c13253f39ae205518cf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "93a3dfb99bff9bcaeeedecef19e02470f7e272dcbc30ecf6e7f316107be9d396"
    sha256 cellar: :any_skip_relocation, ventura:        "a73733b00f2f30a35e189c23f2ca91f661b90bd05ff6a796dd0d0c87f1af6042"
    sha256 cellar: :any_skip_relocation, monterey:       "a73733b00f2f30a35e189c23f2ca91f661b90bd05ff6a796dd0d0c87f1af6042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5525d5a4311fbebc70aa5d6124d2147f94e1958d3700e542d5fd48d406b8c79f"
  end

  uses_from_macos "perl"

  def install
    # Enable large file support
    # https://exiftool.org/forum/index.php?topic=3916.msg18182#msg18182
    inreplace "lib/Image/ExifTool.pm", "'LargeFileSupport', undef", "'LargeFileSupport', 1"

    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "unshift @INC, $incDir;", "unshift @INC, \"#{libexec}/lib\";"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
