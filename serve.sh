#!/bin/bash
# Local development server using Ruby 3.3
/opt/homebrew/opt/ruby@3.3/bin/bundle exec jekyll serve --livereload 2>&1 | grep -v "DEPRECATION WARNING" | grep -v "More info" | grep -v "automated migrator" | grep -v "^$" | grep -v "^ ╷" | grep -v "^ │" | grep -v "^ ╵" | grep -v "^    /"
