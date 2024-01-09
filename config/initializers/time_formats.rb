# frozen_string_literal: true

Time::DATE_FORMATS[:kosa] = "%Y-%m-%dT%H:%M:%SZ"
Time::DATE_FORMATS[:default] = Time::DATE_FORMATS[:kosa]

Date::DATE_FORMATS[:kosa] = "%Y-%m-%d"
Date::DATE_FORMATS[:default] = Date::DATE_FORMATS[:kosa]

# This date has nothing to do with Perl, per se.
# The original email/RSS scripts were written in Perl.
PERL_EPOCH_STR = "2005-04-29T00:00:00Z"
PERL_EPOCH = DateTime.parse(PERL_EPOCH_STR)
