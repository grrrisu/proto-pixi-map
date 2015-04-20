A prototype of a map using pixi.js

Preparation
-----------

```
npm install -g coffee-script
```

Compile a directory tree of .coffee files in src into a parallel tree of .js files in javascripts:
```
coffee --compile --output javascripts/ src/
```

Run
---

```
ruby -r webrick -e "s = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => Dir.pwd); trap('INT') { s.shutdown }; s.start"
```
