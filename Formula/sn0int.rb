class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.19.1.tar.gz"
  sha256 "4720736805bec49102f0622ba6b68cc63da0a023a029687140d5b4d2a4d637dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "618417dd910df3bb10c461c4e5b41f202c23ce24bf39043e5b88e544bc56df0a" => :catalina
    sha256 "cff5e42d3b5e9e44b92f437601ef1764f93df0f5bb259ec0d683cd4d2be59e83" => :mojave
    sha256 "66382b358f95db51620653c1120e903dd009a8a2e4be25c759593a01956df48d" => :high_sierra
    sha256 "51e37b841efd35b29f3b2f41759e30d6e53b0fefac2d02ae8c470538ef8b7b31" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"
  depends_on "libseccomp" unless OS.mac?

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    system "#{bin}/sn0int completions bash > sn0int.bash"
    system "#{bin}/sn0int completions fish > sn0int.fish"
    system "#{bin}/sn0int completions zsh > _sn0int"

    bash_completion.install "sn0int.bash"
    fish_completion.install "sn0int.fish"
    zsh_completion.install "_sn0int"

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system "#{bin}/sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end
