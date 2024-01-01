class Libwapcaplet < Formula
  desc "String internment library"
  homepage "https://www.netsurf-browser.org/projects/libwapcaplet/"
  url "https://download.netsurf-browser.org/libs/releases/libwapcaplet-0.4.3-src.tar.gz"
  sha256 "9b2aa1dd6d6645f8e992b3697fdbd87f0c0e1da5721fa54ed29b484d13160c5c"
  license "MIT"
  head "https://git.netsurf-browser.org/libwapcaplet.git", branch: "master"

  depends_on "netsurf-buildsystem" => :build

  def install
    args = %W[
      NSSHARED=#{Formula["netsurf-buildsystem"].opt_pkgshare}
      PREFIX=#{prefix}
    ]

    system "make", "install", "COMPONENT_TYPE=lib-shared", *args
    system "make", "install", "COMPONENT_TYPE=lib-static", *args
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libwapcaplet/libwapcaplet.h>

      int main() {
          lwc_error rc;

          lwc_string *str;
          rc = lwc_intern_string("Hello world!", 12, &str);
          if (rc != lwc_error_ok) return 1;

          printf("%.*s", (int) lwc_string_length(str), lwc_string_data(str));
          lwc_string_destroy(str);
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lwapcaplet", "-o", "test"
    assert_equal "Hello world!", shell_output(testpath/"test")
  end
end
