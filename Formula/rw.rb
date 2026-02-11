class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/yumike/rw"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.4/rw-aarch64-apple-darwin.tar.xz"
      sha256 "e1b39430d03dcc86c959d21319128ef0a25c5e63e9f3e2aa02e5f16b5a42e1f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.4/rw-x86_64-apple-darwin.tar.xz"
      sha256 "d3b7388f1d401e16f85ca57c4ca10a17d3a21afe52fccb3e4496bb59162be2bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.4/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d7d4fcff21787ea8e1c5cb377390d853508583e53654343bbc3f8f12c3d17371"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.4/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fe4609ce5f69c438eab51dedc95235acaefa29e0306ba2dc612d87a66155346d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rw" if OS.mac? && Hardware::CPU.arm?
    bin.install "rw" if OS.mac? && Hardware::CPU.intel?
    bin.install "rw" if OS.linux? && Hardware::CPU.arm?
    bin.install "rw" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
