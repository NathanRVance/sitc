#!/usr/bin/perl

use Socket;

local $license = test_license("$ARGV[0]");
chomp $license;
local $password = "$ARGV[1]";
chomp $password;
local $file = "$ARGV[2]";
if (($license ne "") && ($password ne "")) {
	write_to_file("$license $password");
	exit;
}

print "\n";
print "Have you previously obtained a WebMO license number? [y/n]:";
local $choice = "";
	while ($choice eq "")
	{
                local $trial_choice = "";
                $trial_choice = <STDIN>;
                chomp $trial_choice;

                if ($trial_choice =~ /^y/i)
                {
                        $choice = "y";
                }
                elsif ($trial_choice =~ /^n/i)
                {
                        $choice = "n";
                }
        }
        if ($choice eq "n")
        {
                require("sockets.cgi");

                print "Please enter the following information to obtain a license.\n";
                print "A license number will be email to the address provided below.\n";
                print "First name: ";
                my $first = <STDIN>;
                chomp $first;
                $first = escape($first);
                print "Last name: ";
                my $last = <STDIN>;
                chomp $last;
                $last = escape($last);
		print "Affiliation: ";
                my $affiliation = <STDIN>;
                chomp $affiliation;
                $affiliation = escape($affiliation);
                print "Email address: ";
                my $email = <STDIN>;
                chomp $email;
                $email = escape($email);
                my $reference = "$oem - installation";
                $reference = escape($reference);

                my $url = "http://www.webmo.net/cgi-bin/purchase/purchase.cgi?first=$first&last=$last&affiliation=$affiliation&email=$email&reference=$reference";
                local(*HTTP);
                open_connection(HTTP, "www.webmo.net", "http");
                print HTTP "GET $url\n";
                print HTTP "Host: www.webmo.net\n\n";
                close_connection(HTTP);
                print "\nA license number has been emailed to the address that was specified.\n\n";
        }
while ($license eq "")
{
        print "License number: ";
	local $trial_license = <STDIN>;
        $license = test_license($trial_license);
}

if ($password eq "") {
	print "Password: ";
	$password = <STDIN>;
	chomp $password;
}
chomp $license;
write_to_file("$license $password");

sub write_to_file
{
	open(my $fh, '>', "$file") or die "Could not open file $file";
	print $fh @_;
	close $fh;
}

sub test_license
{
	local $trial_license = @_[0];
        chomp $trial_license;

        if ($trial_license !~ /\d\d\d\d-\d\d\d\d-\d\d\d\d/)
        {
                print "The license must be in the form xxxx-xxxx-xxxx\n";
        }
        else
        {
                # This operation is check-summing your license information to help you catch
                # typographical errors.  Sure, you could easily circumvent it, but why would
                # you want to do that, unless you didn't have a valid license number!?!

                local ($first, $second, $third) = split(/-/, $trial_license);

                local @checksum = ( (($first*3+7) | ($second*5+13)) % 10, (($first*7+17) & ($second*11+19)) % 10, (($first*13+23) ^ ($second*17+29)) % 10, (($first*19+31) & ($second*23+33) ^ $first) % 10);

                $third =~ /(\d)(\d)(\d)(\d)/;
                if ($1 != $checksum[0] || $2 != $checksum[1] || $3 != $checksum[2] || $4 != $checksum[3])
                {
                        print "The license number you entered was invalid.\n";
                }
                else
                {
                        return $trial_license;
                }
        }	
	return "";
}

sub escape
{
        my ($input) = @_;
        my $string;
        ($string = $input) =~ s/([^\w ])/sprintf("%%%02lx", ord($1))/eg;
        #for javascript compatability
        $string =~ s/ /%20/g;
        return $string;
}

sub open_connection
{
        local ($socket, $remote_host, $remote_service) = @_;
        local ($current_host, $current_address, $remote_address,
                   $remote_port_number, $current_port, $remote_port, $protocol);

        $current_host = &get_current_host ();
        $current_address = &get_packed_address ($current_host);

        $remote_address = &get_packed_address ($remote_host);
        $remote_port_number = &get_port_number ($remote_service);

        $current_port = &create_socket_structure (0, $current_address);
        $remote_port  = &create_socket_structure ($remote_port_number,
                                                  $remote_address);

        $protocol = (getprotobyname ("tcp"))[2];

        socket  ($socket, &AF_INET, &SOCK_STREAM, $protocol) || return (0);
#       bind    ($socket, $current_port)                                         || return (0);
        connect ($socket, $remote_port)                                   || return (0);

        &unbuffer_socket ($socket);

        return (1);
}

