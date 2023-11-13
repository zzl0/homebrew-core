class Ruler < Formula
  desc "Tool to abuse Exchange services"
  homepage "https://github.com/sensepost/ruler"
  url "https://github.com/sensepost/ruler/archive/refs/tags/2.5.0.tar.gz"
  sha256 "e7344c60c604fa08f73dd30978f6815979cc26ca78bca71e132d0c66cc152718"
  license "CC-BY-NC-SA-4.0"
  head "https://github.com/sensepost/ruler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0902958de4c70c76839786dda690b3c2511f8162a311f1fadcd26340ff47088"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ab70c74d0267919c69539df184bdcea18423856a49e7b088e2b451e39eb8c50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e7b0a67fe4d7603a83f0d7de3cb430b17f1de4e0223e640c149bc31aa53f465"
    sha256 cellar: :any_skip_relocation, sonoma:         "34f9d47d325e4b347db003e4f7d5fe059e44c2fb8509cf32a45e271f35ea0780"
    sha256 cellar: :any_skip_relocation, ventura:        "b2b05047e82e4b88b9cddcc57fbd1c979a898ae34db371d9f31afbd3c044028a"
    sha256 cellar: :any_skip_relocation, monterey:       "9eb542d4476ac45c92b6be5c6121e2a0150c05cfc588b1db520b984a65aeddea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a68de0e3454c6891bc15364ad04ff51c6ae31cf244b6c589649b058982fa0ef9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_config = testpath/"config.yml"
    test_config.write <<~EOS
      username: ""
      email: ""
      password: ""
      hash: ""
      domain: ""
      userdn: "/o=First Organization/ou=Exchange Administrative Group(FYDIBOHF23SPDLT)/cn=Recipients/cn=0003BFFDFEF9FB24"
      mailbox: "0003bffd-fef9-fb24-0000-000000000000@outlook.com"
      rpcurl: "https://outlook.office365.com/rpc/rpcproxy.dll"
      rpc: false
      rpcencrypt: true
      ntlm: true
      mapiurl: "https://outlook.office365.com/mapi/emsmdb/"
    EOS

    output = shell_output("#{bin}/ruler --config #{test_config} check 2>&1", 1)
    assert_match "Missing username and/or email argument.", output
  end
end
