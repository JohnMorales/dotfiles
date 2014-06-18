if defined?(PryDebugger)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'ss', 'show-stack'
  Pry.commands.alias_command 'gf', 'frame'
end
Pry.config.commands.alias_command "@", "whereami"
