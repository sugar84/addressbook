package AddressBook;

use Dancer ':syntax';
use Template;
use DBI;
use Carp;
use Data::Dumper;
use Encode;
use utf8;

### Subs
#
$Data::Dumper::Useqq = 1;
{ no warnings 'redefine';
    sub Data::Dumper::qqoute {
        my $s = shift;
        return "'$s'";
    }
}


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

    my $entries    = $sth->fetchall_hashref("org_id")
        or croak $sth->errstr;
    my $utf_string = decode( "utf8",  $entries->{"175"}{"full_name"} );
    warning Dumper( $utf_string );

    template "all_records.tt", { 
        entries  => $entries,
        test_utf => $utf_string,
    };
};

get '/' => sub {
    template 'home';
};

init_all_sql();
init_db();
true;
