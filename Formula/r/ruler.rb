class Ruler < Formula
  desc "Tool to abuse Exchange services"
  homepage "https://github.com/sensepost/ruler"
  url "https://github.com/sensepost/ruler/archive/refs/tags/2.4.1.tar.gz"
  sha256 "ff46d8604d5d8d6a1442956b27e66714b441447db42bf5ff8e61df16f0eae18d"
  license "CC-BY-NC-SA-4.0"
  head "https://github.com/sensepost/ruler.git", branch: "master"

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
