#abbrs
source ~/.config/fish/abbr.fish

#path
set PATH $HOME/miniconda2/bin $PATH

# conda fish helper
if command --search conda > /dev/null
  source (conda info --root)/etc/fish/conf.d/conda.fish
end

# add local extras, if they exist
if test -f ~/.extra.fish
  source ~/.extra.fish
end

# check if ssh key is added, if not; add it.
if not ssh-add -l
  ssh-add ~/.ssh/id_rsa
end

