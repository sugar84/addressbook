package AddressBook;

use Dancer ':syntax';
use Template;
use DBI;
use Carp;
use utf8;

### Subs

my (%sql_blocks);

sub init_all_sql {
    open my $fh, "<", setting("sql_schema")
        or carp "cannot open SQL schema : $!\n";
    $sql_blocks{"schema"} = do { local $/; <$fh> };
    
    open my $fh, "<", setting("sql_fetch_all")
        or carp "cannot open SQL fetch_all : $!\n";
    $sql_blocks{"fetch_all"} = do { local $/; <$fh> };
}

sub init_db {
    my $db = connect_db();

    $db->do( $schema ) 
        or carp $db->errstr;
}

sub connect {
    my $dbh = DBI->connect( setting("db_dbi") . setting("db_name") )
        or carp $DBI::errstr;

    return $dbh;
}

### Handlers

get '/all_records' => sub {
    my $db = connect_db();

    my $sth = $db->prepare( $sql_blocks{"fetch_all"} )
        or carp $db-errstr;
    $sth->execute
        or carp $sth->errstr;

    template "all_records.tt", { 
        entries => $sth->fetchall_hashref("id"),
    };
};

get '/' => sub {
    template 'home';
};

true;
