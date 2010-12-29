package AddressBook;

use Dancer ':syntax';
use Template;
use Carp;
use Data::Dumper;
use Dancer::Plugin::Database;
use AddressBook::Plugin::MountCode;
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

#sub test_select {
#    my $sth = database->prepare( $sql_blocks->{"test_select"} )
#        or croak database->errstr;
#    $sth->execute
#        or croak $sth->errstr;
#    my $entries = $sth->fetchall_hashref("org_id")
#        or croak $sth->errstr;
#
#    return $entries;
#}

warning caller;
mount_code;
#
#open my $fh, "<", "lib/AddressBook/DB2.pm"
#    or croak "cannot open the file $!";
#my $code = do { local $/ = undef; <$fh> };
#close $fh;
#eval $code;
#warning $code;
#warning $@ if $@;
#warning show_settings();
#eval
#use AddressBook::DB2;
#use DB;
#load "DB.pm";
#DB->import( qw(test_select) );

### Handlers

get '/all_records' => sub {

    warning ( __PACKAGE__ );
    my $entries = test_select();

    template "all_records.tt", { 
        entries  => $entries,
#        test_utf => join "::", @{$string_ref},
    };
};

get '/' => sub {
    template 'home';
};

#init_db();
true;
