class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.12.1/fonttools-4.12.1.zip"
  sha256 "4b790ebb2e009282b84db896cb6f31332038c79829b5c29c432481b6df058ece"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d30c6decd463bbdceb1475bdb555fd04d791867237dd6d05a428a4d719c842c" => :catalina
    sha256 "0aca64c1194c4a952f5bb30bd0c65c1ad5d2064346c7c20e6ae578543149213a" => :mojave
    sha256 "53971cbe63b47de282cbfd82b2155a78bb9c265a09c5b799f8a84b9b5bee525a" => :high_sierra
    sha256 "1b681487f6d05f61af00264b4f0824a71039145c938d1a83776c47693c7042ed" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    unless OS.mac?
      assert_match "usage", shell_output("#{bin}/ttx -h")
      return
    end
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
