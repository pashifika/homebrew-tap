# SkillMount Homebrew formula template for the `skillmount-asm` package.
#
# Generated into Formula/skillmount-asm.rb by
# `.github/scripts/package_channels.py generate-homebrew`. Edit this template, never the
# generated formula: the tap copy is rewritten from here on every release.
#
# Provenance of the release archive this formula installs:
#   tag    v0.2.0
#   commit 329c9070316d1bea2566c0fc8c18a12a1e44b22c
class SkillmountAsm < Formula
  desc "Portable skill mounting for coding agents (asm command)"
  homepage "https://github.com/pashifika/skillmount"
  url "https://github.com/pashifika/skillmount/releases/download/v0.2.0/skillmount-v0.2.0-aarch64-apple-darwin.tar.gz"
  sha256 "daf8e311fe76d13e81c463d352beaa29e2dadf10e165a00af835c5eacb736cc9"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "asm"
    pkgshare.install "LICENSE-APACHE", "LICENSE-MIT", "VERSION"
    generate_completions_from_executable(bin/"asm", "completions", base_name: "asm")
  end

  test do
    assert_match "0.2.0", shell_output("#{bin}/asm --version")
    assert_match "Usage:", shell_output("#{bin}/asm --help")

    # SkillMount resolves its product identity from argv[0] and rejects a renamed alias, so
    # this keg must carry exactly one executable and never the paired package's command.
    refute_path_exists bin/"skillmount"

    [
      [bash_completion/"asm", "bash"],
      [zsh_completion/"_asm", "zsh"],
      [fish_completion/"asm.fish", "fish"],
    ].each do |completion, shell|
      assert_path_exists completion, "no #{shell} completion was generated"
      contents = completion.read
      assert_match "asm", contents
      refute_match(/\bskillmount\b/, contents)
    end
  end
end
