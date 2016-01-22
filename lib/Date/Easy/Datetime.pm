package Date::Easy::Datetime;

use strict;
use warnings;
use autodie;

# VERSION

use Exporter;
use parent 'Exporter';
our @EXPORT_OK = qw< datetime now >;
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

use parent 'Time::Piece';

use Time::Local;


##############################
# FUNCTIONS (*NOT* METHODS!) #
##############################

sub datetime
{
	my $datetime = shift;
	if ( $datetime =~ /^-?\d+$/ )
	{
		return Date::Easy::Datetime->new($datetime);
	}
	else
	{
		return Date::Easy::Datetime->new( _str2time($datetime) );
	}
	die("reached unreachable code");
}

sub now () { Date::Easy::Datetime->new }


sub _str2time
{
	require Date::Parse;
	return &Date::Parse::str2time;
}


#######################
# REGULAR CLASS STUFF #
#######################

sub new
{
	my $class = shift;

	my $t;
	if (@_ == 0)
	{
		$t = time;
	}
	elsif (@_ == 6)
	{
		my ($y, $m, $d, $H, $M, $S) = @_;
		--$m;										# timelocal/timegm will expect month as 0..11
		$t = timelocal($S, $M, $H, $d, $m, $y);
	}
	elsif (@_ == 1)
	{
		$t = shift;
	}
	else
	{
		die("Illegal number of arguments to datetime()");
	}

	return scalar $class->_mktime($t, 1);
}
