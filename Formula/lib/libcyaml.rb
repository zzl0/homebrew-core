class Libcyaml < Formula
  desc "C library for reading and writing YAML"
  homepage "https://github.com/tlsa/libcyaml"
  url "https://github.com/tlsa/libcyaml/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "8dbd216e1fce90f9f7cca341e5178710adc76ee360a7793ef867edb28f3e4130"
  license "ISC"

  depends_on "libyaml"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples/numerical/main.c" => "test.c"
  end

  test do
    flags = %W[
      -I#{include} -I#{Formula["libyaml"].opt_include}
      -L#{lib} -L#{Formula["libyaml"].opt_lib}
      -lcyaml -lyaml
      -o test
    ]

    system ENV.cc, pkgshare/"test.c", *flags

    (testpath/"test.yaml").write "name: Numbers\ndata:\n- 1\n- 2\n- 4\n- 8\n"
    expected_output = "Numbers:\n  - 1\n  - 2\n  - 4\n  - 8\n"
    assert_equal expected_output, shell_output("#{testpath}/test #{testpath}/test.yaml")
  end
end
