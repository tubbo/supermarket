atom_feed language: 'en-US' do |feed|
  feed.title "#{@user.username}'s Followed Cookbook Activity"
  feed.updated Time.now

  @followed_cookbook_activity.each do |cookbook_version|
    feed.entry cookbook_version, url: cookbook_version_url(cookbook_version.cookbook, cookbook_version.version) do |entry|
      entry.title t('cookbook.activity',
                    maintainer: cookbook_version.cookbook.maintainer,
                    version: cookbook_version.version,
                    cookbook: cookbook_version.cookbook.name
                   )
      entry.content cookbook_version.description

      entry.author do |author|
        author.name cookbook_version.cookbook.maintainer
        author.uri user_url(cookbook_version.cookbook.owner)
      end
    end
  end
end
