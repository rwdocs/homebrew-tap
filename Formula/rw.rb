class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/rwdocs/rw"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.9/rw-aarch64-apple-darwin.tar.xz"
      sha256 "f16fb5d11f18cff65d12a1a1803a17a8836b1e28925f3777bec92b71fd2a31a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.9/rw-x86_64-apple-darwin.tar.xz"
      sha256 "a11d6514f4bcb56d51171b922f53f042dd4b02e6755520d9217fb191df19fe12"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.9/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "183fd3d54401561759dc24947466a1a7c040c46359b786f134b3df2fd9a82b0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.9/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4094727f03df801f8f2a1d5c0cdaf942dc4312c6ac01250bbeb048e111085596"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
