# frozen_string_literal: true

Time::DATE_FORMATS[:kosa] = "%Y-%m-%dT%H:%M:%SZ"
Time::DATE_FORMATS[:default] = Time::DATE_FORMATS[:kosa]

Date::DATE_FORMATS[:kosa] = "%Y-%m-%d"
Date::DATE_FORMATS[:default] = Date::DATE_FORMATS[:kosa]

PERL_EPOCH = "2005-04-29T00:00:00Z"
