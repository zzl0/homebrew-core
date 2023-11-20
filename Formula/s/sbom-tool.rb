class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://github.com/microsoft/sbom-tool/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "2ee856c667d14f2b6a7f4081b330a8d9e9b0af18923aebacc88ed092736d7bd6"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8a51b520982ed9854d57b2d8fc7107b271c9844c74c111ce18d9aa037bbb8e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8a51b520982ed9854d57b2d8fc7107b271c9844c74c111ce18d9aa037bbb8e1"
    sha256 cellar: :any_skip_relocation, ventura:        "bbb07e840d9d97ba07aceddcf346bf02222b098bfaf56a9c3c9df15cd361e5f3"
    sha256 cellar: :any_skip_relocation, monterey:       "bbb07e840d9d97ba07aceddcf346bf02222b098bfaf56a9c3c9df15cd361e5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6be797b74091c3a50ed591ab57b7a723381d9b299245b1368d35cc54f29371f"
  end

  depends_on "dotnet"

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  def install
    bin.mkdir

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    (bin/"sbom-tool").write_env_script libexec/"Microsoft.Sbom.Tool",
                                       DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb http://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
