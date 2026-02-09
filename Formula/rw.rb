class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/yumike/rw"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.3/rw-aarch64-apple-darwin.tar.xz"
      sha256 "00781b3e0ae365598c5f604418d6cd2ccbae4c6a89fa2c6e30df52896d412cf6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.3/rw-x86_64-apple-darwin.tar.xz"
      sha256 "a1f35c9c1d0398972a011f5f54c9da6d83b41388dd49537846127b3a114a8d80"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.3/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37680407b991d0a7d6b132c21f52cea932503f5c734f4cfb58bad4b6eca0ef6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.3/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c9c1e62b520cb19f7d9956dc755ac51c397ce2b51cf4e4fa31cc7481cba05238"
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
