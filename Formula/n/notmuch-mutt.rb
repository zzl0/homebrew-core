class NotmuchMutt < Formula
  desc "Notmuch integration for Mutt"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.38.1.tar.xz"
  sha256 "c1418760d0e53efad1f35267eb99a50f8b7fa2855c1473e0a4c982b86f8ecdd4"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    formula "notmuch"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6faa1d5cd621e4761715509b98d488eb99bd49db07d92c46e5cf0c6f8dad29dc"
    sha256 cellar: :any,                 arm64_ventura:  "79e313438c9332b53b8904e17415a516e3eebcc189de92234e1616f51c0d4edd"
    sha256 cellar: :any,                 arm64_monterey: "e2bacabd6507b8c64a4bd24940fc6cc3785a95bfda67a7a18ab7049c8bee52ec"
    sha256 cellar: :any,                 arm64_big_sur:  "705d5c69ad1b0cfe59609785e726cdd1af302c0a993df8b6ee0a7964c2b97cc9"
    sha256 cellar: :any,                 sonoma:         "81db451989ce30884711a60fcf82126ad81fd4847a79574350960670353b43a3"
    sha256 cellar: :any,                 ventura:        "ed203220afb16b5129fc349e4bd7f0bf672064f23d2217eec2f75b22ae03846e"
    sha256 cellar: :any,                 monterey:       "e5541e9d930433b0449668bb412e8819e2b9b2396e5bf14947d738b4a105a792"
    sha256 cellar: :any,                 big_sur:        "7fed64a33a46e55518e2d0b9841886d6874097e2e7151e0792f20b9883cfd8e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23a0c5fe3c67f06aaf99c9082a7995ccd642ea878af92acbf9f09a9f0e3de7f5"
  end

  depends_on "notmuch"
  depends_on "perl"
  depends_on "readline"

  resource "Date::Parse" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
    sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
  end

  resource "IO::Lines" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/IO-Stringy-2.113.tar.gz"
    sha256 "51220fcaf9f66a639b69d251d7b0757bf4202f4f9debd45bdd341a6aca62fe4e"
  end

  resource "Devel::GlobalDestruction" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.14.tar.gz"
    sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
  end

  resource "Sub::Exporter::Progressive" do
    url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
    sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
  end

  resource "File::Remove" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/File-Remove-1.61.tar.gz"
    sha256 "fd857f585908fc503461b9e48b3c8594e6535766bc14beb17c90ba58d5dc4975"
  end

  resource "Term::ReadLine::Gnu" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.46.tar.gz"
    sha256 "b13832132e50366c34feac12ce82837c0a9db34ca530ae5d27db97cf9c964c7b"
  end

  resource "String::ShellQuote" do
    url "https://cpan.metacpan.org/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "Mail::Box::Maildir" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Box-3.010.tar.gz"
    sha256 "ae194fa250c545c9b9153e3fb5103cab29f79cf2acd4e9fd75cec532201a9564"
  end

  resource "Mail::Header" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MailTools-2.21.tar.gz"
    sha256 "4ad9bd6826b6f03a2727332466b1b7d29890c8d99a32b4b3b0a8d926ee1a44cb"
  end

  resource "Mail::Reporter" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Mail-Message-3.014.tar.gz"
    sha256 "22859e09a0bd2dae3ca7b3148bff3fb6602b479a00419fe048a21807f26aeb33"
  end

  resource "MIME::Types" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/MIME-Types-2.24.tar.gz"
    sha256 "629e361f22b220be50c2da7354e23c0451757709a03c25a22f3160edb94cb65f"
  end

  resource "Object::Realize::Later" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MARKOV/Object-Realize-Later-0.21.tar.gz"
    sha256 "8f7b9640cc8e34ea92bcf6c01049a03c145e0eb46e562275e28dddd3a8d6d8d9"
  end

  def install
    system "make", "V=1", "prefix=#{prefix}", "-C", "contrib/notmuch-mutt", "install"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      next if r.name.eql? "Term::ReadLine::Gnu"

      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    resource("Term::ReadLine::Gnu").stage do
      # Prevent the Makefile to try and build universal binaries
      ENV.refurbish_args

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                     "--includedir=#{Formula["readline"].opt_include}",
                     "--libdir=#{Formula["readline"].opt_lib}"
      system "make", "install"
    end

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system "#{bin}/notmuch-mutt", "search", "Homebrew"
  end
end
