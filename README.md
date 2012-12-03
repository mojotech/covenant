# Covenant

Covenant is an assertion library for Ruby, designed to be used in your
production code.

It adds 4 methods to `Object`: `assert`, `asserting`, `deny` and `denying`.

## Usage

The `assert` method can be used in several different ways. If you're using it as
a guard, at the top of your methods, you'll likely use it as a wrapper around
the object you want to check:

    # Type checking
    assert(obj).is_an Array
    assert(obj).is_a String

    # Equality
    assert(obj) == some_other_object
    assert(obj) != some_other_object

    # Comparisons
    assert(obj) > 1
    assert(obj) <= 1

`assert` returns its receiver, so you can use it with a method's return value:

    obj.assert > 1          #=> obj
    obj.assert.is_a(String) #=> obj

In this case, you'll probably want to use `asserting` as it reads slightly
better:

    obj.asserting > 1          #=> obj
    obj.asserting.is_a(String) #=> obj

You can also use a block form. `assert` will optionally yield its receiver to
the block.

    obj.assert { full_speed_ahead? } #=> obj
    do_this.and_that.assert { |o| o > 1 } #=> o

In the last case, `o` is the return value of `#and_that`.

### deny

    deny(obj).is_an Array # Covenant::AssertionFailed: Expected #{obj.inspect} to be false.

In general, favor `assert` over `deny`. **Do not** use `deny` with `!=`. It
reads really bad:

    deny(obj) != some_other_object # yuck

## Custom error messages

You can pass a second argument to `assert` and `deny`, and if the check fails,
that message will be used by the exception instead:

    assert(1, "1 != 0!") == 0 # Covenant::AssertionFailed: 1 != 0!

## Supported Ruby versions

The wrapper object returned by `assert` overrides `!=`, so you'll need a Ruby
1.9 compatible implementation.

## TODO

* Speed up
* Document
