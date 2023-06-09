#!/usr/bin/perl

print "/*\n";
print " * Autogenerated by get-signals.pl from ../../doc/signals.txt,\n";
print " * do not edit.\n";
print " */\n\n";
print "static PERL_SIGNAL_ARGS_REC perl_signal_args[] =\n{\n";

while (<>) {
	chomp;

	next if (!/^ "([^"]*)"(<.*>)?(?:,\s*(.*))?/);
	next if (/\.\.\./);
	next if (/\(/);

	$signal = $1;
	$_ = $3;

	s/GList \* of ([^,]*)s/glistptr_\1/g;
	s/GSList of ([^,]*)s/gslist_\1/g;

	s/GString \*[^,]*/gstring/g;

	s/char \*[^,]*/string/g;
	s/ulong \*[^,]*/ulongptr/g;
	s/int \*[^,]*/intptr/g;
	s/int [^,]*/int/g;


	my %map = (
		# core
		CHATNET_REC   => 'iobject',
		SERVER_REC    => 'iobject',
		RECONNECT_REC => 'iobject',
		CHANNEL_REC   => 'iobject',
		QUERY_REC     => 'iobject',
		COMMAND_REC   => 'Irssi::Command',
		NICK_REC      => 'iobject',
		LOG_REC	      => 'Irssi::Log',
		RAWLOG_REC    => 'Irssi::Rawlog',
		IGNORE_REC    => 'Irssi::Ignore',
		MODULE_REC    => 'Irssi::Module',
		TLS_REC       => 'iobject',

		# irc
		BAN_REC		    => 'Irssi::Irc::Ban',
		NETSPLIT_REC	    => 'Irssi::Irc::Netsplit',
		NETSPLIT_SERVER_REC => 'Irssi::Irc::Netsplitserver',

		# irc modules
		DCC_REC	       => 'siobject',
		AUTOIGNORE_REC => 'Irssi::Irc::Autoignore',
		NOTIFYLIST_REC => 'Irssi::Irc::Notifylist',
		CLIENT_REC     => 'Irssi::Irc::Client',

		# fe-common
		THEME_REC	   => 'Irssi::UI::Theme',
		KEYINFO_REC	   => 'Irssi::UI::Keyinfo',
		PROCESS_REC	   => 'Irssi::UI::Process',
		TEXT_DEST_REC	   => 'Irssi::UI::TextDest',
		LINE_INFO_META_REC => 'Irssi::UI::LineInfoMeta',
		WINDOW_REC	   => 'Irssi::UI::Window',
		WI_ITEM_REC	   => 'iobject',

		# fe-text
		TEXTBUFFER_VIEW_REC => 'Irssi::TextUI::TextBufferView',
		LINE_REC	    => 'Irssi::TextUI::Line',

		# perl
		PERL_SCRIPT_REC => 'Irssi::Script',
	);
	my $k = join '|', sort { length $b <=> length $a } keys %map;
	s/($k)[^,]*/$map{$1}/g;

	s/([\w\*:]+)(,|$)/"\1"\2/g;
	if ($_ eq "") {
		print "	   { \"$signal\", { NULL } },\n";
	} else {
		print "	   { \"$signal\", { $_, NULL } },\n";
	}
}

print "\n    { NULL }\n};\n";
