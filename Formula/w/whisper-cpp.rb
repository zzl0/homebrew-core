class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggerganov/whisper.cpp"
  url "https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b2e34e65777033584fa6769a366cdb0228bc5c7da81e58a5e8dc0ce94d0fb54e"
  license "MIT"
  head "https://github.com/ggerganov/whisper.cpp.git", branch: "master"

  def install
    system "make"
    bin.install "main" => "whisper-cpp"

    pkgshare.install ["samples/jfk.wav", "models/for-tests-ggml-tiny.bin"]
  end

  test do
    cp [pkgshare/"jfk.wav", pkgshare/"for-tests-ggml-tiny.bin"], testpath

    system "#{bin}/whisper-cpp", "samples", "-m", "for-tests-ggml-tiny.bin"
    assert_equal 0, $CHILD_STATUS.exitstatus, "whisper-cpp failed with exit code #{$CHILD_STATUS.exitstatus}"
  end
end
