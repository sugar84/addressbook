package AddressBook;

use Dancer ':syntax';
use Template;
use DBI;
use Carp;
use Data::Dumper;
use Dancer::Plugin::Database;
use utf8;

my %sql_blocks;

# import sql-statements
my $sqls_file  = "SQL/sql.pl";
my $sql_blocks = do $sqls_file;


# dirty utf8 hack for Dumper

$Data::Dumper::Useqq = 1;

{ no warnings 'redefine';
    sub Data::Dumper::qqoute {
        my $s = shift;
        return "'$s'";
    }
}

### Subs
#

sub test_select {
    my $db = connect_db();

    my $sth = $db->prepare( $sql_blocks->{"test_select"} )
        or croak $db->errstr;
    warning( $sql_blocks->{"test_select"} );
    $sth->execute
        or croak $sth->errstr;

    my $entries    = $sth->fetchall_hashref("org_id")
        or croak $sth->errstr;
    return $entries;
}

#sub init_all_sql {
#    my $fh;
#    
#    open $fh, "<", setting("sql_schema")
#        or croak "cannot open SQL schema : $!\n";
#    $sql_blocks{"schema"} = do { local $/; <$fh> };
#    close $fh;
#
#    open $fh, "<", setting("sql_fetch_all")
#        or croak "cannot open SQL fetch_all : $!\n";
#    $sql_blocks{"fetch_all"} = do { local $/; <$fh> };
#    close $fh;
#}

sub init_db {
    my $db = connect_db();

    $db->do( $sql_blocks->{"schema"} ) 
        or croak $db->errstr;
}

sub connect_db {
    my $dbh = DBI->connect( setting("db_dbi") . setting("db_name") )
        or croak $DBI::errstr;
    
    $dbh->{"unicode"} = 1;

    return $dbh;
}

### Handlers

get '/all_records' => sub {

    warning Dumper( $sql_blocks );
    warning join("::", @INC);
    my $entries = test_select;
    my $sth = database->prepare(
        "SELECT branch_id, branch_name, branch_order FROM branch"
    ) or croak database->errstr;
    $sth->execute
        or croak $sth->errstr;
    my $string_ref = $sth->fetchrow_arrayref
        or croak $sth->errstr;

    template "all_records.tt", { 
        entries  => $entries,
        test_utf => join "::", @{$string_ref},
    };
};

get '/' => sub {
    template 'home';
};

#init_all_sql();
init_db();
true;
