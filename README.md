# NAME

Test::Deep::Flags - Strictly checking string or number for Test::Deep

# SYNOPSIS

    use Test::Deep;
    use Test::Deep::Flags;

    # ok
    cmp_deeply(
        {
            foo => 1,
        },
        {
            foo => number(1),
        }
    );

    # fail
    cmp_deeply(
        {
            foo => '1',
        },
        {
            foo => number(1),
        }
    );

# DESCRIPTION

Test::Deep::Flags is ...

# LICENSE

Copyright (C) Takumi Akiyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takumi Akiyama <t.akiym@gmail.com>
