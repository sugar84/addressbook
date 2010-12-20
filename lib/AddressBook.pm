package AddressBook;

use Dancer ':syntax';
use Template;
use DBI;
use Carp;
use utf8;

### Subs

my (%sql_blocks);
$sql_blocks{ "fetch_some" } = qq/
    SELECT organization.org_id, organization.full_name, branch.branch_name, 
        branch_order FROM (organization INNER JOIN branch ON 
            organization.branch2_id = branch.branch_id)
        WHERE organization.branch2_id = 10/;


sub init_all_sql {
    my $fh;
    
    open $fh, "<", setting("sql_schema")
        or croak "cannot open SQL schema : $!\n";
    $sql_blocks{"schema"} = do { local $/; <$fh> };
    close $fh;

    open $fh, "<", setting("sql_fetch_all")
        or croak "cannot open SQL fetch_all : $!\n";
    $sql_blocks{"fetch_all"} = do { local $/; <$fh> };
    close $fh;
}

sub init_db {
    my $db = connect_db();

    $db->do( $sql_blocks{"schema"} ) 
        or croak $db->errstr;
}

sub connect_db {
    my $dbh = DBI->connect( setting("db_dbi") . setting("db_name") )
        or croak $DBI::errstr;

    return $dbh;
}

### Handlers

get '/all_records' => sub {
    my $db = connect_db();

    my $sth = $db->prepare( $sql_blocks{"fetch_some"} )
        or croak $db->errstr;
    warning( $sql_blocks{"fetch_some"} );
    $sth->execute
        or croak $sth->errstr;

    template "all_records.tt", { 
        entries => $sth->fetchall_hashref("org_id"),
    };
};

get '/' => sub {
    template 'home';
};

init_all_sql();
init_db();
true;
