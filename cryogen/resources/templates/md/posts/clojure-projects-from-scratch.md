{:title  "Clojure projects from scratch"
 :layout :post
 :date   "..."
 :tags   ["clojure"]
 :klipse false
 :draft? true}

This post is intended primarily for two groups of people:

1. People just starting out in Clojure, who know a bit of the language but don't know how to go about structuring a real project.
2. Seasoned Clojurians who wish to see how to structure a project with the new Clojure CLI + `deps.edn` and not `lein` or `boot` (even though they're still awesome).

My goal is to teach you how to go from an empty directory, to a project you can run, test, compile and (if you wish to) publish with ease. I hope that by the time you have your tooling complete you'll actually understand it all, it won't be a mystical black box that barfs out jar files for you to run.

There's won't be an awful lot of the Clojure language here, so don't worry if you're still getting your head around `defn`s and `keyword?`s. The only code example will be a "Hello, World!", if that helps.

> Note: This post assumes usage of Linux, OSX or similar, I'm afraid it isn't intended for Windows users since I just don't have the knowledge to help you there. Some of the information will apply, but you'll have to adapt things, I'm sure you can find Windows specific guides for the parts that don't fit.

I'm also not going into what editor you should use because that's a book in itself. If you're totally at a loss, check out [Cursive][], although I use [Spacemacs][] because I can't survive without good Vim emulation. There's probably a great plugin for your editor of choice and instructions on getting started, have a Google.

A lot of what I'm going to be talking about can be found in practice in [github.com/robert-stuttaford/bridge][bridge], you may want to have a peruse at some point.

## Installing the Clojure CLI

To run Clojure you'll need the command line tool (introduced around the time of Clojure 1.9) that manages dependencies and allows you execute things.

If you're on OSX, you can use `brew` to install the CLI.

```bash
brew install clojure
```

I found that I could install it through the Arch Linux package manager, `pacman`, too. But this version was slightly out of date at the time of writing, so I don't recommend this just yet. If you're on Linux you can run the manual installer easily enough.

> Note: Bfore running this, make sure you have `curl`, `rlwrap` (optional, allows you to use `clj` instead of `clojure` which has slightly better readline editing) and Java installed.

```bash
curl -O https://download.clojure.org/install/linux-install-1.9.0.326.sh
sudo bash linux-install-1.9.0.326.sh
```

To update, use the package manager you used for the installation or find the latest Linux installer URL on the [getting started][getting-started] page.

You should now be able to drop into a Clojure REPL with one command! You can use `clojure` or `clj`, the latter has a slightly better editing experience but requires you to have `rlwrap` installed.

```bash
λ clj
Clojure 1.9.0
user=> (+ 10 15)
25
```

[cursive]: https://cursive-ide.com/
[spacemacs]: http://spacemacs.org/
[bridge]: https://github.com/robert-stuttaford/bridge
[getting-started]: https://clojure.org/guides/getting_started
