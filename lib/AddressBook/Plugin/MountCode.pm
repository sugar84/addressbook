package AddressBook::Plugin::MountCode;
use strict;
use warnings;

use Dancer qw(:syntax);
use Dancer::Plugin;
use Carp;
#use Data::Dumper;

my $settings = plugin_setting;

register mount_code => sub {
    while ( my ($description, $file) = each %{$settings} ) {
        open my $fh, "<", $file
            or croak "cannot open $file at $description : $!\n";

        my $code = do { local $/ = undef; <$fh> };

        my $caller_package  = caller;
        my $eval = qq/package $caller_package;\n $code/;
        eval $eval;

        if ($@) {
            croak "while execution code some errors occured. $@\n" .
                "See file from the line of your app's config:\n" .
                "\t" . "$description" . ": " . "$file" . "\n";
        }
    }
};

register_plugin;

1;

