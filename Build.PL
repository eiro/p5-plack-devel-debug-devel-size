use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new
( qw{
    module_name Plack::Middleware::Debug::Devel::Size
    dist_version_from lib/Plack/Middleware/Debug/Devel/Size.pm
    license perl
    }
, dist_author         => 'Marc Chantreux <marc.chantreux@biblibre.com>'
, build_requires => {qw{
        Plack::Middleware::Debug 0.14
    }}
# , meta_add =>
#     { homepage => 'https://github.com/eiro/p5-perlude'
#     , repository => 'https://github.com/eiro/p5-perlude.git'
#     , bugtracker => 'https://rt.cpan.org/Dist/Display.html?Queue=Perlude',
#     }
);

$builder->create_build_script();
