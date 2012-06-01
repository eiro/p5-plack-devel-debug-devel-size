package Plack::Middleware::Debug::Devel::Size;
use Modern::Perl;
use Plack::Util::Accessor qw(for);
use parent 'Plack::Middleware::Debug::Base';
use Devel::Size 'total_size';
$Devel::Size::warn = 0;

our $VERSION = '0.01';

=head1 configuration

the common yaml syntax is 

plack_middlewares:
    -
      - Debug
      - panels
      -
        - Dancer::Settings
        - [Devel::Size, for,['Dancer::Route','Dancer::Session']]
        - Profiler::NYTProf

i rather prefer

    symdump: &s
        - 'Dancer::Route'
        - 'Dancer::Session'
    plack_middlewares:
        - [Debug, panels, [Dancer::Settings,[Devel::Size, for, *s ],Profiler::NYTProf] ]

or 

    plack_middlewares:
        - [Debug, panels, [Dancer::Settings,[Devel::Size, for,['Dancer::Route','Dancer::Session']],Profiler::NYTProf] ]

You can also pass code reference when using L<PlackBuilder>

  [ 'Devel::Size', for => \&watch_for_size ],

This is especially useful whan generating watch list in runtime from %INC which might change.

=cut


sub snitch {
    my $ns = shift;
    no strict 'refs';
    my $ref = \%{$ns.'::'};
    total_size $ref;
}


sub prepare_app {
    my $self = shift;
    $self->for([]) unless $self->for
}

sub run {
    my ( $self, $env, $panel ) = @_;
    sub {
        my $res = shift;
        my $total = 0;
	my %pairs = map {
		my $s = snitch $_;
		$total += $s;
#		warn "## $_ = $s\n";
		$s => $_; # sort value => name
	} ref $self->for eq 'CODE' ? $self->for->() : @{ $self->for };
        $panel->content( $self->render_list_pairs( [
		map { $pairs{$_} => $_ }
		sort { $b <=> $a }
		keys %pairs
	] ) );
        $panel->nav_subtitle($total);
    }
}

1;

