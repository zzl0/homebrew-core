class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.72.tar.gz"
  sha256 "c1fd5e0fdb8470dc28e596dc29845e3b7e03d02ab336d961ef3101337ee4093c"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "373cfbab7d313213da941346c7ed267adaf6181a9c739e1fdf15b24163631a21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cbdc425f362bf32e9fe2186f721b65c99dc6803b06e1d6d6677c9f82ac5c67b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392c3f00b337b613b1e09bae294830331f29d2dc250a0f3693957072f09c09f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e575e6ec613cac80d763b87c64156958d5c2f73ca1553467f8f09117f05c94ac"
    sha256 cellar: :any_skip_relocation, ventura:        "3916ab83c510c88b540044c15b30c1fb9019ed4f82602002937abd46db489ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a95b2e09282a3660cf732c55b3ddda17044abdb4f7c2689066d61653eec3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b386d6d5baefb2c5cdbc68695be5121e6224ce927a1e8ab10ea581beec5ae527"
  end

  depends_on "go" => :build

  # update to build with go1.21
  # upstream PR ref, https://github.com/openshift-online/ocm-cli/pull/587
  patch do
    url "https://github.com/openshift-online/ocm-cli/commit/0bfd59a5728ece351e60ab34e0fbade747472feb.patch?full_index=1"
    sha256 "cc5016d6c98b7b995bb331ccf6c68f393e06bdf17536e9b92ca8c18c0a7494c9"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end
