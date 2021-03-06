# -------------------------------------------------------------------
# {{project}} Settings
# -------------------------------------------------------------------
#
#{{author_line}}{{organization_line}}
#   Version : 1.0

# Basic Informations
version: '{{project}} 0.1.0'
description: 'Description of the program.'
usage: 'How to deal with your program'
arguments:
- [ ['-t', '--test'], {'help' : 'Test', 'type' : 'int'} ]
- [ ['positionnal'], {'choices' : ['test']}]

# Logger Settings
logger:
    strings: 'config/strings.yml'
    flavor: 'default'
    title_default: 'default'
    # Delete the path line not to write the log to a file
    path: 'logs'
    threshold: ['DEBUG', 'ERROR', 'INFO', 'WARNING', 'VERBOSE']

# Generic Settings
settings:
    hello: 'world'
    bonjour: 'test'