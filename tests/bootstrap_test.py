"""Exercise setup in disposable homes with package and plugin installs mocked."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]


class BootstrapTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces"
        self.home.mkdir()
        self.env = dict(os.environ, HOME=str(self.home))
        for name in ("XDG_CONFIG_HOME", "ZDOTDIR", "NVM_DIR"):
            self.env.pop(name, None)
        self.install_log = Path(self.temp.name) / "installs.log"
        mocks = Path(self.temp.name) / "mocks.sh"
        mocks.write_text('''
function xcode-select { return 0; }
function brew { printf 'brew %s\\n' "$*" >> "$DOTFILES_TEST_LOG"; }
function /opt/homebrew/bin/brew { brew "$@"; }
function /usr/local/bin/brew { brew "$@"; }
function npm { printf 'npm %s\\n' "$*" >> "$DOTFILES_TEST_LOG"; }
function nvim { printf 'nvim %s\\n' "$*" >> "$DOTFILES_TEST_LOG"; }
function code { printf 'code %s\\n' "$*" >> "$DOTFILES_TEST_LOG"; }
function git {
  if [[ "$1" == clone ]]; then
    mkdir -p "${@: -1}/.git"
  else
    command git "$@"
  fi
}
''')
        nvm_dir = Path(self.temp.name) / "nvm"
        nvm_dir.mkdir()
        (nvm_dir / "nvm.sh").write_text('''
function nvm {
  if [[ "$1" == current ]]; then
    printf 'v24.0.0\\n'
  else
    printf 'nvm %s\\n' "$*" >> "$DOTFILES_TEST_LOG"
  fi
}
''')
        self.env.update(
            BASH_ENV=str(mocks), NVM_DIR=str(nvm_dir),
            DOTFILES_TEST_LOG=str(self.install_log),
        )

    def run_bootstrap(self, *args):
        return subprocess.run(
            ["/bin/bash", str(REPO / "bootstrap.sh"), *args],
            env=self.env, cwd="/tmp", capture_output=True, text=True, check=True,
        )

    def test_dry_run_has_no_writes(self):
        result = self.run_bootstrap("--dry-run")
        self.assertEqual(list(self.home.iterdir()), [])
        self.assertFalse(self.install_log.exists())
        self.assertIn("install Node LTS", result.stdout)

    def test_backups_identity_broken_links_and_reruns(self):
        old_git = '[user]\n name = Work User\n email = work@example.com\n'
        (self.home / ".gitconfig").write_text(old_git)
        (self.home / ".tmux.conf").symlink_to("/missing/config")
        old_nvim = self.home / ".config/nvim"
        old_nvim.mkdir(parents=True)
        (old_nvim / "init.lua").write_text("-- previous editor config\n")
        self.run_bootstrap()
        installs = self.install_log.read_text()
        self.assertIn("brew bundle install", installs)
        self.assertIn("nvm install --lts", installs)
        self.assertIn("nvim --headless", installs)
        self.assertIn("code --install-extension vscodevim.vim", installs)
        self.assertEqual((self.home / ".gitconfig.local").read_text(), old_git)
        self.assertEqual((self.home / ".config/nvim").resolve(), REPO / "nvim")
        backup_roots = list((self.home / ".dotfiles-backups").iterdir())
        self.assertEqual(len(backup_roots), 1)
        backup = backup_roots[0] / str(self.home).lstrip("/")
        self.assertEqual((backup / ".gitconfig").read_text(), old_git)
        self.assertTrue((backup / ".tmux.conf").is_symlink())
        self.assertTrue((backup / ".config/nvim/init.lua").is_file())
        git = subprocess.run(
            ["git", "config", "--global", "--includes", "user.email"], env=self.env,
            capture_output=True, text=True, check=True,
        )
        self.assertEqual(git.stdout.strip(), "work@example.com")
        before = {str(p): p.lstat().st_mtime_ns for p in self.home.rglob("*")}
        self.run_bootstrap()
        after = {str(p): p.lstat().st_mtime_ns for p in self.home.rglob("*")}
        self.assertEqual(before, after)

    def test_custom_config_paths_and_local_settings(self):
        self.env["XDG_CONFIG_HOME"] = str(self.home / "custom config")
        self.env["ZDOTDIR"] = str(self.home / "custom zsh")
        (self.home / ".gitconfig.local").write_text("[user]\n email = local@example.com\n")
        (self.home / ".gitconfig").write_text("[core]\n editor = vim\n")
        self.run_bootstrap()
        self.assertEqual((self.home / "custom zsh/.zshrc").resolve(), REPO / ".zshrc")
        self.assertEqual((self.home / "custom config/nvim").resolve(), REPO / "nvim")
        self.assertIn("local@example.com", (self.home / ".gitconfig.local").read_text())
        settings = self.home / "Library/Application Support/Code/User/settings.json"
        self.assertEqual(settings.resolve(), REPO / "user_settings.json")


if __name__ == "__main__":
    unittest.main()
