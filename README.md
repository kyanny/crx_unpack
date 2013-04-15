# CrxUnpack

[![Build Status](https://travis-ci.org/kyanny/crx_unpack.png)](https://travis-ci.org/kyanny/crx_unpack)

Unpack [Chrome extension (crx)](http://developer.chrome.com/extensions/crx.html) file

## Installation

Add this line to your application's Gemfile:

    gem 'crx_unpack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crx_unpack

## Usage

```ruby
require 'crx_unpack'

data = open('extension.crx', 'rb').read
crx = CrxUnpack.unpack(data)
crx.zip #=> zip data of extension contents

# unzip extension contents into `./extension' directory
CrxUnpack.unpack_contents_from_file('extension.crx', './extension')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
