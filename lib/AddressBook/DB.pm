package AddressBook::DB
use strict;
use warnings;
use DBI;
use base "Exporter";
our @EXPORT qw(fetch);

## Config
my $sql_file = "./sql.pl"; # here lye sql statements;

my $sql_ref = do $sql_file; 

sub fetch {
    
}

sub _connect_db {

}
