class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/yumike/rw"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.1/rw-aarch64-apple-darwin.tar.xz"
      sha256 "258ff48c79dc27a931842e76694e2c04387e6d3780f61a8f7c5a21dd5dd512f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.1/rw-x86_64-apple-darwin.tar.xz"
      sha256 "c5215162f91310507cf67c4a33a6104ebf6d38ee6aa38bae645809d7852a07bf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.1/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "003af54989ddaa634d42312e2d1ffa89db21ff721a20cca2dff5c6fce5a7dea2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.1/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7801a5ff6897927e2e59d5fbf1536077e0b3a85edce6267fb48a0dda8b0f58fb"
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
