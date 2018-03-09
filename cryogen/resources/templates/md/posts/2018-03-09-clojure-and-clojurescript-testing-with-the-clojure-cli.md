{:title  "Clojure and ClojureScript testing with the Clojure CLI"
 :layout :post
 :date   "2018-03-09"
 :tags   ["clojure" "clojurescript" "clojure-cli" "testing"]}

This post is sort of an extension of a previous post, [Clojure projects from scratch][cpfs]. That will introduce you to structuring your project around a `deps.edn` file, here we're going to simply add a couple of dependencies that allow you to run your tests.

In a [Leiningen][] project, `lein test` will execute your Clojure tests, no questions asked. In a Clojure CLI / `deps.edn` based project we have no such command, tests have to be executed by a custom built test runner script.

You probably don't want to be writing and modifying a test runner namespace every time you add a test, that's why [test-runner][] and [cljs-test-runner][] exists. I'm the author of the latter, I hope that doesn't put you off!

## test-runner

First we'll add test-runner, the Clojure version. This will give us an equivalent to `lein test`. Add a `test` alias to your `aliases` section of your `deps.edn` file.

```clojure
{:deps ;; 1
 {org.clojure/clojure {:mvn/version "1.9.0"}
  org.clojure/clojurescript {:mvn/version "1.10.145"}}

 :aliases
 {:test ;; 2
  {:extra-paths ["test"] ;; 3
   :extra-deps
   {com.cognitect/test-runner {:git/url "git@github.com:cognitect-labs/test-runner"
                               :sha "76568540e7f40268ad2b646110f237a60295fa3c"}} ;; 4
   :main-opts ["-m" "cognitect.test-runner"]}}} ;; 5
```

Let's break this down a little, just in case you aren't super familiar with `deps.edn` just yet.

1. Map of your dependencies, here we're depending on the latest Clojure and ClojureScript. Having your language as a versioned dependency is a wonderful thing.
2. Our test alias, we'll activate it with `clojure -Atest`.
3. For Clojure tests, we need to add the test directory to the classpath.
4. Dependency on the test-runner, there may be a new commit by now. I'm waiting for my [return code fix][rcf] to be merged.
5. Set the entry namespace to the test runner.

We can now execute our tests as we would with `lein`!

```bash
$ clojure -Atest
```

At the time of writing, even if your tests fail, the return code of the process will always be 0. This means that your CLI and CI will think the tests passed just fine. I've fixed this and it may have been merged by the time you're reading this. If not, feel free to use the fixed commit from my fork.

```clojure
{:git/url "git@github.com:Olical/test-runner.git"
 :sha "427a16c634201492984d2161d305baa09ab864cd"}
```

[cpfs]: https://oli.me.uk/2018-02-26-clojure-projects-from-scratch/
[Leiningen]: https://leiningen.org/
[test-runner]: https://github.com/cognitect-labs/test-runner
[cljs-test-runner]: https://github.com/Olical/cljs-test-runner
[rcf]: https://github.com/cognitect-labs/test-runner/pull/12
