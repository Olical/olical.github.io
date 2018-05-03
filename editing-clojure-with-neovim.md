{:title  "Editing Clojure with Neovim"
 :layout :post
 :date   ""
 :tags   ["clojure" "neovim"]}

I've used [Spacemacs][] since I started working with [Clojure][] a few years ago, it's an extremely powerful system on par with full IDEs such as [Cursive][]. I highly recommend either of these tools to the budding Clojure(Script) developer, they will carry you as far as you need to go and beyond.

The reason I have drifted back to [Vim][] ([Neovim][] specifically) is because I never felt quite at home within [Emacs][], which Spacemacs is built upon. I wrote JavaScript (among other languages) in Vim for around five years before I began really studying Clojure, Vim and it's nuances are pretty deeply buried within my brain and muscle memory (if that's actually a thing).

I've been working on a fresh Neovim setup in my [dotfiles][] repository and I'm finally at a point where I'm happy with it for day to day work. I extracted my current setup into [spacy-neovim][] for others to fork and build upon in their own repositories. It acts as an opinionated starting point modeled after Spacemacs that you're expected to modify to fit your needs.

This post will mainly be describing the approach I'm taking in my dotfiles and the spacy-neovim repository.

## Structure

The layout of my configuration is almost identical to my previous JavaScript setup:

 * There's a top level entry point: `init.vim`, it sources every file in the `modules/` directory.
 * A file in the root directory, `plugins.vim`, simply lists all of my dependencies for [vim-plug][] to handle.
 * The `modules/` directory contains different configuration related files.
   * `modules/core.vim` - Super basic and general configuration for the entire editor.
   * `modules/mappings.vim` - Custom mappings for things like closing hidden buffers or trimming whitespace.
   * `modules/plugins.vim` - Activates vim-plug and loads configuration files for those plugins. It also warns you if you've remove a plugin but not it's configuration file on startup.
 * Plugin configuration files are found in `modules/plugins/`, like `modules/plugins/vim-fireplace.vim`. They set plugins up and define useful bindings to access their functionality.

Speaking of which, let's have a tour of some of the most important plugins that are included.

## Plugins

### Fireplace ([tpope/vim-fireplace](https://github.com/tpope/vim-fireplace))

This is essential. If you wish to edit Clojure within Vim you'll need this plugin above all others, it gives you a way to interact with and evaluate your Clojure code via an [nREPL][] connection.

[Spacemacs]: http://spacemacs.org/
[Clojure]: https://clojure.org/
[Cursive]: https://cursive-ide.com/
[Vim]: https://www.vim.org/
[Neovim]: https://neovim.io/
[Emacs]: https://www.gnu.org/software/emacs/
[dotfiles]: https://github.com/Olical/dotfiles
[spacy-neovim]: https://github.com/Olical/spacy-neovim
[vim-plug]: https://github.com/junegunn/vim-plug
[nREPL]: https://github.com/clojure-emacs/cider-nrepl
