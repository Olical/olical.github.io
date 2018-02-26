{:title  "Clojure projects from scratch"
 :layout :post
 :date   "2018-02-26"
 :tags   ["clojure"]}

This post is intended _primarily_ for two groups of people:

1. People just starting out in Clojure, who know parts of the language but don't know how to begin structuring a real project.
2. Seasoned Clojurians who wish to see how to structure a project with the new Clojure CLI + `deps.edn` and not `lein` or `boot` (even though they're still awesome).

My goal is to teach you how to go from an empty directory, to a project you can run, test, compile and (if you wish to) publish with ease. We're going to get there through a series of relatively small steps so you can understand all the tools you're using.

There won't be an awful lot of Clojure code here, so don't worry if you're still getting your head around the language itself. The only code example will be a "Hello, World!", if that helps.

> Note: This post assumes usage of Linux, OSX or similar, I'm afraid it isn't intended for Windows users since I just don't have the knowledge to help you there. Some of the information will apply, but you'll have to adapt things, I'm sure you can find Windows specific guides for the parts that don't fit.

I'm not going into what editor you should use because that's a book in itself. If you're totally at a loss, check out [Cursive][], although I use [Spacemacs][] because I can't survive without good Vim emulation. There's probably a great plugin for your editor of choice and instructions on getting started, have a Google.

A lot of what I'm going to be talking about can be found in practice in [github.com/robert-stuttaford/bridge][bridge], you may want to have a peruse at some point.

## Installing the Clojure CLI

To run Clojure you'll need the command line tool (introduced around the time of Clojure 1.9) that manages dependencies and allows you execute code.

If you're on OSX, you can use `brew` to install the CLI.

```bash
$ brew install clojure
```

I have found that I could install it through the Arch Linux package manager although it was slightly out of date at the time of writing, so I don't recommend this just yet. If you're on Linux you can run the manual installer easily enough.

```bash
$ curl -O https://download.clojure.org/install/linux-install-1.9.0.326.sh
$ sudo bash linux-install-1.9.0.326.sh
```

To update, use the package manager you used for the installation or find the latest Linux installer URL on the [getting started][getting-started] page.

You should now be able to drop into a Clojure REPL with one command. You can run `clojure` or `clj` in your terminal, the latter has a slightly better editing experience but requires you to have `rlwrap` installed.

```bash
$ clj
Clojure 1.9.0
user=> (+ 10 15)
25
```

## Initial files

Presuming our project is called `hey`, let's go ahead and create these directories and files:

```bash
$ mkdir -p hey/{src/hey,test/hey}
$ cd hey
$ touch src/hey/core.clj test/hey/core_test.clj
```

This provides us with the following directory structure:

```
$ tree
.
├── src
│   └── hey
│       └── core.clj
└── test
    └── hey
        └── core_test.clj

4 directories, 2 files
```

Let's insert some content into these files:

### src/hey/core.clj

```clojure
(ns hey.core)

(defn -main []
  (println "Hello, World!"))
```

### test/hey/core\_test.clj

```clojure
(ns hey.core-test
  (:require [clojure.test :as t]
            [hey.core :as sut]))

(t/deftest basic-tests
  (t/testing "it says hello to everyone"
    (t/is (= (with-out-str (sut/-main)) "Hello, World!\n"))))
```

The main namespace simply prints "Hello, World!" when executed and the test confirms that functionality.

## Running your code

Now that we have a bare bones program and test file in our project directory, we're probably going to want to run it. We can do that with the Clojure CLI, go ahead and execute the following:

```bash
$ clj -m hey.core
```

You should see "Hello, World!" printed in your terminal. Let's try jumping into a REPL so we can interact with our code directly:

```bash
$ clj
Clojure 1.9.0
user=> (load "hey/core")
nil
user=> (in-ns 'hey.core)
#object[clojure.lang.Namespace 0x2072acb2 "hey.core"]
hey.core=> (-main)
Hello, World!
nil
```

If your editor supports Clojure, you can probably connect a REPL and interact with your code through there too. With spacemacs I would type `,'` to "jack in" with CIDER. I can then use `,ee` to evaluate expressions as I work.

## Testing

We have a test file but no way to run it. We could create our own test runner namespace that executed `clojure.test/run-all-tests`, but that requires telling it about every testing namespace we have in our project. It gets tedious after a while, so let's get something that does it for us.

Create a file called `deps.edn` at the top of your project and add the following to it:

### deps.edn

```clojure
{:paths ["src"]

 :deps
 {org.clojure/clojure {:mvn/version "1.9.0"}}

 :aliases
 {:test
  {:extra-paths ["test"]
   :extra-deps
   {com.cognitect/test-runner {:git/url "git@github.com:cognitect-labs/test-runner"
                               :sha "5f2b5c2efb444df76fb5252102b33f542ebf7f58"}}
   :main-opts ["-m" "cognitect.test-runner"]}}}
```

Let's break this down:

* `:paths` tells Clojure where to look for our source files.
* `:deps` is where we specify our dependencies, right now all we're depending on is Clojure 1.9.0.
* `:aliases` is where we specify special overrides that we can apply with the `-A` argument to the CLI.
* `:test` is the name of our alias, it adds the `test` directory to the paths list and `com.cognitect/test-runner` to the dependencies.
* `:main-opts` instructs Clojure that we want these arguments applied when the alias is active. In this case, we're using `-m` to specify which namespace to execute.

The usage of `deps.edn` is documented further in [the deps guide][deps-guide].

This will discover and run our test for us, let's run it now:

```bash
$ clj -Atest

Running tests in #{"test"}

Testing hey.core-test

Ran 1 tests containing 1 assertions.
0 failures, 0 errors.
```

Hopefully you see the same success message as myself. You can see that we applied the values specified in our alias with the `-Atest` argument.

## Building jars

You can now write additional namespaces, add dependencies, run your code and test things. You've actually got a lot of what you need already and with very little tooling or configuration. Eventually you're going to want to build a jar to either publish for others to use (in the case of a library) or run on a server (in the case of an application).

Compiling your project into a jar will involve similar steps to getting your tests running, we're going to add another alias with another dependency which does the job for us.

Go ahead and add this new alias to the `:aliases` section of your `deps.edn` file, next to the `:test` alias:

```clojure
:pack
{:extra-deps
 {pack/pack.alpha
  {:git/url "git@github.com:juxt/pack.alpha.git"
   :sha     "e6d0691c5f58135e1ef6fb1c9dda563611d36205"}}
 :main-opts ["-m" "mach.pack.alpha.capsule" "deps.edn" "dist/hey.jar"]}
```

We can now build a jar that we can execute directly through the `java` program, without the Clojure CLI:

```bash
$ clj -Apack
$ java -jar dist/hey.jar # Drop us into a Clojure REPL.
$ java -jar dist/hey.jar -m hey.core # Executes our "Hello, World!".
```

## Publishing

Now that you have your jar built you have a couple of options with regards to getting it out into the world. You may want to simply deploy your jar, possibly within a Docker container, to your own server. This is the route you'll take if you're building some sort of web application.

Alternatively, you may have written a library that you wish to publish onto [Clojars][] for anyone to use, we're going to use maven to accomplish this.

First, we're going to add your Clojars login to `~/.m2/settings.xml`:

```xml
<settings>
  <servers>
    <server>
      <id>clojars</id>
      <username>username</username>
      <password>password</password>
    </server>
  </servers>
</settings>
```

Now we're going to generate your base `pom.xml` file, you should run this command whenever you're going to publish so the dependencies get updated:

```bash
$ clj -Spom
```

Here's my example version, it contains some extra Clojars specific fields that you may want to use:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>org.clojars.olical</groupId>
  <artifactId>hey</artifactId>
  <version>2.0.0-SNAPSHOT</version>
  <name>hey</name>
  <description>Just a Hello, World!</description>
  <url>https://github.com/Olical/clojure-hey-example</url>
  <licenses>
    <license>
      <name>Unlicense</name>
      <url>https://unlicense.org/</url>
    </license>
  </licenses>
  <scm>
    <url>https://github.com/Olical/clojure-hey-example</url>
  </scm>
  <dependencies>
    <dependency>
      <groupId>org.clojure</groupId>
      <artifactId>clojure</artifactId>
      <version>1.9.0</version>
    </dependency>
  </dependencies>
  <build>
    <sourceDirectory>src</sourceDirectory>
  </build>
  <repositories>
    <repository>
      <id>clojars</id>
      <url>https://clojars.org/repo</url>
    </repository>
  </repositories>
</project>
```

We can now tell maven to deploy our built jar using this pom file:

```bash
$ mvn deploy:deploy-file \
   -DpomFile=pom.xml \
   -Dfile=dist/hey.jar \
   -DrepositoryId=clojars \
   -Durl=https://clojars.org/repo
```

A lot of this information comes from [Clojar's guide to pushing][pushing] and [Maven's guide to deploying 3rd party jars][deploying-jars].

If everything went to plan, your Clojars account should now contain a fresh new jar.

## Ergonomics

As it stands, to deploy our jar to Clojars we'll want to take the following steps:

* Run the tests with `clj -Atest`.
* Build a fresh jar with `clj -Apack`.
* Run `clj -Spom` to update our `pom.xml` with any dependency changes. (this may require some manual XML grooming)
* Update the version number in our `pom.xml`.
* Run the `mvn deploy:deploy-file...` command.
 
This isn't particularly catchy, so we'll wrap everything we've seen so far in a pretty little `Makefile`:

```makefile
.PHONY: run test pack deploy

run:
	clj -m hey.core

test:
	clj -Atest

pack:
	clj -Apack

deploy: test pack
	clj -Spom
	mvn deploy:deploy-file \
		-DpomFile=pom.xml \
		-Dfile=dist/hey.jar \
		-DrepositoryId=clojars \
		-Durl=https://clojars.org/repo
```

Now all you need to do when you wish to deploy is bump the version number in your `pom.xml` and execute `make deploy`.

## Thanks!

If you've got this far I really hoped this post has helped you out. You can find the example project I built during the writing of this post at [github.com/Olical/clojure-hey-example][example-repo].

Happy Clojuring!

[cursive]: https://cursive-ide.com/
[spacemacs]: http://spacemacs.org/
[bridge]: https://github.com/robert-stuttaford/bridge
[getting-started]: https://clojure.org/guides/getting_started
[deps-guide]: https://clojure.org/guides/deps_and_cli
[clojars]: https://clojars.org/
[pushing]: https://github.com/clojars/clojars-web/wiki/Pushing
[deploying-jars]: https://maven.apache.org/guides/mini/guide-3rd-party-jars-remote.html
[example-repo]: https://github.com/Olical/clojure-hey-example