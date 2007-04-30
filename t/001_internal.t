use Test::More;
use Test::Exception;

use strict;
use warnings;

plan tests => 19;

{
  package My::Metaclass;

  use Moose;

  extends qw/MooseX::Meta::Parameter/;
}

{
  package XXX;

  use MooseX::Method;
  use Test::Exception;

  throws_ok { method xxx => [] => sub {} } qr/not have a meta method/;
}

{
  package XXY;

  use MooseX::Method;
  use Test::Exception;

  sub meta {};

  throws_ok { method xxx => [] => sub {} } qr/not have a meta method/;
}

{
  package XXZ;

  use MooseX::Method;
  use Test::Exception;

  sub meta { bless {},'Foo' }

  throws_ok { method xxx => [] => sub {} } qr/not have a meta method/;
}

{
  package Foo;

  use Moose;
  use MooseX::Method;
  use Test::Exception;

  throws_ok { method xxx => 0 => sub {} } qr/signature declaration must/,'signature declaration';

  throws_ok { method xxx => { foo => 0 } => sub {} } qr/Parameter must/,'parameter declaration';

  throws_ok { method xxx => {} => 0 } qr/Expecting a coderef/,'coderef';
}

throws_ok { MooseX::Meta::Method::Signature->wrap_with_signature (0,sub {}) } qr/Signature must be/;

throws_ok { MooseX::Meta::Method::Signature->wrap_with_signature (bless ({},'Foo'),sub {}) } qr/Signature must be/;

throws_ok { MooseX::Meta::Signature::Named->new (0) } qr/must be a hashref/;

throws_ok { MooseX::Meta::Signature::Positional->new (0) } qr/must be an arrayref/;

throws_ok { MooseX::Meta::Signature::Named->new ({ foo => 0 }) } qr/must be a/,'signature new blessed';

throws_ok { MooseX::Meta::Signature::Positional->new ([0]) } qr/must be a/;

throws_ok { MooseX::Meta::Signature::Named->new ({ foo => bless {},'Foo' }) } qr/must be a/,'signature new isa';

throws_ok { MooseX::Meta::Signature::Positional->new ([bless {},'Foo']) } qr/must be a/;

my $named_signature = MooseX::Meta::Signature::Named->new ({foo => { metaclass => 'My::Metaclass' }});

isa_ok $named_signature,'MooseX::Meta::Signature','signature isa';

ok $named_signature->get_parameter_map,'signature get_parameter_map';

my $test_method = MooseX::Meta::Method::Signature->wrap_with_signature ($named_signature,sub {});

ok $test_method->get_signature;

my $positional_signature = MooseX::Meta::Signature::Positional->new ([{ metaclass => 'My::Metaclass' }]);

isa_ok $positional_signature,'MooseX::Meta::Signature';

ok $positional_signature->get_parameter_map;
