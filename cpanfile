requires 'perl', '5.008001';
requires 'parent';

requires 'Test::Deep';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Tester';
};
