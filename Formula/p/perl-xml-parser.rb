class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/toddr/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz"
  sha256 "d331332491c51cccfb4cb94ffc44f9cd73378e618498d4a37df9e043661c515d"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/toddr/XML-Parser.git", branch: "master"

  uses_from_macos "perl"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
    system "make", "install"
  end

  test do
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5" if OS.linux?
    system "perl", "-e", "require XML::Parser;"
  end
end
