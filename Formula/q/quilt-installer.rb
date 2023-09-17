class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.9.1/quilt-installer-0.9.1.jar"
  sha256 "c4bd6300b883e406a15490f9c36059ec3057fc28b4f5b858e0e793231d0b4fa7"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3eb174a7330aad00dfb973b0b87f77256f51c9a2b071d95995ef5737d4e3ac36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eb174a7330aad00dfb973b0b87f77256f51c9a2b071d95995ef5737d4e3ac36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3eb174a7330aad00dfb973b0b87f77256f51c9a2b071d95995ef5737d4e3ac36"
    sha256 cellar: :any_skip_relocation, ventura:        "3eb174a7330aad00dfb973b0b87f77256f51c9a2b071d95995ef5737d4e3ac36"
    sha256 cellar: :any_skip_relocation, monterey:       "3eb174a7330aad00dfb973b0b87f77256f51c9a2b071d95995ef5737d4e3ac36"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eb174a7330aad00dfb973b0b87f77256f51c9a2b071d95995ef5737d4e3ac36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42af4249d7fc720a96ff5f8357726bf43c6efa617dd0b02bd00fa3d32fad8212"
  end

  depends_on "openjdk"

  def install
    libexec.install "quilt-installer-#{version}.jar"
    bin.write_jar_script libexec/"quilt-installer-#{version}.jar", "quilt-installer"
  end

  test do
    system "#{bin}/quilt-installer", "install", "server", "1.19.2"
    assert_predicate testpath/"server/quilt-server-launch.jar", :exist?
  end
end
