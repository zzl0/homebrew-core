class NetsurfBuildsystem < Formula
  desc "Makefiles shared by NetSurf projects"
  homepage "https://source.netsurf-browser.org/buildsystem.git"
  url "https://download.netsurf-browser.org/libs/releases/buildsystem-1.10.tar.gz"
  sha256 "3d3e39d569e44677c4b179129bde614c65798e2b3e6253160239d1fd6eae4d79"
  license "MIT"
  head "https://git.netsurf-browser.org/buildsystem.git", branch: "master"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"src").mkpath

    (testpath/"Makefile").write <<~EOS
      COMPONENT := hello
      COMPONENT_VERSION := 0.1.0
      COMPONENT_TYPE ?= binary
      include $(NSSHARED)/makefiles/Makefile.tools
      include $(NSBUILD)/Makefile.top
      INSTALL_ITEMS := $(INSTALL_ITEMS) /bin:$(BUILDDIR)/$(COMPONENT)
    EOS

    (testpath/"src/Makefile").write <<~EOS
      DIR_SOURCES := main.c
      include $(NSBUILD)/Makefile.subdir
    EOS

    (testpath/"src/main.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("Hello, world!");
        return 0;
      }
    EOS

    args = %W[
      NSSHARED=#{pkgshare}
      PREFIX=#{testpath}
    ]

    system "make", "install", *args
    assert_equal "Hello, world!", shell_output(testpath/"bin/hello")
  end
end
