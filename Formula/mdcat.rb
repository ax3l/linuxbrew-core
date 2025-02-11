class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.19.0.tar.gz"
  sha256 "2e50dbb8f80b74dbed1cc69c731d8c782df35f2e968fc833b11640272d00f3cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcddb07828db6973b4badb8522a5733cde29114b3cdaa16bb7b676ccdf7faf48" => :catalina
    sha256 "aac82a12f878e80161925f6a95238a85d853040c9273e53fcaffe534843265cf" => :mojave
    sha256 "143bd89cf97a6357f6b29241f8b23a5bf71f3e0144d227196d91fe4ca486fbc6" => :high_sierra
    sha256 "e6787a0f0bfed57115883bbdd201495ffad7cae8d7c4e14e59a7b3123ed5c4df" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
