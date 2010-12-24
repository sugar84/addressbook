#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  test.pl
#
#        USAGE:  ./test.pl  
#
#  DESCRIPTION:  test for fo expr
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Anton Ukolov (), antonuk84@yandex.ru
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  22.12.2010 18:09:20
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Data::Dumper;
my $file = "./sql.pl";
unshift @INC, ".";
my $res = do $file;
print Dumper($res);

