package AddressBook;

use Dancer ':syntax';
use Template;
use DBI;
use Carp;
use utf8;

### Subs

my (%sql_blocks);

sub init_all_sql {
    my $fh;
    
    open $fh, "<", setting("sql_schema")
        or carp "cannot open SQL schema : $!\n";
    $sql_blocks{"schema"} = do { local $/; <$fh> };
    close $fh;

    open $fh, "<", setting("sql_fetch_all")
        or carp "cannot open SQL fetch_all : $!\n";
    $sql_blocks{"fetch_all"} = do { local $/; <$fh> };
    close $fh;
}

sub init_db {
    my $db = connect_db();

    $db->do( $sql_blocks{"schema"} ) 
        or carp $db->errstr;
}

sub connect_db {
    my $dbh = DBI->connect( setting("db_dbi") . setting("db_name") )
        or carp $DBI::errstr;

    return $dbh;
}

### Handlers

get '/all_records' => sub {
    my $db = connect_db();

    my $sth = $db->prepare( $sql_blocks{"fetch_all"} )
        or carp $db->errstr;
    warning( $sql_blocks{"fetch_all"} );
    $sth->execute
        or carp $sth->errstr;

    template "all_records.tt", { 
        entries => $sth->fetchall_hashref("id"),
    };
};

get '/' => sub {
    template 'home';
};

init_all_sql();
init_db();
true;
