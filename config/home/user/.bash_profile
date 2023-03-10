# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

unset USERNAME

echo ""
echo "Login succesfull."
echo ""
echo "Initializing SSH Agent"
eval `ssh-agent -s`
ssh-add /home/$USER/.ssh/*.key
