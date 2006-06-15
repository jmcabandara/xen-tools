#!/usr/bin/perl -w
#
#  Test that every perl file we have passes the syntax check.
#
# Steve
# --
# $Id: perl-syntax.t,v 1.2 2006-06-13 13:26:00 steve Exp $


use strict;
use File::Find;
use Test::More qw( no_plan );


#
#  Find all the files beneath the current directory,
# and call 'checkFile' with the name.
#
find( { wanted => \&checkFile, no_chdir => 1 }, '.' );



#
#  Check a file.
#
#  If this is a perl file then call "perl -c $name", otherwise
# return
#
sub checkFile
{
    # The file.
    my $file = $File::Find::name;

    # We don't care about directories
    return if ( ! -f $file );

    # `modules.sh` is a false positive.
    return if ( $file =~ /modules.sh$/ );

    # See if it is a perl file.
    my $isPerl = 0;

    # Read the file.
    open( INPUT, "<", $file );
    foreach my $line ( <INPUT> )
    {
        if ( $line =~ /\/usr\/bin\/perl/ )
        {
            $isPerl = 1;
        }
    }
    close( INPUT );

    #
    #  Return if it wasn't a perl file.
    #
    return if ( ! $isPerl );

    #
    #  Now run 'perl -c $file' to see if we pass the syntax
    # check
    #
    my $retval = system( "perl -c $file 2>/dev/null >/dev/null" );

    is( $retval, 0, "Perl file passes our syntax check: $file" );
}