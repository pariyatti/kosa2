# frozen_string_literal: true

Dir[Rails.root.join('lib', 'core_extensions', '*.rb')].each { |f| require f }

VimeoMe2::User.include CoreExtensions::VimeoMe2::UserMethods
