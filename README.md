# Covenant

Covenant is an assertion library for Ruby, designed to be used in your
production code.

It adds 2 methods to `Object`: `assert` and `asserting`.

## Usage

Simply pass a block to `#assert`. The block's result must be truthy, otherwise
an exception will be raised.

    assert { [].is_a?(Array) } # yay
    assert { 1.is_a?(String) } # oh, noes!

`assert` returns its receiver, so you can use it with a method's return value:

    obj.assert { obj > 1 } #=> obj

In this case, you'll probably want to use `asserting` as it reads slightly
better:

    obj.asserting { obj > 1 } #=> obj

`assert` will optionally yield its receiver to the block.

    some_query.asserting { |obj| obj > 1 } #=> result

In the last case, `obj` is the return value of `#some_query`.

## Supported Ruby versions

Tested on Ruby 1.9. It may work on 1.8 but I don't guarantee it.

## TODO

* Document
