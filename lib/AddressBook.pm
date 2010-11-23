package AddressBook;
use Dancer ':syntax';
use Template;
use utf8;

get '/' => sub {
    template 'home';
};

get '/donate/thanks' => sub {
    template 'thanks';
};

true;
