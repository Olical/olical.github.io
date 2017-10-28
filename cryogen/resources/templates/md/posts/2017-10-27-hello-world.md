{:title  "Hello, World!"
 :layout :post
 :date   "2017-10-27"
 :tags   []
 :klipse true}

I've, once again, migrated my blog onto another platform. This time I've gone from WordPress on my own Linode to [Cryogen][] on GitHub pages. This means a few things:

1. I no longer need to worry about running my own server, even though Linode is fantastic. I just don't want to maintain anything, especially WordPress.
2. I can blog with a Clojure based platform and integrate [Klipse][] easily for interactive lispy posts.
3. I can write my posts in markdown with Emacs and keep it all on [GitHub][repo].

## The migration
 
I wanted to start fresh since my old blog is full of so many topics that I do not feel reflect my true interests anymore, so here I am with a blank slate. Luckily I found a way to keep my WordPress site exactly how it was so as not to break a single URL without running WordPress itself.

I used [Simply Static][simply-static] to generate a snapshot of my entire blog which I could then merge into my GitHub pages repositories top level. This means every URL that used to work with my original blog will work with this one.

I don't promote my old posts through this anymore, but they're still there, I even preserved [the original homepage][wp-index].

## The payoff

I think it was worth it since I no longer have to run a server and I can do things like this.

```klipse-scheme
(define (add a b)
  (if (= b 0)
    a
    (add (+ a 1) (- b 1))))
    
(add 10 20)
```

I also did this entire migration today while on trains and in cars over mobile internet, which was fun.

[cryogen]: http://cryogenweb.org/
[klipse]: https://github.com/viebel/klipse
[repo]: https://github.com/Olical/olical.github.io
[simply-static]: https://en-gb.wordpress.org/plugins/simply-static/
[wp-index]: https://oli.me.uk/wp-index.html
