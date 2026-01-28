class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/yumike/rw"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.0/rw-aarch64-apple-darwin.tar.xz"
      sha256 "c4500dbf4d51f7a68dd2095f597a40c1145775ffe768d273f8e2f5b7ff2bd50d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.0/rw-x86_64-apple-darwin.tar.xz"
      sha256 "6a907e8626d8022b704946a8ce7d9fe03a7a48ae7b9396313a0b3d0c098c57d8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.0/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a2bc892987791389ba9d2b215603670355bf5f7f3d11cf9c0c4df7b2f797599c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.0/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d892d878c27b32c4ad05c1523fe91133ca343416c0b8140dfa6abc5fbae3fae"
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
