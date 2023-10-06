class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/f2/27/f4e7616a139c84a04edb7778db2b3cfb77348ab73020ff232b6551fa8bdd/ykdl-1.8.2.tar.gz"
  sha256 "c689b8e4bf303d1582e40d5039539a1a754f7cf897bce73ec57c7e874e354b19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e518af017c28127eae157236fe069b98e544ceaa5557b0f1d385880604624629"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bfd95765b3413aae9546fe898949ee266661a4d6bf7251ecedfa7e80d3d85d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9669d8abc2e7007ab762d54ac5f46d2c06d6414945f93d676614761290e9042"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6577df8df4b3a354e9457740ae9c97249062195f8db9ea293238ac664aab15d"
    sha256 cellar: :any_skip_relocation, sonoma:         "40eb478a3218e795d9b35ac00336947fbf26c486410253ebba3739b82026aae9"
    sha256 cellar: :any_skip_relocation, ventura:        "25267a1e6a5b19996364dc210a820182dbd979c802a157fa9f063438b6a5eda9"
    sha256 cellar: :any_skip_relocation, monterey:       "40352d2bfbc62a67104fac49ce087902e0f617b1805106a93d834c6fedf48c60"
    sha256 cellar: :any_skip_relocation, big_sur:        "899a254962e5978a6c267a1fbab79aa69870c19c3d542b46da81fbe9d120b74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcff8c2fb5974a8b76afe84436346f39295e613b9a947e57bab68b8650cd972c"
  end

  depends_on "python@3.12"

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jsengine" do
    url "https://files.pythonhosted.org/packages/bc/0a/1321515de90de02f9c98ac12dfa9763ae93d658ed662261758dc5e902986/jsengine-1.0.7.post1.tar.gz"
    sha256 "2d0d0dcb46d5cb621f21ea1686bdc26a7dc4775607fc85818dd524ba95e0a0fd"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/29/6a/ddad4d36396fb3daf12c79c075a0a35b6eb01e9d0cb9ae742401e8aacb08/m3u8-3.6.0.tar.gz"
    sha256 "d7f17e357e63f90400ae9804bcd193b8935fcca4eb18659aa94f1d7af3b36451"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    video_url = "https://v.youku.com/v_show/id_XNTAwNjY3MjU3Mg==.html"
    output = shell_output("#{bin}/ykdl --info #{video_url} 2>&1", 1)
    assert_match "CRITICAL:YKDL", output
    assert_match version.to_s, shell_output("#{bin}/ykdl -h")
  end
end
