# fish_prompt and fish_right_prompt
source ~/.config/fish/prompt.fish

# source functions
source ~/.config/fish/functions.fish

#abbrs
source ~/.config/fish/abbr.fish

#path
set PATH $HOME/miniconda2/bin $PATH

# conda fish helper
if command --search conda
  source (conda info --root)/etc/fish/conf.d/conda.fish
end

# add local extras, if they exist
if test -f ~/.extra.fish
  source ~/.extra.fish
end
