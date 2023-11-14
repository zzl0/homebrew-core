class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "03bb27c4f751aa259f02993fecef08ff3a295018165a886d640a8951eb3fcd02"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/testifysec/witness/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"witness", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witness version")

    system "openssl", "genrsa", "-out", "buildkey.pem", "2048"
    system "openssl", "rsa", "-in", "buildkey.pem", "-outform", "PEM", "-pubout", "-out", "buildpublic.pem"
    system "#{bin}/witness", "run", "-s", "build", "-a", "environment", "-k", "buildkey.pem", "-o",
           "build-attestation.json"

    output = Base64.decode64(JSON.parse((testpath/"build-attestation.json").read)["payload"])
    assert_match "\"type\":\"https://witness.dev/attestations/product/v0.1\",", output
  end
end
