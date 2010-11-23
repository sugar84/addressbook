package AddressBook;

use Dancer ':syntax';
use Template;
use DBI;
use Carp;
use File::Slurp qw(read_file);
use utf8;

### Subs

sub init_db {
    my $db = connect_db();

    my $schema = read_file( setting("db_sch") )
        or carp( "no sql schema" );
    $db->do( $schema ) 
        or carp $db->errstr;
}

sub connect {
    my $dbh = DBI->connect( setting("db_dbi") . setting("db_name") )
        or carp $DBI->errstr;

    return $dbh;
}
### Handlers

get '/' => sub {
    template 'home';
};

true;
