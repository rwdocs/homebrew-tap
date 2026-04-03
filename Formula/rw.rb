class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/rwdocs/rw"
  version "0.1.22"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.22/rw-aarch64-apple-darwin.tar.xz"
      sha256 "aad0d230a4f95c4fce1bd847715addb80276312e7dd857f564cb6397d0c58830"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.22/rw-x86_64-apple-darwin.tar.xz"
      sha256 "ea5968dd1c5c4f05fe5719ad9ea50a6d029957abb753959c9c3cd19e5b051cdf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.22/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "18e9c36100f159a67a63d875b7da12637d20f61ad956d7e79e798bbc0d67af75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.22/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07ca1ed3c49241bbe46a4ef66a3d8b347d84e71e0fde6b76693f8c2501189e81"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
