require 'open-uri'

class GithubService
  attr_reader :username, :repo, :branch

  def initialize(username = 'mkpdev', repo = 'coding_test', branch = 'master')
    @username = username
    @repo = repo
    @branch = branch
  end

  def read_file(tool_name, language)
    file_name = "#{tool_name.upcase}.#{language}.master.json"

    retry_count = 0
    begin
      raw_link = "https://raw.githubusercontent.com/#{username}/#{repo}/#{branch}/#{file_name}"
      web_contents = open(raw_link, &:read)
      JSON.parse(web_contents)
    rescue OpenURI::HTTPError => e
      if e.io.status[0].to_i == 404
        retry_count += 1
        file_name.sub!('.master', '')
        retry if retry_count < 2
        nil
      end
    end
  end
end
