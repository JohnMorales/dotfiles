#if defined? PryStackExplorer
#  Pry.commands.alias_command 'f', 'finish'
#  Pry.commands.alias_command 'ss', 'show-stack'
#  Pry.commands.alias_command 'gf', 'frame'
#end
Pry.config.commands.alias_command "@", "whereami"
