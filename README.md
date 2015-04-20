A prototype of a map using pixi.js

Pixi
----

Version 2.2.9

Preparation
-----------

```
npm install -g coffee-script
```

Compile a directory tree of .coffee files in lib into a parallel tree of .js files in javascripts:
```
coffee --compile --output javascripts/ lib/
```

Run
---

```
ruby -r webrick -e "s = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => Dir.pwd); trap('INT') { s.shutdown }; s.start"
```

Tests
-----

open ```spec/SpecRunner.html```

