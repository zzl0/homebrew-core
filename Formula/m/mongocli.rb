class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.31.2.tar.gz"
  sha256 "612c65c14db13f09000ed3d214f93bbb6b326b817d8fc46f95133104a1777741"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c038286561c7d7d913ad9ceca1cbb42f251383d1da11fb6b3869ed8ca50a5e49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "444a71e4b71361ca6ea83623ca7d4d5d9c4ea3bf4db59783983d398b82f34b91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa37d9c76d91a88f0b57b0df17bb0e558f53a45e664888136e1fd6c7c076505"
    sha256 cellar: :any_skip_relocation, sonoma:         "abf8bb17cfa9d0dd600066d6a076e858c98c0a61e0503e9ab8baa765868679ed"
    sha256 cellar: :any_skip_relocation, ventura:        "94a36599033dd980e33c7dd0c768c240be2f611c9d8baf70a4b94ab35e6d67d3"
    sha256 cellar: :any_skip_relocation, monterey:       "df2a0bd6a017d90339cc6bbd46d5220e5d11f0f6886da6e9d329b3ce5aa9d829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2102db6a2117eb2f2327e6a109a676b46dcd81430a1321ed4d3e48a861158272"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", "completion")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
