# frozen_string_literal: true

namespace :kosa do
  namespace :config do

    task :dotkosa do
      sh("mkdir -p ~/.kosa")
    end

    desc "Create template secrets files"
    task secrets: [:dotkosa] do
      sh("echo 'sendgrid_api_key: YOUR.API-KEY' > ~/.kosa/secrets.yml")
      sh("echo 'REPLACE_ME_WITH_PASSWORD' > ~/.kosa/ansible-password")
    end

  end
end