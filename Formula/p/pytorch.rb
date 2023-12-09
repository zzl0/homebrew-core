class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v2.1.0",
      revision: "7bcf7da3a268b435777fe87c7794c382f444e86d"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2673d638d0cac286ae5613deef32d2da9ba63275776f8211e58975578b50934d"
    sha256 cellar: :any,                 arm64_ventura:  "677e8a8d53d18009e426991c91084abc5d6bd95472f04e81d3f89bd973a938e7"
    sha256 cellar: :any,                 arm64_monterey: "ffd3d3449e95ade737e45158b21ebb6578013f762085918eb15a6255ba7338ad"
    sha256 cellar: :any,                 sonoma:         "b4c09c8d1f71c7ebe8fc02493b4671dc77904a5faca18914338f53ec824b58c9"
    sha256 cellar: :any,                 ventura:        "52306dbc78c7cba778ab2da899c5739cb5595de90117057f7bff069170e0b0bf"
    sha256 cellar: :any,                 monterey:       "fa196a022d59f43f5f4565c472a28417f4fc18a87e0ce9c2a05c6e8078553564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3442f68d930f32128bfd495052650233a6aa4682383a67fd8bf821d5d0d5fc1a"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on xcode: :build
  depends_on "eigen"
  depends_on "libuv"
  depends_on macos: :monterey # MPS backend only supports 12.3 and above
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python-filelock"
  depends_on "python-jinja"
  depends_on "python-networkx"
  depends_on "python-sympy"
  depends_on "python-typing-extensions"
  depends_on "pyyaml"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "fmt", because: "both install `include/fmt/args.h` headers"

  resource "opt-einsum" do
    url "https://files.pythonhosted.org/packages/7d/bf/9257e53a0e7715bc1127e15063e831f076723c6cd60985333a1c18878fb8/opt_einsum-3.3.0.tar.gz"
    sha256 "59f6475f77bbc37dcf7cd748519c0ec60722e91e63ca114e68821c0c54a46549"
  end

  def install
    python_exe = Formula["python@3.11"].opt_libexec/"bin/python"
    args = %W[
      -GNinja
      -DBLAS=OpenBLAS
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=ON
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DPYTHON_EXECUTABLE=#{python_exe}
      -DUSE_CUDA=OFF
      -DUSE_DISTRIBUTED=ON
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_OPENMP=ON
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
      -DUSE_SYSTEM_PYBIND11=ON
    ]
    args << "-DUSE_MPS=ON" if OS.mac?

    ENV["LDFLAGS"] = "-L#{buildpath}/build/lib"

    # Update references to shared libraries
    inreplace "torch/__init__.py" do |s|
      s.sub!(/here = os.path.abspath\(__file__\)/, "here = \"#{lib}\"")
      s.sub!(/get_file_path\('torch', 'bin', 'torch_shm_manager'\)/, "\"#{bin}/torch_shm_manager\"")
    end

    inreplace "torch/utils/cpp_extension.py", "_TORCH_PATH = os.path.dirname(os.path.dirname(_HERE))",
                                              "_TORCH_PATH = \"#{opt_prefix}\""

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, *args

    # Avoid references to Homebrew shims
    inreplace "build/caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    # test that C++ libraries are available
    (testpath/"test.cpp").write <<~EOS
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"

    # test that the `torch` Python module is available
    system libexec/"bin/python", "-c", <<~EOS
      import torch
      t = torch.rand(5, 3)
      assert isinstance(t, torch.Tensor), "not a tensor"
      assert torch.distributed.is_available(), "torch.distributed is unavailable"
    EOS

    if OS.mac?
      # test that we have the MPS backend
      system libexec/"bin/python", "-c", <<~EOS
        import torch
        assert torch.backends.mps.is_built(), "MPS backend is not built"
      EOS
    end
  end
end
