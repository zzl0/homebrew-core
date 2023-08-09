class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "6e60239c6c26315e3aeac6ede9f485d39d11548293536f0c0ae06d52fc275fc7"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3acab1120e894eb29798d3bdc138af7ff30ff1a0ee43bec7ce9b03a343eec4c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ff2eed4c820638ed1aa921ddad1babf03171ec06984be9b69d4a05ddae8347"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3acab1120e894eb29798d3bdc138af7ff30ff1a0ee43bec7ce9b03a343eec4c0"
    sha256 cellar: :any_skip_relocation, ventura:        "aeb308309c71adbef14878571ad83fa5574165d97a6c71fde64c5c1dfc7d648a"
    sha256 cellar: :any_skip_relocation, monterey:       "aeb308309c71adbef14878571ad83fa5574165d97a6c71fde64c5c1dfc7d648a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f46782fca6175ab1507a558299dbc7b82629b621bdead3e3582623ec3001283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4ff1880b43d2913d9c9e3b8bfca32faa405a2cb4886ba7642e8f6d37c2ca400"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", "completion")
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~EOS
      syntax = "proto3";
      package examplepb;
    EOS

    (testpath/"buf.yaml").write <<~EOS
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - DEFAULT
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    EOS

    expected = <<~EOS
      invalidFileName.proto:1:1:Filename "invalidFileName.proto" should be \
      lower_snake_case.proto, such as "invalid_file_name.proto".
      invalidFileName.proto:2:1:Files with package "examplepb" must be within \
      a directory "examplepb" relative to root but were in directory ".".
      invalidFileName.proto:2:1:Package name "examplepb" should be suffixed \
      with a correctly formed version, such as "examplepb.v1".
    EOS
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end
