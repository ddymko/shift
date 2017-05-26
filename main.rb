require 'find'
require 'yaml'
require 'shellwords'
require 'fileutils'

configs = YAML.load_file('config.yml')

Dir.chdir(configs['path'])
folders = Dir.glob('*').select { |f| File.directory? f }
# Extraction + rename + move
if folders.count > 0
  folders.each do |f|
    # Unrar file
    video_location = Find.find("#{configs['path']}/#{f}").grep(/rar/)
    command = "unrar x #{Shellwords.escape(video_location[0])} #{configs['path']}/#{Shellwords.escape(f)}"
    system(command)

    # Rename and move file
    video = Find.find("#{configs['path']}/#{f}").grep(/NPW.mp4/)
    name = /#{configs['regex']}/.match(f)
    name = name.to_s
    6.times { name.chop! }
    FileUtils.mv(video[0], "#{configs['dest']}/#{name}.mp4")
  end
end
