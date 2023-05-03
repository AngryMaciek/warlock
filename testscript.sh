###############################################################################
#
#   Installation test: simple warlock run
#
#   AUTHOR: Maciej_Bak
#   CONTACT: wsciekly.maciek@gmail.com
#
###############################################################################

# render the config file
python -c "
import os
from jinja2 import Template
with open('tests/localtest/config-template.yml', 'r') as f:
    template = Template(f.read())
text = template.render(WORKFLOW_REPO_PATH=os.getcwd())
with open('tests/localtest/config.yml', 'w') as f:
    f.write(text)
"
# run the pipeline
bash warlock.sh -c tests/localtest/config.yml -e local -n 1
# clean up the output
rm -rf tests/localtest/output
