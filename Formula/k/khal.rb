class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application"
  homepage "https://lostpackets.de/khal/"
  url "https://files.pythonhosted.org/packages/68/ac/e94853c63676a536b3cdd758442a5df678bbe42eed06e46673fc5ba97d72/khal-0.11.2.tar.gz"
  sha256 "8fb8d89371e53e2235953a0765e41b97e174848a688d63768477576d03f899ba"
  license "MIT"
  head "https://github.com/pimutils/khal.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0e39c9168625316bca57f9f3d091f3d67e4688f853ad682f09f447177846458"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d5add8bc50712ce725cc2c24c10e64d37e66a25e66376025b08f5ff5064f72a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec2b5ca208925b0d2dcc1d7fb2f9fa2f8fa4c49b9b1fcc3c1debf89378497be8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2713acc1441967abdb6a2c5e53c130a3699d221d82447f2f8d0efa8ecddcfd97"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca25af2e66b7e7cc47eaa014257cacf34fc7dedeb644acf519f1e5468bbe0159"
    sha256 cellar: :any_skip_relocation, ventura:        "d24cb3c1925c2ca5c0ca34b27ff02a8cc1e7336e14e96e77623d16001d3f2acc"
    sha256 cellar: :any_skip_relocation, monterey:       "a9a1bfc0d045479dcc69f4528fc6b3e07b1c1787e0f44ee9fbfd6bae42ec4b0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4205a9a014ef6f2371bdb85920b68da88cf3afc4d2edde68efa3f99a8ac15810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0bf88d186d4b442d7d5492db7b2c4e852715eda1614f1dab2eece956e2fe507"
  end

  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "six"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/40/d7/06707c968c2ce93e60eeb9f849c84e96c710660054e09791ffa3e5ef04ad/icalendar-5.0.10.tar.gz"
    sha256 "34f0ca020b804758ddf316eb70d1d46f769bce64638d5a080cb65dd46cfee642"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/b2/e2/adf17c75bab9b33e7f392b063468d50e513b2921bbae7343eb3728e0bc0a/tzlocal-5.1.tar.gz"
    sha256 "a5ccb2365b295ed964e0a98ad076fe10c495591e75505d34f154d60a7f1ed722"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/5f/cf/2f01d2231e7fb52bd8190954b6165c89baa17e713c690bdb2dfea1dcd25d/urwid-2.2.2.tar.gz"
    sha256 "5f83b241c1cbf3ec6c4b8c6b908127e0c9ad7481c5d3145639524157fc4e1744"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/".calendar/test/01ef8547.ics").write <<~EOS
      BEGIN:VCALENDAR
      VERSION:2.0
      BEGIN:VEVENT
      DTSTART;VALUE=DATE:20130726
      SUMMARY:testevent
      DTEND;VALUE=DATE:20130727
      LAST-MODIFIED:20130725T142824Z
      DTSTAMP:20130725T142824Z
      CREATED:20130725T142824Z
      UID:01ef8547
      END:VEVENT
      END:VCALENDAR
    EOS
    (testpath/".config/khal/config").write <<~EOS
      [calendars]
      [[test]]
      path = #{testpath}/.calendar/test/
      color = light gray
      [sqlite]
      path = #{testpath}/.calendar/khal.db
      [locale]
      firstweekday = 0
      [default]
      default_calendar = test
    EOS
    system "#{bin}/khal", "--no-color", "search", "testevent"
  end
end
