class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.6/mighttpd2-3.4.6.tar.gz"
  sha256 "fe14264ea0e45281591c86030cad2b349480f16540ad1d9e3a29657ddf62e471"
  revision 1

  bottle do
    sha256 "bcea435a9feba47df19b64d9fac972a1df8f580647204b07a73b2ade2e14c479" => :catalina
    sha256 "68e563757fb405de41a4312c03f7b72da99586430ea8f0aff98fdab48213635f" => :mojave
    sha256 "7b033c6ce128310465134a09bae1ef3df9cb630db732167a06028c1a5773576e" => :high_sierra
    sha256 "7652478fdda8d75605a033d776ef5020bb8e5a231ba0ab2991906feab9a80af9" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-ftls", *std_cabal_v2_args
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
