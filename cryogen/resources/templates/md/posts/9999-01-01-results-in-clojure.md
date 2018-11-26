{:title  "Results in Clojure"
 :layout :post
 :date   "9999-01-01"
 :tags   ["clojure" "result"]
 :klipse true
 :draft? true}

<!--

This would require some conventions or tooling around enums. Errors would maybe
contain a message + more data. Maybe a format function, good use for a multi
method wrapped by a macro?

This could just be about errors, but it's not really. It's really talking about
io fns that can fail in multiple ways. It's more general that errors, you
shouldn't think of your functions as "oh it went well or didn't", it's more
"this function can have multiple responses, each has to be handled
differently". Regular functions that don't perform io and should never throw
don't have this concern.

-->
